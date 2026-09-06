import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../repositories/chat_repository.dart';

/// Manages conversations and the active message thread.
class ChatProvider extends ChangeNotifier {
  ChatProvider({ChatRepository? repository})
    : _repository = repository ?? ChatRepository();

  final ChatRepository _repository;

  List<Conversation> _conversations = [];
  final List<ChatMessage> _messages = [];
  String? _activeConversationId;
  bool _loading = false;

  List<Conversation> get conversations => _conversations;
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  String? get activeConversationId => _activeConversationId;
  bool get isLoading => _loading;

  int get unreadTotal =>
      _conversations.fold(0, (sum, c) => sum + c.unreadCount);

  String _currentUserId = '';

  void setCurrentUserId(String userId) => _currentUserId = userId;

  Future<void> loadConversations() async {
    _loading = true;
    notifyListeners();
    _conversations = await _repository.getConversations(_currentUserId);
    _loading = false;
    notifyListeners();
  }

  Future<void> openConversation(String conversationId) async {
    _activeConversationId = conversationId;
    _messages
      ..clear()
      ..addAll(await _repository.getMessages(conversationId));
    await _repository.markConversationRead(conversationId);
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
    }
    notifyListeners();
  }

  Future<void> sendMessage(String text, {required String senderId}) async {
    final conversationId = _activeConversationId;
    if (conversationId == null || text.trim().isEmpty) return;
    final message = await _repository.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      text: text.trim(),
    );
    _messages.add(message);
    notifyListeners();
  }

  Future<Conversation> startConversation({
    required String otherUserId,
    required String otherUserName,
    String? otherUserAvatar,
    required String requestId,
    required String requestTitle,
  }) async {
    final conversation = await _repository.startConversation(
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      otherUserAvatar: otherUserAvatar,
      requestId: requestId,
      requestTitle: requestTitle,
    );
    await loadConversations();
    return conversation;
  }

  Future<void> markRead(String conversationId) async {
    await _repository.markConversationRead(conversationId);
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
    }
    notifyListeners();
  }
}
