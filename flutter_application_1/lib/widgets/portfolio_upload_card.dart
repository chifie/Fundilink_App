import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';

/// A tappable card for uploading a new portfolio item.
///
/// Displays an add photo icon, title, and subtitle text.
/// Fully customizable with support for drag-and-drop and custom styling.
class PortfolioUploadCard extends StatelessWidget {
  const PortfolioUploadCard({
    super.key,
    required this.onTap,
    this.icon = Icons.add_photo_alternate_outlined,
    this.iconSize = 40,
    this.titleText,
    this.subtitleText,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 2,
    this.showSubtitle = true,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onDragDone,
    this.acceptFileTypes,
    this.animate = false,
  });

  /// Callback when the card is tapped.
  final VoidCallback onTap;

  /// Icon to display. Defaults to [Icons.add_photo_alternate_outlined].
  final IconData icon;

  /// Size of the icon. Defaults to 40.
  final double iconSize;

  /// Custom title text. Uses [AppStrings.addWork] by default.
  final String? titleText;

  /// Custom subtitle text. Uses 'Upload a photo of your work' by default.
  final String? subtitleText;

  /// Color for the icon and text. Uses forestGreen by default.
  final Color? iconColor;

  /// Custom text style for the title.
  final TextStyle? titleStyle;

  /// Custom text style for the subtitle.
  final TextStyle? subtitleStyle;

  /// Padding for the card content.
  final EdgeInsets? padding;

  /// Border radius for the card. Uses radiusM by default.
  final BorderRadius? borderRadius;

  /// Background color for the card. Uses surface color by default.
  final Color? backgroundColor;

  /// Border color for the card. Uses forestGreen with alpha by default.
  final Color? borderColor;

  /// Width of the border. Defaults to 2.
  final double borderWidth;

  /// Whether to show the subtitle text. Defaults to true.
  final bool showSubtitle;

  /// Main axis alignment for the content. Defaults to center.
  final MainAxisAlignment mainAxisAlignment;

  /// Optional callback when a file is dropped on the card.
  final ValueChanged<String>? onDragDone;

  /// Optional list of accepted file type MIME strings.
  final List<String>? acceptFileTypes;

  /// Whether to animate the card appearance. Defaults to false.
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.forestGreen;
    final effectiveTitleText = titleText ?? AppStrings.addWork;
    final effectiveSubtitleText = subtitleText ??
        'Upload a photo of\nyour work';
    final effectiveTitleStyle = titleStyle ??
        TextStyle(
          color: effectiveIconColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        );
    final effectiveSubtitleStyle = subtitleStyle ??
        TextStyle(
          color: effectiveIconColor.withValues(alpha: 0.7),
          fontSize: 11,
        );
    final effectivePadding = padding ?? EdgeInsets.zero;
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.circular(AppDimensions.radiusM);
    final effectiveBackgroundColor = backgroundColor ?? AppColors.surface;
    final effectiveBorderColor = borderColor ??
        AppColors.forestGreen.withValues(alpha: 0.3);

    Widget cardContent = GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: effectiveBorderRadius,
          border: Border.all(
            color: effectiveBorderColor,
            width: borderWidth,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        child: Padding(
          padding: effectivePadding,
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: effectiveIconColor,
              ),
              SizedBox(height: AppDimensions.spaceS),
              Text(
                effectiveTitleText,
                style: effectiveTitleStyle,
              ),
              if (showSubtitle) ...[
                SizedBox(height: 4),
                Text(
                  effectiveSubtitleText,
                  textAlign: TextAlign.center,
                  style: effectiveSubtitleStyle,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (onDragDone != null) {
      cardContent = DragTarget<String>(
        onAcceptWithDetails: (details) => onDragDone!(details.data),
        builder: (context, candidateData, rejectedData) {
          return IgnorePointer(
            ignoring: candidateData.isNotEmpty,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: effectiveBorderRadius,
                border: Border.all(
                  color: candidateData.isNotEmpty
                      ? effectiveIconColor
                      : effectiveBorderColor,
                  width: borderWidth,
                  strokeAlign: BorderSide.strokeAlignCenter,
                ),
                boxShadow: candidateData.isNotEmpty
                    ? [
                        BoxShadow(
                          color: effectiveIconColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: cardContent,
            ),
          );
        },
      );
    }

    if (animate) {
      cardContent = AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
