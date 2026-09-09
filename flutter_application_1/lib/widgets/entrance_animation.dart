import 'dart:async';

import 'package:flutter/material.dart';

/// Animates a child into view with a fade, slide and subtle scale.
///
/// [delay] staggers items in lists, [offset] controls the slide direction,
/// and [animate] can be disabled entirely (e.g. for reduced motion or
/// accessibility preferences).
class EntranceAnimation extends StatefulWidget {
  const EntranceAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 450),
    this.offset = const Offset(0, 0.15),
    this.curve = Curves.easeOutCubic,
    this.animate = true,
  });

  /// The widget to animate in.
  final Widget child;

  /// Delay before the animation starts. Use to stagger list items.
  final Duration delay;

  /// Duration of the entrance animation.
  final Duration duration;

  /// Slide distance and direction. Defaults to sliding up from below.
  final Offset offset;

  /// Animation curve. Defaults to [Curves.easeOutCubic].
  final Curve curve;

  /// Whether the entrance animation runs. Set to false to show the child
  /// immediately without animating.
  final bool animate;

  @override
  State<EntranceAnimation> createState() => _EntranceAnimationState();
}

class _EntranceAnimationState extends State<EntranceAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);
    _opacity = curved;
    _slide = Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(
      curved,
    );
    _scale = Tween<double>(begin: 0.96, end: 1.0).animate(curved);
    _start();
  }

  @override
  void didUpdateWidget(EntranceAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate ||
        widget.delay != oldWidget.delay) {
      _start();
    }
  }

  void _start() {
    _delayTimer?.cancel();
    _controller.stop();
    _controller.value = 0;
    if (!widget.animate) {
      _controller.value = 1;
      return;
    }
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}