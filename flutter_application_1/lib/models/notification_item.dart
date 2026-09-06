/// An in-app notification (request updates, messages, reviews...).
class NotificationItem {
  final String id;
  final String type; // request | chat | review | system
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
