# swappy

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Dependencies

This project uses a service-locator approach powered by
[`get_it`](https://pub.dev/packages/get_it) and
[`provider`](https://pub.dev/packages/provider) for state management.
Core services are registered in `lib/infrastructure/di/locator.dart`:

- `AppStateController` – global application state.
- `AuthService` – authentication wrapper around Firebase.
- `SearchRepository` – mock data source used by `SearchController`.
- `SearchController` – manages search queries.

Contributors should register new repositories or services in the locator and
access them with `locator<T>()` when needed.
