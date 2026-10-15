import 'package:signals/signals_flutter.dart';

/// App-wide user preferences shown on the settings page.
///
/// Values are held in [Signal]s so any widget watching them rebuilds when a
/// preference changes. Preferences live in memory for the current session.
class SettingsController {
  const SettingsController._();

  /// Default course video volume, as a fraction between 0.0 and 1.0.
  static const defaultVolume = 0.8;

  /// Default state of lesson reminder notifications.
  static const defaultNotificationsEnabled = true;

  /// Course video volume, as a fraction between 0.0 and 1.0.
  static final volume = Signal<double>(defaultVolume);

  /// Whether lesson reminder notifications are enabled.
  static final notificationsEnabled = Signal<bool>(defaultNotificationsEnabled);

  /// Updates [volume], clamped to the 0.0 to 1.0 range.
  static void setVolume(double value) => volume.value = value.clamp(0.0, 1.0);

  /// Updates [notificationsEnabled].
  static void setNotificationsEnabled(bool value) =>
      notificationsEnabled.value = value;

  /// Restores every preference to its default value.
  static void reset() {
    volume.value = defaultVolume;
    notificationsEnabled.value = defaultNotificationsEnabled;
  }
}
