class StudyProgressModel {
  final String id;
  final String questionCardId;
  final int timesReviewed;
  final int timesCorrect;
  final int timesIncorrect;
  final DateTime? lastReviewedAt;

  const StudyProgressModel({
    required this.id,
    required this.questionCardId,
    required this.timesReviewed,
    required this.timesCorrect,
    required this.timesIncorrect,
    this.lastReviewedAt,
  });
}
