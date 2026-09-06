# FundiLink

Connect with trusted local fundis and service providers.

FundiLink is a Flutter marketplace app that links customers with verified
fundis (plumbers, electricians, carpenters, painters and more). Customers can
browse fundis, book services and track requests, while fundis can manage their
profile, portfolio, availability, jobs and earnings.

## Features

- **Onboarding & auth** — first-run onboarding, customer/fundi registration and
  demo logins for instant exploration.
- **Home & search** — category browsing, search with filters, and recommended
  fundis with ratings, prices and response times.
- **Fundi profiles** — verified badges, stats, availability, portfolio and
  reviews, with chat and request actions.
- **Service requests** — booking form, request tracking, status updates and
  cancellation.
- **Fundi workspace** — dashboard with stats and quick actions, jobs, requests,
  portfolio, availability, profile management and earnings.
- **Chat** — conversations and threaded messages with fundis.
- **Notifications & settings** — activity notifications and app preferences.

## Getting Started

### Prerequisites

- Flutter SDK (see `pubspec.yaml` for the required Dart SDK version)
- A device, emulator, or browser to run the app

### Run

```bash
flutter pub get
flutter run
```

### Test

```bash
flutter test
```

### Analyze

```bash
flutter analyze
```

## Demo Accounts

The login screen ships with pre-filled demo credentials so you can explore both
sides of the app without registering:

| Role    | Email              | Password   |
| ------- | ------------------ | ---------- |
| Customer| brian@example.com  | fundilink  |
| Fundi   | james@example.com  | fundilink  |

## Project Structure

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

## License

Private project — all rights reserved.