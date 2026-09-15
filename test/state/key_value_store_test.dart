import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/state/key_value_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Behaviour every [KeyValueStore] implementation has to share.
void _expectStoreContract(KeyValueStore Function() create) {
  test('returns null for keys that were never written', () {
    final store = create();

    expect(store.getString('missing'), isNull);
    expect(store.getStrings('missing'), isNull);
    expect(store.getBool('missing'), isNull);
  });

  test('round-trips strings, string lists and booleans', () {
    final store = create()
      ..setString('theme', 'dark')
      ..setStrings('searches', ['plumbing', 'cleaning'])
      ..setBool('onboarded', true);

    expect(store.getString('theme'), 'dark');
    expect(store.getStrings('searches'), ['plumbing', 'cleaning']);
    expect(store.getBool('onboarded'), isTrue);
  });

  test('overwrites an existing value', () {
    final store = create()
      ..setString('theme', 'dark')
      ..setString('theme', 'light');

    expect(store.getString('theme'), 'light');
  });

  test('remove deletes a value', () {
    final store = create()..setBool('onboarded', true);

    store.remove('onboarded');

    expect(store.getBool('onboarded'), isNull);
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InMemoryKeyValueStore', () {
    _expectStoreContract(InMemoryKeyValueStore.new);

    test('accepts seed values', () {
      final store = InMemoryKeyValueStore({'theme': 'dark'});

      expect(store.getString('theme'), 'dark');
    });

    test('copies a stored list so later edits do not leak in', () {
      final store = InMemoryKeyValueStore();
      final searches = ['plumbing'];

      store.setStrings('searches', searches);
      searches.add('cleaning');

      expect(store.getStrings('searches'), ['plumbing']);
    });

    test('instances do not share state', () {
      InMemoryKeyValueStore().setString('theme', 'dark');

      expect(InMemoryKeyValueStore().getString('theme'), isNull);
    });
  });

  group('PrefsKeyValueStore', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues(const {});
      prefs = await SharedPreferences.getInstance();
    });

    _expectStoreContract(() => PrefsKeyValueStore(prefs));

    test('reads values already on disk when it is created', () async {
      SharedPreferences.setMockInitialValues(const {
        'theme': 'dark',
        'searches': <String>['plumbing'],
      });
      final reloaded = await SharedPreferences.getInstance();

      final store = PrefsKeyValueStore(reloaded);

      expect(store.getString('theme'), 'dark');
      expect(store.getStrings('searches'), ['plumbing']);
    });

    test('writes are visible to a freshly created wrapper', () {
      PrefsKeyValueStore(prefs).setString('theme', 'dark');

      expect(PrefsKeyValueStore(prefs).getString('theme'), 'dark');
    });
  });
}
