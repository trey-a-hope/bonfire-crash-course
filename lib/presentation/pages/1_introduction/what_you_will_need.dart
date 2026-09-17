import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;

class WhatYouWillNeed extends StatelessWidget {
  const WhatYouWillNeed({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'What You Will Need',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
