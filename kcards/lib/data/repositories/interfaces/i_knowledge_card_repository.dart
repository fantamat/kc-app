import 'package:kcards/data/models/card_image_model.dart';
import 'package:kcards/data/models/knowledge_card_model.dart';

abstract interface class IKnowledgeCardRepository {
  Stream<List<KnowledgeCardModel>> watchByDirectory(String directoryId);
  Future<List<KnowledgeCardModel>> getByDirectory(String directoryId);
  Future<List<KnowledgeCardModel>> getByDirectoryIds(List<String> dirIds);
  Future<KnowledgeCardModel?> getById(String id);

  Future<KnowledgeCardModel> create({
    required String directoryId,
    required String title,
    String contentMd = '',
  });

  Future<void> update(String id, {String? title, String? contentMd});
  Future<void> delete(String id);

  // Images
  Stream<List<CardImageModel>> watchImages(String knowledgeCardId);
  Future<List<CardImageModel>> getImages(String knowledgeCardId);
  Future<CardImageModel> addImage(
      String knowledgeCardId, String imagePath, int sortOrder);
  Future<void> removeImage(CardImageModel image);
  Future<bool> hasLinkedQuestionCards(String id);
}
