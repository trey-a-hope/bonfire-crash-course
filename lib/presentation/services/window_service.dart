import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:material_ui/material_ui.dart';
import 'package:window_manager/window_manager.dart';

/// A utility service that manages desktop window configuration and lifecycle.
///
/// Uses [windowManager] to configure initial window bounds, frameless title
/// bars, and visibility for desktop targets.
class WindowService {
  /// Initializes and displays the desktop application window.
  ///
  /// Configures default dimensions (1400x900), minimum constraints (1200x720),
  /// centers the window, and keeps the native title bar so the window can be
  /// moved and resized.
  /// Once ready, the window is shown and focused.
  ///
  /// Throws an [UnsupportedError] if executed on a non-desktop platform.
  static Future<void> initializeDesktopWindow(Size size) async {
    if (!PlatformResolver.isDesktop) {
      return;
    }

    await windowManager.ensureInitialized();

    final windowOptions = WindowOptions(
      size: const Size(1400, 900),
      minimumSize: Size(size.width / 2, 720),
      center: true,
      // Keep the native title bar: it provides window dragging, edge
      // resizing, and the minimize/maximize/close buttons. A hidden title
      // bar would need DragToMoveArea/DragToResizeArea widgets instead.
      titleBarStyle: TitleBarStyle.normal,
      fullScreen: false,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
