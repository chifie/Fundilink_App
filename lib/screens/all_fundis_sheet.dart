import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/fundi.dart';
import '../widgets/fundi_card.dart';

/// Modal sheet listing every fundi, opened from the home "See all".
void showAllFundisSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _AllFundisSheet(),
  );
}

class _AllFundisSheet extends StatelessWidget {
  const _AllFundisSheet();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Text('All fundis', style: text.titleLarge),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                for (final FundiProfile fundi in MockData.fundis)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FundiCard(fundi: fundi),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
