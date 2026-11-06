# Bonfire Crash Course

A desktop course app that teaches you to build a 2D side-scrolling game in Flutter with the [Bonfire](https://pub.dev/packages/bonfire) engine, one lesson at a time. Each lesson pairs a written walkthrough and code steps with a video, and you code along in a GitHub Codespace created from [bonfire_crash_course_template](https://github.com/trey-a-hope/bonfire_crash_course_template).

## Features

- **Six modules, ~30 lessons**: Introduction, Getting Started, Map, Hero (Player), Companion (Ally) and Foe (Enemy), ending with a "Bonfire Crash Course Finished!" page. The full outline lives in `lib/core/pane_config.dart`.
- **Code-along lessons**: each coding lesson leads with its code. The key concepts are chips above the steps: tapping one shows what it does in one line and lights up the code lines it's about, with the full explanation behind "Learn more". On the right, the lesson's result is one line (the full objective and "what you're about to type" are behind "Learn more"), then a one-line pro tip and a button that opens the video walkthrough (`lib/presentation/scaffolds/coding_scaffold.dart`, widgets in `lib/presentation/widgets/lesson/`). Each `Concept` has a `short` line and an optional `codeMatch`, the text that marks its code lines; `test/coding_lessons_test.dart` checks every match is really in the lesson's code.
- **One-click setup**: the Getting Started module walks you through creating a GitHub account, opening a Codespace from the template repo, optionally installing VS Code, the template's file structure and running the game. Each page is short: a looping Rive animation, three quick steps, one button and a one-line tip (widgets in `lib/presentation/widgets/onboarding/`).
- **Play the finished game**: the Introduction's "What the course covers" page opens with a large window that plays the template game from its web build (`TEMPLATE_GAME_URL` in `lib/core/constants.dart`, hosted on Codemagic). It starts loading as soon as the page opens, falls back to "Open in browser" if the page can't load, and lives in `lib/presentation/widgets/game_window.dart`. To point it at a new deploy, change that one constant.
- **Module overviews and completion pages**: every module opens with a diagram of its lessons and closes with milestone badges and the skills you unlocked.
- **Progress navigation**: a sidebar plus next/previous controls that move through lessons in order (`lib/domain/controllers/progress_navigation_controller.dart`).
- **Animated UI**: Lottie animations for module badges and celebrations, and Rive animations (`assets/rive/`).
- **Settings**: app version, open source licenses, video volume and lesson reminders.

## How it works

The app is a `MaterialApp.router` with a dark Material 3 theme. `lib/core/pane_config.dart` defines every module and lesson as a tree of panes, and `lib/core/app_router.dart` turns that tree into `go_router` routes inside a `StatefulShellRoute`, so each lesson keeps its state as you move around. Parent paths redirect to their first lesson, and Settings sits outside the course shell so it doesn't count toward progress. App state such as settings and navigation uses `signals`.

On startup, `lib/main.dart` initializes `media_kit` (lesson videos), the Rive native runtime and the desktop window (`window_manager`) before running the app.

```
lib/
├── core/            # router, pane (lesson) config, constants, layout sizes
├── domain/
│   ├── controllers/ # progress navigation, settings
│   └── models/      # Module, PaneInfo, Concept, MilestoneAchievement
└── presentation/
    ├── pages/       # one folder per module: 1_introduction … 6_final
    ├── scaffolds/   # desktop shell, coding lesson and instructions layouts
    ├── widgets/     # cards, video player, step headers, sidebar tiles
    ├── lotties/     # Lottie animation widgets
    ├── rive/        # Rive animation widgets
    └── services/    # window and modal helpers
```

## Tech stack

- Flutter, Dart SDK `^3.12.2`
- `go_router` for navigation and `signals` for state
- `media_kit` / `media_kit_video` for lesson videos (with macOS and Windows video libs)
- `flutter_inappwebview` for the game window (WKWebView on macOS, WebView2 on Windows; building for Windows needs NuGet on the machine)
- `lottie` and `rive` for animations, `flutter_svg` for module diagrams
- `flutter_highlight` / `highlight` for code snippets
- `window_manager` for desktop window setup, `package_info_plus` for the version label
- `msix` for the Windows installer, `flutter_launcher_icons` for app icons

## Getting started

### Prerequisites

- Flutter SDK with Dart `^3.12.2`
- A desktop toolchain for the platform you're building on (Xcode for macOS, Visual Studio for Windows). Android, iOS, Linux and web folders exist too, but the app is built and styled for desktop.

### Install and run

```sh
flutter pub get
flutter run -d macos     # or -d windows
```

## Testing

```sh
flutter test
```

Tests in `test/` cover the pane config, the module overview page, the settings page and the game window (with a fake web view).

## Building releases

- **Windows**: `dart run msix:create` builds an MSIX installer using the `msix_config` in `pubspec.yaml`.
- **macOS DMG**: the scripts live in `macos/scripts/`. `build_dmg.sh` runs `flutter build macos --release`, and `notarize_dmg.sh` signs and notarizes the build (it also runs on Codemagic). Copy `example.env` to `macos/scripts/.env` and fill in `DEVELOPER_ID_P12` (base64 Developer ID certificate), `DEVELOPER_ID_P12_PASSWORD` and `APP_SPECIFIC_PASSWORD` first; `.env` is gitignored.

## Course tooling

- `tool/diagrams/build_module_diagrams.py` builds the module diagrams from `tool/diagrams/specs/*.json`, writing Excalidraw files to `docs/module_diagrams/` and the SVGs the app shows to `assets/images/module_diagrams/`. Run it with `python3 tool/diagrams/build_module_diagrams.py`.
- `tool/sprites/` holds the generators and previews for the wizard and shark sprite sheets used by the template game (see `tool/sprites/README.md`).
- `tool/rive/build_getting_started.py` builds the five Getting Started animations (`assets/rive/gs_*.riv`). Each has `State Machine 1` and a `reduceMotion` view-model boolean that shows a still pose. Run it with `python3 tool/rive/build_getting_started.py`.
- `scripts/start_rive_tunnel.sh` exposes a local Rive MCP server through ngrok so it can be added as a Claude connector while editing animations.

## Related

- [bonfire_crash_course_template](https://github.com/trey-a-hope/bonfire_crash_course_template): the starter game students build during the course.
