import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
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
          'Getting Started',
          style: textTheme.headlineSmall!.copyWith(color: Colors.white),
        ),
        GapSizes.smallGap,
        Text(
          'Open the Code Spaces enviroment. This is where users will be coding along to the project.',
          style: textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
        GapSizes.smallGap,
        AdaptiveButton(
          child: Text(
            'Open',
            style: textTheme.labelLarge!.copyWith(color: Colors.white),
          ),
          onPressed: () => launchUrl(Uri.parse(CODE_SPACES_URL)),
        ),
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
