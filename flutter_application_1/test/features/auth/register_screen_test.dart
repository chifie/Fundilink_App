import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/features/auth/screens/register_screen.dart';
import 'package:fundi_link/models/user_model.dart';
import 'package:fundi_link/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _wrap(AuthProvider auth) {
  return ChangeNotifierProvider<AuthProvider>.value(
    value: auth,
    child: const MaterialApp(home: RegisterScreen()),
  );
}

Future<void> _fillValidForm(WidgetTester tester) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'Brian Kimani');
  await tester.enterText(fields.at(1), 'brian@example.com');
  await tester.enterText(fields.at(2), '+254711223344');
  await tester.enterText(fields.at(3), 'secret1');
  await tester.enterText(fields.at(4), 'secret1');
}

Future<void> _tapRegister(WidgetTester tester) async {
  final button = find.widgetWithText(ElevatedButton, AppStrings.createAccount);
  await tester.ensureVisible(button);
  await tester.pump();
  await tester.tap(button);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('registers a customer with a matching password', (tester) async {
    final auth = AuthProvider();
    await tester.pumpWidget(_wrap(auth));

    await _fillValidForm(tester);
    await _tapRegister(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(auth.isAuthenticated, isTrue);
    expect(auth.user?.role, UserRole.customer);
  });

  testWidgets('rejects mismatched confirmation passwords', (tester) async {
    final auth = AuthProvider();
    await tester.pumpWidget(_wrap(auth));

    await _fillValidForm(tester);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(4), 'different1');
    await _tapRegister(tester);
    await tester.pump();

    expect(find.text(AppStrings.passwordMismatch), findsOneWidget);
    expect(auth.isAuthenticated, isFalse);
  });

  testWidgets('shows required-field errors on an empty submit', (tester) async {
    final auth = AuthProvider();
    await tester.pumpWidget(_wrap(auth));

    await _tapRegister(tester);
    await tester.pump();

    expect(find.text(AppStrings.nameRequired), findsOneWidget);
    expect(find.text(AppStrings.emailRequired), findsOneWidget);
    expect(find.text(AppStrings.phoneRequired), findsOneWidget);
    expect(auth.isAuthenticated, isFalse);
  });
}
