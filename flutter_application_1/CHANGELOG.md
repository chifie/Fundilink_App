# Changelog

All notable changes to FundiLink are documented here. This project follows
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- GitHub Actions CI pipeline that runs `flutter analyze` and `flutter test`.
- Persisted light/dark theme mode and push-notifications toggles in Settings.
- Haptic feedback on key actions (login and request submission).
- Demo fundi quick-fill button on the login screen.
- Time-of-day greeting ("Good morning/afternoon/evening") on the home screen.
- Auto-scroll keeps the chat thread pinned to the newest message.
- Loading and error (with retry) states on the conversation list, notification
  inbox and reviews screen.
- Tooltips and semantics on icon-only controls and quick actions.

### Changed
- Remaining hardcoded user-facing copy centralized in `AppStrings`.
- Request status hints and icons moved into the request-status model.
- Customer and fundi request lists share one `RequestFilterBar` widget.
- Relative-time labels unified behind the shared `DateTimeExtensions.timeAgo`.
- Success/coming-soon feedback routes through the shared `Toast` helper.
- Removed duplicated and unused helpers (`Helpers.shortAmount`, unused
  `CurrencyFormatter`).

### Fixed
- Notification and chat providers now expose load errors instead of silently
  showing empty states.

### Tests
- Added provider tests for auth, chat, fundi, notifications, requests,
  reviews and settings.
- Added unit tests for `Helpers` and the request-status helpers.
- Added widget tests for `FundiAvatar`.

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