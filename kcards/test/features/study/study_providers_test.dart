import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/data/models/card_image_model.dart';
import 'package:kcards/data/models/directory_model.dart';
import 'package:kcards/data/models/question_card_model.dart';
import 'package:kcards/data/repositories/interfaces/i_directory_repository.dart';
import 'package:kcards/data/repositories/interfaces/i_question_card_repository.dart';
import 'package:kcards/features/study/study_providers.dart';
import 'package:kcards/shared/providers/database_provider.dart';

class _FakeDirectoryRepository implements IDirectoryRepository {
  _FakeDirectoryRepository(this._subtreeByDirectoryId);

  final Map<String, List<String>> _subtreeByDirectoryId;
  int getSubtreeIdsCallCount = 0;
  final List<String> getSubtreeIdsArgs = <String>[];

  @override
  Future<List<String>> getSubtreeIds(String directoryId) async {
    getSubtreeIdsCallCount += 1;
    getSubtreeIdsArgs.add(directoryId);
    return _subtreeByDirectoryId[directoryId] ?? <String>[directoryId];
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
  Future<DirectoryModel?> getById(String id) {
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

class _FakeQuestionCardRepository implements IQuestionCardRepository {
  _FakeQuestionCardRepository(this._cardsByDirectoryId);

  final Map<String, List<QuestionCardModel>> _cardsByDirectoryId;
  int getByDirectoryIdsCallCount = 0;
  final List<List<String>> getByDirectoryIdsArgs = <List<String>>[];

  @override
  Future<List<QuestionCardModel>> getByDirectoryIds(List<String> dirIds) async {
    getByDirectoryIdsCallCount += 1;
    getByDirectoryIdsArgs.add(List<String>.from(dirIds));
    return dirIds
        .expand((id) => _cardsByDirectoryId[id] ?? const <QuestionCardModel>[])
        .toList();
  }

  @override
  Future<CardImageModel> addImage(
    String questionCardId,
    String imagePath,
    int sortOrder,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<QuestionCardModel> create({
    required String directoryId,
    required String knowledgeCardId,
    required String title,
    String questionMd = '',
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<QuestionCardModel?> getById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<CardImageModel>> getImages(String questionCardId) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeImage(CardImageModel image) {
    throw UnimplementedError();
  }

  @override
  Future<void> update(
    String id, {
    String? title,
    String? questionMd,
    String? knowledgeCardId,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<QuestionCardModel>> watchByDirectory(String directoryId) {
    throw UnimplementedError();
  }

  @override
  Stream<List<CardImageModel>> watchImages(String questionCardId) {
    throw UnimplementedError();
  }

  @override
  Stream<List<QuestionCardModel>> watchByKnowledgeCard(String knowledgeCardId) {
    throw UnimplementedError();
  }
}

QuestionCardModel _card({required String id, required String directoryId}) {
  return QuestionCardModel(
    id: id,
    directoryId: directoryId,
    knowledgeCardId: 'kc-$id',
    title: 'Title $id',
    questionMd: 'Question $id',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );
}

ProviderContainer _containerWith(
  _FakeDirectoryRepository directoryRepository,
  _FakeQuestionCardRepository questionCardRepository,
) {
  return ProviderContainer(
    overrides: [
      directoryRepositoryProvider.overrideWith((_) => directoryRepository),
      questionCardRepositoryProvider.overrideWith((_) => questionCardRepository),
    ],
  );
}

void main() {
  group('studyQueueProvider', () {
    test('requests subtree IDs only when subtree=true', () async {
      final directoryRepo = _FakeDirectoryRepository({
        'root': <String>['root', 'child-a', 'child-b'],
      });
      final questionRepo = _FakeQuestionCardRepository({
        'root': <QuestionCardModel>[_card(id: 'q1', directoryId: 'root')],
        'child-a': <QuestionCardModel>[_card(id: 'q2', directoryId: 'child-a')],
        'child-b': <QuestionCardModel>[_card(id: 'q3', directoryId: 'child-b')],
      });

      final subtreeContainer = _containerWith(directoryRepo, questionRepo);
      addTearDown(subtreeContainer.dispose);

      await subtreeContainer.read(
        studyQueueProvider(
          const StudySessionParams(directoryId: 'root', subtree: true),
        ).future,
      );

      expect(directoryRepo.getSubtreeIdsCallCount, 1);
      expect(directoryRepo.getSubtreeIdsArgs, equals(<String>['root']));

      final directoryOnlyContainer = _containerWith(directoryRepo, questionRepo);
      addTearDown(directoryOnlyContainer.dispose);

      await directoryOnlyContainer.read(
        studyQueueProvider(
          const StudySessionParams(directoryId: 'root', subtree: false),
        ).future,
      );

      expect(directoryRepo.getSubtreeIdsCallCount, 1);
    });

    test('directory-only mode uses exactly one directory ID', () async {
      final directoryRepo = _FakeDirectoryRepository({
        'root': <String>['root', 'child-a', 'child-b'],
      });
      final questionRepo = _FakeQuestionCardRepository({
        'root': <QuestionCardModel>[_card(id: 'q1', directoryId: 'root')],
        'child-a': <QuestionCardModel>[_card(id: 'q2', directoryId: 'child-a')],
        'child-b': <QuestionCardModel>[_card(id: 'q3', directoryId: 'child-b')],
      });

      final container = _containerWith(directoryRepo, questionRepo);
      addTearDown(container.dispose);

      await container.read(
        studyQueueProvider(
          const StudySessionParams(directoryId: 'root', subtree: false),
        ).future,
      );

      expect(questionRepo.getByDirectoryIdsCallCount, 1);
      expect(questionRepo.getByDirectoryIdsArgs.single, equals(<String>['root']));
    });

    test('resulting queue includes cards from resolved directories', () async {
      final directoryRepo = _FakeDirectoryRepository({
        'root': <String>['root', 'child-a', 'child-b'],
      });
      final questionRepo = _FakeQuestionCardRepository({
        'root': <QuestionCardModel>[_card(id: 'q1', directoryId: 'root')],
        'child-a': <QuestionCardModel>[_card(id: 'q2', directoryId: 'child-a')],
        'child-b': <QuestionCardModel>[_card(id: 'q3', directoryId: 'child-b')],
        'other': <QuestionCardModel>[_card(id: 'q4', directoryId: 'other')],
      });

      final container = _containerWith(directoryRepo, questionRepo);
      addTearDown(container.dispose);

      final queue = await container.read(
        studyQueueProvider(
          const StudySessionParams(directoryId: 'root', subtree: true),
        ).future,
      );

      final ids = queue.map((card) => card.id).toSet();
      expect(ids, equals(<String>{'q1', 'q2', 'q3'}));
      expect(ids.contains('q4'), isFalse);
    });

    test('queue order is shuffled and not guaranteed stable across runs', () async {
      final directoryRepo = _FakeDirectoryRepository({
        'root': <String>['root'],
      });
      final questionRepo = _FakeQuestionCardRepository({
        'root': <QuestionCardModel>[
          _card(id: 'q1', directoryId: 'root'),
          _card(id: 'q2', directoryId: 'root'),
          _card(id: 'q3', directoryId: 'root'),
          _card(id: 'q4', directoryId: 'root'),
          _card(id: 'q5', directoryId: 'root'),
          _card(id: 'q6', directoryId: 'root'),
        ],
      });

      final observedOrders = <String>{};

      for (var i = 0; i < 12; i++) {
        final container = _containerWith(directoryRepo, questionRepo);
        addTearDown(container.dispose);

        final queue = await container.read(
          studyQueueProvider(
            const StudySessionParams(directoryId: 'root', subtree: false),
          ).future,
        );

        observedOrders.add(queue.map((card) => card.id).join(','));
      }

      expect(observedOrders.length, greaterThan(1));
    });
  });
}
