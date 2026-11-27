import 'dart:async';
import 'dart:ui';

import 'package:bonfire_crash_course/bonfire_crash_course_app.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rive/rive.dart';

import 'presentation/services/window_service.dart';

late final PackageInfo packageInfo;

Future<void> main() async {
  // Ensure Flutter engine bindings are initialized before async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Rive native runtime used by Rive animations
  await RiveNative.init();

  final display = PlatformDispatcher.instance.displays.first;
  final screen = display.size / display.devicePixelRatio;
  await WindowService.initializeDesktopWindow(screen);
  packageInfo = await PackageInfo.fromPlatform();

  runApp(const BonfireCrashCourseApp());
}
