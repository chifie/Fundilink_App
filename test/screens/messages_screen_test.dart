import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/screens/messages_screen.dart';

void main() {
  testWidgets('lists conversations with previews', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MessagesScreen()));

    expect(find.text('Grace Wanjiku'), findsOneWidget);
    expect(find.text('I will be there in 20 minutes 🙂'), findsOneWidget);
    expect(find.text('Brian Otieno'), findsOneWidget);
    expect(find.text('Faith Njeri'), findsOneWidget);
  });

  testWidgets('shows unread counters', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MessagesScreen()));

    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });
}
