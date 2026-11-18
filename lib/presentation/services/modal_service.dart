import 'package:bonfire_crash_course/main.dart';
import 'package:material_ui/material_ui.dart';

class ModalService {
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
  }) async => showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      final textTheme = theme.textTheme;
      return AlertDialog(
        title: Text(title, style: textTheme.headlineSmall),
        content: Text(message, style: textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Confirm',
              style: textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      );
    },
  );

  static void showAbout(BuildContext context) => showAboutDialog(
    context: context,
    applicationName: 'Bonfire Crash Course',
    applicationVersion: 'v${packageInfo.version}+${packageInfo.buildNumber}',
    applicationIcon: const Icon(Icons.local_fire_department_rounded),
    children: [
      Text(
        'Welcome to the Bonfire Crash Course!',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ],
  );

  static void showAlert(
    BuildContext context, {
    required String title,
    required String message,
  }) => showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      final textTheme = theme.textTheme;
      return AlertDialog(
        title: Text(title, style: textTheme.headlineSmall),
        content: Text(message, style: textTheme.bodyMedium),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      );
    },
  );
}
