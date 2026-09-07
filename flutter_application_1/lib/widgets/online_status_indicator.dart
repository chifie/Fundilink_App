import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Shows a fundi's online/offline status with a pulsing dot.
///
/// When online, the dot pulses with a subtle glow effect to draw attention.
/// When offline, it shows a static muted dot.
class OnlineStatusIndicator extends StatefulWidget {
  const OnlineStatusIndicator({
    super.key,
    required this.isOnline,
    this.size = 10,
    this.pulseDuration = const Duration(milliseconds: 1500),
    this.color,
    this.offlineColor,
    this.showPulse = true,
  });

  /// Whether the status indicator should show online (true) or offline (false).
  final bool isOnline;

  /// Size of the indicator in logical pixels. Defaults to 10.
  final double size;

  /// Duration of one pulse cycle when online. Defaults to 1500ms.
  final Duration pulseDuration;

  /// Custom color for the online state. Defaults to [AppColors.success].
  final Color? color;

  /// Custom color for the offline state. Defaults to [AppColors.textHint].
  final Color? offlineColor;

  /// Whether to show the pulsing animation when online. Defaults to true.
  /// Set to false to show a static dot even when online.
  final bool showPulse;

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
      duration: widget.pulseDuration,
      vsync: this,
    );
    _startPulse();
  }

  void _startPulse() {
    if (widget.showPulse && widget.isOnline) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(OnlineStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOnline != oldWidget.isOnline ||
        widget.showPulse != oldWidget.showPulse) {
      if (widget.isOnline && widget.showPulse && !_controller.isAnimating) {
        _controller.repeat(reverse: true);
      } else if (!widget.isOnline || !widget.showPulse) {
        _controller.stop();
        _controller.value = 0;
      }
    }

    if (widget.pulseDuration != oldWidget.pulseDuration &&
        _controller.isAnimating) {
      _controller.duration = widget.pulseDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.isOnline
        ? (widget.color ?? AppColors.success)
        : (widget.offlineColor ?? AppColors.textHint);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!widget.isOnline || !widget.showPulse) {
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: effectiveColor,
              shape: BoxShape.circle,
            ),
          );
        }

        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: effectiveColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: effectiveColor.withValues(
                  alpha: 0.3 + _controller.value * 0.4,
                ),
                blurRadius: 4 + _controller.value * 4,
                spreadRadius: _controller.value * 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
