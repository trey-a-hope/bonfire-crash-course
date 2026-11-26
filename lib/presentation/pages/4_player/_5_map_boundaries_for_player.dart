import '../../../core/modules/player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_HERO = 'lib/presentation/characters/hero.dart';

class MapBoundariesForPlayerPage extends StatelessWidget {
  const MapBoundariesForPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 5,
      title: 'Map Boundaries for Player',
      outcome: 'The hero can\'t walk or fall off the map.',
      objective:
          'Keep the player on the map and prevent it from falling into the void.',
      concepts: [
        Concept(
          title: 'Map Boundaries',
          short: 'Keeps the hero inside the map.',
          subtitle: 'Map Boundaries prevent the player from leaving the map.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add all imports at the top.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
// The ScreenBoundaryChecker mixin that ships with the template.
+ import 'package:counter_app/core/mixins/screen_boundary_checker.dart';
''',
        ),
        CodeStep(
          description:
              'Add the ScreenBoundaryChecker mixin to the HeroPlayer class.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer
-     with WithForces, KeyboardEventListener {
+     with WithForces, KeyboardEventListener, ScreenBoundaryChecker {
  static const _asset = CharacterAsset.wizard;
''',
        ),
        CodeStep(
          description:
              'Below onLoad, override the update method. It pauses the hero during cutscenes and otherwise runs PlatformPlayer\'s own update.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer
    with WithForces, KeyboardEventListener, ScreenBoundaryChecker {
  ...
  @override
  Future<void> onLoad() async {
    ...
  }

+   /// Called every game tick to update the player's state.
+   @override
+   void update(double dt) {
+     // Pause player logic and movement while a cutscene/cinematic scene is active.
+     if (gameRef.sceneBuilderStatus.isRunning) return;
+     // Run standard PlatformPlayer animation updates.
+     super.update(dt);
+   }
}
''',
        ),
        CodeStep(
          description:
              'After super.update(dt), call checkBoundaries() to keep the player on the map.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
@override
void update(double dt) {
  // Pause player logic and movement while a cutscene/cinematic scene is active.
  if (gameRef.sceneBuilderStatus.isRunning) return;
  // Run standard PlatformPlayer animation updates.
  super.update(dt);
+   // Constrain the player to stay within the map/screen boundaries. This
+   // runs after the move, so the hero never draws past the edge.
+   checkBoundaries();
}
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add the ScreenBoundaryChecker mixin to HeroPlayer and override update so it calls checkBoundaries() every tick.',
      proTip:
          'Keep the super.update(dt) call in update, before checkBoundaries(); without it the hero stops moving and animating.',
    );
  }
}
