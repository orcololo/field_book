// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSpeciesCacheCollection on Isar {
  IsarCollection<SpeciesCache> get speciesCaches => this.collection();
}

const SpeciesCacheSchema = CollectionSchema(
  name: r'SpeciesCache',
  id: 5390774296682023370,
  properties: {
    r'author': PropertySchema(
      id: 0,
      name: r'author',
      type: IsarType.string,
    ),
    r'family': PropertySchema(
      id: 1,
      name: r'family',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'rank': PropertySchema(
      id: 3,
      name: r'rank',
      type: IsarType.string,
    ),
    r'speciesId': PropertySchema(
      id: 4,
      name: r'speciesId',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 5,
      name: r'status',
      type: IsarType.string,
    ),
    r'syncedAt': PropertySchema(
      id: 6,
      name: r'syncedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _speciesCacheEstimateSize,
  serialize: _speciesCacheSerialize,
  deserialize: _speciesCacheDeserialize,
  deserializeProp: _speciesCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'speciesId': IndexSchema(
      id: 4105165930738425421,
      name: r'speciesId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'speciesId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'family': IndexSchema(
      id: 1611489020059486243,
      name: r'family',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'family',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'syncedAt': IndexSchema(
      id: -9141336850758009100,
      name: r'syncedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'syncedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _speciesCacheGetId,
  getLinks: _speciesCacheGetLinks,
  attach: _speciesCacheAttach,
  version: '3.1.0+1',
);

int _speciesCacheEstimateSize(
  SpeciesCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.author;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.family;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.rank;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.speciesId.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _speciesCacheSerialize(
  SpeciesCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.author);
  writer.writeString(offsets[1], object.family);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.rank);
  writer.writeString(offsets[4], object.speciesId);
  writer.writeString(offsets[5], object.status);
  writer.writeDateTime(offsets[6], object.syncedAt);
}

SpeciesCache _speciesCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SpeciesCache();
  object.author = reader.readStringOrNull(offsets[0]);
  object.family = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  object.rank = reader.readStringOrNull(offsets[3]);
  object.speciesId = reader.readString(offsets[4]);
  object.status = reader.readString(offsets[5]);
  object.syncedAt = reader.readDateTime(offsets[6]);
  return object;
}

P _speciesCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _speciesCacheGetId(SpeciesCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _speciesCacheGetLinks(SpeciesCache object) {
  return [];
}

void _speciesCacheAttach(
    IsarCollection<dynamic> col, Id id, SpeciesCache object) {
  object.id = id;
}

extension SpeciesCacheByIndex on IsarCollection<SpeciesCache> {
  Future<SpeciesCache?> getBySpeciesId(String speciesId) {
    return getByIndex(r'speciesId', [speciesId]);
  }

  SpeciesCache? getBySpeciesIdSync(String speciesId) {
    return getByIndexSync(r'speciesId', [speciesId]);
  }

  Future<bool> deleteBySpeciesId(String speciesId) {
    return deleteByIndex(r'speciesId', [speciesId]);
  }

  bool deleteBySpeciesIdSync(String speciesId) {
    return deleteByIndexSync(r'speciesId', [speciesId]);
  }

  Future<List<SpeciesCache?>> getAllBySpeciesId(List<String> speciesIdValues) {
    final values = speciesIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'speciesId', values);
  }

  List<SpeciesCache?> getAllBySpeciesIdSync(List<String> speciesIdValues) {
    final values = speciesIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'speciesId', values);
  }

  Future<int> deleteAllBySpeciesId(List<String> speciesIdValues) {
    final values = speciesIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'speciesId', values);
  }

  int deleteAllBySpeciesIdSync(List<String> speciesIdValues) {
    final values = speciesIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'speciesId', values);
  }

  Future<Id> putBySpeciesId(SpeciesCache object) {
    return putByIndex(r'speciesId', object);
  }

  Id putBySpeciesIdSync(SpeciesCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'speciesId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySpeciesId(List<SpeciesCache> objects) {
    return putAllByIndex(r'speciesId', objects);
  }

  List<Id> putAllBySpeciesIdSync(List<SpeciesCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'speciesId', objects, saveLinks: saveLinks);
  }
}

extension SpeciesCacheQueryWhereSort
    on QueryBuilder<SpeciesCache, SpeciesCache, QWhere> {
  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhere> anyFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'family'),
      );
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhere> anySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'syncedAt'),
      );
    });
  }
}

extension SpeciesCacheQueryWhere
    on QueryBuilder<SpeciesCache, SpeciesCache, QWhereClause> {
  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> speciesIdEqualTo(
      String speciesId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'speciesId',
        value: [speciesId],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause>
      speciesIdNotEqualTo(String speciesId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'speciesId',
              lower: [],
              upper: [speciesId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'speciesId',
              lower: [speciesId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'speciesId',
              lower: [speciesId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'speciesId',
              lower: [],
              upper: [speciesId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> nameEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> nameNotEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> nameGreaterThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [name],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> nameLessThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [],
        upper: [name],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> nameBetween(
    String lowerName,
    String upperName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [lowerName],
        includeLower: includeLower,
        upper: [upperName],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> nameStartsWith(
      String NamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'name',
        lower: [NamePrefix],
        upper: ['$NamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [''],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'name',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'name',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'name',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'name',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> familyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'family',
        value: [null],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause>
      familyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'family',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> familyEqualTo(
      String? family) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'family',
        value: [family],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> familyNotEqualTo(
      String? family) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'family',
              lower: [],
              upper: [family],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'family',
              lower: [family],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'family',
              lower: [family],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'family',
              lower: [],
              upper: [family],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> familyGreaterThan(
    String? family, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'family',
        lower: [family],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> familyLessThan(
    String? family, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'family',
        lower: [],
        upper: [family],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> familyBetween(
    String? lowerFamily,
    String? upperFamily, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'family',
        lower: [lowerFamily],
        includeLower: includeLower,
        upper: [upperFamily],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> familyStartsWith(
      String FamilyPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'family',
        lower: [FamilyPrefix],
        upper: ['$FamilyPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> familyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'family',
        value: [''],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause>
      familyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'family',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'family',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'family',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'family',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> syncedAtEqualTo(
      DateTime syncedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'syncedAt',
        value: [syncedAt],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause>
      syncedAtNotEqualTo(DateTime syncedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncedAt',
              lower: [],
              upper: [syncedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncedAt',
              lower: [syncedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncedAt',
              lower: [syncedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncedAt',
              lower: [],
              upper: [syncedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause>
      syncedAtGreaterThan(
    DateTime syncedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'syncedAt',
        lower: [syncedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> syncedAtLessThan(
    DateTime syncedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'syncedAt',
        lower: [],
        upper: [syncedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterWhereClause> syncedAtBetween(
    DateTime lowerSyncedAt,
    DateTime upperSyncedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'syncedAt',
        lower: [lowerSyncedAt],
        includeLower: includeLower,
        upper: [upperSyncedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SpeciesCacheQueryFilter
    on QueryBuilder<SpeciesCache, SpeciesCache, QFilterCondition> {
  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      authorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'author',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      authorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'author',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> authorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      authorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      authorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> authorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      authorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      authorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      authorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> authorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      familyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'family',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      familyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'family',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> familyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'family',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      familyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'family',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      familyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'family',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> familyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'family',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      familyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'family',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      familyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'family',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      familyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'family',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> familyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'family',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      familyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'family',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      familyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'family',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> nameContains(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> rankIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rank',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      rankIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rank',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> rankEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      rankGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> rankLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> rankBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rank',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      rankStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> rankEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> rankContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rank',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> rankMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rank',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      rankIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rank',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      rankIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rank',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      speciesIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      speciesIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      speciesIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      speciesIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speciesId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      speciesIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'speciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      speciesIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'speciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      speciesIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'speciesId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      speciesIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'speciesId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      speciesIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speciesId',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      speciesIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'speciesId',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      syncedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      syncedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      syncedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterFilterCondition>
      syncedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SpeciesCacheQueryObject
    on QueryBuilder<SpeciesCache, SpeciesCache, QFilterCondition> {}

extension SpeciesCacheQueryLinks
    on QueryBuilder<SpeciesCache, SpeciesCache, QFilterCondition> {}

extension SpeciesCacheQuerySortBy
    on QueryBuilder<SpeciesCache, SpeciesCache, QSortBy> {
  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortByFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'family', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortByFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'family', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortByRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortByRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortBySpeciesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speciesId', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortBySpeciesIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speciesId', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }
}

extension SpeciesCacheQuerySortThenBy
    on QueryBuilder<SpeciesCache, SpeciesCache, QSortThenBy> {
  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'family', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'family', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenBySpeciesId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speciesId', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenBySpeciesIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speciesId', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QAfterSortBy> thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }
}

extension SpeciesCacheQueryWhereDistinct
    on QueryBuilder<SpeciesCache, SpeciesCache, QDistinct> {
  QueryBuilder<SpeciesCache, SpeciesCache, QDistinct> distinctByAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QDistinct> distinctByFamily(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'family', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QDistinct> distinctByRank(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rank', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QDistinct> distinctBySpeciesId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speciesId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SpeciesCache, SpeciesCache, QDistinct> distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }
}

extension SpeciesCacheQueryProperty
    on QueryBuilder<SpeciesCache, SpeciesCache, QQueryProperty> {
  QueryBuilder<SpeciesCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SpeciesCache, String?, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<SpeciesCache, String?, QQueryOperations> familyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'family');
    });
  }

  QueryBuilder<SpeciesCache, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SpeciesCache, String?, QQueryOperations> rankProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rank');
    });
  }

  QueryBuilder<SpeciesCache, String, QQueryOperations> speciesIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speciesId');
    });
  }

  QueryBuilder<SpeciesCache, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<SpeciesCache, DateTime, QQueryOperations> syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }
}
