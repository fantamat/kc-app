part of '../database.dart';

@DriftAccessor(tables: [QuestionCards, QuestionCardImages])
class QuestionCardDao extends DatabaseAccessor<AppDatabase>
    with _$QuestionCardDaoMixin {
  QuestionCardDao(super.db);

  Stream<List<QuestionCard>> watchByDirectory(String directoryId) =>
      (select(questionCards)
            ..where((t) => t.directoryId.equals(directoryId)))
          .watch();

  Stream<List<QuestionCard>> watchByKnowledgeCard(String knowledgeCardId) =>
      (select(questionCards)
            ..where((t) => t.knowledgeCardId.equals(knowledgeCardId)))
          .watch();

  Future<List<QuestionCard>> getByDirectoryIds(List<String> dirIds) =>
      (select(questionCards)
            ..where((t) => t.directoryId.isIn(dirIds)))
          .get();

  Future<QuestionCard?> getById(String id) =>
      (select(questionCards)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<bool> hasLinkedCards(String knowledgeCardId) async {
    final rows = await (select(questionCards)
          ..where((t) => t.knowledgeCardId.equals(knowledgeCardId))
          ..limit(1))
        .get();
    return rows.isNotEmpty;
  }

  Future<void> insertCard(QuestionCardsCompanion entry) =>
      into(questionCards).insert(entry).then((_) {});

  Future<bool> updateCard(QuestionCardsCompanion entry) =>
      update(questionCards).replace(entry);

  Future<void> patchCard(String id, QuestionCardsCompanion changes) =>
      (update(questionCards)..where((t) => t.id.equals(id)))
          .write(changes)
          .then((_) {});

  Future<void> deleteById(String id) =>
      (delete(questionCards)..where((t) => t.id.equals(id))).go().then((_) {});

  Future<void> deleteByDirectoryIds(List<String> dirIds) =>
      (delete(questionCards)..where((t) => t.directoryId.isIn(dirIds)))
          .go()
          .then((_) {});

  // ── Images ────────────────────────────────────────────────────────────────

  Stream<List<QuestionCardImage>> watchImages(String questionCardId) =>
      (select(questionCardImages)
            ..where((t) => t.questionCardId.equals(questionCardId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<QuestionCardImage>> getImages(String questionCardId) =>
      (select(questionCardImages)
            ..where((t) => t.questionCardId.equals(questionCardId)))
          .get();

  Future<void> insertImage(QuestionCardImagesCompanion entry) =>
      into(questionCardImages).insert(entry).then((_) {});

  Future<void> deleteImage(String id) =>
      (delete(questionCardImages)..where((t) => t.id.equals(id)))
          .go()
          .then((_) {});

  Future<void> deleteAllImagesForCard(String questionCardId) =>
      (delete(questionCardImages)
            ..where((t) => t.questionCardId.equals(questionCardId)))
          .go()
          .then((_) {});
}
