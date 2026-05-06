import 'package:drift/drift.dart';
import 'package:kcards/data/database/database.dart';

class StudyProgressRepository {
  const StudyProgressRepository(this._db);

  final AppDatabase _db;

  StudyProgressDao get _dao => _db.studyProgressDao;

  Stream<StudyProgressEntry?> watchByQuestionCard(int questionCardId) =>
      _dao.watchByQuestionCard(questionCardId);

  Future<StudyProgressEntry?> getByQuestionCard(int questionCardId) =>
      _dao.getByQuestionCard(questionCardId);

  /// Records one review result and upserts the progress row.
  Future<void> recordReview(
    int questionCardId, {
    required bool correct,
  }) async {
    final existing = await _dao.getByQuestionCard(questionCardId);
    await _dao.upsert(
      StudyProgressCompanion(
        questionCardId: Value(questionCardId),
        timesReviewed: Value((existing?.timesReviewed ?? 0) + 1),
        timesCorrect:
            Value((existing?.timesCorrect ?? 0) + (correct ? 1 : 0)),
        timesIncorrect:
            Value((existing?.timesIncorrect ?? 0) + (correct ? 0 : 1)),
        lastReviewedAt: Value(DateTime.now()),
      ),
    );
  }
}
