import 'package:bonfire_crash_course/core/app_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phone_gate/phone_gate.dart';

/// Root app widget that selects the design system framework (Fluent UI vs macos_ui) by platform.
class BonfireCrashCourseApp extends StatelessWidget {
  const BonfireCrashCourseApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    scrollBehavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
    debugShowCheckedModeBanner: false,
    title: 'Bonfire Crash Course',
    theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
    darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
    themeMode: ThemeMode.dark,
    routerConfig: appRouter,
    // Block normal phones: only tablets and unfolded foldables can run the app.
    builder: (context, child) =>
        PhoneGate(size: MediaQuery.sizeOf(context), child: child!),
  );
}
