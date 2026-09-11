/// A single message inside a conversation.
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  /// Returns true if this message was sent by the current user.
  bool isFromMe(String currentUserId) => senderId == currentUserId;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });
}
