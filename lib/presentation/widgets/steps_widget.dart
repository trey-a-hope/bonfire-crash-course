import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_list_tile.dart';
import 'package:bonfire_crash_course/presentation/widgets/code_snippet_card.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum _StepType { simple, code }

class StepsWidget extends StatelessWidget {
  final List<String>? steps;
  final List<CodeStep>? codeSteps;

  final _StepType _type;

  const StepsWidget.simple({super.key, required this.steps})
    : codeSteps = null,
      _type = _StepType.simple;

  const StepsWidget.code({super.key, required this.codeSteps})
    : steps = null,
      _type = _StepType.code;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        // Simple Steps
        if (_type == _StepType.simple) ...[
          ...steps!.mapIndexed((index, step) {
            return AdaptiveListTile(
              icon: Icons.lightbulb,
              title: 'Step ${index + 1}',
              subtitle: step,
            );
          }),
        ],

        // Code Steps
        if (_type == _StepType.code) ...[
          ...codeSteps!.mapIndexed((index, codeStep) {
            return Card(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsetsGeometry.all(8),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Step. ${index + 1} - ${codeStep.description}',
                      style: textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    GapSizes.smallGap,
                    CodeSnippetCard(
                      fileName: codeStep.fileName,
                      code: codeStep.codeSnippet,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}

class CodeStep {
  final String description;
  final String fileName;
  final String codeSnippet;

  const CodeStep({
    required this.description,
    required this.fileName,
    required this.codeSnippet,
  });
}
