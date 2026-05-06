import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kcards/data/database/database.dart';
import 'package:kcards/shared/providers/database_provider.dart';

/// Watches the direct children of [parentId] (null = root).
final childDirsProvider = StreamProvider.autoDispose
    .family<List<DirectoryEntry>, int?>((ref, parentId) {
  return ref.watch(directoryRepositoryProvider).watchChildren(parentId);
});

/// Watches all KnowledgeCards inside [dirId].
final dirKnowledgeCardsProvider = StreamProvider.autoDispose
    .family<List<KnowledgeCard>, int>((ref, dirId) {
  return ref.watch(knowledgeCardRepositoryProvider).watchByDirectory(dirId);
});

/// Loads the ancestor chain from root down to [dirId] (inclusive).
final breadcrumbProvider = FutureProvider.autoDispose
    .family<List<DirectoryEntry>, int?>((ref, dirId) async {
  if (dirId == null) return const [];
  // Watch the repo before any await so Riverpod tracks the dependency.
  final repo = ref.watch(directoryRepositoryProvider);
  final chain = <DirectoryEntry>[];
  int? current = dirId;
  while (current != null) {
    final dir = await repo.getById(current);
    if (dir == null) break;
    chain.insert(0, dir);
    current = dir.parentId;
  }
  return chain;
});
