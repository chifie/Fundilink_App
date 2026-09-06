import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/data/mock_data.dart';
import 'package:fundi_link/models/user_model.dart';
import 'package:fundi_link/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final repository = AuthRepository();

  group('AuthRepository', () {
    test('login returns the fundi demo account for its email', () async {
      final user = await repository.login(
        email: mockFundiUser.email,
        password: 'x',
      );
      expect(user.id, mockFundiUser.id);
      expect(user.role, UserRole.fundi);
    });

    test('login returns the customer demo account otherwise', () async {
      final user = await repository.login(
        email: 'anyone@example.com',
        password: 'x',
      );
      expect(user.id, mockCustomer.id);
      expect(user.role, UserRole.customer);
    });

    test('register honours the requested role', () async {
      final fundi = await repository.register(
        fullName: 'A Fundi',
        email: 'a@example.com',
        phone: '0711223344',
        password: 'secret1',
        role: UserRole.fundi,
      );
      expect(fundi.role, UserRole.fundi);

      final customer = await repository.register(
        fullName: 'A Customer',
        email: 'c@example.com',
        phone: '0711223344',
        password: 'secret1',
        role: UserRole.customer,
      );
      expect(customer.role, UserRole.customer);
    });

    test('restoreSession returns null when no session was saved', () async {
      SharedPreferences.setMockInitialValues({});
      final user = await repository.restoreSession();
      expect(user, isNull);
    });

    test('restoreSession round-trips a saved session', () async {
      SharedPreferences.setMockInitialValues({});
      await repository.saveSession(mockCustomer);
      final user = await repository.restoreSession();
      expect(user?.id, mockCustomer.id);
    });
  });
}
