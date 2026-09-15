import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/screens/chat_room_screen.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';

import '../support/pump_app.dart';

void main() {
  Future<AppStore> pumpRoom(
    WidgetTester tester, {
    AppStore? store,
    String contactName = 'Grace Wanjiku',
  }) async {
    final target = store ?? AppStore(storage: InMemoryKeyValueStore());
    await pumpWithStore(
      tester,
      ChatRoomScreen(contactName: contactName),
      store: target,
    );
    return target;
  }

  testWidgets('shows contact name and message history', (tester) async {
    await pumpRoom(tester);

    expect(find.text('Grace Wanjiku'), findsOneWidget);
    expect(find.text('Hello! Are you available tomorrow?'), findsOneWidget);
    expect(find.text('I will be there in 20 minutes 🙂'), findsOneWidget);
  });

  testWidgets('shows a clock label on each bubble', (tester) async {
    await pumpRoom(tester);

    expect(find.text('9:32 AM'), findsOneWidget);
    expect(find.text('9:41 AM'), findsOneWidget);
  });

  testWidgets('composer sends a message and clears the field', (tester) async {
    final store = await pumpRoom(tester);

    await tester.enterText(find.byType(TextField), 'Karibu');
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pump();

    expect(find.text('Karibu'), findsOneWidget);
    expect(store.messagesFor('Grace Wanjiku').last.text, 'Karibu');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      '',
    );
  });

  testWidgets('a sent message updates the conversation preview', (
    tester,
  ) async {
    final store = await pumpRoom(tester);

    await tester.enterText(find.byType(TextField), 'Karibu');
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pump();

    expect(store.conversations.first.lastMessage, 'Karibu');
  });

  testWidgets('empty messages are not sent', (tester) async {
    final store = await pumpRoom(tester);
    final before = store.messagesFor('Grace Wanjiku').length;

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pump();

    expect(store.messagesFor('Grace Wanjiku'), hasLength(before));
  });

  testWidgets('opening a thread marks it read', (tester) async {
    final store = AppStore(storage: InMemoryKeyValueStore());
    expect(store.unreadMessageCount, 3);

    await pumpRoom(tester, store: store);

    expect(store.unreadMessageCount, 1);
    expect(store.conversations.first.hasUnread, isFalse);
  });

  testWidgets('an unknown contact shows an empty thread', (tester) async {
    await pumpRoom(tester, contactName: 'Nobody');

    expect(find.text('Say hello to Nobody'), findsOneWidget);
  });

  testWidgets('sent messages survive a store restart', (tester) async {
    final storage = InMemoryKeyValueStore();
    await pumpRoom(tester, store: AppStore(storage: storage));

    await tester.enterText(find.byType(TextField), 'Karibu');
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pump();

    final restored = AppStore(storage: storage);
    expect(restored.messagesFor('Grace Wanjiku').last.text, 'Karibu');
  });
}
