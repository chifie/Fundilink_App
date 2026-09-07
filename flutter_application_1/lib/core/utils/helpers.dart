import '../constants/app_strings.dart';

/// Miscellaneous shared helpers used across the app.
class Helpers {
  Helpers._();

  /// Maps a name to a stable color seed for initials avatars.
  static int colorSeed(String name) =>
      name.codeUnits.fold(0, (acc, c) => acc + c);

  /// Time-appropriate greeting for [now], e.g. "Good afternoon".
  static String greetingFor(DateTime now) {
    if (now.hour < 12) return AppStrings.goodMorning;
    if (now.hour < 17) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }
}
