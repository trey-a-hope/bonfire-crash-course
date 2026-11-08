part of 'install_vscode.dart';

/// The VS Code install instructions for one kind of computer.
class VSCodeInstall {
  const VSCodeInstall({
    required this.steps,
    required this.buttonTitle,
    required this.url,
    required this.icon,
  });

  final List<String> steps;
  final String buttonTitle;
  final String url;
  final IconData icon;

  static const macOS = VSCodeInstall(
    steps: [
      'Download VS Code for macOS',
      'Continue with the installation process',
      'Add the Flutter and Dart extensions within VS Code',
    ],
    buttonTitle: 'Download for macOS',
    url: VSCODE_DOWNLOAD_PAGE,
    icon: Icons.apple,
  );

  static const windows = VSCodeInstall(
    steps: [
      'Download and run the installer',
      'Tick Add to PATH',
      'Add the Flutter and Dart extensions',
    ],
    buttonTitle: 'Download for Windows',
    url: VSCODE_DOWNLOAD_PAGE,
    icon: Icons.desktop_windows_rounded,
  );

  /// Any other platform (Linux, etc.): send the student to the download page
  /// to pick their own installer, so nobody gets the wrong one.
  static const other = VSCodeInstall(
    steps: [
      'Pick the download for your system',
      'Install it like any other app',
      'Add the Flutter and Dart extensions',
    ],
    buttonTitle: 'Download VS Code',
    url: VSCODE_DOWNLOAD_PAGE,
    icon: Icons.download_rounded,
  );

  /// The instructions for [platform].
  static VSCodeInstall forPlatform(TargetPlatform platform) =>
      switch (platform) {
        TargetPlatform.macOS => macOS,
        TargetPlatform.windows => windows,
        _ => other,
      };
}
