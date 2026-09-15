import 'package:flutter/material.dart';

import '../models/notification.dart';
import '../screens/chat_room_screen.dart';
import '../state/store_scope.dart';
import '../widgets/empty_state.dart';

/// Opens the activity feed over the current screen.
void showNotificationsSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const NotificationsSheet(),
  );
}

/// Activity feed: unread chats and booking updates, unread items first.
class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final notifications = context.store.notifications;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text('Notifications', style: text.titleLarge),
            ),
            if (notifications.isEmpty)
              const EmptyState(
                icon: Icons.notifications_none,
                title: 'Nothing new',
                message: 'Messages and booking updates show up here.',
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 8),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) => _NotificationTile(
                    item: notifications[index],
                    colors: colors,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Single activity row, tappable when it points at a chat thread.
class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.colors});

  final AppNotification item;
  final ColorScheme colors;

  void _openContact(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => ChatRoomScreen(contactName: item.contactName!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: item.isUnread
            ? colors.primaryContainer
            : colors.surfaceContainerHighest,
        child: Icon(
          item.kind.icon,
          size: 20,
          color: item.isUnread
              ? colors.onPrimaryContainer
              : colors.onSurfaceVariant,
        ),
      ),
      title: Text(
        item.title,
        style: item.isUnread
            ? const TextStyle(fontWeight: FontWeight.w600)
            : null,
      ),
      subtitle: Text(item.detail, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: item.isUnread
          ? Container(
              key: const Key('notification-unread-dot'),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: item.contactName == null ? null : () => _openContact(context),
    );
  }
}
