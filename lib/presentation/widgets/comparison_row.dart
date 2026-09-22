import 'package:flutter/material.dart';

class ComparisonRow extends StatelessWidget {
  final String label;
  final String cloud;
  final String local;

  const ComparisonRow({
    super.key,
    required this.label,
    required this.cloud,
    required this.local,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              cloud,
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              local,
              style: const TextStyle(color: Colors.purpleAccent, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
