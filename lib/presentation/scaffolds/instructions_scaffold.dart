import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/widgets/step_badge_header.dart';

/// A split-pane layout scaffold for instructional and setup-focused lessons.
///
/// Features a top header with the module badge, current step, and page title,
/// paired with a 2-column scrollable body:
/// - Left pane (flex 3): Primary steps, explanations, and action buttons.
/// - Right pane (flex 2): Supporting visuals, screenshots, tips, and benefit cards.
class InstructionsScaffold extends SignalWidget {
  /// The module metadata (module name, total steps, accent color).
  final Module module;

  /// Widgets placed in the scrollable primary content column on the left.
  final List<Widget> leftPaneWidgets;

  /// Widgets placed in the scrollable secondary/visual column on the right.
  final List<Widget> rightPaneWidets;

  /// Current step index within this module.
  final int unitStep;

  /// Main page title.
  final String title;

  /// Optional subtitle or high-level summary.
  final String? subtitle;

  final String? unitExtra;

  const InstructionsScaffold({
    super.key,
    required this.module,
    required this.leftPaneWidgets,
    required this.rightPaneWidets,
    required this.unitStep,
    required this.title,
    this.unitExtra,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Module progression badge & step tracker
        StepBadgeHeader(
          title: module.moduleName.toUpperCase(),
          currentStep: unitStep,
          totalSteps: module.totalSteps,
          color: module.accentColor,
          extra: unitExtra,
        ),
        GapSizes.smallGap,

        // Page title
        Text(
          title,
          style: textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        GapSizes.smallGap,

        // Optional subtitle
        if (subtitle != null) ...[
          GapSizes.xsGap,
          Text(
            subtitle!,
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
        GapSizes.largeGap,

        // Split content: Left (instructions) & Right (visual walkthroughs/cards)
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left pane: Primary instructional content (flex 3)
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(children: leftPaneWidgets),
                ),
              ),
              GapSizes.largeGap,

              // Right pane: Media, visual walkthrough, and tips (flex 2)
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(children: rightPaneWidets),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
