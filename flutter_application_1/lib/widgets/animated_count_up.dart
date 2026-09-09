import 'package:flutter/material.dart';

/// Animates a numeric value counting up to its target.
///
/// Useful for earnings, stats and totals. A custom [formatter] can be used
/// to render currency or percentages; otherwise the value is shown as a
/// whole number.
class AnimatedCountUp extends StatefulWidget {
  const AnimatedCountUp({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutCubic,
    this.style,
    this.textAlign,
    this.formatter,
  });

  /// The target value to count up to.
  final double value;

  /// Duration of the count-up animation.
  final Duration duration;

  /// Animation curve. Defaults to [Curves.easeOutCubic].
  final Curve curve;

  /// Optional text style applied to the rendered value.
  final TextStyle? style;

  /// Optional text alignment for the rendered value.
  final TextAlign? textAlign;

  /// Optional formatter for the rendered value (e.g. currency).
  final String Function(double value)? formatter;

  @override
  State<AnimatedCountUp> createState() => _AnimatedCountUpState();
}

class _AnimatedCountUpState extends State<AnimatedCountUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  double _displayed = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _controller.addListener(() {
      setState(() {
        _displayed = widget.value * _controller.value;
      });
    });
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCountUp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.formatter?.call(_displayed) ??
        _displayed.round().toString();
    return Text(
      text,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}