import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../models/service_request.dart';

/// The status buckets both request list screens can filter by.
enum RequestFilter { all, pending, active, completed }

extension RequestFilterX on RequestFilter {
  /// Filters [requests] down to this bucket.
  List<ServiceRequest> apply(List<ServiceRequest> requests) {
    switch (this) {
      case RequestFilter.all:
        return requests;
      case RequestFilter.pending:
        return requests
            .where((r) => r.status == RequestStatus.pending)
            .toList();
      case RequestFilter.active:
        return requests
            .where(
              (r) =>
                  r.status == RequestStatus.accepted ||
                  r.status == RequestStatus.inProgress,
            )
            .toList();
      case RequestFilter.completed:
        return requests
            .where(
              (r) =>
                  r.status == RequestStatus.completed ||
                  r.status == RequestStatus.reviewed,
            )
            .toList();
    }
  }

  /// User-facing chip label for this bucket.
  String get label {
    switch (this) {
      case RequestFilter.all:
        return AppStrings.all;
      case RequestFilter.pending:
        return AppStrings.pending;
      case RequestFilter.active:
        return AppStrings.inProgress;
      case RequestFilter.completed:
        return AppStrings.completed;
    }
  }
}

/// Horizontally scrollable status filter chips for request lists.
class RequestFilterBar extends StatelessWidget {
  const RequestFilterBar({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final RequestFilter current;
  final ValueChanged<RequestFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Row(
        children: [
          for (final filter in RequestFilter.values)
            _FilterChip(
              label: filter.label,
              selected: filter == current,
              onTap: () => onChanged(filter),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
        selectedColor: AppColors.primarySurface,
        labelStyle: TextStyle(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
      ),
    );
  }
}
