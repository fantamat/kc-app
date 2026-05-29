import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kcards/data/models/card_image_model.dart';
import 'package:kcards/data/models/knowledge_card_model.dart';
import 'package:kcards/data/models/question_card_model.dart';
import 'package:kcards/data/models/study_progress_model.dart';
import 'package:kcards/shared/providers/database_provider.dart';

final knowledgeCardByIdProvider =
  FutureProvider.autoDispose.family<KnowledgeCardModel?, String>((ref, id) =>
        ref.watch(knowledgeCardRepositoryProvider).getById(id));

final knowledgeCardImagesProvider =
  StreamProvider.autoDispose.family<List<CardImageModel>, String>((ref, id) =>
        ref.watch(knowledgeCardRepositoryProvider).watchImages(id));

final questionCardByIdProvider =
  FutureProvider.autoDispose.family<QuestionCardModel?, String>((ref, id) =>
        ref.watch(questionCardRepositoryProvider).getById(id));

final questionCardImagesProvider =
  StreamProvider.autoDispose.family<List<CardImageModel>, String>((ref, id) =>
        ref.watch(questionCardRepositoryProvider).watchImages(id));

/// All QuestionCards linked to a given KnowledgeCard (reactive).
final linkedQuestionCardsProvider =
  StreamProvider.autoDispose.family<List<QuestionCardModel>, String>(
  (ref, knowledgeCardId) => ref
      .watch(questionCardRepositoryProvider)
      .watchByKnowledgeCard(knowledgeCardId),
);

/// StudyProgress for a given QuestionCard (reactive stream).
final studyProgressByQCProvider =
  StreamProvider.autoDispose.family<StudyProgressModel?, String>(
  (ref, questionCardId) => ref
      .watch(studyProgressRepositoryProvider)
      .watchByQuestionCard(questionCardId),
);

/// Parameters that identify a study session.
class StudySessionParams {
  final String directoryId;
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
    .family<List<QuestionCardModel>, StudySessionParams>((ref, params) async {
  final dirRepo = ref.watch(directoryRepositoryProvider);
  final qRepo = ref.watch(questionCardRepositoryProvider);

  final List<String> dirIds;
  if (params.subtree) {
    dirIds = await dirRepo.getSubtreeIds(params.directoryId);
  } else {
    dirIds = [params.directoryId];
  }

  final cards =
      List<QuestionCardModel>.from(await qRepo.getByDirectoryIds(dirIds));
  cards.shuffle(Random());
  return cards;
});
