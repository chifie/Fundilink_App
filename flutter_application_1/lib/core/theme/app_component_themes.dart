import 'package:flutter/material.dart';

import 'app_elevation.dart';
import 'app_shapes.dart';

/// Material 3 component themes for the FundiLink design system.
///
/// Groups the remaining M3 widget themes – chips, dialogs, bottom sheets,
/// snackbars, menus, switches, sliders and more – so [AppTheme] stays a
/// thin assembly layer. All builders are derived from the active
/// [ColorScheme] and text theme so light and dark stay consistent.
class AppComponentThemes {
  AppComponentThemes._();

  // ---- Chip -------------------------------------------------------------

  /// Assist/filter/input chip style with M3 spacing and shapes.
  static ChipThemeData chip(ColorScheme scheme) => ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.secondaryContainer,
        checkmarkColor: scheme.onSecondaryContainer,
        disabledColor: scheme.onSurface.withValues(alpha: 0.12),
        deleteIconColor: scheme.onSurfaceVariant,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
        secondaryLabelStyle:
            TextStyle(color: scheme.onSecondaryContainer, fontSize: 14),
        iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        elevation: 0,
        pressElevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        side: BorderSide(color: scheme.outlineVariant),
        shape: AppShapes.smShape,
      );

  // ---- Dialog -----------------------------------------------------------

  /// Dialog style with the M3 28dp corner radius and full icon support.
  static DialogThemeData dialog(ColorScheme scheme, TextTheme textTheme) =>
      DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppElevation.shadowColor,
        elevation: AppElevation.level3,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.xl),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
      );

  // ---- Bottom sheet -----------------------------------------------------

  /// Bottom sheet style with the M3 28dp top radius and drag handle.
  static BottomSheetThemeData bottomSheet(ColorScheme scheme) =>
      BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surfaceContainerLow,
        modalBarrierColor: Colors.black.withValues(alpha: 0.4),
        elevation: AppElevation.level1,
        modalElevation: AppElevation.level1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        showDragHandle: true,
        dragHandleColor: scheme.onSurfaceVariant,
        dragHandleSize: const Size(32, 4),
      );

  // ---- Snack bar --------------------------------------------------------

  /// Snackbar style – inverse surface for maximum contrast.
  static SnackBarThemeData snackBar(ColorScheme scheme) => SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        actionTextColor: scheme.inversePrimary,
        closeIconColor: scheme.onInverseSurface,
        elevation: AppElevation.level3,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.xs),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: null,
      );

  // ---- Menus ------------------------------------------------------------

  /// Dropdown and popup menu style with the M3 container surface.
  static PopupMenuThemeData popupMenu(ColorScheme scheme) => PopupMenuThemeData(
        color: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppElevation.shadowColor,
        elevation: AppElevation.level2,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.xs),
        position: PopupMenuPosition.under,
        menuPadding: const EdgeInsets.symmetric(vertical: 8),
        textStyle: TextStyle(color: scheme.onSurface, fontSize: 14),
      );

  /// Dropdown menu style for text-field anchored menus.
  static DropdownMenuThemeData dropdownMenu(
    ColorScheme scheme,
    TextTheme textTheme,
  ) =>
      DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(
            scheme.surfaceContainerHigh,
          ),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(AppElevation.level2),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppShapes.xs),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: scheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: AppShapes.xs,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppShapes.xs,
            borderSide: BorderSide(color: scheme.primary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      );

  // ---- Navigation -------------------------------------------------------

  /// Navigation bar (M3 replacement for BottomNavigationBar).
  static NavigationBarThemeData navigationBar(
    ColorScheme scheme,
    TextTheme textTheme,
  ) =>
      NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        height: 80,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium!.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelMedium!.copyWith(
            color: scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.onSecondaryContainer);
          }
          return IconThemeData(color: scheme.onSurfaceVariant);
        }),
      );

  /// Navigation rail for tablet and landscape layouts.
  static NavigationRailThemeData navigationRail(ColorScheme scheme) =>
      NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.onSecondaryContainer),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(color: scheme.onSurfaceVariant),
        elevation: 0,
      );

  /// Navigation drawer with the M3 container surface and pill indicator.
  static NavigationDrawerThemeData navigationDrawer(ColorScheme scheme) =>
      NavigationDrawerThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppElevation.shadowColor,
        indicatorColor: scheme.secondaryContainer,
        elevation: AppElevation.level1,
        tileHeight: 56,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: scheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            );
          }
          return TextStyle(color: scheme.onSurfaceVariant);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.onSecondaryContainer);
          }
          return IconThemeData(color: scheme.onSurfaceVariant);
        }),
      );

  /// Bottom navigation bar (legacy) kept consistent with M3 colors.
  static BottomNavigationBarThemeData bottomNavigationBar(
    ColorScheme scheme,
  ) =>
      BottomNavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        selectedItemColor: scheme.onSurface,
        unselectedItemColor: scheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      );

  /// Tab bar with the M3 primary indicator.
  static TabBarThemeData tabBar(ColorScheme scheme, TextTheme textTheme) =>
      TabBarThemeData(
        labelColor: scheme.onSurface,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: scheme.outlineVariant,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall,
        overlayColor: WidgetStatePropertyAll(
          scheme.onSurface.withValues(alpha: 0.08),
        ),
      );

  // ---- Controls ---------------------------------------------------------

  /// Switch style with the M3 thumb track proportions.
  static SwitchThemeData toggle(ColorScheme scheme) => SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.surfaceContainerHighest;
          }
          if (states.contains(WidgetState.selected)) {
            return scheme.onPrimary;
          }
          return scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return scheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.transparent;
          return scheme.outline;
        }),
      );

  /// Checkbox style.
  static CheckboxThemeData checkbox(ColorScheme scheme) => CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(scheme.onPrimary),
        side: BorderSide(color: scheme.onSurfaceVariant, width: 2),
        shape: RoundedRectangleBorder(borderRadius: AppShapes.xs),
      );

  /// Radio button style.
  static RadioThemeData radio(ColorScheme scheme) => RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.onSurfaceVariant;
        }),
      );

  /// Progress indicators with M3 track colors.
  static ProgressIndicatorThemeData progress(ColorScheme scheme) =>
      ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        circularTrackColor: scheme.surfaceContainerHighest,
        refreshBackgroundColor: scheme.surfaceContainerHighest,
        linearMinHeight: 4,
      );

  /// Slider style with M3 handle and track colors.
  static SliderThemeData slider(ColorScheme scheme) => SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.surfaceContainerHighest,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: scheme.inverseSurface,
        valueIndicatorTextStyle: TextStyle(color: scheme.onInverseSurface),
        trackHeight: 4,
      );

  /// Divider with the M3 outline variant color.
  static DividerThemeData divider(ColorScheme scheme) => DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      );

  /// App bar with M3 surface color and scroll tinting.
  static AppBarTheme appBar(ColorScheme scheme, TextTheme textTheme) =>
      AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: AppElevation.level2,
        shadowColor: AppElevation.shadowColor,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge!.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleSpacing: 16,
      );

  /// Floating action button with the M3 large radius.
  static FloatingActionButtonThemeData fab(ColorScheme scheme) =>
      FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: AppElevation.level1,
        focusElevation: AppElevation.level2,
        hoverElevation: AppElevation.level2,
        highlightElevation: AppElevation.level2,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.lg),
      );

  /// List tile with M3 paddings and text styles.
  static ListTileThemeData listTile(
    ColorScheme scheme,
    TextTheme textTheme,
  ) =>
      ListTileThemeData(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium!.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        minVerticalPadding: 8,
      );

  /// Tooltip with the M3 inverse surface.
  static TooltipThemeData tooltip(ColorScheme scheme, TextTheme textTheme) =>
      TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: AppShapes.xs,
        ),
        textStyle: textTheme.bodySmall!.copyWith(color: scheme.onInverseSurface),
        preferBelow: true,
      );

  /// Input decoration with M3 filled style and floating labels.
  static InputDecorationTheme input(ColorScheme scheme, TextTheme textTheme) =>
      InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        hintStyle: textTheme.bodyMedium!.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        labelStyle: textTheme.bodyMedium!.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        errorStyle: textTheme.bodySmall!.copyWith(color: scheme.error),
        helperStyle: textTheme.bodySmall!.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: AppShapes.xs,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.xs,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.xs,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.xs,
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppShapes.xs,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.xs,
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );
}
