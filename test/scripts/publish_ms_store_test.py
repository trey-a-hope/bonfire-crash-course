#!/usr/bin/env python3
"""Runs scripts/publish_ms_store.py against a local fake of Azure AD and the
Microsoft Store submission API.

    python3 test/scripts/publish_ms_store_test.py
"""

import io
import json
import os
import subprocess
import sys
import tempfile
import threading
import unittest
import zipfile
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SCRIPT = os.path.join(ROOT, "scripts", "publish_ms_store.py")
SECRET = "s3cret-value"
APP = "9TESTAPP000"


class Fake:
    def __init__(self, statuses, pending=False, bad_secret=False):
        self.statuses = list(statuses)  # returned by /status, last one repeats
        self.pending = pending
        self.bad_secret = bad_secret
        self.updated = None
        self.uploaded = None
        self.committed = False
        self.deleted = []


def make_handler(fake, port):
    class H(BaseHTTPRequestHandler):
        def log_message(self, *a):
            pass

        def send(self, code, body=None):
            data = json.dumps(body).encode() if body is not None else b""
            self.send_response(code)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(data)))
            self.end_headers()
            self.wfile.write(data)

        def body(self):
            n = int(self.headers.get("Content-Length") or 0)
            return self.rfile.read(n)

        def authed(self):
            return self.headers.get("Authorization") == "Bearer tok"

        def do_POST(self):
            raw = self.body()
            if self.path.endswith("/oauth2/token"):
                if fake.bad_secret or f"client_secret={SECRET}" not in raw.decode():
                    return self.send(401, {"error": "invalid_client", "error_description": "bad secret"})
                return self.send(200, {"access_token": "tok"})
            if not self.authed():
                return self.send(401, {"code": "Unauthorized"})
            if self.path == f"/v1.0/my/applications/{APP}/submissions":
                return self.send(201, {
                    "id": "111",
                    "applicationPackages": [{"fileName": "old.msix", "fileStatus": "Uploaded", "id": "9"}],
                    "listings": {"en-us": {"baseListing": {"releaseNotes": "old notes"}}},
                    "fileUploadUrl": f"http://127.0.0.1:{port}/blob?sig=TOPSECRET",
                })
            if self.path.endswith("/submissions/111/commit"):
                fake.committed = True
                return self.send(202, {"status": "CommitStarted"})
            self.send(404, {"code": "NotFound"})

        def do_PUT(self):
            raw = self.body()
            if self.path.startswith("/blob"):
                assert self.headers.get("x-ms-blob-type") == "BlockBlob"
                fake.uploaded = raw
                return self.send(201)
            if not self.authed():
                return self.send(401)
            if self.path.endswith("/submissions/111"):
                fake.updated = json.loads(raw)
                return self.send(200, fake.updated)
            self.send(404)

        def do_GET(self):
            if not self.authed():
                return self.send(401)
            if self.path == f"/v1.0/my/applications/{APP}":
                app = {"id": APP}
                if fake.pending:
                    app["pendingApplicationSubmission"] = {"id": "222"}
                return self.send(200, app)
            if self.path.endswith("/submissions/222/status"):
                return self.send(200, {"status": "Certification"})
            if self.path.endswith("/submissions/111/status"):
                s = fake.statuses.pop(0) if len(fake.statuses) > 1 else fake.statuses[0]
                body = {"status": s, "statusDetails": {"errors": [], "warnings": []}}
                if s == "CommitFailed":
                    body["statusDetails"]["errors"] = [{"code": "InvalidPackage", "details": "bad identity"}]
                return self.send(200, body)
            self.send(404, {"code": "NotFound"})

        def do_DELETE(self):
            fake.deleted.append(self.path)
            self.send(204)

    return H


class PublishTest(unittest.TestCase):
    def run_script(self, fake, extra_env=None, drop=()):
        server = ThreadingHTTPServer(("127.0.0.1", 0), None)
        port = server.server_address[1]
        server.RequestHandlerClass = make_handler(fake, port)
        threading.Thread(target=server.serve_forever, daemon=True).start()
        self.addCleanup(server.server_close)
        self.addCleanup(server.shutdown)

        work = tempfile.mkdtemp()
        os.makedirs(os.path.join(work, "build", "windows", "x64", "runner", "Release"))
        with open(os.path.join(work, "build", "windows", "x64", "runner", "Release", "app.msix"), "wb") as f:
            f.write(b"MSIX-BYTES")
        with open(os.path.join(work, "release_notes.txt"), "w") as f:
            f.write("App 1.2.3\n\nWhat's new\n- A thing.\n")

        base = f"http://127.0.0.1:{port}"
        env = dict(os.environ, NO_PROXY="127.0.0.1", no_proxy="127.0.0.1",
                   MS_STORE_API_URL=base, MS_STORE_LOGIN_URL=base,
                   MS_STORE_TENANT_ID="tenant", MS_STORE_CLIENT_ID="client",
                   MS_STORE_CLIENT_SECRET=SECRET, MS_STORE_APP_ID=APP,
                   MS_STORE_POLL_SECONDS="0", MS_STORE_COMMIT_WAIT="1")
        env.update(extra_env or {})
        for k in drop:
            env.pop(k, None)
        p = subprocess.run([sys.executable, SCRIPT], cwd=work, env=env,
                           capture_output=True, text=True, timeout=60)
        out = p.stdout + p.stderr
        self.assertNotIn(SECRET, out)
        self.assertNotIn("TOPSECRET", out)
        return p.returncode, out

    def test_accepted_after_commit(self):
        fake = Fake(["CommitStarted", "CommitStarted", "PreProcessing"])
        code, out = self.run_script(fake, {"MS_STORE_COMMIT_WAIT": "30"})
        self.assertEqual(code, 0, out)
        self.assertIn("accepted by the Store (status PreProcessing)", out)
        self.assertTrue(fake.committed)
        pkgs = fake.updated["applicationPackages"]
        self.assertEqual(pkgs[0]["fileStatus"], "PendingDelete")
        self.assertEqual(pkgs[1], {"fileName": "app.msix", "fileStatus": "PendingUpload"})
        self.assertTrue(fake.updated["listings"]["en-us"]["baseListing"]["releaseNotes"].startswith("App 1.2.3"))
        with zipfile.ZipFile(io.BytesIO(fake.uploaded)) as z:
            self.assertEqual(z.read("app.msix"), b"MSIX-BYTES")
        self.assertEqual(fake.deleted, [])

    def test_certification_counts_as_accepted(self):
        code, out = self.run_script(Fake(["Certification"]))
        self.assertEqual(code, 0, out)

    def test_slow_store_does_not_fail_build(self):
        fake = Fake(["CommitStarted"])
        code, out = self.run_script(fake)
        self.assertEqual(code, 0, out)
        self.assertIn("WARNING: the Store is still processing the commit", out)

    def test_commit_failed_fails_build(self):
        code, out = self.run_script(Fake(["CommitFailed"]))
        self.assertEqual(code, 1, out)
        self.assertIn("InvalidPackage", out)
        self.assertIn("CommitFailed", out)

    def test_pending_submission_fails_clearly(self):
        fake = Fake(["PreProcessing"], pending=True)
        code, out = self.run_script(fake)
        self.assertEqual(code, 1, out)
        self.assertIn("already in progress", out)
        self.assertIn("status Certification", out)
        self.assertFalse(fake.committed)

    def test_bad_secret(self):
        code, out = self.run_script(Fake(["PreProcessing"], bad_secret=True))
        self.assertEqual(code, 1, out)
        self.assertIn("Azure AD refused the credentials", out)

    def test_missing_setting(self):
        code, out = self.run_script(Fake(["PreProcessing"]), drop=["MS_STORE_APP_ID"])
        self.assertEqual(code, 1, out)
        self.assertIn("MS_STORE_APP_ID is not set", out)


if __name__ == "__main__":
    unittest.main(verbosity=2)
