/// Miscellaneous shared helpers used across the app.
class Helpers {
  Helpers._();

  /// Maps a name to a stable color seed for initials avatars.
  static int colorSeed(String name) =>
      name.codeUnits.fold(0, (acc, c) => acc + c);
}
