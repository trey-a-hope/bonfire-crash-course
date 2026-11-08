import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('click opens the full-window viewer and Esc closes it', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: HeroImage(
              imagePath: 'assets/images/module_diagrams/module_3_map.svg',
              width: double.infinity,
              fit: BoxFit.fitWidth,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EnlargedImageViewer), findsNothing);

    await tester.tap(find.byType(HeroImage));
    await tester.pumpAndSettle();
    expect(find.byType(EnlargedImageViewer), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(EnlargedImageViewer), findsNothing);

    // The close button closes it too.
    await tester.tap(find.byType(HeroImage));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close (Esc)'));
    await tester.pumpAndSettle();
    expect(find.byType(EnlargedImageViewer), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
