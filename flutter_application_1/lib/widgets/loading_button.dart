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
  final WidgetStateProperty<OutlinedBorder?>? shape;

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
    final effectiveDisabledColor =
        widget.disabledColor ?? colorScheme.surfaceContainerHighest;
    final effectiveDisabledTextColor = widget.disabledTextColor ??
        colorScheme.onSurface.withValues(alpha: 0.5);
    final effectiveSpinnerSize = widget.spinnerSize ?? 20.0;
    final effectiveSpinnerColor = widget.spinnerColor ?? colorScheme.primary;
    final effectiveElevation = widget.elevation ?? (widget.isOutlined ? 0 : 2);

    final Widget idleChild;
    if (widget.isLoading && widget.showSpinnerOverChild) {
      idleChild = Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.4,
            child: widget.child,
          ),
          SizedBox(
            width: effectiveSpinnerSize,
            height: effectiveSpinnerSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                effectiveSpinnerColor,
              ),
            ),
          ),
        ],
      );
    } else if (widget.isLoading) {
      idleChild = widget.loadingIndicator ?? const SizedBox.shrink();
    } else {
      idleChild = widget.child;
    }

    // Fade between the idle content and the loading state.
    final Widget buttonChild = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(
        key: ValueKey(widget.isLoading),
        child: idleChild,
      ),
    );

    final backgroundColor = WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return effectiveDisabledColor;
      }
      return effectiveStyle.backgroundColor?.resolve(states);
    });
    final foregroundColor = WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return effectiveDisabledTextColor;
      }
      return effectiveStyle.foregroundColor?.resolve(states);
    });
    final textStyle = WidgetStateProperty.resolveWith((states) {
      final base = effectiveStyle.textStyle?.resolve(states);
      if (states.contains(WidgetState.disabled)) {
        return base?.copyWith(color: effectiveDisabledTextColor) ??
            TextStyle(color: effectiveDisabledTextColor);
      }
      return base;
    });

    final ButtonStyle buttonStyle = effectiveStyle.copyWith(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      overlayColor: effectiveStyle.overlayColor,
      elevation: WidgetStateProperty.all(effectiveElevation),
      padding: effectiveStyle.padding,
      textStyle: textStyle,
      shape: widget.shape ?? effectiveStyle.shape,
    );

    Widget button;
    if (widget.isOutlined) {
      button = OutlinedButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: buttonStyle.copyWith(
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: Colors.grey);
            }
            return widget.side ?? BorderSide(color: colorScheme.outline);
          }),
        ),
        child: buttonChild,
      );
    } else {
      button = ElevatedButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: buttonStyle,
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