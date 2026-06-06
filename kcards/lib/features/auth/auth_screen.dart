import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kcards/shared/providers/auth_providers.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  static const _authTimeout = Duration(seconds: 20);

  late final TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Email and password are required.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final auth = ref.read(firebaseAuthProvider);
    final guestMode = ref.read(guestModeProvider.notifier);
    try {
      if (_tabController.index == 0) {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .timeout(_authTimeout);
      } else {
        await auth
            .createUserWithEmailAndPassword(
              email: email,
              password: password,
            )
            .timeout(_authTimeout);
      }

      // Persisting guest mode should not block auth completion for the user.
      try {
        await guestMode.setGuestMode(false).timeout(const Duration(seconds: 5));
      } on TimeoutException catch (e, st) {
        debugPrint('Guest mode persistence timeout: $e\n$st');
        if (mounted) {
          setState(
            () => _error =
                'Signed in, but saving local session settings timed out.',
          );
        }
      } on Exception catch (e, st) {
        debugPrint('Guest mode persistence failed: $e\n$st');
        // Ignore local preference issues; user auth already succeeded.
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _error = e.message ?? _friendlyAuthError(e.code));
      }
    } on TimeoutException {
      if (mounted) {
        setState(
          () => _error =
              'Sign up timed out. Please check internet and Firebase Auth setup.',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _friendlyAuthError(String code) {
    switch (code) {
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase Auth.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'email-already-in-use':
        return 'This email is already registered. Try signing in instead.';
      default:
        return code;
    }
  }

  Future<void> _continueAsGuest() async {
    await ref.read(guestModeProvider.notifier).setGuestMode(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to KCards'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sign In'),
            Tab(text: 'Register'),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _tabController.index == 0
                                  ? 'Sign In'
                                  : 'Create Account',
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _submitting ? null : _continueAsGuest,
                      child: const Text('Continue without login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
