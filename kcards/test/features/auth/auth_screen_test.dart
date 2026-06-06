import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/features/auth/auth_screen.dart';
import 'package:kcards/shared/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class TestGuestModeNotifier extends StateNotifier<AsyncValue<bool>>
    implements GuestModeNotifier {
  TestGuestModeNotifier(AsyncValue<bool> initialState) : super(initialState);

  @override
  Future<void> setGuestMode(bool enabled) async {
    state = AsyncValue.data(enabled);
  }
}

void main() {
  group('AuthScreen', () {
    testWidgets(
      'register timeout stops spinner and shows error',
      (WidgetTester tester) async {
        final auth = MockFirebaseAuth();
        final neverCompletes = Completer<UserCredential>();
        final guestNotifier = TestGuestModeNotifier(const AsyncValue.data(false));

        when(
          () => auth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => neverCompletes.future);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              firebaseAuthProvider.overrideWithValue(auth),
              guestModeProvider.overrideWith((_) => guestNotifier),
            ],
            child: const MaterialApp(home: AuthScreen()),
          ),
        );

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextField, 'Email'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextField, 'Password'),
          'password123',
        );

        await tester.tap(find.byType(FilledButton));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump(const Duration(seconds: 21));
        await tester.pumpAndSettle();

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(
          find.text('Sign up timed out. Please check internet and Firebase Auth setup.'),
          findsOneWidget,
        );
        expect(find.byType(FilledButton), findsOneWidget);
      },
    );
  });
}