import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/pages/content_outline/content_outline_page.dart';
import 'package:bonfire_crash_course/presentation/pages/module_completion_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Modules whose lessons are written. Each module's totalSteps drives the
  // "Step X of Y" badge, so it must match the lessons listed in the sidebar.
  const finishedModules = [
    'Getting Started',
    'Map',
    'Hero (Player)',
    'Companion (Ally)',
  ];

  for (final title in finishedModules) {
    test('$title totalSteps matches its lesson count', () {
      final pane = panes.firstWhere((p) => p.title == title);
      final completion = pane.children.last.child! as ModuleCompletionPage;
      // The completion page is not a lesson.
      final lessons = pane.children
          .where((p) => p.child is! ModuleCompletionPage)
          .length;

      expect(completion.module.totalSteps, lessons);
    });
  }

  // Modules open on their first lesson now; their diagrams live on the
  // Content Outline page, a sidebar footer link outside the course panes.
  for (final pane in panes) {
    test('${pane.title} has no outline page', () {
      expect(pane.child, isNot(isA<ContentOutlinePage>()));
      expect(
        pane.children.map((p) => p.child),
        isNot(contains(isA<ContentOutlinePage>())),
      );
    });
  }

  test('Map, Player and NPC open on their first lesson', () {
    String firstPath(String title) =>
        panes.firstWhere((p) => p.title == title).children.first.path;

    expect(firstPath('Map'), '/map/loading-the-map');
    expect(firstPath('Hero (Player)'), '/player/player-component');
    expect(firstPath('Companion (Ally)'), '/npc/companion-component');
  });

  // Previous/Next and the progress bar walk navigateablePanes in order.
  group('navigation order', () {
    final paths = ProgressNavigationController.navigateablePanes
        .map((p) => p.path)
        .toList();

    test('the finish page is the last pane, so progress ends at 100%', () {
      expect(panes.last.title, 'Bonfire Crash Course Finished!');
      expect(paths.last, '/congrats');
    });

    test('the Content Outline is not in Previous/Next or progress', () {
      expect(panes.map((p) => p.title), isNot(contains('Content Outline')));
      expect(
        paths.where((p) => p.startsWith(ContentOutlinePage.path)),
        isEmpty,
      );
    });

    test('no overview pages are left', () {
      expect(paths.where((p) => p.endsWith('/overview')), isEmpty);
    });
  });

  test('Companion module ends with the cutscene lesson', () {
    final companion = panes.firstWhere((p) => p.title == 'Companion (Ally)');
    final lessons = companion.children
        .where((p) => p.child is! ModuleCompletionPage)
        .toList();

    expect(lessons.last.path, '/npc/companion-cutscene');
    expect(lessons.last.title, 'Berry\'s First-Meeting Cutscene');
  });

  test('Player module includes the attack lesson', () {
    final player = panes.firstWhere((p) => p.title == 'Hero (Player)');

    expect(
      player.children.map((p) => p.path),
      contains('/player/player-attack-system'),
    );
  });
}
