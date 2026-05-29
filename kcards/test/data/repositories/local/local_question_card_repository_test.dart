import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/repositories/local/local_question_card_repository.dart';
import 'package:sqlite3/open.dart';

void _configureSqliteForLinuxTests() {
  if (!Platform.isLinux) {
    return;
  }

  open.overrideFor(OperatingSystem.linux, () {
    const candidates = <String>[
      'libsqlite3.so',
      '/usr/lib/x86_64-linux-gnu/libsqlite3.so',
      '/usr/lib/x86_64-linux-gnu/libsqlite3.so.0',
      '/lib/x86_64-linux-gnu/libsqlite3.so.0',
      '/usr/lib64/libsqlite3.so',
      '/usr/lib/libsqlite3.so',
    ];

    for (final candidate in candidates) {
      try {
        return DynamicLibrary.open(candidate);
      } catch (_) {
        // Try next candidate.
      }
    }

    throw ArgumentError(
      "Failed to load sqlite3. Install system sqlite3 dev/runtime package or ensure libsqlite3 is on LD_LIBRARY_PATH.",
    );
  });
}

void main() {
  setUpAll(_configureSqliteForLinuxTests);

  late AppDatabase db;
  late LocalQuestionCardRepository repository;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = LocalQuestionCardRepository(db);

    await db.directoryDao.insertDirectory(
      DirectoriesCompanion.insert(
        id: 'root',
        name: 'Root',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    await db.knowledgeCardDao.insertCard(
      KnowledgeCardsCompanion.insert(
        id: 'k-1',
        directoryId: 'root',
        title: 'Knowledge 1',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    );

    await db.knowledgeCardDao.insertCard(
      KnowledgeCardsCompanion.insert(
        id: 'k-2',
        directoryId: 'root',
        title: 'Knowledge 2',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('LocalQuestionCardRepository create/get/update', () {
    test('supports create/get/update round trip', () async {
      final created = await repository.create(
        directoryId: 'root',
        knowledgeCardId: 'k-1',
        title: 'Initial title',
        questionMd: 'Initial question',
      );

      final fetched = await repository.getById(created.id);
      expect(fetched, isNotNull);
      expect(fetched!.id, created.id);
      expect(fetched.knowledgeCardId, 'k-1');

      await repository.update(
        created.id,
        title: 'Updated title',
        questionMd: 'Updated question',
      );

      final stored = await db.questionCardDao.getById(created.id);
      expect(stored, isNotNull);
      expect(stored!.title, 'Updated title');
      expect(stored.questionMd, 'Updated question');
      expect(stored.directoryId, 'root');
      expect(stored.knowledgeCardId, 'k-1');
    });

    test('update supports changing knowledgeCardId', () async {
      final oldUpdatedAt = DateTime(2020, 1, 1);
      await db.questionCardDao.insertCard(
        QuestionCardsCompanion.insert(
          id: 'q-change-k',
          directoryId: 'root',
          knowledgeCardId: 'k-1',
          title: 'Question card',
          questionMd: const Value('Body'),
          createdAt: DateTime(2020, 1, 1),
          updatedAt: oldUpdatedAt,
        ),
      );

      await repository.update('q-change-k', knowledgeCardId: 'k-2');

      final after = await db.questionCardDao.getById('q-change-k');
      expect(after, isNotNull);
      expect(after!.knowledgeCardId, 'k-2');
      expect(after.title, 'Question card');
      expect(after.questionMd, 'Body');
      expect(after.updatedAt.isAfter(oldUpdatedAt), isTrue);
    });
  });

  group('LocalQuestionCardRepository delete', () {
    test('removes question images, files, and linked study progress', () async {
      final createdAt = DateTime(2026, 1, 1);
      final updatedAt = DateTime(2026, 1, 2);
      await db.questionCardDao.insertCard(
        QuestionCardsCompanion.insert(
          id: 'q-delete',
          directoryId: 'root',
          knowledgeCardId: 'k-1',
          title: 'To delete',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );

      await db.questionCardDao.insertCard(
        QuestionCardsCompanion.insert(
          id: 'q-keep',
          directoryId: 'root',
          knowledgeCardId: 'k-2',
          title: 'Keep',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );

      final tempDir = await Directory.systemTemp.createTemp('qcard-delete-test-');
      addTearDown(() async {
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      final firstPath = '${tempDir.path}/first.png';
      final secondPath = '${tempDir.path}/second.png';
      final keepPath = '${tempDir.path}/keep.png';
      File(firstPath).writeAsStringSync('first');
      File(secondPath).writeAsStringSync('second');
      File(keepPath).writeAsStringSync('keep');

      await db.questionCardDao.insertImage(
        QuestionCardImagesCompanion.insert(
          id: 'qimg-1',
          questionCardId: 'q-delete',
          imagePath: firstPath,
        ),
      );
      await db.questionCardDao.insertImage(
        QuestionCardImagesCompanion.insert(
          id: 'qimg-2',
          questionCardId: 'q-delete',
          imagePath: secondPath,
        ),
      );
      await db.questionCardDao.insertImage(
        QuestionCardImagesCompanion.insert(
          id: 'qimg-keep',
          questionCardId: 'q-keep',
          imagePath: keepPath,
        ),
      );

      await db.studyProgressDao.upsert(
        StudyProgressCompanion.insert(id: 'sp-delete', questionCardId: 'q-delete'),
      );
      await db.studyProgressDao.upsert(
        StudyProgressCompanion.insert(id: 'sp-keep', questionCardId: 'q-keep'),
      );

      await repository.delete('q-delete');

      expect(await db.questionCardDao.getById('q-delete'), isNull);
      expect(await db.questionCardDao.getImages('q-delete'), isEmpty);
      expect(await db.studyProgressDao.getByQuestionCard('q-delete'), isNull);
      expect(File(firstPath).existsSync(), isFalse);
      expect(File(secondPath).existsSync(), isFalse);

      expect(await db.questionCardDao.getById('q-keep'), isNotNull);
      expect(await db.questionCardDao.getImages('q-keep'), isNotEmpty);
      expect(await db.studyProgressDao.getByQuestionCard('q-keep'), isNotNull);
      expect(File(keepPath).existsSync(), isTrue);
    });
  });

  group('LocalQuestionCardRepository image helpers', () {
    test('addImage/getImages/removeImage keep sort order and cleanup', () async {
      final created = await repository.create(
        directoryId: 'root',
        knowledgeCardId: 'k-1',
        title: 'Image ordering question',
      );

      final tempDir = await Directory.systemTemp.createTemp('qcard-images-test-');
      addTearDown(() async {
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      final pathSort2 = '${tempDir.path}/sort2.png';
      final pathSort1 = '${tempDir.path}/sort1.png';
      final pathSort3 = '${tempDir.path}/sort3.png';
      File(pathSort2).writeAsStringSync('two');
      File(pathSort1).writeAsStringSync('one');
      File(pathSort3).writeAsStringSync('three');

      await repository.addImage(created.id, pathSort2, 2);
      final imageSort1 = await repository.addImage(created.id, pathSort1, 1);
      await repository.addImage(created.id, pathSort3, 3);

      final ordered = await repository.getImages(created.id);
      expect(ordered.map((img) => img.sortOrder).toList(), <int>[2, 1, 3]);
      expect(ordered.map((img) => img.imagePath).toList(), <String>[
        pathSort2,
        pathSort1,
        pathSort3,
      ]);

      await repository.removeImage(imageSort1);

      expect(File(pathSort1).existsSync(), isFalse);

      final remaining = await repository.getImages(created.id);
      expect(remaining.map((img) => img.sortOrder).toList(), <int>[2, 3]);
      expect(remaining.map((img) => img.imagePath).toList(), <String>[
        pathSort2,
        pathSort3,
      ]);

      final dbImages = await db.questionCardDao.getImages(created.id);
      expect(dbImages, hasLength(2));
      expect(
        dbImages.map((img) => img.imagePath).toSet(),
        <String>{pathSort2, pathSort3},
      );
    });
  });
}
