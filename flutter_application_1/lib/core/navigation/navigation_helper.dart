import 'package:flutter/material.dart';
import 'page_transitions.dart';

/// Helper methods for common navigation patterns.
class NavigationHelper {
  NavigationHelper._();

  /// Push a new screen with a slide-up transition.
  static Future<T?> pushSlideUp<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(SlideUpRoute(page: page));
  }

  /// Push a new screen with a fade-through transition.
  static Future<T?> pushFade<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(FadeThroughRoute(page: page));
  }

  /// Push a new screen with a scale-up transition.
  static Future<T?> pushScale<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(ScaleUpRoute(page: page));
  }

  /// Push a new screen and replace the current one.
  static Future<T?> pushReplacement<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  /// Push a new screen and remove all previous routes.
  static Future<T?> pushAndRemoveAll<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => page),
      (route) => false,
    );
  }

  /// Pop back to the first route in the stack.
  static void popToFirst(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
