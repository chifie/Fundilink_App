import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

/// Provides responsive padding based on screen width.
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({super.key, required this.child});
  final Widget child;

  static double horizontal(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) return AppDimensions.paddingXXL;
    if (width >= 600) return AppDimensions.paddingXL;
    return AppDimensions.paddingM;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal(context)),
      child: child,
    );
  }
}
