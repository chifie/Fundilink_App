import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../state/store_scope.dart';
import '../widgets/fundi_avatar.dart';

/// Conversation view backed by the store's thread for [contactName].
class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.contactName});

  final String contactName;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _composerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Opening a thread counts as reading it. Deferred to after the first
    // frame because notifying listeners mid-build is not allowed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.storeRead.markConversationRead(widget.contactName);
    });
  }

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _composerController.text.trim();
    if (text.isEmpty) return;

    context.storeRead.sendMessage(contactName: widget.contactName, text: text);
    _composerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final messages = context.store.messagesFor(widget.contactName);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            FundiAvatar(name: widget.contactName, size: 36),
            const SizedBox(width: 10),
            Expanded(child: Text(widget.contactName)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      'Say hello to ${widget.contactName}',
                      style: text.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.builder(
                    // Reversed so new messages sit at the bottom and the
                    // list starts scrolled to the newest one.
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      return _MessageBubble(
                        message: message,
                        colors: colors,
                        text: text,
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _composerController,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Send',
                    onPressed: _send,
                    icon: const Icon(Icons.send_outlined),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One message bubble with its clock label.
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.colors,
    required this.text,
  });

  final ChatMessage message;
  final ColorScheme colors;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = message.isMine
        ? colors.primaryContainer
        : colors.surfaceContainerHigh;
    final labelColor = message.isMine
        ? colors.onPrimaryContainer
        : colors.onSurfaceVariant;

    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                message.text,
                style: text.bodyMedium?.copyWith(
                  color: message.isMine ? colors.onPrimaryContainer : null,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message.timeLabel,
              style: text.labelSmall?.copyWith(
                color: labelColor.withAlpha(178),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
