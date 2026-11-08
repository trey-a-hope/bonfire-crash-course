import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';

/// The first page of a module: its diagram, shown before the module's lessons.
///
/// The diagram comes from `assets/images/module_diagrams/`, which
/// `tool/diagrams/build_module_diagrams.py` writes from the module's spec.
/// This page is not a lesson, so it has no "STEP X OF N" badge.
class ModuleOverviewPage extends StatelessWidget {
  /// The module's position in the course (e.g. 3 for Map).
  final int moduleNumber;

  /// The display name of the module (e.g. 'Map').
  final String moduleName;

  /// One-line summary of the module, matching the diagram spec's tagline.
  final String tagline;

  /// Icon shown in the module pill.
  final IconData icon;

  /// Thematic accent color for the module pill.
  final Color accentColor;

  /// Number of lessons in the module.
  final int lessonCount;

  /// Title of the lesson the Next button opens.
  final String firstLessonTitle;

  /// Asset path of the module's diagram SVG.
  final String diagramAsset;

  const ModuleOverviewPage({
    super.key,
    required this.moduleNumber,
    required this.moduleName,
    required this.tagline,
    required this.icon,
    required this.accentColor,
    required this.lessonCount,
    required this.firstLessonTitle,
    required this.diagramAsset,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final lessons = lessonCount == 1 ? '1 lesson' : '$lessonCount lessons';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: accentColor, size: 15),
                GapSizes.smallGap,
                Text(
                  'MODULE $moduleNumber • OVERVIEW',
                  style: textTheme.labelMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          GapSizes.mediumGap,

          // Module name
          Text(
            moduleName,
            style: textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          GapSizes.smallGap,

          // Tagline
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              "$tagline. Here's everything this module covers before you start the first lesson.",
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
          GapSizes.largeGap,

          // Diagram card: spans the full width of the content area, and the
          // SVG fills it edge to edge on its own white background.
          // Click it to open a full-window, zoomable view.
          HeroImage(
            imagePath: diagramAsset,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
            semanticsLabel:
                '$moduleName module diagram: its lessons, their key concepts, and what students finish with.',
          ),
          GapSizes.mediumGap,

          Text(
            '$lessons in this module. Press Next to start with $firstLessonTitle.',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
