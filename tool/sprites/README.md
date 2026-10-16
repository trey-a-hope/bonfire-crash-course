# Character sprites

All character sheets live in `assets/images/characters/`. Each sheet is one row of 32x32 frames
(projectiles are 16x16), with a `_right` and a `_left` version; every left frame is its right frame mirrored.
Previews at 4x are in `previews/`.

## Wizard

| Sheet | Frames | What it shows |
|---|---|---|
| `wizard_idle_*` | 4 | Breathing bob, orb sparkles |
| `wizard_walk_*` | 4 | Walk cycle, robe hem sways |
| `wizard_jump_*` | 6 | Crouch, take off, rise, peak, fall, land with dust |
| `wizard_attack_melee_*` | 5 | Crouch and lift the staff, raise it high, swing, smash with sparks, follow through |
| `wizard_attack_range_*` | 6 | Ready, raise with a charge ring, full charge, thrust, release the bolt, recover |
| `wizard_hurt_*` | 5 | White flash, red knockback with eyes shut, ease back to normal colors |
| `wizard_magic_bolt_*` | 4 (16x16) | Projectile for the range attack |

## Shark

| Sheet | Frames | What it shows |
|---|---|---|
| `shark_idle_*` | 4 | Breathing bob, weapons lowered |
| `shark_walk_*` | 4 | Walk cycle |
| `shark_attack_sword_*` | 4 | Wind up, raise, slash, follow through |
| `shark_attack_axe_*` | 4 | Wind up, overhead, chop, follow through |
| `shark_attack_bite_*` | 5 | Crouch, open wide, lunge, chomp, recover |
| `shark_attack_range_*` | 5 | Inhale, water wells up, spit, spray, recover |
| `shark_hurt_*` | 5 | White flash, red knockback, ease back to normal colors (the first 2 frames are the old 2-frame sheet) |
| `shark_death_*` | 4 | Stagger, kneel and drop weapons, fall, lie still |
| `shark_water_ball_*` | 4 (16x16) | Projectile for the range attack |

`svg/` holds a vector copy of each right-facing shark sheet (one rect per pixel).

## Regenerating

Both scripts need Pillow and are run from the repo root:

```sh
python3 tool/sprites/generate_wizard.py assets/images/characters tool/sprites/previews
python3 tool/sprites/generate_shark_combat.py assets/images/characters assets/images/characters tool/sprites/previews tool/sprites/svg
```

The wizard is drawn pixel by pixel in code. The shark has no draw script for its original sheets, so
`generate_shark_combat.py` builds the bite, spit and hurt frames from its idle and hurt frames.

## Using them in Bonfire

```dart
SpriteAnimationData _data(int amount, double step, {bool loop = true, double size = 32}) =>
    SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: step,
      textureSize: Vector2.all(size),
      loop: loop,
    );

class WizardSprites {
  static Future<SpriteAnimation> meleeRight = SpriteAnimation.load('characters/wizard_attack_melee_right.png', _data(5, 0.08, loop: false));
  static Future<SpriteAnimation> meleeLeft = SpriteAnimation.load('characters/wizard_attack_melee_left.png', _data(5, 0.08, loop: false));
  static Future<SpriteAnimation> rangeRight = SpriteAnimation.load('characters/wizard_attack_range_right.png', _data(6, 0.08, loop: false));
  static Future<SpriteAnimation> rangeLeft = SpriteAnimation.load('characters/wizard_attack_range_left.png', _data(6, 0.08, loop: false));
  static Future<SpriteAnimation> hurtRight = SpriteAnimation.load('characters/wizard_hurt_right.png', _data(5, 0.08, loop: false));
  static Future<SpriteAnimation> hurtLeft = SpriteAnimation.load('characters/wizard_hurt_left.png', _data(5, 0.08, loop: false));
  static Future<SpriteAnimation> boltRight = SpriteAnimation.load('characters/wizard_magic_bolt_right.png', _data(4, 0.1, size: 16));
  static Future<SpriteAnimation> boltLeft = SpriteAnimation.load('characters/wizard_magic_bolt_left.png', _data(4, 0.1, size: 16));
}

class SharkSprites {
  static Future<SpriteAnimation> biteRight = SpriteAnimation.load('characters/shark_attack_bite_right.png', _data(5, 0.08, loop: false));
  static Future<SpriteAnimation> biteLeft = SpriteAnimation.load('characters/shark_attack_bite_left.png', _data(5, 0.08, loop: false));
  static Future<SpriteAnimation> rangeRight = SpriteAnimation.load('characters/shark_attack_range_right.png', _data(5, 0.08, loop: false));
  static Future<SpriteAnimation> rangeLeft = SpriteAnimation.load('characters/shark_attack_range_left.png', _data(5, 0.08, loop: false));
  static Future<SpriteAnimation> hurtRight = SpriteAnimation.load('characters/shark_hurt_right.png', _data(5, 0.08, loop: false));
  static Future<SpriteAnimation> hurtLeft = SpriteAnimation.load('characters/shark_hurt_left.png', _data(5, 0.08, loop: false));
  static Future<SpriteAnimation> waterBallRight = SpriteAnimation.load('characters/shark_water_ball_right.png', _data(4, 0.1, size: 16));
  static Future<SpriteAnimation> waterBallLeft = SpriteAnimation.load('characters/shark_water_ball_left.png', _data(4, 0.1, size: 16));
}
```

Play an attack or hurt sheet once with `animation?.playOnce(WizardSprites.meleeRight)` (pick the `Left`
version when `lastDirectionHorizontal` is left). For a range attack, launch the 16x16 projectile on the
range sheet's release frame (frame 5 for the wizard, frame 3 for the shark) so it picks up where the
in-frame bolt or water ball leaves off.
