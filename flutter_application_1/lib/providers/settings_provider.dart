import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted app preferences such as the light/dark theme choice.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    _restoreThemeMode();
  }

  static const String _themeModeKey = 'fundilink_theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

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
}
