import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:material_ui/material_ui.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';

/// One module's page in the "Content Outline" section at the end of the
/// course: a look back at the module's diagram after the course is finished.
///
/// The Content Outline pane in `lib/core/pane_config.dart` lists one of these
/// per module that has a diagram (Map, Player and NPC). Modules no longer open
/// with this page, so a module's sidebar entry goes straight to its first
/// lesson.
///
/// The diagram comes from `assets/images/module_diagrams/`, which
/// `tool/diagrams/build_module_diagrams.py` writes from the module's spec.
/// This page is not a lesson, so it has no "STEP X OF N" badge.
class ContentOutlinePage extends StatelessWidget {
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

  /// Number of lessons in the module (its pages other than the completion
  /// page), shown in the footer line.
  final int lessonCount;

  /// Asset path of the module's diagram SVG.
  final String diagramAsset;

  /// Creates the outline page for one module.
  const ContentOutlinePage({
    super.key,
    required this.moduleNumber,
    required this.moduleName,
    required this.tagline,
    required this.icon,
    required this.accentColor,
    required this.lessonCount,
    required this.diagramAsset,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Singular for a one-lesson module, so the footer never reads "1 lessons".
    final lessons = lessonCount == 1 ? '1 lesson' : '$lessonCount lessons';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section pill: names the Content Outline and which module this is.
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
                  'CONTENT OUTLINE • MODULE $moduleNumber',
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

          // Intro: the tagline, framed as a look back over a finished module.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              "$tagline. Here's a look back at everything this module covered.",
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

          // Footer: lesson count, and a pointer to the other outlines.
          Text(
            "$lessons in this module. Use the sidebar to review another module's outline.",
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
