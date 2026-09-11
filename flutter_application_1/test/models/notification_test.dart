import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/notification_item.dart';

void main() {
  group('NotificationItem.isUnread', () {
    test('returns true when the notification is unread', () {
      final notification = NotificationItem(
        id: 'n1',
        type: 'chat',
        title: 'New message',
        body: 'Hello',
        createdAt: DateTime(2026, 9, 7),
        isRead: false,
      );
      expect(notification.isUnread, isTrue);
    });

    test('returns false when the notification is read', () {
      final notification = NotificationItem(
        id: 'n2',
        type: 'request',
        title: 'Request accepted',
        body: 'Your request was accepted',
        createdAt: DateTime(2026, 9, 7),
        isRead: true,
      );
      expect(notification.isUnread, isFalse);
    });
  });
}
