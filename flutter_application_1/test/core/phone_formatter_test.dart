import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/utils/phone_formatter.dart';

void main() {
  group('PhoneFormatter.format', () {
    test('formats international Kenyan numbers', () {
      expect(PhoneFormatter.format('+254711223344'), '+254 711 223 344');
    });

    test('strips separators before formatting', () {
      expect(PhoneFormatter.format('+254 711 223 344'), '+254 711 223 344');
      expect(PhoneFormatter.format('0711-223-344'), '0711 223 344');
    });

    test('formats local numbers starting with zero', () {
      expect(PhoneFormatter.format('0711223344'), '0711 223 344');
    });

    test('returns unrecognized numbers unchanged', () {
      expect(PhoneFormatter.format('123'), '123');
    });
  });

  group('PhoneFormatter.mask', () {
    test('masks the middle of a number', () {
      expect(PhoneFormatter.mask('+254711223344'), '+25471****44');
    });

    test('returns short numbers unchanged', () {
      expect(PhoneFormatter.mask('123'), '123');
    });
  });
}
