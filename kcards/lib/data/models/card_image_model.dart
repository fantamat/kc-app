/// Represents an image attached to either a KnowledgeCard or a QuestionCard.
/// [imagePath] is a local file path when using the local backend, or a
/// Firebase Storage download URL when using the Firebase backend.
class CardImageModel {
  final String id;
  final String cardId;
  final String imagePath;
  final int sortOrder;

  const CardImageModel({
    required this.id,
    required this.cardId,
    required this.imagePath,
    required this.sortOrder,
  });
}
