import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/navigation/customer_tabs.dart';
import '../../../core/utils/debouncer.dart';
import '../../../models/fundi_model.dart';
import '../../../providers/fundi_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/fundi_card.dart';
import '../../../widgets/search_filters_sheet.dart';
import '../../../widgets/shimmer_loading.dart';
import '../../fundi_profile/screens/fundi_profile_screen.dart';

/// Explore tab: full-text search with category filters and result sorting.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  final Debouncer _debounce = Debouncer();
  String? _appliedCategoryId;
  String _sortBy = 'rating';
  bool _onlyAvailable = false;
  bool _onlyVerified = false;
  double? _minRating;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    CustomerTabs.categoryRequest.addListener(_onCategoryRequest);
    _onCategoryRequest();
  }

  @override
  void dispose() {
    _debounce.dispose();
    CustomerTabs.categoryRequest.removeListener(_onCategoryRequest);
    _queryController.dispose();
    super.dispose();
  }

  void _onCategoryRequest() {
    final categoryId = CustomerTabs.categoryRequest.value;
    if (categoryId == null || categoryId == _appliedCategoryId) return;
    _appliedCategoryId = categoryId;
    _queryController.clear();
    _applySearch();
  }

  /// Runs the current query against the provider with every active filter.
  void _applySearch() {
    final query = _queryController.text.trim();
    context.read<FundiProvider>().loadFundis(
      categoryId: _appliedCategoryId,
      query: query.isEmpty ? null : query,
      sortBy: _sortBy,
      onlyAvailable: _onlyAvailable,
      onlyVerified: _onlyVerified,
      minRating: _minRating,
      maxPrice: _maxPrice,
    );
  }

  void _scheduleSearch(String query) {
    _debounce.run(_applySearch);
  }

  void _selectCategory(String? categoryId) {
    _appliedCategoryId = categoryId;
    _applySearch();
  }

  void _sort(String sortBy) {
    _sortBy = sortBy;
    _applySearch();
  }

  Future<void> _openFilters() async {
    final provider = context.read<FundiProvider>();
    final options = await showSearchFilters(
      context,
      current: SearchFilterOptions(
        categoryId: _appliedCategoryId,
        onlyAvailable: _onlyAvailable,
        onlyVerified: _onlyVerified,
        sortBy: _sortBy,
        minRating: _minRating,
        maxPrice: _maxPrice,
      ),
      categories: provider.categories,
    );
    if (options == null || !mounted) return;
    setState(() {
      _appliedCategoryId = options.categoryId;
      _onlyAvailable = options.onlyAvailable;
      _onlyVerified = options.onlyVerified;
      _sortBy = options.sortBy;
      _minRating = options.minRating;
      _maxPrice = options.maxPrice;
    });
    _applySearch();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FundiProvider>();
    final hasQuery = _queryController.text.trim().isNotEmpty;
    final categories = provider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.search),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: AppStrings.filter,
            onPressed: _openFilters,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: AppStrings.sort,
            initialValue: _sortBy,
            onSelected: _sort,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'rating',
                child: Text(AppStrings.sortHighestRated),
              ),
              PopupMenuItem(
                value: 'price',
                child: Text(AppStrings.sortLowestPrice),
              ),
              PopupMenuItem(
                value: 'distance',
                child: Text(AppStrings.sortNearestFirst),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.paddingM,
              AppDimensions.paddingS,
              AppDimensions.paddingM,
              AppDimensions.paddingXS,
            ),
            child: TextField(
              controller: _queryController,
              onChanged: (value) {
                setState(() {});
                _scheduleSearch(value);
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _queryController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: AppStrings.clearSearch,
                        onPressed: () {
                          _queryController.clear();
                          setState(() {});
                          _applySearch();
                        },
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
              ),
              children: [
                _CategoryFilterChip(
                  label: AppStrings.all,
                  selected: _appliedCategoryId == null,
                  onTap: () => _selectCategory(null),
                ),
                for (final category in categories)
                  _CategoryFilterChip(
                    label: category.name,
                    selected: _appliedCategoryId == category.id,
                    onTap: () => _selectCategory(category.id),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Expanded(child: _buildResults(context, provider, hasQuery)),
        ],
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    FundiProvider provider,
    bool hasQuery,
  ) {
    if (provider.isLoading) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        children: const [
          ShimmerFundiCard(),
          ShimmerFundiCard(),
          ShimmerFundiCard(),
          ShimmerFundiCard(),
        ],
      );
    }
    if (provider.error != null) {
      return ErrorView(message: provider.error, onRetry: _applySearch);
    }
    final fundis = provider.fundis;
    if (fundis.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: hasQuery
            ? AppStrings.noResults
            : AppStrings.discoverFundisNearYou,
        message: hasQuery
            ? AppStrings.noResultsHint
            : AppStrings.searchEmptyMessage,
      );
    }
    return RefreshIndicator(
      onRefresh: () async => _applySearch(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        itemCount: fundis.length,
        itemBuilder: (context, index) => _FundiResultTile(fundi: fundis[index]),
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: AppColors.forestGreen,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        side: BorderSide(
          color: selected ? AppColors.forestGreen : AppColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _FundiResultTile extends StatelessWidget {
  const _FundiResultTile({required this.fundi});

  final Fundi fundi;

  @override
  Widget build(BuildContext context) {
    return FundiCard(
      fundi: fundi,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => FundiProfileScreen(fundi: fundi),
        ),
      ),
    );
  }
}
