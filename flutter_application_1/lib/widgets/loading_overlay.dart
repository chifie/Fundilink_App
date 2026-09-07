import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    Widget overlay = Container();

    if (showBackground) {
      final bgColor = backgroundColor ??
          Theme.of(context).colorScheme.onSurface.withValues(alpha: opacity);
      overlay = Container(color: bgColor);
    }

    final indicatorWidget = indicator ??
        Card(
          color: Theme.of(context).colorScheme.surface,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: overlay,
          ),
        if (isLoading)
          Align(
            alignment: alignment,
            child: Padding(
              padding: padding,
              child: indicatorWidget,
            ),
          ),
      ],
    );
  }
}
