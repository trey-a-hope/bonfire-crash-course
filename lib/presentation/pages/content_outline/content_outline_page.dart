import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/pages/3_map/map_module.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/player_module.dart';
import 'package:bonfire_crash_course/presentation/pages/6_npc/npc_module.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

part 'content_outline_section.dart';
part 'module_pill.dart';

/// The Content Outline: one page that maps every module with a diagram (Map,
/// Player and NPC), opened from the sidebar footer.
///
/// Like Settings and Starter Project Files, it sits outside the course shell
/// (see `lib/core/app_router.dart`), so it has no Previous/Next controls and
/// never changes course progress. Each module is a [_ContentOutlineSection]
/// with its pill, heading, tagline, diagram and lesson count, and the whole
/// page scrolls as one list.
///
/// The diagrams come from `assets/images/module_diagrams/`, which
/// `tool/diagrams/build_module_diagrams.py` writes from each module's spec.
class ContentOutlinePage extends StatelessWidget {
  /// The route path for the Content Outline page.
  static const path = '/content-outline';

  /// The short line under the title that says what the page is for.
  static const intro =
      'A map of every module you can build: its lessons, key concepts, and what you finish with.';

  /// Creates the [ContentOutlinePage].
  const ContentOutlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Same dark chrome as SettingsPage, since this page is pushed on the root
    // navigator, outside the desktop scaffold's theme.
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1B1B1E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          surface: Color(0xFF141416),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1E),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100.0),
              child: ListView(
                padding: const EdgeInsets.all(32.0),
                children: [
                  // Header: back button and page title.
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Back',
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white70,
                        ),
                        onPressed: () => _close(context),
                      ),
                      GapSizes.smallGap,
                      Expanded(
                        child: Text(
                          'Content Outline',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GapSizes.smallGap,

                  // Intro, indented to start under the title text: the back
                  // button is 48 wide, plus the small gap after it.
                  Padding(
                    padding: const EdgeInsets.only(left: 56.0),
                    child: Align(
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
                  ),
                  GapSizes.xlGap,

                  // One section per module, in course order.
                  const _ContentOutlineSection(
                    moduleNumber: 3,
                    module: MAP_MODULE,
                    tagline: 'Build the game world',
                    icon: Icons.map,
                    accentColor: Colors.deepOrangeAccent,
                    diagramAsset:
                        'assets/images/module_diagrams/module_3_map.svg',
                  ),
                  GapSizes.xxlGap,
                  const _ContentOutlineSection(
                    moduleNumber: 4,
                    module: PLAYER_MODULE,
                    tagline: 'Build and control the hero',
                    icon: Icons.person,
                    accentColor: Colors.cyanAccent,
                    diagramAsset:
                        'assets/images/module_diagrams/module_4_player.svg',
                  ),
                  GapSizes.xxlGap,
                  const _ContentOutlineSection(
                    moduleNumber: 5,
                    module: NPC_MODULE,
                    tagline: 'Add a friendly character',
                    icon: Icons.help,
                    accentColor: Colors.purpleAccent,
                    diagramAsset:
                        'assets/images/module_diagrams/module_5_npc_ally.svg',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns to the previous page, or to the first lesson if there is none
  /// (for example when the app opened straight on this route).
  static void _close(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(ProgressNavigationController.navigateablePanes.first.path);
    }
  }
}
