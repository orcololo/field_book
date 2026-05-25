// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLabelTemplateCollection on Isar {
  IsarCollection<LabelTemplate> get labelTemplates => this.collection();
}

const LabelTemplateSchema = CollectionSchema(
  name: r'LabelTemplate',
  id: 8341353780753628,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'institutionName': PropertySchema(
      id: 1,
      name: r'institutionName',
      type: IsarType.string,
    ),
    r'isBuiltIn': PropertySchema(
      id: 2,
      name: r'isBuiltIn',
      type: IsarType.bool,
    ),
    r'labelsPerPage': PropertySchema(
      id: 3,
      name: r'labelsPerPage',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'paperSize': PropertySchema(
      id: 5,
      name: r'paperSize',
      type: IsarType.byte,
      enumMap: _LabelTemplatepaperSizeEnumValueMap,
    ),
    r'showAltitude': PropertySchema(
      id: 6,
      name: r'showAltitude',
      type: IsarType.bool,
    ),
    r'showCollectionDate': PropertySchema(
      id: 7,
      name: r'showCollectionDate',
      type: IsarType.bool,
    ),
    r'showCollector': PropertySchema(
      id: 8,
      name: r'showCollector',
      type: IsarType.bool,
    ),
    r'showCoordinates': PropertySchema(
      id: 9,
      name: r'showCoordinates',
      type: IsarType.bool,
    ),
    r'showFamily': PropertySchema(
      id: 10,
      name: r'showFamily',
      type: IsarType.bool,
    ),
    r'showHabitat': PropertySchema(
      id: 11,
      name: r'showHabitat',
      type: IsarType.bool,
    ),
    r'showLocality': PropertySchema(
      id: 12,
      name: r'showLocality',
      type: IsarType.bool,
    ),
    r'showMorphology': PropertySchema(
      id: 13,
      name: r'showMorphology',
      type: IsarType.bool,
    ),
    r'showNotes': PropertySchema(
      id: 14,
      name: r'showNotes',
      type: IsarType.bool,
    ),
    r'showQrCode': PropertySchema(
      id: 15,
      name: r'showQrCode',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 17,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _labelTemplateEstimateSize,
  serialize: _labelTemplateSerialize,
  deserialize: _labelTemplateDeserialize,
  deserializeProp: _labelTemplateDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _labelTemplateGetId,
  getLinks: _labelTemplateGetLinks,
  attach: _labelTemplateAttach,
  version: '3.1.0+1',
);

int _labelTemplateEstimateSize(
  LabelTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.institutionName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _labelTemplateSerialize(
  LabelTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.institutionName);
  writer.writeBool(offsets[2], object.isBuiltIn);
  writer.writeLong(offsets[3], object.labelsPerPage);
  writer.writeString(offsets[4], object.name);
  writer.writeByte(offsets[5], object.paperSize.index);
  writer.writeBool(offsets[6], object.showAltitude);
  writer.writeBool(offsets[7], object.showCollectionDate);
  writer.writeBool(offsets[8], object.showCollector);
  writer.writeBool(offsets[9], object.showCoordinates);
  writer.writeBool(offsets[10], object.showFamily);
  writer.writeBool(offsets[11], object.showHabitat);
  writer.writeBool(offsets[12], object.showLocality);
  writer.writeBool(offsets[13], object.showMorphology);
  writer.writeBool(offsets[14], object.showNotes);
  writer.writeBool(offsets[15], object.showQrCode);
  writer.writeDateTime(offsets[16], object.updatedAt);
  writer.writeString(offsets[17], object.uuid);
}

LabelTemplate _labelTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LabelTemplate();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.institutionName = reader.readStringOrNull(offsets[1]);
  object.isBuiltIn = reader.readBool(offsets[2]);
  object.labelsPerPage = reader.readLong(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.paperSize =
      _LabelTemplatepaperSizeValueEnumMap[reader.readByteOrNull(offsets[5])] ??
          LabelPaperSize.a4;
  object.showAltitude = reader.readBool(offsets[6]);
  object.showCollectionDate = reader.readBool(offsets[7]);
  object.showCollector = reader.readBool(offsets[8]);
  object.showCoordinates = reader.readBool(offsets[9]);
  object.showFamily = reader.readBool(offsets[10]);
  object.showHabitat = reader.readBool(offsets[11]);
  object.showLocality = reader.readBool(offsets[12]);
  object.showMorphology = reader.readBool(offsets[13]);
  object.showNotes = reader.readBool(offsets[14]);
  object.showQrCode = reader.readBool(offsets[15]);
  object.updatedAt = reader.readDateTime(offsets[16]);
  object.uuid = reader.readString(offsets[17]);
  return object;
}

P _labelTemplateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (_LabelTemplatepaperSizeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          LabelPaperSize.a4) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readDateTime(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LabelTemplatepaperSizeEnumValueMap = {
  'a4': 0,
  'letter': 1,
  'thermal80mm': 2,
};
const _LabelTemplatepaperSizeValueEnumMap = {
  0: LabelPaperSize.a4,
  1: LabelPaperSize.letter,
  2: LabelPaperSize.thermal80mm,
};

Id _labelTemplateGetId(LabelTemplate object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _labelTemplateGetLinks(LabelTemplate object) {
  return [];
}

void _labelTemplateAttach(
    IsarCollection<dynamic> col, Id id, LabelTemplate object) {
  object.id = id;
}

extension LabelTemplateByIndex on IsarCollection<LabelTemplate> {
  Future<LabelTemplate?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  LabelTemplate? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<LabelTemplate?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<LabelTemplate?> getAllByUuidSync(List<String> uuidValues) {
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

  Future<Id> putByUuid(LabelTemplate object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(LabelTemplate object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<LabelTemplate> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<LabelTemplate> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension LabelTemplateQueryWhereSort
    on QueryBuilder<LabelTemplate, LabelTemplate, QWhere> {
  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LabelTemplateQueryWhere
    on QueryBuilder<LabelTemplate, LabelTemplate, QWhereClause> {
  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> idBetween(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> uuidEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterWhereClause> uuidNotEqualTo(
      String uuid) {
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
}

extension LabelTemplateQueryFilter
    on QueryBuilder<LabelTemplate, LabelTemplate, QFilterCondition> {
  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'institutionName',
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'institutionName',
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'institutionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'institutionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'institutionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'institutionName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'institutionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'institutionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'institutionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'institutionName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'institutionName',
        value: '',
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      institutionNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'institutionName',
        value: '',
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      isBuiltInEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBuiltIn',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      labelsPerPageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'labelsPerPage',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      labelsPerPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'labelsPerPage',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      labelsPerPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'labelsPerPage',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      labelsPerPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'labelsPerPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      paperSizeEqualTo(LabelPaperSize value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paperSize',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      paperSizeGreaterThan(
    LabelPaperSize value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paperSize',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      paperSizeLessThan(
    LabelPaperSize value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paperSize',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      paperSizeBetween(
    LabelPaperSize lower,
    LabelPaperSize upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paperSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      showAltitudeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showAltitude',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      showCollectionDateEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showCollectionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      showCollectorEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showCollector',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      showCoordinatesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showCoordinates',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      showFamilyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showFamily',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      showHabitatEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showHabitat',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      showLocalityEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showLocality',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      showMorphologyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showMorphology',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      showNotesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showNotes',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      showQrCodeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showQrCode',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
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

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension LabelTemplateQueryObject
    on QueryBuilder<LabelTemplate, LabelTemplate, QFilterCondition> {}

extension LabelTemplateQueryLinks
    on QueryBuilder<LabelTemplate, LabelTemplate, QFilterCondition> {}

extension LabelTemplateQuerySortBy
    on QueryBuilder<LabelTemplate, LabelTemplate, QSortBy> {
  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByInstitutionName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'institutionName', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByInstitutionNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'institutionName', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByIsBuiltIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByIsBuiltInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByLabelsPerPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelsPerPage', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByLabelsPerPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelsPerPage', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByPaperSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperSize', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByPaperSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperSize', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowAltitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAltitude', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowAltitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAltitude', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowCollectionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCollectionDate', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowCollectionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCollectionDate', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowCollector() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCollector', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowCollectorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCollector', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowCoordinates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCoordinates', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowCoordinatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCoordinates', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByShowFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showFamily', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showFamily', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByShowHabitat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showHabitat', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowHabitatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showHabitat', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowLocality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLocality', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowLocalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLocality', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowMorphology() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showMorphology', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowMorphologyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showMorphology', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByShowNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNotes', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNotes', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByShowQrCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showQrCode', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByShowQrCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showQrCode', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension LabelTemplateQuerySortThenBy
    on QueryBuilder<LabelTemplate, LabelTemplate, QSortThenBy> {
  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByInstitutionName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'institutionName', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByInstitutionNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'institutionName', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByIsBuiltIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByIsBuiltInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBuiltIn', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByLabelsPerPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelsPerPage', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByLabelsPerPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelsPerPage', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByPaperSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperSize', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByPaperSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paperSize', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowAltitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAltitude', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowAltitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showAltitude', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowCollectionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCollectionDate', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowCollectionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCollectionDate', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowCollector() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCollector', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowCollectorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCollector', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowCoordinates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCoordinates', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowCoordinatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showCoordinates', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByShowFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showFamily', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showFamily', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByShowHabitat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showHabitat', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowHabitatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showHabitat', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowLocality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLocality', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowLocalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLocality', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowMorphology() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showMorphology', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowMorphologyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showMorphology', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByShowNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNotes', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showNotes', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByShowQrCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showQrCode', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByShowQrCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showQrCode', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension LabelTemplateQueryWhereDistinct
    on QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> {
  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
      distinctByInstitutionName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'institutionName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByIsBuiltIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBuiltIn');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
      distinctByLabelsPerPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'labelsPerPage');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByPaperSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paperSize');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
      distinctByShowAltitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showAltitude');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
      distinctByShowCollectionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showCollectionDate');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
      distinctByShowCollector() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showCollector');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
      distinctByShowCoordinates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showCoordinates');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByShowFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showFamily');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
      distinctByShowHabitat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showHabitat');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
      distinctByShowLocality() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showLocality');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct>
      distinctByShowMorphology() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showMorphology');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByShowNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showNotes');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByShowQrCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showQrCode');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<LabelTemplate, LabelTemplate, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension LabelTemplateQueryProperty
    on QueryBuilder<LabelTemplate, LabelTemplate, QQueryProperty> {
  QueryBuilder<LabelTemplate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LabelTemplate, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LabelTemplate, String?, QQueryOperations>
      institutionNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'institutionName');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> isBuiltInProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBuiltIn');
    });
  }

  QueryBuilder<LabelTemplate, int, QQueryOperations> labelsPerPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'labelsPerPage');
    });
  }

  QueryBuilder<LabelTemplate, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LabelTemplate, LabelPaperSize, QQueryOperations>
      paperSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paperSize');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showAltitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showAltitude');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations>
      showCollectionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showCollectionDate');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showCollectorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showCollector');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations>
      showCoordinatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showCoordinates');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showFamilyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showFamily');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showHabitatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showHabitat');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showLocalityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showLocality');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showMorphologyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showMorphology');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showNotes');
    });
  }

  QueryBuilder<LabelTemplate, bool, QQueryOperations> showQrCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showQrCode');
    });
  }

  QueryBuilder<LabelTemplate, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<LabelTemplate, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
