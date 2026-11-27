part of 'content_outline_view.dart';

/// One module's section on the [ContentOutlineView]: its "MODULE N" pill,
/// name, tagline, lesson diagram and lesson count.
class _ContentOutlineSection extends StatelessWidget {
  /// The module's position in the course (e.g. 3 for Map).
  final int moduleNumber;

  /// The module this section describes. Its [Module.moduleName] is the
  /// heading and its [Module.totalSteps] is the lesson count, so the outline
  /// can't drift from the lessons' "STEP X OF N" badges.
  final Module module;

  /// One-line summary of the module, matching the diagram spec's tagline.
  final String tagline;

  /// Icon shown in the module pill.
  final IconData icon;

  /// Thematic accent color for the module pill.
  final Color accentColor;

  /// Asset path of the module's diagram SVG.
  final String diagramAsset;

  /// Creates the section for one module.
  const _ContentOutlineSection({
    required this.moduleNumber,
    required this.module,
    required this.tagline,
    required this.icon,
    required this.accentColor,
    required this.diagramAsset,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final lessonCount = module.totalSteps;
    // Singular for a one-lesson module, so the line never reads "1 lessons".
    final lessons = lessonCount == 1 ? '1 lesson' : '$lessonCount lessons';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        _ModulePill(
          label: 'MODULE $moduleNumber',
          icon: icon,
          accentColor: accentColor,
        ),

        // Module name
        Text(
          module.moduleName,
          style: textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),

        // Tagline
        Text(
          tagline,
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),

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
              '${module.moduleName} module diagram: its lessons, their key concepts, and what students finish with.',
        ),

        // Lesson count
        Text(
          '$lessons in this module.',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
