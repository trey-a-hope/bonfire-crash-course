import 'package:bonfire_crash_course/core/platform_resolver.dart';
import 'package:bonfire_crash_course/presentation/widgets/sheet_views/_sheet_views.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart' as mac;

// TODO (Trey) - Remove Material here and place at the top of the app.
class AdaptiveModalService {
  static void showSheet(BuildContext context, SheetType type) {
    if (PlatformResolver.isMacOS) {
      _showMacosSheet(context, type);
    } else {
      _showWindowsSheet(context, type);
    }
  }

  static void _showWindowsSheet(BuildContext context, SheetType type) async {
    final size = MediaQuery.sizeOf(context);

    await showDialog<String>(
      context: context,
      builder: (context) => fluent.ContentDialog(
        constraints: BoxConstraints(
          // Note: these are hardcoded values from macos_ui's MacosSheet
          maxWidth: size.width - (2 * 140.0),
          maxHeight: size.height - (2 * 48.0),
        ),
        content: switch (type) {
          SheetType.settings => const SettingsSheetView(),
        },
      ),
    );
  }

  static void _showMacosSheet(BuildContext context, SheetType type) async {
    await mac.showMacosSheet(
      barrierDismissible: true,
      context: context,
      builder: (_) => mac.MacosSheet(
        child: switch (type) {
          SheetType.settings => const SettingsSheetView(),
        },
      ),
    );
  }
}
