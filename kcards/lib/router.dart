import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kcards/features/auth/auth_screen.dart';
import 'package:kcards/features/card_editor/knowledge_card_editor_screen.dart';
import 'package:kcards/features/card_editor/question_card_editor_screen.dart';
import 'package:kcards/features/export_import/export_screen.dart';
import 'package:kcards/features/export_import/import_screen.dart';
import 'package:kcards/features/study/flip_card_screen.dart';
import 'package:kcards/features/study/knowledge_card_detail_screen.dart';
import 'package:kcards/features/study/study_session_screen.dart';
import 'package:kcards/features/tree_browser/tree_browser_screen.dart';
import 'package:kcards/shared/providers/auth_providers.dart';

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this.ref) {
    _sub = ref.listen<AuthStatus>(authStatusProvider, (previous, next) {
      notifyListeners();
    });
  }

  final Ref ref;
  late final ProviderSubscription<AuthStatus> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

final routerNotifierProvider = Provider<_RouterNotifier>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authStatusProvider);
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation == '/auth';

      if (authStatus == AuthStatus.loading) {
        return null;
      }
      if (authStatus == AuthStatus.unauthenticated && !isAuthRoute) {
        return '/auth';
      }
      if ((authStatus == AuthStatus.authenticated ||
              authStatus == AuthStatus.guest) &&
          isAuthRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const TreeBrowserScreen(),
      ),
      GoRoute(
        path: '/dir/:dirId',
        builder: (context, state) => TreeBrowserScreen(
          directoryId: state.pathParameters['dirId'],
        ),
      ),
      GoRoute(
        path: '/knowledge-card/new',
        builder: (context, state) => KnowledgeCardEditorScreen(
          directoryId: state.uri.queryParameters['dirId'],
        ),
      ),
      GoRoute(
        path: '/knowledge-card/:cardId',
        builder: (context, state) => KnowledgeCardEditorScreen(
          cardId: state.pathParameters['cardId'],
        ),
      ),
      GoRoute(
        path: '/knowledge-card/:cardId/detail',
        builder: (context, state) => KnowledgeCardDetailScreen(
          cardId: state.pathParameters['cardId']!,
        ),
      ),
      GoRoute(
        path: '/question-card/new',
        builder: (context, state) => QuestionCardEditorScreen(
          directoryId: state.uri.queryParameters['dirId'],
          knowledgeCardId: state.uri.queryParameters['knowledgeCardId'],
        ),
      ),
      GoRoute(
        path: '/question-card/:cardId',
        builder: (context, state) => QuestionCardEditorScreen(
          cardId: state.pathParameters['cardId'],
        ),
      ),
      GoRoute(
        path: '/study/session',
        builder: (context, state) => StudySessionScreen(
          directoryId: state.uri.queryParameters['dirId'] ?? '',
          subtree: state.uri.queryParameters['subtree'] == 'true',
        ),
      ),
      GoRoute(
        path: '/study/flip/:questionCardId',
        builder: (context, state) => FlipCardScreen(
          questionCardId: state.pathParameters['questionCardId']!,
        ),
      ),
      GoRoute(
        path: '/export',
        builder: (context, state) => ExportScreen(
          directoryId: state.uri.queryParameters['dirId'],
        ),
      ),
      GoRoute(
        path: '/import',
        builder: (context, state) => const ImportScreen(),
      ),
    ],
  );
});
