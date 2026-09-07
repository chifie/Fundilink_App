import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/core/utils/helpers.dart';

void main() {
  group('Helpers.colorSeed', () {
    test('is stable for the same name', () {
      expect(
        Helpers.colorSeed('James Otieno'),
        Helpers.colorSeed('James Otieno'),
      );
    });

    test('varies for different names', () {
      expect(Helpers.colorSeed('Brian'), isNot(Helpers.colorSeed('James')));
    });
  });

  group('Helpers.greetingFor', () {
    test('says good morning before noon', () {
      expect(
        Helpers.greetingFor(DateTime(2026, 9, 7, 8)),
        AppStrings.goodMorning,
      );
      expect(
        Helpers.greetingFor(DateTime(2026, 9, 7, 11, 59)),
        AppStrings.goodMorning,
      );
    });

    test('says good afternoon from noon to 5pm', () {
      expect(
        Helpers.greetingFor(DateTime(2026, 9, 7, 12)),
        AppStrings.goodAfternoon,
      );
      expect(
        Helpers.greetingFor(DateTime(2026, 9, 7, 16, 59)),
        AppStrings.goodAfternoon,
      );
    });

    test('says good evening from 5pm onwards', () {
      expect(
        Helpers.greetingFor(DateTime(2026, 9, 7, 17)),
        AppStrings.goodEvening,
      );
      expect(
        Helpers.greetingFor(DateTime(2026, 9, 7, 23)),
        AppStrings.goodEvening,
      );
    });
  });
}
