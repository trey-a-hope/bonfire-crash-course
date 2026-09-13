import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// A utility service that manages desktop window configuration and lifecycle.
///
/// Uses [windowManager] to configure initial window bounds, frameless title
/// bars, and visibility for desktop targets.
class WindowService {
  /// Initializes and displays the desktop application window.
  ///
  /// Configures default dimensions (1400x900), minimum constraints (1200x720),
  /// centers the window, and hides the native title bar for custom styling.
  /// Once ready, the window is shown and focused.
  ///
  /// Throws an [UnsupportedError] if executed on a non-desktop platform.
  static Future<void> initializeDesktopWindow() async {
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
}
