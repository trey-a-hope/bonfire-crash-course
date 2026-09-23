import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/widgets/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A navigation bar widget providing "Previous" and "Next" action buttons.
///
/// Dispatches navigation events directly to [PageIndexController] to advance
/// or backtrack through pages.
class PageNavigator extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const PageNavigator({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous page button
        GlassButton(
          onPressed: navigationShell.currentIndex == 0
              ? null
              : () => ProgressNavigationController.previous(context),
          title: 'Previous',
          prefixIconData: Icons.arrow_back_rounded,
        ),
        const Spacer(),
        // Next page button
        GlassButton(
          onPressed:
              navigationShell.currentIndex ==
                  ProgressNavigationController.screens.length - 1
              ? null
              : () => ProgressNavigationController.next(context),
          title: 'Next',
          suffixIconData: Icons.arrow_forward_rounded,
        ),
      ],
    );
  }
}
