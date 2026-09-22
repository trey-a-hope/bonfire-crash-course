import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';

class BenefitItem extends StatelessWidget {
  final String text;

  const BenefitItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Colors.cyanAccent,
            size: 16,
          ),
          GapSizes.smallGap,
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
