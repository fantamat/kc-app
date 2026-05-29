import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/data/models/directory_model.dart';
import 'package:kcards/data/repositories/interfaces/i_directory_repository.dart';
import 'package:kcards/features/tree_browser/tree_browser_providers.dart';
import 'package:kcards/shared/providers/database_provider.dart';

class _FakeDirectoryRepository implements IDirectoryRepository {
  _FakeDirectoryRepository(this._byId);

  final Map<String, DirectoryModel> _byId;
  final List<String> calls = <String>[];

  @override
  Future<DirectoryModel?> getById(String id) async {
    calls.add(id);
    return _byId[id];
  }

  @override
  Future<DirectoryModel> create({required String name, String? parentId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSubtree(String directoryId) {
    throw UnimplementedError();
  }

  @override
  Future<List<DirectoryModel>> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getSubtreeIds(String directoryId) {
    throw UnimplementedError();
  }

  @override
  Future<void> rename(String id, String newName) {
    throw UnimplementedError();
  }

  @override
  Stream<List<DirectoryModel>> watchChildren(String? parentId) {
    throw UnimplementedError();
  }
}

DirectoryModel _dir({
  required String id,
  required String name,
  String? parentId,
}) {
  return DirectoryModel(
    id: id,
    name: name,
    parentId: parentId,
    createdAt: DateTime(2024, 1, 1),
  );
}

void main() {
  group('breadcrumbProvider', () {
    test('builds ancestor chain in root-to-leaf order', () async {
      final root = _dir(id: 'root', name: 'Root');
      final child = _dir(id: 'child', name: 'Child', parentId: 'root');
      final leaf = _dir(id: 'leaf', name: 'Leaf', parentId: 'child');

      final fakeRepo = _FakeDirectoryRepository({
        root.id: root,
        child.id: child,
        leaf.id: leaf,
      });

      final container = ProviderContainer(
        overrides: [
          directoryRepositoryProvider.overrideWith((_) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(breadcrumbProvider('leaf').future);

      expect(result.map((d) => d.id).toList(), equals(['root', 'child', 'leaf']));
    });

    test('returns empty list for null directory input', () async {
      final fakeRepo = _FakeDirectoryRepository({});

      final container = ProviderContainer(
        overrides: [
          directoryRepositoryProvider.overrideWith((_) => fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(breadcrumbProvider(null).future);

      expect(result, isEmpty);
      expect(fakeRepo.calls, isEmpty);
    });
  });
}
