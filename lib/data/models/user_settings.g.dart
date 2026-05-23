// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserSettingsCollection on Isar {
  IsarCollection<UserSettings> get userSettings => this.collection();
}

const UserSettingsSchema = CollectionSchema(
  name: r'UserSettings',
  id: 4939698790990493221,
  properties: {
    r'activeMacroCycleId': PropertySchema(
      id: 0,
      name: r'activeMacroCycleId',
      type: IsarType.string,
    ),
    r'birthDate': PropertySchema(
      id: 1,
      name: r'birthDate',
      type: IsarType.dateTime,
    ),
    r'defaultRestSeconds': PropertySchema(
      id: 2,
      name: r'defaultRestSeconds',
      type: IsarType.long,
    ),
    r'height': PropertySchema(
      id: 3,
      name: r'height',
      type: IsarType.double,
    ),
    r'heightUnit': PropertySchema(
      id: 4,
      name: r'heightUnit',
      type: IsarType.string,
      enumMap: _UserSettingsheightUnitEnumValueMap,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'themeId': PropertySchema(
      id: 6,
      name: r'themeId',
      type: IsarType.string,
    ),
    r'timerSoundEnabled': PropertySchema(
      id: 7,
      name: r'timerSoundEnabled',
      type: IsarType.bool,
    ),
    r'weight': PropertySchema(
      id: 8,
      name: r'weight',
      type: IsarType.double,
    ),
    r'weightUnit': PropertySchema(
      id: 9,
      name: r'weightUnit',
      type: IsarType.string,
      enumMap: _UserSettingsweightUnitEnumValueMap,
    )
  },
  estimateSize: _userSettingsEstimateSize,
  serialize: _userSettingsSerialize,
  deserialize: _userSettingsDeserialize,
  deserializeProp: _userSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userSettingsGetId,
  getLinks: _userSettingsGetLinks,
  attach: _userSettingsAttach,
  version: '3.1.0+1',
);

int _userSettingsEstimateSize(
  UserSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activeMacroCycleId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.heightUnit.name.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.themeId.length * 3;
  bytesCount += 3 + object.weightUnit.name.length * 3;
  return bytesCount;
}

void _userSettingsSerialize(
  UserSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activeMacroCycleId);
  writer.writeDateTime(offsets[1], object.birthDate);
  writer.writeLong(offsets[2], object.defaultRestSeconds);
  writer.writeDouble(offsets[3], object.height);
  writer.writeString(offsets[4], object.heightUnit.name);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.themeId);
  writer.writeBool(offsets[7], object.timerSoundEnabled);
  writer.writeDouble(offsets[8], object.weight);
  writer.writeString(offsets[9], object.weightUnit.name);
}

UserSettings _userSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserSettings();
  object.activeMacroCycleId = reader.readStringOrNull(offsets[0]);
  object.birthDate = reader.readDateTimeOrNull(offsets[1]);
  object.defaultRestSeconds = reader.readLong(offsets[2]);
  object.height = reader.readDoubleOrNull(offsets[3]);
  object.heightUnit = _UserSettingsheightUnitValueEnumMap[
          reader.readStringOrNull(offsets[4])] ??
      HeightUnit.cm;
  object.id = id;
  object.name = reader.readString(offsets[5]);
  object.themeId = reader.readString(offsets[6]);
  object.timerSoundEnabled = reader.readBool(offsets[7]);
  object.weight = reader.readDoubleOrNull(offsets[8]);
  object.weightUnit = _UserSettingsweightUnitValueEnumMap[
          reader.readStringOrNull(offsets[9])] ??
      WeightUnit.kg;
  return object;
}

P _userSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (_UserSettingsheightUnitValueEnumMap[
              reader.readStringOrNull(offset)] ??
          HeightUnit.cm) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (_UserSettingsweightUnitValueEnumMap[
              reader.readStringOrNull(offset)] ??
          WeightUnit.kg) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _UserSettingsheightUnitEnumValueMap = {
  r'cm': r'cm',
  r'ft': r'ft',
};
const _UserSettingsheightUnitValueEnumMap = {
  r'cm': HeightUnit.cm,
  r'ft': HeightUnit.ft,
};
const _UserSettingsweightUnitEnumValueMap = {
  r'kg': r'kg',
  r'lb': r'lb',
};
const _UserSettingsweightUnitValueEnumMap = {
  r'kg': WeightUnit.kg,
  r'lb': WeightUnit.lb,
};

Id _userSettingsGetId(UserSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userSettingsGetLinks(UserSettings object) {
  return [];
}

void _userSettingsAttach(
    IsarCollection<dynamic> col, Id id, UserSettings object) {
  object.id = id;
}

extension UserSettingsQueryWhereSort
    on QueryBuilder<UserSettings, UserSettings, QWhere> {
  QueryBuilder<UserSettings, UserSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserSettingsQueryWhere
    on QueryBuilder<UserSettings, UserSettings, QWhereClause> {
  QueryBuilder<UserSettings, UserSettings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<UserSettings, UserSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterWhereClause> idBetween(
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

extension UserSettingsQueryFilter
    on QueryBuilder<UserSettings, UserSettings, QFilterCondition> {
  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activeMacroCycleId',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activeMacroCycleId',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeMacroCycleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeMacroCycleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeMacroCycleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeMacroCycleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activeMacroCycleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activeMacroCycleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activeMacroCycleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activeMacroCycleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeMacroCycleId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      activeMacroCycleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activeMacroCycleId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      birthDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'birthDate',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      birthDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'birthDate',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      birthDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'birthDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      birthDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'birthDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      birthDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'birthDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      birthDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'birthDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      defaultRestSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultRestSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'height',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'height',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> heightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> heightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightUnitEqualTo(
    HeightUnit value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightUnitGreaterThan(
    HeightUnit value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'heightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightUnitLessThan(
    HeightUnit value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'heightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightUnitBetween(
    HeightUnit lower,
    HeightUnit upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'heightUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightUnitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'heightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightUnitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'heightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightUnitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'heightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightUnitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'heightUnit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heightUnit',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      heightUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'heightUnit',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> idGreaterThan(
    Id value, {
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> nameContains(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'themeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'themeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      themeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'themeId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      timerSoundEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timerSoundEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> weightEqualTo(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightGreaterThan(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightLessThan(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition> weightBetween(
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

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightUnitEqualTo(
    WeightUnit value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightUnitGreaterThan(
    WeightUnit value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightUnitLessThan(
    WeightUnit value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightUnitBetween(
    WeightUnit lower,
    WeightUnit upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weightUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightUnitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightUnitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightUnitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weightUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightUnitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weightUnit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weightUnit',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterFilterCondition>
      weightUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weightUnit',
        value: '',
      ));
    });
  }
}

extension UserSettingsQueryObject
    on QueryBuilder<UserSettings, UserSettings, QFilterCondition> {}

extension UserSettingsQueryLinks
    on QueryBuilder<UserSettings, UserSettings, QFilterCondition> {}

extension UserSettingsQuerySortBy
    on QueryBuilder<UserSettings, UserSettings, QSortBy> {
  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByActiveMacroCycleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMacroCycleId', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByActiveMacroCycleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMacroCycleId', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByBirthDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthDate', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByBirthDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthDate', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByDefaultRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRestSeconds', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByDefaultRestSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRestSeconds', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByHeightUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightUnit', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByHeightUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightUnit', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByThemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeId', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByThemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeId', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByTimerSoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerSoundEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByTimerSoundEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerSoundEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> sortByWeightUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnit', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      sortByWeightUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnit', Sort.desc);
    });
  }
}

extension UserSettingsQuerySortThenBy
    on QueryBuilder<UserSettings, UserSettings, QSortThenBy> {
  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByActiveMacroCycleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMacroCycleId', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByActiveMacroCycleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeMacroCycleId', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByBirthDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthDate', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByBirthDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthDate', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByDefaultRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRestSeconds', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByDefaultRestSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultRestSeconds', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'height', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByHeightUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightUnit', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByHeightUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heightUnit', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByThemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeId', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByThemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeId', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByTimerSoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerSoundEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByTimerSoundEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerSoundEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy> thenByWeightUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnit', Sort.asc);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QAfterSortBy>
      thenByWeightUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnit', Sort.desc);
    });
  }
}

extension UserSettingsQueryWhereDistinct
    on QueryBuilder<UserSettings, UserSettings, QDistinct> {
  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByActiveMacroCycleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeMacroCycleId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct> distinctByBirthDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'birthDate');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByDefaultRestSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultRestSeconds');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct> distinctByHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'height');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct> distinctByHeightUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heightUnit', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct> distinctByThemeId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct>
      distinctByTimerSoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timerSoundEnabled');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct> distinctByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weight');
    });
  }

  QueryBuilder<UserSettings, UserSettings, QDistinct> distinctByWeightUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weightUnit', caseSensitive: caseSensitive);
    });
  }
}

extension UserSettingsQueryProperty
    on QueryBuilder<UserSettings, UserSettings, QQueryProperty> {
  QueryBuilder<UserSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserSettings, String?, QQueryOperations>
      activeMacroCycleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeMacroCycleId');
    });
  }

  QueryBuilder<UserSettings, DateTime?, QQueryOperations> birthDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'birthDate');
    });
  }

  QueryBuilder<UserSettings, int, QQueryOperations>
      defaultRestSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultRestSeconds');
    });
  }

  QueryBuilder<UserSettings, double?, QQueryOperations> heightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'height');
    });
  }

  QueryBuilder<UserSettings, HeightUnit, QQueryOperations>
      heightUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heightUnit');
    });
  }

  QueryBuilder<UserSettings, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<UserSettings, String, QQueryOperations> themeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeId');
    });
  }

  QueryBuilder<UserSettings, bool, QQueryOperations>
      timerSoundEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timerSoundEnabled');
    });
  }

  QueryBuilder<UserSettings, double?, QQueryOperations> weightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weight');
    });
  }

  QueryBuilder<UserSettings, WeightUnit, QQueryOperations>
      weightUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weightUnit');
    });
  }
}
