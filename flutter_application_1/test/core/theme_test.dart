import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme is Material 3 with light brightness', () {
      final theme = AppTheme.lightTheme;
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.light);
    });

    test('dark theme is Material 3 with dark brightness', () {
      final theme = AppTheme.darkTheme;
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.dark);
    });

    test('light theme exposes chip, progress and page transition themes', () {
      final theme = AppTheme.lightTheme;
      expect(theme.chipTheme, isNotNull);
      expect(theme.progressIndicatorTheme, isNotNull);
      expect(theme.pageTransitionsTheme, isNotNull);
      expect(
        theme.pageTransitionsTheme.builders[TargetPlatform.android],
        isA<FadeForwardsPageTransitionsBuilder>(),
      );
    });

    test('dark theme exposes chip, progress and page transition themes', () {
      final theme = AppTheme.darkTheme;
      expect(theme.chipTheme, isNotNull);
      expect(theme.progressIndicatorTheme, isNotNull);
      expect(theme.pageTransitionsTheme, isNotNull);
    });

    test('dark theme carries button and input themes', () {
      final theme = AppTheme.darkTheme;
      expect(theme.elevatedButtonTheme.style, isNotNull);
      expect(theme.outlinedButtonTheme.style, isNotNull);
      expect(theme.inputDecorationTheme, isNotNull);
      expect(theme.snackBarTheme, isNotNull);
      expect(theme.dialogTheme, isNotNull);
    });

    test('themedGradient builds a gradient container', () {
      final widget = AppTheme.themedGradient(child: const Text('hi'));
      expect(widget, isA<Container>());
    });
  });
}