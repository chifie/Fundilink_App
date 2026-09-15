import 'package:flutter/material.dart';

import '../models/fundi.dart';
import '../state/app_store.dart';
import '../widgets/empty_state.dart';
import '../widgets/fundi_card.dart';

/// Full-screen search with live fundi filtering and a search history.
class FundiSearchDelegate extends SearchDelegate<FundiProfile?> {
  FundiSearchDelegate({required this.store});

  final AppStore store;

  @override
  String get searchFieldLabel => 'Search services or fundis';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Clear query',
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton(onPressed: () => close(context, null));
  }

  @override
  void showResults(BuildContext context) {
    // Only a submitted search is worth remembering; live typing is not.
    final term = query.trim();
    if (term.isNotEmpty) store.recordSearch(term);
    super.showResults(context);
  }

  /// Fundis whose name or service matches the query, case-insensitively.
  ///
  /// An empty query suggests the top-rated fundis instead of nothing.
  List<FundiProfile> matches() {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return store.topRatedFundis;

    return store.fundis
        .where(
          (fundi) =>
              fundi.name.toLowerCase().contains(term) ||
              fundi.skill.label.toLowerCase().contains(term),
        )
        .toList();
  }

  @override
  Widget buildResults(BuildContext context) => _resultList(context, matches());

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      // The history lives in the store and SearchDelegate does not listen to
      // it, so this section repaints itself when the history changes.
      return ListenableBuilder(
        listenable: store,
        builder: (context, _) => _history(context),
      );
    }
    return _resultList(context, matches());
  }

  /// Recent searches plus a starting point, shown before anything is typed.
  Widget _history(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final recent = store.recentSearches;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        if (recent.isNotEmpty) ...[
          Row(
            children: [
              Expanded(child: Text('Recent searches', style: text.titleSmall)),
              TextButton(
                onPressed: store.clearRecentSearches,
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final term in recent)
                ActionChip(
                  avatar: const Icon(Icons.history, size: 18),
                  label: Text(term),
                  onPressed: () {
                    query = term;
                    showResults(context);
                  },
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],
        Text('Suggested for you', style: text.titleSmall),
        const SizedBox(height: 8),
        for (final fundi in store.topRatedFundis)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FundiCard(
              fundi: fundi,
              onView: () => close(context, fundi),
              onBook: () => close(context, fundi),
            ),
          ),
      ],
    );
  }

  Widget _resultList(BuildContext context, List<FundiProfile> results) {
    if (results.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: 'No fundis found',
        message:
            'Nothing matches "${query.trim()}". Try another service or name.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: results.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FundiCard(
          fundi: results[index],
          onView: () => close(context, results[index]),
          onBook: () => close(context, results[index]),
        ),
      ),
    );
  }
}
