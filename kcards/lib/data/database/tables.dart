import 'package:drift/drift.dart';

@DataClassName('DirectoryEntry')
class Directories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get parentId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class KnowledgeCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get directoryId => integer()();
  TextColumn get title => text()();
  TextColumn get contentMd => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class KnowledgeCardImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get knowledgeCardId => integer()();
  TextColumn get localPath => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class QuestionCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get directoryId => integer()();
  IntColumn get knowledgeCardId => integer()();
  TextColumn get title => text()();
  TextColumn get questionMd => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class QuestionCardImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get questionCardId => integer()();
  TextColumn get localPath => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@DataClassName('StudyProgressEntry')
class StudyProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get questionCardId => integer().unique()();
  IntColumn get timesReviewed => integer().withDefault(const Constant(0))();
  IntColumn get timesCorrect => integer().withDefault(const Constant(0))();
  IntColumn get timesIncorrect => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
}
