import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bonfire_crash_course/presentation/widgets/hero_image.dart';

void main() {
  testWidgets('ImageWithCaption opens and closes via close button', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              child: HeroImage(
                imagePath: 'assets/images/images.jpeg',
                caption: 'Test caption',
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test caption'), findsOneWidget);
    expect(find.byType(Hero), findsOneWidget);

    // Tap to open
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(EnlargedImageViewer), findsOneWidget);
    expect(find.byTooltip('Close (Esc)'), findsOneWidget);

    // Tap close button
    await tester.tap(find.byTooltip('Close (Esc)'));
    await tester.pumpAndSettle();

    expect(find.byType(EnlargedImageViewer), findsNothing);
  });

  testWidgets('ImageWithCaption closes via Escape key', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              child: HeroImage(
                imagePath: 'assets/images/images.jpeg',
                caption: 'Escape test',
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
    expect(find.byType(EnlargedImageViewer), findsOneWidget);

    // Press Escape
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.byType(EnlargedImageViewer), findsNothing);
  });

  testWidgets('ImageWithCaption closes via backdrop tap', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              child: HeroImage(
                imagePath: 'assets/images/images.jpeg',
                caption: 'Backdrop test',
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
    expect(find.byType(EnlargedImageViewer), findsOneWidget);

    // Tap top-left corner backdrop (away from center content)
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.byType(EnlargedImageViewer), findsNothing);
  });

  testWidgets('Multiple HeroImage widgets in the same subtree do not conflict', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
            children: [
              HeroImage(
                imagePath: 'assets/images/images.jpeg',
                caption: 'Image 1',
              ),
              HeroImage(
                imagePath: 'assets/images/images.jpeg',
                caption: 'Image 2',
              ),
              HeroImage(
                imagePath: 'assets/images/images.jpeg',
                caption: 'Image 3',
              ),
            ],
          ),
        ),
      ),
    ),
  );

    expect(find.byType(HeroImage), findsNWidgets(3));
    expect(find.byType(Hero), findsNWidgets(3));
  });
}

