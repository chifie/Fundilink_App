import 'dart:math';

import 'package:flutter/material.dart';

/// Utility functions for responsive sizing and layout calculations.
class SizeUtils {
  /// Returns the screen width in logical pixels.
  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// Returns the screen height in logical pixels.
  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  /// Returns the screen diagonal in logical pixels.
  static double screenDiagonal(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return sqrt(size.width * size.width + size.height * size.height);
  }

  /// Returns a responsive padding based on screen width.
  static double responsivePadding(BuildContext context,
      {double small = 12, double medium = 16, double large = 24}) {
    final width = screenWidth(context);
    if (width < 360) {
      return small;
    } else if (width < 600) {
      return medium;
    } else {
      return large;
    }
  }

  /// Returns a responsive font size based on screen width.
  static double responsiveFontSize(BuildContext context,
      {double small = 12, double medium = 14, double large = 16}) {
    final width = screenWidth(context);
    if (width < 360) {
      return small;
    } else if (width < 600) {
      return medium;
    } else {
      return large;
    }
  }

  /// Returns a scaled size based on a base size and screen width ratio.
  static double scaledSize(BuildContext context, double baseSize,
      {double referenceWidth = 375}) {
    final width = screenWidth(context);
    return baseSize * (width / referenceWidth);
  }

  /// Checks if the screen is considered small (typically phones).
  static bool isSmallScreen(BuildContext context, {double threshold = 400}) {
    return screenWidth(context) < threshold;
  }

  /// Checks if the screen is considered medium (typically tablets).
  static bool isMediumScreen(BuildContext context,
      {double minThreshold = 400, double maxThreshold = 800}) {
    final width = screenWidth(context);
    return width >= minThreshold && width < maxThreshold;
  }

  /// Checks if the screen is considered large (typically desktops).
  static bool isLargeScreen(BuildContext context, {double threshold = 800}) {
    return screenWidth(context) >= threshold;
  }

  /// Returns the available height excluding system UI.
  static double availableHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).top -
        MediaQuery.paddingOf(context).bottom;
  }

  /// Returns the aspect ratio of the screen.
  static double aspectRatio(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.width / size.height;
  }
}
