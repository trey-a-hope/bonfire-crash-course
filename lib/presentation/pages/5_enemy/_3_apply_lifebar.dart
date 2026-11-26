import '../../../core/modules/enemy_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:material_ui/material_ui.dart';

/// Paths of the template files this page edits.
const _DART_FILE_CHARACTERS_MINOR_ENEMY =
    'lib/presentation/characters/minor_enemy.dart';
const _DART_FILE_CHARACTERS_HERO = 'lib/presentation/characters/hero.dart';

/// Enemy lesson 3, "Apply Lifebar": gives MinorEnemy (50 life, red bar) and
/// HeroPlayer (100 life, green bar) the WithLifeBar mixin, a starting life
/// and a styled life bar. Routed at `/enemy/apply-lifebar` in
/// `lib/core/pane_config.dart`.
class ApplyLifebarPage extends StatelessWidget {
  const ApplyLifebarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: ENEMY_MODULE,
      unitStep: 3,
      title: 'Apply Lifebar',
      outcome:
          'A red life bar floats over the enemy and a green one over the hero, and each shrinks as they take hits.',
      objective:
          'Give MinorEnemy and HeroPlayer a life total and a life bar drawn over their heads.',
      concepts: [
        Concept(
          title: 'WithLifeBar',
          short: 'Draws a life bar over a character.',
          subtitle:
              'A Bonfire mixin that draws a bar over the character showing how much of its life is left. The bar updates on its own every time the character takes damage.',
        ),
        Concept(
          title: 'life',
          short: 'How much damage a character can take.',
          subtitle:
              'The character\'s starting (and maximum) life. Every hit subtracts its damage, and when life reaches 0 the character dies.',
        ),
        Concept(
          title: 'lifeBar.setup',
          short: 'Styles the life bar.',
          subtitle:
              'Sets how the life bar looks, like its background color and its rounded corners.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description: 'Add all imports at the top of minor_enemy.dart.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
// Colors, BorderRadius and Radius, for styling the life bar.
+ import 'package:flutter/material.dart';
''',
        ),
        CodeStep(
          description: 'Add all imports at the top of hero.dart.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
// Colors, BorderRadius and Radius, for styling the life bar.
+ import 'package:flutter/material.dart';
''',
        ),
        CodeStep(
          description:
              'Add the WithLifeBar mixin to the MinorEnemy class, after its other mixins. The list no longer fits on one line, so each mixin gets its own.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
class MinorEnemy extends PlatformEnemy
-     with WithForces, ScreenBoundaryChecker, WithAttack, UseBehavior {
+     with
+         WithForces,
+         ScreenBoundaryChecker,
+         WithAttack,
+         UseBehavior,
+         WithLifeBar {
''',
        ),
        CodeStep(
          description:
              'In the MinorEnemy constructor\'s super(...) call, give the enemy 50 life.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
MinorEnemy(Vector2 position)
    : super(
        position: position,
        size: Vector2.all(TILE_SIZE),
        countJumps: 2,
+         life: 50,
        // Which animation to play for each state and direction.
        animation: PlatformAnimations(
          ...
        ),
      );
''',
        ),
        CodeStep(
          description:
              'Give the MinorEnemy constructor a body, right after super(...), that sets up a red life bar with rounded corners.',
          fileName: _DART_FILE_CHARACTERS_MINOR_ENEMY,
          codeSnippet: '''
MinorEnemy(Vector2 position)
    : super(
        ...
        life: 50,
        animation: PlatformAnimations(
          ...
        ),
-       );
+       ) {
+   lifeBar.setup(
+     backgroundColor: Colors.red,
+     borderRadius: BorderRadius.all(
+       Radius.circular(8),
+     ),
+   );
+ }
''',
        ),
        CodeStep(
          description:
              'Add the WithLifeBar mixin to the HeroPlayer class, after its other mixins.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class HeroPlayer extends PlatformPlayer
    with
        WithForces,
        KeyboardEventListener,
        ScreenBoundaryChecker,
-         WithAttack {
+         WithAttack,
+         WithLifeBar {
''',
        ),
        CodeStep(
          description:
              'In the HeroPlayer constructor\'s super(...) call, give the hero 100 life.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
HeroPlayer(Vector2 position)
    : super(
        position: position,
        size: Vector2.all(TILE_SIZE),
        countJumps: 2,
+         life: 100,
        // Which animation to play for each state and direction.
        animation: PlatformAnimations(
          ...
        ),
      );
''',
        ),
        CodeStep(
          description:
              'Give the HeroPlayer constructor a body, right after super(...), that sets up a green life bar with rounded corners.',
          fileName: _DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
HeroPlayer(Vector2 position)
    : super(
        ...
        life: 100,
        animation: PlatformAnimations(
          ...
        ),
-       );
+       ) {
+   lifeBar.setup(
+     backgroundColor: Colors.green,
+     borderRadius: BorderRadius.all(
+       Radius.circular(8),
+     ),
+   );
+ }
''',
        ),
      ],
      timeToCodeStatement:
          'You\'re about to add WithLifeBar to MinorEnemy and HeroPlayer, give the enemy 50 life and the hero 100, and style a red bar for the enemy and a green bar for the hero.',
      proTip:
          'Change the life values to make fights shorter or longer: with the hero\'s melee doing 20 damage, a 50-life enemy goes down in 3 hits.',
    );
  }
}
