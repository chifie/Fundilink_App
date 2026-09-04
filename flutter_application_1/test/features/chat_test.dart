import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/features/chat/screens/conversation_list_screen.dart';
import 'package:fundi_link/providers/chat_provider.dart';
import 'package:provider/provider.dart';

Widget _wrap(ChatProvider chat) {
  return ChangeNotifierProvider<ChatProvider>.value(
    value: chat,
    child: const MaterialApp(
      home: ConversationListScreen(currentUserId: 'u1'),
    ),
  );
}

void main() {
  testWidgets('conversation list opens a thread and can send messages', (tester) async {
    final chat = ChatProvider();
    unawaited(chat.loadConversations());
    await tester.pumpWidget(_wrap(chat));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('James Otieno'), findsOneWidget);
    expect(find.text('Mary Wanjiku'), findsOneWidget);

    await tester.tap(find.text('James Otieno'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));

    expect(
      find.text('I can come by tomorrow morning at 10. Does that work?'),
      findsOneWidget,
    );

    await tester.enterText(
      find.widgetWithText(TextField, 'Type a message...'),
      'Perfect, see you then.',
    );
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Perfect, see you then.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });
}
