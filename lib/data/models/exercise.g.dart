// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExerciseCollection on Isar {
  IsarCollection<Exercise> get exercises => this.collection();
}

const ExerciseSchema = CollectionSchema(
  name: r'Exercise',
  id: 2972066467915231902,
  properties: {
    r'defaultDurationSeconds': PropertySchema(
      id: 0,
      name: r'defaultDurationSeconds',
      type: IsarType.long,
    ),
    r'defaultReps': PropertySchema(
      id: 1,
      name: r'defaultReps',
      type: IsarType.string,
    ),
    r'defaultRestSeconds': PropertySchema(
      id: 2,
      name: r'defaultRestSeconds',
      type: IsarType.long,
    ),
    r'defaultSets': PropertySchema(
      id: 3,
      name: r'defaultSets',
      type: IsarType.long,
    ),
    r'defaultWeight': PropertySchema(
      id: 4,
      name: r'defaultWeight',
      type: IsarType.double,
    ),
    r'hasSides': PropertySchema(
      id: 5,
      name: r'hasSides',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 7,
      name: r'notes',
      type: IsarType.string,
    ),
    r'tags': PropertySchema(
      id: 8,
      name: r'tags',
      type: IsarType.stringList,
    ),
    r'type': PropertySchema(
      id: 9,
      name: r'type',
      type: IsarType.string,
      enumMap: _ExercisetypeEnumValueMap,
    )
  },
  estimateSize: _exerciseEstimateSize,
  serialize: _exerciseSerialize,
  deserialize: _exerciseDeserialize,
  deserializeProp: _exerciseDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _exerciseGetId,
  getLinks: _exerciseGetLinks,
  attach: _exerciseAttach,
  version: '3.1.0+1',
);

int _exerciseEstimateSize(
  Exercise object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.defaultReps.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tags.length * 3;
  {
    for (var i = 0; i < object.tags.length; i++) {
      final value = object.tags[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _exerciseSerialize(
  Exercise object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.defaultDurationSeconds);
  writer.writeString(offsets[1], object.defaultReps);
  writer.writeLong(offsets[2], object.defaultRestSeconds);
  writer.writeLong(offsets[3], object.defaultSets);
  writer.writeDouble(offsets[4], object.defaultWeight);
  writer.writeBool(offsets[5], object.hasSides);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.notes);
  writer.writeStringList(offsets[8], object.tags);
  writer.writeString(offsets[9], object.type.name);
}

Exercise _exerciseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Exercise();
  object.defaultDurationSeconds = reader.readLong(offsets[0]);
  object.defaultReps = reader.readString(offsets[1]);
  object.defaultRestSeconds = reader.readLong(offsets[2]);
  object.defaultSets = reader.readLong(offsets[3]);
  object.defaultWeight = reader.readDoubleOrNull(offsets[4]);
  object.hasSides = reader.readBool(offsets[5]);
  object.id = id;
  object.name = reader.readString(offsets[6]);
  object.notes = reader.readStringOrNull(offsets[7]);
  object.tags = reader.readStringList(offsets[8]) ?? [];
  object.type =
      _ExercisetypeValueEnumMap[reader.readStringOrNull(offsets[9])] ??
          ExerciseType.weightReps;
  return object;
}

P _exerciseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringList(offset) ?? []) as P;
    case 9:
      return (_ExercisetypeValueEnumMap[reader.readStringOrNull(offset)] ??
          ExerciseType.weightReps) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ExercisetypeEnumValueMap = {
  r'weightReps': r'weightReps',
  r'timed': r'timed',
  r'repsOnly': r'repsOnly',
  r'distancePace': r'distancePace',
};
const _ExercisetypeValueEnumMap = {
  r'weightReps': ExerciseType.weightReps,
  r'timed': ExerciseType.timed,
  r'repsOnly': ExerciseType.repsOnly,
  r'distancePace': ExerciseType.distancePace,
};

Id _exerciseGetId(Exercise object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _exerciseGetLinks(Exercise object) {
  return [];
}

void _exerciseAttach(IsarCollection<dynamic> col, Id id, Exercise object) {
  object.id = id;
}

extension ExerciseQueryWhereSort on QueryBuilder<Exercise, Exercise, QWhere> {
  QueryBuilder<Exercise, Exercise, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExerciseQueryWhere on QueryBuilder<Exercise, Exercise, QWhereClause> {
  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExerciseQueryFilter
    on QueryBuilder<Exercise, Exercise, QFilterCondition> {
  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultDurationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultDurationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultRepsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultRepsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultRepsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultRepsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultReps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultRepsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'defaultReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultRepsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'defaultReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultRepsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'defaultReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultRepsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'defaultReps',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultRepsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultReps',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultRepsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'defaultReps',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultRestSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultRestSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultRestSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultRestSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultRestSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultRestSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultRestSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultRestSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultSetsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultSets',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultSetsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultSets',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultSetsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultSets',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultSetsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultSets',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultWeightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'defaultWeight',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultWeightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'defaultWeight',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultWeightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      defaultWeightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultWeightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> defaultWeightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> hasSidesEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasSides',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> tagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> typeEqualTo(
    ExerciseType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> typeGreaterThan(
    ExerciseType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> typeLessThan(
    ExerciseType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> typeBetween(
    ExerciseType lower,
    ExerciseType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension ExerciseQueryObject
    on QueryBuilder<Exercise, Exercise, QFilterCondition> {}

extension ExerciseQueryLinks
    on QueryBuilder<Exercise, Exercise, QFilterCondition> {}

extension ExerciseQuerySortBy on QueryBuilder<Exercise, Exercise, QSortBy> {
  QueryBuilder<Exercise, Exercise, QAfterSortBy>
      sortByDefaultDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy>
      sortByDefaultDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByDefaultReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReps', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByDefaultRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReps', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByDefaultRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRestSeconds', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy>
      sortByDefaultRestSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRestSeconds', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByDefaultSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSets', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByDefaultSetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSets', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByDefaultWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultWeight', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByDefaultWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultWeight', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByHasSides() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSides', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByHasSidesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSides', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension ExerciseQuerySortThenBy
    on QueryBuilder<Exercise, Exercise, QSortThenBy> {
  QueryBuilder<Exercise, Exercise, QAfterSortBy>
      thenByDefaultDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy>
      thenByDefaultDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByDefaultReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReps', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByDefaultRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReps', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByDefaultRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRestSeconds', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy>
      thenByDefaultRestSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRestSeconds', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByDefaultSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSets', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByDefaultSetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSets', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByDefaultWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultWeight', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByDefaultWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultWeight', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByHasSides() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSides', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByHasSidesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSides', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension ExerciseQueryWhereDistinct
    on QueryBuilder<Exercise, Exercise, QDistinct> {
  QueryBuilder<Exercise, Exercise, QDistinct>
      distinctByDefaultDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultDurationSeconds');
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByDefaultReps(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultReps', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByDefaultRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultRestSeconds');
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByDefaultSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultSets');
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByDefaultWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultWeight');
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByHasSides() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasSides');
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension ExerciseQueryProperty
    on QueryBuilder<Exercise, Exercise, QQueryProperty> {
  QueryBuilder<Exercise, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Exercise, int, QQueryOperations>
      defaultDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultDurationSeconds');
    });
  }

  QueryBuilder<Exercise, String, QQueryOperations> defaultRepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultReps');
    });
  }

  QueryBuilder<Exercise, int, QQueryOperations> defaultRestSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultRestSeconds');
    });
  }

  QueryBuilder<Exercise, int, QQueryOperations> defaultSetsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultSets');
    });
  }

  QueryBuilder<Exercise, double?, QQueryOperations> defaultWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultWeight');
    });
  }

  QueryBuilder<Exercise, bool, QQueryOperations> hasSidesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasSides');
    });
  }

  QueryBuilder<Exercise, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Exercise, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Exercise, List<String>, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<Exercise, ExerciseType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
