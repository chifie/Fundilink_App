import 'package:flutter/material.dart';

/// What an activity item is about, which decides its icon.
enum NotificationKind { message, awaitingFundi, inProgress, completed }

/// Icon shown beside a notification.
extension NotificationKindInfo on NotificationKind {
  IconData get icon => switch (this) {
    NotificationKind.message => Icons.chat_bubble_outline,
    NotificationKind.awaitingFundi => Icons.hourglass_empty,
    NotificationKind.inProgress => Icons.construction_outlined,
    NotificationKind.completed => Icons.task_alt,
  };
}

/// One row in the notifications sheet.
///
/// These are derived from the store's conversations and bookings rather than
/// stored separately, so they can never disagree with the data behind them.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.detail,
    this.contactName,
    this.isUnread = false,
  });

  final String id;
  final NotificationKind kind;
  final String title;
  final String detail;

  /// Set when tapping the row should open a chat thread.
  final String? contactName;

  /// True while the customer has not caught up with it.
  final bool isUnread;
}
