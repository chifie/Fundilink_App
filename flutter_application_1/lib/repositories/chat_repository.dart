import 'package:uuid/uuid.dart';

import '../data/mock_data.dart';
import '../models/chat_message.dart';
import '../models/conversation.dart';

/// Data source for chat conversations and messages.
class ChatRepository {
  static const Duration _latency = Duration(milliseconds: 400);

  static const _uuid = Uuid();

  Future<List<Conversation>> getConversations(String userId) async {
    await Future<void>.delayed(_latency);
    final list = List<Conversation>.of(MockData.conversations);
    list.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    return list;
  }

  Future<List<ChatMessage>> getMessages(String conversationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final list = List<ChatMessage>.of(
      MockData.messagesByConversation[conversationId] ?? const [],
    );
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }

  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final message = ChatMessage(
      id: _uuid.v4(),
      conversationId: conversationId,
      senderId: senderId,
      text: text,
      timestamp: DateTime.now(),
    );
    final messages = MockData.messagesByConversation.putIfAbsent(
      conversationId,
      () => <ChatMessage>[],
    );
    messages.add(message);

    final index = MockData.conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      MockData.conversations[index] = MockData.conversations[index].copyWith(
        lastMessage: text,
        lastMessageAt: message.timestamp,
        unreadCount: 0,
      );
    }
    return message;
  }

  /// Creates a conversation for a customer-fundi pair if none exists.
  Future<Conversation> startConversation({
    required String otherUserId,
    required String otherUserName,
    String? otherUserAvatar,
    required String requestId,
    required String requestTitle,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final existing = MockData.conversations.where((c) =>
        c.otherUserId == otherUserId && c.requestId == requestId);
    if (existing.isNotEmpty) return existing.first;

    final conversation = Conversation(
      id: _uuid.v4(),
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      otherUserAvatar: otherUserAvatar,
      requestId: requestId,
      requestTitle: requestTitle,
      lastMessage: 'Start a conversation',
      lastMessageAt: DateTime.now(),
    );
    MockData.conversations.insert(0, conversation);
    return conversation;
  }

  /// Marks all messages in a conversation as read.
  Future<void> markConversationRead(String conversationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final index = MockData.conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      MockData.conversations[index] =
          MockData.conversations[index].copyWith(unreadCount: 0);
    }
  }
}