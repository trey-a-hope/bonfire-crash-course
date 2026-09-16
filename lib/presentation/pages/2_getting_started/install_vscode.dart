import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_modal_service.dart';
import 'package:bonfire_crash_course/presentation/widgets/sheet_views/_sheet_views.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:url_launcher/url_launcher.dart';

class InstallVSCode extends StatelessWidget {
  final String _windowsDownload =
      'https://code.visualstudio.com/sha/download?build=stable&os=win32-arm64-user';
  final String _macosDownload =
      'https://code.visualstudio.com/sha/download?build=stable&os=darwin-arm64-dmg';

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

        Row(
          children: [
            AdaptiveButton(
              type: .filled,
              child: const Row(
                children: [
                  Icon(FluentIcons.visual_studio_for_windows),
                  GapSizes.smallGap,
                  Text('Download for Windows'),
                ],
              ),
              onPressed: () async {
                final uri = Uri.parse(_windowsDownload);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (!context.mounted) return;
                  AdaptiveModalService.showSheet(context, SheetType.settings);
                }
              },
            ),
            GapSizes.smallGap,
            AdaptiveButton(
              type: .filled,
              child: const Row(
                children: [
                  Icon(FluentIcons.visual_studio_for_windows),
                  GapSizes.smallGap,
                  Text('Download for MacOS'),
                ],
              ),
              onPressed: () async {
                final uri = Uri.parse(_macosDownload);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (!context.mounted) return;
                  AdaptiveModalService.showSheet(context, SheetType.settings);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
