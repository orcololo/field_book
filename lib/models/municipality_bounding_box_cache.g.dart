// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'municipality_bounding_box_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMunicipalityBoundingBoxCacheCollection on Isar {
  IsarCollection<MunicipalityBoundingBoxCache>
      get municipalityBoundingBoxCaches => this.collection();
}

const MunicipalityBoundingBoxCacheSchema = CollectionSchema(
  name: r'MunicipalityBoundingBoxCache',
  id: 5613754794011469086,
  properties: {
    r'cachedAt': PropertySchema(
      id: 0,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'east': PropertySchema(
      id: 1,
      name: r'east',
      type: IsarType.double,
    ),
    r'municipalityKey': PropertySchema(
      id: 2,
      name: r'municipalityKey',
      type: IsarType.string,
    ),
    r'municipalityName': PropertySchema(
      id: 3,
      name: r'municipalityName',
      type: IsarType.string,
    ),
    r'north': PropertySchema(
      id: 4,
      name: r'north',
      type: IsarType.double,
    ),
    r'south': PropertySchema(
      id: 5,
      name: r'south',
      type: IsarType.double,
    ),
    r'west': PropertySchema(
      id: 6,
      name: r'west',
      type: IsarType.double,
    )
  },
  estimateSize: _municipalityBoundingBoxCacheEstimateSize,
  serialize: _municipalityBoundingBoxCacheSerialize,
  deserialize: _municipalityBoundingBoxCacheDeserialize,
  deserializeProp: _municipalityBoundingBoxCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'municipalityKey': IndexSchema(
      id: -781605237494569894,
      name: r'municipalityKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'municipalityKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'cachedAt': IndexSchema(
      id: -699654806693614168,
      name: r'cachedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'cachedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _municipalityBoundingBoxCacheGetId,
  getLinks: _municipalityBoundingBoxCacheGetLinks,
  attach: _municipalityBoundingBoxCacheAttach,
  version: '3.1.0+1',
);

int _municipalityBoundingBoxCacheEstimateSize(
  MunicipalityBoundingBoxCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.municipalityKey.length * 3;
  bytesCount += 3 + object.municipalityName.length * 3;
  return bytesCount;
}

void _municipalityBoundingBoxCacheSerialize(
  MunicipalityBoundingBoxCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.cachedAt);
  writer.writeDouble(offsets[1], object.east);
  writer.writeString(offsets[2], object.municipalityKey);
  writer.writeString(offsets[3], object.municipalityName);
  writer.writeDouble(offsets[4], object.north);
  writer.writeDouble(offsets[5], object.south);
  writer.writeDouble(offsets[6], object.west);
}

MunicipalityBoundingBoxCache _municipalityBoundingBoxCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MunicipalityBoundingBoxCache();
  object.cachedAt = reader.readDateTime(offsets[0]);
  object.east = reader.readDouble(offsets[1]);
  object.id = id;
  object.municipalityKey = reader.readString(offsets[2]);
  object.municipalityName = reader.readString(offsets[3]);
  object.north = reader.readDouble(offsets[4]);
  object.south = reader.readDouble(offsets[5]);
  object.west = reader.readDouble(offsets[6]);
  return object;
}

P _municipalityBoundingBoxCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _municipalityBoundingBoxCacheGetId(MunicipalityBoundingBoxCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _municipalityBoundingBoxCacheGetLinks(
    MunicipalityBoundingBoxCache object) {
  return [];
}

void _municipalityBoundingBoxCacheAttach(
    IsarCollection<dynamic> col, Id id, MunicipalityBoundingBoxCache object) {
  object.id = id;
}

extension MunicipalityBoundingBoxCacheByIndex
    on IsarCollection<MunicipalityBoundingBoxCache> {
  Future<MunicipalityBoundingBoxCache?> getByMunicipalityKey(
      String municipalityKey) {
    return getByIndex(r'municipalityKey', [municipalityKey]);
  }

  MunicipalityBoundingBoxCache? getByMunicipalityKeySync(
      String municipalityKey) {
    return getByIndexSync(r'municipalityKey', [municipalityKey]);
  }

  Future<bool> deleteByMunicipalityKey(String municipalityKey) {
    return deleteByIndex(r'municipalityKey', [municipalityKey]);
  }

  bool deleteByMunicipalityKeySync(String municipalityKey) {
    return deleteByIndexSync(r'municipalityKey', [municipalityKey]);
  }

  Future<List<MunicipalityBoundingBoxCache?>> getAllByMunicipalityKey(
      List<String> municipalityKeyValues) {
    final values = municipalityKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'municipalityKey', values);
  }

  List<MunicipalityBoundingBoxCache?> getAllByMunicipalityKeySync(
      List<String> municipalityKeyValues) {
    final values = municipalityKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'municipalityKey', values);
  }

  Future<int> deleteAllByMunicipalityKey(List<String> municipalityKeyValues) {
    final values = municipalityKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'municipalityKey', values);
  }

  int deleteAllByMunicipalityKeySync(List<String> municipalityKeyValues) {
    final values = municipalityKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'municipalityKey', values);
  }

  Future<Id> putByMunicipalityKey(MunicipalityBoundingBoxCache object) {
    return putByIndex(r'municipalityKey', object);
  }

  Id putByMunicipalityKeySync(MunicipalityBoundingBoxCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'municipalityKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMunicipalityKey(
      List<MunicipalityBoundingBoxCache> objects) {
    return putAllByIndex(r'municipalityKey', objects);
  }

  List<Id> putAllByMunicipalityKeySync(
      List<MunicipalityBoundingBoxCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'municipalityKey', objects, saveLinks: saveLinks);
  }
}

extension MunicipalityBoundingBoxCacheQueryWhereSort on QueryBuilder<
    MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache, QWhere> {
  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhere> anyCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cachedAt'),
      );
    });
  }
}

extension MunicipalityBoundingBoxCacheQueryWhere on QueryBuilder<
    MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache, QWhereClause> {
  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> municipalityKeyEqualTo(String municipalityKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'municipalityKey',
        value: [municipalityKey],
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> municipalityKeyNotEqualTo(String municipalityKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'municipalityKey',
              lower: [],
              upper: [municipalityKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'municipalityKey',
              lower: [municipalityKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'municipalityKey',
              lower: [municipalityKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'municipalityKey',
              lower: [],
              upper: [municipalityKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> cachedAtEqualTo(DateTime cachedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cachedAt',
        value: [cachedAt],
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> cachedAtNotEqualTo(DateTime cachedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cachedAt',
              lower: [],
              upper: [cachedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cachedAt',
              lower: [cachedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cachedAt',
              lower: [cachedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cachedAt',
              lower: [],
              upper: [cachedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> cachedAtGreaterThan(
    DateTime cachedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cachedAt',
        lower: [cachedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> cachedAtLessThan(
    DateTime cachedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cachedAt',
        lower: [],
        upper: [cachedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterWhereClause> cachedAtBetween(
    DateTime lowerCachedAt,
    DateTime upperCachedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cachedAt',
        lower: [lowerCachedAt],
        includeLower: includeLower,
        upper: [upperCachedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MunicipalityBoundingBoxCacheQueryFilter on QueryBuilder<
    MunicipalityBoundingBoxCache,
    MunicipalityBoundingBoxCache,
    QFilterCondition> {
  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> cachedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> cachedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> cachedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cachedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> cachedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cachedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> eastEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'east',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> eastGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'east',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> eastLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'east',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> eastBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'east',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'municipalityKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'municipalityKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'municipalityKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'municipalityKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'municipalityKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'municipalityKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
          QAfterFilterCondition>
      municipalityKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'municipalityKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
          QAfterFilterCondition>
      municipalityKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'municipalityKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'municipalityKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'municipalityKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'municipalityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'municipalityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'municipalityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'municipalityName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'municipalityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'municipalityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
          QAfterFilterCondition>
      municipalityNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'municipalityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
          QAfterFilterCondition>
      municipalityNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'municipalityName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'municipalityName',
        value: '',
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> municipalityNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'municipalityName',
        value: '',
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> northEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'north',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> northGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'north',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> northLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'north',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> northBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'north',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> southEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'south',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> southGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'south',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> southLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'south',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> southBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'south',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> westEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'west',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> westGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'west',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> westLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'west',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterFilterCondition> westBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'west',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension MunicipalityBoundingBoxCacheQueryObject on QueryBuilder<
    MunicipalityBoundingBoxCache,
    MunicipalityBoundingBoxCache,
    QFilterCondition> {}

extension MunicipalityBoundingBoxCacheQueryLinks on QueryBuilder<
    MunicipalityBoundingBoxCache,
    MunicipalityBoundingBoxCache,
    QFilterCondition> {}

extension MunicipalityBoundingBoxCacheQuerySortBy on QueryBuilder<
    MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache, QSortBy> {
  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByEast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'east', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByEastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'east', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByMunicipalityKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipalityKey', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByMunicipalityKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipalityKey', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByMunicipalityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipalityName', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByMunicipalityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipalityName', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByNorth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'north', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByNorthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'north', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortBySouth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'south', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortBySouthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'south', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByWest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'west', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> sortByWestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'west', Sort.desc);
    });
  }
}

extension MunicipalityBoundingBoxCacheQuerySortThenBy on QueryBuilder<
    MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache, QSortThenBy> {
  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByEast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'east', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByEastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'east', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByMunicipalityKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipalityKey', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByMunicipalityKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipalityKey', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByMunicipalityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipalityName', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByMunicipalityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipalityName', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByNorth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'north', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByNorthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'north', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenBySouth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'south', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenBySouthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'south', Sort.desc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByWest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'west', Sort.asc);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QAfterSortBy> thenByWestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'west', Sort.desc);
    });
  }
}

extension MunicipalityBoundingBoxCacheQueryWhereDistinct on QueryBuilder<
    MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache, QDistinct> {
  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QDistinct> distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QDistinct> distinctByEast() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'east');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QDistinct> distinctByMunicipalityKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'municipalityKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QDistinct> distinctByMunicipalityName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'municipalityName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QDistinct> distinctByNorth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'north');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QDistinct> distinctBySouth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'south');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, MunicipalityBoundingBoxCache,
      QDistinct> distinctByWest() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'west');
    });
  }
}

extension MunicipalityBoundingBoxCacheQueryProperty on QueryBuilder<
    MunicipalityBoundingBoxCache,
    MunicipalityBoundingBoxCache,
    QQueryProperty> {
  QueryBuilder<MunicipalityBoundingBoxCache, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, DateTime, QQueryOperations>
      cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, double, QQueryOperations>
      eastProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'east');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, String, QQueryOperations>
      municipalityKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'municipalityKey');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, String, QQueryOperations>
      municipalityNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'municipalityName');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, double, QQueryOperations>
      northProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'north');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, double, QQueryOperations>
      southProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'south');
    });
  }

  QueryBuilder<MunicipalityBoundingBoxCache, double, QQueryOperations>
      westProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'west');
    });
  }
}
