import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../screens/chat_room_screen.dart';
import '../widgets/fundi_avatar.dart';

/// Chats tab listing conversations with unread counters.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: MockData.chats.length,
        itemBuilder: (context, index) {
          final chat = MockData.chats[index];
          return ListTile(
            leading: FundiAvatar(name: chat.name, isOnline: chat.isOnline),
            title: Text(chat.name),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.bodyMedium?.copyWith(
                color: chat.unreadCount > 0
                    ? colors.onSurface
                    : colors.onSurfaceVariant,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat.timeLabel, style: text.labelSmall),
                const SizedBox(height: 4),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${chat.unreadCount}',
                      style: text.labelSmall?.copyWith(color: colors.onPrimary),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChatRoomScreen(contactName: chat.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
