import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:kcards/data/database/database.dart';

class QuestionCardRepository {
  const QuestionCardRepository(this._db);

  final AppDatabase _db;

  QuestionCardDao get _dao => _db.questionCardDao;

  Stream<List<QuestionCard>> watchByDirectory(int directoryId) =>
      _dao.watchByDirectory(directoryId);

  Stream<List<QuestionCard>> watchByKnowledgeCard(int knowledgeCardId) =>
      _dao.watchByKnowledgeCard(knowledgeCardId);

  Future<QuestionCard?> getById(int id) => _dao.getById(id);

  /// Returns all question cards in [directoryId] and all its subdirectories.
  Future<List<QuestionCard>> getByDirectoryIds(List<int> dirIds) =>
      _dao.getByDirectoryIds(dirIds);

  Future<QuestionCard> create({
    required int directoryId,
    required int knowledgeCardId,
    required String title,
    String questionMd = '',
  }) async {
    final now = DateTime.now();
    final id = await _dao.insertCard(
      QuestionCardsCompanion.insert(
        directoryId: directoryId,
        knowledgeCardId: knowledgeCardId,
        title: title,
        questionMd: Value(questionMd),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (await _dao.getById(id))!;
  }

  Future<void> update(
    int id, {
    String? questionMd,
    String? title,
    int? knowledgeCardId,
  }) async {
    final card = await _dao.getById(id);
    if (card == null) return;
    await _dao.updateCard(
      card.toCompanion(true).copyWith(
            questionMd: questionMd != null
                ? Value(questionMd)
                : const Value.absent(),
            title: title != null ? Value(title) : const Value.absent(),
            knowledgeCardId: knowledgeCardId != null
                ? Value(knowledgeCardId)
                : const Value.absent(),
            updatedAt: Value(DateTime.now()),
          ),
    );
  }

  Future<void> delete(int id) async {
    final imgs = await _dao.getImages(id);
    for (final img in imgs) {
      final f = io.File(img.localPath);
      if (f.existsSync()) f.deleteSync();
    }
    await _dao.deleteAllImagesForCard(id);
    await _db.studyProgressDao.deleteByQuestionCard(id);
    await _dao.deleteById(id);
  }

  // ── Images ────────────────────────────────────────────────────────────────

  Stream<List<QuestionCardImage>> watchImages(int questionCardId) =>
      _dao.watchImages(questionCardId);

  Future<int> addImage(
    int questionCardId,
    String localPath,
    int sortOrder,
  ) =>
      _dao.insertImage(
        QuestionCardImagesCompanion.insert(
          questionCardId: questionCardId,
          localPath: localPath,
          sortOrder: Value(sortOrder),
        ),
      );

  Future<void> removeImage(QuestionCardImage image) async {
    final f = io.File(image.localPath);
    if (f.existsSync()) f.deleteSync();
    await _dao.deleteImage(image.id);
  }
}
