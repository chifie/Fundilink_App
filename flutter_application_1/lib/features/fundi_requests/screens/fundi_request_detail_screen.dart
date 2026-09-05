import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/service_request.dart';
import '../../../providers/request_provider.dart';
import '../../../widgets/request_progress_tracker.dart';
import '../../../widgets/status_chip.dart';

/// Fundi-side request detail with accept/reject/start/complete actions.
class FundiRequestDetailScreen extends StatelessWidget {
  const FundiRequestDetailScreen({super.key, required this.request});

  final ServiceRequest request;

  Future<void> _updateStatus(BuildContext context, RequestStatus status) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final provider = context.read<RequestProvider>();
    await provider.updateStatus(request.id, status);
    messenger.showSnackBar(SnackBar(content: Text('Request ${status.label.toLowerCase()}.')));
    navigator.pop();
  }

  Future<void> _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required RequestStatus status,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text(AppStrings.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text(AppStrings.confirm)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await _updateStatus(context, status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestProvider>();
    final current = provider.byId(request.id) ?? request;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.requestDetails)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: [
          Row(
            children: [
              StatusChip(status: current.status),
              const Spacer(),
              Text(
                Formatters.currency(current.estimatedCost),
                style: const TextStyle(color: AppColors.forestGreen, fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceL),
          RequestProgressTracker(status: current.status),
          const SizedBox(height: AppDimensions.spaceL),
          Text(
            current.customerName,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(icon: Icons.description_outlined, text: current.description),
                  const Divider(height: 24),
                  _InfoRow(icon: Icons.category_outlined, text: current.categoryName),
                  const Divider(height: 24),
                  _InfoRow(icon: Icons.calendar_today_outlined, text: '${current.preferredDate} at ${current.preferredTime}'),
                  const Divider(height: 24),
                  _InfoRow(icon: Icons.location_on_outlined, text: current.location),
                ],
              ),
            ),
          ),
          if (current.images.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spaceL),
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: current.images.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppDimensions.spaceM),
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  child: Image.network(
                    current.images[index],
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 200,
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textHint),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.spaceXL),
          // Action buttons based on status
          if (current.status == RequestStatus.pending) ...[
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () => _confirmAction(
                  context,
                  title: 'Accept this request?',
                  message: 'You\'ll be expected to contact the customer and complete the work.',
                  status: RequestStatus.accepted,
                ),
                icon: const Icon(Icons.check, size: 18),
                label: const Text(AppStrings.accept),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () => _confirmAction(
                  context,
                  title: 'Reject this request?',
                  message: 'The customer will be notified that you declined.',
                  status: RequestStatus.rejected,
                ),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                icon: const Icon(Icons.close, size: 18),
                label: const Text(AppStrings.reject),
              ),
            ),
          ],
          if (current.status == RequestStatus.accepted) ...[
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () => _confirmAction(
                  context,
                  title: 'Start work?',
                  message: 'Mark this request as in progress.',
                  status: RequestStatus.inProgress,
                ),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text(AppStrings.startWork),
              ),
            ),
          ],
          if (current.status == RequestStatus.inProgress) ...[
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () => _confirmAction(
                  context,
                  title: 'Mark as complete?',
                  message: 'The customer will be notified that the work is done.',
                  status: RequestStatus.completed,
                ),
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text(AppStrings.markComplete),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textHint),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
