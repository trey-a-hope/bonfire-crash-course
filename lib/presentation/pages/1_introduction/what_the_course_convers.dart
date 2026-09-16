import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;

class WhatTheCourseConvers extends StatelessWidget {
  const WhatTheCourseConvers({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          'What the Course Covers',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
