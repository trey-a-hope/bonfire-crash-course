import 'package:bonfire_crash_course/core/gap_sizes.dart';
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
        Text(
          'Start the app in either VSCode or in the browser. VSCode is recommended for optimal performance.',
          style: textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
        GapSizes.xlGap,
        Expanded(
          child: Center(
            child: Image.asset(
              'assets/images/screenshots/2/run_app.png',

              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
