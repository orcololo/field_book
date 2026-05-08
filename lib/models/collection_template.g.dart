// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCollectionTemplateCollection on Isar {
  IsarCollection<CollectionTemplate> get collectionTemplates =>
      this.collection();
}

const CollectionTemplateSchema = CollectionSchema(
  name: r'CollectionTemplate',
  id: -8621841086757819219,
  properties: {
    r'biome': PropertySchema(
      id: 0,
      name: r'biome',
      type: IsarType.string,
    ),
    r'habitatTemplate': PropertySchema(
      id: 1,
      name: r'habitatTemplate',
      type: IsarType.string,
    ),
    r'isBuiltIn': PropertySchema(
      id: 2,
      name: r'isBuiltIn',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'notesTemplate': PropertySchema(
      id: 4,
      name: r'notesTemplate',
      type: IsarType.string,
    ),
    r'substrateTemplate': PropertySchema(
      id: 5,
      name: r'substrateTemplate',
      type: IsarType.string,
    ),
    r'topographyTemplate': PropertySchema(
      id: 6,
      name: r'topographyTemplate',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 7,
      name: r'uuid',
      type: IsarType.string,
    ),
    r'vegetationTypeTemplate': PropertySchema(
      id: 8,
      name: r'vegetationTypeTemplate',
      type: IsarType.string,
    )
  },
  estimateSize: _collectionTemplateEstimateSize,
  serialize: _collectionTemplateSerialize,
  deserialize: _collectionTemplateDeserialize,
  deserializeProp: _collectionTemplateDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
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
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'biome': IndexSchema(
      id: 787085535770254812,
      name: r'biome',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'biome',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'isBuiltIn': IndexSchema(
      id: 8159970814813350081,
      name: r'isBuiltIn',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isBuiltIn',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _collectionTemplateGetId,
  getLinks: _collectionTemplateGetLinks,
  attach: _collectionTemplateAttach,
  version: '3.1.0+1',
);

int _collectionTemplateEstimateSize(
  CollectionTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.biome.length * 3;
  {
    final value = object.habitatTemplate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.notesTemplate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.substrateTemplate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.topographyTemplate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.uuid.length * 3;
  {
    final value = object.vegetationTypeTemplate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _collectionTemplateSerialize(
  CollectionTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.biome);
  writer.writeString(offsets[1], object.habitatTemplate);
  writer.writeBool(offsets[2], object.isBuiltIn);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.notesTemplate);
  writer.writeString(offsets[5], object.substrateTemplate);
  writer.writeString(offsets[6], object.topographyTemplate);
  writer.writeString(offsets[7], object.uuid);
  writer.writeString(offsets[8], object.vegetationTypeTemplate);
}

CollectionTemplate _collectionTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CollectionTemplate();
  object.biome = reader.readString(offsets[0]);
  object.habitatTemplate = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.isBuiltIn = reader.readBool(offsets[2]);
  object.name = reader.readString(offsets[3]);
  object.notesTemplate = reader.readStringOrNull(offsets[4]);
  object.substrateTemplate = reader.readStringOrNull(offsets[5]);
  object.topographyTemplate = reader.readStringOrNull(offsets[6]);
  object.uuid = reader.readString(offsets[7]);
  object.vegetationTypeTemplate = reader.readStringOrNull(offsets[8]);
  return object;
}

P _collectionTemplateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _collectionTemplateGetId(CollectionTemplate object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _collectionTemplateGetLinks(
    CollectionTemplate object) {
  return [];
}

void _collectionTemplateAttach(
    IsarCollection<dynamic> col, Id id, CollectionTemplate object) {
  object.id = id;
}

extension CollectionTemplateByIndex on IsarCollection<CollectionTemplate> {
  Future<CollectionTemplate?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  CollectionTemplate? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<CollectionTemplate?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<CollectionTemplate?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(CollectionTemplate object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(CollectionTemplate object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<CollectionTemplate> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<CollectionTemplate> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension CollectionTemplateQueryWhereSort
    on QueryBuilder<CollectionTemplate, CollectionTemplate, QWhere> {
  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhere>
      anyIsBuiltIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isBuiltIn'),
      );
    });
  }
}

extension CollectionTemplateQueryWhere
    on QueryBuilder<CollectionTemplate, CollectionTemplate, QWhereClause> {
  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      nameNotEqualTo(String name) {
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      biomeEqualTo(String biome) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'biome',
        value: [biome],
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      biomeNotEqualTo(String biome) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'biome',
              lower: [],
              upper: [biome],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'biome',
              lower: [biome],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'biome',
              lower: [biome],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'biome',
              lower: [],
              upper: [biome],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      isBuiltInEqualTo(bool isBuiltIn) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isBuiltIn',
        value: [isBuiltIn],
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterWhereClause>
      isBuiltInNotEqualTo(bool isBuiltIn) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isBuiltIn',
              lower: [],
              upper: [isBuiltIn],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isBuiltIn',
              lower: [isBuiltIn],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isBuiltIn',
              lower: [isBuiltIn],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isBuiltIn',
              lower: [],
              upper: [isBuiltIn],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CollectionTemplateQueryFilter
    on QueryBuilder<CollectionTemplate, CollectionTemplate, QFilterCondition> {
  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      biomeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'biome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      biomeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'biome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      biomeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'biome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      biomeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'biome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      biomeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'biome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      biomeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'biome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      biomeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'biome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      biomeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'biome',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      biomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'biome',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      biomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'biome',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'habitatTemplate',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'habitatTemplate',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitatTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'habitatTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'habitatTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'habitatTemplate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'habitatTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'habitatTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'habitatTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'habitatTemplate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitatTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      habitatTemplateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'habitatTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      isBuiltInEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBuiltIn',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notesTemplate',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notesTemplate',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notesTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notesTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notesTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notesTemplate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notesTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notesTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notesTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notesTemplate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notesTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      notesTemplateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notesTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'substrateTemplate',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'substrateTemplate',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'substrateTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'substrateTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'substrateTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'substrateTemplate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'substrateTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'substrateTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'substrateTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'substrateTemplate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'substrateTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      substrateTemplateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'substrateTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'topographyTemplate',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'topographyTemplate',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topographyTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topographyTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topographyTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topographyTemplate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topographyTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topographyTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topographyTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topographyTemplate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topographyTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      topographyTemplateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topographyTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vegetationTypeTemplate',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vegetationTypeTemplate',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vegetationTypeTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vegetationTypeTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vegetationTypeTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vegetationTypeTemplate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vegetationTypeTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vegetationTypeTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vegetationTypeTemplate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vegetationTypeTemplate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vegetationTypeTemplate',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterFilterCondition>
      vegetationTypeTemplateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vegetationTypeTemplate',
        value: '',
      ));
    });
  }
}

extension CollectionTemplateQueryObject
    on QueryBuilder<CollectionTemplate, CollectionTemplate, QFilterCondition> {}

extension CollectionTemplateQueryLinks
    on QueryBuilder<CollectionTemplate, CollectionTemplate, QFilterCondition> {}

extension CollectionTemplateQuerySortBy
    on QueryBuilder<CollectionTemplate, CollectionTemplate, QSortBy> {
  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByBiome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biome', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByBiomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biome', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByHabitatTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitatTemplate', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByHabitatTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitatTemplate', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByIsBuiltIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByIsBuiltInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByNotesTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesTemplate', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByNotesTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesTemplate', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortBySubstrateTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'substrateTemplate', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortBySubstrateTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'substrateTemplate', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByTopographyTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topographyTemplate', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByTopographyTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topographyTemplate', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByVegetationTypeTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegetationTypeTemplate', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      sortByVegetationTypeTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegetationTypeTemplate', Sort.desc);
    });
  }
}

extension CollectionTemplateQuerySortThenBy
    on QueryBuilder<CollectionTemplate, CollectionTemplate, QSortThenBy> {
  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByBiome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biome', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByBiomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biome', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByHabitatTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitatTemplate', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByHabitatTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitatTemplate', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByIsBuiltIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByIsBuiltInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByNotesTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesTemplate', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByNotesTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesTemplate', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenBySubstrateTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'substrateTemplate', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenBySubstrateTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'substrateTemplate', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByTopographyTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topographyTemplate', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByTopographyTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topographyTemplate', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByVegetationTypeTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegetationTypeTemplate', Sort.asc);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QAfterSortBy>
      thenByVegetationTypeTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegetationTypeTemplate', Sort.desc);
    });
  }
}

extension CollectionTemplateQueryWhereDistinct
    on QueryBuilder<CollectionTemplate, CollectionTemplate, QDistinct> {
  QueryBuilder<CollectionTemplate, CollectionTemplate, QDistinct>
      distinctByBiome({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'biome', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QDistinct>
      distinctByHabitatTemplate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitatTemplate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QDistinct>
      distinctByIsBuiltIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBuiltIn');
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QDistinct>
      distinctByNotesTemplate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notesTemplate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QDistinct>
      distinctBySubstrateTemplate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'substrateTemplate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QDistinct>
      distinctByTopographyTemplate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topographyTemplate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QDistinct>
      distinctByUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollectionTemplate, CollectionTemplate, QDistinct>
      distinctByVegetationTypeTemplate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vegetationTypeTemplate',
          caseSensitive: caseSensitive);
    });
  }
}

extension CollectionTemplateQueryProperty
    on QueryBuilder<CollectionTemplate, CollectionTemplate, QQueryProperty> {
  QueryBuilder<CollectionTemplate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CollectionTemplate, String, QQueryOperations> biomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'biome');
    });
  }

  QueryBuilder<CollectionTemplate, String?, QQueryOperations>
      habitatTemplateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitatTemplate');
    });
  }

  QueryBuilder<CollectionTemplate, bool, QQueryOperations> isBuiltInProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBuiltIn');
    });
  }

  QueryBuilder<CollectionTemplate, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CollectionTemplate, String?, QQueryOperations>
      notesTemplateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notesTemplate');
    });
  }

  QueryBuilder<CollectionTemplate, String?, QQueryOperations>
      substrateTemplateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'substrateTemplate');
    });
  }

  QueryBuilder<CollectionTemplate, String?, QQueryOperations>
      topographyTemplateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topographyTemplate');
    });
  }

  QueryBuilder<CollectionTemplate, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<CollectionTemplate, String?, QQueryOperations>
      vegetationTypeTemplateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vegetationTypeTemplate');
    });
  }
}
