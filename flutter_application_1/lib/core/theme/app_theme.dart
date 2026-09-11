import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/color_utils.dart';
import 'app_button_styles.dart';
import 'app_card_styles.dart';
import 'app_component_themes.dart';
import 'app_elevation.dart';
import 'app_shapes.dart';
import 'app_text_styles.dart';

/// Application theme configuration with Material 3 light and dark support.
///
/// [AppTheme] is a thin assembly layer: tokens live in [AppTextStyles],
/// [AppShapes], [AppElevation] and the style files, and every component
/// theme is derived from the active [ColorScheme] so light and dark mode
/// stay automatically consistent.
class AppTheme {
  /// Ready-to-use light theme for the app.
  static ThemeData get lightTheme => light();

  /// Ready-to-use dark theme for the app.
  static ThemeData get darkTheme => dark();

  /// Creates a Material 3 light theme configuration.
  static ThemeData light({
    Color? primaryColor,
    Color? scaffoldBackgroundColor,
    Color? errorColor,
    bool useMaterial3 = true,
    VisualDensity? visualDensity,
  }) {
    final scheme = _scheme(
      seedColor: primaryColor ?? AppColors.primary,
      brightness: Brightness.light,
      errorColor: errorColor,
    );
    final textTheme = AppTextStyles.textTheme(scheme.onSurface);

    return _build(
      scheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? scheme.surface,
      useMaterial3: useMaterial3,
      visualDensity: visualDensity,
    );
  }

  /// Creates a Material 3 dark theme configuration.
  static ThemeData dark({
    Color? primaryColor,
    Color? scaffoldBackgroundColor,
    Color? errorColor,
    bool useMaterial3 = true,
    VisualDensity? visualDensity,
  }) {
    final scheme = _scheme(
      seedColor: primaryColor ?? AppColors.primary,
      brightness: Brightness.dark,
      errorColor: errorColor,
    );
    final textTheme = AppTextStyles.textTheme(scheme.onSurface);

    return _build(
      scheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? scheme.surface,
      useMaterial3: useMaterial3,
      visualDensity: visualDensity,
    );
  }

  /// Builds the tonal color scheme from the brand seed color.
  static ColorScheme _scheme({
    required Color seedColor,
    required Brightness brightness,
    Color? errorColor,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    if (errorColor == null) return scheme;
    return scheme.copyWith(error: errorColor);
  }

  /// Assembles the [ThemeData] from M3 component theme builders.
  static ThemeData _build({
    required ColorScheme scheme,
    required TextTheme textTheme,
    required Color scaffoldBackgroundColor,
    required bool useMaterial3,
    VisualDensity? visualDensity,
  }) {
    return ThemeData(
      useMaterial3: useMaterial3,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: textTheme,
      visualDensity: visualDensity,
      splashFactory: InkSparkle.splashFactory,
      highlightColor: scheme.onSurface.withValues(alpha: 0.04),
      splashColor: scheme.onSurface.withValues(alpha: 0.08),
      materialTapTargetSize: MaterialTapTargetSize.padded,

      // Buttons
      elevatedButtonTheme: AppButtonStyles.elevatedTheme(scheme),
      filledButtonTheme: AppButtonStyles.filledTheme(scheme),
      outlinedButtonTheme: AppButtonStyles.outlinedTheme(scheme),
      textButtonTheme: AppButtonStyles.textTheme(scheme),
      segmentedButtonTheme: AppButtonStyles.segmentedTheme(scheme),
      iconButtonTheme: AppButtonStyles.iconTheme(scheme),
      floatingActionButtonTheme: AppComponentThemes.fab(scheme),

      // Cards & containers
      cardTheme: AppCardStyles.elevatedTheme(scheme),

      // Inputs
      inputDecorationTheme: AppComponentThemes.input(scheme, textTheme),
      dropdownMenuTheme: AppComponentThemes.dropdownMenu(scheme, textTheme),

      // Navigation
      appBarTheme: AppComponentThemes.appBar(scheme, textTheme),
      navigationBarTheme: AppComponentThemes.navigationBar(scheme, textTheme),
      navigationRailTheme: AppComponentThemes.navigationRail(scheme),
      navigationDrawerTheme: AppComponentThemes.navigationDrawer(scheme),
      bottomNavigationBarTheme:
          AppComponentThemes.bottomNavigationBar(scheme),
      tabBarTheme: AppComponentThemes.tabBar(scheme, textTheme),

      // Feedback & overlays
      chipTheme: AppComponentThemes.chip(scheme),
      dialogTheme: AppComponentThemes.dialog(scheme, textTheme),
      bottomSheetTheme: AppComponentThemes.bottomSheet(scheme),
      snackBarTheme: AppComponentThemes.snackBar(scheme),
      popupMenuTheme: AppComponentThemes.popupMenu(scheme),
      tooltipTheme: AppComponentThemes.tooltip(scheme, textTheme),
      dividerTheme: AppComponentThemes.divider(scheme),
      listTileTheme: AppComponentThemes.listTile(scheme, textTheme),

      // Controls
      switchTheme: AppComponentThemes.toggle(scheme),
      checkboxTheme: AppComponentThemes.checkbox(scheme),
      radioTheme: AppComponentThemes.radio(scheme),
      progressIndicatorTheme: AppComponentThemes.progress(scheme),
      sliderTheme: AppComponentThemes.slider(scheme),

      pageTransitionsTheme: _pageTransitionsTheme,
    );
  }

  /// Creates a gradient container with theme colors.
  static Widget themedGradient({
    required Widget child,
    List<Color>? colors,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    VoidCallback? onTap,
    double elevation = 0,
  }) {
    final effectiveColors =
        colors ?? const [Color(0xFF0066CC), Color(0xFF004D99)];

    final container = Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: effectiveColors,
        ),
        borderRadius: borderRadius ?? AppShapes.lg,
        boxShadow: elevation > 0 ? AppElevation.shadows(elevation) : null,
      ),
      child: child,
    );

    if (onTap == null) return container;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? AppShapes.lg,
        child: container,
      ),
    );
  }

  /// Brand gradient colors used by [themedGradient] and hero surfaces.
  static List<Color> get brandGradient => const [
        AppColors.primary,
        AppColors.primaryDark,
      ];

  /// Helper kept for widgets that need a quick alpha-blended brand color.
  static Color tint(Color color, int alphaPercent) =>
      ColorUtils.withAlpha(color, alphaPercent);

  /// Consistent screen transition used by default Material routes.
  static const PageTransitionsTheme _pageTransitionsTheme =
      PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
    },
  );
}
