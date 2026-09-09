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
- The shared profile tab now badges accounts by their actual role instead of
  always showing "Customer".
- Fundi jobs and dashboard activity open the fundi-side request detail
  (accept/start/complete) rather than the customer actions screen.
- The fundi demo account shares the seeded fundi id, so its workspace loads
  requests, jobs and earnings instead of empty state.

### Tests
- Added provider tests for auth, chat, fundi, notifications, requests,
  reviews and settings.
- Added unit tests for `Helpers`, the request-status helpers, the shared
  `RequestFilterBar` and the new repository filters.
- Added widget tests for `FundiAvatar` and the onboarding carousel.

### Internal
- `RequestStatus` exposes `isActive`/`isPaidOut` used by filters, jobs,
  earnings, providers and the repository.
- The dashboard reuses the shared `SectionHeader`, reviews share one
  `ReviewTile`, and profile/settings share one `signOut` action.
- The home build caches its curated fundi lists instead of re-sorting per
  list item.

### Added
- Search now opens the filter sheet and supports available/verified/rating/
  price filters.
- The weekly earnings chart has a labelled "This week" heading.
- Kenyan-shillings currency alias and currency code constants.
- Weekend check helper on DateHelper.
- maskedEmail helper on User and shortComment excerpt on Review.
- isUnread flag on NotificationItem, isFromMe on ChatMessage.
- countFundis and todaysEarnings helpers on the repositories.
- isBusy alias on AuthProvider, hasResults flag on FundiProvider.
- isHighRating flag on RatingStars, _buildIcon on EmptyState.
- randomElement helper on ListExtensions and debouncer isActive flag.
- more model and provider unit tests.

### Added
- Enhanced EmptyState widget with accessibility, responsive sizing, theme-aware colors, and customization options
- Enhanced ErrorView widget with customizable icon, button styling, and support for additional actions
- Enhanced ShimmerLoading widget with customizable direction, duration, and disabled state
- Enhanced LoadingOverlay widget with customizable opacity, colors, alignment, and custom indicators
- Enhanced FundiAvatar widget with online indicator, custom colors, and better diameter support
- Enhanced OnlineStatusIndicator with customizable colors, pulse duration, and toggle for animation
- Enhanced RatingStars widget with customizable colors, thresholds, and extended functionality
- Enhanced StatusChip widget with tap support, custom colors, elevation, and flexible styling
- Enhanced SectionHeader widget with description support, custom styling, divider, and icon options
- Enhanced GradientHeader widget with multiple gradient types, tap support, and extensive customization
- Enhanced PriceTag widget with full customization, tap support, and display options
- Enhanced CompletionRateBadge widget with extensive customization and helper methods
- Enhanced VerifiedBadge widget with label support, custom styling, and animation options
- Enhanced InfoRow widget with tap support, dividers, custom styling, and layout options
- Enhanced SectionDivider widget with customizable dividers, spacing, and styling options
- Enhanced ReviewTile widget with extensive customization and interactive options
- Enhanced ScheduleDisplay widget with extensive customization and formatting options
- Enhanced PortfolioUploadCard with drag-drop support, full customization, and animation options
- Enhanced FundiBadgeDisplay with empty state placeholder and animation support
- Enhanced FundiCard widget with selective display options and custom styling
- Added ColorUtils utility class with common color manipulation functions
- Added SizeUtils utility class with responsive sizing helpers
- Added AnimationUtils utility class with animation helpers and staggered controllers
- Added TextUtils utility class with text manipulation and formatting helpers
- Added DateUtils utility class with comprehensive date and time helpers
- Added ListUtils utility class with comprehensive list manipulation helpers
- Enhanced AppTheme with comprehensive theming and Material 3 support

### Added
- Animated splash screen with brand gradient, elastic logo pop-in, staggered
  text reveal and pulsing loading dots.
- New reusable animated widgets: `EntranceAnimation`, `AnimatedCountUp`,
  `AnimatedProgressBar`, `GradientButton` and `PressableScale`.
- Entrance animations on the home screen (greeting, hero search, section
  headers and staggered fundi rows) and animated onboarding pages.
- Press feedback on fundi cards, gradient headers and price tags.
- Animated earnings count-up, chart bar growth, profile completion ring,
  request progress steps, rating star pops and verified badge pulse.
- Cross-fade loading states on the loading button, overlay and toast.
- Dark mode now matches the light theme's component theming (inputs,
  buttons, snackbars, dialogs, navigation) and default routes use a
  consistent fade-forwards page transition.

### Changed
- `EntranceAnimation` uses cancellable timers for its stagger delay.

### Tests
- Added tests for `ListUtils`, `SizeUtils`, theme structure and the splash
  screen, plus widget tests for all new animated widgets.

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