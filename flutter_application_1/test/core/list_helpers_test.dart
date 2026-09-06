import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/utils/list_helpers.dart';

void main() {
  group('ListExtensions.chunked', () {
    test('splits a list into fixed-size chunks', () {
      expect([1, 2, 3, 4, 5, 6, 7].chunked(3), [
        [1, 2, 3],
        [4, 5, 6],
        [7],
      ]);
    });

    test('returns the whole list when it fits in one chunk', () {
      expect([1, 2].chunked(3), [
        [1, 2],
      ]);
    });
  });

  group('ListExtensions.distinctBy', () {
    test('keeps only the first element per key', () {
      final people = [
        {'name': 'Ana', 'team': 'A'},
        {'name': 'Bob', 'team': 'B'},
        {'name': 'Cara', 'team': 'A'},
      ];
      final distinct = people.distinctBy((p) => p['team']);
      expect(distinct.length, 2);
      expect(distinct.first['name'], 'Ana');
    });
  });

  group('ListExtensions.getOrNull', () {
    test('returns the element at a valid index', () {
      expect(['a', 'b'].getOrNull(1), 'b');
    });

    test('returns null for out-of-range indices', () {
      expect(['a', 'b'].getOrNull(-1), isNull);
      expect(['a', 'b'].getOrNull(5), isNull);
      expect(<int>[].getOrNull(0), isNull);
    });
  });
}
