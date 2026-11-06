import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/presentation/pages/1_introduction/what_the_course_convers.dart';
import 'package:bonfire_crash_course/presentation/widgets/game_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stands in for the real web view, and keeps its callbacks so a test can
/// say when the page has loaded or failed.
class FakeWebView {
  int builds = 0;
  Uri? url;
  VoidCallback? onLoaded;
  VoidCallback? onError;

  Widget build(
    BuildContext context, {
    required Uri url,
    required VoidCallback onLoaded,
    required VoidCallback onError,
  }) {
    builds++;
    this.url = url;
    this.onLoaded = onLoaded;
    this.onError = onError;
    return const ColoredBox(key: Key('fake-webview'), color: Colors.black);
  }
}

void main() {
  late FakeWebView fake;
  late List<Uri> opened;

  setUp(() {
    fake = FakeWebView();
    opened = [];
  });

  Future<void> pumpWindow(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 480,
            child: GameWindow(
              webViewBuilder: fake.build,
              openInBrowser: (url) async => opened.add(url),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('starts loading the game URL right away, with a spinner', (
    tester,
  ) async {
    await pumpWindow(tester);

    expect(fake.builds, 1);
    expect(fake.url, Uri.parse(TEMPLATE_GAME_URL));
    expect(find.byKey(const Key('fake-webview')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading the game…'), findsOneWidget);
    expect(
      find.text('A/D walk · Space jump · S melee · W magic bolt'),
      findsOneWidget,
    );

    fake.onLoaded!();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(const Key('fake-webview')), findsOneWidget);
  });

  testWidgets('the game keeps its size when it starts playing', (tester) async {
    await pumpWindow(tester);
    final webView = find.byKey(const Key('fake-webview'));
    final loadingSize = tester.getSize(webView);

    fake.onLoaded!();
    await tester.pump();

    // A resize while the game starts crashes it, so the size must not change.
    expect(tester.getSize(webView), loadingSize);
  });

  testWidgets(
    'a failed load shows the error with Open in browser and Try again',
    (tester) async {
      await pumpWindow(tester);

      fake.onError!();
      await tester.pump();

      expect(find.text("Couldn't load the game"), findsOneWidget);
      expect(find.byKey(const Key('fake-webview')), findsNothing);

      // Only the error panel's button: the link under the window hides.
      expect(find.text('Open in browser'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Open in browser'));
      expect(opened, [Uri.parse(TEMPLATE_GAME_URL)]);

      await tester.tap(find.text('Try again'));
      await tester.pump();

      expect(find.text("Couldn't load the game"), findsNothing);
      expect(find.text('Loading the game…'), findsOneWidget);
      expect(fake.builds, 2);
    },
  );

  testWidgets('an error after the game is playing leaves it running', (
    tester,
  ) async {
    await pumpWindow(tester);
    fake.onLoaded!();
    await tester.pump();

    fake.onError!();
    await tester.pump();

    expect(find.text("Couldn't load the game"), findsNothing);
    expect(find.byKey(const Key('fake-webview')), findsOneWidget);
  });

  testWidgets('a game that never loads times out to the error', (tester) async {
    await pumpWindow(tester);

    await tester.pump(GameWindow.loadTimeout);

    expect(find.text("Couldn't load the game"), findsOneWidget);
  });

  testWidgets('the Open in browser link under the window opens the game', (
    tester,
  ) async {
    await pumpWindow(tester);

    await tester.tap(find.widgetWithText(TextButton, 'Open in browser'));

    expect(opened, [Uri.parse(TEMPLATE_GAME_URL)]);
  });

  testWidgets('"What the course covers" shows the game window', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WhatTheCourseConvers(gameWebViewBuilder: fake.build),
        ),
      ),
    );

    expect(find.byType(GameWindow), findsOneWidget);
    expect(find.text('Loading the game…'), findsOneWidget);

    // The game leads the page, large, with the five modules underneath.
    final game = tester.getRect(find.byType(GameWindow));
    expect(game.width, greaterThan(1440 * 0.6));
    expect(
      tester.getTopLeft(find.text('Cloud-First Development Setup')).dy,
      greaterThan(game.bottom),
    );
  });
}
