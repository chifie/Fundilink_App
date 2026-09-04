import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../models/service_request.dart';

/// Visual step-by-step progress tracker for a service request.
class RequestProgressTracker extends StatelessWidget {
  const RequestProgressTracker({super.key, required this.status});
  final RequestStatus status;

  static const List<(RequestStatus, String, IconData)> _steps = [
    (RequestStatus.pending, 'Pending', Icons.schedule),
    (RequestStatus.accepted, 'Accepted', Icons.check_circle_outline),
    (RequestStatus.inProgress, 'In Progress', Icons.build_circle_outlined),
    (RequestStatus.completed, 'Completed', Icons.verified_outlined),
    (RequestStatus.reviewed, 'Reviewed', Icons.rate_review_outlined),
  ];

  int _statusIndex(RequestStatus s) {
    return _steps.indexWhere((step) => step.$1 == s);
  }

  @override
  Widget build(BuildContext context) {
    if (status == RequestStatus.rejected) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: AppColors.error, size: 20),
            SizedBox(width: 8),
            Text(
              'This request was cancelled',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    final currentIndex = _statusIndex(status);

    return Row(
      children: [
        for (var i = 0; i < _steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                // Circle
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i <= currentIndex ? AppColors.primary : AppColors.surfaceVariant,
                    border: Border.all(
                      color: i <= currentIndex ? AppColors.primary : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _steps[i].$3,
                    size: 14,
                    color: i <= currentIndex ? AppColors.textOnPrimary : AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 4),
                // Label
                Text(
                  _steps[i].$2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: i == currentIndex ? FontWeight.w700 : FontWeight.w500,
                    color: i <= currentIndex ? AppColors.primary : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          // Connector line
          if (i < _steps.length - 1)
            Container(
              width: 20,
              height: 2,
              color: i < currentIndex ? AppColors.primary : AppColors.border,
            ),
        ],
      ],
    );
  }
}
