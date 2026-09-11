import '../data/mock_data.dart';
import '../models/notification_item.dart';

/// Data source for in-app notifications.
class NotificationRepository {
  static const Duration _latency = Duration(milliseconds: 400);

  Future<List<NotificationItem>> getNotifications() async {
    await Future<void>.delayed(_latency);
    final list = List<NotificationItem>.of(MockData.notifications);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> markAllRead() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    for (var i = 0; i < MockData.notifications.length; i++) {
      MockData.notifications[i] = MockData.notifications[i].copyWith(
        isRead: true,
      );
    }
  }

  Future<void> markRead(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final index = MockData.notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      MockData.notifications[index] = MockData.notifications[index].copyWith(
        isRead: true,
      );
    }
  }
}
