import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/features/auth/screens/login_screen.dart';
import 'package:fundi_link/features/shell/customer_shell.dart';
import 'package:fundi_link/features/shell/fundi_workspace_placeholder.dart';
import 'package:fundi_link/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _sessionKey = 'fundilink_session_user_id';

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

/// Advances time so auth latency and the shell's data loads complete.
Future<void> _flushAsyncWork(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump();
}

Future<void> _pumpLogin(WidgetTester tester) async {
  await tester.pumpWidget(const FundiLinkApp());
  await _settle(tester);
  await _settle(tester);
}

void main() {
  testWidgets('signed-out users land on the login screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pumpLogin(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text(AppStrings.email), findsOneWidget);
  });

  testWidgets('customer demo login opens the customer shell', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pumpLogin(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    await tester.pump();
    // Auth latency plus shared-data loads in the shell.
    await _flushAsyncWork(tester);

    expect(find.byType(CustomerShell), findsOneWidget);
    expect(find.text(AppStrings.home), findsWidgets);
  });

  testWidgets('a persisted customer session skips login', (tester) async {
    SharedPreferences.setMockInitialValues({_sessionKey: 'u1'});
    await _pumpLogin(tester);
    await _flushAsyncWork(tester);

    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byType(CustomerShell), findsOneWidget);
  });

  testWidgets('fundi demo login shows the workspace placeholder', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _pumpLogin(tester);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'james@example.com',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.login));
    await tester.pump();
    await _flushAsyncWork(tester);

    expect(find.byType(FundiWorkspacePlaceholder), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.logout));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
