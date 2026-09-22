import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';

class ExtensionRow extends StatelessWidget {
  final String name;
  final String publisher;
  final String description;

  const ExtensionRow({
    super.key,
    required this.name,
    required this.publisher,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.extension_outlined,
            color: Colors.blueAccent,
            size: 16,
          ),
        ),
        GapSizes.mediumGap,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GapSizes.smallGap,
                  Text(
                    'by $publisher',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              GapSizes.xsGap,
              Text(
                description,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
