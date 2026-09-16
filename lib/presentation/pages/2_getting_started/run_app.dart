import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;

class RunApp extends StatelessWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Run the App',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
