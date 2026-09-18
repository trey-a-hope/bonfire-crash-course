import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/lotties/_lotties.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;

class UnitCompletionPage extends StatelessWidget {
  final String unitName;

  const UnitCompletionPage({super.key, required this.unitName});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        children: [
          const Expanded(child: StarBadgeLottie()),
          Text(
            'Great Job!',
            style: textTheme.displayLarge?.copyWith(color: Colors.white),
          ),
          GapSizes.smallGap,
          Text(
            'You completed the $unitName unit; keep going champ.',
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
