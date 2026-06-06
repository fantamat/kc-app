import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _guestModeKey = 'guest_mode_enabled';

enum AuthStatus {
  loading,
  authenticated,
  guest,
  unauthenticated,
}

enum AppBootState {
  loading,
  ready,
  requiresLogin,
  offline,
}

final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((_) => FirebaseFirestore.instance);

class FirebaseConnectionHealth {
  const FirebaseConnectionHealth._({
    required this.isAvailable,
    this.detail,
  });

  const FirebaseConnectionHealth.available({String? detail})
    : this._(isAvailable: true, detail: detail);

  const FirebaseConnectionHealth.unavailable({required String detail})
    : this._(isAvailable: false, detail: detail);

  final bool isAvailable;
  final String? detail;
}

abstract class FirebaseConnectionHealthChecker {
  Future<FirebaseConnectionHealth> check();
}

class FirestoreConnectionHealthChecker
    implements FirebaseConnectionHealthChecker {
  FirestoreConnectionHealthChecker(this._firestore);

  static const _probeDocumentPath = '_health/startup';
  static const _timeout = Duration(seconds: 5);

  final FirebaseFirestore _firestore;

  @override
  Future<FirebaseConnectionHealth> check() async {
    try {
      await _firestore
          .doc(_probeDocumentPath)
          .get(const GetOptions(source: Source.server))
          .timeout(_timeout);
      return const FirebaseConnectionHealth.available();
    } on FirebaseException catch (error, stackTrace) {
      if (_isReachableServerResponse(error.code)) {
        return FirebaseConnectionHealth.available(
          detail: 'Firebase responded with ${error.code}.',
        );
      }

      final detail = _describeFirebaseException(error);
      debugPrint('Firebase startup health check failed: $detail\n$stackTrace');
      return FirebaseConnectionHealth.unavailable(detail: detail);
    } on TimeoutException {
      const detail = 'Timed out while contacting Firebase during startup.';
      debugPrint('Firebase startup health check failed: $detail');
      return const FirebaseConnectionHealth.unavailable(detail: detail);
    } catch (error, stackTrace) {
      final detail = 'Unexpected Firebase startup failure: $error';
      debugPrint('Firebase startup health check failed: $detail\n$stackTrace');
      return FirebaseConnectionHealth.unavailable(detail: detail);
    }
  }

  bool _isReachableServerResponse(String code) {
    return switch (code) {
      'permission-denied' || 'unauthenticated' || 'not-found' => true,
      _ => false,
    };
  }

  String _describeFirebaseException(FirebaseException error) {
    final message = error.message;
    return message == null || message.isEmpty
        ? 'Firebase responded with ${error.code}.'
        : 'Firebase responded with ${error.code}: $message';
  }
}

final firebaseConnectionHealthCheckerProvider =
    Provider<FirebaseConnectionHealthChecker>(
      (ref) => FirestoreConnectionHealthChecker(
        ref.watch(firebaseFirestoreProvider),
      ),
    );

final firebaseConnectionHealthProvider = FutureProvider<FirebaseConnectionHealth>(
  (ref) => ref.watch(firebaseConnectionHealthCheckerProvider).check(),
);

final currentUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

class GuestModeNotifier extends StateNotifier<AsyncValue<bool>> {
  GuestModeNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = AsyncValue.data(prefs.getBool(_guestModeKey) ?? false);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setGuestMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestModeKey, enabled);
    state = AsyncValue.data(enabled);
  }
}

final guestModeProvider =
    StateNotifierProvider<GuestModeNotifier, AsyncValue<bool>>(
  (_) => GuestModeNotifier(),
);

final authStatusProvider = Provider<AuthStatus>((ref) {
  final user = ref.watch(currentUserProvider);
  final guest = ref.watch(guestModeProvider);

  if (user.isLoading || guest.isLoading) return AuthStatus.loading;

  final currentUser = user.valueOrNull;
  if (currentUser != null) return AuthStatus.authenticated;

  final isGuest = guest.valueOrNull ?? false;
  if (isGuest) return AuthStatus.guest;

  return AuthStatus.unauthenticated;
});

final appBootStateProvider = Provider<AppBootState>((ref) {
  final authStatus = ref.watch(authStatusProvider);

  switch (authStatus) {
    case AuthStatus.loading:
      return AppBootState.loading;
    case AuthStatus.authenticated:
    case AuthStatus.guest:
      return AppBootState.ready;
    case AuthStatus.unauthenticated:
      final connectionHealth = ref.watch(firebaseConnectionHealthProvider);
      if (connectionHealth.isLoading) {
        return AppBootState.loading;
      }
      if (connectionHealth.hasError) {
        return AppBootState.offline;
      }
      return connectionHealth.valueOrNull?.isAvailable == true
          ? AppBootState.requiresLogin
          : AppBootState.offline;
  }
});
