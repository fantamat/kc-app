class KnowledgeCardModel {
  final String id;
  final String directoryId;
  final String title;
  final String contentMd;
  final DateTime createdAt;
  final DateTime updatedAt;

  const KnowledgeCardModel({
    required this.id,
    required this.directoryId,
    required this.title,
    required this.contentMd,
    required this.createdAt,
    required this.updatedAt,
  });
}
