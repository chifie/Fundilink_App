import 'package:flutter/material.dart';

/// Adds press-down scale feedback to any tappable child.
///
/// Wrap cards, tiles and list items to give them a subtle "lift" effect
/// while the user holds them down.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = 0.96,
    this.duration = const Duration(milliseconds: 120),
    this.enabled = true,
  });

  /// The widget to wrap.
  final Widget child;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Callback when long-pressed.
  final VoidCallback? onLongPress;

  /// Scale applied while pressed. Defaults to 0.96.
  final double scale;

  /// Duration of the scale animation. Defaults to 120ms.
  final Duration duration;

  /// Whether press feedback is enabled. Defaults to true.
  final bool enabled;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  bool get _interactive => widget.enabled && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _interactive ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: _interactive
          ? () => setState(() => _pressed = false)
          : null,
      onTapUp: _interactive
          ? (_) => setState(() => _pressed = false)
          : null,
      onTap: _interactive ? widget.onTap : null,
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}