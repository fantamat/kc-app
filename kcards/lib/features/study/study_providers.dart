import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kcards/data/database/database.dart';
import 'package:kcards/shared/providers/database_provider.dart';

final knowledgeCardByIdProvider =
    FutureProvider.autoDispose.family<KnowledgeCard?, int>((ref, id) =>
        ref.watch(knowledgeCardRepositoryProvider).getById(id));

final knowledgeCardImagesProvider =
    StreamProvider.autoDispose.family<List<KnowledgeCardImage>, int>((ref, id) =>
        ref.watch(knowledgeCardRepositoryProvider).watchImages(id));

final questionCardByIdProvider =
    FutureProvider.autoDispose.family<QuestionCard?, int>((ref, id) =>
        ref.watch(questionCardRepositoryProvider).getById(id));

final questionCardImagesProvider =
    StreamProvider.autoDispose.family<List<QuestionCardImage>, int>((ref, id) =>
        ref.watch(questionCardRepositoryProvider).watchImages(id));

/// All QuestionCards linked to a given KnowledgeCard (reactive).
final linkedQuestionCardsProvider =
    StreamProvider.autoDispose.family<List<QuestionCard>, int>(
  (ref, knowledgeCardId) => ref
      .watch(questionCardRepositoryProvider)
      .watchByKnowledgeCard(knowledgeCardId),
);

/// StudyProgress for a given QuestionCard (reactive stream).
final studyProgressByQCProvider =
    StreamProvider.autoDispose.family<StudyProgressEntry?, int>(
  (ref, questionCardId) => ref
      .watch(studyProgressRepositoryProvider)
      .watchByQuestionCard(questionCardId),
);

/// Parameters that identify a study session.
class StudySessionParams {
  final int directoryId;
  final bool subtree;

  const StudySessionParams({
    required this.directoryId,
    required this.subtree,
  });

  @override
  bool operator ==(Object other) =>
      other is StudySessionParams &&
      other.directoryId == directoryId &&
      other.subtree == subtree;

  @override
  int get hashCode => Object.hash(directoryId, subtree);
}

/// Loads all QuestionCards for the directory (or subtree), pre-shuffled.
final studyQueueProvider = FutureProvider.autoDispose
    .family<List<QuestionCard>, StudySessionParams>((ref, params) async {
  final dirRepo = ref.watch(directoryRepositoryProvider);
  final qRepo = ref.watch(questionCardRepositoryProvider);

  final List<int> dirIds;
  if (params.subtree) {
    dirIds = await dirRepo.getSubtreeIds(params.directoryId);
  } else {
    dirIds = [params.directoryId];
  }

  final cards = List<QuestionCard>.from(await qRepo.getByDirectoryIds(dirIds));
  cards.shuffle(Random());
  return cards;
});
