import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/models/directory_model.dart';
import 'package:kcards/data/repositories/interfaces/i_directory_repository.dart';

class LocalDirectoryRepository implements IDirectoryRepository {
  const LocalDirectoryRepository(this._db);

  final AppDatabase _db;
  DirectoryDao get _dao => _db.directoryDao;

  @override
  Stream<List<DirectoryModel>> watchChildren(String? parentId) =>
      _dao.watchByParent(parentId).map(
            (entries) => entries.map(_toModel).toList(),
          );

  @override
  Future<DirectoryModel?> getById(String id) async {
    final entry = await _dao.getById(id);
    return entry != null ? _toModel(entry) : null;
  }

  @override
  Future<List<DirectoryModel>> getAll() async {
    final entries = await _dao.getAll();
    return entries.map(_toModel).toList();
  }

  @override
  Future<DirectoryModel> create({
    required String name,
    String? parentId,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await _dao.insertDirectory(
      DirectoriesCompanion.insert(
        id: id,
        name: name,
        parentId: Value(parentId),
        createdAt: now,
      ),
    );
    return DirectoryModel(id: id, name: name, parentId: parentId, createdAt: now);
  }

  @override
  Future<void> rename(String id, String newName) async {
    final entry = await _dao.getById(id);
    if (entry == null) return;
    await _dao.updateDirectory(entry.toCompanion(true).copyWith(name: Value(newName)));
  }

  @override
  Future<List<String>> getSubtreeIds(String directoryId) async {
    final all = await _dao.getAll();
    final result = <String>[];
    _collectIds(all, directoryId, result);
    return result;
  }

  @override
  Future<void> deleteSubtree(String directoryId) async {
    final dirIds = await getSubtreeIds(directoryId);

    // Delete question card images (files + rows) and study progress.
    final qCards = await _db.questionCardDao.getByDirectoryIds(dirIds);
    for (final qc in qCards) {
      final imgs = await _db.questionCardDao.getImages(qc.id);
      for (final img in imgs) {
        final f = io.File(img.imagePath);
        if (f.existsSync()) f.deleteSync();
      }
      await _db.questionCardDao.deleteAllImagesForCard(qc.id);
      await _db.studyProgressDao.deleteByQuestionCard(qc.id);
    }
    await _db.questionCardDao.deleteByDirectoryIds(dirIds);

    // Delete knowledge card images (files + rows).
    final kCards = await _db.knowledgeCardDao.getByDirectoryIds(dirIds);
    for (final kc in kCards) {
      final imgs = await _db.knowledgeCardDao.getImages(kc.id);
      for (final img in imgs) {
        final f = io.File(img.imagePath);
        if (f.existsSync()) f.deleteSync();
      }
      await _db.knowledgeCardDao.deleteAllImagesForCard(kc.id);
    }
    await _db.knowledgeCardDao.deleteByDirectoryIds(dirIds);

    for (final id in dirIds.reversed) {
      await _dao.deleteById(id);
    }
  }

  void _collectIds(List<DirectoryEntry> all, String parentId, List<String> out) {
    out.add(parentId);
    for (final dir in all) {
      if (dir.parentId == parentId) _collectIds(all, dir.id, out);
    }
  }

  DirectoryModel _toModel(DirectoryEntry e) => DirectoryModel(
        id: e.id,
        name: e.name,
        parentId: e.parentId,
        createdAt: e.createdAt,
      );
}
