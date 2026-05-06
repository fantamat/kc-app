import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/repositories/directory_repository.dart';
import 'package:kcards/data/repositories/knowledge_card_repository.dart';
import 'package:kcards/data/repositories/question_card_repository.dart';
import 'package:kcards/data/repositories/study_progress_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final directoryRepositoryProvider = Provider<DirectoryRepository>((ref) {
  return DirectoryRepository(ref.watch(appDatabaseProvider));
});

final knowledgeCardRepositoryProvider =
    Provider<KnowledgeCardRepository>((ref) {
  return KnowledgeCardRepository(ref.watch(appDatabaseProvider));
});

final questionCardRepositoryProvider =
    Provider<QuestionCardRepository>((ref) {
  return QuestionCardRepository(ref.watch(appDatabaseProvider));
});

final studyProgressRepositoryProvider =
    Provider<StudyProgressRepository>((ref) {
  return StudyProgressRepository(ref.watch(appDatabaseProvider));
});
