import 'package:flutter/material.dart';

import '../core/constants/app_dimensions.dart';

/// Friendly placeholder shown when a list or screen has no content yet.
///
/// Displays an animated icon, title, optional message, and optional
/// action button. The icon bounces gently on appear to draw attention
/// without being distracting.
///
/// Example:
/// ```dart
/// EmptyState(
///   icon: Icons.search,
///   title: 'No results found',
///   message: 'Try adjusting your search terms',
///   actionLabel: 'Clear filters',
///   onAction: () => print('Action tapped'),
/// )
/// ```
class EmptyState extends StatefulWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconSize = 88,
    this.messageStyle,
    this.titleStyle,
    this.buttonPadding,
    this.addSemanticLabel,
    this.animate = true,
    this.containerColor,
    this.iconColor,
    this.featherIcon,
  });

  /// Whether to animate the icon on appear. Defaults to true.
  final bool animate;

  /// The icon to display in the center of the empty state.
  final IconData icon;

  /// The main title text displayed below the icon.
  final String title;

  /// Optional secondary message providing more context.
  final String? message;

  /// Optional label for the action button.
  final String? actionLabel;

  /// Optional callback when the action button is pressed.
  final VoidCallback? onAction;

  /// Size of the icon container in logical pixels. Defaults to 88.
  final double iconSize;

  /// Optional custom style for the title text.
  final TextStyle? titleStyle;

  /// Optional custom style for the message text.
  final TextStyle? messageStyle;

  /// Optional padding around the action button.
  final EdgeInsets? buttonPadding;

  /// Optional semantic label for accessibility.
  final String? addSemanticLabel;

  /// Optional custom color for the icon container background.
  final Color? containerColor;

  /// Optional custom color for the icon itself.
  final Color? iconColor;

  /// Optional feather icon for the empty state.
  final IconData? featherIcon;

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.95),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.05),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0),
        weight: 20,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final iconContainerSize = widget.iconSize;
    final iconSize = (iconContainerSize * 0.45).clamp(24.0, 60.0);
    final padding = EdgeInsets.all(
      MediaQuery.sizeOf(context).width < 360
          ? AppDimensions.paddingM
          : AppDimensions.paddingXL,
    );

    Widget content = Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: iconContainerSize,
            height: iconContainerSize,
            child: ScaleTransition(
              scale: _bounceAnimation,
              child: Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: widget.containerColor ??
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: iconSize,
                  color: widget.iconColor ??
                      Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Semantics(
            label: widget.addSemanticLabel ?? widget.title,
            explicitChildNodes: true,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: widget.titleStyle ?? textTheme.titleMedium,
            ),
          ),
          if (widget.message != null) ...[
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              widget.message!,
              textAlign: TextAlign.center,
              style: widget.messageStyle ?? textTheme.bodyMedium,
            ),
          ],
          if (widget.actionLabel != null) ...[
            const SizedBox(height: AppDimensions.spaceXL),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, t, child) {
                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, 12 * (1 - t)),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: widget.buttonPadding ??
                    const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: widget.onAction,
                    child: Text(widget.actionLabel!),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (widget.addSemanticLabel != null) {
      return Semantics(
        label: widget.addSemanticLabel,
        explicitChildNodes: true,
        child: Center(child: content),
      );
    }

    return Center(child: content);
  }
}
