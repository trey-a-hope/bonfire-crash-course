import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_list_tile.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_modal_service.dart';
import 'package:bonfire_crash_course/presentation/widgets/sheet_views/_sheet_views.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Card;
import 'package:flutter/material.dart' hide Colors;
import 'package:url_launcher/url_launcher.dart';

class InstallVSCode extends StatelessWidget {
  const InstallVSCode({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Install VSCode (Optional)',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        GapSizes.mediumGap,
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/screenshots/2/run_app.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      GapSizes.largeGap,

                      Text(
                        'What is VSCode?',
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Visual Studio Code (VS Code) is a free, lightweight code editor developed by Microsoft that includes built-in debugging, an integrated terminal, Git version control, and thousands of customizable extensions.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GapSizes.largeGap,
                      Text(
                        'Why is this step optional?',
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GapSizes.xsGap,
                      Text(
                        'Installing VS Code locally is not required to complete this course. If you prefer not to install software on your machine, you can work entirely in your browser using cloud environments like GitHub Codespaces or JupyterLab, which provide ready-to-use development setups with zero local configuration.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GapSizes.mediumGap,

                      PlatformResolver.isMacOS
                          ? const MacosInstallationVSCodeCard()
                          : const WindowsInstallationVSCodeCard(),
                    ],
                  ),
                ),
              ),

              GapSizes.largeGap,
              const Expanded(child: Placeholder()),
            ],
          ),
        ),
      ],
    );
  }
}

class MacosInstallationVSCodeCard extends StatelessWidget {
  const MacosInstallationVSCodeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: Colors.magenta,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: .start,
          children: [
            Text(
              'macOS Installation Steps',
              style: textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),

            GapSizes.mediumGap,
            const AdaptiveListTile(
              icon: Icons.lightbulb,
              title: 'Step 1',
              subtitle:
                  'Click Download for macOS above to download the universal .zip archive.',
            ),
            GapSizes.smallGap,
            const AdaptiveListTile(
              icon: Icons.lightbulb,
              title: 'Step 2',
              subtitle:
                  'Locate the downloaded file (usually in your Downloads folder) and double-click it to extract Visual Studio Code.app (if Safari hasn\'t already extracted it automatically).',
            ),
            GapSizes.smallGap,
            const AdaptiveListTile(
              icon: Icons.lightbulb,
              title: 'Step 3',
              subtitle:
                  'Drag Visual Studio Code.app into your Applications folder so it is accessible from Launchpad and Spotlight.',
            ),
            GapSizes.smallGap,
            const AdaptiveListTile(
              icon: Icons.lightbulb,
              title: 'Step 4',
              subtitle:
                  'Open VS Code from your Applications folder. If prompted by macOS with a security dialog, click Open.',
            ),
            GapSizes.largeGap,
            Row(
              mainAxisAlignment: .center,
              children: [
                AdaptiveButton(
                  type: .filled,
                  child: const Row(
                    mainAxisSize: .min,
                    children: [
                      Icon(
                        FluentIcons.visual_studio_for_windows,
                        color: Colors.white,
                      ),
                      GapSizes.smallGap,
                      Text(
                        'Download for MacOS',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    final uri = Uri.parse(VSCODE_DOWNLOAD_MACOS);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      if (!context.mounted) return;
                      AdaptiveModalService.showSheet(
                        context,
                        SheetType.settings,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WindowsInstallationVSCodeCard extends StatelessWidget {
  const WindowsInstallationVSCodeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: .start,
          children: [
            Text(
              'Windows Installation Steps',
              style: textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),

            GapSizes.mediumGap,
            const AdaptiveListTile(
              icon: Icons.lightbulb,
              title: 'Step 1',
              subtitle:
                  'Click Download for Windows above to download the .exe user installer.',
            ),
            GapSizes.xsGap,
            const AdaptiveListTile(
              icon: Icons.lightbulb,
              title: 'Step 2',
              subtitle:
                  'Locate the downloaded setup file (usually in your Downloads folder) and double-click it to run the installer.',
            ),
            GapSizes.xsGap,
            const AdaptiveListTile(
              icon: Icons.lightbulb,
              title: 'Step 3',
              subtitle:
                  'Accept the license agreement, choose your destination folder, and on the Select Additional Tasks screen, check "Add to PATH" (and optionally check both "Add \'Open with Code\' action" boxes).',
            ),
            GapSizes.xsGap,
            const AdaptiveListTile(
              icon: Icons.lightbulb,
              title: 'Step 4',
              subtitle:
                  'Click Install, then click Finish once complete to launch Visual Studio Code.',
            ),
            GapSizes.mediumGap,
            Row(
              mainAxisAlignment: .center,
              children: [
                AdaptiveButton(
                  type: .filled,
                  child: const Row(
                    mainAxisSize: .min,
                    children: [
                      Icon(
                        FluentIcons.visual_studio_for_windows,
                        color: Colors.white,
                      ),
                      GapSizes.smallGap,
                      Text(
                        'Download for Windows',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    final uri = Uri.parse(VSCODE_DOWNLOAD_WINDOWS);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      if (!context.mounted) return;
                      AdaptiveModalService.showSheet(
                        context,
                        SheetType.settings,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
