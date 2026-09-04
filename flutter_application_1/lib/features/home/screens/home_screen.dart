import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/navigation/customer_tabs.dart';
import '../../../models/fundi_model.dart';
import '../../../models/service_category.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/fundi_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/fundi_card.dart';
import '../../../widgets/section_header.dart';
import '../../fundi_profile/screens/fundi_profile_screen.dart';
import '../../notifications/screens/notifications_screen.dart';

/// Customer landing tab: greeting, category grid, recommended and nearby
/// fundis.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openFundi(BuildContext context, Fundi fundi) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => FundiProfileScreen(fundi: fundi)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fundiProvider = context.watch<FundiProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final user = context.watch<AuthProvider>().user;

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
          ? const Center(child: CircularProgressIndicator())
          : fundiProvider.error != null && !hasContent
          ? ErrorView(
              message: fundiProvider.error,
              onRetry: () {
                fundiProvider.loadCategories();
                fundiProvider.loadFundis();
              },
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingXL),
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
                    onActionTap: () => CustomerTabs.goTo(CustomerTabs.search),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  _CategoryGrid(categories: categories),
                  const SizedBox(height: AppDimensions.spaceXL),
                ],
                if (fundiProvider.recommended.isNotEmpty) ...[
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
                  for (final fundi in fundiProvider.nearby)
                    FundiCard(
                      fundi: fundi,
                      onTap: () => _openFundi(context, fundi),
                    ),
                ],
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
          const Text(
            'What service do you need today?',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
      onTap: () {
        CustomerTabs.categoryRequest.value = category.id;
        CustomerTabs.goTo(CustomerTabs.search);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
