import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/request_status_extension.dart';
import '../../../models/service_request.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/request_provider.dart';
import '../../../widgets/dialogs/confirm_dialog.dart';
import '../../../widgets/status_chip.dart';
import '../../../widgets/write_review_sheet.dart';
import '../../chat/screens/chat_thread_screen.dart';

/// Full details and customer actions for a single service request.
class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key, required this.request});

  final ServiceRequest request;

  Future<void> _cancel(BuildContext context, ServiceRequest current) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final provider = context.read<RequestProvider>();
    final confirmed = await showConfirmDialog(
      context,
      title: AppStrings.cancelThisRequest,
      message: AppStrings.cancelRequestHint,
      confirmLabel: AppStrings.yes,
      cancelLabel: AppStrings.no,
      confirmColor: AppColors.error,
    );
    if (!confirmed) return;
    await provider.updateStatus(current.id, RequestStatus.rejected);
    messenger.showSnackBar(
      const SnackBar(content: Text(AppStrings.requestCancelled)),
    );
    navigator.pop();
  }

  Future<void> _chatWithFundi(BuildContext context) async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final chat = context.read<ChatProvider>();
    final conversation = await chat.startConversation(
      otherUserId: request.fundiId,
      otherUserName: request.fundiName,
      otherUserAvatar: request.fundiAvatar,
      requestId: request.id,
      requestTitle: request.categoryName,
    );
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatThreadScreen(
          conversation: conversation,
          currentUserId: user.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestProvider>();
    final current = provider.byId(request.id) ?? request;
    final user = context.watch<AuthProvider>().user;

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
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            '${current.categoryName} · ${current.fundiName}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          _InfoCard(
            children: [
              _InfoRow(
                icon: Icons.description_outlined,
                text: current.description,
              ),
              const Divider(height: 24),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                text: '${current.preferredDate} at ${current.preferredTime}',
              ),
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: current.location,
              ),
            ],
          ),
          if (current.images.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spaceL),
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: current.images.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimensions.spaceM),
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  child: Image.network(
                    current.images[index],
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 200,
                      color: AppColors.surfaceVariant,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.spaceL),
          _statusHint(current),
          const SizedBox(height: AppDimensions.spaceL),
          OutlinedButton.icon(
            onPressed: () => _chatWithFundi(context),
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: const Text(AppStrings.messageFundi),
          ),
          if (current.status == RequestStatus.pending) ...[
            const SizedBox(height: AppDimensions.spaceM),
            TextButton.icon(
              onPressed: () => _cancel(context, current),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: const Text(AppStrings.cancelRequest),
            ),
          ],
          if (current.status == RequestStatus.completed) ...[
            const SizedBox(height: AppDimensions.spaceM),
            ElevatedButton.icon(
              onPressed: () => showWriteReviewSheet(
                context,
                fundiId: current.fundiId,
                customerName: user?.fullName ?? 'Customer',
              ),
              icon: const Icon(Icons.star_outline, size: 18),
              label: const Text(AppStrings.writeReview),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusHint(ServiceRequest current) {
    final icon = current.status.icon;
    final text = current.status.customerHint(current.fundiName);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(children: children),
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
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
