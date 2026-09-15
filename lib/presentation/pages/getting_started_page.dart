import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_modal_service.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_index_widget.dart';
import 'package:bonfire_crash_course/presentation/widgets/sheet_views/_sheet_views.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:url_launcher/url_launcher.dart';

class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Setup Github",
          style: textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
        GapSizes.smallGap,
        AdaptiveButton(
          type: .filled,
          child: const Text('Open in Github Codespaces'),
          onPressed: () async {
            final uri = Uri.parse(CODE_SPACES_TEMPLATE_URL);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              if (!context.mounted) return;
              // TODO (Trey) - Use an alert dialog instead of a sheet.
              AdaptiveModalService.showSheet(context, SheetType.settings);
            }
          },
        ),
        GapSizes.smallGap,

        const PageIndexWidget(),
      ],
    );
  }
}

/*
  display - Hero text, splash screens, massive numbers, or promotional banner headlines.
  headline - High-emphasis headers marking major sections or screen-level views.
  title - Medium-emphasis text such as app bar titles, card headers, list tiles, and dialog titles.
  body - Longer-form passages of reading text, paragraphs, descriptions, and default form fields.
  label - Actionable text, button labels, tabs, floating chips, and caption badges.
*/
