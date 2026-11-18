import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/rive/getting_started/getting_started_rive.dart';
import 'package:bonfire_crash_course/presentation/widgets/cards/_cards.dart';
import 'package:material_ui/material_ui.dart';

/// A visually rewarding completion screen displayed when a user finishes a curriculum module.
///
/// Features an animated Rive trophy, the module's badge, recap cards for what
/// the student did in the module, and a "Next Up" guidance banner.
class ModuleCompletionPage extends StatelessWidget {
  final Module module;

  const ModuleCompletionPage({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Celebration Glow + trophy animation
              Stack(
                alignment: Alignment.center,
                children: [
                  // Ambient radial glow
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          module.accentColor.withValues(alpha: 0.28),
                          module.accentColor.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Semantics(
                    image: true,
                    label: GettingStartedScene.moduleComplete.semanticLabel,
                    child: const ExcludeSemantics(
                      child: SizedBox(
                        height: 220,
                        width: 220,
                        child: GettingStartedRive(
                          scene: GettingStartedScene.moduleComplete,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              GapSizes.xsGap,

              // 2. Unit Complete Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: module.accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: module.accentColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(module.badgeIcon, color: module.accentColor, size: 15),
                    GapSizes.smallGap,
                    Text(
                      module.badgeText,
                      style: textTheme.labelMedium?.copyWith(
                        color: module.accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              GapSizes.smallGap,

              // 3. Headline & Description
              Text(
                module.completionHeadline,
                textAlign: TextAlign.center,
                style: textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              GapSizes.smallGap,
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  module.completionSubtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ),
              GapSizes.mediumGap,

              // 4. Recap of what the student did in this module
              _RecapGrid(module: module),
              GapSizes.mediumGap,

              // 6. Up Next Guidance Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1E1E2C),
                      Colors.blueAccent.withValues(alpha: 0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        color: Colors.blueAccent,
                        size: 24,
                      ),
                    ),
                    GapSizes.mediumGap,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'UP NEXT',
                                style: textTheme.labelSmall?.copyWith(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              GapSizes.smallGap,
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.blueAccent,
                                size: 14,
                              ),
                              GapSizes.xsGap,
                              Flexible(
                                child: Text(
                                  module.nextModuleTitle,
                                  style: textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GapSizes.xsGap,
                          Text(
                            module.nextModuleDescription,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GapSizes.mediumGap,
                    module.nextLottie,
                  ],
                ),
              ),
              GapSizes.largeGap,
            ],
          ),
        ),
      ),
    );
  }
}

/// The module's [Module.achievements], as cards three to a row on wide
/// windows, fewer on narrow ones. Cards in a row share the tallest one's height.
class _RecapGrid extends StatelessWidget {
  final Module module;

  const _RecapGrid({required this.module});

  static const _spacing = 16.0;

  @override
  Widget build(BuildContext context) {
    final items = module.achievements;
    if (items.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 720
            ? 3
            : width >= 460
            ? 2
            : 1;

        final rows = <Widget>[];
        for (var i = 0; i < items.length; i += columns) {
          final cells = <Widget>[];
          for (var c = 0; c < columns; c++) {
            if (c > 0) cells.add(const SizedBox(width: _spacing));
            final index = i + c;
            cells.add(
              Expanded(
                child: index < items.length
                    ? MetricCard(
                        icon: items[index].icon,
                        color: module.accentColor,
                        title: items[index].title,
                        subtitle: items[index].description,
                      )
                    : const SizedBox.shrink(),
              ),
            );
          }
          if (rows.isNotEmpty) rows.add(const SizedBox(height: _spacing));
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: cells,
              ),
            ),
          );
        }
        return Column(children: rows);
      },
    );
  }
}
