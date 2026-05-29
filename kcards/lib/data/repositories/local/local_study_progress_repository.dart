import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/models/study_progress_model.dart';
import 'package:kcards/data/repositories/interfaces/i_study_progress_repository.dart';

class LocalStudyProgressRepository implements IStudyProgressRepository {
  const LocalStudyProgressRepository(this._db);

  final AppDatabase _db;
  StudyProgressDao get _dao => _db.studyProgressDao;

  @override
  Stream<StudyProgressModel?> watchByQuestionCard(String questionCardId) =>
      _dao.watchByQuestionCard(questionCardId).map(
            (entry) => entry != null ? _toModel(entry) : null,
          );

  @override
  Future<StudyProgressModel?> getByQuestionCard(String questionCardId) async {
    final entry = await _dao.getByQuestionCard(questionCardId);
    return entry != null ? _toModel(entry) : null;
  }

  @override
  Future<void> recordReview(String questionCardId,
      {required bool correct}) async {
    final existing = await _dao.getByQuestionCard(questionCardId);
    final id = existing?.id ?? const Uuid().v4();
    await _dao.upsert(
      StudyProgressCompanion(
        id: Value(id),
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

  StudyProgressModel _toModel(StudyProgressEntry e) => StudyProgressModel(
        id: e.id,
        questionCardId: e.questionCardId,
        timesReviewed: e.timesReviewed,
        timesCorrect: e.timesCorrect,
        timesIncorrect: e.timesIncorrect,
        lastReviewedAt: e.lastReviewedAt,
      );
}
