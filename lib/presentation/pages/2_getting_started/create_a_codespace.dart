import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_modal_service.dart';
import 'package:bonfire_crash_course/presentation/widgets/course_video_player.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:bonfire_crash_course/presentation/widgets/sheet_views/_sheet_views.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:url_launcher/url_launcher.dart';

class CreateACodespace extends StatelessWidget {
  const CreateACodespace({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Create a Codespace',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        GapSizes.mediumGap,
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      const CourseVideoPlayer(
                        videoUrl:
                            'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
                        title: 'Github Codespaces Overview',
                      ),
                      GapSizes.mediumGap,
                      Text(
                        'What is Github Codespaces?',
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GapSizes.xsGap,
                      Text(
                        'Think of Codespaces as a full developer computer running in the cloud. It launches Visual Studio Code directly inside your browser with all the compilers, extensions, and tools we need for this course already installed. Click the Code button on our GitHub repository, select Codespaces, and start coding immediately.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GapSizes.mediumGap,
                      Text(
                        'Create a Github CodeSpace',
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const StepsWidget.simple(
                        steps: [
                          'Select the \'Create a Codespace\' button at the bottom.',
                          'When the \'Create a new codespace\' window appears, select the \'Create codespace\' button.',
                        ],
                      ),
                      GapSizes.mediumGap,

                      Text(
                        'The codespace will create in a new tab, (it may take a few minutes to load).',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      GapSizes.mediumGap,
                      Center(
                        child: Padding(
                          padding: const EdgeInsetsGeometry.all(16),
                          child: AdaptiveButton(
                            type: .filled,
                            child: const Row(
                              mainAxisSize: .min,
                              children: [
                                Icon(
                                  FluentIcons.git_graph,
                                  color: Colors.white,
                                ),
                                GapSizes.xsGap,
                                Text(
                                  'Create a Codespace',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              final uri = Uri.parse(CODE_SPACES_TEMPLATE_URL);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                if (!context.mounted) return;
                                AdaptiveModalService.showSheet(
                                  context,
                                  SheetType.settings,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GapSizes.largeGap,
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      HeroImage(
                        imagePath: 'assets/images/images.jpeg',
                        caption:
                            'Github codespaces running directly inside of a browser',
                      ),
                      GapSizes.mediumGap,
                      HeroImage(
                        imagePath: 'assets/images/getting_started/1.png',
                        caption: '\'Create a new codespace\' window',
                      ),
                      GapSizes.mediumGap,
                      HeroImage(
                        imagePath: 'assets/images/getting_started/2.png',
                        caption: 'Your new codespace running in the browser',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
