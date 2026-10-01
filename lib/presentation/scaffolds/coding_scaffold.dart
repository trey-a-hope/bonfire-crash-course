import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/app_card.dart';
import 'package:bonfire_crash_course/presentation/widgets/course_video_player.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:bonfire_crash_course/presentation/widgets/step_badge_header.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

/// A standardized split-pane layout scaffold for interactive coding lessons.
///
/// Implements a responsive desktop layout with structured curriculum
/// presentation (Objectives, Concepts, Code Steps, Verification) on the left (flex 3),
/// and multimedia walkthroughs (Video Player, Visual Preview, Pro-Tips) on the right (flex 2).
class CodingScaffold extends SignalWidget {
  /// The module metadata (module name, total steps, accent color).
  final Module module;

  /// Current step index within this module.
  final int unitStep;

  /// Optional extra badge label displayed beside the step counter.
  final String? unitExtra;

  /// Main lesson title.
  final String title;

  /// Optional subtitle or high-level overview.
  final String? subtitle;

  /// Widget displaying the core objective of the lesson.
  final String objective;

  /// Key conceptual breakdown cards for this lesson.
  final List<Concept> concepts;

  /// Step-by-step code implementation instructions.
  final List<CodeStep> codeSteps;

  /// Guidance statement and expected completion time for game verification.
  final String timeToCodeStatement;

  /// URL for the embedded lesson video walkthrough.
  final String videoUrl;

  /// Optional title override for the video player header.
  final String? videoTitle;

  const CodingScaffold({
    super.key,
    required this.module,
    required this.unitStep,
    this.unitExtra,
    required this.title,
    this.subtitle,
    required this.objective,
    required this.concepts,
    required this.codeSteps,
    required this.timeToCodeStatement,
    required this.videoUrl,
    this.videoTitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Module progression badge & step tracker
        StepBadgeHeader(
          title: module.moduleName.toUpperCase(),
          currentStep: unitStep,
          totalSteps: module.totalSteps,
          color: module.accentColor,
          extra: unitExtra,
        ),
        GapSizes.smallGap,

        // Page title
        Text(
          title,
          style: textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        GapSizes.smallGap,

        // Optional subtitle
        if (subtitle != null) ...[
          GapSizes.xsGap,
          Text(
            subtitle!,
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
        GapSizes.largeGap,

        // Main Split Content
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Objective, Concepts & Code Steps (Flex 3)
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCard.objective(
                        title: 'Lesson Objective',
                        description: objective,
                      ),
                      GapSizes.largeGap,

                      // Key Concepts Section
                      if (concepts.isNotEmpty) ...[
                        Text(
                          'Key Concepts',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GapSizes.smallGap,
                        ...concepts.mapIndexed(
                          (i, concept) => i == concepts.length
                              ? AppCard.lightbulb(
                                  title: concept.title,
                                  description: concept.subtitle,
                                )
                              : Column(
                                  children: [
                                    AppCard.lightbulb(
                                      title: concept.title,
                                      description: concept.subtitle,
                                    ),
                                    GapSizes.smallGap,
                                  ],
                                ),
                        ),
                        GapSizes.mediumGap,
                      ],

                      // Code Steps Section
                      if (codeSteps.isNotEmpty) ...[
                        Text(
                          'Code Implementation',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GapSizes.smallGap,
                        StepsWidget.code(codeSteps: codeSteps),
                        GapSizes.mediumGap,
                      ],

                      // Checkpoint / Verification Card
                      AppCard.action(
                        title: 'Verify in Your Running Game',
                        description: timeToCodeStatement,
                      ),
                      GapSizes.largeGap,
                    ],
                  ),
                ),
              ),
              GapSizes.largeGap,

              // Right Column: Video Walkthrough, Lottie Visual & Pro-Tip (Flex 2)
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Video Player Container
                      CourseVideoPlayer(
                        videoUrl: videoUrl,
                        title: videoTitle ?? '$title Tutorial',
                      ),
                      GapSizes.mediumGap,

                      // Animated Visual Preview Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Colors.cyanAccent,
                                  size: 18,
                                ),
                                GapSizes.smallGap,
                                Text(
                                  'Interactive Visual',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            GapSizes.mediumGap,
                            const HeroImage(
                              imagePath: 'assets/images/images.jpeg',
                              caption:
                                  'GitHub codespaces running directly inside your browser',
                            ),
                          ],
                        ),
                      ),
                      GapSizes.mediumGap,

                      AppCard.info(
                        title: 'Pro-Tip',
                        description:
                            'Ensure your map JSON/TMX assets are declared under the assets: section in pubspec.yaml so Bonfire can bundle and parse them properly.',
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
