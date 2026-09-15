import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/screens/chat_room_screen.dart';

void main() {
  Future<void> pumpRoom(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ChatRoomScreen(contactName: 'Grace Wanjiku')),
    );
  }

  testWidgets('shows contact name and message history', (tester) async {
    await pumpRoom(tester);

    expect(find.text('Grace Wanjiku'), findsOneWidget);
    expect(find.text('Hello! Are you available tomorrow?'), findsOneWidget);
    expect(find.text('I will be there in 20 minutes 🙂'), findsOneWidget);
  });

  testWidgets('composer sends a message and clears the field', (tester) async {
    await pumpRoom(tester);

    await tester.enterText(find.byType(TextField), 'Karibu');
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pump();

    expect(find.text('Karibu'), findsOneWidget);
  });

  testWidgets('empty messages are not sent', (tester) async {
    await pumpRoom(tester);

    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pump();

    expect(find.text('Karibu'), findsNothing);
  });
}
