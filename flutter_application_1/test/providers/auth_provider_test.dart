import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/demo_accounts.dart';
import 'package:fundi_link/models/user_model.dart';
import 'package:fundi_link/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthProvider session', () {
    test('restoreSession signs out when nothing was saved', () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthProvider();

      await auth.restoreSession();

      expect(auth.status, AuthStatus.unauthenticated);
      expect(auth.user, isNull);
    });

    test('restoreSession restores the persisted fundi session', () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthProvider();
      final success = await auth.login(
        email: DemoAccounts.fundiEmail,
        password: DemoAccounts.password,
      );
      expect(success, isTrue);

      final restored = AuthProvider();
      await restored.restoreSession();

      expect(restored.status, AuthStatus.authenticated);
      expect(restored.user?.role, UserRole.fundi);
    });
  });

  group('AuthProvider login', () {
    test('demo fundi login authenticates with the fundi role', () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthProvider();

      final success = await auth.login(
        email: DemoAccounts.fundiEmail,
        password: DemoAccounts.password,
      );

      expect(success, isTrue);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.role, UserRole.fundi);
    });

    test('any other credentials sign in as a customer', () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthProvider();

      final success = await auth.login(
        email: 'someone@example.com',
        password: 'whatever',
      );

      expect(success, isTrue);
      expect(auth.role, UserRole.customer);
    });
  });

  group('AuthProvider register and logout', () {
    test('register signs the customer in', () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthProvider();

      final success = await auth.register(
        fullName: 'Brian Kimani',
        email: 'new@example.com',
        phone: '0711223344',
        password: 'secret1',
        role: UserRole.customer,
      );

      expect(success, isTrue);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.role, UserRole.customer);
    });

    test('logout clears the session', () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthProvider();
      await auth.login(
        email: DemoAccounts.customerEmail,
        password: DemoAccounts.password,
      );
      expect(auth.isAuthenticated, isTrue);

      await auth.logout();

      expect(auth.status, AuthStatus.unauthenticated);
      expect(auth.user, isNull);
    });
  });
}
