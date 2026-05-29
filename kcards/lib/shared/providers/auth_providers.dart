import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _guestModeKey = 'guest_mode_enabled';

enum AuthStatus {
  loading,
  authenticated,
  guest,
  unauthenticated,
}

final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

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
