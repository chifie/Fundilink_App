# Changelog

All notable changes to FundiLink are documented here. This project follows
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- GitHub Actions CI pipeline that runs `flutter analyze` and `flutter test`.
- Expanded unit and widget test coverage for core utilities, models and
  shared widgets.
- Persisted light/dark theme mode toggle in Settings.
- Haptic feedback on key actions (login and request submission).
- Demo fundi quick-fill button on the login screen.

### Changed
- Search screen now uses the shared `Debouncer` utility.
- Logout and request cancellation flows reuse the shared confirm dialog.
- Hardcoded user-facing copy centralized in `AppStrings`.

## [1.0.0] - 2026-09-05

### Added
- Initial release of the FundiLink marketplace app.
- Onboarding, registration and demo login for customers and fundis.
- Home feed with categories, recommended and nearby fundis.
- Fundi profiles with portfolio, availability, reviews and chat.
- Service request booking, tracking, cancellation and review flow.
- Fundi workspace with dashboard, jobs, requests, earnings and settings.

### Fixed
- Compile errors in navigation, image picking, toast and progress tracking.
- Stale demo account references removed in favour of shared constants.