import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/utils/date_helper.dart';

void main() {
  group('DateHelper.todayFormatted', () {
    test('returns today formatted as MMM d, yyyy', () {
      expect(
        DateHelper.todayFormatted(),
        matches(RegExp(r'^[A-Z][a-z]{2} \d{1,2}, \d{4}$')),
      );
    });
  });

  group('DateHelper.dayName', () {
    test('maps each weekday to its English name', () {
      const expected = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      // Monday, 7 September 2026 is a known weekday; derive others from it.
      for (var i = 0; i < 7; i++) {
        final date = DateTime(2026, 9, 7).add(Duration(days: i));
        expect(DateHelper.dayName(date), expected[i]);
      }
    });
  });

  group('DateHelper.shortDayName', () {
    test('returns the three-letter abbreviation', () {
      final date = DateTime(2026, 9, 7); // Monday
      expect(DateHelper.shortDayName(date), 'Mon');
    });
  });

  group('DateHelper.isSameDay', () {
    test('compares calendar days, ignoring time', () {
      final a = DateTime(2026, 9, 7, 8, 30);
      final b = DateTime(2026, 9, 7, 22, 45);
      final c = DateTime(2026, 9, 8);
      expect(DateHelper.isSameDay(a, b), isTrue);
      expect(DateHelper.isSameDay(a, c), isFalse);
    });
  });
}
