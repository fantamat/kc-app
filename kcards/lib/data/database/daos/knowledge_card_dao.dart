part of '../database.dart';

@DriftAccessor(tables: [KnowledgeCards, KnowledgeCardImages])
class KnowledgeCardDao extends DatabaseAccessor<AppDatabase>
    with _$KnowledgeCardDaoMixin {
  KnowledgeCardDao(super.db);

  Stream<List<KnowledgeCard>> watchByDirectory(String directoryId) =>
      (select(knowledgeCards)
            ..where((t) => t.directoryId.equals(directoryId))
            ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  Future<List<KnowledgeCard>> getByDirectoryIds(List<String> dirIds) =>
      (select(knowledgeCards)
            ..where((t) => t.directoryId.isIn(dirIds)))
          .get();

  Future<KnowledgeCard?> getById(String id) =>
      (select(knowledgeCards)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> insertCard(KnowledgeCardsCompanion entry) =>
      into(knowledgeCards).insert(entry).then((_) {});

  Future<bool> updateCard(KnowledgeCardsCompanion entry) =>
      update(knowledgeCards).replace(entry);

  Future<void> deleteById(String id) =>
      (delete(knowledgeCards)..where((t) => t.id.equals(id))).go().then((_) {});

  Future<void> deleteByDirectoryIds(List<String> dirIds) =>
      (delete(knowledgeCards)..where((t) => t.directoryId.isIn(dirIds)))
          .go()
          .then((_) {});

  Future<bool> hasLinkedQuestionCards(String id) async {
    final rows = await (select(knowledgeCards)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .get();
    return rows.isNotEmpty;
  }

  // ── Images ────────────────────────────────────────────────────────────────

  Stream<List<KnowledgeCardImage>> watchImages(String knowledgeCardId) =>
      (select(knowledgeCardImages)
            ..where((t) => t.knowledgeCardId.equals(knowledgeCardId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<KnowledgeCardImage>> getImages(String knowledgeCardId) =>
      (select(knowledgeCardImages)
            ..where((t) => t.knowledgeCardId.equals(knowledgeCardId)))
          .get();

  Future<void> insertImage(KnowledgeCardImagesCompanion entry) =>
      into(knowledgeCardImages).insert(entry).then((_) {});

  Future<void> deleteImage(String id) =>
      (delete(knowledgeCardImages)..where((t) => t.id.equals(id)))
          .go()
          .then((_) {});

  Future<void> deleteAllImagesForCard(String knowledgeCardId) =>
      (delete(knowledgeCardImages)
            ..where((t) => t.knowledgeCardId.equals(knowledgeCardId)))
          .go()
          .then((_) {});
}
