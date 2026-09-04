/// List helper extensions and utilities.
extension ListExtensions<T> on List<T> {
  /// Returns the list chunked into groups of [size].
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size).clamp(0, length)));
    }
    return chunks;
  }

  /// Returns distinct elements based on a key selector.
  List<T> distinctBy(dynamic Function(T) keySelector) {
    final seen = <dynamic>{};
    return where((item) => seen.add(keySelector(item))).toList();
  }

  /// Returns the element at [index] or null if out of bounds.
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
