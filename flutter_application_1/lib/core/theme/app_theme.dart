import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

/// Application theme configuration with light and dark mode support.
class AppTheme {
  /// Ready-to-use light theme for the app.
  static ThemeData get lightTheme => light();

  /// Ready-to-use dark theme for the app.
  static ThemeData get darkTheme => dark();

  /// Creates a light theme configuration.
  static ThemeData light({
    Color? primaryColor,
    Color? scaffoldBackgroundColor,
    Color? errorColor,
    TextTheme? textTheme,
    AppBarTheme? appBarTheme,
    CardThemeData? cardTheme,
    InputDecorationTheme? inputDecorationTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    TextButtonThemeData? textButtonTheme,
    FloatingActionButtonThemeData? fabTheme,
    IconThemeData? iconTheme,
    DividerThemeData? dividerTheme,
    BottomNavigationBarThemeData? bottomNavTheme,
    TabBarThemeData? tabBarTheme,
    SnackBarThemeData? snackbarTheme,
    DialogThemeData? dialogTheme,
    PopupMenuThemeData? popupMenuTheme,
    ListTileThemeData? listTileTheme,
    NavigationBarThemeData? navigationBarTheme,
    bool useMaterial3 = true,
    VisualDensity? visualDensity,
  }) {
    final primary = primaryColor ?? const Color(0xFF0066CC);
    final surface = scaffoldBackgroundColor ?? const Color(0xFFFAFAFA);

    return ThemeData(
      useMaterial3: useMaterial3,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: ColorUtils.lighten(primary, 0.5),
        onPrimaryContainer: primary,
        secondary: const Color(0xFF625B71),
        onSecondary: Colors.white,
        secondaryContainer: ColorUtils.lighten(const Color(0xFF625B71), 0.6),
        onSecondaryContainer: const Color(0xFF625B71),
        tertiary: const Color(0xFF7D5260),
        onTertiary: Colors.white,
        tertiaryContainer: ColorUtils.lighten(const Color(0xFF7D5260), 0.6),
        onTertiaryContainer: const Color(0xFF7D5260),
        surface: surface,
        onSurface: const Color(0xFF1C1B1F),
        surfaceContainerHighest: const Color(0xFFE7E0EC),
        onSurfaceVariant: const Color(0xFF49454F),
        error: errorColor ?? const Color(0xFFBA1A1A),
        onError: Colors.white,
        errorContainer: const Color(0xFFFFDAD6),
        onErrorContainer: const Color(0xFF410002),
        outline: const Color(0xFF79747E),
        outlineVariant: const Color(0xFFCAC4D0),
      ),
      scaffoldBackgroundColor: surface,
      textTheme: textTheme ??
          const TextTheme(
            displayLarge: TextStyle(
              fontSize: 57,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.25,
            ),
            displayMedium: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w400,
            ),
            displaySmall: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
            ),
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
            ),
            headlineMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
            ),
            headlineSmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
            titleLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
            titleSmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
            ),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4,
            ),
            labelLarge: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
            labelMedium: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
            labelSmall: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
      appBarTheme: appBarTheme ??
          AppBarTheme(
            backgroundColor: surface,
            foregroundColor: const Color(0xFF1C1B1F),
            elevation: 0,
            scrolledUnderElevation: 2,
            centerTitle: false,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1B1F),
            ),
          ),
      cardTheme: cardTheme ??
          CardThemeData(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
      inputDecorationTheme: inputDecorationTheme ??
          InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF79747E)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF79747E)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            hintStyle: const TextStyle(
              color: Color(0xFF79747E),
              fontSize: 14,
            ),
          ),
      elevatedButtonTheme: elevatedButtonTheme ??
          ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      outlinedButtonTheme: outlinedButtonTheme ??
          OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: primary,
              side: const BorderSide(color: Color(0xFF79747E)),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      textButtonTheme: textButtonTheme ??
          TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: primary,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      floatingActionButtonTheme: fabTheme ??
          FloatingActionButtonThemeData(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
      iconTheme: iconTheme ??
          const IconThemeData(
            color: Color(0xFF49454F),
            size: 24,
          ),
      dividerTheme: dividerTheme ??
          const DividerThemeData(
            color: Color(0xFFE0E0E0),
            thickness: 1,
            space: 1,
          ),
      bottomNavigationBarTheme: bottomNavTheme ??
          BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: primary,
            unselectedItemColor: const Color(0xFF79747E),
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),
      tabBarTheme: tabBarTheme ??
          TabBarThemeData(
            labelColor: primary,
            unselectedLabelColor: const Color(0xFF79747E),
            indicatorColor: primary,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
      snackBarTheme: snackbarTheme ??
          SnackBarThemeData(
            backgroundColor: const Color(0xFF1C1B1F),
            contentTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            behavior: SnackBarBehavior.floating,
          ),
      dialogTheme: dialogTheme ??
          DialogThemeData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1B1F),
            ),
          ),
      popupMenuTheme: popupMenuTheme ??
          PopupMenuThemeData(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
      listTileTheme: listTileTheme ??
          ListTileThemeData(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            titleTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C1B1F),
            ),
            subtitleTextStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF79747E),
            ),
          ),
      navigationBarTheme: navigationBarTheme ??
          NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: ColorUtils.withAlpha(primary, 20),
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      visualDensity: visualDensity,
    );
  }

  /// Creates a dark theme configuration.
  static ThemeData dark({
    Color? primaryColor,
    Color? scaffoldBackgroundColor,
    Color? errorColor,
    TextTheme? textTheme,
    AppBarTheme? appBarTheme,
    CardThemeData? cardTheme,
    bool useMaterial3 = true,
  }) {
    final primary = primaryColor ?? const Color(0xFF66B2FF);
    final surface = scaffoldBackgroundColor ?? const Color(0xFF1C1B1F);

    return ThemeData(
      useMaterial3: useMaterial3,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: const Color(0xFF003258),
        primaryContainer: ColorUtils.darken(primary, 0.3),
        onPrimaryContainer: primary,
        secondary: const Color(0xFFCCC2DC),
        onSecondary: const Color(0xFF292532),
        secondaryContainer: ColorUtils.darken(const Color(0xFFCCC2DC), 0.4),
        onSecondaryContainer: const Color(0xFFCCC2DC),
        tertiary: const Color(0xFFEFB8C8),
        onTertiary: const Color(0xFF492532),
        tertiaryContainer: ColorUtils.darken(const Color(0xFFEFB8C8), 0.4),
        onTertiaryContainer: const Color(0xFFEFB8C8),
        surface: surface,
        onSurface: const Color(0xFFE6E1E5),
        surfaceContainerHighest: const Color(0xFF49454F),
        onSurfaceVariant: const Color(0xFFCAC4D0),
        error: errorColor ?? const Color(0xFFFFB4AB),
        onError: const Color(0xFF690005),
        errorContainer: const Color(0xFF93000A),
        onErrorContainer: const Color(0xFFFFDAD6),
        outline: const Color(0xFF938F99),
        outlineVariant: const Color(0xFF49454F),
      ),
      scaffoldBackgroundColor: surface,
      textTheme: textTheme,
      appBarTheme: appBarTheme ??
          AppBarTheme(
            backgroundColor: surface,
            foregroundColor: const Color(0xFFE6E1E5),
            elevation: 0,
            scrolledUnderElevation: 2,
            centerTitle: false,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE6E1E5),
            ),
          ),
      cardTheme: cardTheme ??
          CardThemeData(
            color: const Color(0xFF2B2B2B),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
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
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: elevation,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap == null) return container;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: container,
      ),
    );
  }
}