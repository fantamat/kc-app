import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/models/card_image_model.dart';
import 'package:kcards/data/models/knowledge_card_model.dart';
import 'package:kcards/data/repositories/interfaces/i_knowledge_card_repository.dart';

class LocalKnowledgeCardRepository implements IKnowledgeCardRepository {
  const LocalKnowledgeCardRepository(this._db);

  final AppDatabase _db;
  KnowledgeCardDao get _dao => _db.knowledgeCardDao;

  @override
  Stream<List<KnowledgeCardModel>> watchByDirectory(String directoryId) =>
      _dao.watchByDirectory(directoryId).map(
            (rows) => rows.map(_toModel).toList(),
          );

  @override
  Future<List<KnowledgeCardModel>> getByDirectory(String directoryId) async {
    final rows = await _dao.getByDirectoryIds([directoryId]);
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<KnowledgeCardModel>> getByDirectoryIds(
      List<String> dirIds) async {
    final rows = await _dao.getByDirectoryIds(dirIds);
    return rows.map(_toModel).toList();
  }

  @override
  Future<KnowledgeCardModel?> getById(String id) async {
    final row = await _dao.getById(id);
    return row != null ? _toModel(row) : null;
  }

  @override
  Future<KnowledgeCardModel> create({
    required String directoryId,
    required String title,
    String contentMd = '',
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await _dao.insertCard(
      KnowledgeCardsCompanion.insert(
        id: id,
        directoryId: directoryId,
        title: title,
        contentMd: Value(contentMd),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return KnowledgeCardModel(
      id: id,
      directoryId: directoryId,
      title: title,
      contentMd: contentMd,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> update(String id, {String? title, String? contentMd}) async {
    final row = await _dao.getById(id);
    if (row == null) return;
    await _dao.updateCard(
      row.toCompanion(true).copyWith(
            title: title != null ? Value(title) : const Value.absent(),
            contentMd:
                contentMd != null ? Value(contentMd) : const Value.absent(),
            updatedAt: Value(DateTime.now()),
          ),
    );
  }

  @override
  Future<void> delete(String id) async {
    if (await hasLinkedQuestionCards(id)) {
      throw StateError(
          'Cannot delete a KnowledgeCard that has linked QuestionCards.');
    }
    final imgs = await _dao.getImages(id);
    for (final img in imgs) {
      final f = io.File(img.imagePath);
      if (f.existsSync()) f.deleteSync();
    }
    await _dao.deleteAllImagesForCard(id);
    await _dao.deleteById(id);
  }

  @override
  Future<bool> hasLinkedQuestionCards(String id) =>
      _db.questionCardDao.hasLinkedCards(id);

  // ── Images ────────────────────────────────────────────────────────────────

  @override
  Stream<List<CardImageModel>> watchImages(String knowledgeCardId) =>
      _dao.watchImages(knowledgeCardId).map(
            (rows) => rows.map(_toImageModel).toList(),
          );

  @override
  Future<List<CardImageModel>> getImages(String knowledgeCardId) async {
    final rows = await _dao.getImages(knowledgeCardId);
    return rows.map(_toImageModel).toList();
  }

  @override
  Future<CardImageModel> addImage(
    String knowledgeCardId,
    String imagePath,
    int sortOrder,
  ) async {
    final id = const Uuid().v4();
    await _dao.insertImage(
      KnowledgeCardImagesCompanion.insert(
        id: id,
        knowledgeCardId: knowledgeCardId,
        imagePath: imagePath,
        sortOrder: Value(sortOrder),
      ),
    );
    return CardImageModel(
      id: id,
      cardId: knowledgeCardId,
      imagePath: imagePath,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<void> removeImage(CardImageModel image) async {
    final f = io.File(image.imagePath);
    if (f.existsSync()) f.deleteSync();
    await _dao.deleteImage(image.id);
  }

  KnowledgeCardModel _toModel(KnowledgeCard r) => KnowledgeCardModel(
        id: r.id,
        directoryId: r.directoryId,
        title: r.title,
        contentMd: r.contentMd,
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
      );

  CardImageModel _toImageModel(KnowledgeCardImage r) => CardImageModel(
        id: r.id,
        cardId: r.knowledgeCardId,
        imagePath: r.imagePath,
        sortOrder: r.sortOrder,
      );
}
