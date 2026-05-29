class QuestionCardModel {
  final String id;
  final String directoryId;
  final String knowledgeCardId;
  final String title;
  final String questionMd;
  final DateTime createdAt;
  final DateTime updatedAt;

  const QuestionCardModel({
    required this.id,
    required this.directoryId,
    required this.knowledgeCardId,
    required this.title,
    required this.questionMd,
    required this.createdAt,
    required this.updatedAt,
  });
}
