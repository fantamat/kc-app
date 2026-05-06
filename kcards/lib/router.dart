import 'package:go_router/go_router.dart';
import 'package:kcards/features/card_editor/knowledge_card_editor_screen.dart';
import 'package:kcards/features/card_editor/question_card_editor_screen.dart';
import 'package:kcards/features/export_import/export_screen.dart';
import 'package:kcards/features/export_import/import_screen.dart';
import 'package:kcards/features/study/flip_card_screen.dart';
import 'package:kcards/features/study/knowledge_card_detail_screen.dart';
import 'package:kcards/features/study/study_session_screen.dart';
import 'package:kcards/features/tree_browser/tree_browser_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Root browser
    GoRoute(
      path: '/',
      builder: (context, state) => const TreeBrowserScreen(),
    ),
    // Sub-directory browser
    GoRoute(
      path: '/dir/:dirId',
      builder: (context, state) => TreeBrowserScreen(
        directoryId: state.pathParameters['dirId'],
      ),
    ),

    // Knowledge card — new (query param: dirId)
    GoRoute(
      path: '/knowledge-card/new',
      builder: (context, state) => KnowledgeCardEditorScreen(
        directoryId: state.uri.queryParameters['dirId'],
      ),
    ),
    // Knowledge card — edit
    GoRoute(
      path: '/knowledge-card/:cardId',
      builder: (context, state) => KnowledgeCardEditorScreen(
        cardId: state.pathParameters['cardId'],
      ),
    ),
    // Knowledge card — detail / linked question cards
    GoRoute(
      path: '/knowledge-card/:cardId/detail',
      builder: (context, state) => KnowledgeCardDetailScreen(
        cardId: state.pathParameters['cardId']!,
      ),
    ),

    // Question card — new (query params: dirId, knowledgeCardId)
    GoRoute(
      path: '/question-card/new',
      builder: (context, state) => QuestionCardEditorScreen(
        directoryId: state.uri.queryParameters['dirId'],
        knowledgeCardId: state.uri.queryParameters['knowledgeCardId'],
      ),
    ),
    // Question card — edit
    GoRoute(
      path: '/question-card/:cardId',
      builder: (context, state) => QuestionCardEditorScreen(
        cardId: state.pathParameters['cardId'],
      ),
    ),

    // Study session (query params: dirId, subtree=true|false)
    GoRoute(
      path: '/study/session',
      builder: (context, state) => StudySessionScreen(
        directoryId: state.uri.queryParameters['dirId'] ?? '',
        subtree: state.uri.queryParameters['subtree'] == 'true',
      ),
    ),
    // Flip card
    GoRoute(
      path: '/study/flip/:questionCardId',
      builder: (context, state) => FlipCardScreen(
        questionCardId: state.pathParameters['questionCardId']!,
      ),
    ),

    // Export / Import
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
