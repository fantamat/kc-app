part of '../database.dart';

@DriftAccessor(tables: [StudyProgress])
class StudyProgressDao extends DatabaseAccessor<AppDatabase>
    with _$StudyProgressDaoMixin {
  StudyProgressDao(super.db);

  Stream<StudyProgressEntry?> watchByQuestionCard(int questionCardId) =>
      (select(studyProgress)
            ..where((t) => t.questionCardId.equals(questionCardId)))
          .watchSingleOrNull();

  Future<StudyProgressEntry?> getByQuestionCard(int questionCardId) =>
      (select(studyProgress)
            ..where((t) => t.questionCardId.equals(questionCardId)))
          .getSingleOrNull();

  Future<void> upsert(StudyProgressCompanion entry) =>
      into(studyProgress).insertOnConflictUpdate(entry);

  Future<int> deleteByQuestionCard(int questionCardId) =>
      (delete(studyProgress)
            ..where((t) => t.questionCardId.equals(questionCardId)))
          .go();
}
