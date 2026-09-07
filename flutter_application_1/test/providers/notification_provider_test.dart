import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/providers/notification_provider.dart';

void main() {
  group('NotificationProvider', () {
    test('load populates the inbox and computes unread count', () async {
      final provider = NotificationProvider();
      expect(provider.notifications, isEmpty);

      await provider.load();

      expect(provider.notifications, isNotEmpty);
      expect(provider.isLoading, isFalse);
      // Seed data has exactly one unread notification.
      expect(provider.unreadCount, 1);
    });

    test('markRead clears the unread flag on one item', () async {
      final provider = NotificationProvider();
      await provider.load();

      final unread = provider.notifications.firstWhere((n) => !n.isRead);
      await provider.markRead(unread.id);

      expect(provider.unreadCount, 0);
      expect(
        provider.notifications.firstWhere((n) => n.id == unread.id).isRead,
        isTrue,
      );
    });

    test('markAllRead clears every unread flag', () async {
      final provider = NotificationProvider();
      await provider.load();

      await provider.markAllRead();

      expect(provider.unreadCount, 0);
      expect(provider.notifications.every((n) => n.isRead), isTrue);
    });

    test('load can be repeated to refresh the inbox', () async {
      final provider = NotificationProvider();
      await provider.load();
      final before = provider.notifications.length;

      await provider.load();

      expect(provider.notifications.length, before);
    });
  });
}
