import 'package:bonfire_crash_course/core/constants.dart';

import 'player_module.dart';
import 'package:bonfire_crash_course/domain/models/concept.dart';
import 'package:bonfire_crash_course/presentation/scaffolds/coding_scaffold.dart';
import 'package:bonfire_crash_course/presentation/widgets/steps_widget.dart';
import 'package:flutter/material.dart';

class PlayerAttackSystemPage extends StatelessWidget {
  const PlayerAttackSystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CodingScaffold(
      videoUrl:
          'https://pub-d3f44d01ffd44d388d0301d76139d55e.r2.dev/flight.mp4',
      module: PLAYER_MODULE,
      unitStep: 6,
      title: 'Player Attack System',
      objective:
          'Give the hero a close-range melee strike, a projectile attack, and the vision to spot nearby enemies.',
      concepts: [
        Concept(
          title: 'Melee Attack (attack.melee)',
          subtitle:
              'A physical hit right in front of the player. Bonfire spawns a short-lived damage area of the given size; any enemy inside it takes damage and, with withPush enabled, is knocked back.',
        ),
        Concept(
          title: 'Ranged Attack (attack.range)',
          subtitle:
              'Fires a FlyingAttackGameObject projectile in the chosen direction. It damages the first enemy it hits and is destroyed when it reaches a barrier (collision tiles), optionally playing a destroy animation.',
        ),
        Concept(
          title: 'Enemy Vision (vision.seeEnemy)',
          subtitle:
              'Scans for enemies within radiusVision pixels every time it runs. observed receives the list of enemies in sight, and notObserved fires when none are. Narrow visionAngle to make a cone instead of a full 360° circle.',
        ),
      ],
      codeSteps: [
        CodeStep(
          description:
              'Add the WithAttack mixin to the Hero class. This gives the hero the attack API; vision is already built into every Player.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
class Hero ... with WithAttack { ... }
''',
        ),
        CodeStep(
          description:
              'Create a melee attack that damages any enemy directly in front of the hero.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
/// Swings at enemies right in front of the hero.
void _meleeAttack() {
  attack.melee(
    // Life removed from each enemy caught in the hit area.
    damage: 20,
    // Size of the invisible hit area spawned beside the hero.
    size: Vector2.all(32),
    // Knock the enemy back a little when it is hit.
    withPush: true,
  );
}
''',
        ),
        CodeStep(
          description:
              'Create a ranged attack that fires a projectile in the direction the hero is facing.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
/// Sprite sheet for the projectile, relative to assets/images/.
/// Add your own 4-frame, 32x32 sheet (a fireball, an arrow, etc.).
static const _projectile = 'characters/projectile.png';

/// Fires a projectile that flies until it hits an enemy or a wall.
void _rangeAttack() {
  attack.range(
    // Sprite sheet for the projectile while it is flying.
    animation: AnimationUtils.loadAnimation(_projectile),
    // Size of the projectile on screen.
    size: Vector2.all(16),
    // Pixels per second the projectile travels.
    speed: 200,
    damage: 10,
    // Called when the projectile hits something and is removed.
    onDestroy: () {
      // Play a sound, spawn particles, etc.
    },
  );
}
''',
        ),
        CodeStep(
          description:
              'Trigger the attacks from the keyboard: Z for melee and X for the ranged attack.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
@override
bool onKeyboard(
  KeyEvent event,
  Set<LogicalKeyboardKey> keysPressed,
) {
  if (event is KeyDownEvent) {
    if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      _meleeAttack();
      return true; // Handled
    }
    if (event.logicalKey == LogicalKeyboardKey.keyX) {
      _rangeAttack();
      return true; // Handled
    }
  }

  return super.onKeyboard(event, keysPressed);
}
''',
        ),
        CodeStep(
          description:
              'Add the new attack keys to acceptedKeys so the keyboard controller passes them to the hero.',
          fileName: DART_FILE_GAME_SCREEN,
          codeSnippet: '''
acceptedKeys: [
  LogicalKeyboardKey.space,
  LogicalKeyboardKey.keyZ, // Melee attack
  LogicalKeyboardKey.keyX, // Ranged attack
],
''',
        ),
        CodeStep(
          description:
              'Use vision.seeEnemy in update to react when an enemy comes within range.',
          fileName: DART_FILE_CHARACTERS_HERO,
          codeSnippet: '''
/// Seconds left before the hero can auto-attack again.
double _attackCooldown = 0;

@override
void update(double dt) {
  if (gameRef.sceneBuilderStatus.isRunning) return;
  checkBoundaries();

  // Count down the cooldown so the hero does not attack every frame.
  if (_attackCooldown > 0) _attackCooldown -= dt;

  // Look for enemies within 64 pixels of the hero.
  vision.seeEnemy(
    radiusVision: 64,
    observed: (enemies) {
      // An enemy is close: strike it, then wait half a second.
      if (_attackCooldown <= 0) {
        _meleeAttack();
        _attackCooldown = 0.5;
      }
    },
    notObserved: () {
      // No enemies nearby; nothing to do.
    },
  );

  super.update(dt);
}
''',
        ),
      ],
      timeToCodeStatement:
          'Approx. 15 minutes. Press Z and X in your running game to see both attacks, then walk toward an enemy to watch vision trigger the melee strike.',
    );
  }
}
