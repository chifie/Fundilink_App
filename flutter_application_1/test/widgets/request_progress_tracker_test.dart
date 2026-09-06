import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/service_request.dart';
import 'package:fundi_link/widgets/request_progress_tracker.dart';

Widget _wrap(RequestStatus status) {
  return MaterialApp(
    home: Scaffold(
      body: RequestProgressTracker(status: status),
    ),
  );
}

void main() {
  testWidgets('renders the progress header', (tester) async {
    await tester.pumpWidget(_wrap(RequestStatus.pending));

    expect(find.text('Request Progress'), findsOneWidget);
  });

  testWidgets('renders all five step labels', (tester) async {
    await tester.pumpWidget(_wrap(RequestStatus.pending));

    for (final label in ['Pending', 'Accepted', 'In Progress', 'Completed', 'Reviewed']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('shows the cancelled banner for a rejected request', (tester) async {
    await tester.pumpWidget(_wrap(RequestStatus.rejected));

    expect(find.text('This request was cancelled'), findsOneWidget);
    expect(find.text('Request Progress'), findsNothing);
  });

  testWidgets('builds without error for every request status', (tester) async {
    for (final status in RequestStatus.values) {
      await tester.pumpWidget(_wrap(status));
      expect(tester.takeException(), isNull);
    }
  });
}