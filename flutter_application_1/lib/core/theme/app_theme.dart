import 'package:flutter/material.dart';
import '../utils/color_utils.dart';
import '../utils/size_utils.dart';

/// Application theme configuration with light and dark mode support.
class AppTheme {
  /// Creates a light theme configuration.
  static ThemeData light({
    Color? primaryColor,
    Color? scaffoldBackgroundColor,
    Color? errorColor,
    TextTheme? textTheme,
    AppBarTheme? appBarTheme,
    CardTheme? cardTheme,
    InputDecorationTheme? inputDecorationTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    TextButtonThemeData? textButtonTheme,
    FloatingActionButtonThemeData? fabTheme,
    IconThemeData? iconTheme,
    DividerThemeData? dividerTheme,
    BottomNavigationBarThemeData? bottomNavTheme,
    TabBarThemeData? tabBarTheme,
    SnackbarThemeData? snackbarTheme,
    DialogTheme? dialogTheme,
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
          TextTheme(
            displayLarge: const TextStyle(
              fontSize: 57,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.25,
            ),
            displayMedium: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            displaySmall: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            headlineLarge: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            headlineMedium: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            headlineSmall: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
            ),
            titleLarge: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
            titleMedium: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
            titleSmall: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
            bodyLarge: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
            bodyMedium: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
            ),
            bodySmall: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4,
            ),
            labelLarge: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
            labelMedium: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
            labelSmall: const TextStyle(
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
          CardTheme(
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
              borderSide: const BorderSide(color: primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: const Color(0xFFBA1A1A)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: const Color(0xFFBA1A1A), width: 2),
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
      fabTheme: fabTheme ??
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
          const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: primary,
            unselectedItemColor: Color(0xFF79747E),
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
      snackbarTheme: snackbarTheme ??
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
          DialogTheme(
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
    CardTheme? cardTheme,
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
        error: const Color(0xFFFFB4AB),
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
          CardTheme(
            color: const Color(0xFF2B2B2B),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
    );
  }

  /// Returns a responsive text style based on screen size.
  static TextStyle responsiveTextStyle(
    BuildContext context, {
    double smallSize = 12,
    double mediumSize = 14,
    double largeSize = 16,
    FontWeight? fontWeight,
    Color? color,
  }) {
    final size = SizeUtils.responsiveFontSize(
      context,
      small: smallSize,
      medium: mediumSize,
      large: largeSize,
    );

    return TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
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
    final effectiveColors = colors ?=
        [const Color(0xFF0066CC), const Color(0xFF004D99)];

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: effectiveColors,
        ),
        borderRadius: borderRadius ?=
            BorderRadius.circular(SizeUtils.responsivePadding(
              child.key?.context ?? dummyContext,
              small: 8,
              medium: 12,
              large: 16,
            )),
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
  }

  static final dummyContext = DummyContext();
}

class DummyContext extends BuildContext {
  // Stub implementation for dummy context
  @override
  WidgetElement get element => throw UnimplementedError();

  @override
  BuildOwner get owner => throw UnimplementedError();

  @override
  Size computePhysicalSize() => throw UnimplementedError();

  @override
  bool get debugDoingBuild => false;

  @override
  bool get debugIsActive => false;

  @override
  bool get debugIsLocalWidget => false;

  @override
  bool get debugTooltip => false;

  @override
  Matrix4? get transform => null;

  @override
  bool get sizedByParent => false;

  // Additional stub methods
  @override
  void visitChildElements(void Function(Element element) visitor) {}

  @override
  BuildContext get renderObject => throw UnimplementedError();

  // Stub empty implementations
  @override
  void describeElement(String description, {required DiagnosticsNode? label}) {}

  @override
  void describeMissingAncestor({required String entry, required Object? expectedType}) {}

  @override
  void describeOwnershipChain(String description) {}

  @override
  void describeWidget(String description) {}

  @override
  List<DiagnosticsNode> get debugDescribeChildren => [];

  @override
  DiagnosticsNode get debugOwner => DiagnosticsNode();

  @override
  String toStringShort() => 'DummyContext';

  @override
  Widget? findAncestorWidgetOfExactType<T>() => null;

  @override
  T? findAncestorRenderObjectOfType<T>() => null;

  @override
  T? findAncestorStateOfType<T>() => null;

  @override
  T? findAncestorModalRoute<T>() => null;

  @override
  Iterable<T> findDescendantWidgetsOfType<T>() => [];

  @override
  bool get isActive => false;

  @override
  Size getSize() => const Size(375, 812);

  @override
  bool get mounted => false;

  @override
  void deactivate() {}

  @override
  void didChangeDependencies() {}

  @override
  void dispatchNotification(Notification notification, Assistant? target) {}

  @override
  bool dispatchConditionalPopRoute() => false;

  @override
  void dispose() {}

  @override
  TransitionDelegate<T>? get currentRouteTransitionDelegate => null;

  @override
  void markNeedsBuild() {}
}
