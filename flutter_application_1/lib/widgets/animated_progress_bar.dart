import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// An animated linear progress bar with an optional percentage label.
///
/// The fill smoothly animates towards [value] whenever it changes, using a
/// [TweenAnimationBuilder] so the widget stays stateless.
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeOutCubic,
    this.showLabel = false,
    this.labelStyle,
    this.labelColor,
  });

  /// Progress value between 0.0 and 1.0.
  final double value;

  /// Height of the bar track. Defaults to 8.
  final double height;

  /// Fill color. Defaults to the primary color.
  final Color? color;

  /// Track color. Defaults to a light surface variant.
  final Color? backgroundColor;

  /// Border radius of the bar. Defaults to fully rounded.
  final BorderRadius? borderRadius;

  /// Duration of the fill animation.
  final Duration duration;

  /// Animation curve. Defaults to [Curves.easeOutCubic].
  final Curve curve;

  /// Whether to render a percentage label above the bar.
  final bool showLabel;

  /// Optional text style for the percentage label.
  final TextStyle? labelStyle;

  /// Color of the percentage label when [labelStyle] is not provided.
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    final effectiveBackgroundColor = backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.circular(AppDimensions.radiusFull);
    final effectiveLabelColor = labelColor ?? effectiveColor;
    final clamped = value.clamp(0.0, 1.0);

    final bar = TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: clamped),
      duration: duration,
      curve: curve,
      builder: (context, animatedValue, _) {
        return ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: SizedBox(
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: effectiveBackgroundColor),
                FractionallySizedBox(
                  widthFactor: animatedValue,
                  alignment: Alignment.centerLeft,
                  child: ColoredBox(color: effectiveColor),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!showLabel) return bar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: clamped),
          duration: duration,
          curve: curve,
          builder: (context, animatedValue, _) {
            return Text(
              '${(animatedValue * 100).round()}%',
              style: labelStyle ??
                  TextStyle(
                    color: effectiveLabelColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.spaceXS),
        bar,
      ],
    );
  }
}