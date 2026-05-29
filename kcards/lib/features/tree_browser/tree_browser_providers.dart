import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kcards/data/models/directory_model.dart';
import 'package:kcards/data/models/knowledge_card_model.dart';
import 'package:kcards/shared/providers/database_provider.dart';

/// Watches the direct children of [parentId] (null = root).
final childDirsProvider = StreamProvider.autoDispose
    .family<List<DirectoryModel>, String?>((ref, parentId) {
  return ref.watch(directoryRepositoryProvider).watchChildren(parentId);
});

/// Watches all KnowledgeCards inside [dirId].
final dirKnowledgeCardsProvider = StreamProvider.autoDispose
    .family<List<KnowledgeCardModel>, String>((ref, dirId) {
  return ref.watch(knowledgeCardRepositoryProvider).watchByDirectory(dirId);
});

/// Loads the ancestor chain from root down to [dirId] (inclusive).
final breadcrumbProvider = FutureProvider.autoDispose
    .family<List<DirectoryModel>, String?>((ref, dirId) async {
  if (dirId == null) return const [];
  // Watch the repo before any await so Riverpod tracks the dependency.
  final repo = ref.watch(directoryRepositoryProvider);
  final chain = <DirectoryModel>[];
  String? current = dirId;
  while (current != null) {
    final dir = await repo.getById(current);
    if (dir == null) break;
    chain.insert(0, dir);
    current = dir.parentId;
  }
  return chain;
});
