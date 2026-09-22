import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';

class ScreenshotHeader extends StatelessWidget {
  final String step;
  final String title;

  const ScreenshotHeader({super.key, required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GapSizes.smallGap,
        Expanded(
          child: Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
