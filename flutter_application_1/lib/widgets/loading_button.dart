import 'package:flutter/material.dart';

/// A button that automatically handles loading state with visual feedback.
/// 
/// Displays a loading indicator and disables interaction while loading.
/// Supports both ElevatedButton and OutlinedButton styles.
class LoadingButton extends StatefulWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.loadingIndicator,
    this.disabledColor,
    this.disabledTextColor,
    this.showSpinnerOverChild = true,
    this.spinnerSize,
    this.spinnerColor,
    this.style,
    this.elevation,
    this.shape,
    this.isOutlined = false,
    this.side,
  });

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The child widget (typically text) displayed on the button.
  final Widget child;

  /// Whether the button is currently in a loading state.
  final bool isLoading;

  /// Custom loading indicator. Defaults to CircularProgressIndicator.
  final Widget? loadingIndicator;

  /// Background color when disabled or loading.
  final Color? disabledColor;

  /// Text color when disabled or loading.
  final Color? disabledTextColor;

  /// Whether to show spinner over the child or replace it.
  /// Defaults to true (spinner shown over child with reduced opacity).
  final bool showSpinnerOverChild;

  /// Size of the loading spinner.
  final double? spinnerSize;

  /// Color of the loading spinner.
  final Color? spinnerColor;

  /// Button style overrides.
  final ButtonStyle? style;

  /// Elevation of the button.
  final double? elevation;

  /// Shape of the button.
  final MaterialStateProperty<OutlinedBorder?>? shape;

  /// Whether to use outlined style instead of elevated.
  final bool isOutlined;

  /// Border side for outlined button.
  final BorderSide? side;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = widget.isLoading || widget.onPressed == null;
    
    final effectiveStyle = widget.style ?? ButtonStyle();
    final effectiveDisabledColor = widget.disabledColor ?? 
        colorScheme.surfaceContainerHighest;
    final effectiveDisabledTextColor = widget.disabledTextColor ?? 
        colorScheme.onSurface.withValues(alpha: 0.5);
    final effectiveSpinnerSize = widget.spinnerSize ?? 20.0;
    final effectiveSpinnerColor = widget.spinnerColor ?? colorScheme.primary;
    final effectiveElevation = widget.elevation ?? (widget.isOutlined ? 0 : 2);
    final effectiveShape = widget.shape;

    Widget buttonChild;
    if (widget.isLoading && widget.showSpinnerOverChild) {
      buttonChild = Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          Opacity(
            opacity: 0.7,
            child: widget.child,
          ),
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      );
    } else if (widget.isLoading) {
      buttonChild = widget.loadingIndicator ?? const SizedBox.shrink();
    } else {
      buttonChild = widget.child;
    }

    Widget button;
    if (widget.isOutlined) {
      button = OutlinedButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: effectiveStyle.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return effectiveDisabledColor;
            }
            return effectiveStyle.backgroundColor?.resolve(states);
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return effectiveDisabledTextColor;
            }
            return effectiveStyle.foregroundColor?.resolve(states);
          }),
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return const BorderSide(color: Colors.grey);
            }
            return widget.side ?? BorderSide(color: colorScheme.outline);
          }),
          overlayColor: effectiveStyle.overlayColor,
          elevation: MaterialStateProperty.all(effectiveElevation),
          padding: effectiveStyle.padding,
          textStyle: effectiveStyle.textStyle?.copyWith(
            color: isDisabled ? effectiveDisabledTextColor : null,
          ),
          shape: effectiveShape,
        ),
        child: buttonChild,
      );
    } else {
      button = ElevatedButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: effectiveStyle.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return effectiveDisabledColor;
            }
            return effectiveStyle.backgroundColor?.resolve(states);
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return effectiveDisabledTextColor;
            }
            return effectiveStyle.foregroundColor?.resolve(states);
          }),
          overlayColor: effectiveStyle.overlayColor,
          elevation: MaterialStateProperty.all(effectiveElevation),
          padding: effectiveStyle.padding,
          textStyle: effectiveStyle.textStyle?.copyWith(
            color: isDisabled ? effectiveDisabledTextColor : null,
          ),
          shape: effectiveShape,
        ),
        child: buttonChild,
      );
    }

    if (widget.isLoading) {
      button = Opacity(
        opacity: 0.8,
        child: button,
      );
    }

    return button;
  }
}
