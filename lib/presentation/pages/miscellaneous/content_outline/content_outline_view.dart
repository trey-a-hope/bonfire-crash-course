import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/core/modules/map_module.dart';
import 'package:bonfire_crash_course/core/modules/player_module.dart';
import 'package:bonfire_crash_course/core/modules/enemy_module.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:material_ui/material_ui.dart';

part 'content_outline_section.dart';
part 'module_pill.dart';

/// The Content Outline tab of the Course Info page: one scrolling list that
/// maps every module with a diagram (Map, Player and Enemy).
///
/// Each module is a [_ContentOutlineSection] with its pill, heading, tagline,
/// diagram and lesson count.
///
/// The diagrams come from `assets/images/module_diagrams/`, which
/// `tool/diagrams/build_module_diagrams.py` writes from each module's spec.
class ContentOutlineView extends StatelessWidget {
  /// The short line at the top of the tab that says what it is for.
  static const intro =
      'A map of every module you can build: its lessons, key concepts, and what you finish with.';

  /// Creates the [ContentOutlineView].
  const ContentOutlineView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100.0),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  intro,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
            GapSizes.xlGap,

            // One section per module, in course order.
            const _ContentOutlineSection(
              moduleNumber: 3,
              module: MAP_MODULE,
              tagline: 'Build the game world',
              icon: Icons.map,
              accentColor: Colors.deepOrangeAccent,
              diagramAsset: 'assets/images/module_diagrams/module_3_map.svg',
            ),
            GapSizes.xxlGap,
            const _ContentOutlineSection(
              moduleNumber: 4,
              module: PLAYER_MODULE,
              tagline: 'Build and control the hero',
              icon: Icons.person,
              accentColor: Colors.cyanAccent,
              diagramAsset: 'assets/images/module_diagrams/module_4_player.svg',
            ),
            GapSizes.xxlGap,
            const _ContentOutlineSection(
              moduleNumber: 5,
              module: ENEMY_MODULE,
              tagline: 'Add an enemy to fight',
              icon: Icons.dangerous,
              accentColor: Colors.redAccent,
              diagramAsset: 'assets/images/module_diagrams/module_5_enemy.svg',
            ),
          ],
        ),
      ),
    );
  }
}
