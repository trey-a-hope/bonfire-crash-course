import 'dart:io';

import 'package:bonfire_crash_course/core/pane_config.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/presentation/pages/content_outline_page.dart';
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

  // Modules open on their first lesson now; their diagrams moved to the
  // Content Outline at the end of the course.
  for (final pane in panes.where((p) => p.path != contentOutlinePath)) {
    test('${pane.title} has no outline page', () {
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

  // The Content Outline: last pane, one page per module with a diagram.
  group('Content Outline', () {
    final outline = panes.last;

    test('is the last pane, right after the finish page', () {
      expect(outline.title, 'Content Outline');
      expect(outline.path, '/content-outline');
      expect(panes[panes.length - 2].path, '/congrats');
      expect(outline.children.map((p) => (p.title, p.path)), [
        ('Map', '/content-outline/map'),
        ('Player', '/content-outline/player'),
        ('NPC (Ally)', '/content-outline/npc'),
      ]);
    });

    // Each outline page's module and lesson count match the real module.
    const moduleFor = {
      '/content-outline/map': 'Map',
      '/content-outline/player': 'Hero (Player)',
      '/content-outline/npc': 'Companion (Ally)',
    };

    for (final entry in moduleFor.entries) {
      test('${entry.key} matches ${entry.value} and its diagram exists', () {
        final page =
            outline.children.firstWhere((p) => p.path == entry.key).child!
                as ContentOutlinePage;
        final module = panes.firstWhere((p) => p.title == entry.value);
        final lessons = module.children.where(
          (p) => p.child is! ModuleCompletionPage,
        );

        expect(File(page.diagramAsset).existsSync(), isTrue);
        expect(page.lessonCount, lessons.length);
      });
    }
  });

  // Previous/Next and the progress bar walk navigateablePanes in order.
  group('navigation order', () {
    final paths = ProgressNavigationController.navigateablePanes
        .map((p) => p.path)
        .toList();

    test('Next from the finish page opens the Content Outline', () {
      final congrats = paths.indexOf('/congrats');

      expect(congrats, isNot(-1));
      expect(paths[congrats + 1], '/content-outline/map');
      expect(paths.last, '/content-outline/npc');
    });

    test('no overview pages are left', () {
      expect(paths.where((p) => p.endsWith('/overview')), isEmpty);
    });

    test('progress reaches 100 on the finish page and stays there', () {
      final congrats = paths.indexOf('/congrats');

      expect(ProgressNavigationController.courseEndIndex, congrats);
      expect(ProgressNavigationController.progressAt(0), 0);
      expect(
        ProgressNavigationController.progressAt(congrats - 1),
        lessThan(100),
      );
      expect(ProgressNavigationController.progressAt(congrats), 100);
      expect(ProgressNavigationController.progressAt(paths.length - 1), 100);
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
