import '../utils/formatters.dart';

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

  /// True when the customer still has messages to catch up on.
  bool get hasUnread => unreadCount > 0;

  /// Copy with any field replaced; omitted fields keep their value.
  Conversation copyWith({
    String? name,
    String? lastMessage,
    String? timeLabel,
    int? unreadCount,
    bool? isOnline,
  }) => Conversation(
    name: name ?? this.name,
    lastMessage: lastMessage ?? this.lastMessage,
    timeLabel: timeLabel ?? this.timeLabel,
    unreadCount: unreadCount ?? this.unreadCount,
    isOnline: isOnline ?? this.isOnline,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Conversation &&
          other.name == name &&
          other.lastMessage == lastMessage &&
          other.timeLabel == timeLabel &&
          other.unreadCount == unreadCount &&
          other.isOnline == isOnline;

  @override
  int get hashCode =>
      Object.hash(name, lastMessage, timeLabel, unreadCount, isOnline);

  /// Rebuilds a conversation from the JSON written by [toJson].
  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    name: json['name'] as String,
    lastMessage: json['lastMessage'] as String,
    timeLabel: json['timeLabel'] as String,
    unreadCount: json['unreadCount'] as int,
    isOnline: json['isOnline'] as bool,
  );

  /// Plain JSON map, safe for `jsonEncode` and local persistence.
  Map<String, dynamic> toJson() => {
    'name': name,
    'lastMessage': lastMessage,
    'timeLabel': timeLabel,
    'unreadCount': unreadCount,
    'isOnline': isOnline,
  };
}

/// Who wrote a message in a thread.
enum ChatAuthor { customer, fundi }

/// One message inside a conversation thread.
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.sentAt,
    required this.author,
  });

  final String text;
  final DateTime sentAt;
  final ChatAuthor author;

  /// True for messages the customer wrote, which align to the right.
  bool get isMine => author == ChatAuthor.customer;

  /// Clock label shown under the bubble, e.g. `9:41 AM`.
  String get timeLabel => Formatters.timeOfDay(sentAt);

  /// Rebuilds a message from the JSON written by [toJson].
  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    text: json['text'] as String,
    sentAt: DateTime.parse(json['sentAt'] as String),
    author: ChatAuthor.values.byName(json['author'] as String),
  );

  /// Plain JSON map, safe for `jsonEncode` and local persistence.
  Map<String, dynamic> toJson() => {
    'text': text,
    'sentAt': sentAt.toIso8601String(),
    'author': author.name,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          other.text == text &&
          other.sentAt == sentAt &&
          other.author == author;

  @override
  int get hashCode => Object.hash(text, sentAt, author);
}
