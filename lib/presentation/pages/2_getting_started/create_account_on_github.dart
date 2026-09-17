import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;

class CreateAccountOnGithub extends StatelessWidget {
  const CreateAccountOnGithub({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Create an Account on Github',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
