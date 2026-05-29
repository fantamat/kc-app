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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
  final String id;
  final String name;
  final String? parentId;
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
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
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
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DirectoryEntry copyWith({
    String? id,
    String? name,
    Value<String?> parentId = const Value.absent(),
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
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DirectoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DirectoriesCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<DirectoryEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DirectoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DirectoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DirectoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directoryIdMeta = const VerificationMeta(
    'directoryId',
  );
  @override
  late final GeneratedColumn<String> directoryId = GeneratedColumn<String>(
    'directory_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      directoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
  final String id;
  final String directoryId;
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
    map['id'] = Variable<String>(id);
    map['directory_id'] = Variable<String>(directoryId);
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
      id: serializer.fromJson<String>(json['id']),
      directoryId: serializer.fromJson<String>(json['directoryId']),
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
      'id': serializer.toJson<String>(id),
      'directoryId': serializer.toJson<String>(directoryId),
      'title': serializer.toJson<String>(title),
      'contentMd': serializer.toJson<String>(contentMd),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KnowledgeCard copyWith({
    String? id,
    String? directoryId,
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
  final Value<String> id;
  final Value<String> directoryId;
  final Value<String> title;
  final Value<String> contentMd;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const KnowledgeCardsCompanion({
    this.id = const Value.absent(),
    this.directoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.contentMd = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeCardsCompanion.insert({
    required String id,
    required String directoryId,
    required String title,
    this.contentMd = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       directoryId = Value(directoryId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<KnowledgeCard> custom({
    Expression<String>? id,
    Expression<String>? directoryId,
    Expression<String>? title,
    Expression<String>? contentMd,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (directoryId != null) 'directory_id': directoryId,
      if (title != null) 'title': title,
      if (contentMd != null) 'content_md': contentMd,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? directoryId,
    Value<String>? title,
    Value<String>? contentMd,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return KnowledgeCardsCompanion(
      id: id ?? this.id,
      directoryId: directoryId ?? this.directoryId,
      title: title ?? this.title,
      contentMd: contentMd ?? this.contentMd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (directoryId.present) {
      map['directory_id'] = Variable<String>(directoryId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgeCardIdMeta = const VerificationMeta(
    'knowledgeCardId',
  );
  @override
  late final GeneratedColumn<String> knowledgeCardId = GeneratedColumn<String>(
    'knowledge_card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
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
    imagePath,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      knowledgeCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}knowledge_card_id'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
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
  final String id;
  final String knowledgeCardId;
  final String imagePath;
  final int sortOrder;
  const KnowledgeCardImage({
    required this.id,
    required this.knowledgeCardId,
    required this.imagePath,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['knowledge_card_id'] = Variable<String>(knowledgeCardId);
    map['image_path'] = Variable<String>(imagePath);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  KnowledgeCardImagesCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeCardImagesCompanion(
      id: Value(id),
      knowledgeCardId: Value(knowledgeCardId),
      imagePath: Value(imagePath),
      sortOrder: Value(sortOrder),
    );
  }

  factory KnowledgeCardImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeCardImage(
      id: serializer.fromJson<String>(json['id']),
      knowledgeCardId: serializer.fromJson<String>(json['knowledgeCardId']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'knowledgeCardId': serializer.toJson<String>(knowledgeCardId),
      'imagePath': serializer.toJson<String>(imagePath),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  KnowledgeCardImage copyWith({
    String? id,
    String? knowledgeCardId,
    String? imagePath,
    int? sortOrder,
  }) => KnowledgeCardImage(
    id: id ?? this.id,
    knowledgeCardId: knowledgeCardId ?? this.knowledgeCardId,
    imagePath: imagePath ?? this.imagePath,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  KnowledgeCardImage copyWithCompanion(KnowledgeCardImagesCompanion data) {
    return KnowledgeCardImage(
      id: data.id.present ? data.id.value : this.id,
      knowledgeCardId: data.knowledgeCardId.present
          ? data.knowledgeCardId.value
          : this.knowledgeCardId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeCardImage(')
          ..write('id: $id, ')
          ..write('knowledgeCardId: $knowledgeCardId, ')
          ..write('imagePath: $imagePath, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, knowledgeCardId, imagePath, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeCardImage &&
          other.id == this.id &&
          other.knowledgeCardId == this.knowledgeCardId &&
          other.imagePath == this.imagePath &&
          other.sortOrder == this.sortOrder);
}

class KnowledgeCardImagesCompanion extends UpdateCompanion<KnowledgeCardImage> {
  final Value<String> id;
  final Value<String> knowledgeCardId;
  final Value<String> imagePath;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const KnowledgeCardImagesCompanion({
    this.id = const Value.absent(),
    this.knowledgeCardId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeCardImagesCompanion.insert({
    required String id,
    required String knowledgeCardId,
    required String imagePath,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       knowledgeCardId = Value(knowledgeCardId),
       imagePath = Value(imagePath);
  static Insertable<KnowledgeCardImage> custom({
    Expression<String>? id,
    Expression<String>? knowledgeCardId,
    Expression<String>? imagePath,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (knowledgeCardId != null) 'knowledge_card_id': knowledgeCardId,
      if (imagePath != null) 'image_path': imagePath,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeCardImagesCompanion copyWith({
    Value<String>? id,
    Value<String>? knowledgeCardId,
    Value<String>? imagePath,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return KnowledgeCardImagesCompanion(
      id: id ?? this.id,
      knowledgeCardId: knowledgeCardId ?? this.knowledgeCardId,
      imagePath: imagePath ?? this.imagePath,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (knowledgeCardId.present) {
      map['knowledge_card_id'] = Variable<String>(knowledgeCardId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeCardImagesCompanion(')
          ..write('id: $id, ')
          ..write('knowledgeCardId: $knowledgeCardId, ')
          ..write('imagePath: $imagePath, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directoryIdMeta = const VerificationMeta(
    'directoryId',
  );
  @override
  late final GeneratedColumn<String> directoryId = GeneratedColumn<String>(
    'directory_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgeCardIdMeta = const VerificationMeta(
    'knowledgeCardId',
  );
  @override
  late final GeneratedColumn<String> knowledgeCardId = GeneratedColumn<String>(
    'knowledge_card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      directoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}directory_id'],
      )!,
      knowledgeCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
  final String id;
  final String directoryId;
  final String knowledgeCardId;
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
    map['id'] = Variable<String>(id);
    map['directory_id'] = Variable<String>(directoryId);
    map['knowledge_card_id'] = Variable<String>(knowledgeCardId);
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
      id: serializer.fromJson<String>(json['id']),
      directoryId: serializer.fromJson<String>(json['directoryId']),
      knowledgeCardId: serializer.fromJson<String>(json['knowledgeCardId']),
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
      'id': serializer.toJson<String>(id),
      'directoryId': serializer.toJson<String>(directoryId),
      'knowledgeCardId': serializer.toJson<String>(knowledgeCardId),
      'title': serializer.toJson<String>(title),
      'questionMd': serializer.toJson<String>(questionMd),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  QuestionCard copyWith({
    String? id,
    String? directoryId,
    String? knowledgeCardId,
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
  final Value<String> id;
  final Value<String> directoryId;
  final Value<String> knowledgeCardId;
  final Value<String> title;
  final Value<String> questionMd;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const QuestionCardsCompanion({
    this.id = const Value.absent(),
    this.directoryId = const Value.absent(),
    this.knowledgeCardId = const Value.absent(),
    this.title = const Value.absent(),
    this.questionMd = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionCardsCompanion.insert({
    required String id,
    required String directoryId,
    required String knowledgeCardId,
    required String title,
    this.questionMd = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       directoryId = Value(directoryId),
       knowledgeCardId = Value(knowledgeCardId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<QuestionCard> custom({
    Expression<String>? id,
    Expression<String>? directoryId,
    Expression<String>? knowledgeCardId,
    Expression<String>? title,
    Expression<String>? questionMd,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (directoryId != null) 'directory_id': directoryId,
      if (knowledgeCardId != null) 'knowledge_card_id': knowledgeCardId,
      if (title != null) 'title': title,
      if (questionMd != null) 'question_md': questionMd,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? directoryId,
    Value<String>? knowledgeCardId,
    Value<String>? title,
    Value<String>? questionMd,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return QuestionCardsCompanion(
      id: id ?? this.id,
      directoryId: directoryId ?? this.directoryId,
      knowledgeCardId: knowledgeCardId ?? this.knowledgeCardId,
      title: title ?? this.title,
      questionMd: questionMd ?? this.questionMd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (directoryId.present) {
      map['directory_id'] = Variable<String>(directoryId.value);
    }
    if (knowledgeCardId.present) {
      map['knowledge_card_id'] = Variable<String>(knowledgeCardId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionCardIdMeta = const VerificationMeta(
    'questionCardId',
  );
  @override
  late final GeneratedColumn<String> questionCardId = GeneratedColumn<String>(
    'question_card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
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
    imagePath,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      questionCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_card_id'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
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
  final String id;
  final String questionCardId;
  final String imagePath;
  final int sortOrder;
  const QuestionCardImage({
    required this.id,
    required this.questionCardId,
    required this.imagePath,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['question_card_id'] = Variable<String>(questionCardId);
    map['image_path'] = Variable<String>(imagePath);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  QuestionCardImagesCompanion toCompanion(bool nullToAbsent) {
    return QuestionCardImagesCompanion(
      id: Value(id),
      questionCardId: Value(questionCardId),
      imagePath: Value(imagePath),
      sortOrder: Value(sortOrder),
    );
  }

  factory QuestionCardImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionCardImage(
      id: serializer.fromJson<String>(json['id']),
      questionCardId: serializer.fromJson<String>(json['questionCardId']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'questionCardId': serializer.toJson<String>(questionCardId),
      'imagePath': serializer.toJson<String>(imagePath),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  QuestionCardImage copyWith({
    String? id,
    String? questionCardId,
    String? imagePath,
    int? sortOrder,
  }) => QuestionCardImage(
    id: id ?? this.id,
    questionCardId: questionCardId ?? this.questionCardId,
    imagePath: imagePath ?? this.imagePath,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  QuestionCardImage copyWithCompanion(QuestionCardImagesCompanion data) {
    return QuestionCardImage(
      id: data.id.present ? data.id.value : this.id,
      questionCardId: data.questionCardId.present
          ? data.questionCardId.value
          : this.questionCardId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionCardImage(')
          ..write('id: $id, ')
          ..write('questionCardId: $questionCardId, ')
          ..write('imagePath: $imagePath, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, questionCardId, imagePath, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionCardImage &&
          other.id == this.id &&
          other.questionCardId == this.questionCardId &&
          other.imagePath == this.imagePath &&
          other.sortOrder == this.sortOrder);
}

class QuestionCardImagesCompanion extends UpdateCompanion<QuestionCardImage> {
  final Value<String> id;
  final Value<String> questionCardId;
  final Value<String> imagePath;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const QuestionCardImagesCompanion({
    this.id = const Value.absent(),
    this.questionCardId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionCardImagesCompanion.insert({
    required String id,
    required String questionCardId,
    required String imagePath,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       questionCardId = Value(questionCardId),
       imagePath = Value(imagePath);
  static Insertable<QuestionCardImage> custom({
    Expression<String>? id,
    Expression<String>? questionCardId,
    Expression<String>? imagePath,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionCardId != null) 'question_card_id': questionCardId,
      if (imagePath != null) 'image_path': imagePath,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionCardImagesCompanion copyWith({
    Value<String>? id,
    Value<String>? questionCardId,
    Value<String>? imagePath,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return QuestionCardImagesCompanion(
      id: id ?? this.id,
      questionCardId: questionCardId ?? this.questionCardId,
      imagePath: imagePath ?? this.imagePath,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questionCardId.present) {
      map['question_card_id'] = Variable<String>(questionCardId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionCardImagesCompanion(')
          ..write('id: $id, ')
          ..write('questionCardId: $questionCardId, ')
          ..write('imagePath: $imagePath, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionCardIdMeta = const VerificationMeta(
    'questionCardId',
  );
  @override
  late final GeneratedColumn<String> questionCardId = GeneratedColumn<String>(
    'question_card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      questionCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
  final String id;
  final String questionCardId;
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
    map['id'] = Variable<String>(id);
    map['question_card_id'] = Variable<String>(questionCardId);
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
      id: serializer.fromJson<String>(json['id']),
      questionCardId: serializer.fromJson<String>(json['questionCardId']),
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
      'id': serializer.toJson<String>(id),
      'questionCardId': serializer.toJson<String>(questionCardId),
      'timesReviewed': serializer.toJson<int>(timesReviewed),
      'timesCorrect': serializer.toJson<int>(timesCorrect),
      'timesIncorrect': serializer.toJson<int>(timesIncorrect),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
    };
  }

  StudyProgressEntry copyWith({
    String? id,
    String? questionCardId,
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
  final Value<String> id;
  final Value<String> questionCardId;
  final Value<int> timesReviewed;
  final Value<int> timesCorrect;
  final Value<int> timesIncorrect;
  final Value<DateTime?> lastReviewedAt;
  final Value<int> rowid;
  const StudyProgressCompanion({
    this.id = const Value.absent(),
    this.questionCardId = const Value.absent(),
    this.timesReviewed = const Value.absent(),
    this.timesCorrect = const Value.absent(),
    this.timesIncorrect = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyProgressCompanion.insert({
    required String id,
    required String questionCardId,
    this.timesReviewed = const Value.absent(),
    this.timesCorrect = const Value.absent(),
    this.timesIncorrect = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       questionCardId = Value(questionCardId);
  static Insertable<StudyProgressEntry> custom({
    Expression<String>? id,
    Expression<String>? questionCardId,
    Expression<int>? timesReviewed,
    Expression<int>? timesCorrect,
    Expression<int>? timesIncorrect,
    Expression<DateTime>? lastReviewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionCardId != null) 'question_card_id': questionCardId,
      if (timesReviewed != null) 'times_reviewed': timesReviewed,
      if (timesCorrect != null) 'times_correct': timesCorrect,
      if (timesIncorrect != null) 'times_incorrect': timesIncorrect,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyProgressCompanion copyWith({
    Value<String>? id,
    Value<String>? questionCardId,
    Value<int>? timesReviewed,
    Value<int>? timesCorrect,
    Value<int>? timesIncorrect,
    Value<DateTime?>? lastReviewedAt,
    Value<int>? rowid,
  }) {
    return StudyProgressCompanion(
      id: id ?? this.id,
      questionCardId: questionCardId ?? this.questionCardId,
      timesReviewed: timesReviewed ?? this.timesReviewed,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      timesIncorrect: timesIncorrect ?? this.timesIncorrect,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questionCardId.present) {
      map['question_card_id'] = Variable<String>(questionCardId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('rowid: $rowid')
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
      required String id,
      required String name,
      Value<String?> parentId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$DirectoriesTableUpdateCompanionBuilder =
    DirectoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> parentId,
      Value<DateTime> createdAt,
      Value<int> rowid,
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
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
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DirectoriesCompanion(
                id: id,
                name: name,
                parentId: parentId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DirectoriesCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                createdAt: createdAt,
                rowid: rowid,
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
      required String id,
      required String directoryId,
      required String title,
      Value<String> contentMd,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$KnowledgeCardsTableUpdateCompanionBuilder =
    KnowledgeCardsCompanion Function({
      Value<String> id,
      Value<String> directoryId,
      Value<String> title,
      Value<String> contentMd,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directoryId => $composableBuilder(
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directoryId => $composableBuilder(
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get directoryId => $composableBuilder(
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
                Value<String> id = const Value.absent(),
                Value<String> directoryId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> contentMd = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeCardsCompanion(
                id: id,
                directoryId: directoryId,
                title: title,
                contentMd: contentMd,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String directoryId,
                required String title,
                Value<String> contentMd = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeCardsCompanion.insert(
                id: id,
                directoryId: directoryId,
                title: title,
                contentMd: contentMd,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
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
      required String id,
      required String knowledgeCardId,
      required String imagePath,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$KnowledgeCardImagesTableUpdateCompanionBuilder =
    KnowledgeCardImagesCompanion Function({
      Value<String> id,
      Value<String> knowledgeCardId,
      Value<String> imagePath,
      Value<int> sortOrder,
      Value<int> rowid,
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get knowledgeCardId => $composableBuilder(
    column: $table.knowledgeCardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get knowledgeCardId => $composableBuilder(
    column: $table.knowledgeCardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get knowledgeCardId => $composableBuilder(
    column: $table.knowledgeCardId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

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
                Value<String> id = const Value.absent(),
                Value<String> knowledgeCardId = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeCardImagesCompanion(
                id: id,
                knowledgeCardId: knowledgeCardId,
                imagePath: imagePath,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String knowledgeCardId,
                required String imagePath,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnowledgeCardImagesCompanion.insert(
                id: id,
                knowledgeCardId: knowledgeCardId,
                imagePath: imagePath,
                sortOrder: sortOrder,
                rowid: rowid,
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
      required String id,
      required String directoryId,
      required String knowledgeCardId,
      required String title,
      Value<String> questionMd,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$QuestionCardsTableUpdateCompanionBuilder =
    QuestionCardsCompanion Function({
      Value<String> id,
      Value<String> directoryId,
      Value<String> knowledgeCardId,
      Value<String> title,
      Value<String> questionMd,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directoryId => $composableBuilder(
    column: $table.directoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get knowledgeCardId => $composableBuilder(
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directoryId => $composableBuilder(
    column: $table.directoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get knowledgeCardId => $composableBuilder(
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get directoryId => $composableBuilder(
    column: $table.directoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get knowledgeCardId => $composableBuilder(
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
                Value<String> id = const Value.absent(),
                Value<String> directoryId = const Value.absent(),
                Value<String> knowledgeCardId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> questionMd = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionCardsCompanion(
                id: id,
                directoryId: directoryId,
                knowledgeCardId: knowledgeCardId,
                title: title,
                questionMd: questionMd,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String directoryId,
                required String knowledgeCardId,
                required String title,
                Value<String> questionMd = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => QuestionCardsCompanion.insert(
                id: id,
                directoryId: directoryId,
                knowledgeCardId: knowledgeCardId,
                title: title,
                questionMd: questionMd,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
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
      required String id,
      required String questionCardId,
      required String imagePath,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$QuestionCardImagesTableUpdateCompanionBuilder =
    QuestionCardImagesCompanion Function({
      Value<String> id,
      Value<String> questionCardId,
      Value<String> imagePath,
      Value<int> sortOrder,
      Value<int> rowid,
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionCardId => $composableBuilder(
    column: $table.questionCardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionCardId => $composableBuilder(
    column: $table.questionCardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questionCardId => $composableBuilder(
    column: $table.questionCardId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

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
                Value<String> id = const Value.absent(),
                Value<String> questionCardId = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionCardImagesCompanion(
                id: id,
                questionCardId: questionCardId,
                imagePath: imagePath,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String questionCardId,
                required String imagePath,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionCardImagesCompanion.insert(
                id: id,
                questionCardId: questionCardId,
                imagePath: imagePath,
                sortOrder: sortOrder,
                rowid: rowid,
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
      required String id,
      required String questionCardId,
      Value<int> timesReviewed,
      Value<int> timesCorrect,
      Value<int> timesIncorrect,
      Value<DateTime?> lastReviewedAt,
      Value<int> rowid,
    });
typedef $$StudyProgressTableUpdateCompanionBuilder =
    StudyProgressCompanion Function({
      Value<String> id,
      Value<String> questionCardId,
      Value<int> timesReviewed,
      Value<int> timesCorrect,
      Value<int> timesIncorrect,
      Value<DateTime?> lastReviewedAt,
      Value<int> rowid,
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionCardId => $composableBuilder(
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionCardId => $composableBuilder(
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questionCardId => $composableBuilder(
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
                Value<String> id = const Value.absent(),
                Value<String> questionCardId = const Value.absent(),
                Value<int> timesReviewed = const Value.absent(),
                Value<int> timesCorrect = const Value.absent(),
                Value<int> timesIncorrect = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyProgressCompanion(
                id: id,
                questionCardId: questionCardId,
                timesReviewed: timesReviewed,
                timesCorrect: timesCorrect,
                timesIncorrect: timesIncorrect,
                lastReviewedAt: lastReviewedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String questionCardId,
                Value<int> timesReviewed = const Value.absent(),
                Value<int> timesCorrect = const Value.absent(),
                Value<int> timesIncorrect = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyProgressCompanion.insert(
                id: id,
                questionCardId: questionCardId,
                timesReviewed: timesReviewed,
                timesCorrect: timesCorrect,
                timesIncorrect: timesIncorrect,
                lastReviewedAt: lastReviewedAt,
                rowid: rowid,
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
