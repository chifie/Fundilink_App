import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme is Material 3 and light', () {
      final theme = AppTheme.light();
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.light);
    });

    test('dark theme is Material 3 and dark', () {
      final theme = AppTheme.dark();
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    test('seed color is the FundiLink teal', () {
      expect(AppTheme.lightScheme.primary, isNot(Colors.deepPurple));
    });

    test('dark surfaces form a stepped scale', () {
      final colors = AppTheme.darkScheme;
      expect(
        colors.surfaceContainerLowest.toARGB32(),
        lessThan(colors.surfaceContainerLow.toARGB32()),
      );
      expect(
        colors.surfaceContainerLow.toARGB32(),
        lessThan(colors.surfaceContainer.toARGB32()),
      );
      expect(
        colors.surfaceContainer.toARGB32(),
        lessThan(colors.surfaceContainerHigh.toARGB32()),
      );
    });
  });
}
