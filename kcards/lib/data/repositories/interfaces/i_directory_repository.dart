import 'package:kcards/data/models/directory_model.dart';

abstract interface class IDirectoryRepository {
  Stream<List<DirectoryModel>> watchChildren(String? parentId);
  Future<DirectoryModel?> getById(String id);
  Future<List<DirectoryModel>> getAll();
  Future<DirectoryModel> create({required String name, String? parentId});
  Future<void> rename(String id, String newName);
  Future<List<String>> getSubtreeIds(String directoryId);
  Future<void> deleteSubtree(String directoryId);
}
