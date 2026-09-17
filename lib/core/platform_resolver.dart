/// Utility class for detecting the host operating system platform.
class PlatformResolver {
  /// Toggle this flag to debug on a specific platform.
  static const _debugOnWindows = true;

  /// Checks if the current target platform is Windows.
  static bool get isWindows =>
      _debugOnWindows; // defaultTargetPlatform == TargetPlatform.windows;

  /// Checks if the current target platform is macOS.
  static bool get isMacOS =>
      !_debugOnWindows; //defaultTargetPlatform == TargetPlatform.macOS;

  /// Checks if the app is running on a supported desktop platform (Windows or macOS).
  static bool get isDesktop => isWindows || isMacOS;
}
