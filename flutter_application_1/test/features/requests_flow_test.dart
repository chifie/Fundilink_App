import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/data/mock_data.dart';
import 'package:fundi_link/features/customer_requests/screens/my_requests_screen.dart';
import 'package:fundi_link/features/service_request/screens/request_form_screen.dart';
import 'package:fundi_link/models/service_request.dart';
import 'package:fundi_link/providers/auth_provider.dart';
import 'package:fundi_link/providers/request_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _wrapRequests(RequestProvider requests, AuthProvider auth) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: requests),
      ChangeNotifierProvider.value(value: auth),
    ],
    child: const MaterialApp(home: MyRequestsScreen()),
  );
}

Widget _wrapForm(RequestProvider requests, AuthProvider auth) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: requests),
      ChangeNotifierProvider.value(value: auth),
    ],
    child: MaterialApp(home: RequestFormScreen(fundi: MockData.fundis.first)),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('my requests lists the seeded customer requests', (tester) async {
    final requests = RequestProvider();
    unawaited(requests.loadCustomerRequests('u1'));
    await tester.pumpWidget(_wrapRequests(requests, AuthProvider()));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Kitchen sink leaking'), findsNothing);
    expect(find.textContaining('kitchen sink'), findsWidgets);
    expect(find.text(AppStrings.pending), findsWidgets);
    expect(find.text(AppStrings.inProgress), findsWidgets);
  });

  testWidgets('cancelling a pending request updates its status', (
    tester,
  ) async {
    final requests = RequestProvider();
    unawaited(requests.loadCustomerRequests('u1'));
    await tester.pumpWidget(_wrapRequests(requests, AuthProvider()));
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.textContaining('kitchen sink').first);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.requestDetails), findsOneWidget);
    final cancel = find.text(AppStrings.cancelRequest);
    await tester.ensureVisible(cancel);
    await tester.pump();
    expect(cancel, findsOneWidget);

    await tester.tap(cancel);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.yes));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    // Snackbar auto-dismiss timer.
    await tester.pump(const Duration(seconds: 5));

    final cancelled = requests.byId('r1');
    expect(cancelled?.status, RequestStatus.rejected);
    expect(find.text('My Requests'), findsOneWidget);
  });

  testWidgets('booking form validates before submitting', (tester) async {
    final requests = RequestProvider();
    final auth = AuthProvider();
    await tester.pumpWidget(_wrapForm(requests, auth));
    await tester.pump();

    final submit = find.widgetWithText(
      ElevatedButton,
      AppStrings.submitRequest,
    );
    await tester.ensureVisible(submit);
    await tester.pump();
    await tester.tap(submit);
    await tester.pump();

    expect(find.text(AppStrings.describeProblem), findsOneWidget);
    expect(find.text(AppStrings.addLocation), findsOneWidget);
  });

  testWidgets('submitting a booking reaches the success screen', (
    tester,
  ) async {
    final requests = RequestProvider();
    final auth = AuthProvider();
    // Complete sign-in before the form builds so the user and their
    // default location are available to the booking form.
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: auth,
        child: const MaterialApp(home: Scaffold()),
      ),
    );
    unawaited(auth.login(email: 'brian@example.com', password: 'fundilink'));
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpWidget(_wrapForm(requests, auth));
    await tester.pump();

    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.problemDescription),
      'Fix the leaking kitchen tap.',
    );
    await tester.pump();

    final submit = find.widgetWithText(
      ElevatedButton,
      AppStrings.submitRequest,
    );
    await tester.ensureVisible(submit);
    await tester.pump();
    await tester.tap(submit);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text(AppStrings.requestSubmitted), findsOneWidget);
    expect(requests.customerRequests, isNotEmpty);
  });
}
