import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/service_request.dart';
import '../../../widgets/status_chip.dart';
import '../../customer_requests/screens/request_detail_screen.dart';

/// Shows the most recent fundi requests as a compact list.
class FundiRecentActivity extends StatelessWidget {
  const FundiRecentActivity({super.key, required this.requests});

  final List<ServiceRequest> requests;

  @override
  Widget build(BuildContext context) {
    final recent = requests.take(5).toList();
    if (recent.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppDimensions.paddingXL),
        child: Center(
          child: Text(
            'No recent activity yet.',
            style: TextStyle(color: AppColors.textHint),
          ),
        ),
      );
    }
    return Column(
      children: [for (final request in recent) _ActivityTile(request: request)],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.request});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceS),
      child: ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RequestDetailScreen(request: request),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: request.status.lightColor,
          child: Icon(
            request.status.icon,
            color: request.status.color,
            size: 20,
          ),
        ),
        title: Text(
          request.customerName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          request.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StatusChip(status: request.status, compact: true),
            const SizedBox(height: 4),
            Text(
              Formatters.timeAgo(request.createdAt),
              style: const TextStyle(color: AppColors.textHint, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
