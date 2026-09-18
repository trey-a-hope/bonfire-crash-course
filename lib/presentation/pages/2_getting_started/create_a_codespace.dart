import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/presentation/lotties/_lotties.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_button.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_modal_service.dart';
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
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
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
                    Image.asset(
                      'assets/images/images.jpeg',
                      fit: BoxFit.fitHeight,
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
                        'Click Download for macOS above to download the universal .zip archive.',
                      ],
                    ),
                  ],
                ),
              ),
              GapSizes.largeGap,
              Expanded(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/images.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    GapSizes.xsGap,
                    Text(
                      'Github codespaces running directly inside of a browser',
                      style: textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                    GapSizes.xsGap,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          const PowerOffLottie(),
                          AdaptiveButton(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
