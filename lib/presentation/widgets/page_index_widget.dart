import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/controllers/page_index_controller.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:flutter/material.dart';

/// A navigation bar widget providing "Previous" and "Next" action buttons.
///
/// Dispatches navigation events directly to [PageIndexController] to advance
/// or backtrack through pages.
class PageIndexWidget extends StatelessWidget {
  const PageIndexWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous page button
        AdaptiveButton(
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chevron_left),
              GapSizes.xsGap,
              Text('Previous'),
            ],
          ),
          onPressed: () => PageIndexController.decrement(),
        ),
        const Spacer(),
        // Next page button
        AdaptiveButton(
          type: AdaptiveButtonType.filled,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.chevron_right), GapSizes.xsGap, Text('Next')],
          ),
          onPressed: () => PageIndexController.increment(),
        ),
      ],
    );
  }
}
