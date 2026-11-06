import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/_cards.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum _StepType { simple, code }

class StepsWidget extends StatelessWidget {
  final List<String>? steps;
  final List<CodeStep>? codeSteps;

  /// Lights up the code lines containing this text (code steps only).
  final String? highlightMatch;

  final _StepType _type;

  const StepsWidget.simple({super.key, required this.steps})
    : codeSteps = null,
      highlightMatch = null,
      _type = _StepType.simple;

  const StepsWidget.code({
    super.key,
    required this.codeSteps,
    this.highlightMatch,
  }) : steps = null,
       _type = _StepType.code;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        // Simple Steps
        if (_type == _StepType.simple) ...[
          ...steps!.mapIndexed(
            (index, step) => ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.amber),
              title: Text('Step ${index + 1}'),
              subtitle: Text(step),
            ),
          ),
        ],

        // Code Steps
        if (_type == _StepType.code) ...[
          ...codeSteps!.mapIndexed((index, codeStep) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.blueAccent.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          'STEP ${index + 1}',
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      GapSizes.smallGap,
                      Expanded(
                        child: Text(
                          codeStep.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GapSizes.mediumGap,
                  CodeSnippetCard(
                    fileName: codeStep.fileName,
                    code: codeStep.codeSnippet,
                    highlightMatch: highlightMatch,
                  ),
                ],
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
