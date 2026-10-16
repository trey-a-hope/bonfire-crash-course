# Template sync

The lessons in this app teach the code in
[trey-a-hope/bonfire_crash_course_template](https://github.com/trey-a-hope/bonfire_crash_course_template).
The template is the source of truth: whatever its code does, the lessons
should show. This file records how far the lessons have been synced and
which lesson covers which template file.

## Last synced

| Field | Value |
| --- | --- |
| Template commit | `1546017` (Merge pull request #1 from trey-a-hope/fix/hero-attack-animations) |
| Synced on | 2026-10-16 |

## Template file → lessons

| Template file | Lessons (lib/presentation/pages/...) |
| --- | --- |
| `lib/presentation/screens/game_screen.dart` | `3_map/_1_loading_the_map.dart`, `3_map/_2_apply_custom_background.dart` (background param), `4_player/_1_create_player_component.dart` (player param), `4_player/_4_move_and_jump.dart` (Keyboard controller) |
| `lib/presentation/backgrounds/parallax_background.dart` | `3_map/_2_apply_custom_background.dart` |
| `lib/presentation/characters/hero.dart` | `4_player/_1` (class, constructor, animations), `_2` (gravity), `_3` (hitbox), `_4` (keyboard, jump), `_5` (boundaries), `_6_player_attack_system.dart` (attacks) |
| `lib/presentation/characters/util/animation_utils.dart` | `4_player/_1_create_player_component.dart` |
| `lib/core/mixins/screen_boundary_checker.dart` | Default page: never discussed; `4_player/_5` only adds the mixin to Hero |
| `lib/core/constants/globals.dart` | Default page: never discussed; lessons only use its constants by name |
| `lib/core/constants/character_asset.dart` | Ships with the template; concept card in `4_player/_1`, frame counts used in `_6` |
| Folder layout and asset folders | `2_getting_started/project_file_structure.dart` via `lib/presentation/widgets/file_widget_tree.dart` |
| File paths shown on code steps | `lib/core/constants.dart` (`DART_FILE_*`) |

## Rules

- **Default pages** are template files that are already in place when a student
  starts. Lessons never discuss them: no code steps, concepts or notes about their
  contents. Code that only *uses* them (a constant name, `with ScreenBoundaryChecker`,
  `checkBoundaries()`) is fine. Current default pages:
  - `lib/core/constants/globals.dart`
  - `lib/core/mixins/screen_boundary_checker.dart`
- The Project File Structure tree still lists default pages, labelled as default files.
- Every coding lesson has a **Time to Code** message (`timeToCodeStatement`): 1-2
  sentences, starting "You're about to...", naming what the student types in this
  lesson, taken from the template code its steps show.
- Every coding lesson has a **Pro Tip** (`proTip`): 1-2 sentences of quick advice for
  that lesson, grounded in the template code (a gotcha, a tweak to try, or a way to
  check it works). Neither message may discuss a default page.

## Not covered yet

- Companion (Ally) and Foe (Enemy) modules: the template has no NPC or enemy
  code yet, so those lessons are still placeholders.
