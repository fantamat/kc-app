part of '../database.dart';

@DriftAccessor(tables: [KnowledgeCards, KnowledgeCardImages])
class KnowledgeCardDao extends DatabaseAccessor<AppDatabase>
    with _$KnowledgeCardDaoMixin {
  KnowledgeCardDao(super.db);

  Stream<List<KnowledgeCard>> watchByDirectory(int directoryId) =>
      (select(knowledgeCards)
            ..where((t) => t.directoryId.equals(directoryId))
            ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  Future<List<KnowledgeCard>> getByDirectoryIds(List<int> dirIds) =>
      (select(knowledgeCards)
            ..where((t) => t.directoryId.isIn(dirIds)))
          .get();

  Future<KnowledgeCard?> getById(int id) =>
      (select(knowledgeCards)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertCard(KnowledgeCardsCompanion entry) =>
      into(knowledgeCards).insert(entry);

  Future<bool> updateCard(KnowledgeCardsCompanion entry) =>
      update(knowledgeCards).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(knowledgeCards)..where((t) => t.id.equals(id))).go();

  Future<int> deleteByDirectoryIds(List<int> dirIds) =>
      (delete(knowledgeCards)..where((t) => t.directoryId.isIn(dirIds))).go();

  // ── Images ────────────────────────────────────────────────────────────────

  Stream<List<KnowledgeCardImage>> watchImages(int knowledgeCardId) =>
      (select(knowledgeCardImages)
            ..where((t) => t.knowledgeCardId.equals(knowledgeCardId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<KnowledgeCardImage>> getImages(int knowledgeCardId) =>
      (select(knowledgeCardImages)
            ..where((t) => t.knowledgeCardId.equals(knowledgeCardId)))
          .get();

  Future<int> insertImage(KnowledgeCardImagesCompanion entry) =>
      into(knowledgeCardImages).insert(entry);

  Future<int> deleteImage(int id) =>
      (delete(knowledgeCardImages)..where((t) => t.id.equals(id))).go();

  Future<int> deleteAllImagesForCard(int knowledgeCardId) =>
      (delete(knowledgeCardImages)
            ..where((t) => t.knowledgeCardId.equals(knowledgeCardId)))
          .go();
}
