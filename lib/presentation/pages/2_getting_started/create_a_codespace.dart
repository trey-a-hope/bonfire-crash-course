import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_modal_service.dart';
import 'package:bonfire_crash_course/presentation/widgets/sheet_views/_sheet_views.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateACodespace extends StatelessWidget {
  const CreateACodespace({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Create a Codespace',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        AdaptiveButton(
          type: .filled,
          child: const Text('Open in Github Codespaces'),
          onPressed: () async {
            final uri = Uri.parse(CODE_SPACES_TEMPLATE_URL);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              if (!context.mounted) return;
              AdaptiveModalService.showSheet(context, SheetType.settings);
            }
          },
        ),
      ],
    );
  }
}
