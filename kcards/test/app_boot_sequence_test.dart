import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/app.dart';
import 'package:kcards/shared/providers/auth_providers.dart';

class TestGuestModeNotifier extends StateNotifier<AsyncValue<bool>>
    implements GuestModeNotifier {
  TestGuestModeNotifier(AsyncValue<bool> initialState) : super(initialState);

  @override
  Future<void> setGuestMode(bool enabled) async {
    state = AsyncValue.data(enabled);
  }
}

class FakeFirebaseConnectionHealthChecker
    implements FirebaseConnectionHealthChecker {
  FakeFirebaseConnectionHealthChecker(this._health);

  final FirebaseConnectionHealth _health;

  @override
  Future<FirebaseConnectionHealth> check() async => _health;
}

void main() {
  group('Application boot sequence', () {
    testWidgets(
      'does not show login when unauthenticated and Firebase is unavailable',
      (WidgetTester tester) async {
        final guestNotifier = TestGuestModeNotifier(const AsyncValue.data(false));

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              currentUserProvider.overrideWith(
                (_) => Stream<User?>.value(null),
              ),
              guestModeProvider.overrideWith((_) => guestNotifier),
              firebaseConnectionHealthCheckerProvider.overrideWithValue(
                FakeFirebaseConnectionHealthChecker(
                  FirebaseConnectionHealth.unavailable(
                    detail: 'Timed out while contacting Firebase during startup.',
                  ),
                ),
              ),
            ],
            child: const KCardsApp(),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Firebase connection unavailable'), findsOneWidget);
        expect(
          find.text('Timed out while contacting Firebase during startup.'),
          findsOneWidget,
        );
        expect(find.text('Welcome to KCards'), findsNothing);
      },
    );

    testWidgets(
      'shows login when unauthenticated and Firebase is available',
      (WidgetTester tester) async {
        final guestNotifier = TestGuestModeNotifier(const AsyncValue.data(false));

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              currentUserProvider.overrideWith(
                (_) => Stream<User?>.value(null),
              ),
              guestModeProvider.overrideWith((_) => guestNotifier),
              firebaseConnectionHealthCheckerProvider.overrideWithValue(
                FakeFirebaseConnectionHealthChecker(
                  FirebaseConnectionHealth.available(),
                ),
              ),
            ],
            child: const KCardsApp(),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Welcome to KCards'), findsOneWidget);
        expect(find.text('Firebase connection unavailable'), findsNothing);
      },
    );
  });
}