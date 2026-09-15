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

  group('date and time formatting', () {
    test('dayMonth drops the leading zero on single digit days', () {
      expect(Formatters.dayMonth(DateTime(2026, 9, 5)), 'Sep 5');
      expect(Formatters.dayMonth(DateTime(2026, 9, 20)), 'Sep 20');
    });

    test('timeOfDay renders a 12-hour clock without seconds', () {
      expect(Formatters.timeOfDay(DateTime(2026, 9, 20, 14)), '2:00 PM');
      expect(Formatters.timeOfDay(DateTime(2026, 9, 20, 9, 30)), '9:30 AM');
      expect(Formatters.timeOfDay(DateTime(2026, 9, 20, 0, 5)), '12:05 AM');
      expect(Formatters.timeOfDay(DateTime(2026, 9, 20, 12)), '12:00 PM');
    });

    test('dateTime joins day and time with a separator', () {
      expect(
        Formatters.dateTime(DateTime(2026, 9, 20, 14)),
        'Sep 20 · 2:00 PM',
      );
    });

    test('fullDate spells out the weekday and year', () {
      expect(Formatters.fullDate(DateTime(2026, 9, 20)), 'Sun, Sep 20, 2026');
    });
  });
}
