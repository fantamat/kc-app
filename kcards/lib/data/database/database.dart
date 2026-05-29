import 'dart:io' as io;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';
part 'daos/directory_dao.dart';
part 'daos/knowledge_card_dao.dart';
part 'daos/question_card_dao.dart';
part 'daos/study_progress_dao.dart';

@DriftDatabase(
  tables: [
    Directories,
    KnowledgeCards,
    KnowledgeCardImages,
    QuestionCards,
    QuestionCardImages,
    StudyProgress,
  ],
  daos: [
    DirectoryDao,
    KnowledgeCardDao,
    QuestionCardDao,
    StudyProgressDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For unit tests — inject an in-memory connection.
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v5: Primary keys changed from int to String (UUID).
          // Drop all tables and recreate (no data migration required).
          await customStatement(
              'DROP TABLE IF EXISTS study_progress');
          await customStatement(
              'DROP TABLE IF EXISTS question_card_images');
          await customStatement(
              'DROP TABLE IF EXISTS question_cards');
          await customStatement(
              'DROP TABLE IF EXISTS knowledge_card_images');
          await customStatement(
              'DROP TABLE IF EXISTS knowledge_cards');
          await customStatement(
              'DROP TABLE IF EXISTS directories');
          await m.createAll();
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = io.File(p.join(dbFolder.path, 'kcards.db'));
    return NativeDatabase.createInBackground(file);
  });
}
