import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/chat_message.dart';

void main() {
  group('ChatMessage.isFromMe', () {
    test('returns true when the sender matches the current user', () {
      final message = ChatMessage(
        id: 'm1',
        conversationId: 'c1',
        senderId: 'u1',
        text: 'Hello',
        timestamp: DateTime(2026, 9, 7),
        isRead: false,
      );
      expect(message.isFromMe('u1'), isTrue);
    });

    test('returns false when the sender differs', () {
      final message = ChatMessage(
        id: 'm1',
        conversationId: 'c1',
        senderId: 'f1',
        text: 'Hello',
        timestamp: DateTime(2026, 9, 7),
        isRead: false,
      );
      expect(message.isFromMe('u1'), isFalse);
    });
  });
}
