import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/chat_message.dart';
import '../../../models/conversation.dart';
import '../../../providers/chat_provider.dart';
import '../../../widgets/empty_state.dart';

/// Live message thread for a single conversation.
class ChatThreadScreen extends StatefulWidget {
  const ChatThreadScreen({
    super.key,
    required this.conversation,
    required this.currentUserId,
  });

  final Conversation conversation;
  final String currentUserId;

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  final TextEditingController _inputController = TextEditingController();
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_opened) return;
      _opened = true;
      context.read<ChatProvider>().openConversation(widget.conversation.id);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text;
    if (text.trim().isEmpty) return;
    context.read<ChatProvider>().sendMessage(
      text,
      senderId: widget.currentUserId,
    );
    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final conversation = widget.conversation;
    final messages = chat.activeConversationId == conversation.id
        ? chat.messages
        : const [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.chat_bubble_outline, size: 20),
            const SizedBox(width: AppDimensions.spaceS),
            Expanded(
              child: Text(
                conversation.otherUserName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.paddingM),
            child: Center(
              child: Text(
                conversation.requestTitle,
                style: const TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const EmptyState(
                    icon: Icons.forum_outlined,
                    title: AppStrings.startConversation,
                    message: AppStrings.noMessages,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMine = message.senderId == widget.currentUserId;
                      return _MessageBubble(message: message, isMine: isMine);
                    },
                  ),
          ),
          _Composer(controller: _inputController, onSend: _send),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMine});

  final ChatMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS + 2,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppDimensions.radiusM),
            topRight: const Radius.circular(AppDimensions.radiusM),
            bottomLeft: Radius.circular(isMine ? AppDimensions.radiusM : 4),
            bottomRight: Radius.circular(isMine ? 4 : AppDimensions.radiusM),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isMine ? AppColors.textOnPrimary : AppColors.textPrimary,
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              Formatters.time(message.timestamp),
              style: TextStyle(
                color: isMine
                    ? AppColors.textOnPrimary.withValues(alpha: 0.7)
                    : AppColors.textHint,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: AppDimensions.elevationLow,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  decoration: const InputDecoration(
                    hintText: AppStrings.typeMessage,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceS),
              IconButton.filled(
                onPressed: onSend,
                icon: const Icon(Icons.send),
                tooltip: AppStrings.send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
