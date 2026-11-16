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
    expect(button.url, CreateACodespace.CODE_SPACES_TEMPLATE_URL);
    expect(find.text('Visual Walkthrough'), findsNothing);
    expect(find.text('What is GitHub Codespaces?'), findsNothing);
  });

  // for (final (platform, install) in [
  //   (TargetPlatform.macOS, VSCodeInstall.macOS),
  //   (TargetPlatform.windows, VSCodeInstall.windows),
  //   (TargetPlatform.linux, VSCodeInstall.other),
  // ]) {
  //   testWidgets('Install VS Code shows only the ${platform.name} steps', (
  //     tester,
  //   ) async {
  //     debugDefaultTargetPlatformOverride = platform;
  //     try {
  //       await pumpPage(tester, const InstallVSCode());

  //       final hero = tester.widget<AnimatedHeroCard>(
  //         find.byType(AnimatedHeroCard),
  //       );
  //       expect(hero.scene, GettingStartedScene.vscode);
  //       expect(find.text('Cloud vs. Local Setup'), findsNothing);

  //       // No platform toggle any more.
  //       expect(find.text('macOS'), findsNothing);
  //       expect(find.text('Windows'), findsNothing);

  //       expect(stepsOn(tester), install.steps);
  //       expectShortSteps(stepsOn(tester));
  //       final button = tester.widget<OpenLinkButton>(
  //         find.byType(OpenLinkButton),
  //       );
  //       expect(button.title, install.buttonTitle);
  //       expect(button.url, install.url);
  //     } finally {
  //       debugDefaultTargetPlatformOverride = null;
  //     }
  //   });
  // }

  // test('Install VS Code links every platform to the download page', () {
  //   expect(VSCodeInstall.macOS.url, VSCODE_DOWNLOAD_PAGE);
  //   expect(VSCodeInstall.windows.url, VSCODE_DOWNLOAD_PAGE);
  //   expect(VSCodeInstall.other.url, VSCODE_DOWNLOAD_PAGE);
  //   expect(
  //     VSCodeInstall.forPlatform(TargetPlatform.fuchsia),
  //     VSCodeInstall.other,
  //   );
  // });

  // testWidgets(
  //   'Starter Project Files: animation left, tree right, file info below',
  //   (tester) async {
  //     await pumpPage(tester, const StarterProjectFilesPage());

  //     expect(find.text('Starter Project Files'), findsOneWidget);
  //     expect(find.text(StarterProjectFilesPage.note), findsOneWidget);

  //     expect(find.byType(Placeholder), findsNothing);
  //     final hero = tester.widget<AnimatedHeroCard>(
  //       find.byType(AnimatedHeroCard),
  //     );
  //     expect(hero.scene, GettingStartedScene.fileStructure);
  //     expect(find.text('Tap a file to see what it does'), findsOneWidget);

  //     // The tree starts fully open.
  //     await tester.ensureVisible(find.text('main.dart'));
  //     await tester.pumpAndSettle();
  //     await tester.tap(find.text('main.dart'));
  //     await tester.pumpAndSettle();

  //     // The animation stays on the left, with the explanation under it, and
  //     // the tree sits on the right.
  //     final heroRect = tester.getRect(find.byType(AnimatedHeroCard));
  //     final info = find.textContaining('The entry point of the application');
  //     expect(info, findsOneWidget);
  //     expect(find.text('Tap a file to see what it does'), findsNothing);
  //     expect(tester.getTopLeft(info).dy, greaterThan(heroRect.bottom));
  //     expect(tester.getTopLeft(info).dx, lessThan(heroRect.right));
  //     expect(
  //       tester
  //           .getTopLeft(
  //             find.descendant(
  //               of: find.byType(FileTreeWidget),
  //               matching: find.text('main.dart'),
  //             ),
  //           )
  //           .dx,
  //       greaterThan(heroRect.right),
  //     );
  //   },
  // );

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

  testWidgets(
    'every scene is a bundled Rive file with the names the app uses',
    (tester) async {
      // The native runtime can't run here, so check the bytes: a Rive file
      // stores its artboard, state machine and property names as plain text.
      bool contains(List<int> bytes, String text) {
        final needle = text.codeUnits;
        for (var i = 0; i <= bytes.length - needle.length; i++) {
          var match = true;
          for (var j = 0; j < needle.length && match; j++) {
            match = bytes[i + j] == needle[j];
          }
          if (match) return true;
        }
        return false;
      }

      for (final scene in GettingStartedScene.values) {
        final data = await tester.runAsync(
          () => rootBundle.load(scene.assetPath),
        );
        final bytes = data!.buffer.asUint8List();
        expect(String.fromCharCodes(bytes.take(4)), 'RIVE', reason: scene.name);
        for (final name in [
          scene.artboardName,
          GettingStartedRive.stateMachineName,
          GettingStartedRive.reduceMotionProperty,
        ]) {
          expect(contains(bytes, name), isTrue, reason: '${scene.name}: $name');
        }
      }
    },
  );
}
