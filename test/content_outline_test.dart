import 'dart:convert';
import 'dart:io';

import 'package:bonfire_crash_course/core/modules/enemy_module.dart';
import 'package:bonfire_crash_course/core/modules/map_module.dart';
import 'package:bonfire_crash_course/core/modules/player_module.dart';
import 'package:bonfire_crash_course/domain/models/module.dart';
import 'package:bonfire_crash_course/presentation/pages/miscellaneous/content_outline/content_outline_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The modules the Content Outline shows, with their diagram spec number.
const _outlineModules = <int, Module>{
  3: MAP_MODULE,
  4: PLAYER_MODULE,
  5: ENEMY_MODULE,
};

void main() {
  testWidgets('Content Outline shows Map, Player and Enemy with lesson counts',
      (tester) async {
    tester.view.physicalSize = const Size(1280, 6000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: ContentOutlinePage()));
    await tester.pump();

    expect(find.text('Map'), findsOneWidget);
    expect(find.text('Player'), findsOneWidget);
    expect(find.text('Enemy'), findsOneWidget);
    expect(find.textContaining('NPC'), findsNothing);
    expect(find.text('3 lessons in this module.'), findsOneWidget);
    expect(find.text('7 lessons in this module.'), findsOneWidget);
    expect(find.text('5 lessons in this module.'), findsOneWidget);
  });

  // Keeps each diagram locked to its module: one diagram column per lesson,
  // and the app copy of the diagram exists.
  for (final entry in _outlineModules.entries) {
    test('Module ${entry.key} diagram has one column per lesson', () {
      final spec = jsonDecode(
        File('tool/diagrams/specs/module_${entry.key}.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      expect(spec['name'], entry.value.moduleName);
      expect((spec['lessons'] as List).length, entry.value.totalSteps);
      final slug = entry.value.moduleName.toLowerCase();
      expect(
        File('assets/images/module_diagrams/module_${entry.key}_$slug.svg')
            .existsSync(),
        isTrue,
      );
    });
  }
}
