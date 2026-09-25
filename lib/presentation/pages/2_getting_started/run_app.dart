import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/core/modules/_modules.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:bonfire_crash_course/presentation/widgets/milestone_row.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class RunApp extends StatelessWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      leftPaneWidgets: [
        // Launching in Codespaces Card
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.play_circle_filled_rounded,
                      color: Colors.greenAccent,
                      size: 20,
                    ),
                  ),
                  GapSizes.mediumGap,
                  Text(
                    'How to Launch the Game',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GapSizes.mediumGap,
              const StepsWidget.simple(
                steps: [
                  'Open the integrated terminal in VS Code using the shortcut (Ctrl + ` on Windows/Linux, Cmd + ` on Mac) or from the top menu: Terminal > New Terminal.',
                  'Verify dependencies by typing "flutter pub get" and pressing Enter.',
                  'Start the development server by pressing F5 (Run > Start Debugging) or typing "flutter run -d chrome" in the terminal.',
                  'When prompted by Codespaces with "Open in Browser", click it to see the starter game live in your browser!',
                ],
              ),
            ],
          ),
        ),
        GapSizes.largeGap,

        // Terminal Command Snippet Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.terminal_rounded,
                    color: Colors.white60,
                    size: 16,
                  ),
                  GapSizes.smallGap,
                  Text(
                    'QUICK TERMINAL COMMAND',
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              GapSizes.smallGap,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF14141E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.greenAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: const Text(
                  'flutter run -d web-server --web-port 8080',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.greenAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        GapSizes.largeGap,

        // Hot Reload Feature Highlight Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.cyanAccent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.cyanAccent.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Colors.cyanAccent,
                  size: 22,
                ),
              ),
              GapSizes.mediumGap,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Power of Hot Reload',
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GapSizes.xsGap,
                    Text(
                      'One of Flutter’s greatest superpowers is Stateful Hot Reload. Whenever you edit game parameters, maps, or player logic, simply save your file (Ctrl/Cmd + S) or press "r" in your terminal. Your updates appear in the running game in under 1 second without restarting or losing character position!',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        GapSizes.largeGap,
      ],
      rightPaneWidets: [
        // Visual Walkthrough Panel
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.sports_esports_rounded,
                      color: Colors.greenAccent,
                      size: 18,
                    ),
                  ),
                  GapSizes.smallGap,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What You Should See',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Click screenshot to zoom',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GapSizes.mediumGap,
              const HeroImage(
                imagePath: 'assets/images/screenshots/2/run_app.png',
                caption:
                    'Default Bonfire starter game running inside the browser',
              ),
            ],
          ),
        ),
        GapSizes.mediumGap,

        // Milestone Checklist: Getting Started Complete
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.greenAccent.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.greenAccent,
                    size: 22,
                  ),
                  GapSizes.smallGap,
                  Text(
                    'Getting Started Complete! 🎉',
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GapSizes.smallGap,
              Text(
                'Congratulations! Your developer setup is fully primed and tested. Here is what you have unlocked:',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ),
              GapSizes.mediumGap,
              const MilestoneRow(text: 'GitHub template repository connected'),
              const MilestoneRow(
                text: 'Cloud or local VS Code environment active',
              ),
              const MilestoneRow(text: 'Flutter & Bonfire compiling smoothly'),
              const MilestoneRow(text: 'Hot Reload verified and functional'),
              GapSizes.mediumGap,
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                    GapSizes.smallGap,
                    Expanded(
                      child: Text(
                        'Next Unit: Map & World Building! Advance to the next lesson to import your first tilemap.',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      unitStep: 4,
      title: 'Run the Game Application',
    );
  }
}
