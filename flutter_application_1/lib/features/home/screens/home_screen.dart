import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/navigation/customer_tabs.dart';
import '../../../core/navigation/page_transitions.dart';
import '../../../models/fundi_model.dart';
import '../../../models/service_category.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/fundi_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/fundi_card.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/shimmer_loading.dart';
import '../../fundi_profile/screens/fundi_profile_screen.dart';
import '../../notifications/screens/notifications_screen.dart';

/// Customer landing tab: greeting, category grid, recommended and nearby
/// fundis.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openFundi(BuildContext context, Fundi fundi) {
    Navigator.of(context).push(
      SlideUpRoute(page: FundiProfileScreen(fundi: fundi)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fundiProvider = context.watch<FundiProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final user = context.watch<AuthProvider>().user;
    final showNewBadge = fundiProvider.recommended.isNotEmpty && fundiProvider.nearby.isNotEmpty;

    final categories = fundiProvider.categories;
    final isLoading = fundiProvider.isLoading;
    final hasContent = fundiProvider.fundis.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            tooltip: AppStrings.notifications,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const NotificationsScreen(),
              ),
            ),
            icon: Badge(
              isLabelVisible: notificationProvider.unreadCount > 0,
              label: Text('${notificationProvider.unreadCount}'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
        ],
      ),
      body: isLoading && !hasContent
          ? const _LoadingSkeleton()
          : fundiProvider.error != null && !hasContent
              ? ErrorView(
                  message: fundiProvider.error,
                  onRetry: () {
                    fundiProvider.loadCategories();
                    fundiProvider.loadFundis();
                  },
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await fundiProvider.loadCategories();
                    await fundiProvider.loadFundis();
                  },
                  child: ListView(
                    padding:
                        const EdgeInsets.only(bottom: AppDimensions.paddingXL),
                    children: [
                      _Greeting(name: user?.fullName ?? 'there'),
                      const SizedBox(height: AppDimensions.spaceM),
                      _HeroSearch(
                        onTap: () => CustomerTabs.goTo(CustomerTabs.search),
                      ),
                      const SizedBox(height: AppDimensions.spaceXL),
                      if (categories.isNotEmpty) ...[
                        SectionHeader(
                          title: AppStrings.popularCategories,
                          actionLabel: AppStrings.viewAll,
                          onActionTap: () =>
                              CustomerTabs.goTo(CustomerTabs.search),
                        ),
                        const SizedBox(height: AppDimensions.spaceM),
                        _CategoryGrid(categories: categories),
                        const SizedBox(height: AppDimensions.spaceXL),
                      ],
                      if (fundiProvider.recommended.isNotEmpty) ...[
                        if (showNewBadge)
                          _NewArrivalsBanner(),
                        const SectionHeader(title: AppStrings.recommendedFundi),
                        const SizedBox(height: AppDimensions.spaceM),
                        SizedBox(
                          height: 210,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingM,
                            ),
                            itemCount: fundiProvider.recommended.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: AppDimensions.spaceM),
                            itemBuilder: (context, index) {
                              final fundi = fundiProvider.recommended[index];
                              return FundiCardCompact(
                                fundi: fundi,
                                onTap: () => _openFundi(context, fundi),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceXL),
                      ],
                      if (fundiProvider.nearby.isNotEmpty) ...[
                        const SectionHeader(title: AppStrings.nearbyFundi),
                        const SizedBox(height: AppDimensions.spaceS),
                        for (var i = 0; i < fundiProvider.nearby.length; i++)
                          _StaggeredItem(
                            index: i,
                            child: FundiCard(
                              fundi: fundiProvider.nearby[i],
                              onTap: () =>
                                  _openFundi(context, fundiProvider.nearby[i]),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
    );
  }
}

class _NewArrivalsBanner extends StatelessWidget {
  const _NewArrivalsBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: AppColors.forestGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco, size: 12, color: AppColors.forestGreen),
          const SizedBox(width: 4),
          Text(
            AppStrings.newArrivalsAvailable,
            style: const TextStyle(
              color: AppColors.forestGreen,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.greeting}$name 👋',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.homeSubtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSearch extends StatelessWidget {
  const _HeroSearch({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        elevation: AppDimensions.elevationLow,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Container(
            height: AppDimensions.inputHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: AppColors.textHint),
                SizedBox(width: AppDimensions.spaceM),
                Text(
                  AppStrings.searchHint,
                  style: TextStyle(color: AppColors.textHint, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});

  final List<ServiceCategory> categories;

  @override
  Widget build(BuildContext context) {
    final visible = categories.take(8).toList();
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      mainAxisSpacing: AppDimensions.spaceM,
      crossAxisSpacing: AppDimensions.spaceM,
      childAspectRatio: 0.82,
      children: [
        for (final category in visible) _CategoryItem(category: category),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});

  final ServiceCategory category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      splashColor: category.color.withValues(alpha: 0.15),
      highlightColor: category.color.withValues(alpha: 0.05),
      onTap: () {
        CustomerTabs.categoryRequest.value = category.id;
        CustomerTabs.goTo(CustomerTabs.search);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(category.icon, color: category.color, size: 26),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            category.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingXL),
      children: [
        const SizedBox(height: AppDimensions.paddingXL + 56),
        // Greeting skeleton
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoading(
                child: SizedBox(
                  width: 200,
                  height: 26,
                  child: ColoredBox(color: AppColors.surfaceVariant),
                ),
              ),
              SizedBox(height: 8),
              ShimmerLoading(
                child: SizedBox(
                  width: 180,
                  height: 16,
                  child: ColoredBox(color: AppColors.surfaceVariant),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
        // Search bar skeleton
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
          child: ShimmerLoading(
            child: SizedBox(
              height: 52,
              child: ColoredBox(color: AppColors.surfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXL),
        // Categories skeleton
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          child: ShimmerLoading(
            child: SizedBox(
              width: 140,
              height: 20,
              child: ColoredBox(color: AppColors.surfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            itemCount: 8,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppDimensions.spaceM),
            itemBuilder: (_, _) => const ShimmerCategoryItem(),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXL),
        // Recommended skeleton
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          child: ShimmerLoading(
            child: SizedBox(
              width: 180,
              height: 20,
              child: ColoredBox(color: AppColors.surfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            itemCount: 4,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppDimensions.spaceM),
            itemBuilder: (_, _) => const ShimmerCompactCard(),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXL),
        // Nearby skeleton
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          child: ShimmerLoading(
            child: SizedBox(
              width: 140,
              height: 20,
              child: ColoredBox(color: AppColors.surfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
        const ShimmerFundiCard(),
        const ShimmerFundiCard(),
        const ShimmerFundiCard(),
      ],
    );
  }
}

/// Wraps a child widget with a staggered fade-in-slide animation.
class _StaggeredItem extends StatefulWidget {
  const _StaggeredItem({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    // Start the animation after a staggered delay using the ticker.
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
