import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/utils/formatters.dart';

void main() {
  group('Formatters.currency', () {
    test('formats whole shillings without decimals', () {
      expect(Formatters.currency(800), 'KES 800');
      expect(Formatters.currency(1200.5), 'KES 1,201');
    });
  });

  group('Formatters.date', () {
    test('formats a date with month, day and year', () {
      expect(Formatters.date(DateTime(2026, 9, 4)), 'Sep 4, 2026');
    });
  });

  group('Formatters.timeAgo', () {
    test('returns human-friendly relative labels', () {
      final now = DateTime.now();
      expect(Formatters.timeAgo(now.subtract(const Duration(seconds: 5))), 'just now');
      expect(Formatters.timeAgo(now.subtract(const Duration(minutes: 10))), '10m ago');
      expect(Formatters.timeAgo(now.subtract(const Duration(hours: 3))), '3h ago');
      expect(Formatters.timeAgo(now.subtract(const Duration(days: 2))), '2d ago');
    });
  });

  group('Formatters.shortDate', () {
    test('returns a compact date label', () {
      expect(Formatters.shortDate(DateTime(2026, 9, 4)), 'Sep 4');
    });
  });
}
