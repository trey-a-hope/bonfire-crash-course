; Inno Setup script. Built by scripts/build_local_exe.ps1, which passes /DAppVersion=<x.y.z>.
#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif

[Setup]
AppId={{6F1B8E52-3C0A-4D7B-9E21-5A8C4B7D1F36}
AppName=Bonfire Crash Course
AppVersion={#AppVersion}
AppPublisher=treycodes
DefaultDirName={autopf}\Bonfire Crash Course
DefaultGroupName=Bonfire Crash Course
; Per-user install by default, so no admin rights are needed.
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=..\build
OutputBaseFilename=bonfire_crash_course_setup_{#AppVersion}
SetupIconFile=..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\bonfire_crash_course.exe
Compression=lzma2
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
WizardStyle=modern

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Bonfire Crash Course"; Filename: "{app}\bonfire_crash_course.exe"
Name: "{autodesktop}\Bonfire Crash Course"; Filename: "{app}\bonfire_crash_course.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional shortcuts:"

[Run]
Filename: "{app}\bonfire_crash_course.exe"; Description: "Launch Bonfire Crash Course"; Flags: nowait postinstall skipifsilent
