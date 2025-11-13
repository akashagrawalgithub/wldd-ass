# DevGallery

Flutter app to browse GitHub developers.

## Features

- List of GitHub developers
- Search by username
- View developer details and repositories
- Offline support with caching
- Pull to refresh

## Setup

1. Clone the repo
2. Run `flutter pub get`
3. Run `flutter run`

## Run App

```bash
flutter run
```

## Run Tests

```bash
flutter test
```

## State Management

Using `setState` for state management. For this app, the state is simple and contained within each screen, so setState is sufficient. No need for complex state management libraries like Provider or Bloc. If the app grows and needs shared state across multiple screens, we can refactor to use Provider or another solution later.

## Dependencies

- dio: API calls
- shared_preferences: Local storage
