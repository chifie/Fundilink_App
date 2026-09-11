import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted app preferences such as the light/dark theme choice.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    _restoreThemeMode();
    _restoreNotifications();
  }

  static const String _themeModeKey = 'fundilink_theme_mode';
  static const String _notificationsKey = 'fundilink_push_notifications';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Reads the saved theme mode, falling back to the system default.
  Future<void> _restoreThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_themeModeKey);
      if (saved == null) return;
      final mode = ThemeMode.values.firstWhere(
        (mode) => mode.name == saved,
        orElse: () => ThemeMode.system,
      );
      if (mode == _themeMode) return;
      _themeMode = mode;
      notifyListeners();
    } catch (_) {
      // Preferences unavailable; keep the system default.
    }
  }

  /// Reads the saved notification preference, defaulting to enabled.
  Future<void> _restoreNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      notifyListeners();
    } catch (_) {
      // Preferences unavailable; keep the default.
    }
  }

  /// Applies [enabled] (dark vs light) immediately and persists the choice.
  Future<void> setDarkMode(bool enabled) async {
    _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, _themeMode.name);
    } catch (_) {
      // Non-fatal: the toggle still applies for this session.
    }
  }

  /// Updates and persists whether push notifications are enabled.
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsKey, enabled);
    } catch (_) {
      // Non-fatal: the choice still applies for this session.
    }
  }
}
