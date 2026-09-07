import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsProvider theme', () {
    test('defaults to system theme when nothing is saved', () async {
      SharedPreferences.setMockInitialValues({});
      final settings = SettingsProvider();
      await pumpEventQueue();
      expect(settings.themeMode, ThemeMode.system);
    });

    test('restores a saved dark mode preference', () async {
      SharedPreferences.setMockInitialValues({
        'fundilink_theme_mode': 'dark',
      });
      final settings = SettingsProvider();
      await pumpEventQueue();
      expect(settings.isDarkMode, isTrue);
    });

    test('setDarkMode applies immediately and persists', () async {
      SharedPreferences.setMockInitialValues({});
      final first = SettingsProvider();
      await pumpEventQueue();
      await first.setDarkMode(true);
      expect(first.isDarkMode, isTrue);

      final restored = SettingsProvider();
      await pumpEventQueue();
      expect(restored.isDarkMode, isTrue);
    });
  });

  group('SettingsProvider notifications', () {
    test('defaults to notifications enabled', () async {
      SharedPreferences.setMockInitialValues({});
      final settings = SettingsProvider();
      await pumpEventQueue();
      expect(settings.notificationsEnabled, isTrue);
    });

    test('restores a disabled preference', () async {
      SharedPreferences.setMockInitialValues({
        'fundilink_push_notifications': false,
      });
      final settings = SettingsProvider();
      await pumpEventQueue();
      expect(settings.notificationsEnabled, isFalse);
    });

    test('setNotificationsEnabled applies immediately and persists', () async {
      SharedPreferences.setMockInitialValues({});
      final first = SettingsProvider();
      await pumpEventQueue();
      await first.setNotificationsEnabled(false);
      expect(first.notificationsEnabled, isFalse);

      final restored = SettingsProvider();
      await pumpEventQueue();
      expect(restored.notificationsEnabled, isFalse);
    });
  });
}
