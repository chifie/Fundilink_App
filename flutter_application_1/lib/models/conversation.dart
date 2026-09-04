/// A chat conversation between a customer and a fundi.
class Conversation {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final String requestId;
  final String requestTitle;
  final String? lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  const Conversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    required this.requestId,
    required this.requestTitle,
    this.lastMessage,
    required this.lastMessageAt,
    this.unreadCount = 0,
  });

  Conversation copyWith({
    String? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return Conversation(
      id: id,
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      otherUserAvatar: otherUserAvatar,
      requestId: requestId,
      requestTitle: requestTitle,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}