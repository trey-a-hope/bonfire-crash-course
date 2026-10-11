import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'getting_started_module.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/instructions_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/app_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/course_video_player.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:bonfire_crash_course/presentation/widgets/screenshot_header.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:bonfire_crash_course/presentation/widgets/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateACodespace extends StatelessWidget {
  const CreateACodespace({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InstructionsScaffold(
      module: GETTING_STARTED_MODULE,
      unitStep: 2,
      title: 'Create a Codespace',
      subtitle:
          'Launch a full cloud-hosted VS Code and Flutter environment with zero local configuration.',
      leftPaneWidgets: [
        // Video Player Container
        const CourseVideoPlayer(
          videoUrl:
              'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
          title: 'GitHub Codespaces Overview',
        ),
        GapSizes.largeGap,

        // What is GitHub Codespaces? Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blueAccent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.cloud_queue_rounded,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                  ),
                  GapSizes.mediumGap,
                  Text(
                    'What is GitHub Codespaces?',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GapSizes.smallGap,
              Text(
                'Think of Codespaces as a dedicated developer computer in the cloud. It boots Visual Studio Code directly inside your browser tab with the Flutter SDK, Dart runtime, Bonfire game engine template, and all necessary extensions already installed and configured.',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        GapSizes.largeGap,

        // Step-by-Step Launch Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.blueAccent.withValues(alpha: 0.25),
            ),
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
                      Icons.play_arrow_rounded,
                      color: Colors.greenAccent,
                      size: 20,
                    ),
                  ),
                  GapSizes.mediumGap,
                  Text(
                    'Launch Your Codespace',
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
                  'Click the "Create a Codespace" button below to open the GitHub template repository.',
                  'When the "Create a new codespace" modal appears on GitHub, click the green "Create codespace" button.',
                  'Your cloud editor will initialize in a new tab with your project files ready to edit.',
                ],
              ),
              GapSizes.largeGap,
              Center(
                child: Column(
                  children: [
                    GlassButton(
                      title: 'Create a Codespace',
                      prefixIconData: Icons.open_in_new_rounded,
                      onPressed: () async {
                        final uri = Uri.parse(CODE_SPACES_TEMPLATE_URL);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      color: Colors.purpleAccent,
                    ),
                    GapSizes.smallGap,
                    Text(
                      'Opens GitHub in your default browser',
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
        ),
        GapSizes.mediumGap,

        AppCard.info(
          title: 'First-Time Build Duration',
          description:
              'The very first launch takes ~90 seconds while GitHub pulls the Docker container and downloads Flutter dependencies. Subsequent launches load in under 5 seconds!',
        ),
        GapSizes.largeGap,
      ],
      rightPaneWidets: [
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
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: Colors.cyanAccent,
                      size: 18,
                    ),
                  ),
                  GapSizes.smallGap,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visual Walkthrough',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Click any screenshot to zoom',
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

              // Image 1
              const ScreenshotHeader(
                step: '1',
                title: 'Codespaces Browser Interface',
              ),
              GapSizes.smallGap,
              const HeroImage(
                imagePath: 'assets/images/images.jpeg',
                caption:
                    'GitHub codespaces running directly inside your browser',
              ),
              GapSizes.largeGap,

              // Image 2
              const ScreenshotHeader(
                step: '2',
                title: '\'Create a New Codespace\' Window',
              ),
              GapSizes.smallGap,
              const HeroImage(
                imagePath: 'assets/images/getting_started/1.png',
                caption: 'The creation modal confirming machine specs',
              ),
              GapSizes.largeGap,

              // Image 3
              const ScreenshotHeader(step: '3', title: 'VS Code Live & Ready'),
              GapSizes.smallGap,
              const HeroImage(
                imagePath: 'assets/images/getting_started/2.png',
                caption: 'Your active workspace with terminal and editor',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
