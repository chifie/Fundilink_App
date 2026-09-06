import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/core/utils/validators.dart';

void main() {
  group('Validators.validateEmail', () {
    test('accepts well-formed emails', () {
      expect(Validators.validateEmail('brian@example.com'), isNull);
      expect(Validators.validateEmail('user.name+tag@sub.domain.co'), isNull);
    });

    test('rejects empty or malformed emails', () {
      expect(Validators.validateEmail(''), AppStrings.emailRequired);
      expect(Validators.validateEmail('   '), AppStrings.emailRequired);
      expect(Validators.validateEmail('not-an-email'), AppStrings.emailInvalid);
      expect(Validators.validateEmail('brian@'), AppStrings.emailInvalid);
    });
  });

  group('Validators.validatePassword', () {
    test('accepts passwords of at least six characters', () {
      expect(Validators.validatePassword('secret1'), isNull);
    });

    test('rejects empty and short passwords', () {
      expect(Validators.validatePassword(''), AppStrings.passwordRequired);
      expect(
        Validators.validatePassword('12345'),
        AppStrings.passwordMinLength,
      );
    });
  });

  group('Validators.validateConfirmPassword', () {
    test('rejects mismatched confirmation', () {
      expect(
        Validators.validateConfirmPassword('abc123', 'abc124'),
        AppStrings.passwordMismatch,
      );
      expect(Validators.validateConfirmPassword('abc123', 'abc123'), isNull);
    });
  });

  group('Validators.validateName', () {
    test('rejects empty names', () {
      expect(Validators.validateName(''), AppStrings.nameRequired);
      expect(Validators.validateName('   '), AppStrings.nameRequired);
      expect(Validators.validateName('Brian Kimani'), isNull);
    });
  });

  group('Validators.validatePhone', () {
    test('accepts local and international numbers', () {
      expect(Validators.validatePhone('0711223344'), isNull);
      expect(Validators.validatePhone('+254711223344'), isNull);
    });

    test('rejects empty and invalid numbers', () {
      expect(Validators.validatePhone(''), AppStrings.phoneRequired);
      expect(Validators.validatePhone('123'), AppStrings.phoneInvalid);
      expect(Validators.validatePhone('phone-number'), AppStrings.phoneInvalid);
    });
  });

  group('Validators.required', () {
    test('falls back to a custom message', () {
      expect(Validators.required('', 'Pick a date'), 'Pick a date');
      expect(Validators.required('Dec 5', 'Pick a date'), isNull);
    });
  });
}
