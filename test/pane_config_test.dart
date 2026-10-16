import 'dart:io';

import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/presentation/pages/module_completion_page.dart';
import 'package:bonfire_crash_course/presentation/pages/module_overview_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Modules whose lessons are written. Each module's totalSteps drives the
  // "Step X of Y" badge, so it must match the lessons listed in the sidebar.
  const finishedModules = ['Getting Started', 'Map', 'Hero (Player)'];

  for (final title in finishedModules) {
    test('$title totalSteps matches its lesson count', () {
      final pane = panes.firstWhere((p) => p.title == title);
      final completion = pane.children.last.child! as ModuleCompletionPage;
      // The overview and completion pages are not lessons.
      final lessons = pane.children
          .where(
            (p) =>
                p.child is! ModuleOverviewPage &&
                p.child is! ModuleCompletionPage,
          )
          .length;

      expect(completion.module.totalSteps, lessons);
    });
  }

  // From Map onward, each module starts with an overview page showing its diagram.
  const modulesWithOverview = ['Map', 'Hero (Player)', 'Companion (Ally)'];

  for (final title in modulesWithOverview) {
    test('$title starts with an overview page whose diagram exists', () {
      final pane = panes.firstWhere((p) => p.title == title);
      final overview = pane.children.first.child;

      expect(overview, isA<ModuleOverviewPage>());
      final page = overview! as ModuleOverviewPage;
      expect(File(page.diagramAsset).existsSync(), isTrue);
      final lessons = pane.children
          .skip(1)
          .where((p) => p.child is! ModuleCompletionPage);
      expect(page.lessonCount, lessons.length);
      expect(page.firstLessonTitle, pane.children[1].title);
    });
  }

  for (final title in ['Introduction', 'Getting Started', 'Foe (Enemy)']) {
    test('$title has no overview page', () {
      final pane = panes.firstWhere((p) => p.title == title);

      expect(
        pane.children.map((p) => p.child),
        isNot(contains(isA<ModuleOverviewPage>())),
      );
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
