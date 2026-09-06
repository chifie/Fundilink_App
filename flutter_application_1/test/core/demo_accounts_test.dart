import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/demo_accounts.dart';
import 'package:fundi_link/data/mock_data.dart';

void main() {
  group('DemoAccounts', () {
    test('customer email matches the mock customer', () {
      expect(mockCustomer.email, DemoAccounts.customerEmail);
    });

    test('fundi email matches the mock fundi user', () {
      expect(mockFundiUser.email, DemoAccounts.fundiEmail);
    });

    test('password is shared across demo accounts', () {
      expect(DemoAccounts.password, isNotEmpty);
      expect(DemoAccounts.password.length, greaterThanOrEqualTo(6));
    });

    test('customer and fundi demo emails are distinct', () {
      expect(DemoAccounts.customerEmail, isNot(DemoAccounts.fundiEmail));
    });
  });
}
