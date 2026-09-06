import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/navigation/customer_tabs.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/conversation.dart';
import '../../../providers/chat_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/fundi_avatar.dart';
import 'chat_thread_screen.dart';

/// List of the signed-in customer's conversations.
class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({super.key, required this.currentUserId});

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final conversations = context.watch<ChatProvider>().conversations;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.messages)),
      body: conversations.isEmpty
          ? EmptyState(
              icon: Icons.forum_outlined,
              title: 'No conversations yet',
              message:
                  'Request a service or tap chat on a fundi profile to get started.',
              actionLabel: AppStrings.findFundi,
              onAction: () => CustomerTabs.goTo(CustomerTabs.home),
            )
          : RefreshIndicator(
              onRefresh: () => context.read<ChatProvider>().loadConversations(),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingS,
                ),
                itemCount: conversations.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, indent: 72),
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return _ConversationTile(
                    conversation: conversation,
                    currentUserId: currentUserId,
                  );
                },
              ),
            ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
  });

  final Conversation conversation;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final unread = conversation.unreadCount;

    return ListTile(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChatThreadScreen(
            conversation: conversation,
            currentUserId: currentUserId,
          ),
        ),
      ),
      leading: FundiAvatar(
        name: conversation.otherUserName,
        imageUrl: conversation.otherUserAvatar,
      ),
      title: Text(
        conversation.otherUserName,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        conversation.lastMessage ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: unread > 0 ? AppColors.textPrimary : AppColors.textSecondary,
          fontSize: 13,
          fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            Formatters.timeAgo(conversation.lastMessageAt),
            style: const TextStyle(color: AppColors.textHint, fontSize: 11),
          ),
          const SizedBox(height: 4),
          if (unread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                '$unread',
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
