# Contributing to FundiLink

Thanks for your interest in contributing to FundiLink! This guide covers the
basics of working on the project.

## Project layout

The Flutter app lives in `flutter_application_1/`. All `flutter` commands below
are run from that directory.

```
lib/
  core/         App constants, theme, navigation, and shared utilities
  data/         Mock data used while the backend is not connected
  features/     Feature modules (auth, home, search, requests, chat, ...)
  models/       Domain models (Fundi, ServiceRequest, Review, ...)
  providers/    ChangeNotifier state management
  repositories/ Data access layer
  services/     API client and service layer
  widgets/      Reusable UI components
test/           Widget and unit tests
```

## Getting started

1. Fork the repository and clone your fork.
2. Make sure you have the Flutter SDK installed (see `pubspec.yaml` for the
   required Dart SDK version).
3. Install dependencies and confirm everything is green:

```bash
cd flutter_application_1
flutter pub get
flutter analyze
flutter test
```

## Making changes

- Keep changes focused and commit them in small, logical units.
- Run `flutter analyze` and `flutter test` before pushing — CI runs both and
  will fail otherwise.
- Add tests for new behavior. Prefer unit tests for pure logic and widget
  tests for UI components; existing tests under `test/` are good templates.
- Follow the existing code style. Run `dart format` if you are unsure whether
  your formatting matches.
- Reuse the shared constants (`AppStrings`, `AppColors`, `AppDimensions`,
  `DemoAccounts`) instead of hardcoding new values.

## Commit style

Write concise, imperative commit messages that describe *why* a change was
made, not just what it does. For example:

```
Add persisted theme mode toggle

The app shipped with a dark theme that could never be enabled. Add a
settings provider backed by shared_preferences and a toggle so users can
switch between light and dark mode.
```

## Pull requests

- Reference the issue your PR addresses, if any.
- Describe what changed and why, plus how it was verified.
- Keep the diff reviewable — split large features into separate PRs when
  sensible.

## Code of conduct

Be respectful and constructive. We welcome contributors of all experience
levels.