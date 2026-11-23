# Builds a single-file Windows installer for installing on a few devices (no certificate needed).
# Requires Inno Setup 6 (https://jrsoftware.org/isdl.php).
# On the target device: run the setup exe. Windows SmartScreen may warn once:
# More info -> Run anyway.
# Output: build\bonfire_crash_course_setup_<version>.exe
Set-Location (Split-Path $PSScriptRoot -Parent)
flutter build windows --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$iscc = @(
  "$env:ProgramFiles\Inno Setup 6\ISCC.exe",
  "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
  "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $iscc) { Write-Error "Inno Setup 6 not found. Install it from https://jrsoftware.org/isdl.php"; exit 1 }

$version = ((Select-String -Path pubspec.yaml -Pattern '^version:\s*(\S+)').Matches[0].Groups[1].Value -split '\+')[0]
& $iscc "/DAppVersion=$version" installer\bonfire_crash_course.iss
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "Created build\bonfire_crash_course_setup_$version.exe"
