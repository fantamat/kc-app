// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DirectoriesTable extends Directories
    with TableInfo<$DirectoriesTable, DirectoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DirectoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, parentId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'directories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DirectoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DirectoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DirectoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DirectoriesTable createAlias(String alias) {
    return $DirectoriesTable(attachedDatabase, alias);
  }
}

class DirectoryEntry extends DataClass implements Insertable<DirectoryEntry> {
  final int id;
  final String name;
  final int? parentId;
  final DateTime createdAt;
  const DirectoryEntry({
    required this.id,
    required this.name,
    this.parentId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DirectoriesCompanion toCompanion(bool nullToAbsent) {
    return DirectoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      createdAt: Value(createdAt),
    );
  }

  factory DirectoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DirectoryEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<int?>(parentId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DirectoryEntry copyWith({
    int? id,
    String? name,
    Value<int?> parentId = const Value.absent(),
    DateTime? createdAt,
  }) => DirectoryEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    createdAt: createdAt ?? this.createdAt,
  );
  DirectoryEntry copyWithCompanion(DirectoriesCompanion data) {
    return DirectoryEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DirectoryEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DirectoryEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.createdAt == this.createdAt);
}

class DirectoriesCompanion extends UpdateCompanion<DirectoryEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> parentId;
  final Value<DateTime> createdAt;
  const DirectoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DirectoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<DirectoryEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? parentId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DirectoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? parentId,
    Value<DateTime>? createdAt,
  }) {
    return DirectoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DirectoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeCardsTable extends KnowledgeCards
    with TableInfo<$KnowledgeCardsTable, KnowledgeCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _directoryIdMeta = const VerificationMeta(
    'directoryId',
  );
  @override
  late final GeneratedColumn<int> directoryId = GeneratedColumn<int>(
    'directory_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMdMeta = const VerificationMeta(
    'contentMd',
  );
  @override
  late final GeneratedColumn<String> contentMd = GeneratedColumn<String>(
    'content_md',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    directoryId,
    title,
    contentMd,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('directory_id')) {
      context.handle(
        _directoryIdMeta,
        directoryId.isAcceptableOrUnknown(
          data['directory_id']!,
          _directoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_directoryIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_md')) {
      context.handle(
        _contentMdMeta,
        contentMd.isAcceptableOrUnknown(data['content_md']!, _contentMdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      directoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}directory_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      contentMd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_md'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KnowledgeCardsTable createAlias(String alias) {
    return $KnowledgeCardsTable(attachedDatabase, alias);
  }
}

class KnowledgeCard extends DataClass implements Insertable<KnowledgeCard> {
  final int id;
  final int directoryId;
  final String title;
  final String contentMd;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KnowledgeCard({
    required this.id,
    required this.directoryId,
    required this.title,
    required this.contentMd,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['directory_id'] = Variable<int>(directoryId);
    map['title'] = Variable<String>(title);
    map['content_md'] = Variable<String>(contentMd);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KnowledgeCardsCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeCardsCompanion(
      id: Value(id),
      directoryId: Value(directoryId),
      title: Value(title),
      contentMd: Value(contentMd),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KnowledgeCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeCard(
      id: serializer.fromJson<int>(json['id']),
      directoryId: serializer.fromJson<int>(json['directoryId']),
      title: serializer.fromJson<String>(json['title']),
      contentMd: serializer.fromJson<String>(json['contentMd']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'directoryId': serializer.toJson<int>(directoryId),
      'title': serializer.toJson<String>(title),
      'contentMd': serializer.toJson<String>(contentMd),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KnowledgeCard copyWith({
    int? id,
    int? directoryId,
    String? title,
    String? contentMd,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KnowledgeCard(
    id: id ?? this.id,
    directoryId: directoryId ?? this.directoryId,
    title: title ?? this.title,
    contentMd: contentMd ?? this.contentMd,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KnowledgeCard copyWithCompanion(KnowledgeCardsCompanion data) {
    return KnowledgeCard(
      id: data.id.present ? data.id.value : this.id,
      directoryId: data.directoryId.present
          ? data.directoryId.value
          : this.directoryId,
      title: data.title.present ? data.title.value : this.title,
      contentMd: data.contentMd.present ? data.contentMd.value : this.contentMd,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeCard(')
          ..write('id: $id, ')
          ..write('directoryId: $directoryId, ')
          ..write('title: $title, ')
          ..write('contentMd: $contentMd, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, directoryId, title, contentMd, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeCard &&
          other.id == this.id &&
          other.directoryId == this.directoryId &&
          other.title == this.title &&
          other.contentMd == this.contentMd &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KnowledgeCardsCompanion extends UpdateCompanion<KnowledgeCard> {
  final Value<int> id;
  final Value<int> directoryId;
  final Value<String> title;
  final Value<String> contentMd;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const KnowledgeCardsCompanion({
    this.id = const Value.absent(),
    this.directoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.contentMd = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  KnowledgeCardsCompanion.insert({
    this.id = const Value.absent(),
    required int directoryId,
    required String title,
    this.contentMd = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : directoryId = Value(directoryId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<KnowledgeCard> custom({
    Expression<int>? id,
    Expression<int>? directoryId,
    Expression<String>? title,
    Expression<String>? contentMd,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (directoryId != null) 'directory_id': directoryId,
      if (title != null) 'title': title,
      if (contentMd != null) 'content_md': contentMd,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  KnowledgeCardsCompanion copyWith({
    Value<int>? id,
    Value<int>? directoryId,
    Value<String>? title,
    Value<String>? contentMd,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return KnowledgeCardsCompanion(
      id: id ?? this.id,
      directoryId: directoryId ?? this.directoryId,
      title: title ?? this.title,
      contentMd: contentMd ?? this.contentMd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (directoryId.present) {
      map['directory_id'] = Variable<int>(directoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentMd.present) {
      map['content_md'] = Variable<String>(contentMd.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeCardsCompanion(')
          ..write('id: $id, ')
          ..write('directoryId: $directoryId, ')
          ..write('title: $title, ')
          ..write('contentMd: $contentMd, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeCardImagesTable extends KnowledgeCardImages
    with TableInfo<$KnowledgeCardImagesTable, KnowledgeCardImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeCardImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _knowledgeCardIdMeta = const VerificationMeta(
    'knowledgeCardId',
  );
  @override
  late final GeneratedColumn<int> knowledgeCardId = GeneratedColumn<int>(
    'knowledge_card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    knowledgeCardId,
    localPath,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_card_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnowledgeCardImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('knowledge_card_id')) {
      context.handle(
        _knowledgeCardIdMeta,
        knowledgeCardId.isAcceptableOrUnknown(
          data['knowledge_card_id']!,
          _knowledgeCardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_knowledgeCardIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeCardImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeCardImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      knowledgeCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}knowledge_card_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $KnowledgeCardImagesTable createAlias(String alias) {
    return $KnowledgeCardImagesTable(attachedDatabase, alias);
  }
}

class KnowledgeCardImage extends DataClass
    implements Insertable<KnowledgeCardImage> {
  final int id;
  final int knowledgeCardId;
  final String localPath;
  final int sortOrder;
  const KnowledgeCardImage({
    required this.id,
    required this.knowledgeCardId,
    required this.localPath,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['knowledge_card_id'] = Variable<int>(knowledgeCardId);
    map['local_path'] = Variable<String>(localPath);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  KnowledgeCardImagesCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeCardImagesCompanion(
      id: Value(id),
      knowledgeCardId: Value(knowledgeCardId),
      localPath: Value(localPath),
      sortOrder: Value(sortOrder),
    );
  }

  factory KnowledgeCardImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeCardImage(
      id: serializer.fromJson<int>(json['id']),
      knowledgeCardId: serializer.fromJson<int>(json['knowledgeCardId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'knowledgeCardId': serializer.toJson<int>(knowledgeCardId),
      'localPath': serializer.toJson<String>(localPath),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  KnowledgeCardImage copyWith({
    int? id,
    int? knowledgeCardId,
    String? localPath,
    int? sortOrder,
  }) => KnowledgeCardImage(
    id: id ?? this.id,
    knowledgeCardId: knowledgeCardId ?? this.knowledgeCardId,
    localPath: localPath ?? this.localPath,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  KnowledgeCardImage copyWithCompanion(KnowledgeCardImagesCompanion data) {
    return KnowledgeCardImage(
      id: data.id.present ? data.id.value : this.id,
      knowledgeCardId: data.knowledgeCardId.present
          ? data.knowledgeCardId.value
          : this.knowledgeCardId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeCardImage(')
          ..write('id: $id, ')
          ..write('knowledgeCardId: $knowledgeCardId, ')
          ..write('localPath: $localPath, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, knowledgeCardId, localPath, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeCardImage &&
          other.id == this.id &&
          other.knowledgeCardId == this.knowledgeCardId &&
          other.localPath == this.localPath &&
          other.sortOrder == this.sortOrder);
}

class KnowledgeCardImagesCompanion extends UpdateCompanion<KnowledgeCardImage> {
  final Value<int> id;
  final Value<int> knowledgeCardId;
  final Value<String> localPath;
  final Value<int> sortOrder;
  const KnowledgeCardImagesCompanion({
    this.id = const Value.absent(),
    this.knowledgeCardId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  KnowledgeCardImagesCompanion.insert({
    this.id = const Value.absent(),
    required int knowledgeCardId,
    required String localPath,
    this.sortOrder = const Value.absent(),
  }) : knowledgeCardId = Value(knowledgeCardId),
       localPath = Value(localPath);
  static Insertable<KnowledgeCardImage> custom({
    Expression<int>? id,
    Expression<int>? knowledgeCardId,
    Expression<String>? localPath,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (knowledgeCardId != null) 'knowledge_card_id': knowledgeCardId,
      if (localPath != null) 'local_path': localPath,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  KnowledgeCardImagesCompanion copyWith({
    Value<int>? id,
    Value<int>? knowledgeCardId,
    Value<String>? localPath,
    Value<int>? sortOrder,
  }) {
    return KnowledgeCardImagesCompanion(
      id: id ?? this.id,
      knowledgeCardId: knowledgeCardId ?? this.knowledgeCardId,
      localPath: localPath ?? this.localPath,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (knowledgeCardId.present) {
      map['knowledge_card_id'] = Variable<int>(knowledgeCardId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeCardImagesCompanion(')
          ..write('id: $id, ')
          ..write('knowledgeCardId: $knowledgeCardId, ')
          ..write('localPath: $localPath, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $QuestionCardsTable extends QuestionCards
    with TableInfo<$QuestionCardsTable, QuestionCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _directoryIdMeta = const VerificationMeta(
    'directoryId',
  );
  @override
  late final GeneratedColumn<int> directoryId = GeneratedColumn<int>(
    'directory_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgeCardIdMeta = const VerificationMeta(
    'knowledgeCardId',
  );
  @override
  late final GeneratedColumn<int> knowledgeCardId = GeneratedColumn<int>(
    'knowledge_card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionMdMeta = const VerificationMeta(
    'questionMd',
  );
  @override
  late final GeneratedColumn<String> questionMd = GeneratedColumn<String>(
    'question_md',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    directoryId,
    knowledgeCardId,
    title,
    questionMd,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('directory_id')) {
      context.handle(
        _directoryIdMeta,
        directoryId.isAcceptableOrUnknown(
          data['directory_id']!,
          _directoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_directoryIdMeta);
    }
    if (data.containsKey('knowledge_card_id')) {
      context.handle(
        _knowledgeCardIdMeta,
        knowledgeCardId.isAcceptableOrUnknown(
          data['knowledge_card_id']!,
          _knowledgeCardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_knowledgeCardIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('question_md')) {
      context.handle(
        _questionMdMeta,
        questionMd.isAcceptableOrUnknown(data['question_md']!, _questionMdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      directoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}directory_id'],
      )!,
      knowledgeCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}knowledge_card_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      questionMd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_md'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $QuestionCardsTable createAlias(String alias) {
    return $QuestionCardsTable(attachedDatabase, alias);
  }
}

class QuestionCard extends DataClass implements Insertable<QuestionCard> {
  final int id;
  final int directoryId;
  final int knowledgeCardId;
  final String title;
  final String questionMd;
  final DateTime createdAt;
  final DateTime updatedAt;
  const QuestionCard({
    required this.id,
    required this.directoryId,
    required this.knowledgeCardId,
    required this.title,
    required this.questionMd,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['directory_id'] = Variable<int>(directoryId);
    map['knowledge_card_id'] = Variable<int>(knowledgeCardId);
    map['title'] = Variable<String>(title);
    map['question_md'] = Variable<String>(questionMd);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  QuestionCardsCompanion toCompanion(bool nullToAbsent) {
    return QuestionCardsCompanion(
      id: Value(id),
      directoryId: Value(directoryId),
      knowledgeCardId: Value(knowledgeCardId),
      title: Value(title),
      questionMd: Value(questionMd),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory QuestionCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionCard(
      id: serializer.fromJson<int>(json['id']),
      directoryId: serializer.fromJson<int>(json['directoryId']),
      knowledgeCardId: serializer.fromJson<int>(json['knowledgeCardId']),
      title: serializer.fromJson<String>(json['title']),
      questionMd: serializer.fromJson<String>(json['questionMd']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'directoryId': serializer.toJson<int>(directoryId),
      'knowledgeCardId': serializer.toJson<int>(knowledgeCardId),
      'title': serializer.toJson<String>(title),
      'questionMd': serializer.toJson<String>(questionMd),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  QuestionCard copyWith({
    int? id,
    int? directoryId,
    int? knowledgeCardId,
    String? title,
    String? questionMd,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => QuestionCard(
    id: id ?? this.id,
    directoryId: directoryId ?? this.directoryId,
    knowledgeCardId: knowledgeCardId ?? this.knowledgeCardId,
    title: title ?? this.title,
    questionMd: questionMd ?? this.questionMd,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  QuestionCard copyWithCompanion(QuestionCardsCompanion data) {
    return QuestionCard(
      id: data.id.present ? data.id.value : this.id,
      directoryId: data.directoryId.present
          ? data.directoryId.value
          : this.directoryId,
      knowledgeCardId: data.knowledgeCardId.present
          ? data.knowledgeCardId.value
          : this.knowledgeCardId,
      title: data.title.present ? data.title.value : this.title,
      questionMd: data.questionMd.present
          ? data.questionMd.value
          : this.questionMd,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionCard(')
          ..write('id: $id, ')
          ..write('directoryId: $directoryId, ')
          ..write('knowledgeCardId: $knowledgeCardId, ')
          ..write('title: $title, ')
          ..write('questionMd: $questionMd, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    directoryId,
    knowledgeCardId,
    title,
    questionMd,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionCard &&
          other.id == this.id &&
          other.directoryId == this.directoryId &&
          other.knowledgeCardId == this.knowledgeCardId &&
          other.title == this.title &&
          other.questionMd == this.questionMd &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class QuestionCardsCompanion extends UpdateCompanion<QuestionCard> {
  final Value<int> id;
  final Value<int> directoryId;
  final Value<int> knowledgeCardId;
  final Value<String> title;
  final Value<String> questionMd;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const QuestionCardsCompanion({
    this.id = const Value.absent(),
    this.directoryId = const Value.absent(),
    this.knowledgeCardId = const Value.absent(),
    this.title = const Value.absent(),
    this.questionMd = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  QuestionCardsCompanion.insert({
    this.id = const Value.absent(),
    required int directoryId,
    required int knowledgeCardId,
    required String title,
    this.questionMd = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : directoryId = Value(directoryId),
       knowledgeCardId = Value(knowledgeCardId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<QuestionCard> custom({
    Expression<int>? id,
    Expression<int>? directoryId,
    Expression<int>? knowledgeCardId,
    Expression<String>? title,
    Expression<String>? questionMd,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (directoryId != null) 'directory_id': directoryId,
      if (knowledgeCardId != null) 'knowledge_card_id': knowledgeCardId,
      if (title != null) 'title': title,
      if (questionMd != null) 'question_md': questionMd,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  QuestionCardsCompanion copyWith({
    Value<int>? id,
    Value<int>? directoryId,
    Value<int>? knowledgeCardId,
    Value<String>? title,
    Value<String>? questionMd,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return QuestionCardsCompanion(
      id: id ?? this.id,
      directoryId: directoryId ?? this.directoryId,
      knowledgeCardId: knowledgeCardId ?? this.knowledgeCardId,
      title: title ?? this.title,
      questionMd: questionMd ?? this.questionMd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (directoryId.present) {
      map['directory_id'] = Variable<int>(directoryId.value);
    }
    if (knowledgeCardId.present) {
      map['knowledge_card_id'] = Variable<int>(knowledgeCardId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (questionMd.present) {
      map['question_md'] = Variable<String>(questionMd.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionCardsCompanion(')
          ..write('id: $id, ')
          ..write('directoryId: $directoryId, ')
          ..write('knowledgeCardId: $knowledgeCardId, ')
          ..write('title: $title, ')
          ..write('questionMd: $questionMd, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $QuestionCardImagesTable extends QuestionCardImages
    with TableInfo<$QuestionCardImagesTable, QuestionCardImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionCardImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _questionCardIdMeta = const VerificationMeta(
    'questionCardId',
  );
  @override
  late final GeneratedColumn<int> questionCardId = GeneratedColumn<int>(
    'question_card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questionCardId,
    localPath,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_card_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionCardImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('question_card_id')) {
      context.handle(
        _questionCardIdMeta,
        questionCardId.isAcceptableOrUnknown(
          data['question_card_id']!,
          _questionCardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionCardIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionCardImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionCardImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      questionCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_card_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $QuestionCardImagesTable createAlias(String alias) {
    return $QuestionCardImagesTable(attachedDatabase, alias);
  }
}

class QuestionCardImage extends DataClass
    implements Insertable<QuestionCardImage> {
  final int id;
  final int questionCardId;
  final String localPath;
  final int sortOrder;
  const QuestionCardImage({
    required this.id,
    required this.questionCardId,
    required this.localPath,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['question_card_id'] = Variable<int>(questionCardId);
    map['local_path'] = Variable<String>(localPath);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  QuestionCardImagesCompanion toCompanion(bool nullToAbsent) {
    return QuestionCardImagesCompanion(
      id: Value(id),
      questionCardId: Value(questionCardId),
      localPath: Value(localPath),
      sortOrder: Value(sortOrder),
    );
  }

  factory QuestionCardImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionCardImage(
      id: serializer.fromJson<int>(json['id']),
      questionCardId: serializer.fromJson<int>(json['questionCardId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questionCardId': serializer.toJson<int>(questionCardId),
      'localPath': serializer.toJson<String>(localPath),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  QuestionCardImage copyWith({
    int? id,
    int? questionCardId,
    String? localPath,
    int? sortOrder,
  }) => QuestionCardImage(
    id: id ?? this.id,
    questionCardId: questionCardId ?? this.questionCardId,
    localPath: localPath ?? this.localPath,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  QuestionCardImage copyWithCompanion(QuestionCardImagesCompanion data) {
    return QuestionCardImage(
      id: data.id.present ? data.id.value : this.id,
      questionCardId: data.questionCardId.present
          ? data.questionCardId.value
          : this.questionCardId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionCardImage(')
          ..write('id: $id, ')
          ..write('questionCardId: $questionCardId, ')
          ..write('localPath: $localPath, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, questionCardId, localPath, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionCardImage &&
          other.id == this.id &&
          other.questionCardId == this.questionCardId &&
          other.localPath == this.localPath &&
          other.sortOrder == this.sortOrder);
}

class QuestionCardImagesCompanion extends UpdateCompanion<QuestionCardImage> {
  final Value<int> id;
  final Value<int> questionCardId;
  final Value<String> localPath;
  final Value<int> sortOrder;
  const QuestionCardImagesCompanion({
    this.id = const Value.absent(),
    this.questionCardId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  QuestionCardImagesCompanion.insert({
    this.id = const Value.absent(),
    required int questionCardId,
    required String localPath,
    this.sortOrder = const Value.absent(),
  }) : questionCardId = Value(questionCardId),
       localPath = Value(localPath);
  static Insertable<QuestionCardImage> custom({
    Expression<int>? id,
    Expression<int>? questionCardId,
    Expression<String>? localPath,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionCardId != null) 'question_card_id': questionCardId,
      if (localPath != null) 'local_path': localPath,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  QuestionCardImagesCompanion copyWith({
    Value<int>? id,
    Value<int>? questionCardId,
    Value<String>? localPath,
    Value<int>? sortOrder,
  }) {
    return QuestionCardImagesCompanion(
      id: id ?? this.id,
      questionCardId: questionCardId ?? this.questionCardId,
      localPath: localPath ?? this.localPath,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questionCardId.present) {
      map['question_card_id'] = Variable<int>(questionCardId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionCardImagesCompanion(')
          ..write('id: $id, ')
          ..write('questionCardId: $questionCardId, ')
          ..write('localPath: $localPath, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $StudyProgressTable extends StudyProgress
    with TableInfo<$StudyProgressTable, StudyProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _questionCardIdMeta = const VerificationMeta(
    'questionCardId',
  );
  @override
  late final GeneratedColumn<int> questionCardId = GeneratedColumn<int>(
    'question_card_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _timesReviewedMeta = const VerificationMeta(
    'timesReviewed',
  );
  @override
  late final GeneratedColumn<int> timesReviewed = GeneratedColumn<int>(
    'times_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timesCorrectMeta = const VerificationMeta(
    'timesCorrect',
  );
  @override
  late final GeneratedColumn<int> timesCorrect = GeneratedColumn<int>(
    'times_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timesIncorrectMeta = const VerificationMeta(
    'timesIncorrect',
  );
  @override
  late final GeneratedColumn<int> timesIncorrect = GeneratedColumn<int>(
    'times_incorrect',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>(
        'last_reviewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questionCardId,
    timesReviewed,
    timesCorrect,
    timesIncorrect,
    lastReviewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('question_card_id')) {
      context.handle(
        _questionCardIdMeta,
        questionCardId.isAcceptableOrUnknown(
          data['question_card_id']!,
          _questionCardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionCardIdMeta);
    }
    if (data.containsKey('times_reviewed')) {
      context.handle(
        _timesReviewedMeta,
        timesReviewed.isAcceptableOrUnknown(
          data['times_reviewed']!,
          _timesReviewedMeta,
        ),
      );
    }
    if (data.containsKey('times_correct')) {
      context.handle(
        _timesCorrectMeta,
        timesCorrect.isAcceptableOrUnknown(
          data['times_correct']!,
          _timesCorrectMeta,
        ),
      );
    }
    if (data.containsKey('times_incorrect')) {
      context.handle(
        _timesIncorrectMeta,
        timesIncorrect.isAcceptableOrUnknown(
          data['times_incorrect']!,
          _timesIncorrectMeta,
        ),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      questionCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_card_id'],
      )!,
      timesReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_reviewed'],
      )!,
      timesCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_correct'],
      )!,
      timesIncorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_incorrect'],
      )!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed_at'],
      ),
    );
  }

  @override
  $StudyProgressTable createAlias(String alias) {
    return $StudyProgressTable(attachedDatabase, alias);
  }
}

class StudyProgressEntry extends DataClass
    implements Insertable<StudyProgressEntry> {
  final int id;
  final int questionCardId;
  final int timesReviewed;
  final int timesCorrect;
  final int timesIncorrect;
  final DateTime? lastReviewedAt;
  const StudyProgressEntry({
    required this.id,
    required this.questionCardId,
    required this.timesReviewed,
    required this.timesCorrect,
    required this.timesIncorrect,
    this.lastReviewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['question_card_id'] = Variable<int>(questionCardId);
    map['times_reviewed'] = Variable<int>(timesReviewed);
    map['times_correct'] = Variable<int>(timesCorrect);
    map['times_incorrect'] = Variable<int>(timesIncorrect);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    return map;
  }

  StudyProgressCompanion toCompanion(bool nullToAbsent) {
    return StudyProgressCompanion(
      id: Value(id),
      questionCardId: Value(questionCardId),
      timesReviewed: Value(timesReviewed),
      timesCorrect: Value(timesCorrect),
      timesIncorrect: Value(timesIncorrect),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory StudyProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyProgressEntry(
      id: serializer.fromJson<int>(json['id']),
      questionCardId: serializer.fromJson<int>(json['questionCardId']),
      timesReviewed: serializer.fromJson<int>(json['timesReviewed']),
      timesCorrect: serializer.fromJson<int>(json['timesCorrect']),
      timesIncorrect: serializer.fromJson<int>(json['timesIncorrect']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questionCardId': serializer.toJson<int>(questionCardId),
      'timesReviewed': serializer.toJson<int>(timesReviewed),
      'timesCorrect': serializer.toJson<int>(timesCorrect),
      'timesIncorrect': serializer.toJson<int>(timesIncorrect),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
    };
  }

  StudyProgressEntry copyWith({
    int? id,
    int? questionCardId,
    int? timesReviewed,
    int? timesCorrect,
    int? timesIncorrect,
    Value<DateTime?> lastReviewedAt = const Value.absent(),
  }) => StudyProgressEntry(
    id: id ?? this.id,
    questionCardId: questionCardId ?? this.questionCardId,
    timesReviewed: timesReviewed ?? this.timesReviewed,
    timesCorrect: timesCorrect ?? this.timesCorrect,
    timesIncorrect: timesIncorrect ?? this.timesIncorrect,
    lastReviewedAt: lastReviewedAt.present
        ? lastReviewedAt.value
        : this.lastReviewedAt,
  );
  StudyProgressEntry copyWithCompanion(StudyProgressCompanion data) {
    return StudyProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      questionCardId: data.questionCardId.present
          ? data.questionCardId.value
          : this.questionCardId,
      timesReviewed: data.timesReviewed.present
          ? data.timesReviewed.value
          : this.timesReviewed,
      timesCorrect: data.timesCorrect.present
          ? data.timesCorrect.value
          : this.timesCorrect,
      timesIncorrect: data.timesIncorrect.present
          ? data.timesIncorrect.value
          : this.timesIncorrect,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyProgressEntry(')
          ..write('id: $id, ')
          ..write('questionCardId: $questionCardId, ')
          ..write('timesReviewed: $timesReviewed, ')
          ..write('timesCorrect: $timesCorrect, ')
          ..write('timesIncorrect: $timesIncorrect, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    questionCardId,
    timesReviewed,
    timesCorrect,
    timesIncorrect,
    lastReviewedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyProgressEntry &&
          other.id == this.id &&
          other.questionCardId == this.questionCardId &&
          other.timesReviewed == this.timesReviewed &&
          other.timesCorrect == this.timesCorrect &&
          other.timesIncorrect == this.timesIncorrect &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class StudyProgressCompanion extends UpdateCompanion<StudyProgressEntry> {
  final Value<int> id;
  final Value<int> questionCardId;
  final Value<int> timesReviewed;
  final Value<int> timesCorrect;
  final Value<int> timesIncorrect;
  final Value<DateTime?> lastReviewedAt;
  const StudyProgressCompanion({
    this.id = const Value.absent(),
    this.questionCardId = const Value.absent(),
    this.timesReviewed = const Value.absent(),
    this.timesCorrect = const Value.absent(),
    this.timesIncorrect = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
  });
  StudyProgressCompanion.insert({
    this.id = const Value.absent(),
    required int questionCardId,
    this.timesReviewed = const Value.absent(),
    this.timesCorrect = const Value.absent(),
    this.timesIncorrect = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
  }) : questionCardId = Value(questionCardId);
  static Insertable<StudyProgressEntry> custom({
    Expression<int>? id,
    Expression<int>? questionCardId,
    Expression<int>? timesReviewed,
    Expression<int>? timesCorrect,
    Expression<int>? timesIncorrect,
    Expression<DateTime>? lastReviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionCardId != null) 'question_card_id': questionCardId,
      if (timesReviewed != null) 'times_reviewed': timesReviewed,
      if (timesCorrect != null) 'times_correct': timesCorrect,
      if (timesIncorrect != null) 'times_incorrect': timesIncorrect,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
    });
  }

  StudyProgressCompanion copyWith({
    Value<int>? id,
    Value<int>? questionCardId,
    Value<int>? timesReviewed,
    Value<int>? timesCorrect,
    Value<int>? timesIncorrect,
    Value<DateTime?>? lastReviewedAt,
  }) {
    return StudyProgressCompanion(
      id: id ?? this.id,
      questionCardId: questionCardId ?? this.questionCardId,
      timesReviewed: timesReviewed ?? this.timesReviewed,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      timesIncorrect: timesIncorrect ?? this.timesIncorrect,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questionCardId.present) {
      map['question_card_id'] = Variable<int>(questionCardId.value);
    }
    if (timesReviewed.present) {
      map['times_reviewed'] = Variable<int>(timesReviewed.value);
    }
    if (timesCorrect.present) {
      map['times_correct'] = Variable<int>(timesCorrect.value);
    }
    if (timesIncorrect.present) {
      map['times_incorrect'] = Variable<int>(timesIncorrect.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyProgressCompanion(')
          ..write('id: $id, ')
          ..write('questionCardId: $questionCardId, ')
          ..write('timesReviewed: $timesReviewed, ')
          ..write('timesCorrect: $timesCorrect, ')
          ..write('timesIncorrect: $timesIncorrect, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DirectoriesTable directories = $DirectoriesTable(this);
  late final $KnowledgeCardsTable knowledgeCards = $KnowledgeCardsTable(this);
  late final $KnowledgeCardImagesTable knowledgeCardImages =
      $KnowledgeCardImagesTable(this);
  late final $QuestionCardsTable questionCards = $QuestionCardsTable(this);
  late final $QuestionCardImagesTable questionCardImages =
      $QuestionCardImagesTable(this);
  late final $StudyProgressTable studyProgress = $StudyProgressTable(this);
  late final DirectoryDao directoryDao = DirectoryDao(this as AppDatabase);
  late final KnowledgeCardDao knowledgeCardDao = KnowledgeCardDao(
    this as AppDatabase,
  );
  late final QuestionCardDao questionCardDao = QuestionCardDao(
    this as AppDatabase,
  );
  late final StudyProgressDao studyProgressDao = StudyProgressDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    directories,
    knowledgeCards,
    knowledgeCardImages,
    questionCards,
    questionCardImages,
    studyProgress,
  ];
}

typedef $$DirectoriesTableCreateCompanionBuilder =
    DirectoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> parentId,
      required DateTime createdAt,
    });
typedef $$DirectoriesTableUpdateCompanionBuilder =
    DirectoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> parentId,
      Value<DateTime> createdAt,
    });

class $$DirectoriesTableFilterComposer
    extends Composer<_$AppDatabase, $DirectoriesTable> {
  $$DirectoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DirectoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DirectoriesTable> {
  $$DirectoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DirectoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DirectoriesTable> {
  $$DirectoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DirectoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DirectoriesTable,
          DirectoryEntry,
          $$DirectoriesTableFilterComposer,
          $$DirectoriesTableOrderingComposer,
          $$DirectoriesTableAnnotationComposer,
          $$DirectoriesTableCreateCompanionBuilder,
          $$DirectoriesTableUpdateCompanionBuilder,
          (
            DirectoryEntry,
            BaseReferences<_$AppDatabase, $DirectoriesTable, DirectoryEntry>,
          ),
          DirectoryEntry,
          PrefetchHooks Function()
        > {
  $$DirectoriesTableTableManager(_$AppDatabase db, $DirectoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DirectoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DirectoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DirectoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DirectoriesCompanion(
                id: id,
                name: name,
                parentId: parentId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> parentId = const Value.absent(),
                required DateTime createdAt,
              }) => DirectoriesCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DirectoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DirectoriesTable,
      DirectoryEntry,
      $$DirectoriesTableFilterComposer,
      $$DirectoriesTableOrderingComposer,
      $$DirectoriesTableAnnotationComposer,
      $$DirectoriesTableCreateCompanionBuilder,
      $$DirectoriesTableUpdateCompanionBuilder,
      (
        DirectoryEntry,
        BaseReferences<_$AppDatabase, $DirectoriesTable, DirectoryEntry>,
      ),
      DirectoryEntry,
      PrefetchHooks Function()
    >;
typedef $$KnowledgeCardsTableCreateCompanionBuilder =
    KnowledgeCardsCompanion Function({
      Value<int> id,
      required int directoryId,
      required String title,
      Value<String> contentMd,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$KnowledgeCardsTableUpdateCompanionBuilder =
    KnowledgeCardsCompanion Function({
      Value<int> id,
      Value<int> directoryId,
      Value<String> title,
      Value<String> contentMd,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$KnowledgeCardsTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeCardsTable> {
  $$KnowledgeCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get directoryId => $composableBuilder(
    column: $table.directoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentMd => $composableBuilder(
    column: $table.contentMd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KnowledgeCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeCardsTable> {
  $$KnowledgeCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get directoryId => $composableBuilder(
    column: $table.directoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentMd => $composableBuilder(
    column: $table.contentMd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnowledgeCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeCardsTable> {
  $$KnowledgeCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get directoryId => $composableBuilder(
    column: $table.directoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentMd =>
      $composableBuilder(column: $table.contentMd, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KnowledgeCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KnowledgeCardsTable,
          KnowledgeCard,
          $$KnowledgeCardsTableFilterComposer,
          $$KnowledgeCardsTableOrderingComposer,
          $$KnowledgeCardsTableAnnotationComposer,
          $$KnowledgeCardsTableCreateCompanionBuilder,
          $$KnowledgeCardsTableUpdateCompanionBuilder,
          (
            KnowledgeCard,
            BaseReferences<_$AppDatabase, $KnowledgeCardsTable, KnowledgeCard>,
          ),
          KnowledgeCard,
          PrefetchHooks Function()
        > {
  $$KnowledgeCardsTableTableManager(
    _$AppDatabase db,
    $KnowledgeCardsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> directoryId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> contentMd = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => KnowledgeCardsCompanion(
                id: id,
                directoryId: directoryId,
                title: title,
                contentMd: contentMd,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int directoryId,
                required String title,
                Value<String> contentMd = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => KnowledgeCardsCompanion.insert(
                id: id,
                directoryId: directoryId,
                title: title,
                contentMd: contentMd,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KnowledgeCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KnowledgeCardsTable,
      KnowledgeCard,
      $$KnowledgeCardsTableFilterComposer,
      $$KnowledgeCardsTableOrderingComposer,
      $$KnowledgeCardsTableAnnotationComposer,
      $$KnowledgeCardsTableCreateCompanionBuilder,
      $$KnowledgeCardsTableUpdateCompanionBuilder,
      (
        KnowledgeCard,
        BaseReferences<_$AppDatabase, $KnowledgeCardsTable, KnowledgeCard>,
      ),
      KnowledgeCard,
      PrefetchHooks Function()
    >;
typedef $$KnowledgeCardImagesTableCreateCompanionBuilder =
    KnowledgeCardImagesCompanion Function({
      Value<int> id,
      required int knowledgeCardId,
      required String localPath,
      Value<int> sortOrder,
    });
typedef $$KnowledgeCardImagesTableUpdateCompanionBuilder =
    KnowledgeCardImagesCompanion Function({
      Value<int> id,
      Value<int> knowledgeCardId,
      Value<String> localPath,
      Value<int> sortOrder,
    });

class $$KnowledgeCardImagesTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeCardImagesTable> {
  $$KnowledgeCardImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get knowledgeCardId => $composableBuilder(
    column: $table.knowledgeCardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KnowledgeCardImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeCardImagesTable> {
  $$KnowledgeCardImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get knowledgeCardId => $composableBuilder(
    column: $table.knowledgeCardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnowledgeCardImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeCardImagesTable> {
  $$KnowledgeCardImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get knowledgeCardId => $composableBuilder(
    column: $table.knowledgeCardId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$KnowledgeCardImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KnowledgeCardImagesTable,
          KnowledgeCardImage,
          $$KnowledgeCardImagesTableFilterComposer,
          $$KnowledgeCardImagesTableOrderingComposer,
          $$KnowledgeCardImagesTableAnnotationComposer,
          $$KnowledgeCardImagesTableCreateCompanionBuilder,
          $$KnowledgeCardImagesTableUpdateCompanionBuilder,
          (
            KnowledgeCardImage,
            BaseReferences<
              _$AppDatabase,
              $KnowledgeCardImagesTable,
              KnowledgeCardImage
            >,
          ),
          KnowledgeCardImage,
          PrefetchHooks Function()
        > {
  $$KnowledgeCardImagesTableTableManager(
    _$AppDatabase db,
    $KnowledgeCardImagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeCardImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeCardImagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$KnowledgeCardImagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> knowledgeCardId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => KnowledgeCardImagesCompanion(
                id: id,
                knowledgeCardId: knowledgeCardId,
                localPath: localPath,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int knowledgeCardId,
                required String localPath,
                Value<int> sortOrder = const Value.absent(),
              }) => KnowledgeCardImagesCompanion.insert(
                id: id,
                knowledgeCardId: knowledgeCardId,
                localPath: localPath,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KnowledgeCardImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KnowledgeCardImagesTable,
      KnowledgeCardImage,
      $$KnowledgeCardImagesTableFilterComposer,
      $$KnowledgeCardImagesTableOrderingComposer,
      $$KnowledgeCardImagesTableAnnotationComposer,
      $$KnowledgeCardImagesTableCreateCompanionBuilder,
      $$KnowledgeCardImagesTableUpdateCompanionBuilder,
      (
        KnowledgeCardImage,
        BaseReferences<
          _$AppDatabase,
          $KnowledgeCardImagesTable,
          KnowledgeCardImage
        >,
      ),
      KnowledgeCardImage,
      PrefetchHooks Function()
    >;
typedef $$QuestionCardsTableCreateCompanionBuilder =
    QuestionCardsCompanion Function({
      Value<int> id,
      required int directoryId,
      required int knowledgeCardId,
      required String title,
      Value<String> questionMd,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$QuestionCardsTableUpdateCompanionBuilder =
    QuestionCardsCompanion Function({
      Value<int> id,
      Value<int> directoryId,
      Value<int> knowledgeCardId,
      Value<String> title,
      Value<String> questionMd,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$QuestionCardsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionCardsTable> {
  $$QuestionCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get directoryId => $composableBuilder(
    column: $table.directoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get knowledgeCardId => $composableBuilder(
    column: $table.knowledgeCardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionMd => $composableBuilder(
    column: $table.questionMd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionCardsTable> {
  $$QuestionCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get directoryId => $composableBuilder(
    column: $table.directoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get knowledgeCardId => $composableBuilder(
    column: $table.knowledgeCardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionMd => $composableBuilder(
    column: $table.questionMd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionCardsTable> {
  $$QuestionCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get directoryId => $composableBuilder(
    column: $table.directoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get knowledgeCardId => $composableBuilder(
    column: $table.knowledgeCardId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get questionMd => $composableBuilder(
    column: $table.questionMd,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$QuestionCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionCardsTable,
          QuestionCard,
          $$QuestionCardsTableFilterComposer,
          $$QuestionCardsTableOrderingComposer,
          $$QuestionCardsTableAnnotationComposer,
          $$QuestionCardsTableCreateCompanionBuilder,
          $$QuestionCardsTableUpdateCompanionBuilder,
          (
            QuestionCard,
            BaseReferences<_$AppDatabase, $QuestionCardsTable, QuestionCard>,
          ),
          QuestionCard,
          PrefetchHooks Function()
        > {
  $$QuestionCardsTableTableManager(_$AppDatabase db, $QuestionCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> directoryId = const Value.absent(),
                Value<int> knowledgeCardId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> questionMd = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => QuestionCardsCompanion(
                id: id,
                directoryId: directoryId,
                knowledgeCardId: knowledgeCardId,
                title: title,
                questionMd: questionMd,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int directoryId,
                required int knowledgeCardId,
                required String title,
                Value<String> questionMd = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => QuestionCardsCompanion.insert(
                id: id,
                directoryId: directoryId,
                knowledgeCardId: knowledgeCardId,
                title: title,
                questionMd: questionMd,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionCardsTable,
      QuestionCard,
      $$QuestionCardsTableFilterComposer,
      $$QuestionCardsTableOrderingComposer,
      $$QuestionCardsTableAnnotationComposer,
      $$QuestionCardsTableCreateCompanionBuilder,
      $$QuestionCardsTableUpdateCompanionBuilder,
      (
        QuestionCard,
        BaseReferences<_$AppDatabase, $QuestionCardsTable, QuestionCard>,
      ),
      QuestionCard,
      PrefetchHooks Function()
    >;
typedef $$QuestionCardImagesTableCreateCompanionBuilder =
    QuestionCardImagesCompanion Function({
      Value<int> id,
      required int questionCardId,
      required String localPath,
      Value<int> sortOrder,
    });
typedef $$QuestionCardImagesTableUpdateCompanionBuilder =
    QuestionCardImagesCompanion Function({
      Value<int> id,
      Value<int> questionCardId,
      Value<String> localPath,
      Value<int> sortOrder,
    });

class $$QuestionCardImagesTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionCardImagesTable> {
  $$QuestionCardImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionCardId => $composableBuilder(
    column: $table.questionCardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionCardImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionCardImagesTable> {
  $$QuestionCardImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionCardId => $composableBuilder(
    column: $table.questionCardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionCardImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionCardImagesTable> {
  $$QuestionCardImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get questionCardId => $composableBuilder(
    column: $table.questionCardId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$QuestionCardImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionCardImagesTable,
          QuestionCardImage,
          $$QuestionCardImagesTableFilterComposer,
          $$QuestionCardImagesTableOrderingComposer,
          $$QuestionCardImagesTableAnnotationComposer,
          $$QuestionCardImagesTableCreateCompanionBuilder,
          $$QuestionCardImagesTableUpdateCompanionBuilder,
          (
            QuestionCardImage,
            BaseReferences<
              _$AppDatabase,
              $QuestionCardImagesTable,
              QuestionCardImage
            >,
          ),
          QuestionCardImage,
          PrefetchHooks Function()
        > {
  $$QuestionCardImagesTableTableManager(
    _$AppDatabase db,
    $QuestionCardImagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionCardImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionCardImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionCardImagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> questionCardId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => QuestionCardImagesCompanion(
                id: id,
                questionCardId: questionCardId,
                localPath: localPath,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int questionCardId,
                required String localPath,
                Value<int> sortOrder = const Value.absent(),
              }) => QuestionCardImagesCompanion.insert(
                id: id,
                questionCardId: questionCardId,
                localPath: localPath,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionCardImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionCardImagesTable,
      QuestionCardImage,
      $$QuestionCardImagesTableFilterComposer,
      $$QuestionCardImagesTableOrderingComposer,
      $$QuestionCardImagesTableAnnotationComposer,
      $$QuestionCardImagesTableCreateCompanionBuilder,
      $$QuestionCardImagesTableUpdateCompanionBuilder,
      (
        QuestionCardImage,
        BaseReferences<
          _$AppDatabase,
          $QuestionCardImagesTable,
          QuestionCardImage
        >,
      ),
      QuestionCardImage,
      PrefetchHooks Function()
    >;
typedef $$StudyProgressTableCreateCompanionBuilder =
    StudyProgressCompanion Function({
      Value<int> id,
      required int questionCardId,
      Value<int> timesReviewed,
      Value<int> timesCorrect,
      Value<int> timesIncorrect,
      Value<DateTime?> lastReviewedAt,
    });
typedef $$StudyProgressTableUpdateCompanionBuilder =
    StudyProgressCompanion Function({
      Value<int> id,
      Value<int> questionCardId,
      Value<int> timesReviewed,
      Value<int> timesCorrect,
      Value<int> timesIncorrect,
      Value<DateTime?> lastReviewedAt,
    });

class $$StudyProgressTableFilterComposer
    extends Composer<_$AppDatabase, $StudyProgressTable> {
  $$StudyProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionCardId => $composableBuilder(
    column: $table.questionCardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesReviewed => $composableBuilder(
    column: $table.timesReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesCorrect => $composableBuilder(
    column: $table.timesCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesIncorrect => $composableBuilder(
    column: $table.timesIncorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyProgressTable> {
  $$StudyProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionCardId => $composableBuilder(
    column: $table.questionCardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesReviewed => $composableBuilder(
    column: $table.timesReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesCorrect => $composableBuilder(
    column: $table.timesCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesIncorrect => $composableBuilder(
    column: $table.timesIncorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyProgressTable> {
  $$StudyProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get questionCardId => $composableBuilder(
    column: $table.questionCardId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesReviewed => $composableBuilder(
    column: $table.timesReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesCorrect => $composableBuilder(
    column: $table.timesCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesIncorrect => $composableBuilder(
    column: $table.timesIncorrect,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );
}

class $$StudyProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyProgressTable,
          StudyProgressEntry,
          $$StudyProgressTableFilterComposer,
          $$StudyProgressTableOrderingComposer,
          $$StudyProgressTableAnnotationComposer,
          $$StudyProgressTableCreateCompanionBuilder,
          $$StudyProgressTableUpdateCompanionBuilder,
          (
            StudyProgressEntry,
            BaseReferences<
              _$AppDatabase,
              $StudyProgressTable,
              StudyProgressEntry
            >,
          ),
          StudyProgressEntry,
          PrefetchHooks Function()
        > {
  $$StudyProgressTableTableManager(_$AppDatabase db, $StudyProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> questionCardId = const Value.absent(),
                Value<int> timesReviewed = const Value.absent(),
                Value<int> timesCorrect = const Value.absent(),
                Value<int> timesIncorrect = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
              }) => StudyProgressCompanion(
                id: id,
                questionCardId: questionCardId,
                timesReviewed: timesReviewed,
                timesCorrect: timesCorrect,
                timesIncorrect: timesIncorrect,
                lastReviewedAt: lastReviewedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int questionCardId,
                Value<int> timesReviewed = const Value.absent(),
                Value<int> timesCorrect = const Value.absent(),
                Value<int> timesIncorrect = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
              }) => StudyProgressCompanion.insert(
                id: id,
                questionCardId: questionCardId,
                timesReviewed: timesReviewed,
                timesCorrect: timesCorrect,
                timesIncorrect: timesIncorrect,
                lastReviewedAt: lastReviewedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyProgressTable,
      StudyProgressEntry,
      $$StudyProgressTableFilterComposer,
      $$StudyProgressTableOrderingComposer,
      $$StudyProgressTableAnnotationComposer,
      $$StudyProgressTableCreateCompanionBuilder,
      $$StudyProgressTableUpdateCompanionBuilder,
      (
        StudyProgressEntry,
        BaseReferences<_$AppDatabase, $StudyProgressTable, StudyProgressEntry>,
      ),
      StudyProgressEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DirectoriesTableTableManager get directories =>
      $$DirectoriesTableTableManager(_db, _db.directories);
  $$KnowledgeCardsTableTableManager get knowledgeCards =>
      $$KnowledgeCardsTableTableManager(_db, _db.knowledgeCards);
  $$KnowledgeCardImagesTableTableManager get knowledgeCardImages =>
      $$KnowledgeCardImagesTableTableManager(_db, _db.knowledgeCardImages);
  $$QuestionCardsTableTableManager get questionCards =>
      $$QuestionCardsTableTableManager(_db, _db.questionCards);
  $$QuestionCardImagesTableTableManager get questionCardImages =>
      $$QuestionCardImagesTableTableManager(_db, _db.questionCardImages);
  $$StudyProgressTableTableManager get studyProgress =>
      $$StudyProgressTableTableManager(_db, _db.studyProgress);
}

mixin _$DirectoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $DirectoriesTable get directories => attachedDatabase.directories;
}
mixin _$KnowledgeCardDaoMixin on DatabaseAccessor<AppDatabase> {
  $KnowledgeCardsTable get knowledgeCards => attachedDatabase.knowledgeCards;
  $KnowledgeCardImagesTable get knowledgeCardImages =>
      attachedDatabase.knowledgeCardImages;
}
mixin _$QuestionCardDaoMixin on DatabaseAccessor<AppDatabase> {
  $QuestionCardsTable get questionCards => attachedDatabase.questionCards;
  $QuestionCardImagesTable get questionCardImages =>
      attachedDatabase.questionCardImages;
}
mixin _$StudyProgressDaoMixin on DatabaseAccessor<AppDatabase> {
  $StudyProgressTable get studyProgress => attachedDatabase.studyProgress;
}
