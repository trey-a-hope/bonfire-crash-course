import 'dart:ui' show Size;

import 'package:flutter/foundation.dart';

/// Utility class for detecting the current target operating system platform.
///
/// Uses Flutter's [defaultTargetPlatform] rather than `dart:io`, making these
/// checks safe on all targets (including web) and easy to override in tests.
class PlatformResolver {
  /// Whether the current target platform is Windows.
  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;

  /// Whether the current target platform is macOS.
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;

  /// Whether the current target platform is iOS.
  static bool get isIos => defaultTargetPlatform == TargetPlatform.iOS;

  /// Whether the current target platform is Android.
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  /// Whether the app is running on a supported desktop platform
  /// (Windows or macOS).
  static bool get isDesktop => isWindows || isMacOS;

  /// Whether the app is running on a supported mobile platform
  /// (iOS or Android).
  static bool get isMobile => isIos || isAndroid;

  /// Smallest width (in logical pixels) of a screen that can run the app on a
  /// phone. Matches Android's "tablet" threshold (sw600dp): unfolded foldables
  /// and tablets are above it, normal phones are below it.
  static const double minSupportedShortestSide = 600;

  /// True when the app should be blocked: a mobile device whose screen is too
  /// narrow (a normal phone), judged by the shortest side of [size].
  static bool isUnsupportedPhone(Size size) =>
      isMobile && size.shortestSide < minSupportedShortestSide;
}
