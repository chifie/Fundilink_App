import 'package:flutter/material.dart';

/// Utility functions and common animation patterns.
class AnimationUtils {
  /// Creates a standard fade-in animation curve.
  static const fadeInCurve = Curves.easeOut;

  /// Creates a standard fade-out animation curve.
  static const fadeOutCurve = Curves.easeIn;

  /// Creates a standard scale animation curve.
  static const scaleCurve = Curves.easeOutBack;

  /// Creates a standard slide animation curve.
  static const slideCurve = Curves.easeOutCubic;

  /// Creates a staggered animation duration for list items.
  static const List<Duration> staggeredDurations = [
    Duration(milliseconds: 50),
    Duration(milliseconds: 100),
    Duration(milliseconds: 150),
    Duration(milliseconds: 200),
    Duration(milliseconds: 250),
    Duration(milliseconds: 300),
    Duration(milliseconds: 350),
    Duration(milliseconds: 400),
    Duration(milliseconds: 450),
    Duration(milliseconds: 500),
  ];

  /// Creates a widget with fade-in animation.
  static Widget fadeIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = fadeInCurve,
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
  }) {
    return AnimatedOpacity(
      duration: duration,
      opacity: endOpacity,
      curve: curve,
      child: child,
    );
  }

  /// Creates a widget with scale-in animation.
  static Widget scaleIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = scaleCurve,
    double beginScale = 0.8,
    double endScale = 1.0,
    Alignment alignment = Alignment.center,
  }) {
    return AnimatedScale(
      duration: duration,
      scale: endScale,
      curve: curve,
      alignment: alignment,
      child: child,
    );
  }

  /// Creates a widget with slide-in animation.
  static Widget slideIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = slideCurve,
    Offset beginOffset = const Offset(0, 0.1),
    Offset endOffset = Offset.zero,
    Alignment alignment = Alignment.topCenter,
  }) {
    return AnimatedPositioned(
      duration: duration,
      curve: curve,
      left: alignment.x * beginOffset.dx,
      top: alignment.y * beginOffset.dy,
      child: AnimatedOpacity(
        duration: duration,
        opacity: 1.0,
        child: child,
      ),
    );
  }

  /// Creates a staggered animation controller for list items.
  ///
  /// Each controller is automatically started and staggered based on
  /// the predefined [staggeredDurations] list.
  static List<AnimationController> createStaggeredControllers(
    TickerProvider vsync,
    int itemCount, {
    Duration baseDuration = const Duration(milliseconds: 300),
    bool autoStart = true,
  }) {
    return List.generate(itemCount, (index) {
      final controller = AnimationController(
        duration: staggeredDurations[index % staggeredDurations.length],
        vsync: vsync,
      );
      if (autoStart) {
        controller.forward();
      }
      return controller;
    });
  }

  /// Creates a list of tween sequences for bouncy animations.
  static TweenSequence<double> bouncyTweenSequence({
    double begin = 0.0,
    double end = 1.0,
    double overshoot = 1.2,
    double settle1 = 0.95,
    double settle2 = 1.05,
    int weight1 = 40,
    int weight2 = 20,
    int weight3 = 20,
    int weight4 = 20,
  }) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: begin, end: end * overshoot),
        weight: weight1.toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: end * overshoot, end: end * settle1),
        weight: weight2.toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: end * settle1, end: end * settle2),
        weight: weight3.toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: end * settle2, end: end),
        weight: weight4.toDouble(),
      ),
    ]);
  }
}
