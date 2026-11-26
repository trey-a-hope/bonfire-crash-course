import '../../../core/modules/npc_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_COMPANION =
    'lib/presentation/characters/companion.dart';

class CompanionSpriteAnimationsPage extends StatelessWidget {
  const CompanionSpriteAnimationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: NPC_MODULE,
      unitStep: 2,
      title: 'Companion Sprite Animations',
      outcome: 'Berry the strawberry stands on the ground and animates.',
      objective:
          'Give the companion idle and walk animations from the strawberry sprite sheets, using the same AnimationUtils helper as the hero.',
      concepts: [
        Concept(
          title: 'SimpleDirectionAnimation',
          short: 'Idle and run animations for each direction.',
          subtitle:
              'Holds an NPC\'s idle and run animations for each direction. Bonfire picks the right one from which way the NPC faces and whether it\'s moving.',
        ),
        Concept(
          title: 'Frame Count (amount)',
          short: 'How many frames to slice from a sheet.',
          subtitle:
              'How many 32x32 frames AnimationUtils slices from a sheet. The strawberry idle sheet has 8 frames (a breath, a stem sway and a blink) and the walk sheet has 4. A wrong amount makes the animation jitter or show half-frames.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add all imports at the top.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
// The same helper the hero uses to turn a sprite sheet into an animation.
+ import 'package:counter_app/presentation/characters/util/animation_utils.dart';
''',
        ),
        CodeStep(
          description:
              'Pass a SimpleDirectionAnimation to super(...) with the idle animation. The strawberry faces the camera, so left and right share the same sheet.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
Companion(Vector2 position)
    : super(
        position: position,
        // Size on screen; matches one 32x32 frame.
        size: Vector2.all(TILE_SIZE),
        life: 100,
        // Same speed as the hero (Bonfire's default, 80), so it keeps up
        // instead of falling behind and losing sight of them.
        speed: 80,
+         // The strawberry faces the camera, so left and right share a sheet.
+         animation: SimpleDirectionAnimation(
+           // Idle breathes, sways its stem and blinks: 8 frames, played slowly.
+           idleRight: AnimationUtils.loadAnimation(
+             STRAWBERRY_IDLE,
+             amount: 8,
+             stepTime: 0.15,
+           ),
+           idleLeft: AnimationUtils.loadAnimation(
+             STRAWBERRY_IDLE,
+             amount: 8,
+             stepTime: 0.15,
+           ),
+         ),
      );
''',
        ),
        CodeStep(
          description:
              'Add the walk animation to the same SimpleDirectionAnimation, after idleLeft, so Berry steps along when it moves.',
          fileName: _DART_FILE_CHARACTERS_COMPANION,
          codeSnippet: '''
animation: SimpleDirectionAnimation(
  ... // idleRight
  idleLeft: AnimationUtils.loadAnimation(
    STRAWBERRY_IDLE,
    amount: 8,
    stepTime: 0.15,
  ),
+   // Walk steps quickly enough to match the speed, so the feet
+   // don't look like they're sliding.
+   runRight: AnimationUtils.loadAnimation(
+     STRAWBERRY_WALK,
+     amount: 4,
+     stepTime: 0.08,
+   ),
+   runLeft: AnimationUtils.loadAnimation(
+     STRAWBERRY_WALK,
+     amount: 4,
+     stepTime: 0.08,
+   ),
),
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to pass a SimpleDirectionAnimation with the strawberry\'s idle and walk sheets to the Companion constructor.',
      proTip:
          'The companion now appears standing on the ground at tile (24, 7). Walk the hero into it and you\'ll pass straight through; it has no hitbox yet, and the next lesson adds one.',
    );
  }
}
