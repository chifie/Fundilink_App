import 'package:flutter/material.dart';

import '../models/fundi.dart';
import '../widgets/fundi_card.dart';

/// Full-screen search with live fundi filtering.
class FundiSearchDelegate extends SearchDelegate<FundiProfile?> {
  FundiSearchDelegate({required this.fundis});

  final List<FundiProfile> fundis;

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
  Widget buildResults(BuildContext context) {
    return _resultsList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _resultsList(context);
  }

  Widget _resultsList(BuildContext context) {
    final q = query.trim().toLowerCase();
    final results = q.isEmpty
        ? fundis
        : fundis.where((fundi) {
            final name = fundi.name.toLowerCase();
            final skill = fundi.skill.label.toLowerCase();
            return name.contains(q) || skill.contains(q);
          }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            Text('No fundis found for "$query"'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: results.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FundiCard(
          fundi: results[index],
          onBook: () => close(context, results[index]),
        ),
      ),
    );
  }
}
