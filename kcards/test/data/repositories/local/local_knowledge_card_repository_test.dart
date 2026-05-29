import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/repositories/local/local_knowledge_card_repository.dart';
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
  late LocalKnowledgeCardRepository repository;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = LocalKnowledgeCardRepository(db);

    await db.directoryDao.insertDirectory(
      DirectoriesCompanion.insert(
        id: 'root',
        name: 'Root',
        createdAt: DateTime(2026, 1, 1),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('LocalKnowledgeCardRepository create/get/update', () {
    test('supports create/get/update round trip', () async {
      final created = await repository.create(
        directoryId: 'root',
        title: 'Initial title',
        contentMd: 'Initial body',
      );

      final fetched = await repository.getById(created.id);
      expect(fetched, isNotNull);
      expect(fetched!.id, created.id);

      await repository.update(
        created.id,
        title: 'Updated title',
        contentMd: 'Updated body',
      );

      final stored = await db.knowledgeCardDao.getById(created.id);
      expect(stored, isNotNull);
      expect(stored!.title, 'Updated title');
      expect(stored.contentMd, 'Updated body');
      expect(stored.directoryId, 'root');
    });

    test('update refreshes updatedAt', () async {
      final oldUpdatedAt = DateTime(2020, 1, 1);
      await db.knowledgeCardDao.insertCard(
        KnowledgeCardsCompanion.insert(
          id: 'k-updated-at',
          directoryId: 'root',
          title: 'Card',
          updatedAt: oldUpdatedAt,
          createdAt: DateTime(2020, 1, 1),
        ),
      );

      await repository.update('k-updated-at', title: 'Card updated');

      final after = await db.knowledgeCardDao.getById('k-updated-at');
      expect(after, isNotNull);
      expect(after!.updatedAt.isAfter(oldUpdatedAt), isTrue);
    });
  });

  group('LocalKnowledgeCardRepository delete', () {
    test('throws when linked question cards exist', () async {
      final created = await repository.create(
        directoryId: 'root',
        title: 'Card with linked question',
      );

      await db.questionCardDao.insertCard(
        QuestionCardsCompanion.insert(
          id: 'q-1',
          directoryId: 'root',
          knowledgeCardId: created.id,
          title: 'Linked question',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      );

      await expectLater(
        () => repository.delete(created.id),
        throwsA(isA<StateError>()),
      );

      expect(await db.knowledgeCardDao.getById(created.id), isNotNull);
    });

    test('removes image rows and image files', () async {
      final created = await repository.create(
        directoryId: 'root',
        title: 'Card with images',
      );

      final tempDir = await Directory.systemTemp.createTemp('kcard-delete-test-');
      addTearDown(() async {
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      final firstPath = '${tempDir.path}/first.png';
      final secondPath = '${tempDir.path}/second.png';
      File(firstPath).writeAsStringSync('first');
      File(secondPath).writeAsStringSync('second');

      await repository.addImage(created.id, firstPath, 1);
      await repository.addImage(created.id, secondPath, 2);

      expect(await db.knowledgeCardDao.getImages(created.id), hasLength(2));
      expect(File(firstPath).existsSync(), isTrue);
      expect(File(secondPath).existsSync(), isTrue);

      await repository.delete(created.id);

      expect(await db.knowledgeCardDao.getById(created.id), isNull);
      expect(await db.knowledgeCardDao.getImages(created.id), isEmpty);
      expect(File(firstPath).existsSync(), isFalse);
      expect(File(secondPath).existsSync(), isFalse);
    });
  });

  group('LocalKnowledgeCardRepository image helpers', () {
    test('addImage/getImages/removeImage keep sort order and cleanup', () async {
      final created = await repository.create(
        directoryId: 'root',
        title: 'Image ordering card',
      );

      final tempDir = await Directory.systemTemp.createTemp('kcard-images-test-');
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

      final dbImages = await db.knowledgeCardDao.getImages(created.id);
      expect(dbImages, hasLength(2));
      expect(dbImages.map((img) => img.imagePath).toSet(),
          <String>{pathSort2, pathSort3});
    });
  });
}
