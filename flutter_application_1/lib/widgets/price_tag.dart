import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import 'pressable_scale.dart';

/// A styled price tag displaying a fundi's starting price.
///
/// Supports compact or regular display modes with customizable styling.
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.price,
    this.compact = false,
    this.currencySymbol,
    this.displayFullPrice = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.showCurrencySymbol = true,
    this.onTap,
    this.elevation = 0,
  });

  /// The price text to display (e.g., 'Starting at $25').
  final String price;

  /// Whether to display in compact mode. Defaults to false.
  final bool compact;

  /// Custom currency symbol prefix. Uses default from price if not set.
  final String? currencySymbol;

  /// Whether to display the full price text. Defaults to true.
  /// Set to false to show just the amount.
  final bool displayFullPrice;

  /// Custom background color. Uses primary surface by default.
  final Color? backgroundColor;

  /// Custom text color. Uses primary color by default.
  final Color? textColor;

  /// Custom font size. Uses compact-based sizing by default.
  final double? fontSize;

  /// Custom padding. Uses compact-based padding by default.
  final EdgeInsets? padding;

  /// Custom border radius. Uses full circle by default.
  final BorderRadius? borderRadius;

  /// Whether to show currency symbol. Defaults to true.
  final bool showCurrencySymbol;

  /// Optional tap callback for interactive price tags.
  final VoidCallback? onTap;

  /// Elevation of the tag when tapped. Defaults to 0.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.primarySurface;
    final effectiveTextColor = textColor ?? AppColors.primary;
    final effectiveFontSize = fontSize ?? (compact ? 11 : 13);
    final effectivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: compact ? 6 : 10,
      vertical: compact ? 3 : 5,
    );
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.circular(AppDimensions.radiusFull);

    final displayText = displayFullPrice
        ? price
        : price.split(' ').last;

    Widget tagContent = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
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
      child: Text(
        displayText,
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (onTap != null) {
      return PressableScale(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveBorderRadius,
            child: tagContent,
          ),
        ),
      );
    }

    return tagContent;
  }
}
