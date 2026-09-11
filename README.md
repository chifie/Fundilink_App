# Fundilink

A Flutter application built with **Material 3** (Material You) design.

## Material 3 design system

All colors, components and typography are defined in [`lib/theme/app_theme.dart`](lib/theme/app_theme.dart):

- **Color** — light and dark schemes generated from a single seed color via `ColorScheme.fromSeed`
- **Buttons** — filled, tonal, elevated, outlined and text variants with M3 metrics (pill shape, 40 dp height, `labelLarge` labels)
- **Cards** — 12 dp corner radius and tonal surfaces for all three variants (`Card`, `Card.filled`, `Card.outlined`)
- **Typography** — the full 15-style M3 type scale (display → label) with spec sizes, weights and letter spacing

`main.dart` showcases every element, and the app bar includes a light/dark toggle.

## Getting started

```sh
flutter pub get
flutter run
```

## Tests

```sh
flutter test
```
