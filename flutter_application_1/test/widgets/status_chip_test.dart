import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/service_request.dart';
import 'package:fundi_link/widgets/status_chip.dart';

Widget _wrap(RequestStatus status, {bool compact = false}) {
  return MaterialApp(
    home: Scaffold(
      body: StatusChip(status: status, compact: compact),
    ),
  );
}

void main() {
  testWidgets('renders the status label for every status', (tester) async {
    for (final status in RequestStatus.values) {
      await tester.pumpWidget(_wrap(status));
      expect(find.text(status.label), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('shows the status icon in the full variant', (tester) async {
    await tester.pumpWidget(_wrap(RequestStatus.pending));
    expect(find.byIcon(RequestStatus.pending.icon), findsOneWidget);
  });

  testWidgets('compact variant hides the icon', (tester) async {
    await tester.pumpWidget(_wrap(RequestStatus.accepted, compact: true));
    expect(find.byIcon(RequestStatus.accepted.icon), findsNothing);
    expect(find.text(RequestStatus.accepted.label), findsOneWidget);
  });
}
