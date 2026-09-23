import 'package:bonfire_crash_course/presentation/widgets/desktop_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('AdaptiveWindow renders pure Flutter sidebar and content shell', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/page1',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return DesktopScaffold(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/page1',
                  builder: (context, state) => const Text('Page 1 Content'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/page2',
                  builder: (context, state) => const Text('Page 2 Content'),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    // Verify sidebar branding
    expect(find.text('Bonfire Crash Course'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Verify main content
    expect(find.text('Page 1 Content'), findsOneWidget);

    // Verify sidebar categories from pane_config exist
    expect(find.text('Introduction'), findsWidgets);
    expect(find.text('Getting Started'), findsOneWidget);

    // Scroll sidebar ListView to reveal Player
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('Player'), findsOneWidget);
  });

  testWidgets('AdaptiveWindow tapping navigable item switches branch', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/intro/starting',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return DesktopScaffold(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/intro/starting',
                  builder: (context, state) => const Text('Intro Screen 1'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/intro/what-the-course-covers',
                  builder: (context, state) => const Text('Intro Screen 2'),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Intro Screen 1'), findsOneWidget);
    expect(find.text('What The Course Covers'), findsOneWidget);

    // Tap on second lesson item in sidebar
    await tester.tap(find.text('What The Course Covers'));
    await tester.pumpAndSettle();

    // Verify switched to branch 1
    expect(find.text('Intro Screen 2'), findsOneWidget);
  });
}
