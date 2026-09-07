import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'shimmer_loading.dart';

/// Skeleton placeholder for a list item with avatar, text lines, and optional details.
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({
    super.key,
    this.showAvatar = true,
    this.avatarRadius = 24,
    this.textLines = 2,
    this.showSecondaryText = true,
    this.showMetaInfo = false,
    this.showChips = false,
    this.chipCount = 2,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.width,
    this.height = 72,
    this.isCompact = false,
  });

  /// Whether to show the avatar placeholder.
  final bool showAvatar;

  /// Radius of the avatar placeholder.
  final double avatarRadius;

  /// Number of text lines to show.
  final int textLines;

  /// Whether to show secondary smaller text.
  final bool showSecondaryText;

  /// Whether to show meta info (like date, location).
  final bool showMetaInfo;

  /// Whether to show chip/badge placeholders.
  final bool showChips;

  /// Number of chips to show.
  final int chipCount;

  /// Padding around the item content.
  final EdgeInsets padding;

  /// Fixed width of the skeleton.
  final double? width;

  /// Fixed height of the skeleton.
  final double height;

  /// Whether to use compact sizing.
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width;
    final effectiveHeight = isCompact ? height * 0.7 : height;
    final effectivePadding = isCompact 
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        : padding;

    return ShimmerLoading(
      child: SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: Padding(
          padding: effectivePadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showAvatar) ...[
                Container(
                  width: avatarRadius * 2,
                  height: avatarRadius * 2,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primary text line
                    Container(
                      height: isCompact ? 12 : 16,
                      width: mediaQueryWidth(context) * 0.6,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Secondary text line
                    if (showSecondaryText)
                      Container(
                        height: 12,
                        width: mediaQueryWidth(context) * 0.4,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    // Meta info
                    if (showMetaInfo) ...[
                      SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 60,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                    // Chips
                    if (showChips) ...[
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children: List.generate(
                          chipCount,
                          (_) => Container(
                            height: 20,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double mediaQueryWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }
}

/// Skeleton placeholder for a card with image and multiple text lines.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.imageHeight = 120,
    this.textLines = 3,
    this.showImage = true,
    this.imageRadius = 12,
    this.padding = const EdgeInsets.all(16),
    this.radius = 12,
  });

  /// Height of the image placeholder.
  final double imageHeight;

  /// Number of text lines to show.
  final int textLines;

  /// Whether to show the image placeholder.
  final bool showImage;

  /// Border radius of the image placeholder.
  final double imageRadius;

  /// Padding around the card content.
  final EdgeInsets padding;

  /// Border radius of the card.
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showImage) ...[
              Container(
                height: imageHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(imageRadius),
                ),
              ),
              SizedBox(height: 16),
            ],
            ...List.generate(
              textLines,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index < textLines - 1 ? 8 : 0,
                ),
                child: Container(
                  height: 14,
                  width: index == textLines - 1
                      ? MediaQuery.sizeOf(context).width * 0.7
                      : MediaQuery.sizeOf(context).width * 0.9,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder for a profile header with avatar and text.
class SkeletonProfileHeader extends StatelessWidget {
  const SkeletonProfileHeader({
    super.key,
    this.avatarRadius = 40,
    this.textLines = 2,
    this.showSubtitle = true,
    this.showMeta = false,
  });

  /// Radius of the avatar placeholder.
  final double avatarRadius;

  /// Number of text lines to show.
  final int textLines;

  /// Whether to show subtitle text.
  final bool showSubtitle;

  /// Whether to show meta info below text.
  final bool showMeta;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        children: [
          // Avatar
          Container(
            width: avatarRadius * 2,
            height: avatarRadius * 2,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 2),
            ),
          ),
          SizedBox(height: 12),
          // Primary text
          ...List.generate(
            textLines,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index < textLines - 1 ? 4 : 0),
              child: Container(
                height: 16,
                width: index == 0 ? 150 : 100,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          if (showSubtitle) ...[
            SizedBox(height: 4),
            Container(
              height: 14,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
          if (showMeta) ...[
            SizedBox(height: 8),
            Container(
              height: 10,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Collection of common skeleton loading patterns.
class SkeletonPatterns {
  /// Creates a skeleton for a search result item.
  static Widget searchResult(double width) {
    return SkeletonListItem(
      showAvatar: true,
      avatarRadius: 20,
      textLines: 2,
      showSecondaryText: true,
      width: width,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  /// Creates a skeleton for a card item.
  static Widget cardItem(double width, {double height = 140}) {
    return SkeletonCard(
      imageHeight: height * 0.4,
      textLines: 2,
      width: width,
      padding: const EdgeInsets.all(12),
      radius: 12,
    );
  }

  /// Creates a skeleton for a profile header.
  static Widget profileHeader(double avatarSize) {
    return SkeletonProfileHeader(
      avatarRadius: avatarSize / 2,
      textLines: 2,
      showSubtitle: true,
    );
  }

  /// Creates a skeleton for a horizontal scrolling list item.
  static Widget horizontalListItem(double width) {
    return SkeletonListItem(
      showAvatar: true,
      avatarRadius: 22,
      textLines: 2,
      showChips: true,
      chipCount: 2,
      width: width,
      height: 80,
      isCompact: true,
    );
  }

  /// Creates a simple text skeleton line.
  static Widget textLine({double width = 200, double height = 14}) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  /// Creates a circular skeleton for avatars or icons.
  static Widget circle({double radius = 24}) {
    return ShimmerLoading(
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
