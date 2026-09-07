/// Utility functions for list manipulation and transformations.
class ListUtils {
  /// Returns a list of items with indices paired with each item.
  static List<T> withIndex<T>(List<T> list) {
    return List.generate(list.length, (index) => list[index]);
  }

  /// Maps a list to a new list of pairs (index, item).
  static List<(int, T)> asIndexedList<T>(List<T> list) {
    return List.generate(list.length, (index) => (index, list[index]));
  }

  /// Groups a list of items by a key function.
  static Map<K, List<T>> groupBy<T, K>(List<T> items, K Function(T) keyFn) {
    final Map<K, List<T>> result = {};
    for (final item in items) {
      final key = keyFn(item);
      result.putIfAbsent(key, () => []).add(item);
    }
    return result;
  }

  /// Partitions a list into two lists based on a predicate.
  static (List<T>, List<T>) partition<T>(
    List<T> items,
    bool Function(T) predicate,
  ) {
    final pass = <T>[];
    final fail = <T>[];
    for (final item in items) {
      if (predicate(item)) {
        pass.add(item);
      } else {
        fail.add(item);
      }
    }
    return (pass, fail);
  }

  /// Removes null values from a list.
  static List<T> removeNulls<T>(List<T?> items) {
    return items.whereType<T>().toList();
  }

  /// Returns a paginated sublist.
  static List<T> paginate<T>(
    List<T> items,
    int page, {
    int pageSize = 10,
  }) {
    final start = (page - 1) * pageSize;
    if (start >= items.length) return [];
    final end = (start + pageSize).clamp(0, items.length);
    return items.sublist(start, end);
  }

  /// Checks if a list is empty or null.
  static bool isNullOrEmpty<T>(List<T>? list) {
    return list == null || list.isEmpty;
  }

  /// Checks if a list is not empty and not null.
  static bool isNotNullOrEmpty<T>(List<T>? list) {
    return list != null && list.isNotEmpty;
  }

  /// Returns the first item or null if the list is empty.
  static T? firstOrNull<T>(List<T> items) {
    return items.isNotEmpty ? items.first : null;
  }

  /// Returns the last item or null if the list is empty.
  static T? lastOrNull<T>(List<T> items) {
    return items.isNotEmpty ? items.last : null;
  }

  /// Returns a random item from the list, or null if empty.
  static T? random<T>(List<T> items, {int? seed}) {
    if (items.isEmpty) return null;
    final random = seed != null ? Random(seed) : Random();
    return items[random.nextInt(items.length)];
  }

  /// Shuffles a list using the Fisher-Yates algorithm.
  static List<T> shuffle<T>(List<T> items, {int? seed}) {
    final random = seed != null ? Random(seed) : Random();
    final copy = List<T>.from(items);
    for (var i = copy.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = copy[i];
      copy[i] = copy[j];
      copy[j] = temp;
    }
    return copy;
  }

  /// Returns a list of unique items (removes duplicates).
  static List<T> distinct<T>(List<T> items) {
    return items.toSet().toList();
  }

  /// Returns distinct items by a key function.
  static List<T> distinctBy<T, K>(List<T> items, K Function(T) keyFn) {
    final seen = <K>{};
    return items.where((item) {
      final key = keyFn(item);
      if (seen.contains(key)) return false;
      seen.add(key);
      return true;
    }).toList();
  }

  /// Chunks a list into smaller lists of a given size.
  static List<List<T>> chunk<T>(List<T> items, int chunkSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < items.length; i += chunkSize) {
      final end = (i + chunkSize).clamp(0, items.length);
      chunks.add(items.sublist(i, end));
    }
    return chunks;
  }

  /// Returns items at specified indices.
  static List<T> atIndices<T>(List<T> items, List<int> indices) {
    return indices.map((index) => items[index]).toList();
  }

  /// Replaces an item at a specific index, returning a new list.
  static List<T> replaceAt<T>(List<T> items, int index, T newValue) {
    final copy = List<T>.from(items);
    copy[index] = newValue;
    return copy;
  }

  /// Inserts an item at a specific index, returning a new list.
  static List<T> insertAt<T>(List<T> items, int index, T item) {
    final copy = List<T>.from(items)..insert(index, item);
    return copy;
  }

  /// Removes an item at a specific index, returning a new list.
  static List<T> removeAt<T>(List<T> items, int index) {
    final copy = List<T>.from(items)..removeAt(index);
    return copy;
  }

  /// Returns true if all items satisfy the predicate.
  static bool all<T>(List<T> items, bool Function(T) test) {
    for (final item in items) {
      if (!test(item)) return false;
    }
    return true;
  }

  /// Returns true if any item satisfies the predicate.
  static bool any<T>(List<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return true;
    }
    return false;
  }

  /// Finds the first item matching the predicate, or null.
  static T? find<T>(List<T> items, bool Function(T) predicate) {
    for (final item in items) {
      if (predicate(item)) return item;
    }
    return null;
  }

  /// Counts items matching the predicate.
  static int count<T>(List<T> items, bool Function(T) predicate) {
    var count = 0;
    for (final item in items) {
      if (predicate(item)) count++;
    }
    return count;
  }

  /// Sums numeric values from a list.
  static num sum<T>(List<T> items, num Function(T) selector) {
    num total = 0;
    for (final item in items) {
      total += selector(item);
    }
    return total;
  }

  /// Calculates the average of numeric values from a list.
  static double? average<T>(List<T> items, num Function(T) selector) {
    if (items.isEmpty) return null;
    return sum(items, selector) / items.length;
  }

  /// Finds the minimum value using a selector function.
  static T? min<T>(List<T> items, Comparable<T> Function(T) selector) {
    if (items.isEmpty) return null;
    T? minItem;
    Comparable? minValue;
    for (final item in items) {
      final value = selector(item);
      if (minValue == null || value.compareTo(minValue as Comparable) < 0) {
        minItem = item;
        minValue = value;
      }
    }
    return minItem;
  }

  /// Finds the maximum value using a selector function.
  static T? max<T>(List<T> items, Comparable<T> Function(T) selector) {
    if (items.isEmpty) return null;
    T? maxItem;
    Comparable? maxValue;
    for (final item in items) {
      final value = selector(item);
      if (maxValue == null || value.compareTo(maxValue as Comparable) > 0) {
        maxItem = item;
        maxValue = value;
      }
    }
    return maxItem;
  }
}

import 'dart:math';

