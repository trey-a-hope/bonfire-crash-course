import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/_6_player_attack_system.dart';
import 'package:bonfire_crash_course/presentation/pages/4_player/player_module.dart';
import 'package:bonfire_crash_course/presentation/pages/module_completion_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final playerPane = panes.firstWhere((pane) => pane.path == '/player');

  test('attack system lesson comes right after map boundaries', () {
    final paths = ProgressNavigationController.navigateablePanes
        .map((pane) => pane.path)
        .toList();
    final boundariesIndex = paths.indexOf('/player/map-boundaries-for-player');

    expect(paths[boundariesIndex + 1], '/player/player-attack-system');
    expect(paths[boundariesIndex + 2], '/player/congrats');
  });

  test('attack system lesson renders the PlayerAttackSystemPage', () {
    final pane = playerPane.children.firstWhere(
      (pane) => pane.path == '/player/player-attack-system',
    );

    expect(pane.title, 'Player Attack System');
    expect(pane.child, isA<PlayerAttackSystemPage>());
  });

  test('player module step count matches its lessons', () {
    final lessons = playerPane.children.where(
      (pane) => pane.child is! ModuleCompletionPage,
    );

    expect(PLAYER_MODULE.totalSteps, lessons.length);
  });
}
