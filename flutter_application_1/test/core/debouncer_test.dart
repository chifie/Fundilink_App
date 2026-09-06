import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/utils/debouncer.dart';

void main() {
  test('runs the action after the delay elapses', () async {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
    var calls = 0;

    debouncer.run(() => calls++);
    expect(calls, 0);

    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(calls, 0);

    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(calls, 1);

    debouncer.dispose();
  });

  test('cancels a pending call when run is invoked again', () async {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
    var calls = 0;

    debouncer.run(() => calls++);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    debouncer.run(() => calls++);

    await Future<void>.delayed(const Duration(milliseconds: 150));
    expect(calls, 1);

    debouncer.dispose();
  });

  test('dispose cancels any pending call', () async {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
    var calls = 0;

    debouncer.run(() => calls++);
    debouncer.dispose();

    await Future<void>.delayed(const Duration(milliseconds: 150));
    expect(calls, 0);
  });
}