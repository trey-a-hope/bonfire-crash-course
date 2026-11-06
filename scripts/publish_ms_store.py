#!/usr/bin/env python3
"""Publishes the Windows MSIX to the Microsoft Store from a Codemagic build.

Run as the Post-build script of the Codemagic "Windows (Prod)" workflow,
with Codemagic's own Microsoft Store publishing turned off:

    python scripts/publish_ms_store.py

Why not Codemagic's built-in publishing: after committing the submission it
waits for the Store to *start certification*, and fails the build if that
takes more than a few minutes, even though the submission went through and
carries on in Partner Center. This script stops waiting as soon as the
Store has accepted the commit. Only real errors fail the build.

What it does:
  1. Finds the .msix Codemagic packaged under build/ (or packages one with
     `dart run msix:create` if there isn't one).
  2. Gets a token for the Microsoft Store submission API with the Azure AD
     app linked to Partner Center.
  3. Creates a new submission (a copy of the last published one), replaces
     its packages with the new .msix and sets the release notes of every
     listing to release_notes.txt.
  4. Uploads the package, commits the submission, and waits only until the
     Store has processed the commit (status leaves CommitStarted).

Exit codes: 0 when the submission was committed. If the Store is still
processing the commit when MS_STORE_COMMIT_WAIT runs out, the script prints
a WARNING and still exits 0, because the submission is in and Partner Center
emails about any later problem. 1 for a real error: missing settings, a
submission already in progress, a rejected package or a failed commit.

Environment:
  MS_STORE_TENANT_ID      Azure AD tenant ID (required)
  MS_STORE_CLIENT_ID      Azure AD application (client) ID (required)
  MS_STORE_CLIENT_SECRET  Azure AD client secret (required, secure)
  MS_STORE_APP_ID         Store ID of the app (required), e.g. 9PG9KP1X3JH6
  MS_STORE_MSIX           path to the .msix (default: newest under build/)
  MS_STORE_PACKAGE_VERSION  version for msix:create when no .msix exists
                          (default 1.0.$BUILD_NUMBER.0)
  MS_STORE_RELEASE_NOTES  release notes file (default release_notes.txt)
  MS_STORE_COMMIT_WAIT    seconds to wait for the commit (default 600)
  MS_STORE_POLL_SECONDS   seconds between status checks (default 15)
  MS_STORE_API_URL        default https://manage.devcenter.microsoft.com
  MS_STORE_LOGIN_URL      default https://login.microsoftonline.com
                          (tests point both at a local fake)
"""

import glob
import io
import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import zipfile

API = os.environ.get("MS_STORE_API_URL", "https://manage.devcenter.microsoft.com").rstrip("/")
LOGIN = os.environ.get("MS_STORE_LOGIN_URL", "https://login.microsoftonline.com").rstrip("/")
RESOURCE = "https://manage.devcenter.microsoft.com"
NOTES_LIMIT = 1500  # the Store's limit for release notes

# Statuses after a successful commit. The Store moves on through these by
# itself; none of them needs anything from the build.
ACCEPTED = {
    "PreProcessing", "Certification", "Release", "PendingPublication",
    "Publishing", "Published",
}
FAILED = {
    "CommitFailed", "PreProcessingFailed", "CertificationFailed",
    "ReleaseFailed", "PublishFailed", "Canceled",
}


class StoreError(Exception):
    pass


def log(msg):
    print(f"[ms-store] {msg}", flush=True)


def env(name, default=None, required=False):
    value = os.environ.get(name, "").strip()
    if not value:
        if required:
            raise StoreError(
                f"{name} is not set. Add it to the workflow's environment "
                "variables (see the Microsoft Store section of the README)."
            )
        return default
    return value


def request(method, url, token=None, body=None, headers=None, form=None, raw=None, tries=3):
    hdrs = dict(headers or {})
    data = None
    if token:
        hdrs["Authorization"] = f"Bearer {token}"
    if body is not None:
        data = json.dumps(body).encode()
        hdrs["Content-Type"] = "application/json"
    elif form is not None:
        data = urllib.parse.urlencode(form).encode()
        hdrs["Content-Type"] = "application/x-www-form-urlencoded"
    elif raw is not None:
        data = raw
    if data is None and method in ("POST", "PUT"):
        data = b""
    for attempt in range(1, tries + 1):
        req = urllib.request.Request(url, data=data, method=method, headers=hdrs)
        try:
            with urllib.request.urlopen(req, timeout=300) as resp:
                text = resp.read().decode() or "null"
                try:
                    return resp.status, json.loads(text)
                except ValueError:
                    return resp.status, text
        except urllib.error.HTTPError as e:
            text = e.read().decode(errors="replace")
            if (e.code >= 500 or e.code == 429) and attempt < tries:
                log(f"{method} {short(url)} returned HTTP {e.code}, retrying")
                time.sleep(2 * attempt)
                continue
            try:
                return e.code, json.loads(text)
            except ValueError:
                return e.code, text
        except urllib.error.URLError as e:
            if attempt < tries:
                log(f"{method} {short(url)} failed ({e.reason}), retrying")
                time.sleep(2 * attempt)
                continue
            raise StoreError(f"could not reach {short(url)}: {e.reason}")


def short(url):
    # Never print the upload URL's signature.
    return url.split("?", 1)[0]


def describe(body):
    if isinstance(body, dict):
        code = body.get("code") or body.get("error")
        msg = body.get("message") or body.get("error_description")
        if code or msg:
            return f"{code}: {msg}" if code and msg else str(code or msg)
    return str(body)[:500]


def get_token(tenant, client_id, secret):
    status, body = request(
        "POST", f"{LOGIN}/{urllib.parse.quote(tenant)}/oauth2/token",
        form={
            "grant_type": "client_credentials",
            "client_id": client_id,
            "client_secret": secret,
            "resource": RESOURCE,
        },
    )
    if status != 200 or not isinstance(body, dict) or "access_token" not in body:
        raise StoreError(
            f"Azure AD refused the credentials (HTTP {status}, {describe(body)}). "
            "Check MS_STORE_TENANT_ID, MS_STORE_CLIENT_ID and MS_STORE_CLIENT_SECRET; "
            "client secrets expire, so you may need a new one."
        )
    return body["access_token"]


def find_msix():
    path = env("MS_STORE_MSIX")
    if path:
        if not os.path.isfile(path):
            raise StoreError(f"MS_STORE_MSIX points at {path}, which doesn't exist.")
        return path
    found = sorted(glob.glob("build/**/*.msix", recursive=True), key=os.path.getmtime)
    if found:
        return found[-1]
    version = env("MS_STORE_PACKAGE_VERSION", f"1.0.{env('BUILD_NUMBER', '0')}.0")
    log(f"no .msix under build/, packaging one with msix:create (version {version})")
    cmd = f"dart run msix:create --store --version {version}"
    if subprocess.call(cmd, shell=True) != 0:
        raise StoreError(f"`{cmd}` failed; see the output above.")
    found = sorted(glob.glob("build/**/*.msix", recursive=True), key=os.path.getmtime)
    if not found:
        raise StoreError("msix:create finished but no .msix was found under build/.")
    return found[-1]


def read_notes():
    path = env("MS_STORE_RELEASE_NOTES", "release_notes.txt")
    try:
        with open(path, encoding="utf-8") as f:
            text = f.read().strip()
    except OSError:
        log(f"WARNING: {path} not found, keeping the release notes from the last submission")
        return None
    if not text:
        log(f"WARNING: {path} is empty, keeping the release notes from the last submission")
        return None
    if len(text) > NOTES_LIMIT:
        log(f"WARNING: {path} is over {NOTES_LIMIT} characters, cutting it to fit")
        text = text[:NOTES_LIMIT]
    return text


def check_no_pending(app_url, token):
    status, app = request("GET", app_url, token)
    if status == 404:
        raise StoreError(
            "the Store has no app with that ID. Check MS_STORE_APP_ID against "
            "Partner Center > Apps and games > the app > Product identity > Store ID."
        )
    if status != 200:
        raise StoreError(f"could not read the app (HTTP {status}, {describe(app)}).")
    pending = (app or {}).get("pendingApplicationSubmission")
    if pending:
        status, sub = request("GET", f"{app_url}/submissions/{pending['id']}/status", token)
        state = sub.get("status") if isinstance(sub, dict) else "unknown"
        raise StoreError(
            f"submission {pending['id']} is already in progress in Partner Center "
            f"(status {state}). The Store allows one at a time: wait until it is "
            "published, or open it in Partner Center and delete or cancel it, then "
            "rebuild."
        )


def zip_package(msix):
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as z:
        z.write(msix, os.path.basename(msix))
    return buf.getvalue()


def main():
    tenant = env("MS_STORE_TENANT_ID", required=True)
    client_id = env("MS_STORE_CLIENT_ID", required=True)
    secret = env("MS_STORE_CLIENT_SECRET", required=True)
    app_id = env("MS_STORE_APP_ID", required=True)
    wait = int(env("MS_STORE_COMMIT_WAIT", "600"))
    poll = int(env("MS_STORE_POLL_SECONDS", "15"))

    msix = find_msix()
    log(f"package: {msix} ({os.path.getsize(msix) // 1024} KB)")
    notes = read_notes()

    token = get_token(tenant, client_id, secret)
    app_url = f"{API}/v1.0/my/applications/{urllib.parse.quote(app_id)}"
    check_no_pending(app_url, token)

    status, sub = request("POST", f"{app_url}/submissions", token)
    if status not in (200, 201) or not isinstance(sub, dict) or "id" not in sub:
        raise StoreError(f"could not create a submission (HTTP {status}, {describe(sub)}).")
    sub_id = sub["id"]
    sub_url = f"{app_url}/submissions/{sub_id}"
    log(f"created submission {sub_id}")

    try:
        name = os.path.basename(msix)
        packages = sub.get("applicationPackages") or []
        for p in packages:
            p["fileStatus"] = "PendingDelete"
        packages.append({"fileName": name, "fileStatus": "PendingUpload"})
        sub["applicationPackages"] = packages
        if notes is not None:
            for listing in (sub.get("listings") or {}).values():
                listing.setdefault("baseListing", {})["releaseNotes"] = notes
            log(f"release notes set for {len(sub.get('listings') or {})} listing(s)")

        upload_url = sub.get("fileUploadUrl")
        if not upload_url:
            raise StoreError("the new submission has no upload URL.")
        status, body = request("PUT", sub_url, token, body=sub)
        if status != 200:
            raise StoreError(f"the Store rejected the submission update (HTTP {status}, {describe(body)}).")

        status, body = request(
            "PUT", upload_url, raw=zip_package(msix),
            headers={"x-ms-blob-type": "BlockBlob", "x-ms-version": "2019-12-12"},
        )
        if status not in (200, 201):
            raise StoreError(f"uploading the package failed (HTTP {status}, {describe(body)}).")
        log("package uploaded")

        status, body = request("POST", f"{sub_url}/commit", token)
        if status not in (200, 202):
            raise StoreError(f"the Store refused the commit (HTTP {status}, {describe(body)}).")
    except Exception:
        # Not committed yet: remove the draft so the next build can submit.
        request("DELETE", sub_url, token)
        log(f"deleted draft submission {sub_id}")
        raise

    log("submission committed, waiting for the Store to accept it")
    deadline = time.monotonic() + wait
    state = "CommitStarted"
    while True:
        status, body = request("GET", f"{sub_url}/status", token)
        if status == 200 and isinstance(body, dict):
            state = body.get("status", state)
            if state in ACCEPTED:
                log(f"accepted by the Store (status {state}). Certification carries on "
                    "in Partner Center; it can take up to 3 business days.")
                return 0
            if state in FAILED:
                details = body.get("statusDetails") or {}
                for kind in ("errors", "warnings", "certificationReports"):
                    for item in details.get(kind) or []:
                        log(f"{kind[:-1]}: {json.dumps(item)}")
                raise StoreError(f"the Store reports submission {sub_id} as {state}; see above.")
        else:
            log(f"status check returned HTTP {status}, trying again")
        if time.monotonic() >= deadline:
            log(f"WARNING: the Store is still processing the commit (status {state}) after "
                f"{wait} s. The submission is in; check it in Partner Center. Not failing the build.")
            return 0
        time.sleep(poll)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except StoreError as e:
        log(f"ERROR: {e}")
        sys.exit(1)
