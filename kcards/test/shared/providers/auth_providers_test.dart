import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/shared/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

class TestGuestModeNotifier extends StateNotifier<AsyncValue<bool>>
    implements GuestModeNotifier {
  TestGuestModeNotifier(AsyncValue<bool> initialState) : super(initialState);

  @override
  Future<void> setGuestMode(bool enabled) async {
    state = AsyncValue.data(enabled);
  }
}

void main() {
  group('authStatusProvider', () {
    test('is loading when auth state is loading', () {
      final userController = StreamController<User?>();
      final guestNotifier = TestGuestModeNotifier(const AsyncValue.data(false));

      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWith((_) => userController.stream),
          guestModeProvider.overrideWith((_) => guestNotifier),
        ],
      );

      addTearDown(() async {
        await userController.close();
        container.dispose();
      });

      expect(container.read(authStatusProvider), AuthStatus.loading);
    });

    test('is loading when guest mode is loading', () async {
      final guestNotifier = TestGuestModeNotifier(const AsyncValue.loading());

      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWith((_) => Stream<User?>.value(null)),
          guestModeProvider.overrideWith((_) => guestNotifier),
        ],
      );

      addTearDown(() {
        container.dispose();
      });

      await container.read(currentUserProvider.future);

      expect(container.read(authStatusProvider), AuthStatus.loading);
    });

    test('is authenticated when user exists', () async {
      final user = MockUser();
      final guestNotifier = TestGuestModeNotifier(const AsyncValue.data(false));

      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWith((_) => Stream<User?>.value(user)),
          guestModeProvider.overrideWith((_) => guestNotifier),
        ],
      );

      addTearDown(() {
        container.dispose();
      });

      await container.read(currentUserProvider.future);

      expect(container.read(authStatusProvider), AuthStatus.authenticated);
    });

    test('is guest when no user and guest mode is enabled', () async {
      final guestNotifier = TestGuestModeNotifier(const AsyncValue.data(true));

      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWith((_) => Stream<User?>.value(null)),
          guestModeProvider.overrideWith((_) => guestNotifier),
        ],
      );

      addTearDown(() {
        container.dispose();
      });

      await container.read(currentUserProvider.future);

      expect(container.read(authStatusProvider), AuthStatus.guest);
    });

    test('is unauthenticated when no user and guest mode is disabled', () async {
      final guestNotifier = TestGuestModeNotifier(const AsyncValue.data(false));

      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWith((_) => Stream<User?>.value(null)),
          guestModeProvider.overrideWith((_) => guestNotifier),
        ],
      );

      addTearDown(() {
        container.dispose();
      });

      await container.read(currentUserProvider.future);

      expect(container.read(authStatusProvider), AuthStatus.unauthenticated);
    });
  });
}
