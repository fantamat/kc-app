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
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(questionCards, questionCards.title);
          }
          // v3: title is now required; questionMd has a Dart-side default ''.
          // No SQL schema change needed (SQLite ALTER COLUMN is unsupported).
          if (from < 4) {
            await m.addColumn(
                studyProgress, studyProgress.timesIncorrect);
          }
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
