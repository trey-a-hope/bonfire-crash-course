import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';

class BenefitRow extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;

  const BenefitRow({
    super.key,
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 16),
          ),
          GapSizes.mediumGap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GapSizes.xsGap,
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
