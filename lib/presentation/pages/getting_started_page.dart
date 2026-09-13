import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/page_index_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;

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
          'What is Flutter?',
          style: textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
        const Expanded(child: Placeholder()),
        GapSizes.smallGap,
        Text(
          'What is Bonfire?',
          style: textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
        const Expanded(child: Placeholder()),
        GapSizes.smallGap,
        Text(
          "What you'll be building today!",
          style: textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
        const Expanded(child: Placeholder()),
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
