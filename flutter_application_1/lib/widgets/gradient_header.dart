import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// A reusable gradient header card with child content.
///
/// Displays a child widget inside a gradient background with rounded
/// corners. The gradient direction and colors are customizable.
class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.child,
    this.colors,
    this.startAlignment = Alignment.topLeft,
    this.endAlignment = Alignment.bottomRight,
    this.gradientType = GradientType.linear,
    this.borderRadius,
    this.padding,
    this.height,
    this.width,
    this.elevation,
    this.border,
    this.onTap,
  });

  /// The child widget to display inside the header.
  final Widget child;

  /// Custom gradient colors. Uses primary colors by default.
  final List<Color>? colors;

  /// Start alignment for the gradient. Defaults to top-left.
  final Alignment startAlignment;

  /// End alignment for the gradient. Defaults to bottom-right.
  final Alignment endAlignment;

  /// Type of gradient to use. Defaults to linear.
  final GradientType gradientType;

  /// Border radius for the header. Uses large radius by default.
  final BorderRadius? borderRadius;

  /// Padding inside the header. Uses large padding by default.
  final EdgeInsets? padding;

  /// Optional fixed height for the header.
  final double? height;

  /// Optional fixed width for the header. Defaults to full width.
  final double? width;

  /// Elevation of the header card. Defaults to 0.
  final double elevation;

  /// Optional border for the header.
  final Border? border;

  /// Optional tap callback for the header.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.circular(AppDimensions.radiusL);
    final effectivePadding = padding ??
        EdgeInsets.all(AppDimensions.paddingL);
    final defaultColors = colors ?? [AppColors.primary, AppColors.primaryDark];

    Widget headerContent = Container(
      width: width,
      height: height,
      padding: effectivePadding,
      decoration: BoxDecoration(
        gradient: _buildGradient(defaultColors),
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
        border: border,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: headerContent,
        ),
      );
    }

    return headerContent;
  }

  Gradient _buildGradient(List<Color> colors) {
    switch (gradientType) {
      case GradientType.linear:
        return LinearGradient(
          begin: startAlignment,
          end: endAlignment,
          colors: colors,
        );
      case GradientType.radial:
        return RadialGradient(
          colors: colors,
          center: Alignment.center,
          radius: 0.8,
        );
      case GradientType.sweep:
        return SweepGradient(
          colors: colors,
          startAngle: 0,
          endAngle: 3.14159 * 2,
        );
    }
  }
}

/// Types of gradients supported by [GradientHeader].
enum GradientType {
  /// Linear gradient from start to end alignment.
  linear,

  /// Radial gradient from center.
  radial,

  /// Sweep gradient around center.
  sweep,
}
