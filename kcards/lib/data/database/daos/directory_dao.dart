part of '../database.dart';

@DriftAccessor(tables: [Directories])
class DirectoryDao extends DatabaseAccessor<AppDatabase>
    with _$DirectoryDaoMixin {
  DirectoryDao(super.db);

  Stream<List<DirectoryEntry>> watchByParent(int? parentId) =>
      (select(directories)
            ..where(
              (t) => parentId == null
                  ? t.parentId.isNull()
                  : t.parentId.equals(parentId),
            ))
          .watch();

  Future<List<DirectoryEntry>> getAll() => select(directories).get();

  Future<DirectoryEntry?> getById(int id) =>
      (select(directories)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertDirectory(DirectoriesCompanion entry) =>
      into(directories).insert(entry);

  Future<bool> updateDirectory(DirectoriesCompanion entry) =>
      update(directories).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(directories)..where((t) => t.id.equals(id))).go();
}
