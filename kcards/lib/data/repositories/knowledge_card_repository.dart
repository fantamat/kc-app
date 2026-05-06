import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:kcards/data/database/database.dart';

class KnowledgeCardRepository {
  const KnowledgeCardRepository(this._db);

  final AppDatabase _db;

  KnowledgeCardDao get _dao => _db.knowledgeCardDao;

  Stream<List<KnowledgeCard>> watchByDirectory(int directoryId) =>
      _dao.watchByDirectory(directoryId);

  Future<List<KnowledgeCard>> getByDirectory(int directoryId) =>
      _dao.getByDirectoryIds([directoryId]);

  Future<KnowledgeCard?> getById(int id) => _dao.getById(id);

  Future<KnowledgeCard> create({
    required int directoryId,
    required String title,
    String contentMd = '',
  }) async {
    final now = DateTime.now();
    final id = await _dao.insertCard(
      KnowledgeCardsCompanion.insert(
        directoryId: directoryId,
        title: title,
        contentMd: Value(contentMd),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (await _dao.getById(id))!;
  }

  Future<void> update(
    int id, {
    String? title,
    String? contentMd,
  }) async {
    final card = await _dao.getById(id);
    if (card == null) return;
    await _dao.updateCard(
      card.toCompanion(true).copyWith(
            title: title != null ? Value(title) : const Value.absent(),
            contentMd:
                contentMd != null ? Value(contentMd) : const Value.absent(),
            updatedAt: Value(DateTime.now()),
          ),
    );
  }

  /// Throws [StateError] if any QuestionCards are linked to [id].
  Future<void> delete(int id) async {
    if (await _db.questionCardDao.hasLinkedCards(id)) {
      throw StateError(
        'Cannot delete a KnowledgeCard that has linked QuestionCards.',
      );
    }
    final imgs = await _dao.getImages(id);
    for (final img in imgs) {
      final f = io.File(img.localPath);
      if (f.existsSync()) f.deleteSync();
    }
    await _dao.deleteAllImagesForCard(id);
    await _dao.deleteById(id);
  }

  // ── Images ────────────────────────────────────────────────────────────────

  Stream<List<KnowledgeCardImage>> watchImages(int knowledgeCardId) =>
      _dao.watchImages(knowledgeCardId);

  Future<int> addImage(
    int knowledgeCardId,
    String localPath,
    int sortOrder,
  ) =>
      _dao.insertImage(
        KnowledgeCardImagesCompanion.insert(
          knowledgeCardId: knowledgeCardId,
          localPath: localPath,
          sortOrder: Value(sortOrder),
        ),
      );

  Future<void> removeImage(KnowledgeCardImage image) async {
    final f = io.File(image.localPath);
    if (f.existsSync()) f.deleteSync();
    await _dao.deleteImage(image.id);
  }
}
