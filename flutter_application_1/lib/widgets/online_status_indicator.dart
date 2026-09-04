import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Shows a fundi's online/offline status with a pulsing dot.
class OnlineStatusIndicator extends StatefulWidget {
  const OnlineStatusIndicator({super.key, required this.isOnline, this.size = 10});
  final bool isOnline;
  final double size;

  @override
  State<OnlineStatusIndicator> createState() => _OnlineStatusIndicatorState();
}

class _OnlineStatusIndicatorState extends State<OnlineStatusIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    if (widget.isOnline) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(OnlineStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOnline && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isOnline && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isOnline ? AppColors.success : AppColors.textHint;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: widget.isOnline
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3 + _controller.value * 0.4),
                      blurRadius: 4 + _controller.value * 4,
                      spreadRadius: _controller.value * 2,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}
