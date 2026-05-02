// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExercisesTableTable extends ExercisesTable
    with TableInfo<$ExercisesTableTable, ExercisesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _muscleGroupMeta = const VerificationMeta(
    'muscleGroup',
  );
  @override
  late final GeneratedColumn<String> muscleGroup = GeneratedColumn<String>(
    'muscle_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _creatorIdMeta = const VerificationMeta(
    'creatorId',
  );
  @override
  late final GeneratedColumn<String> creatorId = GeneratedColumn<String>(
    'creator_id',
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    muscleGroup,
    category,
    isSystem,
    creatorId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExercisesTableData> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('muscle_group')) {
      context.handle(
        _muscleGroupMeta,
        muscleGroup.isAcceptableOrUnknown(
          data['muscle_group']!,
          _muscleGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_muscleGroupMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('creator_id')) {
      context.handle(
        _creatorIdMeta,
        creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExercisesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExercisesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      muscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_group'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      creatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ExercisesTableTable createAlias(String alias) {
    return $ExercisesTableTable(attachedDatabase, alias);
  }
}

class ExercisesTableData extends DataClass
    implements Insertable<ExercisesTableData> {
  final String id;
  final String name;
  final String? description;
  final String muscleGroup;
  final String category;
  final bool isSystem;
  final String? creatorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const ExercisesTableData({
    required this.id,
    required this.name,
    this.description,
    required this.muscleGroup,
    required this.category,
    required this.isSystem,
    this.creatorId,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['muscle_group'] = Variable<String>(muscleGroup);
    map['category'] = Variable<String>(category);
    map['is_system'] = Variable<bool>(isSystem);
    if (!nullToAbsent || creatorId != null) {
      map['creator_id'] = Variable<String>(creatorId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ExercisesTableCompanion toCompanion(bool nullToAbsent) {
    return ExercisesTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      muscleGroup: Value(muscleGroup),
      category: Value(category),
      isSystem: Value(isSystem),
      creatorId: creatorId == null && nullToAbsent
          ? const Value.absent()
          : Value(creatorId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ExercisesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExercisesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      muscleGroup: serializer.fromJson<String>(json['muscleGroup']),
      category: serializer.fromJson<String>(json['category']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      creatorId: serializer.fromJson<String?>(json['creatorId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'muscleGroup': serializer.toJson<String>(muscleGroup),
      'category': serializer.toJson<String>(category),
      'isSystem': serializer.toJson<bool>(isSystem),
      'creatorId': serializer.toJson<String?>(creatorId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ExercisesTableData copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? muscleGroup,
    String? category,
    bool? isSystem,
    Value<String?> creatorId = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => ExercisesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    muscleGroup: muscleGroup ?? this.muscleGroup,
    category: category ?? this.category,
    isSystem: isSystem ?? this.isSystem,
    creatorId: creatorId.present ? creatorId.value : this.creatorId,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ExercisesTableData copyWithCompanion(ExercisesTableCompanion data) {
    return ExercisesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      muscleGroup: data.muscleGroup.present
          ? data.muscleGroup.value
          : this.muscleGroup,
      category: data.category.present ? data.category.value : this.category,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('category: $category, ')
          ..write('isSystem: $isSystem, ')
          ..write('creatorId: $creatorId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    muscleGroup,
    category,
    isSystem,
    creatorId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExercisesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.muscleGroup == this.muscleGroup &&
          other.category == this.category &&
          other.isSystem == this.isSystem &&
          other.creatorId == this.creatorId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExercisesTableCompanion extends UpdateCompanion<ExercisesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> muscleGroup;
  final Value<String> category;
  final Value<bool> isSystem;
  final Value<String?> creatorId;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ExercisesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.category = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesTableCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String muscleGroup,
    required String category,
    this.isSystem = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       muscleGroup = Value(muscleGroup),
       category = Value(category);
  static Insertable<ExercisesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? muscleGroup,
    Expression<String>? category,
    Expression<bool>? isSystem,
    Expression<String>? creatorId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (category != null) 'category': category,
      if (isSystem != null) 'is_system': isSystem,
      if (creatorId != null) 'creator_id': creatorId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? muscleGroup,
    Value<String>? category,
    Value<bool>? isSystem,
    Value<String?>? creatorId,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExercisesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      category: category ?? this.category,
      isSystem: isSystem ?? this.isSystem,
      creatorId: creatorId ?? this.creatorId,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(muscleGroup.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<String>(creatorId.value);
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
    return (StringBuffer('ExercisesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('category: $category, ')
          ..write('isSystem: $isSystem, ')
          ..write('creatorId: $creatorId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTableTable extends RoutinesTable
    with TableInfo<$RoutinesTableTable, RoutinesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creatorIdMeta = const VerificationMeta(
    'creatorId',
  );
  @override
  late final GeneratedColumn<String> creatorId = GeneratedColumn<String>(
    'creator_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isTemplateMeta = const VerificationMeta(
    'isTemplate',
  );
  @override
  late final GeneratedColumn<bool> isTemplate = GeneratedColumn<bool>(
    'is_template',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_template" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    creatorId,
    isTemplate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutinesTableData> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('creator_id')) {
      context.handle(
        _creatorIdMeta,
        creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_creatorIdMeta);
    }
    if (data.containsKey('is_template')) {
      context.handle(
        _isTemplateMeta,
        isTemplate.isAcceptableOrUnknown(data['is_template']!, _isTemplateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutinesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutinesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      creatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator_id'],
      )!,
      isTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_template'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $RoutinesTableTable createAlias(String alias) {
    return $RoutinesTableTable(attachedDatabase, alias);
  }
}

class RoutinesTableData extends DataClass
    implements Insertable<RoutinesTableData> {
  final String id;
  final String name;
  final String? description;
  final String creatorId;
  final bool isTemplate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const RoutinesTableData({
    required this.id,
    required this.name,
    this.description,
    required this.creatorId,
    required this.isTemplate,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['creator_id'] = Variable<String>(creatorId);
    map['is_template'] = Variable<bool>(isTemplate);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RoutinesTableCompanion toCompanion(bool nullToAbsent) {
    return RoutinesTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      creatorId: Value(creatorId),
      isTemplate: Value(isTemplate),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RoutinesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutinesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      creatorId: serializer.fromJson<String>(json['creatorId']),
      isTemplate: serializer.fromJson<bool>(json['isTemplate']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'creatorId': serializer.toJson<String>(creatorId),
      'isTemplate': serializer.toJson<bool>(isTemplate),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  RoutinesTableData copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? creatorId,
    bool? isTemplate,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => RoutinesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    creatorId: creatorId ?? this.creatorId,
    isTemplate: isTemplate ?? this.isTemplate,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  RoutinesTableData copyWithCompanion(RoutinesTableCompanion data) {
    return RoutinesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
      isTemplate: data.isTemplate.present
          ? data.isTemplate.value
          : this.isTemplate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('creatorId: $creatorId, ')
          ..write('isTemplate: $isTemplate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    creatorId,
    isTemplate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutinesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.creatorId == this.creatorId &&
          other.isTemplate == this.isTemplate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutinesTableCompanion extends UpdateCompanion<RoutinesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> creatorId;
  final Value<bool> isTemplate;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const RoutinesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.creatorId = const Value.absent(),
    this.isTemplate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesTableCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String creatorId,
    this.isTemplate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       creatorId = Value(creatorId);
  static Insertable<RoutinesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? creatorId,
    Expression<bool>? isTemplate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (creatorId != null) 'creator_id': creatorId,
      if (isTemplate != null) 'is_template': isTemplate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? creatorId,
    Value<bool>? isTemplate,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutinesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      isTemplate: isTemplate ?? this.isTemplate,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<String>(creatorId.value);
    }
    if (isTemplate.present) {
      map['is_template'] = Variable<bool>(isTemplate.value);
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
    return (StringBuffer('RoutinesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('creatorId: $creatorId, ')
          ..write('isTemplate: $isTemplate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineExercisesTableTable extends RoutineExercisesTable
    with TableInfo<$RoutineExercisesTableTable, RoutineExercisesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineExercisesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineId,
    exerciseId,
    position,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_exercises_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineExercisesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineExercisesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineExercisesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $RoutineExercisesTableTable createAlias(String alias) {
    return $RoutineExercisesTableTable(attachedDatabase, alias);
  }
}

class RoutineExercisesTableData extends DataClass
    implements Insertable<RoutineExercisesTableData> {
  final String id;
  final String routineId;
  final String exerciseId;
  final int position;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const RoutineExercisesTableData({
    required this.id,
    required this.routineId,
    required this.exerciseId,
    required this.position,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RoutineExercisesTableCompanion toCompanion(bool nullToAbsent) {
    return RoutineExercisesTableCompanion(
      id: Value(id),
      routineId: Value(routineId),
      exerciseId: Value(exerciseId),
      position: Value(position),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RoutineExercisesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineExercisesTableData(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      position: serializer.fromJson<int>(json['position']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String>(routineId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'position': serializer.toJson<int>(position),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  RoutineExercisesTableData copyWith({
    String? id,
    String? routineId,
    String? exerciseId,
    int? position,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => RoutineExercisesTableData(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    exerciseId: exerciseId ?? this.exerciseId,
    position: position ?? this.position,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  RoutineExercisesTableData copyWithCompanion(
    RoutineExercisesTableCompanion data,
  ) {
    return RoutineExercisesTableData(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      position: data.position.present ? data.position.value : this.position,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineExercisesTableData(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    routineId,
    exerciseId,
    position,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineExercisesTableData &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.exerciseId == this.exerciseId &&
          other.position == this.position &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutineExercisesTableCompanion
    extends UpdateCompanion<RoutineExercisesTableData> {
  final Value<String> id;
  final Value<String> routineId;
  final Value<String> exerciseId;
  final Value<int> position;
  final Value<String?> notes;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const RoutineExercisesTableCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.position = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineExercisesTableCompanion.insert({
    required String id,
    required String routineId,
    required String exerciseId,
    required int position,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       routineId = Value(routineId),
       exerciseId = Value(exerciseId),
       position = Value(position);
  static Insertable<RoutineExercisesTableData> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<String>? exerciseId,
    Expression<int>? position,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (position != null) 'position': position,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineExercisesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? routineId,
    Value<String>? exerciseId,
    Value<int>? position,
    Value<String?>? notes,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutineExercisesTableCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      exerciseId: exerciseId ?? this.exerciseId,
      position: position ?? this.position,
      notes: notes ?? this.notes,
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
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('RoutineExercisesTableCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('position: $position, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineSetsTableTable extends RoutineSetsTable
    with TableInfo<$RoutineSetsTableTable, RoutineSetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineSetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineExerciseIdMeta = const VerificationMeta(
    'routineExerciseId',
  );
  @override
  late final GeneratedColumn<String> routineExerciseId =
      GeneratedColumn<String>(
        'routine_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES routine_exercises_table (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _setTypeMeta = const VerificationMeta(
    'setType',
  );
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
    'set_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('working'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineExerciseId,
    setNumber,
    weight,
    reps,
    restSeconds,
    setType,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_sets_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineSetsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_exercise_id')) {
      context.handle(
        _routineExerciseIdMeta,
        routineExerciseId.isAcceptableOrUnknown(
          data['routine_exercise_id']!,
          _routineExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_routineExerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    if (data.containsKey('set_type')) {
      context.handle(
        _setTypeMeta,
        setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineSetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineSetsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_exercise_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      ),
      setType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $RoutineSetsTableTable createAlias(String alias) {
    return $RoutineSetsTableTable(attachedDatabase, alias);
  }
}

class RoutineSetsTableData extends DataClass
    implements Insertable<RoutineSetsTableData> {
  final String id;
  final String routineExerciseId;
  final int setNumber;
  final double? weight;
  final int? reps;
  final int? restSeconds;
  final String setType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const RoutineSetsTableData({
    required this.id,
    required this.routineExerciseId,
    required this.setNumber,
    this.weight,
    this.reps,
    this.restSeconds,
    required this.setType,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_exercise_id'] = Variable<String>(routineExerciseId);
    map['set_number'] = Variable<int>(setNumber);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || restSeconds != null) {
      map['rest_seconds'] = Variable<int>(restSeconds);
    }
    map['set_type'] = Variable<String>(setType);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RoutineSetsTableCompanion toCompanion(bool nullToAbsent) {
    return RoutineSetsTableCompanion(
      id: Value(id),
      routineExerciseId: Value(routineExerciseId),
      setNumber: Value(setNumber),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      restSeconds: restSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restSeconds),
      setType: Value(setType),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RoutineSetsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineSetsTableData(
      id: serializer.fromJson<String>(json['id']),
      routineExerciseId: serializer.fromJson<String>(json['routineExerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weight: serializer.fromJson<double?>(json['weight']),
      reps: serializer.fromJson<int?>(json['reps']),
      restSeconds: serializer.fromJson<int?>(json['restSeconds']),
      setType: serializer.fromJson<String>(json['setType']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineExerciseId': serializer.toJson<String>(routineExerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'weight': serializer.toJson<double?>(weight),
      'reps': serializer.toJson<int?>(reps),
      'restSeconds': serializer.toJson<int?>(restSeconds),
      'setType': serializer.toJson<String>(setType),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  RoutineSetsTableData copyWith({
    String? id,
    String? routineExerciseId,
    int? setNumber,
    Value<double?> weight = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<int?> restSeconds = const Value.absent(),
    String? setType,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => RoutineSetsTableData(
    id: id ?? this.id,
    routineExerciseId: routineExerciseId ?? this.routineExerciseId,
    setNumber: setNumber ?? this.setNumber,
    weight: weight.present ? weight.value : this.weight,
    reps: reps.present ? reps.value : this.reps,
    restSeconds: restSeconds.present ? restSeconds.value : this.restSeconds,
    setType: setType ?? this.setType,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  RoutineSetsTableData copyWithCompanion(RoutineSetsTableCompanion data) {
    return RoutineSetsTableData(
      id: data.id.present ? data.id.value : this.id,
      routineExerciseId: data.routineExerciseId.present
          ? data.routineExerciseId.value
          : this.routineExerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      setType: data.setType.present ? data.setType.value : this.setType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineSetsTableData(')
          ..write('id: $id, ')
          ..write('routineExerciseId: $routineExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('setType: $setType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    routineExerciseId,
    setNumber,
    weight,
    reps,
    restSeconds,
    setType,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineSetsTableData &&
          other.id == this.id &&
          other.routineExerciseId == this.routineExerciseId &&
          other.setNumber == this.setNumber &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.restSeconds == this.restSeconds &&
          other.setType == this.setType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutineSetsTableCompanion extends UpdateCompanion<RoutineSetsTableData> {
  final Value<String> id;
  final Value<String> routineExerciseId;
  final Value<int> setNumber;
  final Value<double?> weight;
  final Value<int?> reps;
  final Value<int?> restSeconds;
  final Value<String> setType;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const RoutineSetsTableCompanion({
    this.id = const Value.absent(),
    this.routineExerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.setType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineSetsTableCompanion.insert({
    required String id,
    required String routineExerciseId,
    required int setNumber,
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.setType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       routineExerciseId = Value(routineExerciseId),
       setNumber = Value(setNumber);
  static Insertable<RoutineSetsTableData> custom({
    Expression<String>? id,
    Expression<String>? routineExerciseId,
    Expression<int>? setNumber,
    Expression<double>? weight,
    Expression<int>? reps,
    Expression<int>? restSeconds,
    Expression<String>? setType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineExerciseId != null) 'routine_exercise_id': routineExerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (setType != null) 'set_type': setType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineSetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? routineExerciseId,
    Value<int>? setNumber,
    Value<double?>? weight,
    Value<int?>? reps,
    Value<int?>? restSeconds,
    Value<String>? setType,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutineSetsTableCompanion(
      id: id ?? this.id,
      routineExerciseId: routineExerciseId ?? this.routineExerciseId,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      setType: setType ?? this.setType,
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
    if (routineExerciseId.present) {
      map['routine_exercise_id'] = Variable<String>(routineExerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
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
    return (StringBuffer('RoutineSetsTableCompanion(')
          ..write('id: $id, ')
          ..write('routineExerciseId: $routineExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('setType: $setType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTableTable extends WorkoutsTable
    with TableInfo<$WorkoutsTableTable, WorkoutsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gymIdMeta = const VerificationMeta('gymId');
  @override
  late final GeneratedColumn<String> gymId = GeneratedColumn<String>(
    'gym_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainerNotesMeta = const VerificationMeta(
    'trainerNotes',
  );
  @override
  late final GeneratedColumn<String> trainerNotes = GeneratedColumn<String>(
    'trainer_notes',
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    routineId,
    gymId,
    startedAt,
    finishedAt,
    notes,
    trainerNotes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    }
    if (data.containsKey('gym_id')) {
      context.handle(
        _gymIdMeta,
        gymId.isAcceptableOrUnknown(data['gym_id']!, _gymIdMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('trainer_notes')) {
      context.handle(
        _trainerNotesMeta,
        trainerNotes.isAcceptableOrUnknown(
          data['trainer_notes']!,
          _trainerNotesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      ),
      gymId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gym_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      trainerNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trainer_notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $WorkoutsTableTable createAlias(String alias) {
    return $WorkoutsTableTable(attachedDatabase, alias);
  }
}

class WorkoutsTableData extends DataClass
    implements Insertable<WorkoutsTableData> {
  final String id;
  final String userId;
  final String? routineId;
  final String? gymId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final String? notes;
  final String? trainerNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const WorkoutsTableData({
    required this.id,
    required this.userId,
    this.routineId,
    this.gymId,
    required this.startedAt,
    this.finishedAt,
    this.notes,
    this.trainerNotes,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || routineId != null) {
      map['routine_id'] = Variable<String>(routineId);
    }
    if (!nullToAbsent || gymId != null) {
      map['gym_id'] = Variable<String>(gymId);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || trainerNotes != null) {
      map['trainer_notes'] = Variable<String>(trainerNotes);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  WorkoutsTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      routineId: routineId == null && nullToAbsent
          ? const Value.absent()
          : Value(routineId),
      gymId: gymId == null && nullToAbsent
          ? const Value.absent()
          : Value(gymId),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      trainerNotes: trainerNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(trainerNotes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory WorkoutsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      routineId: serializer.fromJson<String?>(json['routineId']),
      gymId: serializer.fromJson<String?>(json['gymId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      trainerNotes: serializer.fromJson<String?>(json['trainerNotes']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'routineId': serializer.toJson<String?>(routineId),
      'gymId': serializer.toJson<String?>(gymId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'notes': serializer.toJson<String?>(notes),
      'trainerNotes': serializer.toJson<String?>(trainerNotes),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  WorkoutsTableData copyWith({
    String? id,
    String? userId,
    Value<String?> routineId = const Value.absent(),
    Value<String?> gymId = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> trainerNotes = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => WorkoutsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    routineId: routineId.present ? routineId.value : this.routineId,
    gymId: gymId.present ? gymId.value : this.gymId,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    notes: notes.present ? notes.value : this.notes,
    trainerNotes: trainerNotes.present ? trainerNotes.value : this.trainerNotes,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  WorkoutsTableData copyWithCompanion(WorkoutsTableCompanion data) {
    return WorkoutsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      gymId: data.gymId.present ? data.gymId.value : this.gymId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      trainerNotes: data.trainerNotes.present
          ? data.trainerNotes.value
          : this.trainerNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('routineId: $routineId, ')
          ..write('gymId: $gymId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('notes: $notes, ')
          ..write('trainerNotes: $trainerNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    routineId,
    gymId,
    startedAt,
    finishedAt,
    notes,
    trainerNotes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.routineId == this.routineId &&
          other.gymId == this.gymId &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.notes == this.notes &&
          other.trainerNotes == this.trainerNotes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutsTableCompanion extends UpdateCompanion<WorkoutsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> routineId;
  final Value<String?> gymId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<String?> notes;
  final Value<String?> trainerNotes;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const WorkoutsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.routineId = const Value.absent(),
    this.gymId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.trainerNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsTableCompanion.insert({
    required String id,
    required String userId,
    this.routineId = const Value.absent(),
    this.gymId = const Value.absent(),
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.trainerNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       startedAt = Value(startedAt);
  static Insertable<WorkoutsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? routineId,
    Expression<String>? gymId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<String>? notes,
    Expression<String>? trainerNotes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (routineId != null) 'routine_id': routineId,
      if (gymId != null) 'gym_id': gymId,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (notes != null) 'notes': notes,
      if (trainerNotes != null) 'trainer_notes': trainerNotes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? routineId,
    Value<String?>? gymId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<String?>? notes,
    Value<String?>? trainerNotes,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkoutsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      routineId: routineId ?? this.routineId,
      gymId: gymId ?? this.gymId,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      notes: notes ?? this.notes,
      trainerNotes: trainerNotes ?? this.trainerNotes,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (gymId.present) {
      map['gym_id'] = Variable<String>(gymId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (trainerNotes.present) {
      map['trainer_notes'] = Variable<String>(trainerNotes.value);
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
    return (StringBuffer('WorkoutsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('routineId: $routineId, ')
          ..write('gymId: $gymId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('notes: $notes, ')
          ..write('trainerNotes: $trainerNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExercisesTableTable extends WorkoutExercisesTable
    with TableInfo<$WorkoutExercisesTableTable, WorkoutExercisesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExercisesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineExerciseIdMeta = const VerificationMeta(
    'routineExerciseId',
  );
  @override
  late final GeneratedColumn<String> routineExerciseId =
      GeneratedColumn<String>(
        'routine_exercise_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    exerciseId,
    routineExerciseId,
    position,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExercisesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('routine_exercise_id')) {
      context.handle(
        _routineExerciseIdMeta,
        routineExerciseId.isAcceptableOrUnknown(
          data['routine_exercise_id']!,
          _routineExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExercisesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExercisesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      routineExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_exercise_id'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $WorkoutExercisesTableTable createAlias(String alias) {
    return $WorkoutExercisesTableTable(attachedDatabase, alias);
  }
}

class WorkoutExercisesTableData extends DataClass
    implements Insertable<WorkoutExercisesTableData> {
  final String id;
  final String workoutId;
  final String exerciseId;
  final String? routineExerciseId;
  final int position;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const WorkoutExercisesTableData({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    this.routineExerciseId,
    required this.position,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['exercise_id'] = Variable<String>(exerciseId);
    if (!nullToAbsent || routineExerciseId != null) {
      map['routine_exercise_id'] = Variable<String>(routineExerciseId);
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  WorkoutExercisesTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesTableCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      routineExerciseId: routineExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(routineExerciseId),
      position: Value(position),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory WorkoutExercisesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExercisesTableData(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      routineExerciseId: serializer.fromJson<String?>(
        json['routineExerciseId'],
      ),
      position: serializer.fromJson<int>(json['position']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'routineExerciseId': serializer.toJson<String?>(routineExerciseId),
      'position': serializer.toJson<int>(position),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  WorkoutExercisesTableData copyWith({
    String? id,
    String? workoutId,
    String? exerciseId,
    Value<String?> routineExerciseId = const Value.absent(),
    int? position,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => WorkoutExercisesTableData(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId ?? this.exerciseId,
    routineExerciseId: routineExerciseId.present
        ? routineExerciseId.value
        : this.routineExerciseId,
    position: position ?? this.position,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  WorkoutExercisesTableData copyWithCompanion(
    WorkoutExercisesTableCompanion data,
  ) {
    return WorkoutExercisesTableData(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      routineExerciseId: data.routineExerciseId.present
          ? data.routineExerciseId.value
          : this.routineExerciseId,
      position: data.position.present ? data.position.value : this.position,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesTableData(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('routineExerciseId: $routineExerciseId, ')
          ..write('position: $position, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutId,
    exerciseId,
    routineExerciseId,
    position,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExercisesTableData &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.routineExerciseId == this.routineExerciseId &&
          other.position == this.position &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutExercisesTableCompanion
    extends UpdateCompanion<WorkoutExercisesTableData> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<String> exerciseId;
  final Value<String?> routineExerciseId;
  final Value<int> position;
  final Value<String?> notes;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const WorkoutExercisesTableCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.routineExerciseId = const Value.absent(),
    this.position = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutExercisesTableCompanion.insert({
    required String id,
    required String workoutId,
    required String exerciseId,
    this.routineExerciseId = const Value.absent(),
    required int position,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutId = Value(workoutId),
       exerciseId = Value(exerciseId),
       position = Value(position);
  static Insertable<WorkoutExercisesTableData> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<String>? exerciseId,
    Expression<String>? routineExerciseId,
    Expression<int>? position,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (routineExerciseId != null) 'routine_exercise_id': routineExerciseId,
      if (position != null) 'position': position,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutExercisesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutId,
    Value<String>? exerciseId,
    Value<String?>? routineExerciseId,
    Value<int>? position,
    Value<String?>? notes,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkoutExercisesTableCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      routineExerciseId: routineExerciseId ?? this.routineExerciseId,
      position: position ?? this.position,
      notes: notes ?? this.notes,
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
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (routineExerciseId.present) {
      map['routine_exercise_id'] = Variable<String>(routineExerciseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('WorkoutExercisesTableCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('routineExerciseId: $routineExerciseId, ')
          ..write('position: $position, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTableTable extends WorkoutSetsTable
    with TableInfo<$WorkoutSetsTableTable, WorkoutSetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutExerciseIdMeta = const VerificationMeta(
    'workoutExerciseId',
  );
  @override
  late final GeneratedColumn<String> workoutExerciseId =
      GeneratedColumn<String>(
        'workout_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_exercises_table (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutExerciseId,
    setNumber,
    weight,
    reps,
    rpe,
    completed,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_exercise_id')) {
      context.handle(
        _workoutExerciseIdMeta,
        workoutExerciseId.isAcceptableOrUnknown(
          data['workout_exercise_id']!,
          _workoutExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutExerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_exercise_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $WorkoutSetsTableTable createAlias(String alias) {
    return $WorkoutSetsTableTable(attachedDatabase, alias);
  }
}

class WorkoutSetsTableData extends DataClass
    implements Insertable<WorkoutSetsTableData> {
  final String id;
  final String workoutExerciseId;
  final int setNumber;
  final double? weight;
  final int? reps;
  final double? rpe;
  final bool completed;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const WorkoutSetsTableData({
    required this.id,
    required this.workoutExerciseId,
    required this.setNumber,
    this.weight,
    this.reps,
    this.rpe,
    required this.completed,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_exercise_id'] = Variable<String>(workoutExerciseId);
    map['set_number'] = Variable<int>(setNumber);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  WorkoutSetsTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsTableCompanion(
      id: Value(id),
      workoutExerciseId: Value(workoutExerciseId),
      setNumber: Value(setNumber),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      completed: Value(completed),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory WorkoutSetsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetsTableData(
      id: serializer.fromJson<String>(json['id']),
      workoutExerciseId: serializer.fromJson<String>(json['workoutExerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weight: serializer.fromJson<double?>(json['weight']),
      reps: serializer.fromJson<int?>(json['reps']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      completed: serializer.fromJson<bool>(json['completed']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutExerciseId': serializer.toJson<String>(workoutExerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'weight': serializer.toJson<double?>(weight),
      'reps': serializer.toJson<int?>(reps),
      'rpe': serializer.toJson<double?>(rpe),
      'completed': serializer.toJson<bool>(completed),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  WorkoutSetsTableData copyWith({
    String? id,
    String? workoutExerciseId,
    int? setNumber,
    Value<double?> weight = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<double?> rpe = const Value.absent(),
    bool? completed,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => WorkoutSetsTableData(
    id: id ?? this.id,
    workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
    setNumber: setNumber ?? this.setNumber,
    weight: weight.present ? weight.value : this.weight,
    reps: reps.present ? reps.value : this.reps,
    rpe: rpe.present ? rpe.value : this.rpe,
    completed: completed ?? this.completed,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  WorkoutSetsTableData copyWithCompanion(WorkoutSetsTableCompanion data) {
    return WorkoutSetsTableData(
      id: data.id.present ? data.id.value : this.id,
      workoutExerciseId: data.workoutExerciseId.present
          ? data.workoutExerciseId.value
          : this.workoutExerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      completed: data.completed.present ? data.completed.value : this.completed,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsTableData(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('completed: $completed, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutExerciseId,
    setNumber,
    weight,
    reps,
    rpe,
    completed,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetsTableData &&
          other.id == this.id &&
          other.workoutExerciseId == this.workoutExerciseId &&
          other.setNumber == this.setNumber &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.rpe == this.rpe &&
          other.completed == this.completed &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutSetsTableCompanion extends UpdateCompanion<WorkoutSetsTableData> {
  final Value<String> id;
  final Value<String> workoutExerciseId;
  final Value<int> setNumber;
  final Value<double?> weight;
  final Value<int?> reps;
  final Value<double?> rpe;
  final Value<bool> completed;
  final Value<String?> notes;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const WorkoutSetsTableCompanion({
    this.id = const Value.absent(),
    this.workoutExerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.completed = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsTableCompanion.insert({
    required String id,
    required String workoutExerciseId,
    required int setNumber,
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.completed = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutExerciseId = Value(workoutExerciseId),
       setNumber = Value(setNumber);
  static Insertable<WorkoutSetsTableData> custom({
    Expression<String>? id,
    Expression<String>? workoutExerciseId,
    Expression<int>? setNumber,
    Expression<double>? weight,
    Expression<int>? reps,
    Expression<double>? rpe,
    Expression<bool>? completed,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutExerciseId != null) 'workout_exercise_id': workoutExerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (rpe != null) 'rpe': rpe,
      if (completed != null) 'completed': completed,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutExerciseId,
    Value<int>? setNumber,
    Value<double?>? weight,
    Value<int?>? reps,
    Value<double?>? rpe,
    Value<bool>? completed,
    Value<String?>? notes,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSetsTableCompanion(
      id: id ?? this.id,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
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
    if (workoutExerciseId.present) {
      map['workout_exercise_id'] = Variable<String>(workoutExerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('WorkoutSetsTableCompanion(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('completed: $completed, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOperationsTableTable extends SyncOperationsTable
    with TableInfo<$SyncOperationsTableTable, SyncOperationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOperationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
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
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payload,
    createdAt,
    syncedAt,
    attemptCount,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_operations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOperationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
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
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOperationsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOperationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $SyncOperationsTableTable createAlias(String alias) {
    return $SyncOperationsTableTable(attachedDatabase, alias);
  }
}

class SyncOperationsTableData extends DataClass
    implements Insertable<SyncOperationsTableData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String? payload;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final int attemptCount;
  final String? lastError;
  const SyncOperationsTableData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    this.payload,
    required this.createdAt,
    this.syncedAt,
    required this.attemptCount,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SyncOperationsTableCompanion toCompanion(bool nullToAbsent) {
    return SyncOperationsTableCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory SyncOperationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOperationsTableData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String?>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String?>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  SyncOperationsTableData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    Value<String?> payload = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
    int? attemptCount,
    Value<String?> lastError = const Value.absent(),
  }) => SyncOperationsTableData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload.present ? payload.value : this.payload,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    attemptCount: attemptCount ?? this.attemptCount,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  SyncOperationsTableData copyWithCompanion(SyncOperationsTableCompanion data) {
    return SyncOperationsTableData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationsTableData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payload,
    createdAt,
    syncedAt,
    attemptCount,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOperationsTableData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError);
}

class SyncOperationsTableCompanion
    extends UpdateCompanion<SyncOperationsTableData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String?> payload;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<int> rowid;
  const SyncOperationsTableCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOperationsTableCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    this.payload = const Value.absent(),
    required DateTime createdAt,
    this.syncedAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       createdAt = Value(createdAt);
  static Insertable<SyncOperationsTableData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOperationsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String?>? payload,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
    Value<int>? attemptCount,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return SyncOperationsTableCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationsTableCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExercisesTableTable exercisesTable = $ExercisesTableTable(this);
  late final $RoutinesTableTable routinesTable = $RoutinesTableTable(this);
  late final $RoutineExercisesTableTable routineExercisesTable =
      $RoutineExercisesTableTable(this);
  late final $RoutineSetsTableTable routineSetsTable = $RoutineSetsTableTable(
    this,
  );
  late final $WorkoutsTableTable workoutsTable = $WorkoutsTableTable(this);
  late final $WorkoutExercisesTableTable workoutExercisesTable =
      $WorkoutExercisesTableTable(this);
  late final $WorkoutSetsTableTable workoutSetsTable = $WorkoutSetsTableTable(
    this,
  );
  late final $SyncOperationsTableTable syncOperationsTable =
      $SyncOperationsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercisesTable,
    routinesTable,
    routineExercisesTable,
    routineSetsTable,
    workoutsTable,
    workoutExercisesTable,
    workoutSetsTable,
    syncOperationsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routines_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_exercises_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routine_exercises_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_sets_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workouts_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_exercises_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_exercises_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sets_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ExercisesTableTableCreateCompanionBuilder =
    ExercisesTableCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required String muscleGroup,
      required String category,
      Value<bool> isSystem,
      Value<String?> creatorId,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$ExercisesTableTableUpdateCompanionBuilder =
    ExercisesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> muscleGroup,
      Value<String> category,
      Value<bool> isSystem,
      Value<String?> creatorId,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$ExercisesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
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

class $$ExercisesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
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

class $$ExercisesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTableTable> {
  $$ExercisesTableTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<String> get creatorId =>
      $composableBuilder(column: $table.creatorId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExercisesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTableTable,
          ExercisesTableData,
          $$ExercisesTableTableFilterComposer,
          $$ExercisesTableTableOrderingComposer,
          $$ExercisesTableTableAnnotationComposer,
          $$ExercisesTableTableCreateCompanionBuilder,
          $$ExercisesTableTableUpdateCompanionBuilder,
          (
            ExercisesTableData,
            BaseReferences<
              _$AppDatabase,
              $ExercisesTableTable,
              ExercisesTableData
            >,
          ),
          ExercisesTableData,
          PrefetchHooks Function()
        > {
  $$ExercisesTableTableTableManager(
    _$AppDatabase db,
    $ExercisesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> muscleGroup = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<String?> creatorId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesTableCompanion(
                id: id,
                name: name,
                description: description,
                muscleGroup: muscleGroup,
                category: category,
                isSystem: isSystem,
                creatorId: creatorId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required String muscleGroup,
                required String category,
                Value<bool> isSystem = const Value.absent(),
                Value<String?> creatorId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                muscleGroup: muscleGroup,
                category: category,
                isSystem: isSystem,
                creatorId: creatorId,
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

typedef $$ExercisesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTableTable,
      ExercisesTableData,
      $$ExercisesTableTableFilterComposer,
      $$ExercisesTableTableOrderingComposer,
      $$ExercisesTableTableAnnotationComposer,
      $$ExercisesTableTableCreateCompanionBuilder,
      $$ExercisesTableTableUpdateCompanionBuilder,
      (
        ExercisesTableData,
        BaseReferences<_$AppDatabase, $ExercisesTableTable, ExercisesTableData>,
      ),
      ExercisesTableData,
      PrefetchHooks Function()
    >;
typedef $$RoutinesTableTableCreateCompanionBuilder =
    RoutinesTableCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required String creatorId,
      Value<bool> isTemplate,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$RoutinesTableTableUpdateCompanionBuilder =
    RoutinesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> creatorId,
      Value<bool> isTemplate,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$RoutinesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $RoutinesTableTable, RoutinesTableData> {
  $$RoutinesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $RoutineExercisesTableTable,
    List<RoutineExercisesTableData>
  >
  _routineExercisesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineExercisesTable,
        aliasName: $_aliasNameGenerator(
          db.routinesTable.id,
          db.routineExercisesTable.routineId,
        ),
      );

  $$RoutineExercisesTableTableProcessedTableManager
  get routineExercisesTableRefs {
    final manager = $$RoutineExercisesTableTableTableManager(
      $_db,
      $_db.routineExercisesTable,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineExercisesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutinesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTableTable> {
  $$RoutinesTableTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTemplate => $composableBuilder(
    column: $table.isTemplate,
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

  Expression<bool> routineExercisesTableRefs(
    Expression<bool> Function($$RoutineExercisesTableTableFilterComposer f) f,
  ) {
    final $$RoutineExercisesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineExercisesTable,
          getReferencedColumn: (t) => t.routineId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineExercisesTableTableFilterComposer(
                $db: $db,
                $table: $db.routineExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RoutinesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTableTable> {
  $$RoutinesTableTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creatorId => $composableBuilder(
    column: $table.creatorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTemplate => $composableBuilder(
    column: $table.isTemplate,
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

class $$RoutinesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTableTable> {
  $$RoutinesTableTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creatorId =>
      $composableBuilder(column: $table.creatorId, builder: (column) => column);

  GeneratedColumn<bool> get isTemplate => $composableBuilder(
    column: $table.isTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> routineExercisesTableRefs<T extends Object>(
    Expression<T> Function($$RoutineExercisesTableTableAnnotationComposer a) f,
  ) {
    final $$RoutineExercisesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineExercisesTable,
          getReferencedColumn: (t) => t.routineId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineExercisesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.routineExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RoutinesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTableTable,
          RoutinesTableData,
          $$RoutinesTableTableFilterComposer,
          $$RoutinesTableTableOrderingComposer,
          $$RoutinesTableTableAnnotationComposer,
          $$RoutinesTableTableCreateCompanionBuilder,
          $$RoutinesTableTableUpdateCompanionBuilder,
          (RoutinesTableData, $$RoutinesTableTableReferences),
          RoutinesTableData,
          PrefetchHooks Function({bool routineExercisesTableRefs})
        > {
  $$RoutinesTableTableTableManager(_$AppDatabase db, $RoutinesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> creatorId = const Value.absent(),
                Value<bool> isTemplate = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesTableCompanion(
                id: id,
                name: name,
                description: description,
                creatorId: creatorId,
                isTemplate: isTemplate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required String creatorId,
                Value<bool> isTemplate = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                creatorId: creatorId,
                isTemplate: isTemplate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutinesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineExercisesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineExercisesTableRefs) db.routineExercisesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineExercisesTableRefs)
                    await $_getPrefetchedData<
                      RoutinesTableData,
                      $RoutinesTableTable,
                      RoutineExercisesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$RoutinesTableTableReferences
                          ._routineExercisesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RoutinesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).routineExercisesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.routineId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoutinesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTableTable,
      RoutinesTableData,
      $$RoutinesTableTableFilterComposer,
      $$RoutinesTableTableOrderingComposer,
      $$RoutinesTableTableAnnotationComposer,
      $$RoutinesTableTableCreateCompanionBuilder,
      $$RoutinesTableTableUpdateCompanionBuilder,
      (RoutinesTableData, $$RoutinesTableTableReferences),
      RoutinesTableData,
      PrefetchHooks Function({bool routineExercisesTableRefs})
    >;
typedef $$RoutineExercisesTableTableCreateCompanionBuilder =
    RoutineExercisesTableCompanion Function({
      required String id,
      required String routineId,
      required String exerciseId,
      required int position,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$RoutineExercisesTableTableUpdateCompanionBuilder =
    RoutineExercisesTableCompanion Function({
      Value<String> id,
      Value<String> routineId,
      Value<String> exerciseId,
      Value<int> position,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$RoutineExercisesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RoutineExercisesTableTable,
          RoutineExercisesTableData
        > {
  $$RoutineExercisesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutinesTableTable _routineIdTable(_$AppDatabase db) =>
      db.routinesTable.createAlias(
        $_aliasNameGenerator(
          db.routineExercisesTable.routineId,
          db.routinesTable.id,
        ),
      );

  $$RoutinesTableTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<String>('routine_id')!;

    final manager = $$RoutinesTableTableTableManager(
      $_db,
      $_db.routinesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RoutineSetsTableTable, List<RoutineSetsTableData>>
  _routineSetsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineSetsTable,
    aliasName: $_aliasNameGenerator(
      db.routineExercisesTable.id,
      db.routineSetsTable.routineExerciseId,
    ),
  );

  $$RoutineSetsTableTableProcessedTableManager get routineSetsTableRefs {
    final manager =
        $$RoutineSetsTableTableTableManager($_db, $_db.routineSetsTable).filter(
          (f) => f.routineExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _routineSetsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineExercisesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTableTable> {
  $$RoutineExercisesTableTableFilterComposer({
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

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$RoutinesTableTableFilterComposer get routineId {
    final $$RoutinesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routinesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableTableFilterComposer(
            $db: $db,
            $table: $db.routinesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> routineSetsTableRefs(
    Expression<bool> Function($$RoutineSetsTableTableFilterComposer f) f,
  ) {
    final $$RoutineSetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineSetsTable,
      getReferencedColumn: (t) => t.routineExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineSetsTableTableFilterComposer(
            $db: $db,
            $table: $db.routineSetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineExercisesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTableTable> {
  $$RoutineExercisesTableTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$RoutinesTableTableOrderingComposer get routineId {
    final $$RoutinesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routinesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableTableOrderingComposer(
            $db: $db,
            $table: $db.routinesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineExercisesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTableTable> {
  $$RoutineExercisesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoutinesTableTableAnnotationComposer get routineId {
    final $$RoutinesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routinesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.routinesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> routineSetsTableRefs<T extends Object>(
    Expression<T> Function($$RoutineSetsTableTableAnnotationComposer a) f,
  ) {
    final $$RoutineSetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineSetsTable,
      getReferencedColumn: (t) => t.routineExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineSetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.routineSetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineExercisesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineExercisesTableTable,
          RoutineExercisesTableData,
          $$RoutineExercisesTableTableFilterComposer,
          $$RoutineExercisesTableTableOrderingComposer,
          $$RoutineExercisesTableTableAnnotationComposer,
          $$RoutineExercisesTableTableCreateCompanionBuilder,
          $$RoutineExercisesTableTableUpdateCompanionBuilder,
          (RoutineExercisesTableData, $$RoutineExercisesTableTableReferences),
          RoutineExercisesTableData,
          PrefetchHooks Function({bool routineId, bool routineSetsTableRefs})
        > {
  $$RoutineExercisesTableTableTableManager(
    _$AppDatabase db,
    $RoutineExercisesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineExercisesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RoutineExercisesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RoutineExercisesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> routineId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineExercisesTableCompanion(
                id: id,
                routineId: routineId,
                exerciseId: exerciseId,
                position: position,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String routineId,
                required String exerciseId,
                required int position,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineExercisesTableCompanion.insert(
                id: id,
                routineId: routineId,
                exerciseId: exerciseId,
                position: position,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineExercisesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({routineId = false, routineSetsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (routineSetsTableRefs) db.routineSetsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (routineId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.routineId,
                                    referencedTable:
                                        $$RoutineExercisesTableTableReferences
                                            ._routineIdTable(db),
                                    referencedColumn:
                                        $$RoutineExercisesTableTableReferences
                                            ._routineIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (routineSetsTableRefs)
                        await $_getPrefetchedData<
                          RoutineExercisesTableData,
                          $RoutineExercisesTableTable,
                          RoutineSetsTableData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$RoutineExercisesTableTableReferences
                                  ._routineSetsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutineExercisesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).routineSetsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoutineExercisesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineExercisesTableTable,
      RoutineExercisesTableData,
      $$RoutineExercisesTableTableFilterComposer,
      $$RoutineExercisesTableTableOrderingComposer,
      $$RoutineExercisesTableTableAnnotationComposer,
      $$RoutineExercisesTableTableCreateCompanionBuilder,
      $$RoutineExercisesTableTableUpdateCompanionBuilder,
      (RoutineExercisesTableData, $$RoutineExercisesTableTableReferences),
      RoutineExercisesTableData,
      PrefetchHooks Function({bool routineId, bool routineSetsTableRefs})
    >;
typedef $$RoutineSetsTableTableCreateCompanionBuilder =
    RoutineSetsTableCompanion Function({
      required String id,
      required String routineExerciseId,
      required int setNumber,
      Value<double?> weight,
      Value<int?> reps,
      Value<int?> restSeconds,
      Value<String> setType,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$RoutineSetsTableTableUpdateCompanionBuilder =
    RoutineSetsTableCompanion Function({
      Value<String> id,
      Value<String> routineExerciseId,
      Value<int> setNumber,
      Value<double?> weight,
      Value<int?> reps,
      Value<int?> restSeconds,
      Value<String> setType,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$RoutineSetsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RoutineSetsTableTable,
          RoutineSetsTableData
        > {
  $$RoutineSetsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutineExercisesTableTable _routineExerciseIdTable(
    _$AppDatabase db,
  ) => db.routineExercisesTable.createAlias(
    $_aliasNameGenerator(
      db.routineSetsTable.routineExerciseId,
      db.routineExercisesTable.id,
    ),
  );

  $$RoutineExercisesTableTableProcessedTableManager get routineExerciseId {
    final $_column = $_itemColumn<String>('routine_exercise_id')!;

    final manager = $$RoutineExercisesTableTableTableManager(
      $_db,
      $_db.routineExercisesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutineSetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineSetsTableTable> {
  $$RoutineSetsTableTableFilterComposer({
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

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setType => $composableBuilder(
    column: $table.setType,
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

  $$RoutineExercisesTableTableFilterComposer get routineExerciseId {
    final $$RoutineExercisesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.routineExerciseId,
          referencedTable: $db.routineExercisesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineExercisesTableTableFilterComposer(
                $db: $db,
                $table: $db.routineExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RoutineSetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineSetsTableTable> {
  $$RoutineSetsTableTableOrderingComposer({
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

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
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

  $$RoutineExercisesTableTableOrderingComposer get routineExerciseId {
    final $$RoutineExercisesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.routineExerciseId,
          referencedTable: $db.routineExercisesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineExercisesTableTableOrderingComposer(
                $db: $db,
                $table: $db.routineExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RoutineSetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineSetsTableTable> {
  $$RoutineSetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoutineExercisesTableTableAnnotationComposer get routineExerciseId {
    final $$RoutineExercisesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.routineExerciseId,
          referencedTable: $db.routineExercisesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineExercisesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.routineExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RoutineSetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineSetsTableTable,
          RoutineSetsTableData,
          $$RoutineSetsTableTableFilterComposer,
          $$RoutineSetsTableTableOrderingComposer,
          $$RoutineSetsTableTableAnnotationComposer,
          $$RoutineSetsTableTableCreateCompanionBuilder,
          $$RoutineSetsTableTableUpdateCompanionBuilder,
          (RoutineSetsTableData, $$RoutineSetsTableTableReferences),
          RoutineSetsTableData,
          PrefetchHooks Function({bool routineExerciseId})
        > {
  $$RoutineSetsTableTableTableManager(
    _$AppDatabase db,
    $RoutineSetsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineSetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineSetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineSetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> routineExerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> restSeconds = const Value.absent(),
                Value<String> setType = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineSetsTableCompanion(
                id: id,
                routineExerciseId: routineExerciseId,
                setNumber: setNumber,
                weight: weight,
                reps: reps,
                restSeconds: restSeconds,
                setType: setType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String routineExerciseId,
                required int setNumber,
                Value<double?> weight = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> restSeconds = const Value.absent(),
                Value<String> setType = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineSetsTableCompanion.insert(
                id: id,
                routineExerciseId: routineExerciseId,
                setNumber: setNumber,
                weight: weight,
                reps: reps,
                restSeconds: restSeconds,
                setType: setType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineSetsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (routineExerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.routineExerciseId,
                                referencedTable:
                                    $$RoutineSetsTableTableReferences
                                        ._routineExerciseIdTable(db),
                                referencedColumn:
                                    $$RoutineSetsTableTableReferences
                                        ._routineExerciseIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoutineSetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineSetsTableTable,
      RoutineSetsTableData,
      $$RoutineSetsTableTableFilterComposer,
      $$RoutineSetsTableTableOrderingComposer,
      $$RoutineSetsTableTableAnnotationComposer,
      $$RoutineSetsTableTableCreateCompanionBuilder,
      $$RoutineSetsTableTableUpdateCompanionBuilder,
      (RoutineSetsTableData, $$RoutineSetsTableTableReferences),
      RoutineSetsTableData,
      PrefetchHooks Function({bool routineExerciseId})
    >;
typedef $$WorkoutsTableTableCreateCompanionBuilder =
    WorkoutsTableCompanion Function({
      required String id,
      required String userId,
      Value<String?> routineId,
      Value<String?> gymId,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<String?> notes,
      Value<String?> trainerNotes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$WorkoutsTableTableUpdateCompanionBuilder =
    WorkoutsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String?> routineId,
      Value<String?> gymId,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<String?> notes,
      Value<String?> trainerNotes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$WorkoutsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutsTableTable, WorkoutsTableData> {
  $$WorkoutsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $WorkoutExercisesTableTable,
    List<WorkoutExercisesTableData>
  >
  _workoutExercisesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutExercisesTable,
        aliasName: $_aliasNameGenerator(
          db.workoutsTable.id,
          db.workoutExercisesTable.workoutId,
        ),
      );

  $$WorkoutExercisesTableTableProcessedTableManager
  get workoutExercisesTableRefs {
    final manager = $$WorkoutExercisesTableTableTableManager(
      $_db,
      $_db.workoutExercisesTable,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTableTable> {
  $$WorkoutsTableTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routineId => $composableBuilder(
    column: $table.routineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gymId => $composableBuilder(
    column: $table.gymId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainerNotes => $composableBuilder(
    column: $table.trainerNotes,
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

  Expression<bool> workoutExercisesTableRefs(
    Expression<bool> Function($$WorkoutExercisesTableTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutExercisesTable,
          getReferencedColumn: (t) => t.workoutId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExercisesTableTableFilterComposer(
                $db: $db,
                $table: $db.workoutExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTableTable> {
  $$WorkoutsTableTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routineId => $composableBuilder(
    column: $table.routineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gymId => $composableBuilder(
    column: $table.gymId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainerNotes => $composableBuilder(
    column: $table.trainerNotes,
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

class $$WorkoutsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTableTable> {
  $$WorkoutsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get routineId =>
      $composableBuilder(column: $table.routineId, builder: (column) => column);

  GeneratedColumn<String> get gymId =>
      $composableBuilder(column: $table.gymId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get trainerNotes => $composableBuilder(
    column: $table.trainerNotes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> workoutExercisesTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutExercisesTable,
          getReferencedColumn: (t) => t.workoutId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExercisesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTableTable,
          WorkoutsTableData,
          $$WorkoutsTableTableFilterComposer,
          $$WorkoutsTableTableOrderingComposer,
          $$WorkoutsTableTableAnnotationComposer,
          $$WorkoutsTableTableCreateCompanionBuilder,
          $$WorkoutsTableTableUpdateCompanionBuilder,
          (WorkoutsTableData, $$WorkoutsTableTableReferences),
          WorkoutsTableData,
          PrefetchHooks Function({bool workoutExercisesTableRefs})
        > {
  $$WorkoutsTableTableTableManager(_$AppDatabase db, $WorkoutsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> routineId = const Value.absent(),
                Value<String?> gymId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> trainerNotes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsTableCompanion(
                id: id,
                userId: userId,
                routineId: routineId,
                gymId: gymId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                notes: notes,
                trainerNotes: trainerNotes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String?> routineId = const Value.absent(),
                Value<String?> gymId = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> trainerNotes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsTableCompanion.insert(
                id: id,
                userId: userId,
                routineId: routineId,
                gymId: gymId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                notes: notes,
                trainerNotes: trainerNotes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExercisesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutExercisesTableRefs) db.workoutExercisesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutExercisesTableRefs)
                    await $_getPrefetchedData<
                      WorkoutsTableData,
                      $WorkoutsTableTable,
                      WorkoutExercisesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutsTableTableReferences
                          ._workoutExercisesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutExercisesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.workoutId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTableTable,
      WorkoutsTableData,
      $$WorkoutsTableTableFilterComposer,
      $$WorkoutsTableTableOrderingComposer,
      $$WorkoutsTableTableAnnotationComposer,
      $$WorkoutsTableTableCreateCompanionBuilder,
      $$WorkoutsTableTableUpdateCompanionBuilder,
      (WorkoutsTableData, $$WorkoutsTableTableReferences),
      WorkoutsTableData,
      PrefetchHooks Function({bool workoutExercisesTableRefs})
    >;
typedef $$WorkoutExercisesTableTableCreateCompanionBuilder =
    WorkoutExercisesTableCompanion Function({
      required String id,
      required String workoutId,
      required String exerciseId,
      Value<String?> routineExerciseId,
      required int position,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$WorkoutExercisesTableTableUpdateCompanionBuilder =
    WorkoutExercisesTableCompanion Function({
      Value<String> id,
      Value<String> workoutId,
      Value<String> exerciseId,
      Value<String?> routineExerciseId,
      Value<int> position,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$WorkoutExercisesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutExercisesTableTable,
          WorkoutExercisesTableData
        > {
  $$WorkoutExercisesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutsTableTable _workoutIdTable(_$AppDatabase db) =>
      db.workoutsTable.createAlias(
        $_aliasNameGenerator(
          db.workoutExercisesTable.workoutId,
          db.workoutsTable.id,
        ),
      );

  $$WorkoutsTableTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$WorkoutsTableTableTableManager(
      $_db,
      $_db.workoutsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTableTable, List<WorkoutSetsTableData>>
  _workoutSetsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSetsTable,
    aliasName: $_aliasNameGenerator(
      db.workoutExercisesTable.id,
      db.workoutSetsTable.workoutExerciseId,
    ),
  );

  $$WorkoutSetsTableTableProcessedTableManager get workoutSetsTableRefs {
    final manager =
        $$WorkoutSetsTableTableTableManager($_db, $_db.workoutSetsTable).filter(
          (f) => f.workoutExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _workoutSetsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutExercisesTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTableTable> {
  $$WorkoutExercisesTableTableFilterComposer({
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

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routineExerciseId => $composableBuilder(
    column: $table.routineExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$WorkoutsTableTableFilterComposer get workoutId {
    final $$WorkoutsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetsTableRefs(
    Expression<bool> Function($$WorkoutSetsTableTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetsTable,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutSetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTableTable> {
  $$WorkoutExercisesTableTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routineExerciseId => $composableBuilder(
    column: $table.routineExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$WorkoutsTableTableOrderingComposer get workoutId {
    final $$WorkoutsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableTableOrderingComposer(
            $db: $db,
            $table: $db.workoutsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExercisesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTableTable> {
  $$WorkoutExercisesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get routineExerciseId => $composableBuilder(
    column: $table.routineExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WorkoutsTableTableAnnotationComposer get workoutId {
    final $$WorkoutsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetsTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetsTable,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExercisesTableTable,
          WorkoutExercisesTableData,
          $$WorkoutExercisesTableTableFilterComposer,
          $$WorkoutExercisesTableTableOrderingComposer,
          $$WorkoutExercisesTableTableAnnotationComposer,
          $$WorkoutExercisesTableTableCreateCompanionBuilder,
          $$WorkoutExercisesTableTableUpdateCompanionBuilder,
          (WorkoutExercisesTableData, $$WorkoutExercisesTableTableReferences),
          WorkoutExercisesTableData,
          PrefetchHooks Function({bool workoutId, bool workoutSetsTableRefs})
        > {
  $$WorkoutExercisesTableTableTableManager(
    _$AppDatabase db,
    $WorkoutExercisesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExercisesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WorkoutExercisesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutExercisesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String?> routineExerciseId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesTableCompanion(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                routineExerciseId: routineExerciseId,
                position: position,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutId,
                required String exerciseId,
                Value<String?> routineExerciseId = const Value.absent(),
                required int position,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesTableCompanion.insert(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                routineExerciseId: routineExerciseId,
                position: position,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutExercisesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workoutId = false, workoutSetsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsTableRefs) db.workoutSetsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (workoutId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.workoutId,
                                    referencedTable:
                                        $$WorkoutExercisesTableTableReferences
                                            ._workoutIdTable(db),
                                    referencedColumn:
                                        $$WorkoutExercisesTableTableReferences
                                            ._workoutIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsTableRefs)
                        await $_getPrefetchedData<
                          WorkoutExercisesTableData,
                          $WorkoutExercisesTableTable,
                          WorkoutSetsTableData
                        >(
                          currentTable: table,
                          referencedTable:
                              $$WorkoutExercisesTableTableReferences
                                  ._workoutSetsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutExercisesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutExercisesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExercisesTableTable,
      WorkoutExercisesTableData,
      $$WorkoutExercisesTableTableFilterComposer,
      $$WorkoutExercisesTableTableOrderingComposer,
      $$WorkoutExercisesTableTableAnnotationComposer,
      $$WorkoutExercisesTableTableCreateCompanionBuilder,
      $$WorkoutExercisesTableTableUpdateCompanionBuilder,
      (WorkoutExercisesTableData, $$WorkoutExercisesTableTableReferences),
      WorkoutExercisesTableData,
      PrefetchHooks Function({bool workoutId, bool workoutSetsTableRefs})
    >;
typedef $$WorkoutSetsTableTableCreateCompanionBuilder =
    WorkoutSetsTableCompanion Function({
      required String id,
      required String workoutExerciseId,
      required int setNumber,
      Value<double?> weight,
      Value<int?> reps,
      Value<double?> rpe,
      Value<bool> completed,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSetsTableTableUpdateCompanionBuilder =
    WorkoutSetsTableCompanion Function({
      Value<String> id,
      Value<String> workoutExerciseId,
      Value<int> setNumber,
      Value<double?> weight,
      Value<int?> reps,
      Value<double?> rpe,
      Value<bool> completed,
      Value<String?> notes,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$WorkoutSetsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutSetsTableTable,
          WorkoutSetsTableData
        > {
  $$WorkoutSetsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutExercisesTableTable _workoutExerciseIdTable(
    _$AppDatabase db,
  ) => db.workoutExercisesTable.createAlias(
    $_aliasNameGenerator(
      db.workoutSetsTable.workoutExerciseId,
      db.workoutExercisesTable.id,
    ),
  );

  $$WorkoutExercisesTableTableProcessedTableManager get workoutExerciseId {
    final $_column = $_itemColumn<String>('workout_exercise_id')!;

    final manager = $$WorkoutExercisesTableTableTableManager(
      $_db,
      $_db.workoutExercisesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTableTable> {
  $$WorkoutSetsTableTableFilterComposer({
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

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$WorkoutExercisesTableTableFilterComposer get workoutExerciseId {
    final $$WorkoutExercisesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.workoutExerciseId,
          referencedTable: $db.workoutExercisesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExercisesTableTableFilterComposer(
                $db: $db,
                $table: $db.workoutExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTableTable> {
  $$WorkoutSetsTableTableOrderingComposer({
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

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

  $$WorkoutExercisesTableTableOrderingComposer get workoutExerciseId {
    final $$WorkoutExercisesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.workoutExerciseId,
          referencedTable: $db.workoutExercisesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExercisesTableTableOrderingComposer(
                $db: $db,
                $table: $db.workoutExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTableTable> {
  $$WorkoutSetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WorkoutExercisesTableTableAnnotationComposer get workoutExerciseId {
    final $$WorkoutExercisesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.workoutExerciseId,
          referencedTable: $db.workoutExercisesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExercisesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutExercisesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTableTable,
          WorkoutSetsTableData,
          $$WorkoutSetsTableTableFilterComposer,
          $$WorkoutSetsTableTableOrderingComposer,
          $$WorkoutSetsTableTableAnnotationComposer,
          $$WorkoutSetsTableTableCreateCompanionBuilder,
          $$WorkoutSetsTableTableUpdateCompanionBuilder,
          (WorkoutSetsTableData, $$WorkoutSetsTableTableReferences),
          WorkoutSetsTableData,
          PrefetchHooks Function({bool workoutExerciseId})
        > {
  $$WorkoutSetsTableTableTableManager(
    _$AppDatabase db,
    $WorkoutSetsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutExerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsTableCompanion(
                id: id,
                workoutExerciseId: workoutExerciseId,
                setNumber: setNumber,
                weight: weight,
                reps: reps,
                rpe: rpe,
                completed: completed,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutExerciseId,
                required int setNumber,
                Value<double?> weight = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsTableCompanion.insert(
                id: id,
                workoutExerciseId: workoutExerciseId,
                setNumber: setNumber,
                weight: weight,
                reps: reps,
                rpe: rpe,
                completed: completed,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutSetsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutExerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workoutExerciseId,
                                referencedTable:
                                    $$WorkoutSetsTableTableReferences
                                        ._workoutExerciseIdTable(db),
                                referencedColumn:
                                    $$WorkoutSetsTableTableReferences
                                        ._workoutExerciseIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTableTable,
      WorkoutSetsTableData,
      $$WorkoutSetsTableTableFilterComposer,
      $$WorkoutSetsTableTableOrderingComposer,
      $$WorkoutSetsTableTableAnnotationComposer,
      $$WorkoutSetsTableTableCreateCompanionBuilder,
      $$WorkoutSetsTableTableUpdateCompanionBuilder,
      (WorkoutSetsTableData, $$WorkoutSetsTableTableReferences),
      WorkoutSetsTableData,
      PrefetchHooks Function({bool workoutExerciseId})
    >;
typedef $$SyncOperationsTableTableCreateCompanionBuilder =
    SyncOperationsTableCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String operation,
      Value<String?> payload,
      required DateTime createdAt,
      Value<DateTime?> syncedAt,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$SyncOperationsTableTableUpdateCompanionBuilder =
    SyncOperationsTableCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<String?> payload,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$SyncOperationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOperationsTableTable> {
  $$SyncOperationsTableTableFilterComposer({
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

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOperationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOperationsTableTable> {
  $$SyncOperationsTableTableOrderingComposer({
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

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOperationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOperationsTableTable> {
  $$SyncOperationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SyncOperationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOperationsTableTable,
          SyncOperationsTableData,
          $$SyncOperationsTableTableFilterComposer,
          $$SyncOperationsTableTableOrderingComposer,
          $$SyncOperationsTableTableAnnotationComposer,
          $$SyncOperationsTableTableCreateCompanionBuilder,
          $$SyncOperationsTableTableUpdateCompanionBuilder,
          (
            SyncOperationsTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncOperationsTableTable,
              SyncOperationsTableData
            >,
          ),
          SyncOperationsTableData,
          PrefetchHooks Function()
        > {
  $$SyncOperationsTableTableTableManager(
    _$AppDatabase db,
    $SyncOperationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOperationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOperationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SyncOperationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationsTableCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                syncedAt: syncedAt,
                attemptCount: attemptCount,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operation,
                Value<String?> payload = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationsTableCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                syncedAt: syncedAt,
                attemptCount: attemptCount,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOperationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOperationsTableTable,
      SyncOperationsTableData,
      $$SyncOperationsTableTableFilterComposer,
      $$SyncOperationsTableTableOrderingComposer,
      $$SyncOperationsTableTableAnnotationComposer,
      $$SyncOperationsTableTableCreateCompanionBuilder,
      $$SyncOperationsTableTableUpdateCompanionBuilder,
      (
        SyncOperationsTableData,
        BaseReferences<
          _$AppDatabase,
          $SyncOperationsTableTable,
          SyncOperationsTableData
        >,
      ),
      SyncOperationsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExercisesTableTableTableManager get exercisesTable =>
      $$ExercisesTableTableTableManager(_db, _db.exercisesTable);
  $$RoutinesTableTableTableManager get routinesTable =>
      $$RoutinesTableTableTableManager(_db, _db.routinesTable);
  $$RoutineExercisesTableTableTableManager get routineExercisesTable =>
      $$RoutineExercisesTableTableTableManager(_db, _db.routineExercisesTable);
  $$RoutineSetsTableTableTableManager get routineSetsTable =>
      $$RoutineSetsTableTableTableManager(_db, _db.routineSetsTable);
  $$WorkoutsTableTableTableManager get workoutsTable =>
      $$WorkoutsTableTableTableManager(_db, _db.workoutsTable);
  $$WorkoutExercisesTableTableTableManager get workoutExercisesTable =>
      $$WorkoutExercisesTableTableTableManager(_db, _db.workoutExercisesTable);
  $$WorkoutSetsTableTableTableManager get workoutSetsTable =>
      $$WorkoutSetsTableTableTableManager(_db, _db.workoutSetsTable);
  $$SyncOperationsTableTableTableManager get syncOperationsTable =>
      $$SyncOperationsTableTableTableManager(_db, _db.syncOperationsTable);
}
