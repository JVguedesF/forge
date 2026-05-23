// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'macro_cycle.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMacroCycleCollection on Isar {
  IsarCollection<MacroCycle> get macroCycles => this.collection();
}

const MacroCycleSchema = CollectionSchema(
  name: r'MacroCycle',
  id: -5691367745223836183,
  properties: {
    r'currentPhaseIndex': PropertySchema(
      id: 0,
      name: r'currentPhaseIndex',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 2,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'phases': PropertySchema(
      id: 4,
      name: r'phases',
      type: IsarType.objectList,
      target: r'Phase',
    ),
    r'startDate': PropertySchema(
      id: 5,
      name: r'startDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _macroCycleEstimateSize,
  serialize: _macroCycleSerialize,
  deserialize: _macroCycleDeserialize,
  deserializeProp: _macroCycleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'Phase': PhaseSchema,
    r'DaySchedule': DayScheduleSchema,
    r'PhaseGoal': PhaseGoalSchema
  },
  getId: _macroCycleGetId,
  getLinks: _macroCycleGetLinks,
  attach: _macroCycleAttach,
  version: '3.1.0+1',
);

int _macroCycleEstimateSize(
  MacroCycle object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.phases.length * 3;
  {
    final offsets = allOffsets[Phase]!;
    for (var i = 0; i < object.phases.length; i++) {
      final value = object.phases[i];
      bytesCount += PhaseSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _macroCycleSerialize(
  MacroCycle object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentPhaseIndex);
  writer.writeString(offsets[1], object.description);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeString(offsets[3], object.name);
  writer.writeObjectList<Phase>(
    offsets[4],
    allOffsets,
    PhaseSchema.serialize,
    object.phases,
  );
  writer.writeDateTime(offsets[5], object.startDate);
}

MacroCycle _macroCycleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MacroCycle();
  object.currentPhaseIndex = reader.readLong(offsets[0]);
  object.description = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.isActive = reader.readBool(offsets[2]);
  object.name = reader.readString(offsets[3]);
  object.phases = reader.readObjectList<Phase>(
        offsets[4],
        PhaseSchema.deserialize,
        allOffsets,
        Phase(),
      ) ??
      [];
  object.startDate = reader.readDateTime(offsets[5]);
  return object;
}

P _macroCycleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readObjectList<Phase>(
            offset,
            PhaseSchema.deserialize,
            allOffsets,
            Phase(),
          ) ??
          []) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _macroCycleGetId(MacroCycle object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _macroCycleGetLinks(MacroCycle object) {
  return [];
}

void _macroCycleAttach(IsarCollection<dynamic> col, Id id, MacroCycle object) {
  object.id = id;
}

extension MacroCycleQueryWhereSort
    on QueryBuilder<MacroCycle, MacroCycle, QWhere> {
  QueryBuilder<MacroCycle, MacroCycle, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MacroCycleQueryWhere
    on QueryBuilder<MacroCycle, MacroCycle, QWhereClause> {
  QueryBuilder<MacroCycle, MacroCycle, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterWhereClause> idBetween(
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

extension MacroCycleQueryFilter
    on QueryBuilder<MacroCycle, MacroCycle, QFilterCondition> {
  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      currentPhaseIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentPhaseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      currentPhaseIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentPhaseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      currentPhaseIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentPhaseIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      currentPhaseIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentPhaseIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> isActiveEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> nameContains(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      phasesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'phases',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> phasesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'phases',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      phasesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'phases',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      phasesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'phases',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      phasesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'phases',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      phasesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'phases',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> startDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition>
      startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MacroCycleQueryObject
    on QueryBuilder<MacroCycle, MacroCycle, QFilterCondition> {
  QueryBuilder<MacroCycle, MacroCycle, QAfterFilterCondition> phasesElement(
      FilterQuery<Phase> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'phases');
    });
  }
}

extension MacroCycleQueryLinks
    on QueryBuilder<MacroCycle, MacroCycle, QFilterCondition> {}

extension MacroCycleQuerySortBy
    on QueryBuilder<MacroCycle, MacroCycle, QSortBy> {
  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> sortByCurrentPhaseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseIndex', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy>
      sortByCurrentPhaseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseIndex', Sort.desc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }
}

extension MacroCycleQuerySortThenBy
    on QueryBuilder<MacroCycle, MacroCycle, QSortThenBy> {
  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenByCurrentPhaseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseIndex', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy>
      thenByCurrentPhaseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseIndex', Sort.desc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QAfterSortBy> thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }
}

extension MacroCycleQueryWhereDistinct
    on QueryBuilder<MacroCycle, MacroCycle, QDistinct> {
  QueryBuilder<MacroCycle, MacroCycle, QDistinct>
      distinctByCurrentPhaseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPhaseIndex');
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MacroCycle, MacroCycle, QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }
}

extension MacroCycleQueryProperty
    on QueryBuilder<MacroCycle, MacroCycle, QQueryProperty> {
  QueryBuilder<MacroCycle, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MacroCycle, int, QQueryOperations> currentPhaseIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPhaseIndex');
    });
  }

  QueryBuilder<MacroCycle, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<MacroCycle, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<MacroCycle, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<MacroCycle, List<Phase>, QQueryOperations> phasesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phases');
    });
  }

  QueryBuilder<MacroCycle, DateTime, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PhaseSchema = Schema(
  name: r'Phase',
  id: -2090859306872267,
  properties: {
    r'completedSessions': PropertySchema(
      id: 0,
      name: r'completedSessions',
      type: IsarType.long,
    ),
    r'deloadWeeks': PropertySchema(
      id: 1,
      name: r'deloadWeeks',
      type: IsarType.longList,
    ),
    r'durationWeeks': PropertySchema(
      id: 2,
      name: r'durationWeeks',
      type: IsarType.long,
    ),
    r'goals': PropertySchema(
      id: 3,
      name: r'goals',
      type: IsarType.objectList,
      target: r'PhaseGoal',
    ),
    r'intensityPercent': PropertySchema(
      id: 4,
      name: r'intensityPercent',
      type: IsarType.double,
    ),
    r'isCompleted': PropertySchema(
      id: 5,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'objective': PropertySchema(
      id: 7,
      name: r'objective',
      type: IsarType.string,
    ),
    r'recommendedReps': PropertySchema(
      id: 8,
      name: r'recommendedReps',
      type: IsarType.string,
    ),
    r'recommendedSets': PropertySchema(
      id: 9,
      name: r'recommendedSets',
      type: IsarType.long,
    ),
    r'startDate': PropertySchema(
      id: 10,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'targetSessions': PropertySchema(
      id: 11,
      name: r'targetSessions',
      type: IsarType.long,
    ),
    r'weeklySchedule': PropertySchema(
      id: 12,
      name: r'weeklySchedule',
      type: IsarType.objectList,
      target: r'DaySchedule',
    )
  },
  estimateSize: _phaseEstimateSize,
  serialize: _phaseSerialize,
  deserialize: _phaseDeserialize,
  deserializeProp: _phaseDeserializeProp,
);

int _phaseEstimateSize(
  Phase object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.deloadWeeks.length * 8;
  bytesCount += 3 + object.goals.length * 3;
  {
    final offsets = allOffsets[PhaseGoal]!;
    for (var i = 0; i < object.goals.length; i++) {
      final value = object.goals[i];
      bytesCount += PhaseGoalSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.objective;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.recommendedReps;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.weeklySchedule.length * 3;
  {
    final offsets = allOffsets[DaySchedule]!;
    for (var i = 0; i < object.weeklySchedule.length; i++) {
      final value = object.weeklySchedule[i];
      bytesCount += DayScheduleSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _phaseSerialize(
  Phase object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.completedSessions);
  writer.writeLongList(offsets[1], object.deloadWeeks);
  writer.writeLong(offsets[2], object.durationWeeks);
  writer.writeObjectList<PhaseGoal>(
    offsets[3],
    allOffsets,
    PhaseGoalSchema.serialize,
    object.goals,
  );
  writer.writeDouble(offsets[4], object.intensityPercent);
  writer.writeBool(offsets[5], object.isCompleted);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.objective);
  writer.writeString(offsets[8], object.recommendedReps);
  writer.writeLong(offsets[9], object.recommendedSets);
  writer.writeDateTime(offsets[10], object.startDate);
  writer.writeLong(offsets[11], object.targetSessions);
  writer.writeObjectList<DaySchedule>(
    offsets[12],
    allOffsets,
    DayScheduleSchema.serialize,
    object.weeklySchedule,
  );
}

Phase _phaseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Phase();
  object.completedSessions = reader.readLong(offsets[0]);
  object.deloadWeeks = reader.readLongList(offsets[1]) ?? [];
  object.durationWeeks = reader.readLong(offsets[2]);
  object.goals = reader.readObjectList<PhaseGoal>(
        offsets[3],
        PhaseGoalSchema.deserialize,
        allOffsets,
        PhaseGoal(),
      ) ??
      [];
  object.intensityPercent = reader.readDoubleOrNull(offsets[4]);
  object.isCompleted = reader.readBool(offsets[5]);
  object.name = reader.readString(offsets[6]);
  object.objective = reader.readStringOrNull(offsets[7]);
  object.recommendedReps = reader.readStringOrNull(offsets[8]);
  object.recommendedSets = reader.readLongOrNull(offsets[9]);
  object.startDate = reader.readDateTimeOrNull(offsets[10]);
  object.targetSessions = reader.readLong(offsets[11]);
  object.weeklySchedule = reader.readObjectList<DaySchedule>(
        offsets[12],
        DayScheduleSchema.deserialize,
        allOffsets,
        DaySchedule(),
      ) ??
      [];
  return object;
}

P _phaseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readObjectList<PhaseGoal>(
            offset,
            PhaseGoalSchema.deserialize,
            allOffsets,
            PhaseGoal(),
          ) ??
          []) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readObjectList<DaySchedule>(
            offset,
            DayScheduleSchema.deserialize,
            allOffsets,
            DaySchedule(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PhaseQueryFilter on QueryBuilder<Phase, Phase, QFilterCondition> {
  QueryBuilder<Phase, Phase, QAfterFilterCondition> completedSessionsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition>
      completedSessionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> completedSessionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> completedSessionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedSessions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> deloadWeeksElementEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deloadWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition>
      deloadWeeksElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deloadWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> deloadWeeksElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deloadWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> deloadWeeksElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deloadWeeks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> deloadWeeksLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deloadWeeks',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> deloadWeeksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deloadWeeks',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> deloadWeeksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deloadWeeks',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> deloadWeeksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deloadWeeks',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition>
      deloadWeeksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deloadWeeks',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> deloadWeeksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deloadWeeks',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> durationWeeksEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> durationWeeksGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> durationWeeksLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> durationWeeksBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationWeeks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> goalsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goals',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> goalsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goals',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> goalsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goals',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> goalsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goals',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> goalsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goals',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> goalsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'goals',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> intensityPercentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intensityPercent',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition>
      intensityPercentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intensityPercent',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> intensityPercentEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intensityPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> intensityPercentGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intensityPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> intensityPercentLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intensityPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> intensityPercentBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intensityPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> isCompletedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Phase, Phase, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Phase, Phase, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Phase, Phase, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Phase, Phase, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Phase, Phase, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Phase, Phase, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'objective',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'objective',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'objective',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'objective',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'objective',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'objective',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'objective',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'objective',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'objective',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'objective',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'objective',
        value: '',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> objectiveIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'objective',
        value: '',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recommendedReps',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recommendedReps',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendedReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recommendedReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recommendedReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recommendedReps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recommendedReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recommendedReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recommendedReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recommendedReps',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedRepsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendedReps',
        value: '',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition>
      recommendedRepsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recommendedReps',
        value: '',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedSetsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recommendedSets',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedSetsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recommendedSets',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedSetsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendedSets',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedSetsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recommendedSets',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedSetsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recommendedSets',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> recommendedSetsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recommendedSets',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> startDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startDate',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> startDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startDate',
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> startDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> startDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> startDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> startDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> targetSessionsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> targetSessionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> targetSessionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> targetSessionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetSessions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> weeklyScheduleLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklySchedule',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> weeklyScheduleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklySchedule',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> weeklyScheduleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklySchedule',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition>
      weeklyScheduleLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklySchedule',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition>
      weeklyScheduleLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklySchedule',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> weeklyScheduleLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weeklySchedule',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PhaseQueryObject on QueryBuilder<Phase, Phase, QFilterCondition> {
  QueryBuilder<Phase, Phase, QAfterFilterCondition> goalsElement(
      FilterQuery<PhaseGoal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'goals');
    });
  }

  QueryBuilder<Phase, Phase, QAfterFilterCondition> weeklyScheduleElement(
      FilterQuery<DaySchedule> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'weeklySchedule');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DayScheduleSchema = Schema(
  name: r'DaySchedule',
  id: -546682053454918947,
  properties: {
    r'weekday': PropertySchema(
      id: 0,
      name: r'weekday',
      type: IsarType.long,
    ),
    r'workoutIds': PropertySchema(
      id: 1,
      name: r'workoutIds',
      type: IsarType.longList,
    ),
    r'workoutNames': PropertySchema(
      id: 2,
      name: r'workoutNames',
      type: IsarType.stringList,
    )
  },
  estimateSize: _dayScheduleEstimateSize,
  serialize: _dayScheduleSerialize,
  deserialize: _dayScheduleDeserialize,
  deserializeProp: _dayScheduleDeserializeProp,
);

int _dayScheduleEstimateSize(
  DaySchedule object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.workoutIds.length * 8;
  bytesCount += 3 + object.workoutNames.length * 3;
  {
    for (var i = 0; i < object.workoutNames.length; i++) {
      final value = object.workoutNames[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _dayScheduleSerialize(
  DaySchedule object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.weekday);
  writer.writeLongList(offsets[1], object.workoutIds);
  writer.writeStringList(offsets[2], object.workoutNames);
}

DaySchedule _dayScheduleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DaySchedule();
  object.weekday = reader.readLong(offsets[0]);
  object.workoutIds = reader.readLongList(offsets[1]) ?? [];
  object.workoutNames = reader.readStringList(offsets[2]) ?? [];
  return object;
}

P _dayScheduleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DayScheduleQueryFilter
    on QueryBuilder<DaySchedule, DaySchedule, QFilterCondition> {
  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition> weekdayEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekday',
        value: value,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      weekdayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekday',
        value: value,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition> weekdayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekday',
        value: value,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition> weekdayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutIds',
        value: value,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutIds',
        value: value,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutIds',
        value: value,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'workoutNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'workoutNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workoutNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workoutNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutNames',
        value: '',
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workoutNames',
        value: '',
      ));
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DaySchedule, DaySchedule, QAfterFilterCondition>
      workoutNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workoutNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension DayScheduleQueryObject
    on QueryBuilder<DaySchedule, DaySchedule, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PhaseGoalSchema = Schema(
  name: r'PhaseGoal',
  id: 964490786994885360,
  properties: {
    r'current': PropertySchema(
      id: 0,
      name: r'current',
      type: IsarType.double,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'exerciseId': PropertySchema(
      id: 2,
      name: r'exerciseId',
      type: IsarType.long,
    ),
    r'exerciseName': PropertySchema(
      id: 3,
      name: r'exerciseName',
      type: IsarType.string,
    ),
    r'target': PropertySchema(
      id: 4,
      name: r'target',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.string,
      enumMap: _PhaseGoaltypeEnumValueMap,
    ),
    r'unit': PropertySchema(
      id: 6,
      name: r'unit',
      type: IsarType.string,
    ),
    r'workoutType': PropertySchema(
      id: 7,
      name: r'workoutType',
      type: IsarType.string,
      enumMap: _PhaseGoalworkoutTypeEnumValueMap,
    )
  },
  estimateSize: _phaseGoalEstimateSize,
  serialize: _phaseGoalSerialize,
  deserialize: _phaseGoalDeserialize,
  deserializeProp: _phaseGoalDeserializeProp,
);

int _phaseGoalEstimateSize(
  PhaseGoal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  {
    final value = object.exerciseName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.name.length * 3;
  bytesCount += 3 + object.unit.length * 3;
  {
    final value = object.workoutType;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  return bytesCount;
}

void _phaseGoalSerialize(
  PhaseGoal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.current);
  writer.writeString(offsets[1], object.description);
  writer.writeLong(offsets[2], object.exerciseId);
  writer.writeString(offsets[3], object.exerciseName);
  writer.writeDouble(offsets[4], object.target);
  writer.writeString(offsets[5], object.type.name);
  writer.writeString(offsets[6], object.unit);
  writer.writeString(offsets[7], object.workoutType?.name);
}

PhaseGoal _phaseGoalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PhaseGoal();
  object.current = reader.readDouble(offsets[0]);
  object.description = reader.readString(offsets[1]);
  object.exerciseId = reader.readLongOrNull(offsets[2]);
  object.exerciseName = reader.readStringOrNull(offsets[3]);
  object.target = reader.readDouble(offsets[4]);
  object.type =
      _PhaseGoaltypeValueEnumMap[reader.readStringOrNull(offsets[5])] ??
          GoalType.sessions;
  object.unit = reader.readString(offsets[6]);
  object.workoutType =
      _PhaseGoalworkoutTypeValueEnumMap[reader.readStringOrNull(offsets[7])];
  return object;
}

P _phaseGoalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (_PhaseGoaltypeValueEnumMap[reader.readStringOrNull(offset)] ??
          GoalType.sessions) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (_PhaseGoalworkoutTypeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PhaseGoaltypeEnumValueMap = {
  r'sessions': r'sessions',
  r'distance': r'distance',
  r'weight': r'weight',
  r'reps': r'reps',
  r'duration': r'duration',
};
const _PhaseGoaltypeValueEnumMap = {
  r'sessions': GoalType.sessions,
  r'distance': GoalType.distance,
  r'weight': GoalType.weight,
  r'reps': GoalType.reps,
  r'duration': GoalType.duration,
};
const _PhaseGoalworkoutTypeEnumValueMap = {
  r'musculacao': r'musculacao',
  r'corrida': r'corrida',
  r'drills': r'drills',
  r'bola': r'bola',
  r'mobilidade': r'mobilidade',
  r'custom': r'custom',
};
const _PhaseGoalworkoutTypeValueEnumMap = {
  r'musculacao': WorkoutType.musculacao,
  r'corrida': WorkoutType.corrida,
  r'drills': WorkoutType.drills,
  r'bola': WorkoutType.bola,
  r'mobilidade': WorkoutType.mobilidade,
  r'custom': WorkoutType.custom,
};

extension PhaseGoalQueryFilter
    on QueryBuilder<PhaseGoal, PhaseGoal, QFilterCondition> {
  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> currentEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'current',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> currentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'current',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> currentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'current',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> currentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'current',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> exerciseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exerciseId',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      exerciseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exerciseId',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> exerciseIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseId',
        value: value,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> exerciseIdLessThan(
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> exerciseIdBetween(
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      exerciseNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exerciseName',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      exerciseNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exerciseName',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> exerciseNameEqualTo(
    String? value, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      exerciseNameGreaterThan(
    String? value, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      exerciseNameLessThan(
    String? value, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> exerciseNameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      exerciseNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> exerciseNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      exerciseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseName',
        value: '',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      exerciseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseName',
        value: '',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> targetEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'target',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> targetGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'target',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> targetLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'target',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> targetBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'target',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> typeEqualTo(
    GoalType value, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> typeGreaterThan(
    GoalType value, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> typeLessThan(
    GoalType value, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> typeBetween(
    GoalType lower,
    GoalType upper, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> typeStartsWith(
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> typeContains(
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> typeMatches(
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> unitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> unitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> unitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> unitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> unitContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> unitMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      workoutTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'workoutType',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      workoutTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'workoutType',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> workoutTypeEqualTo(
    WorkoutType? value, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      workoutTypeGreaterThan(
    WorkoutType? value, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> workoutTypeLessThan(
    WorkoutType? value, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> workoutTypeBetween(
    WorkoutType? lower,
    WorkoutType? upper, {
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> workoutTypeEndsWith(
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

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> workoutTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workoutType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition> workoutTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workoutType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      workoutTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutType',
        value: '',
      ));
    });
  }

  QueryBuilder<PhaseGoal, PhaseGoal, QAfterFilterCondition>
      workoutTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workoutType',
        value: '',
      ));
    });
  }
}

extension PhaseGoalQueryObject
    on QueryBuilder<PhaseGoal, PhaseGoal, QFilterCondition> {}
