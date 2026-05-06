import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:kcards/data/database/database.dart';

class DirectoryRepository {
  const DirectoryRepository(this._db);

  final AppDatabase _db;

  DirectoryDao get _dao => _db.directoryDao;

  Stream<List<DirectoryEntry>> watchChildren(int? parentId) =>
      _dao.watchByParent(parentId);

  Future<DirectoryEntry?> getById(int id) => _dao.getById(id);

  Future<DirectoryEntry> create({
    required String name,
    int? parentId,
  }) async {
    final id = await _dao.insertDirectory(
      DirectoriesCompanion.insert(
        name: name,
        parentId: Value(parentId),
        createdAt: DateTime.now(),
      ),
    );
    return (await _dao.getById(id))!;
  }

  Future<void> rename(int id, String newName) async {
    final dir = await _dao.getById(id);
    if (dir == null) return;
    await _dao.updateDirectory(
      dir.toCompanion(true).copyWith(name: Value(newName)),
    );
  }

  /// Returns IDs of [directoryId] and ALL its descendants (DFS order).
  Future<List<int>> getSubtreeIds(int directoryId) async {
    final all = await _dao.getAll();
    final result = <int>[];
    _collectIds(all, directoryId, result);
    return result;
  }

  /// Deletes [directoryId] and all descendant content (cascades images/cards).
  Future<void> deleteSubtree(int directoryId) async {
    final dirIds = await getSubtreeIds(directoryId);

    // Delete question card images (files + rows) and study progress.
    final qCards = await _db.questionCardDao.getByDirectoryIds(dirIds);
    for (final qc in qCards) {
      final imgs = await _db.questionCardDao.getImages(qc.id);
      for (final img in imgs) {
        final f = io.File(img.localPath);
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
        final f = io.File(img.localPath);
        if (f.existsSync()) f.deleteSync();
      }
      await _db.knowledgeCardDao.deleteAllImagesForCard(kc.id);
    }
    await _db.knowledgeCardDao.deleteByDirectoryIds(dirIds);

    // Delete directories leaf-first.
    for (final id in dirIds.reversed) {
      await _dao.deleteById(id);
    }
  }

  void _collectIds(
    List<DirectoryEntry> all,
    int parentId,
    List<int> out,
  ) {
    out.add(parentId);
    for (final dir in all) {
      if (dir.parentId == parentId) _collectIds(all, dir.id, out);
    }
  }
}
