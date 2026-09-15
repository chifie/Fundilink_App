import 'package:shared_preferences/shared_preferences.dart';

/// The slice of local storage the app actually uses.
///
/// Widget tests and previews cannot touch platform channels, so everything
/// that persists goes through this interface and can be swapped for
/// [InMemoryKeyValueStore].
///
/// Reads are synchronous because `SharedPreferences` caches values in
/// memory; writes update that cache immediately and flush in the background.
abstract interface class KeyValueStore {
  String? getString(String key);
  List<String>? getStrings(String key);
  bool? getBool(String key);
  void setString(String key, String value);
  void setStrings(String key, List<String> value);
  void setBool(String key, bool value);
  void remove(String key);
}

/// [KeyValueStore] backed by `SharedPreferences`.
class PrefsKeyValueStore implements KeyValueStore {
  PrefsKeyValueStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  List<String>? getStrings(String key) => _prefs.getStringList(key);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  void setString(String key, String value) => _prefs.setString(key, value);

  @override
  void setStrings(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  @override
  void setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  void remove(String key) => _prefs.remove(key);
}

/// Non-persistent [KeyValueStore] for tests and demo runs.
///
/// Values live for as long as the instance does, which is exactly the
/// lifetime of a widget test.
class InMemoryKeyValueStore implements KeyValueStore {
  InMemoryKeyValueStore([Map<String, Object>? seed])
    : _values = <String, Object>{...?seed};

  final Map<String, Object> _values;

  @override
  String? getString(String key) => _values[key] as String?;

  @override
  List<String>? getStrings(String key) => _values[key] as List<String>?;

  @override
  bool? getBool(String key) => _values[key] as bool?;

  @override
  void setString(String key, String value) => _values[key] = value;

  @override
  void setStrings(String key, List<String> value) =>
      _values[key] = List<String>.of(value);

  @override
  void setBool(String key, bool value) => _values[key] = value;

  @override
  void remove(String key) => _values.remove(key);
}
