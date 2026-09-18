import 'package:flutter/material.dart';

import '../models/fundi.dart';
import '../screens/all_fundis_screen.dart';
import '../screens/fundi_detail_sheet.dart';
import '../screens/notifications_sheet.dart';
import '../search/fundi_search_delegate.dart';
import '../state/store_scope.dart';
import '../widgets/fundi_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/search_bar_field.dart';
import '../widgets/section_header.dart';
import '../widgets/service_category_grid.dart';

/// Landing tab: greeting, search, categories and top-rated fundis.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: context.storeRead.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good morning 👋', style: text.bodyMedium),
                          Text(
                            'Find a trusted fundi',
                            style: text.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    Badge.count(
                      count: context.store.unreadNotificationCount,
                      isLabelVisible: context.store.unreadNotificationCount > 0,
                      child: IconButton.filledTonal
                        tooltip: 'Notifications',
                        onPressed: () => showNotificationsSheet(context),
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBarField(
                  onTap: () async {
                    final fundi = await showSearch<FundiProfile?>(
                      context: context,
                      delegate: FundiSearchDelegate(store: context.storeRead),
                    );
                    if (fundi == null || !context.mounted) return;
                    showFundiDetailSheet(context, fundi);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ServiceCategoryGrid(
                  onTap: (skill) => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AllFundisScreen(initialSkill: skill),
                    ),
                  ),
                ),
              ),
              const PromoBanner(),
              SectionHeader(
                title: 'Top rated fundis',
                onSeeAll: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AllFundisScreen(),
                    ),
                  );
                },
              ),
              for (final FundiProfile fundi in context.store.topRatedFundis)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: FundiCard(
                    fundi: fundi,
                    onView: () => showFundiDetailSheet(context, fundi),
                    onBook: () => showFundiDetailSheet(context, fundi),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
