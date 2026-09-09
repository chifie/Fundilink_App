import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';

/// Centred error state with a retry action for failed async loads.
///
/// Displays an error icon, message, and retry button. The icon size,
/// button style, and spacing are all customizable. The whole view fades
/// in when it first appears.
///
/// Example usage:
/// ```dart
/// ErrorView(
///   message: 'Unable to load data',
///   onRetry: () => loadData(),
///   icon: Icons.error_outline,
///   isError: true,
/// )
/// ```
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.message,
    required this.onRetry,
    this.icon = Icons.cloud_off_outlined,
    this.iconSize = 44,
    this.buttonStyle,
    this.padding = const EdgeInsets.all(AppDimensions.paddingXL),
    this.addAction,
    this.isError = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.initialOpacity = 0.0,
  });

  /// The error message to display. Uses [AppStrings.somethingWentWrong]
  /// if not provided.
  final String? message;

  /// Callback invoked when the retry button is pressed.
  final VoidCallback onRetry;

  /// Icon to display. Defaults to [Icons.cloud_off_outlined].
  final IconData icon;

  /// Size of the icon in logical pixels. Defaults to 44.
  final double iconSize;

  /// Optional custom style for the retry button.
  final ButtonStyle? buttonStyle;

  /// Padding around the entire error view. Defaults to large padding.
  final EdgeInsets padding;

  /// Optional additional action widget (e.g., 'Report issue' button).
  final Widget? addAction;

  /// Whether this represents an error (true) or a warning (false).
  /// Affects the icon and color scheme. Defaults to true.
  final bool isError;

  /// Duration of the fade-in animation. Defaults to 300ms.
  final Duration animationDuration;

  /// Initial opacity for the fade-in animation. Defaults to 0.0.
  final double initialOpacity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = isError
        ? colorScheme.onSurfaceVariant
        : AppColors.warning;

    final retryButton = OutlinedButton(
      onPressed: onRetry,
      style: buttonStyle,
      child: Text(AppStrings.retry),
    );

    Widget content = Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            message ?? AppStrings.somethingWentWrong,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          if (addAction != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                retryButton,
                const SizedBox(width: AppDimensions.spaceM),
                addAction!,
              ],
            )
          else
            retryButton,
        ],
      ),
    );

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: initialOpacity.clamp(0.0, 1.0), end: 1.0),
        duration: animationDuration,
        curve: Curves.easeOut,
        builder: (context, opacity, child) =>
            Opacity(opacity: opacity, child: child),
        child: content,
      ),
    );
  }
}