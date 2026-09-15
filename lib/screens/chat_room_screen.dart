import 'package:flutter/material.dart';

import '../widgets/fundi_avatar.dart';

/// A single chat message shown as a bubble.
class ChatMessage {
  const ChatMessage({required this.text, required this.fromMe});

  final String text;
  final bool fromMe;
}

/// Simple conversation view: static history plus a working composer.
class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.contactName});

  final String contactName;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messages = <ChatMessage>[
    const ChatMessage(text: 'Hello! Are you available tomorrow?', fromMe: true),
    const ChatMessage(text: 'Yes, I am free from 9 AM.', fromMe: false),
    const ChatMessage(text: 'I will be there in 20 minutes 🙂', fromMe: false),
  ];

  final _composerController = TextEditingController();

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _composerController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, fromMe: true));
      _composerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final bubbleColor = message.fromMe
                    ? colors.primaryContainer
                    : colors.surfaceContainerHigh;
                return Align(
                  alignment: message.fromMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(message.text, style: text.bodyMedium),
                  ),
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
