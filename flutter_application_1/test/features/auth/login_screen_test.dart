import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/features/auth/screens/login_screen.dart';
import 'package:fundi_link/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _wrap(AuthProvider auth) {
  return ChangeNotifierProvider<AuthProvider>.value(
    value: auth,
    child: const MaterialApp(home: LoginScreen()),
  );
}

Future<void> _tapLogin(WidgetTester tester) async {
  final button = find.widgetWithText(ElevatedButton, AppStrings.login);
  await tester.ensureVisible(button);
  await tester.pump();
  await tester.tap(button);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('signs in with the pre-filled demo account', (tester) async {
    final auth = AuthProvider();
    await tester.pumpWidget(_wrap(auth));

    await _tapLogin(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(auth.isAuthenticated, isTrue);
    expect(auth.user?.fullName, 'Brian Kimani');
  });

  testWidgets('shows validation errors for an empty form', (tester) async {
    final auth = AuthProvider();
    await tester.pumpWidget(_wrap(auth));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '');
    await tester.enterText(fields.at(1), '');
    await _tapLogin(tester);
    await tester.pump();

    expect(find.text(AppStrings.emailRequired), findsOneWidget);
    expect(find.text(AppStrings.passwordRequired), findsOneWidget);
    expect(auth.isAuthenticated, isFalse);
  });

  testWidgets('navigates to the registration screen', (tester) async {
    final auth = AuthProvider();
    await tester.pumpWidget(_wrap(auth));

    final registerLink = find.widgetWithText(TextButton, AppStrings.register);
    await tester.ensureVisible(registerLink);
    await tester.pump();
    await tester.tap(registerLink);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.createAccount), findsWidgets);
  });
}
