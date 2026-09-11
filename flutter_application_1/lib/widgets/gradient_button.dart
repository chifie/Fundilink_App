import 'package:flutter/material.dart';

import '../core/constants/app_dimensions.dart';
import '../core/theme/app_motion.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/color_utils.dart';

/// A modern primary button with a gradient background and press feedback.
///
/// The button scales down slightly while pressed and shows a ripple over
/// the gradient. Falls back to a muted, disabled look when [onPressed] is
/// null. Colors default to the active [ColorScheme] primary gradient so
/// the button adapts to light and dark themes automatically.
class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.colors,
    this.borderRadius,
    this.height,
    this.padding,
    this.pressScale = 0.97,
    this.enabled = true,
  });

  /// Callback when the button is tapped. Null disables the button.
  final VoidCallback? onPressed;

  /// The button label or icon content.
  final Widget child;

  /// Gradient colors. Defaults to the scheme primary gradient.
  final List<Color>? colors;

  /// Border radius. Defaults to [AppDimensions.radiusM].
  final BorderRadius? borderRadius;

  /// Fixed height. Defaults to [AppDimensions.buttonHeight].
  final double? height;

  /// Padding around the child.
  final EdgeInsets? padding;

  /// Scale applied while the button is pressed. Defaults to 0.97.
  final double pressScale;

  /// Whether the button is interactive. Defaults to true.
  final bool enabled;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  bool get _interactive => widget.enabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderRadius =
        widget.borderRadius ?? BorderRadius.circular(AppDimensions.radiusM);
    final height = widget.height ?? AppDimensions.buttonHeight;
    final gradientColors = widget.colors ??
        [
          scheme.primary,
          ColorUtils.darken(scheme.primary, 0.15),
        ];
    final labelStyle =
        AppTextStyles.labelLarge(scheme.onPrimary).copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 15,
    );

    return Semantics(
      button: true,
      enabled: _interactive,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _interactive ? (_) => setState(() => _pressed = true) : null,
        onTapCancel:
            _interactive ? () => setState(() => _pressed = false) : null,
        onTapUp: _interactive
            ? (_) => setState(() => _pressed = false)
            : null,
        onTap: _interactive ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _pressed ? widget.pressScale : 1.0,
          duration: AppMotion.short,
          curve: Curves.easeOut,
          child: Material(
            color: Colors.transparent,
            child: Ink(
              height: height,
              decoration: BoxDecoration(
                gradient: _interactive
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      )
                    : null,
                color: _interactive
                    ? null
                    : scheme.onSurface.withValues(alpha: 0.12),
                borderRadius: borderRadius,
                boxShadow: _interactive
                    ? [
                        BoxShadow(
                          color: gradientColors.last.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: InkWell(
                onTap: _interactive ? widget.onPressed : null,
                borderRadius: borderRadius,
                splashColor: scheme.onPrimary.withValues(alpha: 0.2),
                highlightColor: scheme.onPrimary.withValues(alpha: 0.1),
                child: Container(
                  height: height,
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingL,
                      ),
                  alignment: Alignment.center,
                  child: DefaultTextStyle.merge(
                    style: labelStyle,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
