// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_session.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrainingSessionCollection on Isar {
  IsarCollection<TrainingSession> get trainingSessions => this.collection();
}

const TrainingSessionSchema = CollectionSchema(
  name: r'TrainingSession',
  id: -8612409335690718969,
  properties: {
    r'avgPaceSeconds': PropertySchema(
      id: 0,
      name: r'avgPaceSeconds',
      type: IsarType.double,
    ),
    r'caloriesBurned': PropertySchema(
      id: 1,
      name: r'caloriesBurned',
      type: IsarType.long,
    ),
    r'completedSets': PropertySchema(
      id: 2,
      name: r'completedSets',
      type: IsarType.long,
    ),
    r'durationSeconds': PropertySchema(
      id: 3,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'endTime': PropertySchema(
      id: 4,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'exercises': PropertySchema(
      id: 5,
      name: r'exercises',
      type: IsarType.objectList,
      target: r'SessionExercise',
    ),
    r'kmPaces': PropertySchema(
      id: 6,
      name: r'kmPaces',
      type: IsarType.doubleList,
    ),
    r'macroCycleId': PropertySchema(
      id: 7,
      name: r'macroCycleId',
      type: IsarType.long,
    ),
    r'macroPhaseIndex': PropertySchema(
      id: 8,
      name: r'macroPhaseIndex',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 9,
      name: r'notes',
      type: IsarType.string,
    ),
    r'perceivedEffort': PropertySchema(
      id: 10,
      name: r'perceivedEffort',
      type: IsarType.long,
    ),
    r'prCount': PropertySchema(
      id: 11,
      name: r'prCount',
      type: IsarType.long,
    ),
    r'startTime': PropertySchema(
      id: 12,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'totalActiveSeconds': PropertySchema(
      id: 13,
      name: r'totalActiveSeconds',
      type: IsarType.long,
    ),
    r'totalDistanceKm': PropertySchema(
      id: 14,
      name: r'totalDistanceKm',
      type: IsarType.double,
    ),
    r'totalVolume': PropertySchema(
      id: 15,
      name: r'totalVolume',
      type: IsarType.double,
    ),
    r'workoutColorValue': PropertySchema(
      id: 16,
      name: r'workoutColorValue',
      type: IsarType.long,
    ),
    r'workoutId': PropertySchema(
      id: 17,
      name: r'workoutId',
      type: IsarType.long,
    ),
    r'workoutName': PropertySchema(
      id: 18,
      name: r'workoutName',
      type: IsarType.string,
    ),
    r'workoutType': PropertySchema(
      id: 19,
      name: r'workoutType',
      type: IsarType.string,
      enumMap: _TrainingSessionworkoutTypeEnumValueMap,
    )
  },
  estimateSize: _trainingSessionEstimateSize,
  serialize: _trainingSessionSerialize,
  deserialize: _trainingSessionDeserialize,
  deserializeProp: _trainingSessionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'SessionExercise': SessionExerciseSchema,
    r'SessionSet': SessionSetSchema
  },
  getId: _trainingSessionGetId,
  getLinks: _trainingSessionGetLinks,
  attach: _trainingSessionAttach,
  version: '3.1.0+1',
);

int _trainingSessionEstimateSize(
  TrainingSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.exercises.length * 3;
  {
    final offsets = allOffsets[SessionExercise]!;
    for (var i = 0; i < object.exercises.length; i++) {
      final value = object.exercises[i];
      bytesCount +=
          SessionExerciseSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.kmPaces.length * 8;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.workoutName.length * 3;
  bytesCount += 3 + object.workoutType.name.length * 3;
  return bytesCount;
}

void _trainingSessionSerialize(
  TrainingSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.avgPaceSeconds);
  writer.writeLong(offsets[1], object.caloriesBurned);
  writer.writeLong(offsets[2], object.completedSets);
  writer.writeLong(offsets[3], object.durationSeconds);
  writer.writeDateTime(offsets[4], object.endTime);
  writer.writeObjectList<SessionExercise>(
    offsets[5],
    allOffsets,
    SessionExerciseSchema.serialize,
    object.exercises,
  );
  writer.writeDoubleList(offsets[6], object.kmPaces);
  writer.writeLong(offsets[7], object.macroCycleId);
  writer.writeLong(offsets[8], object.macroPhaseIndex);
  writer.writeString(offsets[9], object.notes);
  writer.writeLong(offsets[10], object.perceivedEffort);
  writer.writeLong(offsets[11], object.prCount);
  writer.writeDateTime(offsets[12], object.startTime);
  writer.writeLong(offsets[13], object.totalActiveSeconds);
  writer.writeDouble(offsets[14], object.totalDistanceKm);
  writer.writeDouble(offsets[15], object.totalVolume);
  writer.writeLong(offsets[16], object.workoutColorValue);
  writer.writeLong(offsets[17], object.workoutId);
  writer.writeString(offsets[18], object.workoutName);
  writer.writeString(offsets[19], object.workoutType.name);
}

TrainingSession _trainingSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrainingSession();
  object.avgPaceSeconds = reader.readDouble(offsets[0]);
  object.caloriesBurned = reader.readLongOrNull(offsets[1]);
  object.completedSets = reader.readLong(offsets[2]);
  object.durationSeconds = reader.readLong(offsets[3]);
  object.endTime = reader.readDateTimeOrNull(offsets[4]);
  object.exercises = reader.readObjectList<SessionExercise>(
        offsets[5],
        SessionExerciseSchema.deserialize,
        allOffsets,
        SessionExercise(),
      ) ??
      [];
  object.id = id;
  object.kmPaces = reader.readDoubleList(offsets[6]) ?? [];
  object.macroCycleId = reader.readLongOrNull(offsets[7]);
  object.macroPhaseIndex = reader.readLongOrNull(offsets[8]);
  object.notes = reader.readStringOrNull(offsets[9]);
  object.perceivedEffort = reader.readLongOrNull(offsets[10]);
  object.prCount = reader.readLong(offsets[11]);
  object.startTime = reader.readDateTime(offsets[12]);
  object.totalActiveSeconds = reader.readLong(offsets[13]);
  object.totalDistanceKm = reader.readDouble(offsets[14]);
  object.totalVolume = reader.readDouble(offsets[15]);
  object.workoutColorValue = reader.readLong(offsets[16]);
  object.workoutId = reader.readLongOrNull(offsets[17]);
  object.workoutName = reader.readString(offsets[18]);
  object.workoutType = _TrainingSessionworkoutTypeValueEnumMap[
          reader.readStringOrNull(offsets[19])] ??
      WorkoutType.musculacao;
  return object;
}

P _trainingSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readObjectList<SessionExercise>(
            offset,
            SessionExerciseSchema.deserialize,
            allOffsets,
            SessionExercise(),
          ) ??
          []) as P;
    case 6:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readLongOrNull(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (_TrainingSessionworkoutTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          WorkoutType.musculacao) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TrainingSessionworkoutTypeEnumValueMap = {
  r'musculacao': r'musculacao',
  r'corrida': r'corrida',
  r'drills': r'drills',
  r'bola': r'bola',
  r'mobilidade': r'mobilidade',
  r'custom': r'custom',
};
const _TrainingSessionworkoutTypeValueEnumMap = {
  r'musculacao': WorkoutType.musculacao,
  r'corrida': WorkoutType.corrida,
  r'drills': WorkoutType.drills,
  r'bola': WorkoutType.bola,
  r'mobilidade': WorkoutType.mobilidade,
  r'custom': WorkoutType.custom,
};

Id _trainingSessionGetId(TrainingSession object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _trainingSessionGetLinks(TrainingSession object) {
  return [];
}

void _trainingSessionAttach(
    IsarCollection<dynamic> col, Id id, TrainingSession object) {
  object.id = id;
}

extension TrainingSessionQueryWhereSort
    on QueryBuilder<TrainingSession, TrainingSession, QWhere> {
  QueryBuilder<TrainingSession, TrainingSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TrainingSessionQueryWhere
    on QueryBuilder<TrainingSession, TrainingSession, QWhereClause> {
  QueryBuilder<TrainingSession, TrainingSession, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<TrainingSession, TrainingSession, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterWhereClause> idBetween(
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

extension TrainingSessionQueryFilter
    on QueryBuilder<TrainingSession, TrainingSession, QFilterCondition> {
  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      avgPaceSecondsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgPaceSeconds',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      avgPaceSecondsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgPaceSeconds',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      avgPaceSecondsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgPaceSeconds',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      avgPaceSecondsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgPaceSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      caloriesBurnedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'caloriesBurned',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      caloriesBurnedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'caloriesBurned',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      caloriesBurnedEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'caloriesBurned',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      caloriesBurnedGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'caloriesBurned',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      caloriesBurnedLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'caloriesBurned',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      caloriesBurnedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'caloriesBurned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      completedSetsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedSets',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      completedSetsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedSets',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      completedSetsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedSets',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      completedSetsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedSets',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      durationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      durationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      durationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      durationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      endTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      exercisesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      exercisesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      exercisesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      exercisesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      exercisesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      exercisesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      kmPacesElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kmPaces',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      kmPacesElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kmPaces',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      kmPacesElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kmPaces',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      kmPacesElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kmPaces',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      kmPacesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmPaces',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      kmPacesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmPaces',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      kmPacesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmPaces',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      kmPacesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmPaces',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      kmPacesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmPaces',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      kmPacesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmPaces',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroCycleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'macroCycleId',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroCycleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'macroCycleId',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroCycleIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'macroCycleId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroCycleIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'macroCycleId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroCycleIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'macroCycleId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroCycleIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'macroCycleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroPhaseIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'macroPhaseIndex',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroPhaseIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'macroPhaseIndex',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroPhaseIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'macroPhaseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroPhaseIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'macroPhaseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroPhaseIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'macroPhaseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      macroPhaseIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'macroPhaseIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesEqualTo(
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

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesGreaterThan(
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

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesLessThan(
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

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesBetween(
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

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesStartsWith(
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

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesEndsWith(
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

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      perceivedEffortIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'perceivedEffort',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      perceivedEffortIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'perceivedEffort',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      perceivedEffortEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'perceivedEffort',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      perceivedEffortGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'perceivedEffort',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      perceivedEffortLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'perceivedEffort',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      perceivedEffortBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'perceivedEffort',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      prCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      prCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      prCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      prCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalActiveSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalActiveSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalActiveSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalActiveSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalActiveSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalActiveSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalActiveSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalActiveSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalDistanceKmEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDistanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalDistanceKmGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDistanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalDistanceKmLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDistanceKm',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalDistanceKmBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDistanceKm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      totalVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutColorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutColorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutColorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'workoutId',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'workoutId',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutId',
        value: value,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'workoutName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'workoutName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workoutName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workoutName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutName',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workoutName',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutTypeEqualTo(
    WorkoutType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutTypeGreaterThan(
    WorkoutType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutTypeLessThan(
    WorkoutType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutTypeBetween(
    WorkoutType lower,
    WorkoutType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'workoutType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'workoutType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workoutType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workoutType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutType',
        value: '',
      ));
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      workoutTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workoutType',
        value: '',
      ));
    });
  }
}

extension TrainingSessionQueryObject
    on QueryBuilder<TrainingSession, TrainingSession, QFilterCondition> {
  QueryBuilder<TrainingSession, TrainingSession, QAfterFilterCondition>
      exercisesElement(FilterQuery<SessionExercise> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'exercises');
    });
  }
}

extension TrainingSessionQueryLinks
    on QueryBuilder<TrainingSession, TrainingSession, QFilterCondition> {}

extension TrainingSessionQuerySortBy
    on QueryBuilder<TrainingSession, TrainingSession, QSortBy> {
  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByAvgPaceSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPaceSeconds', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByAvgPaceSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPaceSeconds', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByCaloriesBurned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesBurned', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByCaloriesBurnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesBurned', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByCompletedSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSets', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByCompletedSetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSets', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByMacroCycleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroCycleId', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByMacroCycleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroCycleId', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByMacroPhaseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroPhaseIndex', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByMacroPhaseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroPhaseIndex', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByPerceivedEffort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'perceivedEffort', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByPerceivedEffortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'perceivedEffort', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy> sortByPrCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prCount', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByPrCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prCount', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByTotalActiveSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalActiveSeconds', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByTotalActiveSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalActiveSeconds', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByTotalDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceKm', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByTotalDistanceKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceKm', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByTotalVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByWorkoutColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutColorValue', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByWorkoutColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutColorValue', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByWorkoutId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutId', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByWorkoutIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutId', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByWorkoutName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutName', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByWorkoutNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutName', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByWorkoutType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutType', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      sortByWorkoutTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutType', Sort.desc);
    });
  }
}

extension TrainingSessionQuerySortThenBy
    on QueryBuilder<TrainingSession, TrainingSession, QSortThenBy> {
  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByAvgPaceSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPaceSeconds', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByAvgPaceSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPaceSeconds', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByCaloriesBurned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesBurned', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByCaloriesBurnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesBurned', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByCompletedSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSets', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByCompletedSetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSets', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByMacroCycleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroCycleId', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByMacroCycleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroCycleId', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByMacroPhaseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroPhaseIndex', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByMacroPhaseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroPhaseIndex', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByPerceivedEffort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'perceivedEffort', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByPerceivedEffortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'perceivedEffort', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy> thenByPrCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prCount', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByPrCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prCount', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByTotalActiveSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalActiveSeconds', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByTotalActiveSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalActiveSeconds', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByTotalDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceKm', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByTotalDistanceKmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceKm', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByTotalVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByWorkoutColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutColorValue', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByWorkoutColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutColorValue', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByWorkoutId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutId', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByWorkoutIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutId', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByWorkoutName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutName', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByWorkoutNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutName', Sort.desc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByWorkoutType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutType', Sort.asc);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QAfterSortBy>
      thenByWorkoutTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutType', Sort.desc);
    });
  }
}

extension TrainingSessionQueryWhereDistinct
    on QueryBuilder<TrainingSession, TrainingSession, QDistinct> {
  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByAvgPaceSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgPaceSeconds');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByCaloriesBurned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'caloriesBurned');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByCompletedSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedSets');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByKmPaces() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kmPaces');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByMacroCycleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'macroCycleId');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByMacroPhaseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'macroPhaseIndex');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByPerceivedEffort() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'perceivedEffort');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByPrCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prCount');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByTotalActiveSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalActiveSeconds');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByTotalDistanceKm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDistanceKm');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalVolume');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByWorkoutColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutColorValue');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByWorkoutId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutId');
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByWorkoutName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrainingSession, TrainingSession, QDistinct>
      distinctByWorkoutType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutType', caseSensitive: caseSensitive);
    });
  }
}

extension TrainingSessionQueryProperty
    on QueryBuilder<TrainingSession, TrainingSession, QQueryProperty> {
  QueryBuilder<TrainingSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TrainingSession, double, QQueryOperations>
      avgPaceSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgPaceSeconds');
    });
  }

  QueryBuilder<TrainingSession, int?, QQueryOperations>
      caloriesBurnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'caloriesBurned');
    });
  }

  QueryBuilder<TrainingSession, int, QQueryOperations> completedSetsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedSets');
    });
  }

  QueryBuilder<TrainingSession, int, QQueryOperations>
      durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<TrainingSession, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<TrainingSession, List<SessionExercise>, QQueryOperations>
      exercisesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exercises');
    });
  }

  QueryBuilder<TrainingSession, List<double>, QQueryOperations>
      kmPacesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kmPaces');
    });
  }

  QueryBuilder<TrainingSession, int?, QQueryOperations> macroCycleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'macroCycleId');
    });
  }

  QueryBuilder<TrainingSession, int?, QQueryOperations>
      macroPhaseIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'macroPhaseIndex');
    });
  }

  QueryBuilder<TrainingSession, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<TrainingSession, int?, QQueryOperations>
      perceivedEffortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'perceivedEffort');
    });
  }

  QueryBuilder<TrainingSession, int, QQueryOperations> prCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prCount');
    });
  }

  QueryBuilder<TrainingSession, DateTime, QQueryOperations>
      startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<TrainingSession, int, QQueryOperations>
      totalActiveSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalActiveSeconds');
    });
  }

  QueryBuilder<TrainingSession, double, QQueryOperations>
      totalDistanceKmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDistanceKm');
    });
  }

  QueryBuilder<TrainingSession, double, QQueryOperations>
      totalVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalVolume');
    });
  }

  QueryBuilder<TrainingSession, int, QQueryOperations>
      workoutColorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutColorValue');
    });
  }

  QueryBuilder<TrainingSession, int?, QQueryOperations> workoutIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutId');
    });
  }

  QueryBuilder<TrainingSession, String, QQueryOperations>
      workoutNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutName');
    });
  }

  QueryBuilder<TrainingSession, WorkoutType, QQueryOperations>
      workoutTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutType');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SessionExerciseSchema = Schema(
  name: r'SessionExercise',
  id: -3699433427391073826,
  properties: {
    r'exerciseId': PropertySchema(
      id: 0,
      name: r'exerciseId',
      type: IsarType.long,
    ),
    r'exerciseName': PropertySchema(
      id: 1,
      name: r'exerciseName',
      type: IsarType.string,
    ),
    r'sets': PropertySchema(
      id: 2,
      name: r'sets',
      type: IsarType.objectList,
      target: r'SessionSet',
    )
  },
  estimateSize: _sessionExerciseEstimateSize,
  serialize: _sessionExerciseSerialize,
  deserialize: _sessionExerciseDeserialize,
  deserializeProp: _sessionExerciseDeserializeProp,
);

int _sessionExerciseEstimateSize(
  SessionExercise object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.exerciseName.length * 3;
  bytesCount += 3 + object.sets.length * 3;
  {
    final offsets = allOffsets[SessionSet]!;
    for (var i = 0; i < object.sets.length; i++) {
      final value = object.sets[i];
      bytesCount += SessionSetSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _sessionExerciseSerialize(
  SessionExercise object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.exerciseId);
  writer.writeString(offsets[1], object.exerciseName);
  writer.writeObjectList<SessionSet>(
    offsets[2],
    allOffsets,
    SessionSetSchema.serialize,
    object.sets,
  );
}

SessionExercise _sessionExerciseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SessionExercise();
  object.exerciseId = reader.readLongOrNull(offsets[0]);
  object.exerciseName = reader.readString(offsets[1]);
  object.sets = reader.readObjectList<SessionSet>(
        offsets[2],
        SessionSetSchema.deserialize,
        allOffsets,
        SessionSet(),
      ) ??
      [];
  return object;
}

P _sessionExerciseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readObjectList<SessionSet>(
            offset,
            SessionSetSchema.deserialize,
            allOffsets,
            SessionSet(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SessionExerciseQueryFilter
    on QueryBuilder<SessionExercise, SessionExercise, QFilterCondition> {
  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exerciseId',
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exerciseId',
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseId',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseId',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseId',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseName',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      exerciseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseName',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      setsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      setsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      setsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      setsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      setsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      setsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SessionExerciseQueryObject
    on QueryBuilder<SessionExercise, SessionExercise, QFilterCondition> {
  QueryBuilder<SessionExercise, SessionExercise, QAfterFilterCondition>
      setsElement(FilterQuery<SessionSet> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sets');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SessionSetSchema = Schema(
  name: r'SessionSet',
  id: 7378379328497303479,
  properties: {
    r'completed': PropertySchema(
      id: 0,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'durationSeconds': PropertySchema(
      id: 1,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'isPR': PropertySchema(
      id: 2,
      name: r'isPR',
      type: IsarType.bool,
    ),
    r'reps': PropertySchema(
      id: 3,
      name: r'reps',
      type: IsarType.long,
    ),
    r'setIndex': PropertySchema(
      id: 4,
      name: r'setIndex',
      type: IsarType.long,
    ),
    r'weight': PropertySchema(
      id: 5,
      name: r'weight',
      type: IsarType.double,
    )
  },
  estimateSize: _sessionSetEstimateSize,
  serialize: _sessionSetSerialize,
  deserialize: _sessionSetDeserialize,
  deserializeProp: _sessionSetDeserializeProp,
);

int _sessionSetEstimateSize(
  SessionSet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sessionSetSerialize(
  SessionSet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completed);
  writer.writeLong(offsets[1], object.durationSeconds);
  writer.writeBool(offsets[2], object.isPR);
  writer.writeLong(offsets[3], object.reps);
  writer.writeLong(offsets[4], object.setIndex);
  writer.writeDouble(offsets[5], object.weight);
}

SessionSet _sessionSetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SessionSet();
  object.completed = reader.readBool(offsets[0]);
  object.durationSeconds = reader.readLongOrNull(offsets[1]);
  object.isPR = reader.readBool(offsets[2]);
  object.reps = reader.readLongOrNull(offsets[3]);
  object.setIndex = reader.readLong(offsets[4]);
  object.weight = reader.readDoubleOrNull(offsets[5]);
  return object;
}

P _sessionSetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SessionSetQueryFilter
    on QueryBuilder<SessionSet, SessionSet, QFilterCondition> {
  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> completedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition>
      durationSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationSeconds',
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition>
      durationSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationSeconds',
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition>
      durationSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition>
      durationSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition>
      durationSecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition>
      durationSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> isPREqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPR',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> repsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reps',
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> repsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reps',
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> repsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> repsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> repsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reps',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> repsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> setIndexEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition>
      setIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> setIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> setIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> weightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition>
      weightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> weightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> weightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> weightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SessionSet, SessionSet, QAfterFilterCondition> weightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension SessionSetQueryObject
    on QueryBuilder<SessionSet, SessionSet, QFilterCondition> {}
