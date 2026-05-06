part of '../database.dart';

@DriftAccessor(tables: [QuestionCards, QuestionCardImages])
class QuestionCardDao extends DatabaseAccessor<AppDatabase>
    with _$QuestionCardDaoMixin {
  QuestionCardDao(super.db);

  Stream<List<QuestionCard>> watchByDirectory(int directoryId) =>
      (select(questionCards)
            ..where((t) => t.directoryId.equals(directoryId)))
          .watch();

  Stream<List<QuestionCard>> watchByKnowledgeCard(int knowledgeCardId) =>
      (select(questionCards)
            ..where((t) => t.knowledgeCardId.equals(knowledgeCardId)))
          .watch();

  Future<List<QuestionCard>> getByDirectoryIds(List<int> dirIds) =>
      (select(questionCards)
            ..where((t) => t.directoryId.isIn(dirIds)))
          .get();

  Future<QuestionCard?> getById(int id) =>
      (select(questionCards)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<bool> hasLinkedCards(int knowledgeCardId) async {
    final rows = await (select(questionCards)
          ..where((t) => t.knowledgeCardId.equals(knowledgeCardId))
          ..limit(1))
        .get();
    return rows.isNotEmpty;
  }

  Future<int> insertCard(QuestionCardsCompanion entry) =>
      into(questionCards).insert(entry);

  Future<bool> updateCard(QuestionCardsCompanion entry) =>
      update(questionCards).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(questionCards)..where((t) => t.id.equals(id))).go();

  Future<int> deleteByDirectoryIds(List<int> dirIds) =>
      (delete(questionCards)..where((t) => t.directoryId.isIn(dirIds))).go();

  // ── Images ────────────────────────────────────────────────────────────────

  Stream<List<QuestionCardImage>> watchImages(int questionCardId) =>
      (select(questionCardImages)
            ..where((t) => t.questionCardId.equals(questionCardId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<QuestionCardImage>> getImages(int questionCardId) =>
      (select(questionCardImages)
            ..where((t) => t.questionCardId.equals(questionCardId)))
          .get();

  Future<int> insertImage(QuestionCardImagesCompanion entry) =>
      into(questionCardImages).insert(entry);

  Future<int> deleteImage(int id) =>
      (delete(questionCardImages)..where((t) => t.id.equals(id))).go();

  Future<int> deleteAllImagesForCard(int questionCardId) =>
      (delete(questionCardImages)
            ..where((t) => t.questionCardId.equals(questionCardId)))
          .go();
}
