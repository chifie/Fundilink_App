import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/user_model.dart';

void main() {
  group('User.maskedEmail', () {
    test('hides the middle of a long email', () {
      const user = User(
        id: 'u1',
        fullName: 'Brian Kimani',
        email: 'brian@example.com',
        phone: '+254711223344',
        role: UserRole.customer,
      );
      expect(user.maskedEmail, 'br****om');
    });

    test('returns the raw email for short addresses', () {
      const user = User(
        id: 'u2',
        fullName: 'Maya',
        email: 'ma@x.co',
        phone: '+254711223344',
        role: UserRole.customer,
      );
      expect(user.maskedEmail, 'ma@x.co');
    });
  });

  group('User.copyWith', () {
    test('preserves fields when no arguments are passed', () {
      const original = User(
        id: 'u1',
        fullName: 'Brian Kimani',
        email: 'brian@example.com',
        phone: '+254711223344',
        role: UserRole.customer,
        location: 'Nairobi',
      );
      final copy = original.copyWith();
      expect(copy.id, original.id);
      expect(copy.fullName, original.fullName);
      expect(copy.email, original.email);
      expect(copy.phone, original.phone);
      expect(copy.role, original.role);
      expect(copy.location, original.location);
    });

    test('overrides the provided fields', () {
      const original = User(
        id: 'u1',
        fullName: 'Brian Kimani',
        email: 'brian@example.com',
        phone: '+254711223344',
        role: UserRole.customer,
      );
      final copy = original.copyWith(fullName: 'Brian Ochieng');
      expect(copy.fullName, 'Brian Ochieng');
      expect(copy.id, original.id);
    });
  });
}
