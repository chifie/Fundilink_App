import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

import '../../../models/portfolio_item.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/fundi_provider.dart';
import '../../../widgets/empty_state.dart';

/// Manage portfolio items (work samples) for the fundi.
class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fundiProvider = context.watch<FundiProvider>();
    final user = context.read<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myPortfolio),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add portfolio item coming soon')),
              );
            },
            icon: const Icon(Icons.add_photo_alternate_outlined),
          ),
        ],
      ),
      body: FutureBuilder<List<PortfolioItem>>(
        future: fundiProvider.portfolioFor(user?.id ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.photo_library_outlined,
              title: AppStrings.noPortfolio,
              message: 'Showcase your best work to attract more customers.',
              actionLabel: AppStrings.addWork,
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppDimensions.spaceM,
              crossAxisSpacing: AppDimensions.spaceM,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _PortfolioTile(item: item);
            },
          );
        },
      ),
    );
  }
}

class _PortfolioTile extends StatelessWidget {
  const _PortfolioTile({required this.item});
  final PortfolioItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: AppColors.surfaceVariant,
              child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textHint),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.forestGreen.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
