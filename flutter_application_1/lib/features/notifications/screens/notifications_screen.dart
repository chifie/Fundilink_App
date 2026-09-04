import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/notification_item.dart';
import '../../../providers/notification_provider.dart';
import '../../../widgets/empty_state.dart';

/// In-app notification inbox for request updates, chats and reviews.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final notifications = provider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () =>
                  context.read<NotificationProvider>().markAllRead(),
              child: const Text(AppStrings.markAllRead),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? EmptyState(
              icon: Icons.notifications_none,
              title: AppStrings.noNotifications,
              message:
                  'Updates about your requests and chats will appear here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingS,
              ),
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) =>
                  _NotificationTile(notification: notifications[index]),
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (notification.type) {
      'chat' => (Icons.chat_bubble_outline, AppColors.primary),
      'request' => (Icons.assignment_outlined, AppColors.info),
      'review' => (Icons.star_outline, AppColors.starFilled),
      _ => (Icons.notifications_outlined, AppColors.textHint),
    };

    return ListTile(
      onTap: () =>
          context.read<NotificationProvider>().markRead(notification.id),
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            Formatters.timeAgo(notification.createdAt),
            style: const TextStyle(color: AppColors.textHint, fontSize: 11),
          ),
        ],
      ),
      trailing: notification.isRead
          ? null
          : Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
    );
  }
}
