import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final IconData? suffixIconData;
  final IconData? prefixIconData;
  final Color color;

  const GlassButton({
    super.key,
    this.onPressed,
    required this.title,
    this.prefixIconData,
    this.suffixIconData,
    this.color = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isEnabled = onPressed != null;
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIconData != null) ...[
                Icon(prefixIconData, color: Colors.white, size: 16),
                GapSizes.smallGap,
              ],
              Text(
                title,
                style: textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (suffixIconData != null) ...[
                GapSizes.smallGap,
                Icon(suffixIconData, color: Colors.white, size: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
