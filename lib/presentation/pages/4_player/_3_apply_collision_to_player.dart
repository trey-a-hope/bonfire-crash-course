import 'package:bonfire_crash_course/core/config/constants.dart';

import '../../../core/modules/player_module.dart';

import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

class ApplyCollisionToPlayerPage extends StatelessWidget {
  const ApplyCollisionToPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 3,
      title: 'Apply Collision to Player',
      outcome: 'The hero lands on the ground instead of falling through.',
      objective: 'Apply collision to the player component in a Bonfire game by configuring its shape, size, and physics properties.',
      concepts: [
        Concept(
          title: 'RectangleHitbox',
          short: 'The hero\'s solid shape.',
          subtitle: 'Defines the collision area of the player component as a rectangle.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add a RectangleHitbox in onLoad so the hero has a solid shape.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer ... {
+   @override
+   Future<void> onLoad() async {
+     add(RectangleHitbox(size: size));
+     return super.onLoad();
+   }
}
''',
        ),
        CodeStep(
          description:
              'Add a ValueNotifier to control whether hitbox outlines show.',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
class _GameScreenState extends State<GameScreen> {
+   final _collisionBoxesVisible = ValueNotifier<bool>(false);
}
''',
        ),
        CodeStep(
          description:
              'Add a ValueNotifier to control whether hitbox outlines show.',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
@override
void dispose() {
+ _collisionBoxesVisible.dispose();
  super.dispose();
}
''',
        ),
        CodeStep(
          description: '?',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
return BonfireWidget(
  cameraConfig: _cameraConfig,
+   components: [
+     CollisionBoxes.shared(_collisionBoxesVisible),
+   ],
)
''',
        ),
        CodeStep(
          description: '?',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
return BonfireWidget(
  cameraConfig: _cameraConfig,
  components: [
    CollisionBoxes.shared(_collisionBoxesVisible),
  ],
+   overlayBuilderMap: {
+     CollisionBoxesToggle.overlayName: (context, game) =>
+       CollisionBoxesToggle(visible: _collisionBoxesVisible),
+   },
)
''',
        ),

        CodeStep(
          description: '?',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
return BonfireWidget(
  cameraConfig: _cameraConfig,
  components: [
    CollisionBoxes.shared(_collisionBoxesVisible),
  ],
  overlayBuilderMap: {
    CollisionBoxesToggle.overlayName: (context, game) =>
      CollisionBoxesToggle(visible: _collisionBoxesVisible),
  },
+  initialActiveOverlays: [
+     CollisionBoxesToggle.overlayName,
+  ],
)
''',
        ),
      ],
      timeToCodeStatement: 'You\'re about to override onLoad in hero.dart and add a RectangleHitbox the same size as the hero.',
      proTip: 'While testing, set debugMode: true on BonfireWidget to outline every hitbox, so you can see exactly where the hero meets the ground.',
    );
  }
}
