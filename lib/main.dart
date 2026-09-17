import 'package:bonfire_crash_course/core/app_router.dart';
import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:media_kit/media_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'presentation/services/window_service.dart';

late final PackageInfo packageInfo;

Future<void> main() async {
  // Ensure Flutter engine bindings are initialized before async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MediaKit
  MediaKit.ensureInitialized();

  // Set up desktop window properties (size, center, title bar)
  await WindowService.initializeDesktopWindow();

  packageInfo = await PackageInfo.fromPlatform();

  runApp(const DesktopApp());
}

/// Root app widget that selects the design system framework (Fluent UI vs macos_ui) by platform.
class DesktopApp extends StatelessWidget {
  final _title = 'Bonfire Crash Course';
  final _debugShowCheckedModeBanner = false;

  const DesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Windows UI implementation using FluentApp
    if (PlatformResolver.isWindows) {
      return fluent.FluentApp.router(
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          scrollbars: false,
        ),
        debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
        title: _title,
        theme: fluent.FluentThemeData(
          brightness: fluent.Brightness.dark,
          accentColor: fluent.Colors.blue,
        ),
        routerConfig: appRouter,
      );
    }

    // macOS UI implementation using MacosApp
    return macos.MacosApp.router(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      debugShowCheckedModeBanner: _debugShowCheckedModeBanner,
      title: _title,
      theme: macos.MacosThemeData(
        brightness: Brightness.dark,
        accentColor: macos.AccentColor.blue,
      ),
      routerConfig: appRouter,
    );
  }
}

/*
  display - Hero text, splash screens, massive numbers, or promotional banner headlines.
  headline - High-emphasis headers marking major sections or screen-level views.
  title - Medium-emphasis text such as app bar titles, card headers, list tiles, and dialog titles.
  body - Longer-form passages of reading text, paragraphs, descriptions, and default form fields.
  label - Actionable text, button labels, tabs, floating chips, and caption badges.
*/
