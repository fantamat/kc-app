# KCards

KCards is a Flutter app for organizing and studying knowledge cards and linked
question cards in a directory tree. It supports local-first usage (guest mode)
and cloud-backed usage when authenticated.

## What the app does

- Manage a tree of directories.
- Create, edit, and delete knowledge cards.
- Create, edit, and delete question cards linked to knowledge cards.
- Attach images to both knowledge cards and question cards.
- Run study sessions for a single directory or an entire subtree.
- Track study progress (review count, correct/incorrect, last reviewed time).
- Export a directory subtree to JSON and import it back.
- Use guest mode locally or sign in/register with Firebase Auth.

## Architecture snapshot

The project follows a layered structure:

- `lib/features`: UI screens and feature-level providers.
- `lib/shared/providers`: dependency wiring and backend selection.
- `lib/data/repositories/interfaces`: repository contracts.
- `lib/data/repositories/local`: local Drift/SQLite implementations.
- `lib/data/repositories/firebase`: Firebase Firestore implementations.
- `lib/data/services`: image storage abstractions (local and Firebase Storage).
- `lib/data/export_import`: JSON subtree serializer for backup/restore.
- `lib/data/database`: Drift schema, DAOs, and app database.

State management uses Riverpod. Navigation uses GoRouter.

## Backend behavior

Repository and image-service providers switch backend automatically:

- Authenticated user: Firebase repositories + Firebase Storage image service.
- Guest or unauthenticated: local Drift repositories + local image service.

This routing logic is centralized in `lib/shared/providers/database_provider.dart`.

## Tech stack

- Flutter (Material 3)
- Riverpod
- GoRouter
- Drift + SQLite
- Firebase Auth
- Cloud Firestore
- Firebase Storage

## Prerequisites

- Flutter SDK compatible with Dart `^3.11.4`
- Android/iOS tooling (depending on target platform)
- Firebase project configuration for cloud features

## Setup

1. Install dependencies:

	```bash
	flutter pub get
	```

2. Ensure Firebase config is present:

	- `lib/firebase_options.dart`
	- Platform-specific Firebase files as required by FlutterFire

3. Run code generation (Drift/Riverpod):

	```bash
	dart run build_runner build --delete-conflicting-outputs
	```

4. Launch the app:

	```bash
	flutter run
	```

## Useful commands

- Run analyzer:

  ```bash
  flutter analyze
  ```

- Run tests:

  ```bash
  flutter test
  ```

- Regenerate code while watching:

  ```bash
  dart run build_runner watch --delete-conflicting-outputs
  ```

## Testing notes

Current tests are minimal. For a recommended high-level unit test scope, see:

- `UNIT_TEST_SCOPE.md`

## Current routes

Key routes configured in `lib/router.dart`:

- `/auth`
- `/`
- `/dir/:dirId`
- `/knowledge-card/new`
- `/knowledge-card/:cardId`
- `/knowledge-card/:cardId/detail`
- `/question-card/new`
- `/question-card/:cardId`
- `/study/session`
- `/study/flip/:questionCardId`
- `/export`
- `/import`
