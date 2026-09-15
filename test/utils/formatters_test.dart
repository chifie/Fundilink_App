import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/utils/formatters.dart';

void main() {
  group('Formatters.currency', () {
    test('prefixes the KSh symbol and groups thousands', () {
      expect(Formatters.currency(600), 'KSh 600');
      expect(Formatters.currency(1800), 'KSh 1,800');
      expect(Formatters.currency(2500), 'KSh 2,500');
      expect(Formatters.currency(1234567), 'KSh 1,234,567');
    });

    test('drops decimals so whole-shilling rates stay compact', () {
      expect(Formatters.currency(0), 'KSh 0');
      expect(Formatters.currency(1499.6), 'KSh 1,500');
    });
  });
}
