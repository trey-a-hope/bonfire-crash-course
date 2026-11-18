import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:material_ui/material_ui.dart';

class StepBadgeHeader extends StatelessWidget {
  final Color color;
  final String title;
  final int currentStep;
  final int totalSteps;
  final String? extra;

  const StepBadgeHeader({
    super.key,
    required this.color,
    required this.title,
    required this.currentStep,
    required this.totalSteps,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Text(
            '$title • STEP $currentStep OF $totalSteps',
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
        if (extra != null) ...[
          GapSizes.smallGap,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              extra!.toUpperCase(),
              style: textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
