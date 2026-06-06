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
  @override
  Future<FirebaseConnectionHealth> check() async =>
      const FirebaseConnectionHealth.available();
}

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    final guestNotifier = TestGuestModeNotifier(const AsyncValue.data(false));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((_) => Stream<User?>.value(null)),
          guestModeProvider.overrideWith((_) => guestNotifier),
          firebaseConnectionHealthCheckerProvider.overrideWithValue(
            FakeFirebaseConnectionHealthChecker(),
          ),
        ],
        child: const KCardsApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome to KCards'), findsOneWidget);
  });
}
