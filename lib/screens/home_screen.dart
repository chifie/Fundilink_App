import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/fundi.dart';
import '../widgets/fundi_card.dart';
import '../widgets/search_bar_field.dart';
import '../widgets/section_header.dart';
import '../widgets/service_category_grid.dart';

/// Landing tab: greeting, search, categories and top-rated fundis.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
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
                        Text('Find a trusted fundi',
                            style: text.headlineSmall),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'Notifications',
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: SearchBarField(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ServiceCategoryGrid(
                onTap: (skill) {},
              ),
            ),
            const SectionHeader(title: 'Top rated fundis', onSeeAll: null),
            for (final FundiProfile fundi in MockData.fundis.take(3))
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: FundiCard(
                  fundi: fundi,
                  onView: () {},
                  onBook: () {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
