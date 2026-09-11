import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/utils/list_utils.dart';

void main() {
  group('ListUtils', () {
    test('groupBy groups items by key', () {
      final items = ['apple', 'ant', 'bear', 'cat'];
      final grouped = ListUtils.groupBy(items, (s) => s[0]);
      expect(grouped['a'], ['apple', 'ant']);
      expect(grouped['b'], ['bear']);
      expect(grouped['c'], ['cat']);
    });

    test('partition splits on predicate', () {
      final (evens, odds) = ListUtils.partition(
        [1, 2, 3, 4, 5],
        (n) => n.isEven,
      );
      expect(evens, [2, 4]);
      expect(odds, [1, 3, 5]);
    });

    test('paginate returns the requested page', () {
      final items = List.generate(25, (i) => i);
      expect(ListUtils.paginate(items, 1), hasLength(10));
      expect(ListUtils.paginate(items, 3), hasLength(5));
      expect(ListUtils.paginate(items, 4), isEmpty);
    });

    test('removeNulls drops null values', () {
      expect(ListUtils.removeNulls([1, null, 2, null, 3]), [1, 2, 3]);
    });

    test('chunk splits into fixed-size chunks', () {
      expect(ListUtils.chunk([1, 2, 3, 4, 5], 2), [
        [1, 2],
        [3, 4],
        [5],
      ]);
    });

    test('distinct removes duplicates', () {
      expect(ListUtils.distinct([1, 2, 2, 3, 1]), [1, 2, 3]);
    });

    test('distinctBy keeps the first item per key', () {
      final items = [
        {'id': 1, 'name': 'a'},
        {'id': 1, 'name': 'b'},
        {'id': 2, 'name': 'c'},
      ];
      final result = ListUtils.distinctBy(items, (m) => m['id']);
      expect(result, hasLength(2));
      expect(result.first['name'], 'a');
    });

    test('min and max use the selector', () {
      final items = ['cat', 'apple', 'elephant'];
      expect(ListUtils.min(items, (s) => s), 'apple');
      expect(ListUtils.max(items, (s) => s), 'elephant');
      expect(ListUtils.min<String>([], (s) => s), isNull);
    });

    test('sum and average compute correctly', () {
      expect(ListUtils.sum([1, 2, 3], (n) => n), 6);
      expect(ListUtils.average([1, 2, 3], (n) => n), 2.0);
      expect(ListUtils.average([], (n) => n), isNull);
    });

    test('find, count, all and any', () {
      final items = [1, 2, 3, 4];
      expect(ListUtils.find(items, (n) => n > 3), 4);
      expect(ListUtils.find(items, (n) => n > 10), isNull);
      expect(ListUtils.count(items, (n) => n.isEven), 2);
      expect(ListUtils.all(items, (n) => n > 0), isTrue);
      expect(ListUtils.any(items, (n) => n == 3), isTrue);
    });

    test('firstOrNull and lastOrNull', () {
      expect(ListUtils.firstOrNull([1, 2]), 1);
      expect(ListUtils.firstOrNull<int>([]), isNull);
      expect(ListUtils.lastOrNull([1, 2]), 2);
      expect(ListUtils.lastOrNull<int>([]), isNull);
    });

    test('random and shuffle are deterministic with a seed', () {
      final items = [1, 2, 3, 4, 5];
      final shuffled1 = ListUtils.shuffle(items, seed: 7);
      final shuffled2 = ListUtils.shuffle(items, seed: 7);
      expect(shuffled1, shuffled2);
      expect(shuffled1.toSet(), items.toSet());
      expect(ListUtils.random(items, seed: 7), ListUtils.random(items, seed: 7));
      expect(ListUtils.random<int>([]), isNull);
    });

    test('isNullOrEmpty helpers', () {
      expect(ListUtils.isNullOrEmpty(null), isTrue);
      expect(ListUtils.isNullOrEmpty([]), isTrue);
      expect(ListUtils.isNotNullOrEmpty([1]), isTrue);
      expect(ListUtils.isNotNullOrEmpty(null), isFalse);
    });

    test('withIndex and asIndexedList pair items with indices', () {
      expect(ListUtils.withIndex(['a', 'b']), ['a', 'b']);
      expect(ListUtils.asIndexedList(['a', 'b']), [(0, 'a'), (1, 'b')]);
    });

    test('atIndices, replaceAt, insertAt and removeAt', () {
      final items = [10, 20, 30];
      expect(ListUtils.atIndices(items, [0, 2]), [10, 30]);
      expect(ListUtils.replaceAt(items, 1, 99), [10, 99, 30]);
      expect(ListUtils.insertAt(items, 1, 15), [10, 15, 20, 30]);
      expect(ListUtils.removeAt(items, 0), [20, 30]);
    });
  });
}