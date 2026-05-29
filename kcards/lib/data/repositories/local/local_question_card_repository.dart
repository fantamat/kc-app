import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/models/card_image_model.dart';
import 'package:kcards/data/models/question_card_model.dart';
import 'package:kcards/data/repositories/interfaces/i_question_card_repository.dart';

class LocalQuestionCardRepository implements IQuestionCardRepository {
  const LocalQuestionCardRepository(this._db);

  final AppDatabase _db;
  QuestionCardDao get _dao => _db.questionCardDao;

  @override
  Stream<List<QuestionCardModel>> watchByDirectory(String directoryId) =>
      _dao.watchByDirectory(directoryId).map(
            (rows) => rows.map(_toModel).toList(),
          );

  @override
  Stream<List<QuestionCardModel>> watchByKnowledgeCard(
          String knowledgeCardId) =>
      _dao.watchByKnowledgeCard(knowledgeCardId).map(
            (rows) => rows.map(_toModel).toList(),
          );

  @override
  Future<QuestionCardModel?> getById(String id) async {
    final row = await _dao.getById(id);
    return row != null ? _toModel(row) : null;
  }

  @override
  Future<List<QuestionCardModel>> getByDirectoryIds(
      List<String> dirIds) async {
    final rows = await _dao.getByDirectoryIds(dirIds);
    return rows.map(_toModel).toList();
  }

  @override
  Future<QuestionCardModel> create({
    required String directoryId,
    required String knowledgeCardId,
    required String title,
    String questionMd = '',
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await _dao.insertCard(
      QuestionCardsCompanion.insert(
        id: id,
        directoryId: directoryId,
        knowledgeCardId: knowledgeCardId,
        title: title,
        questionMd: Value(questionMd),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return QuestionCardModel(
      id: id,
      directoryId: directoryId,
      knowledgeCardId: knowledgeCardId,
      title: title,
      questionMd: questionMd,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> update(
    String id, {
    String? title,
    String? questionMd,
    String? knowledgeCardId,
  }) async {
    final row = await _dao.getById(id);
    if (row == null) return;
    await _dao.updateCard(
      row.toCompanion(true).copyWith(
            title: title != null ? Value(title) : const Value.absent(),
            questionMd:
                questionMd != null ? Value(questionMd) : const Value.absent(),
            knowledgeCardId: knowledgeCardId != null
                ? Value(knowledgeCardId)
                : const Value.absent(),
            updatedAt: Value(DateTime.now()),
          ),
    );
  }

  @override
  Future<void> delete(String id) async {
    final imgs = await _dao.getImages(id);
    for (final img in imgs) {
      final f = io.File(img.imagePath);
      if (f.existsSync()) f.deleteSync();
    }
    await _dao.deleteAllImagesForCard(id);
    await _db.studyProgressDao.deleteByQuestionCard(id);
    await _dao.deleteById(id);
  }

  // ── Images ────────────────────────────────────────────────────────────────

  @override
  Stream<List<CardImageModel>> watchImages(String questionCardId) =>
      _dao.watchImages(questionCardId).map(
            (rows) => rows.map(_toImageModel).toList(),
          );

  @override
  Future<List<CardImageModel>> getImages(String questionCardId) async {
    final rows = await _dao.getImages(questionCardId);
    return rows.map(_toImageModel).toList();
  }

  @override
  Future<CardImageModel> addImage(
    String questionCardId,
    String imagePath,
    int sortOrder,
  ) async {
    final id = const Uuid().v4();
    await _dao.insertImage(
      QuestionCardImagesCompanion.insert(
        id: id,
        questionCardId: questionCardId,
        imagePath: imagePath,
        sortOrder: Value(sortOrder),
      ),
    );
    return CardImageModel(
      id: id,
      cardId: questionCardId,
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

  QuestionCardModel _toModel(QuestionCard r) => QuestionCardModel(
        id: r.id,
        directoryId: r.directoryId,
        knowledgeCardId: r.knowledgeCardId,
        title: r.title,
        questionMd: r.questionMd,
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
      );

  CardImageModel _toImageModel(QuestionCardImage r) => CardImageModel(
        id: r.id,
        cardId: r.questionCardId,
        imagePath: r.imagePath,
        sortOrder: r.sortOrder,
      );
}
