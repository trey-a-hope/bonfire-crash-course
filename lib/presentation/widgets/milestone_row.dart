import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';

class MilestoneRow extends StatelessWidget {
  final String text;

  const MilestoneRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.done_all_rounded,
            color: Colors.greenAccent,
            size: 16,
          ),
          GapSizes.smallGap,
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
