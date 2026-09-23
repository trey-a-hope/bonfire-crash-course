import 'package:bonfire_crash_course/main.dart';
import 'package:flutter/material.dart';

class ModalService {
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
  }) async => showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Confirm'),
        ),
      ],
    ),
  );

  static void showAbout(BuildContext context) => showAboutDialog(
    context: context,
    applicationName: 'Bonfire Crash Course',
    applicationVersion: 'v${packageInfo.version}+${packageInfo.buildNumber}',
    applicationIcon: const Icon(Icons.local_fire_department_rounded),
    children: [const Text('Welcome to the Bonfire Crash Course!')],
  );

  static void showAlert(
    BuildContext context, {
    required String title,
    required String message,
  }) => showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
