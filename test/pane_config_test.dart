import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/presentation/pages/module_completion_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Modules whose lessons are written. Each module's totalSteps drives the
  // "Step X of Y" badge, so it must match the lessons listed in the sidebar.
  const finishedModules = ['Getting Started', 'Map', 'Hero (Player)'];

  for (final title in finishedModules) {
    test('$title totalSteps matches its lesson count', () {
      final pane = panes.firstWhere((p) => p.title == title);
      final completion = pane.children.last.child! as ModuleCompletionPage;
      final lessons = pane.children.length - 1;

      expect(completion.module.totalSteps, lessons);
    });
  }

  test('Player module includes the attack lesson', () {
    final player = panes.firstWhere((p) => p.title == 'Hero (Player)');

    expect(
      player.children.map((p) => p.path),
      contains('/player/player-attack-system'),
    );
  });
}
