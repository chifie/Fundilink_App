import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../models/service_category.dart';

/// Filter options for fundi search.
class SearchFilterOptions {
  const SearchFilterOptions({
    this.categoryId,
    this.minRating,
    this.maxPrice,
    this.onlyAvailable = false,
    this.onlyVerified = false,
    this.sortBy = 'rating',
  });

  final String? categoryId;
  final double? minRating;
  final double? maxPrice;
  final bool onlyAvailable;
  final bool onlyVerified;
  final String sortBy;

  SearchFilterOptions copyWith({
    String? categoryId,
    double? minRating,
    double? maxPrice,
    bool? onlyAvailable,
    bool? onlyVerified,
    String? sortBy,
  }) {
    return SearchFilterOptions(
      categoryId: categoryId ?? this.categoryId,
      minRating: minRating ?? this.minRating,
      maxPrice: maxPrice ?? this.maxPrice,
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
      onlyVerified: onlyVerified ?? this.onlyVerified,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

/// Bottom sheet for advanced fundi search filtering.
Future<SearchFilterOptions?> showSearchFilters(
  BuildContext context, {
  required SearchFilterOptions current,
  required List<ServiceCategory> categories,
}) {
  return showModalBottomSheet<SearchFilterOptions>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    showDragHandle: true,
    builder: (_) =>
        _SearchFiltersSheet(current: current, categories: categories),
  );
}

class _SearchFiltersSheet extends StatefulWidget {
  const _SearchFiltersSheet({required this.current, required this.categories});
  final SearchFilterOptions current;
  final List<ServiceCategory> categories;

  @override
  State<_SearchFiltersSheet> createState() => _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends State<_SearchFiltersSheet> {
  late String? _categoryId;
  late String _sortBy;
  late bool _onlyAvailable;
  late bool _onlyVerified;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.current.categoryId;
    _sortBy = widget.current.sortBy;
    _onlyAvailable = widget.current.onlyAvailable;
    _onlyVerified = widget.current.onlyVerified;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingL,
        right: AppDimensions.paddingL,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppDimensions.paddingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            AppStrings.filterAndSort,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppDimensions.spaceL),

          // Sort by
          const Text(
            AppStrings.sortByLabel,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Wrap(
            spacing: AppDimensions.spaceS,
            children: [
              _SortChip(
                label: AppStrings.highestRated,
                value: 'rating',
                selected: _sortBy,
                onTap: (v) => setState(() => _sortBy = v),
              ),
              _SortChip(
                label: AppStrings.lowestPrice,
                value: 'price',
                selected: _sortBy,
                onTap: (v) => setState(() => _sortBy = v),
              ),
              _SortChip(
                label: AppStrings.nearest,
                value: 'distance',
                selected: _sortBy,
                onTap: (v) => setState(() => _sortBy = v),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceL),

          // Category
          const Text(
            AppStrings.categoryLabel,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Wrap(
            spacing: AppDimensions.spaceS,
            runSpacing: AppDimensions.spaceS,
            children: [
              _SortChip(
                label: AppStrings.all,
                value: '',
                selected: _categoryId ?? '',
                onTap: (v) => setState(() => _categoryId = null),
              ),
              for (final cat in widget.categories)
                _SortChip(
                  label: cat.name,
                  value: cat.id,
                  selected: _categoryId ?? '',
                  onTap: (v) => setState(() => _categoryId = v),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceL),

          // Toggles
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              AppStrings.availableOnly,
              style: TextStyle(fontSize: 14),
            ),
            value: _onlyAvailable,
            onChanged: (v) => setState(() => _onlyAvailable = v),
            activeThumbColor: AppColors.primary,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              AppStrings.verifiedOnly,
              style: TextStyle(fontSize: 14),
            ),
            value: _onlyVerified,
            onChanged: (v) => setState(() => _onlyVerified = v),
            activeThumbColor: AppColors.primary,
          ),
          const SizedBox(height: AppDimensions.spaceL),

          // Apply button
          SizedBox(
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(
                  SearchFilterOptions(
                    categoryId: _categoryId,
                    sortBy: _sortBy,
                    onlyAvailable: _onlyAvailable,
                    onlyVerified: _onlyVerified,
                  ),
                );
              },
              child: const Text(AppStrings.apply),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(value),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    );
  }
}
