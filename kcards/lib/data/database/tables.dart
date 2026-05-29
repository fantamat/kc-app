import 'package:drift/drift.dart';

@DataClassName('DirectoryEntry')
class Directories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class KnowledgeCards extends Table {
  TextColumn get id => text()();
  TextColumn get directoryId => text()();
  TextColumn get title => text()();
  TextColumn get contentMd => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class KnowledgeCardImages extends Table {
  TextColumn get id => text()();
  TextColumn get knowledgeCardId => text()();
  TextColumn get imagePath => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class QuestionCards extends Table {
  TextColumn get id => text()();
  TextColumn get directoryId => text()();
  TextColumn get knowledgeCardId => text()();
  TextColumn get title => text()();
  TextColumn get questionMd => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class QuestionCardImages extends Table {
  TextColumn get id => text()();
  TextColumn get questionCardId => text()();
  TextColumn get imagePath => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StudyProgressEntry')
class StudyProgress extends Table {
  TextColumn get id => text()();
  TextColumn get questionCardId => text().unique()();
  IntColumn get timesReviewed => integer().withDefault(const Constant(0))();
  IntColumn get timesCorrect => integer().withDefault(const Constant(0))();
  IntColumn get timesIncorrect => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
