import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/domain/controllers/settings_controller.dart';
import 'package:bonfire_crash_course/main.dart';
import 'package:bonfire_crash_course/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

final _introPath = ProgressNavigationController.navigateablePanes.first.path;

Widget _buildApp() => MaterialApp.router(
  routerConfig: GoRouter(
    initialLocation: SettingsPage.path,
    routes: [
      GoRoute(
        path: _introPath,
        builder: (context, state) => const Scaffold(body: Text('Intro page')),
      ),
      GoRoute(
        path: SettingsPage.path,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  ),
);

void main() {
  setUpAll(() async {
    PackageInfo.setMockInitialValues(
      appName: 'Bonfire Crash Course',
      packageName: 'com.io.bonfire_crash_course',
      version: '1.2.3',
      buildNumber: '4',
      buildSignature: '',
    );
    packageInfo = await PackageInfo.fromPlatform();
  });

  setUp(SettingsController.reset);

  Future<void> pumpSettings(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
  }

  testWidgets('shows every settings section', (tester) async {
    await pumpSettings(tester);

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('ABOUT'), findsOneWidget);
    expect(find.text('SOUND'), findsOneWidget);
    expect(find.text('NOTIFICATIONS'), findsOneWidget);
    expect(find.text('ACCOUNT'), findsNothing);
    expect(find.text('Log out'), findsNothing);
  });

  testWidgets('about shows the app version', (tester) async {
    await pumpSettings(tester);

    expect(find.text('Version 1.2.3+4'), findsOneWidget);
  });

  testWidgets('licenses opens the license page directly', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.text('Licenses'));
    await tester.pumpAndSettle();

    expect(find.byType(LicensePage), findsOneWidget);
    expect(find.byType(AboutDialog), findsNothing);
  });

  testWidgets('dragging the slider updates the volume', (tester) async {
    await pumpSettings(tester);
    expect(find.text('80%'), findsOneWidget);

    final slider = find.byKey(const Key('settings_volume_slider'));
    await tester.drag(slider, const Offset(-2000, 0));
    await tester.pumpAndSettle();

    expect(SettingsController.volume.value, 0.0);
    expect(find.text('0%'), findsOneWidget);
    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
  });

  testWidgets('toggling the switch turns lesson reminders off', (tester) async {
    await pumpSettings(tester);
    expect(SettingsController.notificationsEnabled.value, isTrue);

    await tester.tap(find.byKey(const Key('settings_notifications_switch')));
    await tester.pumpAndSettle();

    expect(SettingsController.notificationsEnabled.value, isFalse);
    expect(find.textContaining('Off.'), findsOneWidget);
  });

  testWidgets('back button returns to the first lesson with no history', (
    tester,
  ) async {
    await pumpSettings(tester);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Intro page'), findsOneWidget);
  });

  testWidgets('does not overflow at 200% text scale', (tester) async {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: _buildApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
