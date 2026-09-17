import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A navigation bar widget providing "Previous" and "Next" action buttons.
///
/// Dispatches navigation events directly to [PageIndexController] to advance
/// or backtrack through pages.
class PageIndexWidget extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const PageIndexWidget({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous page button
        AdaptiveButton(
          onPressed: navigationShell.currentIndex == 0
              ? null
              : () => ProgressNavigationController.decrement(navigationShell),
          child: const Row(
            mainAxisAlignment: .center,
            children: [
              Icon(Icons.chevron_left),
              GapSizes.xsGap,
              Text('Previous'),
              GapSizes.smallGap,
            ],
          ),
        ),
        const Spacer(),
        // Next page button
        AdaptiveButton(
          type: AdaptiveButtonType.filled,
          onPressed:
              navigationShell.currentIndex ==
                  ProgressNavigationController.screens.length - 1
              ? null
              : () => ProgressNavigationController.increment(navigationShell),
          child: const Row(
            mainAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              Icon(Icons.chevron_right, color: Colors.white),
              GapSizes.xsGap,
              Text('Next', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
