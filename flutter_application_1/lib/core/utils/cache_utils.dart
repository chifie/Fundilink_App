import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// A single entry stored in [MemoryCache] with optional expiry.
class _CacheEntry<T> {
  const _CacheEntry({
    required this.value,
    required this.createdAt,
    this.expiry,
  });

  final T value;
  final DateTime createdAt;
  final DateTime? expiry;
}

/// A utility class for in-memory caching with TTL support.
class MemoryCache {
  final int maxSize;
  final Map<String, _CacheEntry<dynamic>> _cache = {};
  int _currentSize = 0;
  final LinkedHashMap<String, int> _accessOrder;

  /// Creates a MemoryCache with the specified maximum size (in entries).
  MemoryCache({this.maxSize = 100}) : _accessOrder = LinkedHashMap<String, int>();

  /// Get a value from the cache.
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) {
      return null;
    }
    
    // Check if expired
    if (entry.expiry != null && entry.expiry!.isBefore(DateTime.now())) {
      _removeEntry(key);
      return null;
    }
    
    // Update access order (LRU)
    _updateAccessOrder(key);
    
    return entry.value as T?;
  }

  /// Put a value into the cache.
  void put<T>(String key, T value, {Duration? ttl}) {
    // If key exists, remove it first to recalculate size
    if (_cache.containsKey(key)) {
      _removeEntry(key);
    }
    
    // Evict if needed
    while (_currentSize >= maxSize && _cache.isNotEmpty) {
      _evictOldest();
    }
    
    final entry = _CacheEntry<T>(
      value: value,
      createdAt: DateTime.now(),
      expiry: ttl != null ? DateTime.now().add(ttl) : null,
    );
    
    _cache[key] = entry;
    _accessOrder[key] = _currentSize;
    _currentSize++;
  }

  /// Remove a value from the cache.
  void remove(String key) {
    _removeEntry(key);
  }

  /// Clear the entire cache.
  void clear() {
    _cache.clear();
    _accessOrder.clear();
    _currentSize = 0;
  }

  /// Check if a key exists in the cache.
  bool containsKey(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    if (entry.expiry != null && entry.expiry!.isBefore(DateTime.now())) {
      _removeEntry(key);
      return false;
    }
    return true;
  }

  /// Get the number of items in the cache.
  int get size => _currentSize;

  /// Get all keys in the cache.
  List<String> get keys => _accessOrder.keys.toList();

  /// Update access order for LRU eviction.
  void _updateAccessOrder(String key) {
    final newAccessOrder = <String, int>{};
    var order = 0;
    for (final k in _accessOrder.keys) {
      if (k == key) {
        newAccessOrder[k] = order++;
      } else {
        newAccessOrder[k] = order++;
      }
    }
    _accessOrder.clear();
    _accessOrder.addAll(newAccessOrder);
  }

  /// Remove an entry and update state.
  void _removeEntry(String key) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
      _accessOrder.remove(key);
      _currentSize--;
    }
  }

  /// Evict the oldest entry (LRU).
  void _evictOldest() {
    if (_accessOrder.isNotEmpty) {
      final oldestKey = _accessOrder.keys.first;
      _removeEntry(oldestKey);
    }
  }
}

/// A cache for storing JSON data.
class JsonCache {
  final MemoryCache _cache = MemoryCache();

  /// Put JSON-serializable data into the cache.
  void put(String key, dynamic data, {Duration? ttl}) {
    final jsonString = jsonEncode(data);
    _cache.put(key, jsonString, ttl: ttl);
  }

  /// Get JSON data from the cache.
  T? get<T>(String key, {T Function(dynamic)? parser}) {
    final jsonString = _cache.get<String>(key);
    if (jsonString == null) return null;
    
    try {
      final decoded = jsonDecode(jsonString);
      return parser != null ? parser(decoded) : decoded as T?;
    } catch (e) {
      return null;
    }
  }

  /// Check if key exists.
  bool containsKey(String key) => _cache.containsKey(key);

  /// Remove a key.
  void remove(String key) => _cache.remove(key);

  /// Clear all cached data.
  void clear() => _cache.clear();

  /// Get cache size.
  int get size => _cache.size;
}

/// A persistent file-based cache for storing data across app restarts.
class FileCache {
  Directory? _cacheDir;
  final String _directoryName;

  /// Creates a FileCache with a custom directory name.
  FileCache({String directoryName = 'cache'}) : _directoryName = directoryName;

  /// Initialize the cache directory.
  Future<void> init() async {
    _cacheDir = await _getCacheDirectory();
  }

  Directory? get cacheDirectory => _cacheDir;

  /// Get a value from the file cache.
  Future<String?> get(String key) async {
    if (_cacheDir == null) {
      await init();
    }
    
    final file = File('${_cacheDir!.path}/$key');
    if (await file.exists()) {
      return file.readAsString();
    }
    return null;
  }

  /// Put a value into the file cache.
  Future<void> put(String key, String value, {Duration? ttl}) async {
    if (_cacheDir == null) {
      await init();
    }
    
    final file = File('${_cacheDir!.path}/$key');
    final data = jsonEncode({
      'value': value,
      'createdAt': DateTime.now().toIso8601String(),
      'ttl': ttl?.inMilliseconds,
    });
    await file.writeAsString(data);
  }

  /// Put JSON data into the file cache.
  Future<void> putJson(String key, dynamic data, {Duration? ttl}) async {
    final jsonString = jsonEncode(data);
    await put(key, jsonString, ttl: ttl);
  }

  /// Get JSON data from the file cache.
  Future<T?> getJson<T>(String key, {T Function(dynamic)? parser}) async {
    final jsonString = await get(key);
    if (jsonString == null) return null;
    
    try {
      final data = jsonDecode(jsonString);
      return parser != null ? parser(data) : data as T?;
    } catch (e) {
      return null;
    }
  }

  /// Remove a key from the cache.
  Future<void> remove(String key) async {
    if (_cacheDir == null) return;
    
    final file = File('${_cacheDir!.path}/$key');
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Clear all cached files.
  Future<void> clear() async {
    if (_cacheDir == null) return;
    
    await for (final entity in _cacheDir!.list(recursive: true)) {
      if (entity is File) {
        await entity.delete();
      }
    }
  }

  /// Get all cached keys.
  Future<List<String>> getKeys() async {
    if (_cacheDir == null) return [];
    
    final keys = <String>[];
    await for (final entity in _cacheDir!.list()) {
      if (entity is File) {
        keys.add(entity.path.split('/').last);
      }
    }
    return keys;
  }

  /// Check if a key exists.
  Future<bool> containsKey(String key) async {
    if (_cacheDir == null) return false;
    
    final file = File('${_cacheDir!.path}/$key');
    return file.exists();
  }

  /// Remove expired entries.
  Future<void> removeExpired() async {
    if (_cacheDir == null) return;
    
    await for (final entity in _cacheDir!.list()) {
      if (entity is File) {
        try {
          final content = await entity.readAsString();
          final data = jsonDecode(content);
          final createdAt = DateTime.parse(data['createdAt'] as String);
          final ttlMs = data['ttl'] as int?;
          
          if (ttlMs != null) {
            final expiry = createdAt.add(Duration(milliseconds: ttlMs));
            if (expiry.isBefore(DateTime.now())) {
              await entity.delete();
            }
          }
        } catch (_) {
          // If parsing fails, keep the file
        }
      }
    }
  }

  /// Get the cache directory.
  Future<Directory> _getCacheDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDocDir.path}/$_directoryName');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }
}

/// A combined memory + file cache for best performance and persistence.
class HybridCache {
  final MemoryCache _memoryCache;
  final FileCache _fileCache;
  final bool _persistToDisk;

  /// Creates a HybridCache.
  /// [maxMemorySize] is the maximum number of entries in memory.
  /// [persistToDisk] controls whether to write to disk.
  HybridCache({
    int maxMemorySize = 100,
    bool persistToDisk = true,
    String directoryName = 'cache',
  })  : _memoryCache = MemoryCache(maxSize: maxMemorySize),
        _fileCache = FileCache(directoryName: directoryName),
        _persistToDisk = persistToDisk;

  /// Initialize the cache.
  Future<void> init() async {
    if (_persistToDisk) {
      await _fileCache.init();
    }
  }

  /// Get a value from the cache (checks memory first, then file).
  Future<T?> get<T>(String key, {T Function(dynamic)? parser}) async {
    // Try memory first
    var value = _memoryCache.get<String>(key);
    if (value != null) {
      try {
        final decoded = jsonDecode(value);
        return parser != null ? parser(decoded) : decoded as T?;
      } catch (e) {
        return null;
      }
    }
    
    // Try file cache
    if (_persistToDisk) {
      value = await _fileCache.get(key);
      if (value != null) {
        try {
          final decoded = jsonDecode(value);
          // Also cache in memory
          _memoryCache.put(key, value);
          return parser != null ? parser(decoded) : decoded as T?;
        } catch (e) {
          return null;
        }
      }
    }
    
    return null;
  }

  /// Put a value into the cache.
  Future<void> put<T>(String key, T value, {Duration? ttl}) async {
    final jsonString = jsonEncode(value);
    _memoryCache.put(key, jsonString, ttl: ttl);
    
    if (_persistToDisk) {
      await _fileCache.put(key, jsonString, ttl: ttl);
    }
  }

  /// Remove a key from the cache.
  Future<void> remove(String key) async {
    _memoryCache.remove(key);
    if (_persistToDisk) {
      await _fileCache.remove(key);
    }
  }

  /// Clear the cache.
  Future<void> clear() async {
    _memoryCache.clear();
    if (_persistToDisk) {
      await _fileCache.clear();
    }
  }

  /// Check if a key exists.
  Future<bool> containsKey(String key) async {
    if (_memoryCache.containsKey(key)) {
      return true;
    }
    if (_persistToDisk) {
      return await _fileCache.containsKey(key);
    }
    return false;
  }

  /// Get the memory cache size.
  int get memorySize => _memoryCache.size;
}

/// Extension for adding cache operations to Maps.
extension CacheExtension on Map {
  /// Get a value with fallback.
  V? getCached<K, V>(K key, {V? fallback}) {
    return this[key] as V? ?? fallback;
  }

  /// Put a value with expiration tracking.
  void putWithExpiry<K, V>(K key, V value, DateTime expiry) {
    this[key] = {
      'value': value,
      'expiry': expiry.toIso8601String(),
    };
  }

  /// Get a value if not expired.
  V? getValidated<K, V>(K key) {
    final entry = this[key];
    if (entry is! Map) return null;
    
    final expiryStr = entry['expiry'] as String?;
    if (expiryStr == null) return entry['value'] as V?;
    
    final expiry = DateTime.tryParse(expiryStr);
    if (expiry == null || expiry.isBefore(DateTime.now())) {
      this.remove(key);
      return null;
    }
    
    return entry['value'] as V?;
  }
}
