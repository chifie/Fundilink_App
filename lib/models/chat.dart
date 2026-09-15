/// A chat conversation row shown in the chats tab.
class Conversation {
  const Conversation({
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    required this.unreadCount,
    required this.isOnline,
  });

  final String name;

  /// Preview of the most recent message.
  final String lastMessage;

  /// Preformatted timestamp, e.g. "09:41" or "Tue".
  final String timeLabel;
  final int unreadCount;
  final bool isOnline;
}
