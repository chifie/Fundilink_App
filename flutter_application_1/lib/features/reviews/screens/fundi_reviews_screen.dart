import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/review.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/review_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/fundi_avatar.dart';
import '../../../widgets/rating_stars.dart';

/// Reviews screen showing customer reviews for the fundi.
class FundiReviewsScreen extends StatefulWidget {
  const FundiReviewsScreen({super.key});

  @override
  State<FundiReviewsScreen> createState() => _FundiReviewsScreenState();
}

class _FundiReviewsScreenState extends State<FundiReviewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<ReviewProvider>().loadReviews(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final provider = context.watch<ReviewProvider>();
    final fundiId = user?.id ?? '';
    final reviews = provider.reviewsFor(fundiId);
    final avgRating = provider.averageFor(fundiId);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.reviews)),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null && reviews.isEmpty
          ? ErrorView(
              message: provider.error,
              onRetry: () => provider.loadReviews(fundiId),
            )
          : reviews.isEmpty
          ? const EmptyState(
              icon: Icons.rate_review_outlined,
              title: AppStrings.noReviews,
              message: AppStrings.noReviewsHint,
            )
          : ListView(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              children: [
                // Rating summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: Column(
                    children: [
                      Text(
                        avgRating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.forestGreen,
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceS),
                      RatingStars(rating: avgRating, size: 24),
                      const SizedBox(height: AppDimensions.spaceS),
                      Text(
                        '${reviews.length} ${reviews.length == 1 ? 'review' : 'reviews'}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXL),

                // Individual reviews
                for (final review in reviews) _ReviewTile(review: review),
              ],
            ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FundiAvatar(name: review.customerName, radius: 16),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        review.customerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      Formatters.timeAgo(review.createdAt),
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                RatingStars(rating: review.rating, size: 13),
                const SizedBox(height: 4),
                Text(
                  review.comment,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
