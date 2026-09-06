import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter.format', () {
    test('formats whole shillings with thousands separators', () {
      expect(CurrencyFormatter.format(800), 'KES 800');
      expect(CurrencyFormatter.format(1200), 'KES 1,200');
      expect(CurrencyFormatter.format(1234567), 'KES 1,234,567');
    });

    test('rounds decimal amounts to whole shillings', () {
      expect(CurrencyFormatter.format(1200.5), 'KES 1,201');
      expect(CurrencyFormatter.format(99.9), 'KES 100');
    });

    test('handles zero and negative amounts', () {
      expect(CurrencyFormatter.format(0), 'KES 0');
      expect(CurrencyFormatter.format(-500), '-KES 500');
    });
  });

  group('CurrencyFormatter.formatShort', () {
    test('abbreviates large amounts', () {
      expect(CurrencyFormatter.formatShort(1500000), 'KES 1.5M');
      expect(CurrencyFormatter.formatShort(2000), 'KES 2.0K');
      expect(CurrencyFormatter.formatShort(800), 'KES 800');
    });
  });

  group('CurrencyFormatter.compact', () {
    test('returns digits without the KES prefix', () {
      expect(CurrencyFormatter.compact(1200), '1,200');
      expect(CurrencyFormatter.compact(0), '0');
    });
  });
}
