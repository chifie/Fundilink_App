import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/providers/chat_provider.dart';

void main() {
  group('ChatProvider conversations', () {
    test(
      'loadConversations exposes the seeded conversations newest first',
      () async {
        final provider = ChatProvider();
        provider.setCurrentUserId('u1');
        await provider.loadConversations();

        expect(provider.conversations, isNotEmpty);
        // Seed data is sorted by last message time, newest first.
        expect(provider.conversations.first.id, 'c1');
        // Only the newest conversation carries unread messages in the seed data.
        expect(provider.unreadTotal, 2);
      },
    );

    test('markRead clears unread on a single conversation', () async {
      final provider = ChatProvider();
      await provider.loadConversations();
      expect(provider.unreadTotal, 2);

      await provider.markRead('c1');

      expect(provider.unreadTotal, 0);
      expect(
        provider.conversations.firstWhere((c) => c.id == 'c1').unreadCount,
        0,
      );
    });

    test('openConversation loads messages and clears unread', () async {
      final provider = ChatProvider();
      await provider.loadConversations();
      await provider.openConversation('c1');

      expect(provider.activeConversationId, 'c1');
      expect(provider.messages, isNotEmpty);
      // Messages arrive oldest-to-newest for the threaded view.
      final timestamps = provider.messages.map((m) => m.timestamp).toList();
      final sorted = [...timestamps]..sort();
      expect(timestamps, sorted);
      expect(provider.unreadTotal, 0);
    });
  });

  group('ChatProvider sending', () {
    test('sendMessage appends to the active thread', () async {
      final provider = ChatProvider();
      final conversation = await provider.startConversation(
        otherUserId: 'f99',
        otherUserName: 'Test Fundi',
        requestId: 'req-chat-provider-test',
        requestTitle: 'Test request',
      );
      await provider.openConversation(conversation.id);
      expect(provider.messages, isEmpty);

      await provider.sendMessage('Hello there', senderId: 'u1');

      expect(provider.messages, hasLength(1));
      expect(provider.messages.single.text, 'Hello there');
      expect(provider.messages.single.senderId, 'u1');
    });

    test('sendMessage ignores blank text', () async {
      final provider = ChatProvider();
      final conversation = await provider.startConversation(
        otherUserId: 'f98',
        otherUserName: 'Blank Sender',
        requestId: 'req-chat-blank-test',
        requestTitle: 'Blank request',
      );
      await provider.openConversation(conversation.id);

      await provider.sendMessage('   ', senderId: 'u1');

      expect(provider.messages, isEmpty);
    });
  });
}
