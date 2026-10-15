import 'package:bonfire_crash_course/core/gap_sizes.dart';
import 'package:bonfire_crash_course/domain/controllers/progress_navigation_controller.dart';
import 'package:bonfire_crash_course/domain/controllers/settings_controller.dart';
import 'package:bonfire_crash_course/main.dart';
import 'package:bonfire_crash_course/presentation/services/modal_service.dart';
import 'package:bonfire_crash_course/presentation/widgets/settings_section.dart';
import 'package:bonfire_crash_course/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals/signals_flutter.dart';

/// The settings page, opened from the sidebar footer.
///
/// Groups preferences into About, Sound, Notifications, and Account sections,
/// styled with the same dark surfaces and accent tints as the desktop shell.
class SettingsPage extends StatelessWidget {
  /// The route path for the settings page.
  static const path = '/settings';

  /// Creates the [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1B1B1E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          surface: Color(0xFF141416),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1E),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720.0),
              child: ListView(
                padding: const EdgeInsets.all(32.0),
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Back',
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white70,
                        ),
                        onPressed: () => _close(context),
                      ),
                      GapSizes.smallGap,
                      Text(
                        'Settings',
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GapSizes.xlGap,
                  const _AboutSection(),
                  GapSizes.largeGap,
                  const _VolumeSection(),
                  GapSizes.largeGap,
                  const _NotificationsSection(),
                  GapSizes.largeGap,
                  const _AccountSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns to the previous page, or to the first lesson if there is none.
  static void _close(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(ProgressNavigationController.navigateablePanes.first.path);
    }
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) => SettingsSection(
    title: 'About',
    children: [
      SettingsTile(
        icon: Icons.local_fire_department_rounded,
        color: Colors.orangeAccent,
        title: 'Bonfire Crash Course',
        subtitle: 'Version ${packageInfo.version}+${packageInfo.buildNumber}',
      ),
      SettingsTile(
        icon: Icons.info_outline_rounded,
        color: Colors.cyanAccent,
        title: 'About this app',
        subtitle: 'Credits and open source licenses',
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.white38,
        ),
        onTap: () => ModalService.showAbout(context),
      ),
    ],
  );
}

class _VolumeSection extends SignalWidget {
  const _VolumeSection();

  @override
  Widget build(BuildContext context) {
    final volume = SettingsController.volume.value;
    final percent = (volume * 100).round();

    return SettingsSection(
      title: 'Sound',
      children: [
        SettingsTile(
          icon: switch (volume) {
            0.0 => Icons.volume_off_rounded,
            < 0.5 => Icons.volume_down_rounded,
            _ => Icons.volume_up_rounded,
          },
          title: 'Volume',
          subtitle: 'Playback volume for course videos',
          trailing: Text(
            '$percent%',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: Slider(
            key: const Key('settings_volume_slider'),
            value: volume,
            divisions: 20,
            label: '$percent%',
            semanticFormatterCallback: (value) => '${(value * 100).round()}%',
            onChanged: SettingsController.setVolume,
          ),
        ),
      ],
    );
  }
}

class _NotificationsSection extends SignalWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context) {
    final enabled = SettingsController.notificationsEnabled.value;

    return SettingsSection(
      title: 'Notifications',
      children: [
        SettingsTile(
          icon: enabled
              ? Icons.notifications_active_rounded
              : Icons.notifications_off_rounded,
          color: Colors.amberAccent,
          title: 'Lesson reminders',
          subtitle: enabled
              ? 'On. We will remind you to pick up where you left off.'
              : 'Off. You will not get lesson reminders.',
          trailing: Switch(
            key: const Key('settings_notifications_switch'),
            value: enabled,
            onChanged: SettingsController.setNotificationsEnabled,
          ),
          onTap: () => SettingsController.setNotificationsEnabled(!enabled),
        ),
      ],
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  Future<void> _logout(BuildContext context) async {
    final confirmed = await ModalService.showConfirmation(
      context,
      title: 'Log out?',
      message:
          'Your settings will be reset and you will return to the start of the course.',
    );
    if (confirmed != true || !context.mounted) return;

    SettingsController.reset();
    context.go(ProgressNavigationController.navigateablePanes.first.path);
  }

  @override
  Widget build(BuildContext context) => SettingsSection(
    title: 'Account',
    children: [
      SettingsTile(
        key: const Key('settings_logout_tile'),
        icon: Icons.logout_rounded,
        color: Colors.redAccent,
        title: 'Log out',
        subtitle: 'Reset your settings and return to the introduction',
        isDestructive: true,
        onTap: () => _logout(context),
      ),
    ],
  );
}
