import 'package:bonfire_crash_course/presentation/lotties/bonfire_lottie.dart';
import 'package:bonfire_crash_course/presentation/lotties/flutter_lottie.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;

class WhatIsTheFlameEngine extends StatelessWidget {
  const WhatIsTheFlameEngine({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'What is Flame and Bonfire?',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        const Expanded(
          child: Row(
            children: [
              Expanded(child: FlutterLottie(height: double.infinity)),
              Expanded(child: BonfireLottie(height: double.infinity)),
            ],
          ),
        ),
      ],
    );
  }
}
