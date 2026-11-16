part of 'getting_started_rive.dart';

/// The bundled Rive animations: one hero per Getting Started lesson, plus
/// the trophy at the top of every module completion page, and the cloud
/// setup scene on "What You Will Need".
enum GettingStartedScene {
  /// A developer profile card fills in and gets a green check.
  githubAccount(
    fileName: 'gs_github_account',
    artboardName: 'GithubAccount',
    semanticLabel: 'A new GitHub profile card fills in and gets a green check',
    fallbackIcon: Icons.person_add_alt_1_rounded,
  ),

  /// A cloud beams a ready-to-code editor window down.
  codespace(
    fileName: 'gs_codespace',
    artboardName: 'Codespace',
    semanticLabel: 'A cloud beams a ready-to-code editor down to you',
    fallbackIcon: Icons.cloud_download_rounded,
  ),

  /// A folder opens and its files hop out one after another.
  fileStructure(
    fileName: 'gs_file_structure',
    artboardName: 'FileStructure',
    semanticLabel: 'A folder opens and its files hop out',
    fallbackIcon: Icons.folder_open_rounded,
  ),

  /// A play button is pressed and a little hero hops by a campfire.
  runGame(
    fileName: 'gs_run_game',
    artboardName: 'RunGame',
    semanticLabel: 'Play is pressed and a little hero hops by a campfire',
    fallbackIcon: Icons.sports_esports_rounded,
  ),

  /// A gold trophy shines in a burst of rays while confetti falls.
  moduleComplete(
    fileName: 'module_complete',
    artboardName: 'ModuleComplete',
    semanticLabel: 'A gold trophy shines as confetti falls',
    fallbackIcon: Icons.emoji_events_rounded,
    fallbackColor: Colors.amberAccent,
  ),

  /// A cloud drops GitHub, a web browser and Wi-Fi (the three things a
  /// student needs) onto a laptop, which gets a green check. Shown on
  /// "What You Will Need".
  zeroSetup(
    fileName: 'zero_setup',
    artboardName: 'ZeroSetup',
    semanticLabel:
        'A cloud drops GitHub, a web browser and Wi-Fi onto a laptop',
    fallbackIcon: Icons.cloud_done_rounded,
    fallbackColor: Colors.cyanAccent,
  );

  const GettingStartedScene({
    required this.fileName,
    required this.artboardName,
    required this.semanticLabel,
    required this.fallbackIcon,
    this.fallbackColor = Colors.lightGreenAccent,
  });

  /// The file's name in `assets/rive/`, without `.riv`.
  final String fileName;

  /// The artboard inside the file.
  final String artboardName;

  /// What the animation shows, for screen readers.
  final String semanticLabel;

  /// Shown instead of the animation if the file can't be loaded.
  final IconData fallbackIcon;

  /// The colour of [fallbackIcon].
  final Color fallbackColor;

  /// Path of the bundled Rive file.
  String get assetPath => 'assets/rive/$fileName.riv';
}
