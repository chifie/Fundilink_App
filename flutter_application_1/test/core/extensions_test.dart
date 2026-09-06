import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/extensions/datetime_extensions.dart';
import 'package:fundi_link/core/extensions/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    test('capitalize uppercases the first letter only', () {
      expect('hello'.capitalize, 'Hello');
      expect('hello world'.capitalize, 'Hello world');
      expect(''.capitalize, '');
    });

    test('truncate adds an ellipsis past the limit', () {
      expect('FundiLink'.truncate(5), 'Fundi…');
      expect('FundiLink'.truncate(20), 'FundiLink');
    });

    test('isValidEmail matches well-formed addresses', () {
      expect('brian@example.com'.isValidEmail, isTrue);
      expect('not-an-email'.isValidEmail, isFalse);
    });

    test('initials derives two-letter initials from a name', () {
      expect('James Otieno'.initials, 'JO');
      expect('Ana'.initials, 'A');
      expect(''.initials, '?');
    });
  });

  group('DateTimeExtensions', () {
    test('isToday matches the current calendar day', () {
      expect(DateTime.now().isToday, isTrue);
      expect(DateTime.now().subtract(const Duration(days: 1)).isToday, isFalse);
    });

    test('isYesterday matches the previous calendar day', () {
      expect(DateTime.now().subtract(const Duration(days: 1)).isYesterday, isTrue);
      expect(DateTime.now().isYesterday, isFalse);
    });

    test('isThisWeek covers dates within the last seven days', () {
      expect(DateTime.now().isThisWeek, isTrue);
      expect(DateTime.now().subtract(const Duration(days: 2)).isThisWeek, isTrue);
    });

    test('timeAgo returns human-friendly labels', () {
      final now = DateTime.now();
      expect(now.subtract(const Duration(seconds: 30)).timeAgo, 'just now');
      expect(now.subtract(const Duration(minutes: 5)).timeAgo, '5m ago');
      expect(now.subtract(const Duration(hours: 2)).timeAgo, '2h ago');
      expect(now.subtract(const Duration(days: 40)).timeAgo, '1mo ago');
    });
  });
}