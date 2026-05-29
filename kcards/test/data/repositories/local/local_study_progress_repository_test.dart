import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kcards/data/database/database.dart';
import 'package:kcards/data/repositories/local/local_study_progress_repository.dart';
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
  late LocalStudyProgressRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = LocalStudyProgressRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('LocalStudyProgressRepository.recordReview', () {
    test('first recordReview creates row with proper counters', () async {
      await repository.recordReview('q-1', correct: true);

      final progress = await db.studyProgressDao.getByQuestionCard('q-1');
      expect(progress, isNotNull);
      expect(progress!.questionCardId, 'q-1');
      expect(progress.timesReviewed, 1);
      expect(progress.timesCorrect, 1);
      expect(progress.timesIncorrect, 0);
      expect(progress.lastReviewedAt, isNotNull);
    });

    test('subsequent recordReview increments totals correctly', () async {
      await db.studyProgressDao.upsert(
        StudyProgressCompanion.insert(
          id: 'sp-1',
          questionCardId: 'q-1',
          timesReviewed: const Value(7),
          timesCorrect: const Value(5),
          timesIncorrect: const Value(2),
          lastReviewedAt: Value(DateTime(2026, 1, 1)),
        ),
      );

      await repository.recordReview('q-1', correct: true);
      await repository.recordReview('q-1', correct: false);

      final progress = await db.studyProgressDao.getByQuestionCard('q-1');
      expect(progress, isNotNull);
      expect(progress!.id, 'sp-1');
      expect(progress.timesReviewed, 9);
      expect(progress.timesCorrect, 6);
      expect(progress.timesIncorrect, 3);
    });

    test('correct true and false affect the right counter', () async {
      await db.studyProgressDao.upsert(
        StudyProgressCompanion.insert(
          id: 'sp-2',
          questionCardId: 'q-2',
          timesReviewed: const Value(10),
          timesCorrect: const Value(4),
          timesIncorrect: const Value(6),
          lastReviewedAt: Value(DateTime(2026, 1, 1)),
        ),
      );

      await repository.recordReview('q-2', correct: true);

      final afterCorrect = await db.studyProgressDao.getByQuestionCard('q-2');
      expect(afterCorrect, isNotNull);
      expect(afterCorrect!.timesReviewed, 11);
      expect(afterCorrect.timesCorrect, 5);
      expect(afterCorrect.timesIncorrect, 6);

      await repository.recordReview('q-2', correct: false);

      final afterIncorrect = await db.studyProgressDao.getByQuestionCard('q-2');
      expect(afterIncorrect, isNotNull);
      expect(afterIncorrect!.timesReviewed, 12);
      expect(afterIncorrect.timesCorrect, 5);
      expect(afterIncorrect.timesIncorrect, 7);
    });

    test('lastReviewedAt gets updated', () async {
      final initialTime = DateTime(2020, 1, 1);
      await db.studyProgressDao.upsert(
        StudyProgressCompanion.insert(
          id: 'sp-3',
          questionCardId: 'q-3',
          timesReviewed: const Value(1),
          timesCorrect: const Value(1),
          timesIncorrect: const Value(0),
          lastReviewedAt: Value(initialTime),
        ),
      );

      await repository.recordReview('q-3', correct: true);

      final firstUpdate = await db.studyProgressDao.getByQuestionCard('q-3');
      expect(firstUpdate, isNotNull);
      final firstEntry = firstUpdate!;
      final firstReviewedAt = firstEntry.lastReviewedAt;
      expect(firstReviewedAt, isNotNull);
      expect(firstReviewedAt!.isAfter(initialTime), isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 2));

      await repository.recordReview('q-3', correct: false);

      final secondUpdate = await db.studyProgressDao.getByQuestionCard('q-3');
      expect(secondUpdate, isNotNull);
      final secondEntry = secondUpdate!;
      final secondReviewedAt = secondEntry.lastReviewedAt;
      expect(secondReviewedAt, isNotNull);
      expect(secondReviewedAt!.isAfter(initialTime), isTrue);
      expect(secondReviewedAt.isBefore(firstReviewedAt), isFalse);
    });
  });
}
