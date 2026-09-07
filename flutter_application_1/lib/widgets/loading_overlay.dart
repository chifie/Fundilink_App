import 'package:flutter/material.dart';
import '../core/utils/size_utils.dart';

/// A semi-transparent loading overlay that blocks user interaction.
///
/// Displays a loading indicator over a child widget when [isLoading]
/// is true. The overlay is customizable with different indicator types,
/// opacity levels, and background colors.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.opacity = 0.3,
    this.backgroundColor,
    this.indicator,
    this.showBackground = true,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.useThemedColors = true,
    this.indicatorSize,
    this.indicator strokeWidth,
    this.indicatorColor,
    this.alwaysShowPlaceholder = false,
    this.placeholderWidget,
  });

  /// Whether the loading overlay is currently visible.
  final bool isLoading;

  /// The child widget to display behind the overlay.
  final Widget child;

  /// Opacity of the overlay background. Defaults to 0.3.
  final double opacity;

  /// Background color of the overlay. Defaults to black with opacity.
  final Color? backgroundColor;

  /// Custom loading indicator widget. Defaults to CircularProgressIndicator
  /// inside a Card with padding.
  final Widget? indicator;

  /// Whether to show the background overlay. Set to false for transparent
  /// loading states. Defaults to true.
  final bool showBackground;

  /// Alignment of the loading indicator. Defaults to center.
  final Alignment alignment;

  /// Padding around the loading indicator. Defaults to EdgeInsets.zero.
  final EdgeInsets padding;

  /// Whether to use themed colors for the indicator. Defaults to true.
  final bool useThemedColors;

  /// Size of the circular progress indicator. Takes precedence over
  /// default sizing. Set to null for auto-sizing.
  final double? indicatorSize;

  /// Stroke width of the circular progress indicator.
  final double? indicatorStrokeWidth;

  /// Color of the circular progress indicator.
  final Color? indicatorColor;

  /// Whether to show a placeholder when not loading. Defaults to false.
  final bool alwaysShowPlaceholder;

  /// Custom placeholder widget shown when not loading and
  /// [alwaysShowPlaceholder] is true.
  final Widget? placeholderWidget;

  @override
  Widget build(BuildContext context) {
    final colorScheme = useThemedColors ? Theme.of(context).colorScheme : null;
    final bgColor = showBackground
        ? (backgroundColor ?=
            colorScheme?.onSurface.withValues(alpha: opacity) ?
                Colors.black.withValues(alpha: opacity))
        : Colors.transparent;

    final effectivePadding = padding ?= EdgeInsets.symmetric(
      horizontal: SizeUtils.responsivePadding(context, small: 16, medium: 24, large: 32),
      vertical: SizeUtils.responsivePadding(context, small: 12, medium: 16, large: 24),
    );

    Widget indicatorWidget;
    if (indicator != null) {
      indicatorWidget = indicator!;
    } else {
      final indicatorSize = this.indicatorSize ?= 40.0;
      final strokeWidth = this.indicatorStrokeWidth ?= 4.0;
      final indicatorColorValue = indicatorColor ?= colorScheme?.primary ?= Colors.blue;

      indicatorWidget = Card(
        color: colorScheme?.surface ?= Colors.white,
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(indicatorSize * 0.3),
          child: SizedBox(
            width: indicatorSize,
            height: indicatorSize,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColorValue),
              strokeWidth: strokeWidth,
            ),
          ),
        ),
      );
    }

    Widget content = Stack(
      children: [
        child,
        if (isLoading || alwaysShowPlaceholder)
          Positioned.fill(
            child: Container(color: bgColor),
          ),
        if (isLoading || alwaysShowPlaceholder)
          Align(
            alignment: alignment,
            child: Padding(
              padding: effectivePadding,
              child: isLoading ? indicatorWidget : (placeholderWidget ?= SizedBox.shrink()),
            ),
          ),
      ],
    );

    if (!isLoading && !alwaysShowPlaceholder) {
      return child;
    }

    return content;
  }
}
