import 'package:flutter/foundation.dart';

/// Utility class for detecting the host operating system platform.
class PlatformResolver {
  /// Checks if the current target platform is Windows.
  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;

  /// Checks if the current target platform is macOS.
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;

  /// Checks if the app is running on a supported desktop platform (Windows or macOS).
  static bool get isDesktop => isWindows || isMacOS;
}
