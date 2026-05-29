import 'package:kcards/data/models/study_progress_model.dart';

abstract interface class IStudyProgressRepository {
  Stream<StudyProgressModel?> watchByQuestionCard(String questionCardId);
  Future<StudyProgressModel?> getByQuestionCard(String questionCardId);
  Future<void> recordReview(String questionCardId, {required bool correct});
}
