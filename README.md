# FundiLink

Connect with trusted local fundis and service providers — a Flutter app
built with a clean **Material 3** (Material You) design.

## Features

- **Home** — greeting header, service search, tappable category grid, promo
  banner and top-rated fundis with a detail bottom sheet
- **Bookings** — Active / Done / Cancelled filters, progress tracker and a
  timeline detail sheet
- **Chats** — conversation list with unread badges and a working chat room
- **Profile** — grouped settings, theme toggle and account actions
- **New request** — FAB flow with service chips and job description

## Design system

All colors, components and typography live in
[`lib/theme/app_theme.dart`](lib/theme/app_theme.dart):

- **Color** — light and dark schemes seeded from the FundiLink teal via
  `ColorScheme.fromSeed`, with stepped dark surfaces
- **Shapes** — shared 10/16/24 dp corner radius scale
- **Buttons** — pill-shaped M3 variants with 40 dp height
- **Inputs** — filled, rounded text fields with quiet borders
- **Typography** — the full 15-style M3 type scale

The app shell uses an `IndexedStack` body plus a Material 3 `NavigationBar`.

## Project structure

```
lib/
├── data/       # Mock catalogue (fundis, bookings, chats)
├── models/     # Domain models and enums
├── screens/    # Tab screens and bottom sheets
├── shell/      # Home shell with bottom navigation
├── theme/      # Material 3 design tokens
└── widgets/    # Reusable UI components
```

## Getting started

```sh
flutter pub get
flutter run
```

## Tests

```sh
flutter test
flutter analyze
```
