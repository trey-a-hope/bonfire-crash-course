import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/presentation/widgets/adaptive_window.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';

late final PackageInfo packageInfo;

Future<void> main() async {
  // Ensure Flutter engine bindings are initialized before async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MediaKit
  MediaKit.ensureInitialized();

  // Set up desktop window properties (size, center, title bar)
  await _initializeDesktopWindow();

  packageInfo = await PackageInfo.fromPlatform();

  runApp(const DesktopApp());
}

/// Initializes window options and window manager settings for desktop platforms.
Future<void> _initializeDesktopWindow() async {
  if (!PlatformResolver.isDesktop) {
    throw UnsupportedError('This app only supports desktop platforms.');
  }

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1400, 900),
    minimumSize: Size(1200, 720),
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
    fullScreen: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

/// Root app widget that selects the design system framework (Fluent UI vs macos_ui) by platform.
class DesktopApp extends StatelessWidget {
  final _title = 'Bonfire Crash Course';
  final _debugShowCheckedModeBanner = false;

  const DesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Windows UI implementation using FluentApp
    final windowsApp = fluent.FluentApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
      title: _title,
      theme: fluent.FluentThemeData(
        brightness: fluent.Brightness.dark,
        accentColor: fluent.Colors.blue,
      ),
      home: const AdaptiveWindow(),
    );

    // macOS UI implementation using MacosApp
    final macosApp = MacosApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
      title: _title,
      theme: MacosThemeData(
        brightness: Brightness.dark,
        accentColor: AccentColor.blue,
      ),
      home: const AdaptiveWindow(),
    );

    return PlatformResolver.isWindows ? windowsApp : macosApp;
  }
}
