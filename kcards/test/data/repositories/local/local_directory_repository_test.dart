import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/repositories/local/local_directory_repository.dart';
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
  late LocalDirectoryRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = LocalDirectoryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('LocalDirectoryRepository.create', () {
    test('stores name, parent relation, and generated ID', () async {
      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'root',
          name: 'Root',
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      final created = await repository.create(name: 'Child', parentId: 'root');
      final stored = await db.directoryDao.getById(created.id);

      expect(created.id, isNotEmpty);
      expect(created.id, isNot('root'));
      expect(created.name, 'Child');
      expect(created.parentId, 'root');

      expect(stored, isNotNull);
      expect(stored!.id, created.id);
      expect(stored.name, 'Child');
      expect(stored.parentId, 'root');
    });
  });

  group('LocalDirectoryRepository.rename', () {
    test('updates existing directory', () async {
      final createdAt = DateTime(2026, 1, 1);

      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'dir-1',
          name: 'Old Name',
          createdAt: createdAt,
        ),
      );

      await repository.rename('dir-1', 'New Name');
      final updated = await db.directoryDao.getById('dir-1');

      expect(updated, isNotNull);
      expect(updated!.name, 'New Name');
      expect(updated.id, 'dir-1');
      expect(updated.createdAt, createdAt);
    });

    test('no-ops for unknown IDs', () async {
      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'dir-1',
          name: 'Existing',
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      await repository.rename('missing-id', 'Should Not Apply');

      final existing = await db.directoryDao.getById('dir-1');
      final missing = await db.directoryDao.getById('missing-id');

      expect(existing, isNotNull);
      expect(existing!.name, 'Existing');
      expect(missing, isNull);
    });
  });

  group('LocalDirectoryRepository.getSubtreeIds', () {
    test('returns root + descendants recursively', () async {
      final createdAt = DateTime(2026, 1, 1);

      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'root',
          name: 'Root',
          createdAt: createdAt,
        ),
      );
      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'a',
          name: 'A',
          parentId: const Value('root'),
          createdAt: createdAt,
        ),
      );
      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'b',
          name: 'B',
          parentId: const Value('root'),
          createdAt: createdAt,
        ),
      );
      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'a1',
          name: 'A1',
          parentId: const Value('a'),
          createdAt: createdAt,
        ),
      );
      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'other',
          name: 'Other',
          createdAt: createdAt,
        ),
      );

      final subtree = await repository.getSubtreeIds('root');

      expect(subtree, unorderedEquals(<String>['root', 'a', 'b', 'a1']));
      expect(subtree.contains('other'), isFalse);
    });
  });

  group('LocalDirectoryRepository.deleteSubtree', () {
    test('removes subtree entities and image files when present', () async {
      final createdAt = DateTime(2026, 1, 1);
      final updatedAt = DateTime(2026, 1, 2);
      final tmpDir = await Directory.systemTemp.createTemp('local-dir-repo-test-');

      final q1ImagePath = '${tmpDir.path}/q1.png';
      final q2ImagePath = '${tmpDir.path}/q2.png';
      final k1ImagePath = '${tmpDir.path}/k1.png';
      final q3ImagePath = '${tmpDir.path}/q3.png';
      final k2ImagePath = '${tmpDir.path}/k2.png';

      File(q1ImagePath).writeAsStringSync('q1');
      File(q2ImagePath).writeAsStringSync('q2');
      File(k1ImagePath).writeAsStringSync('k1');
      File(q3ImagePath).writeAsStringSync('q3');
      File(k2ImagePath).writeAsStringSync('k2');

      addTearDown(() async {
        if (tmpDir.existsSync()) {
          await tmpDir.delete(recursive: true);
        }
      });

      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'root',
          name: 'Root',
          createdAt: createdAt,
        ),
      );
      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'a',
          name: 'A',
          parentId: const Value('root'),
          createdAt: createdAt,
        ),
      );
      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'a1',
          name: 'A1',
          parentId: const Value('a'),
          createdAt: createdAt,
        ),
      );
      await db.directoryDao.insertDirectory(
        DirectoriesCompanion.insert(
          id: 'other',
          name: 'Other',
          createdAt: createdAt,
        ),
      );

      await db.questionCardDao.insertCard(
        QuestionCardsCompanion.insert(
          id: 'q1',
          directoryId: 'a',
          knowledgeCardId: 'k1',
          title: 'Q1',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );
      await db.questionCardDao.insertCard(
        QuestionCardsCompanion.insert(
          id: 'q2',
          directoryId: 'a1',
          knowledgeCardId: 'k1',
          title: 'Q2',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );
      await db.questionCardDao.insertCard(
        QuestionCardsCompanion.insert(
          id: 'q3',
          directoryId: 'other',
          knowledgeCardId: 'k2',
          title: 'Q3',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );

      await db.knowledgeCardDao.insertCard(
        KnowledgeCardsCompanion.insert(
          id: 'k1',
          directoryId: 'a',
          title: 'K1',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );
      await db.knowledgeCardDao.insertCard(
        KnowledgeCardsCompanion.insert(
          id: 'k2',
          directoryId: 'other',
          title: 'K2',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );

      await db.studyProgressDao.upsert(
        StudyProgressCompanion.insert(id: 'sp1', questionCardId: 'q1'),
      );
      await db.studyProgressDao.upsert(
        StudyProgressCompanion.insert(id: 'sp2', questionCardId: 'q2'),
      );
      await db.studyProgressDao.upsert(
        StudyProgressCompanion.insert(id: 'sp3', questionCardId: 'q3'),
      );

      await db.questionCardDao.insertImage(
        QuestionCardImagesCompanion.insert(
          id: 'qimg1',
          questionCardId: 'q1',
          imagePath: q1ImagePath,
        ),
      );
      await db.questionCardDao.insertImage(
        QuestionCardImagesCompanion.insert(
          id: 'qimg2',
          questionCardId: 'q2',
          imagePath: q2ImagePath,
        ),
      );
      await db.questionCardDao.insertImage(
        QuestionCardImagesCompanion.insert(
          id: 'qimg3',
          questionCardId: 'q3',
          imagePath: q3ImagePath,
        ),
      );

      await db.knowledgeCardDao.insertImage(
        KnowledgeCardImagesCompanion.insert(
          id: 'kimg1',
          knowledgeCardId: 'k1',
          imagePath: k1ImagePath,
        ),
      );
      await db.knowledgeCardDao.insertImage(
        KnowledgeCardImagesCompanion.insert(
          id: 'kimg2',
          knowledgeCardId: 'k2',
          imagePath: k2ImagePath,
        ),
      );

      await repository.deleteSubtree('root');

      expect(await db.directoryDao.getById('root'), isNull);
      expect(await db.directoryDao.getById('a'), isNull);
      expect(await db.directoryDao.getById('a1'), isNull);
      expect(await db.directoryDao.getById('other'), isNotNull);

      expect(await db.questionCardDao.getById('q1'), isNull);
      expect(await db.questionCardDao.getById('q2'), isNull);
      expect(await db.questionCardDao.getById('q3'), isNotNull);

      expect(await db.knowledgeCardDao.getById('k1'), isNull);
      expect(await db.knowledgeCardDao.getById('k2'), isNotNull);

      expect(await db.studyProgressDao.getByQuestionCard('q1'), isNull);
      expect(await db.studyProgressDao.getByQuestionCard('q2'), isNull);
      expect(await db.studyProgressDao.getByQuestionCard('q3'), isNotNull);

      expect(await db.questionCardDao.getImages('q1'), isEmpty);
      expect(await db.questionCardDao.getImages('q2'), isEmpty);
      expect(await db.questionCardDao.getImages('q3'), isNotEmpty);

      expect(await db.knowledgeCardDao.getImages('k1'), isEmpty);
      expect(await db.knowledgeCardDao.getImages('k2'), isNotEmpty);

      expect(File(q1ImagePath).existsSync(), isFalse);
      expect(File(q2ImagePath).existsSync(), isFalse);
      expect(File(k1ImagePath).existsSync(), isFalse);

      expect(File(q3ImagePath).existsSync(), isTrue);
      expect(File(k2ImagePath).existsSync(), isTrue);
    });
  });
}