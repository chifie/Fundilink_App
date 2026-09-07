import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/availability.dart';
import '../../../models/fundi_model.dart';
import '../../../models/portfolio_item.dart';
import '../../../models/review.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/fundi_provider.dart';
import '../../../providers/request_provider.dart';
import '../../../providers/review_provider.dart';
import '../../../widgets/feedback/toast.dart';
import '../../../widgets/fundi_avatar.dart';
import '../../../widgets/rating_stars.dart';
import '../../../widgets/review_tile.dart';
import '../../../widgets/section_header.dart';
import '../../chat/screens/chat_thread_screen.dart';
import '../../service_request/screens/request_form_screen.dart';

/// Detailed public profile of a fundi: stats, availability, portfolio,
/// reviews plus chat and request actions.
class FundiProfileScreen extends StatefulWidget {
  const FundiProfileScreen({super.key, required this.fundi});

  final Fundi fundi;

  @override
  State<FundiProfileScreen> createState() => _FundiProfileScreenState();
}

class _FundiProfileScreenState extends State<FundiProfileScreen> {
  Fundi get fundi => widget.fundi;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewProvider>().loadReviews(fundi.id);
    });
  }

  Future<void> _startChat() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final chat = context.read<ChatProvider>();
    try {
      // Find an existing request to this fundi, if any.
      final requests = context.read<RequestProvider>();
      final existingRequest = requests.customerRequests
          .where((r) => r.fundiId == fundi.id)
          .toList();
      final requestId = existingRequest.isNotEmpty
          ? existingRequest.first.id
          : '';
      final requestTitle = existingRequest.isNotEmpty
          ? existingRequest.first.categoryName
          : fundi.categoryName;

      final conversation = await chat.startConversation(
        otherUserId: fundi.id,
        otherUserName: fundi.fullName,
        otherUserAvatar: fundi.avatarUrl,
        requestId: requestId,
        requestTitle: requestTitle,
      );
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChatThreadScreen(
            conversation: conversation,
            currentUserId: user.id,
          ),
        ),
      );
    } catch (_) {
      if (context.mounted) {
        Toast.showError(context, AppStrings.chatStartFailed);
      }
    }
  }

  Future<void> _requestService() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => RequestFormScreen(fundi: fundi)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fundiProvider = context.watch<FundiProvider>();
    final reviewProvider = context.watch<ReviewProvider>();
    final reviews = reviewProvider.reviewsFor(fundi.id);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.fundiProfile)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppDimensions.paddingXL),
        children: [
          _HeaderCard(fundi: fundi),
          const SizedBox(height: AppDimensions.spaceXS),
          _ActionCta(fundi: fundi),
          const SizedBox(height: AppDimensions.spaceM),
          _StatsRow(fundi: fundi),
          const SizedBox(height: AppDimensions.spaceL),
          FutureBuilder(
            future: fundiProvider.availabilityFor(fundi.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final availability = snapshot.data!;
              return _AvailabilityCard(availability: availability);
            },
          ),
          const SizedBox(height: AppDimensions.spaceL),
          _AboutCard(fundi: fundi),
          const SizedBox(height: AppDimensions.spaceL),
          _PortfolioSection(fundiProvider: fundiProvider, fundi: fundi),
          const SizedBox(height: AppDimensions.spaceL),
          _ReviewsSection(reviews: reviews),
        ],
      ),
      bottomNavigationBar: _ActionBar(
        onChat: _startChat,
        onRequest: _requestService,
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.fundi});

  final Fundi fundi;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          FundiAvatar(
            name: fundi.fullName,
            imageUrl: fundi.avatarUrl,
            radius: AppDimensions.avatarXL / 2,
            heroTag: 'fundi-avatar-${fundi.id}',
            useHero: true,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  fundi.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (fundi.verified) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.verified,
                  size: 20,
                  color: AppColors.forestGreen,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            fundi.categoryName,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.textHint,
              ),
              const SizedBox(width: 2),
              Text(
                '${fundi.location} · ${fundi.distanceKm.toStringAsFixed(1)} km',
                style: const TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
              const SizedBox(width: AppDimensions.spaceL),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: fundi.isAvailable
                      ? AppColors.successLight
                      : AppColors.errorLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  fundi.isAvailable
                      ? AppStrings.available
                      : AppStrings.unavailable,
                  style: TextStyle(
                    color: fundi.isAvailable
                        ? AppColors.success
                        : AppColors.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceS),
          RatingStars(rating: fundi.rating, showValue: true, size: 18),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.fundi});

  final Fundi fundi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Row(
        children: [
          _Stat(value: '${fundi.experienceYears}', label: AppStrings.years),
          _Stat(
            value: '${fundi.completedJobs}',
            label: AppStrings.completedJobs,
          ),
          _Stat(
            value: fundi.rating.toStringAsFixed(1),
            label: AppStrings.averageRating,
          ),
          _Stat(
            value: Formatters.currency(fundi.startingPrice),
            label: AppStrings.startingPrice,
            isPrice: true,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.isPrice = false});

  final String value;
  final String label;
  final bool isPrice;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isPrice ? AppColors.forestGreen : AppColors.textPrimary,
                fontSize: isPrice ? 12 : 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textHint, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard({required this.availability});

  final Availability availability;

  @override
  Widget build(BuildContext context) {
    final workingDays = availability.workingDays;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Row(
        children: [
          const Icon(Icons.event_available, color: AppColors.success, size: 20),
          const SizedBox(width: AppDimensions.spaceS),
          Expanded(
            child: Text(
              'Usually available ${workingDays.join('–')} · '
              '${availability.startTime} to ${availability.endTime}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.fundi});

  final Fundi fundi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: AppStrings.about),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            fundi.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Wrap(
            spacing: AppDimensions.spaceS,
            runSpacing: AppDimensions.spaceS,
            children: [
              for (final tag in fundi.serviceTags)
                Chip(
                  label: Text(tag),
                  labelStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  backgroundColor: AppColors.surfaceVariant,
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PortfolioSection extends StatelessWidget {
  const _PortfolioSection({required this.fundiProvider, required this.fundi});

  final FundiProvider fundiProvider;
  final Fundi fundi;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PortfolioItem>>(
      future: fundiProvider.portfolioFor(fundi.id),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <PortfolioItem>[];
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: AppStrings.portfolio),
            const SizedBox(height: AppDimensions.spaceM),
            SizedBox(
              height: 150,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimensions.spaceM),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    child: SizedBox(
                      width: 150,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: AppColors.surfaceVariant,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.textHint,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black54],
                                ),
                              ),
                              child: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.reviews});

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: AppStrings.reviews,
            actionLabel: reviews.isEmpty
                ? null
                : '${reviews.length} ${AppStrings.totalLabel}',
          ),
          const SizedBox(height: AppDimensions.spaceS),
          if (reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
              child: Text(
                AppStrings.noReviews,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            for (final review in reviews) ReviewTile(review: review),
        ],
      ),
    );
  }
}

class _ActionCta extends StatelessWidget {
  const _ActionCta({required this.fundi});
  final Fundi fundi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.forestGreen.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 16,
            color: AppColors.forestGreen,
          ),
          const SizedBox(width: 6),
          Text(
            'Chat with ${fundi.fullName}',
            style: const TextStyle(
              color: AppColors.forestGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.onChat, required this.onRequest});

  final VoidCallback onChat;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: AppDimensions.elevationHigh,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onChat,
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text(AppStrings.chat),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onRequest,
                  icon: const Icon(Icons.request_quote_outlined, size: 18),
                  label: const Text(AppStrings.requestService),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
