import 'package:kcards/data/models/card_image_model.dart';
import 'package:kcards/data/models/question_card_model.dart';

abstract interface class IQuestionCardRepository {
  Stream<List<QuestionCardModel>> watchByDirectory(String directoryId);
  Stream<List<QuestionCardModel>> watchByKnowledgeCard(String knowledgeCardId);
  Future<QuestionCardModel?> getById(String id);
  Future<List<QuestionCardModel>> getByDirectoryIds(List<String> dirIds);

  Future<QuestionCardModel> create({
    required String directoryId,
    required String knowledgeCardId,
    required String title,
    String questionMd = '',
  });

  Future<void> update(
    String id, {
    String? title,
    String? questionMd,
    String? knowledgeCardId,
  });

  Future<void> delete(String id);

  // Images
  Stream<List<CardImageModel>> watchImages(String questionCardId);
  Future<List<CardImageModel>> getImages(String questionCardId);
  Future<CardImageModel> addImage(
      String questionCardId, String imagePath, int sortOrder);
  Future<void> removeImage(CardImageModel image);
}
