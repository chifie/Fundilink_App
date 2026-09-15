import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/fundi.dart';
import '../screens/fundi_detail_sheet.dart';
import '../widgets/empty_state.dart';
import '../widgets/fundi_card.dart';

/// Sort options for the fundi catalogue.
enum FundiSort { rating, priceLow, priceHigh, jobs }

/// Human labels for the sort options.
extension FundiSortLabel on FundiSort {
  String get label => switch (this) {
    FundiSort.rating => 'Top rated',
    FundiSort.priceLow => 'Price: low to high',
    FundiSort.priceHigh => 'Price: high to low',
    FundiSort.jobs => 'Most jobs',
  };
}

/// Full fundi catalogue with skill filters and sorting.
class AllFundisScreen extends StatefulWidget {
  const AllFundisScreen({super.key});

  @override
  State<AllFundisScreen> createState() => _AllFundisScreenState();
}

class _AllFundisScreenState extends State<AllFundisScreen> {
  FundiSkill? _skillFilter;
  FundiSort _sort = FundiSort.rating;

  List<FundiProfile> get _filtered {
    final fundis =
        MockData.fundis
            .where((f) => _skillFilter == null || f.skill == _skillFilter)
            .toList()
          ..sort((a, b) {
            switch (_sort) {
              case FundiSort.rating:
                return b.rating.compareTo(a.rating);
              case FundiSort.priceLow:
                return a.pricePerHour.compareTo(b.pricePerHour);
              case FundiSort.priceHigh:
                return b.pricePerHour.compareTo(a.pricePerHour);
              case FundiSort.jobs:
                return b.jobsDone.compareTo(a.jobsDone);
            }
          });
    return fundis;
  }

  @override
  Widget build(BuildContext context) {
    final fundis = _filtered;

    return Scaffold(
      appBar: AppBar(title: const Text('All fundis')),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: _skillFilter == null,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _skillFilter = null),
                  ),
                ),
                for (final skill in FundiSkill.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(skill.label),
                      selected: _skillFilter == skill,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _skillFilter = skill),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.sort, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<FundiSort>(
                    value: _sort,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: [
                      for (final sort in FundiSort.values)
                        DropdownMenuItem(value: sort, child: Text(sort.label)),
                    ],
                    onChanged: (sort) {
                      if (sort != null) setState(() => _sort = sort);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: fundis.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off,
                    title: 'No fundis in this category',
                    message: 'Try another service or clear the filter.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: fundis.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FundiCard(
                        fundi: fundis[index],
                        onView: () =>
                            showFundiDetailSheet(context, fundis[index]),
                        onBook: () =>
                            showFundiDetailSheet(context, fundis[index]),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
