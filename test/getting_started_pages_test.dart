import 'package:bonfire_crash_course/core/constants.dart';
import 'package:bonfire_crash_course/presentation/pages/2_getting_started/_getting_started.dart';
import 'package:bonfire_crash_course/presentation/rive/getting_started/getting_started_rive.dart';
import 'package:bonfire_crash_course/presentation/widgets/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The native Rive runtime isn't available under `flutter test`, so every
  // animation shows its fallback icon.
  setUp(() => GettingStartedRive.loadFile = (_) async => null);

  Future<void> pumpPage(WidgetTester tester, Widget page) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: page)));
    await tester.pumpAndSettle();
  }

  /// The step texts on the page, in order.
  List<String> stepsOn(WidgetTester tester) => tester
      .widgetList<QuickStepTile>(find.byType(QuickStepTile))
      .map((tile) => tile.text)
      .toList();

  void expectShortSteps(List<String> steps) {
    expect(steps.length, inInclusiveRange(1, 3));
    for (final step in steps) {
      expect(step.split(' ').length, lessThanOrEqualTo(8), reason: step);
    }
  }

  testWidgets('Create an Account on GitHub: animation, 3 steps, one button', (
    tester,
  ) async {
    await pumpPage(tester, const CreateAccountOnGithub());

    final hero = tester.widget<AnimatedHeroCard>(find.byType(AnimatedHeroCard));
    expect(hero.scene, GettingStartedScene.githubAccount);
    expectShortSteps(stepsOn(tester));
    final button = tester.widget<OpenLinkButton>(find.byType(OpenLinkButton));
    expect(button.title, 'Go to GitHub Sign Up');
    expect(button.url, 'https://github.com/signup');
    expect(find.byType(OneLineTip), findsOneWidget);
    // The old reading is gone.
    expect(find.text('Free Developer Tier'), findsNothing);
    expect(find.text('Why Do You Need a GitHub Account?'), findsNothing);
  });

  testWidgets('Create a Codespace: animation, 3 steps, codespace button', (
    tester,
  ) async {
    await pumpPage(tester, const CreateACodespace());

    final hero = tester.widget<AnimatedHeroCard>(find.byType(AnimatedHeroCard));
    expect(hero.scene, GettingStartedScene.codespace);
    expectShortSteps(stepsOn(tester));
    final button = tester.widget<OpenLinkButton>(find.byType(OpenLinkButton));
    expect(button.url, CODE_SPACES_TEMPLATE_URL);
    expect(find.text('Visual Walkthrough'), findsNothing);
    expect(find.text('What is GitHub Codespaces?'), findsNothing);
  });

  testWidgets('Install VS Code switches between macOS and Windows', (
    tester,
  ) async {
    await pumpPage(tester, const InstallVSCode());

    final hero = tester.widget<AnimatedHeroCard>(find.byType(AnimatedHeroCard));
    expect(hero.scene, GettingStartedScene.vscode);
    expect(find.text('Cloud vs. Local Setup'), findsNothing);

    await tester.tap(find.text('macOS'));
    await tester.pumpAndSettle();
    expect(stepsOn(tester), InstallVSCode.macSteps);
    expectShortSteps(stepsOn(tester));
    var button = tester.widget<OpenLinkButton>(find.byType(OpenLinkButton));
    expect(button.title, 'Download for macOS');
    expect(button.url, VSCODE_DOWNLOAD_MACOS);

    await tester.tap(find.text('Windows'));
    await tester.pumpAndSettle();
    expect(stepsOn(tester), InstallVSCode.windowsSteps);
    expectShortSteps(stepsOn(tester));
    button = tester.widget<OpenLinkButton>(find.byType(OpenLinkButton));
    expect(button.title, 'Download for Windows');
    expect(button.url, VSCODE_DOWNLOAD_WINDOWS);
  });

  testWidgets('Project File Structure shows the hint until a file is picked', (
    tester,
  ) async {
    await pumpPage(tester, const ProjectFileStructure());

    expect(find.byType(Placeholder), findsNothing);
    final hero = tester.widget<AnimatedHeroCard>(find.byType(AnimatedHeroCard));
    expect(hero.scene, GettingStartedScene.fileStructure);
    expect(find.text('Tap a file to see what it does'), findsOneWidget);

    // The tree starts fully open.
    await tester.ensureVisible(find.text('main.dart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('main.dart'));
    await tester.pumpAndSettle();

    expect(find.byType(AnimatedHeroCard), findsNothing);
    expect(
      find.textContaining('The entry point of the application'),
      findsOneWidget,
    );
  });

  testWidgets('Run the App copies the run command', (tester) async {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await pumpPage(tester, const RunApp());

    final hero = tester.widget<AnimatedHeroCard>(find.byType(AnimatedHeroCard));
    expect(hero.scene, GettingStartedScene.runGame);
    expectShortSteps(stepsOn(tester));
    expect(find.text(RunApp.runCommand), findsOneWidget);
    expect(find.text('Getting Started Complete! 🎉'), findsNothing);

    await tester.tap(find.text('Copy'));
    await tester.pump();
    expect(copied, [RunApp.runCommand]);
    expect(find.text('Copied!'), findsOneWidget);

    await tester.pump(CommandBox.copiedFor);
    expect(find.text('Copy'), findsOneWidget);
  });

  testWidgets('steps slide in, or appear at once with reduced motion', (
    tester,
  ) async {
    const steps = QuickSteps(steps: ['One', 'Two', 'Three']);

    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: steps)));
    double opacityOf(String text) => tester
        .widget<Opacity>(
          find.ancestor(of: find.text(text), matching: find.byType(Opacity)),
        )
        .opacity;
    expect(opacityOf('Three'), 0);
    await tester.pumpAndSettle();
    expect(opacityOf('Three'), 1);

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(body: QuickSteps(steps: ['A', 'B', 'C'])),
        ),
      ),
    );
    expect(opacityOf('C'), 1);
  });

  testWidgets('an animation that cannot load shows its fallback icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 480,
            child: AnimatedHeroCard(scene: GettingStartedScene.codespace),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('getting-started-rive-fallback')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(GettingStartedScene.codespace.semanticLabel),
      findsOneWidget,
    );
  });

  test('every scene points at a bundled .riv file', () {
    for (final scene in GettingStartedScene.values) {
      expect(scene.assetPath, startsWith('assets/rive/gs_'));
      expect(scene.assetPath, endsWith('.riv'));
    }
  });
}
