// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlantRecordCollection on Isar {
  IsarCollection<PlantRecord> get plantRecords => this.collection();
}

const PlantRecordSchema = CollectionSchema(
  name: r'PlantRecord',
  id: -3237636575448876276,
  properties: {
    r'altitude': PropertySchema(
      id: 0,
      name: r'altitude',
      type: IsarType.double,
    ),
    r'associatedTaxa': PropertySchema(
      id: 1,
      name: r'associatedTaxa',
      type: IsarType.string,
    ),
    r'audioNotePaths': PropertySchema(
      id: 2,
      name: r'audioNotePaths',
      type: IsarType.stringList,
    ),
    r'audioTranscripts': PropertySchema(
      id: 3,
      name: r'audioTranscripts',
      type: IsarType.stringList,
    ),
    r'category': PropertySchema(
      id: 4,
      name: r'category',
      type: IsarType.string,
      enumMap: _PlantRecordcategoryEnumValueMap,
    ),
    r'caule': PropertySchema(
      id: 5,
      name: r'caule',
      type: IsarType.string,
    ),
    r'cauleCircunferencia': PropertySchema(
      id: 6,
      name: r'cauleCircunferencia',
      type: IsarType.double,
    ),
    r'cauleCircunferenciaUnidade': PropertySchema(
      id: 7,
      name: r'cauleCircunferenciaUnidade',
      type: IsarType.string,
    ),
    r'cauleCor': PropertySchema(
      id: 8,
      name: r'cauleCor',
      type: IsarType.string,
    ),
    r'cauleDescricaoSeiva': PropertySchema(
      id: 9,
      name: r'cauleDescricaoSeiva',
      type: IsarType.string,
    ),
    r'cauleTamanho': PropertySchema(
      id: 10,
      name: r'cauleTamanho',
      type: IsarType.double,
    ),
    r'cauleTamanhoUnidade': PropertySchema(
      id: 11,
      name: r'cauleTamanhoUnidade',
      type: IsarType.string,
    ),
    r'cauleTemSeiva': PropertySchema(
      id: 12,
      name: r'cauleTemSeiva',
      type: IsarType.bool,
    ),
    r'cauleTipoCasca': PropertySchema(
      id: 13,
      name: r'cauleTipoCasca',
      type: IsarType.string,
    ),
    r'collectionMethod': PropertySchema(
      id: 14,
      name: r'collectionMethod',
      type: IsarType.string,
      enumMap: _PlantRecordcollectionMethodEnumValueMap,
    ),
    r'collectorNumber': PropertySchema(
      id: 15,
      name: r'collectorNumber',
      type: IsarType.string,
    ),
    r'commonName': PropertySchema(
      id: 16,
      name: r'commonName',
      type: IsarType.string,
    ),
    r'commonNameFts': PropertySchema(
      id: 17,
      name: r'commonNameFts',
      type: IsarType.string,
    ),
    r'contributorName': PropertySchema(
      id: 18,
      name: r'contributorName',
      type: IsarType.string,
    ),
    r'country': PropertySchema(
      id: 19,
      name: r'country',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 20,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dateCollected': PropertySchema(
      id: 21,
      name: r'dateCollected',
      type: IsarType.dateTime,
    ),
    r'determinationQualifier': PropertySchema(
      id: 22,
      name: r'determinationQualifier',
      type: IsarType.string,
    ),
    r'determinations': PropertySchema(
      id: 23,
      name: r'determinations',
      type: IsarType.objectList,
      target: r'Determination',
    ),
    r'deviceId': PropertySchema(
      id: 24,
      name: r'deviceId',
      type: IsarType.string,
    ),
    r'duplicateOf': PropertySchema(
      id: 25,
      name: r'duplicateOf',
      type: IsarType.string,
    ),
    r'duplicateUuids': PropertySchema(
      id: 26,
      name: r'duplicateUuids',
      type: IsarType.stringList,
    ),
    r'family': PropertySchema(
      id: 27,
      name: r'family',
      type: IsarType.string,
    ),
    r'florCor': PropertySchema(
      id: 28,
      name: r'florCor',
      type: IsarType.string,
    ),
    r'florDescricao': PropertySchema(
      id: 29,
      name: r'florDescricao',
      type: IsarType.string,
    ),
    r'florInflorescencia': PropertySchema(
      id: 30,
      name: r'florInflorescencia',
      type: IsarType.string,
    ),
    r'florTamanho': PropertySchema(
      id: 31,
      name: r'florTamanho',
      type: IsarType.double,
    ),
    r'florTamanhoUnidade': PropertySchema(
      id: 32,
      name: r'florTamanhoUnidade',
      type: IsarType.string,
    ),
    r'folhaBainha': PropertySchema(
      id: 33,
      name: r'folhaBainha',
      type: IsarType.string,
    ),
    r'folhaDescricao': PropertySchema(
      id: 34,
      name: r'folhaDescricao',
      type: IsarType.string,
    ),
    r'folhaLamina': PropertySchema(
      id: 35,
      name: r'folhaLamina',
      type: IsarType.string,
    ),
    r'folhaPeciolo': PropertySchema(
      id: 36,
      name: r'folhaPeciolo',
      type: IsarType.string,
    ),
    r'frutoCor': PropertySchema(
      id: 37,
      name: r'frutoCor',
      type: IsarType.string,
    ),
    r'frutoDescricao': PropertySchema(
      id: 38,
      name: r'frutoDescricao',
      type: IsarType.string,
    ),
    r'frutoFormato': PropertySchema(
      id: 39,
      name: r'frutoFormato',
      type: IsarType.string,
    ),
    r'frutoTamanho': PropertySchema(
      id: 40,
      name: r'frutoTamanho',
      type: IsarType.double,
    ),
    r'frutoTamanhoUnidade': PropertySchema(
      id: 41,
      name: r'frutoTamanhoUnidade',
      type: IsarType.string,
    ),
    r'genus': PropertySchema(
      id: 42,
      name: r'genus',
      type: IsarType.string,
    ),
    r'habitat': PropertySchema(
      id: 43,
      name: r'habitat',
      type: IsarType.string,
    ),
    r'humidity': PropertySchema(
      id: 44,
      name: r'humidity',
      type: IsarType.double,
    ),
    r'iNaturalistId': PropertySchema(
      id: 45,
      name: r'iNaturalistId',
      type: IsarType.string,
    ),
    r'iNaturalistSyncedAt': PropertySchema(
      id: 46,
      name: r'iNaturalistSyncedAt',
      type: IsarType.dateTime,
    ),
    r'isDraft': PropertySchema(
      id: 47,
      name: r'isDraft',
      type: IsarType.bool,
    ),
    r'latestDetermination': PropertySchema(
      id: 48,
      name: r'latestDetermination',
      type: IsarType.object,
      target: r'Determination',
    ),
    r'latitude': PropertySchema(
      id: 49,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'locality': PropertySchema(
      id: 50,
      name: r'locality',
      type: IsarType.string,
    ),
    r'longitude': PropertySchema(
      id: 51,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'measurements': PropertySchema(
      id: 52,
      name: r'measurements',
      type: IsarType.objectList,
      target: r'Measurement',
    ),
    r'moonPhase': PropertySchema(
      id: 53,
      name: r'moonPhase',
      type: IsarType.string,
    ),
    r'municipality': PropertySchema(
      id: 54,
      name: r'municipality',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 55,
      name: r'notes',
      type: IsarType.string,
    ),
    r'numberOfIndividuals': PropertySchema(
      id: 56,
      name: r'numberOfIndividuals',
      type: IsarType.long,
    ),
    r'phenologicalState': PropertySchema(
      id: 57,
      name: r'phenologicalState',
      type: IsarType.string,
      enumMap: _PlantRecordphenologicalStateEnumValueMap,
    ),
    r'phenologyFournier': PropertySchema(
      id: 58,
      name: r'phenologyFournier',
      type: IsarType.string,
    ),
    r'photoMetadata': PropertySchema(
      id: 59,
      name: r'photoMetadata',
      type: IsarType.objectList,
      target: r'PhotoMetadata',
    ),
    r'photoPaths': PropertySchema(
      id: 60,
      name: r'photoPaths',
      type: IsarType.stringList,
    ),
    r'raiz': PropertySchema(
      id: 61,
      name: r'raiz',
      type: IsarType.string,
    ),
    r'registryIdentifier': PropertySchema(
      id: 62,
      name: r'registryIdentifier',
      type: IsarType.string,
    ),
    r'scientificAuthor': PropertySchema(
      id: 63,
      name: r'scientificAuthor',
      type: IsarType.string,
    ),
    r'scientificName': PropertySchema(
      id: 64,
      name: r'scientificName',
      type: IsarType.string,
    ),
    r'scientificNameFts': PropertySchema(
      id: 65,
      name: r'scientificNameFts',
      type: IsarType.string,
    ),
    r'sementeCor': PropertySchema(
      id: 66,
      name: r'sementeCor',
      type: IsarType.string,
    ),
    r'sementeDescricao': PropertySchema(
      id: 67,
      name: r'sementeDescricao',
      type: IsarType.string,
    ),
    r'sementeFormato': PropertySchema(
      id: 68,
      name: r'sementeFormato',
      type: IsarType.string,
    ),
    r'sementeTamanho': PropertySchema(
      id: 69,
      name: r'sementeTamanho',
      type: IsarType.double,
    ),
    r'sementeTamanhoUnidade': PropertySchema(
      id: 70,
      name: r'sementeTamanhoUnidade',
      type: IsarType.string,
    ),
    r'sessionId': PropertySchema(
      id: 71,
      name: r'sessionId',
      type: IsarType.string,
    ),
    r'species': PropertySchema(
      id: 72,
      name: r'species',
      type: IsarType.string,
    ),
    r'state': PropertySchema(
      id: 73,
      name: r'state',
      type: IsarType.string,
    ),
    r'substrate': PropertySchema(
      id: 74,
      name: r'substrate',
      type: IsarType.string,
    ),
    r'syncMetadata': PropertySchema(
      id: 75,
      name: r'syncMetadata',
      type: IsarType.object,
      target: r'SyncMetadata',
    ),
    r'taxonStatus': PropertySchema(
      id: 76,
      name: r'taxonStatus',
      type: IsarType.string,
    ),
    r'temperature': PropertySchema(
      id: 77,
      name: r'temperature',
      type: IsarType.double,
    ),
    r'topography': PropertySchema(
      id: 78,
      name: r'topography',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 79,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 80,
      name: r'uuid',
      type: IsarType.string,
    ),
    r'vegetationType': PropertySchema(
      id: 81,
      name: r'vegetationType',
      type: IsarType.string,
    ),
    r'weatherCondition': PropertySchema(
      id: 82,
      name: r'weatherCondition',
      type: IsarType.string,
    ),
    r'weatherNotes': PropertySchema(
      id: 83,
      name: r'weatherNotes',
      type: IsarType.string,
    ),
    r'windSpeed': PropertySchema(
      id: 84,
      name: r'windSpeed',
      type: IsarType.double,
    )
  },
  estimateSize: _plantRecordEstimateSize,
  serialize: _plantRecordSerialize,
  deserialize: _plantRecordDeserialize,
  deserializeProp: _plantRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'scientificName': IndexSchema(
      id: 7683531704520451829,
      name: r'scientificName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'scientificName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'commonName': IndexSchema(
      id: -5029519833804736586,
      name: r'commonName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'commonName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'dateCollected': IndexSchema(
      id: -1379764541830760607,
      name: r'dateCollected',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateCollected',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'latitude': IndexSchema(
      id: 2839588665230214757,
      name: r'latitude',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'latitude',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'longitude': IndexSchema(
      id: -7076447437327017580,
      name: r'longitude',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'longitude',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'municipality': IndexSchema(
      id: 867571283543279071,
      name: r'municipality',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'municipality',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'category': IndexSchema(
      id: -7560358558326323820,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'isDraft': IndexSchema(
      id: -4216025303557102554,
      name: r'isDraft',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isDraft',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'sessionId': IndexSchema(
      id: 6949518585047923839,
      name: r'sessionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sessionId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'registryIdentifier': IndexSchema(
      id: -7731802419751093968,
      name: r'registryIdentifier',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'registryIdentifier',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'session': LinkSchema(
      id: 8140444348789920939,
      name: r'session',
      target: r'CollectionSession',
      single: true,
    )
  },
  embeddedSchemas: {
    r'Determination': DeterminationSchema,
    r'Measurement': MeasurementSchema,
    r'PhotoMetadata': PhotoMetadataSchema,
    r'SyncMetadata': SyncMetadataSchema
  },
  getId: _plantRecordGetId,
  getLinks: _plantRecordGetLinks,
  attach: _plantRecordAttach,
  version: '3.1.0+1',
);

int _plantRecordEstimateSize(
  PlantRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.associatedTaxa;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.audioNotePaths.length * 3;
  {
    for (var i = 0; i < object.audioNotePaths.length; i++) {
      final value = object.audioNotePaths[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.audioTranscripts.length * 3;
  {
    for (var i = 0; i < object.audioTranscripts.length; i++) {
      final value = object.audioTranscripts[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.category.name.length * 3;
  {
    final value = object.caule;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cauleCircunferenciaUnidade;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cauleCor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cauleDescricaoSeiva;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cauleTamanhoUnidade;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cauleTipoCasca;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.collectionMethod;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.collectorNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.commonName.length * 3;
  bytesCount += 3 + object.commonNameFts.length * 3;
  {
    final value = object.contributorName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.country;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.determinationQualifier;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.determinations.length * 3;
  {
    final offsets = allOffsets[Determination]!;
    for (var i = 0; i < object.determinations.length; i++) {
      final value = object.determinations[i];
      bytesCount +=
          DeterminationSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.deviceId.length * 3;
  {
    final value = object.duplicateOf;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.duplicateUuids.length * 3;
  {
    for (var i = 0; i < object.duplicateUuids.length; i++) {
      final value = object.duplicateUuids[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.family;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.florCor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.florDescricao;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.florInflorescencia;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.florTamanhoUnidade;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.folhaBainha;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.folhaDescricao;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.folhaLamina;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.folhaPeciolo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.frutoCor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.frutoDescricao;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.frutoFormato;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.frutoTamanhoUnidade;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.genus;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.habitat;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.iNaturalistId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.latestDetermination;
    if (value != null) {
      bytesCount += 3 +
          DeterminationSchema.estimateSize(
              value, allOffsets[Determination]!, allOffsets);
    }
  }
  {
    final value = object.locality;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.measurements.length * 3;
  {
    final offsets = allOffsets[Measurement]!;
    for (var i = 0; i < object.measurements.length; i++) {
      final value = object.measurements[i];
      bytesCount += MeasurementSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.moonPhase;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.municipality;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.phenologicalState;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.phenologyFournier;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.photoMetadata.length * 3;
  {
    final offsets = allOffsets[PhotoMetadata]!;
    for (var i = 0; i < object.photoMetadata.length; i++) {
      final value = object.photoMetadata[i];
      bytesCount +=
          PhotoMetadataSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.photoPaths.length * 3;
  {
    for (var i = 0; i < object.photoPaths.length; i++) {
      final value = object.photoPaths[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.raiz;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.registryIdentifier;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.scientificAuthor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.scientificName.length * 3;
  bytesCount += 3 + object.scientificNameFts.length * 3;
  {
    final value = object.sementeCor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sementeDescricao;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sementeFormato;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sementeTamanhoUnidade;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sessionId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.species;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.state;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.substrate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 +
      SyncMetadataSchema.estimateSize(
          object.syncMetadata, allOffsets[SyncMetadata]!, allOffsets);
  {
    final value = object.taxonStatus;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.topography;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.uuid.length * 3;
  {
    final value = object.vegetationType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.weatherCondition;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.weatherNotes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _plantRecordSerialize(
  PlantRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.altitude);
  writer.writeString(offsets[1], object.associatedTaxa);
  writer.writeStringList(offsets[2], object.audioNotePaths);
  writer.writeStringList(offsets[3], object.audioTranscripts);
  writer.writeString(offsets[4], object.category.name);
  writer.writeString(offsets[5], object.caule);
  writer.writeDouble(offsets[6], object.cauleCircunferencia);
  writer.writeString(offsets[7], object.cauleCircunferenciaUnidade);
  writer.writeString(offsets[8], object.cauleCor);
  writer.writeString(offsets[9], object.cauleDescricaoSeiva);
  writer.writeDouble(offsets[10], object.cauleTamanho);
  writer.writeString(offsets[11], object.cauleTamanhoUnidade);
  writer.writeBool(offsets[12], object.cauleTemSeiva);
  writer.writeString(offsets[13], object.cauleTipoCasca);
  writer.writeString(offsets[14], object.collectionMethod?.name);
  writer.writeString(offsets[15], object.collectorNumber);
  writer.writeString(offsets[16], object.commonName);
  writer.writeString(offsets[17], object.commonNameFts);
  writer.writeString(offsets[18], object.contributorName);
  writer.writeString(offsets[19], object.country);
  writer.writeDateTime(offsets[20], object.createdAt);
  writer.writeDateTime(offsets[21], object.dateCollected);
  writer.writeString(offsets[22], object.determinationQualifier);
  writer.writeObjectList<Determination>(
    offsets[23],
    allOffsets,
    DeterminationSchema.serialize,
    object.determinations,
  );
  writer.writeString(offsets[24], object.deviceId);
  writer.writeString(offsets[25], object.duplicateOf);
  writer.writeStringList(offsets[26], object.duplicateUuids);
  writer.writeString(offsets[27], object.family);
  writer.writeString(offsets[28], object.florCor);
  writer.writeString(offsets[29], object.florDescricao);
  writer.writeString(offsets[30], object.florInflorescencia);
  writer.writeDouble(offsets[31], object.florTamanho);
  writer.writeString(offsets[32], object.florTamanhoUnidade);
  writer.writeString(offsets[33], object.folhaBainha);
  writer.writeString(offsets[34], object.folhaDescricao);
  writer.writeString(offsets[35], object.folhaLamina);
  writer.writeString(offsets[36], object.folhaPeciolo);
  writer.writeString(offsets[37], object.frutoCor);
  writer.writeString(offsets[38], object.frutoDescricao);
  writer.writeString(offsets[39], object.frutoFormato);
  writer.writeDouble(offsets[40], object.frutoTamanho);
  writer.writeString(offsets[41], object.frutoTamanhoUnidade);
  writer.writeString(offsets[42], object.genus);
  writer.writeString(offsets[43], object.habitat);
  writer.writeDouble(offsets[44], object.humidity);
  writer.writeString(offsets[45], object.iNaturalistId);
  writer.writeDateTime(offsets[46], object.iNaturalistSyncedAt);
  writer.writeBool(offsets[47], object.isDraft);
  writer.writeObject<Determination>(
    offsets[48],
    allOffsets,
    DeterminationSchema.serialize,
    object.latestDetermination,
  );
  writer.writeDouble(offsets[49], object.latitude);
  writer.writeString(offsets[50], object.locality);
  writer.writeDouble(offsets[51], object.longitude);
  writer.writeObjectList<Measurement>(
    offsets[52],
    allOffsets,
    MeasurementSchema.serialize,
    object.measurements,
  );
  writer.writeString(offsets[53], object.moonPhase);
  writer.writeString(offsets[54], object.municipality);
  writer.writeString(offsets[55], object.notes);
  writer.writeLong(offsets[56], object.numberOfIndividuals);
  writer.writeString(offsets[57], object.phenologicalState?.name);
  writer.writeString(offsets[58], object.phenologyFournier);
  writer.writeObjectList<PhotoMetadata>(
    offsets[59],
    allOffsets,
    PhotoMetadataSchema.serialize,
    object.photoMetadata,
  );
  writer.writeStringList(offsets[60], object.photoPaths);
  writer.writeString(offsets[61], object.raiz);
  writer.writeString(offsets[62], object.registryIdentifier);
  writer.writeString(offsets[63], object.scientificAuthor);
  writer.writeString(offsets[64], object.scientificName);
  writer.writeString(offsets[65], object.scientificNameFts);
  writer.writeString(offsets[66], object.sementeCor);
  writer.writeString(offsets[67], object.sementeDescricao);
  writer.writeString(offsets[68], object.sementeFormato);
  writer.writeDouble(offsets[69], object.sementeTamanho);
  writer.writeString(offsets[70], object.sementeTamanhoUnidade);
  writer.writeString(offsets[71], object.sessionId);
  writer.writeString(offsets[72], object.species);
  writer.writeString(offsets[73], object.state);
  writer.writeString(offsets[74], object.substrate);
  writer.writeObject<SyncMetadata>(
    offsets[75],
    allOffsets,
    SyncMetadataSchema.serialize,
    object.syncMetadata,
  );
  writer.writeString(offsets[76], object.taxonStatus);
  writer.writeDouble(offsets[77], object.temperature);
  writer.writeString(offsets[78], object.topography);
  writer.writeDateTime(offsets[79], object.updatedAt);
  writer.writeString(offsets[80], object.uuid);
  writer.writeString(offsets[81], object.vegetationType);
  writer.writeString(offsets[82], object.weatherCondition);
  writer.writeString(offsets[83], object.weatherNotes);
  writer.writeDouble(offsets[84], object.windSpeed);
}

PlantRecord _plantRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlantRecord();
  object.altitude = reader.readDoubleOrNull(offsets[0]);
  object.associatedTaxa = reader.readStringOrNull(offsets[1]);
  object.audioNotePaths = reader.readStringList(offsets[2]) ?? [];
  object.audioTranscripts = reader.readStringList(offsets[3]) ?? [];
  object.category =
      _PlantRecordcategoryValueEnumMap[reader.readStringOrNull(offsets[4])] ??
          PlantCategory.trees;
  object.caule = reader.readStringOrNull(offsets[5]);
  object.cauleCircunferencia = reader.readDoubleOrNull(offsets[6]);
  object.cauleCircunferenciaUnidade = reader.readStringOrNull(offsets[7]);
  object.cauleCor = reader.readStringOrNull(offsets[8]);
  object.cauleDescricaoSeiva = reader.readStringOrNull(offsets[9]);
  object.cauleTamanho = reader.readDoubleOrNull(offsets[10]);
  object.cauleTamanhoUnidade = reader.readStringOrNull(offsets[11]);
  object.cauleTemSeiva = reader.readBool(offsets[12]);
  object.cauleTipoCasca = reader.readStringOrNull(offsets[13]);
  object.collectionMethod = _PlantRecordcollectionMethodValueEnumMap[
      reader.readStringOrNull(offsets[14])];
  object.collectorNumber = reader.readStringOrNull(offsets[15]);
  object.commonName = reader.readString(offsets[16]);
  object.commonNameFts = reader.readString(offsets[17]);
  object.contributorName = reader.readStringOrNull(offsets[18]);
  object.country = reader.readStringOrNull(offsets[19]);
  object.createdAt = reader.readDateTime(offsets[20]);
  object.dateCollected = reader.readDateTime(offsets[21]);
  object.determinationQualifier = reader.readStringOrNull(offsets[22]);
  object.determinations = reader.readObjectList<Determination>(
        offsets[23],
        DeterminationSchema.deserialize,
        allOffsets,
        Determination(),
      ) ??
      [];
  object.deviceId = reader.readString(offsets[24]);
  object.duplicateOf = reader.readStringOrNull(offsets[25]);
  object.duplicateUuids = reader.readStringList(offsets[26]) ?? [];
  object.family = reader.readStringOrNull(offsets[27]);
  object.florCor = reader.readStringOrNull(offsets[28]);
  object.florDescricao = reader.readStringOrNull(offsets[29]);
  object.florInflorescencia = reader.readStringOrNull(offsets[30]);
  object.florTamanho = reader.readDoubleOrNull(offsets[31]);
  object.florTamanhoUnidade = reader.readStringOrNull(offsets[32]);
  object.folhaBainha = reader.readStringOrNull(offsets[33]);
  object.folhaDescricao = reader.readStringOrNull(offsets[34]);
  object.folhaLamina = reader.readStringOrNull(offsets[35]);
  object.folhaPeciolo = reader.readStringOrNull(offsets[36]);
  object.frutoCor = reader.readStringOrNull(offsets[37]);
  object.frutoDescricao = reader.readStringOrNull(offsets[38]);
  object.frutoFormato = reader.readStringOrNull(offsets[39]);
  object.frutoTamanho = reader.readDoubleOrNull(offsets[40]);
  object.frutoTamanhoUnidade = reader.readStringOrNull(offsets[41]);
  object.genus = reader.readStringOrNull(offsets[42]);
  object.habitat = reader.readStringOrNull(offsets[43]);
  object.humidity = reader.readDoubleOrNull(offsets[44]);
  object.iNaturalistId = reader.readStringOrNull(offsets[45]);
  object.iNaturalistSyncedAt = reader.readDateTimeOrNull(offsets[46]);
  object.id = id;
  object.isDraft = reader.readBool(offsets[47]);
  object.latitude = reader.readDoubleOrNull(offsets[49]);
  object.locality = reader.readStringOrNull(offsets[50]);
  object.longitude = reader.readDoubleOrNull(offsets[51]);
  object.measurements = reader.readObjectList<Measurement>(
        offsets[52],
        MeasurementSchema.deserialize,
        allOffsets,
        Measurement(),
      ) ??
      [];
  object.moonPhase = reader.readStringOrNull(offsets[53]);
  object.municipality = reader.readStringOrNull(offsets[54]);
  object.notes = reader.readStringOrNull(offsets[55]);
  object.numberOfIndividuals = reader.readLongOrNull(offsets[56]);
  object.phenologicalState = _PlantRecordphenologicalStateValueEnumMap[
      reader.readStringOrNull(offsets[57])];
  object.phenologyFournier = reader.readStringOrNull(offsets[58]);
  object.photoMetadata = reader.readObjectList<PhotoMetadata>(
        offsets[59],
        PhotoMetadataSchema.deserialize,
        allOffsets,
        PhotoMetadata(),
      ) ??
      [];
  object.photoPaths = reader.readStringList(offsets[60]) ?? [];
  object.raiz = reader.readStringOrNull(offsets[61]);
  object.registryIdentifier = reader.readStringOrNull(offsets[62]);
  object.scientificAuthor = reader.readStringOrNull(offsets[63]);
  object.scientificName = reader.readString(offsets[64]);
  object.scientificNameFts = reader.readString(offsets[65]);
  object.sementeCor = reader.readStringOrNull(offsets[66]);
  object.sementeDescricao = reader.readStringOrNull(offsets[67]);
  object.sementeFormato = reader.readStringOrNull(offsets[68]);
  object.sementeTamanho = reader.readDoubleOrNull(offsets[69]);
  object.sementeTamanhoUnidade = reader.readStringOrNull(offsets[70]);
  object.sessionId = reader.readStringOrNull(offsets[71]);
  object.species = reader.readStringOrNull(offsets[72]);
  object.state = reader.readStringOrNull(offsets[73]);
  object.substrate = reader.readStringOrNull(offsets[74]);
  object.syncMetadata = reader.readObjectOrNull<SyncMetadata>(
        offsets[75],
        SyncMetadataSchema.deserialize,
        allOffsets,
      ) ??
      SyncMetadata();
  object.taxonStatus = reader.readStringOrNull(offsets[76]);
  object.temperature = reader.readDoubleOrNull(offsets[77]);
  object.topography = reader.readStringOrNull(offsets[78]);
  object.updatedAt = reader.readDateTime(offsets[79]);
  object.uuid = reader.readString(offsets[80]);
  object.vegetationType = reader.readStringOrNull(offsets[81]);
  object.weatherCondition = reader.readStringOrNull(offsets[82]);
  object.weatherNotes = reader.readStringOrNull(offsets[83]);
  object.windSpeed = reader.readDoubleOrNull(offsets[84]);
  return object;
}

P _plantRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (_PlantRecordcategoryValueEnumMap[
              reader.readStringOrNull(offset)] ??
          PlantCategory.trees) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (_PlantRecordcollectionMethodValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readDateTime(offset)) as P;
    case 21:
      return (reader.readDateTime(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readObjectList<Determination>(
            offset,
            DeterminationSchema.deserialize,
            allOffsets,
            Determination(),
          ) ??
          []) as P;
    case 24:
      return (reader.readString(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readStringList(offset) ?? []) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    case 28:
      return (reader.readStringOrNull(offset)) as P;
    case 29:
      return (reader.readStringOrNull(offset)) as P;
    case 30:
      return (reader.readStringOrNull(offset)) as P;
    case 31:
      return (reader.readDoubleOrNull(offset)) as P;
    case 32:
      return (reader.readStringOrNull(offset)) as P;
    case 33:
      return (reader.readStringOrNull(offset)) as P;
    case 34:
      return (reader.readStringOrNull(offset)) as P;
    case 35:
      return (reader.readStringOrNull(offset)) as P;
    case 36:
      return (reader.readStringOrNull(offset)) as P;
    case 37:
      return (reader.readStringOrNull(offset)) as P;
    case 38:
      return (reader.readStringOrNull(offset)) as P;
    case 39:
      return (reader.readStringOrNull(offset)) as P;
    case 40:
      return (reader.readDoubleOrNull(offset)) as P;
    case 41:
      return (reader.readStringOrNull(offset)) as P;
    case 42:
      return (reader.readStringOrNull(offset)) as P;
    case 43:
      return (reader.readStringOrNull(offset)) as P;
    case 44:
      return (reader.readDoubleOrNull(offset)) as P;
    case 45:
      return (reader.readStringOrNull(offset)) as P;
    case 46:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 47:
      return (reader.readBool(offset)) as P;
    case 48:
      return (reader.readObjectOrNull<Determination>(
        offset,
        DeterminationSchema.deserialize,
        allOffsets,
      )) as P;
    case 49:
      return (reader.readDoubleOrNull(offset)) as P;
    case 50:
      return (reader.readStringOrNull(offset)) as P;
    case 51:
      return (reader.readDoubleOrNull(offset)) as P;
    case 52:
      return (reader.readObjectList<Measurement>(
            offset,
            MeasurementSchema.deserialize,
            allOffsets,
            Measurement(),
          ) ??
          []) as P;
    case 53:
      return (reader.readStringOrNull(offset)) as P;
    case 54:
      return (reader.readStringOrNull(offset)) as P;
    case 55:
      return (reader.readStringOrNull(offset)) as P;
    case 56:
      return (reader.readLongOrNull(offset)) as P;
    case 57:
      return (_PlantRecordphenologicalStateValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 58:
      return (reader.readStringOrNull(offset)) as P;
    case 59:
      return (reader.readObjectList<PhotoMetadata>(
            offset,
            PhotoMetadataSchema.deserialize,
            allOffsets,
            PhotoMetadata(),
          ) ??
          []) as P;
    case 60:
      return (reader.readStringList(offset) ?? []) as P;
    case 61:
      return (reader.readStringOrNull(offset)) as P;
    case 62:
      return (reader.readStringOrNull(offset)) as P;
    case 63:
      return (reader.readStringOrNull(offset)) as P;
    case 64:
      return (reader.readString(offset)) as P;
    case 65:
      return (reader.readString(offset)) as P;
    case 66:
      return (reader.readStringOrNull(offset)) as P;
    case 67:
      return (reader.readStringOrNull(offset)) as P;
    case 68:
      return (reader.readStringOrNull(offset)) as P;
    case 69:
      return (reader.readDoubleOrNull(offset)) as P;
    case 70:
      return (reader.readStringOrNull(offset)) as P;
    case 71:
      return (reader.readStringOrNull(offset)) as P;
    case 72:
      return (reader.readStringOrNull(offset)) as P;
    case 73:
      return (reader.readStringOrNull(offset)) as P;
    case 74:
      return (reader.readStringOrNull(offset)) as P;
    case 75:
      return (reader.readObjectOrNull<SyncMetadata>(
            offset,
            SyncMetadataSchema.deserialize,
            allOffsets,
          ) ??
          SyncMetadata()) as P;
    case 76:
      return (reader.readStringOrNull(offset)) as P;
    case 77:
      return (reader.readDoubleOrNull(offset)) as P;
    case 78:
      return (reader.readStringOrNull(offset)) as P;
    case 79:
      return (reader.readDateTime(offset)) as P;
    case 80:
      return (reader.readString(offset)) as P;
    case 81:
      return (reader.readStringOrNull(offset)) as P;
    case 82:
      return (reader.readStringOrNull(offset)) as P;
    case 83:
      return (reader.readStringOrNull(offset)) as P;
    case 84:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PlantRecordcategoryEnumValueMap = {
  r'trees': r'trees',
  r'shrubs': r'shrubs',
  r'herbs': r'herbs',
  r'ferns': r'ferns',
  r'grasses': r'grasses',
  r'vines': r'vines',
  r'cacti': r'cacti',
  r'aquatic': r'aquatic',
};
const _PlantRecordcategoryValueEnumMap = {
  r'trees': PlantCategory.trees,
  r'shrubs': PlantCategory.shrubs,
  r'herbs': PlantCategory.herbs,
  r'ferns': PlantCategory.ferns,
  r'grasses': PlantCategory.grasses,
  r'vines': PlantCategory.vines,
  r'cacti': PlantCategory.cacti,
  r'aquatic': PlantCategory.aquatic,
};
const _PlantRecordcollectionMethodEnumValueMap = {
  r'voucherCollected': r'voucherCollected',
  r'photoOnly': r'photoOnly',
  r'sterileMaterial': r'sterileMaterial',
  r'livingMaterial': r'livingMaterial',
};
const _PlantRecordcollectionMethodValueEnumMap = {
  r'voucherCollected': CollectionMethod.voucherCollected,
  r'photoOnly': CollectionMethod.photoOnly,
  r'sterileMaterial': CollectionMethod.sterileMaterial,
  r'livingMaterial': CollectionMethod.livingMaterial,
};
const _PlantRecordphenologicalStateEnumValueMap = {
  r'flowering': r'flowering',
  r'fruiting': r'fruiting',
  r'budding': r'budding',
  r'withFruit': r'withFruit',
  r'vegetative': r'vegetative',
  r'sterile': r'sterile',
  r'unknown': r'unknown',
};
const _PlantRecordphenologicalStateValueEnumMap = {
  r'flowering': PhenologicalState.flowering,
  r'fruiting': PhenologicalState.fruiting,
  r'budding': PhenologicalState.budding,
  r'withFruit': PhenologicalState.withFruit,
  r'vegetative': PhenologicalState.vegetative,
  r'sterile': PhenologicalState.sterile,
  r'unknown': PhenologicalState.unknown,
};

Id _plantRecordGetId(PlantRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _plantRecordGetLinks(PlantRecord object) {
  return [object.session];
}

void _plantRecordAttach(
    IsarCollection<dynamic> col, Id id, PlantRecord object) {
  object.id = id;
  object.session
      .attach(col, col.isar.collection<CollectionSession>(), r'session', id);
}

extension PlantRecordByIndex on IsarCollection<PlantRecord> {
  Future<PlantRecord?> getByRegistryIdentifier(String? registryIdentifier) {
    return getByIndex(r'registryIdentifier', [registryIdentifier]);
  }

  PlantRecord? getByRegistryIdentifierSync(String? registryIdentifier) {
    return getByIndexSync(r'registryIdentifier', [registryIdentifier]);
  }

  Future<bool> deleteByRegistryIdentifier(String? registryIdentifier) {
    return deleteByIndex(r'registryIdentifier', [registryIdentifier]);
  }

  bool deleteByRegistryIdentifierSync(String? registryIdentifier) {
    return deleteByIndexSync(r'registryIdentifier', [registryIdentifier]);
  }

  Future<List<PlantRecord?>> getAllByRegistryIdentifier(
      List<String?> registryIdentifierValues) {
    final values = registryIdentifierValues.map((e) => [e]).toList();
    return getAllByIndex(r'registryIdentifier', values);
  }

  List<PlantRecord?> getAllByRegistryIdentifierSync(
      List<String?> registryIdentifierValues) {
    final values = registryIdentifierValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'registryIdentifier', values);
  }

  Future<int> deleteAllByRegistryIdentifier(
      List<String?> registryIdentifierValues) {
    final values = registryIdentifierValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'registryIdentifier', values);
  }

  int deleteAllByRegistryIdentifierSync(
      List<String?> registryIdentifierValues) {
    final values = registryIdentifierValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'registryIdentifier', values);
  }

  Future<Id> putByRegistryIdentifier(PlantRecord object) {
    return putByIndex(r'registryIdentifier', object);
  }

  Id putByRegistryIdentifierSync(PlantRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'registryIdentifier', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRegistryIdentifier(List<PlantRecord> objects) {
    return putAllByIndex(r'registryIdentifier', objects);
  }

  List<Id> putAllByRegistryIdentifierSync(List<PlantRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'registryIdentifier', objects,
        saveLinks: saveLinks);
  }
}

extension PlantRecordQueryWhereSort
    on QueryBuilder<PlantRecord, PlantRecord, QWhere> {
  QueryBuilder<PlantRecord, PlantRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhere> anyDateCollected() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateCollected'),
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhere> anyLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'latitude'),
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhere> anyLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'longitude'),
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhere> anyIsDraft() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isDraft'),
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension PlantRecordQueryWhere
    on QueryBuilder<PlantRecord, PlantRecord, QWhereClause> {
  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> uuidEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> uuidNotEqualTo(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      scientificNameEqualTo(String scientificName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'scientificName',
        value: [scientificName],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      scientificNameNotEqualTo(String scientificName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scientificName',
              lower: [],
              upper: [scientificName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scientificName',
              lower: [scientificName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scientificName',
              lower: [scientificName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scientificName',
              lower: [],
              upper: [scientificName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> commonNameEqualTo(
      String commonName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'commonName',
        value: [commonName],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      commonNameNotEqualTo(String commonName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commonName',
              lower: [],
              upper: [commonName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commonName',
              lower: [commonName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commonName',
              lower: [commonName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commonName',
              lower: [],
              upper: [commonName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      dateCollectedEqualTo(DateTime dateCollected) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateCollected',
        value: [dateCollected],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      dateCollectedNotEqualTo(DateTime dateCollected) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateCollected',
              lower: [],
              upper: [dateCollected],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateCollected',
              lower: [dateCollected],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateCollected',
              lower: [dateCollected],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateCollected',
              lower: [],
              upper: [dateCollected],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      dateCollectedGreaterThan(
    DateTime dateCollected, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateCollected',
        lower: [dateCollected],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      dateCollectedLessThan(
    DateTime dateCollected, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateCollected',
        lower: [],
        upper: [dateCollected],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      dateCollectedBetween(
    DateTime lowerDateCollected,
    DateTime upperDateCollected, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateCollected',
        lower: [lowerDateCollected],
        includeLower: includeLower,
        upper: [upperDateCollected],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> latitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'latitude',
        value: [null],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      latitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'latitude',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> latitudeEqualTo(
      double? latitude) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'latitude',
        value: [latitude],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> latitudeNotEqualTo(
      double? latitude) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'latitude',
              lower: [],
              upper: [latitude],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'latitude',
              lower: [latitude],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'latitude',
              lower: [latitude],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'latitude',
              lower: [],
              upper: [latitude],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> latitudeGreaterThan(
    double? latitude, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'latitude',
        lower: [latitude],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> latitudeLessThan(
    double? latitude, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'latitude',
        lower: [],
        upper: [latitude],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> latitudeBetween(
    double? lowerLatitude,
    double? upperLatitude, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'latitude',
        lower: [lowerLatitude],
        includeLower: includeLower,
        upper: [upperLatitude],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> longitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'longitude',
        value: [null],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      longitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'longitude',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> longitudeEqualTo(
      double? longitude) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'longitude',
        value: [longitude],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> longitudeNotEqualTo(
      double? longitude) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'longitude',
              lower: [],
              upper: [longitude],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'longitude',
              lower: [longitude],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'longitude',
              lower: [longitude],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'longitude',
              lower: [],
              upper: [longitude],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      longitudeGreaterThan(
    double? longitude, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'longitude',
        lower: [longitude],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> longitudeLessThan(
    double? longitude, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'longitude',
        lower: [],
        upper: [longitude],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> longitudeBetween(
    double? lowerLongitude,
    double? upperLongitude, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'longitude',
        lower: [lowerLongitude],
        includeLower: includeLower,
        upper: [upperLongitude],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      municipalityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'municipality',
        value: [null],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      municipalityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'municipality',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> municipalityEqualTo(
      String? municipality) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'municipality',
        value: [municipality],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      municipalityNotEqualTo(String? municipality) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'municipality',
              lower: [],
              upper: [municipality],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'municipality',
              lower: [municipality],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'municipality',
              lower: [municipality],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'municipality',
              lower: [],
              upper: [municipality],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> categoryEqualTo(
      PlantCategory category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'category',
        value: [category],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> categoryNotEqualTo(
      PlantCategory category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> isDraftEqualTo(
      bool isDraft) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isDraft',
        value: [isDraft],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> isDraftNotEqualTo(
      bool isDraft) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isDraft',
              lower: [],
              upper: [isDraft],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isDraft',
              lower: [isDraft],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isDraft',
              lower: [isDraft],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isDraft',
              lower: [],
              upper: [isDraft],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> sessionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sessionId',
        value: [null],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      sessionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> sessionIdEqualTo(
      String? sessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sessionId',
        value: [sessionId],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> sessionIdNotEqualTo(
      String? sessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> createdAtEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> createdAtNotEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> updatedAtEqualTo(
      DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> updatedAtNotEqualTo(
      DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause> updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      registryIdentifierIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'registryIdentifier',
        value: [null],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      registryIdentifierIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'registryIdentifier',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      registryIdentifierEqualTo(String? registryIdentifier) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'registryIdentifier',
        value: [registryIdentifier],
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterWhereClause>
      registryIdentifierNotEqualTo(String? registryIdentifier) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registryIdentifier',
              lower: [],
              upper: [registryIdentifier],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registryIdentifier',
              lower: [registryIdentifier],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registryIdentifier',
              lower: [registryIdentifier],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'registryIdentifier',
              lower: [],
              upper: [registryIdentifier],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PlantRecordQueryFilter
    on QueryBuilder<PlantRecord, PlantRecord, QFilterCondition> {
  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      altitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'altitude',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      altitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'altitude',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> altitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'altitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      altitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'altitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      altitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'altitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> altitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'altitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'associatedTaxa',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'associatedTaxa',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'associatedTaxa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'associatedTaxa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'associatedTaxa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'associatedTaxa',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'associatedTaxa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'associatedTaxa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'associatedTaxa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'associatedTaxa',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'associatedTaxa',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      associatedTaxaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'associatedTaxa',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioNotePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioNotePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioNotePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioNotePaths',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioNotePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioNotePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioNotePaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioNotePaths',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioNotePaths',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioNotePaths',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioNotePaths',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioNotePaths',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioNotePaths',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioNotePaths',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioNotePaths',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioNotePathsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioNotePaths',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioTranscripts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioTranscripts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioTranscripts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioTranscripts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioTranscripts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioTranscripts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioTranscripts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioTranscripts',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioTranscripts',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioTranscripts',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTranscripts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTranscripts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTranscripts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTranscripts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTranscripts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      audioTranscriptsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'audioTranscripts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> categoryEqualTo(
    PlantCategory value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      categoryGreaterThan(
    PlantCategory value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      categoryLessThan(
    PlantCategory value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> categoryBetween(
    PlantCategory lower,
    PlantCategory upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> categoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'caule',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'caule',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'caule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'caule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'caule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'caule',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'caule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'caule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'caule',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'caule',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'caule',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'caule',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cauleCircunferencia',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cauleCircunferencia',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleCircunferencia',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cauleCircunferencia',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cauleCircunferencia',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cauleCircunferencia',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cauleCircunferenciaUnidade',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cauleCircunferenciaUnidade',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleCircunferenciaUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cauleCircunferenciaUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cauleCircunferenciaUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cauleCircunferenciaUnidade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cauleCircunferenciaUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cauleCircunferenciaUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cauleCircunferenciaUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cauleCircunferenciaUnidade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleCircunferenciaUnidade',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCircunferenciaUnidadeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cauleCircunferenciaUnidade',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cauleCor',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cauleCor',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleCorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cauleCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cauleCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleCorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cauleCor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cauleCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cauleCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cauleCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> cauleCorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cauleCor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleCor',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleCorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cauleCor',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cauleDescricaoSeiva',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cauleDescricaoSeiva',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleDescricaoSeiva',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cauleDescricaoSeiva',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cauleDescricaoSeiva',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cauleDescricaoSeiva',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cauleDescricaoSeiva',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cauleDescricaoSeiva',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cauleDescricaoSeiva',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cauleDescricaoSeiva',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleDescricaoSeiva',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleDescricaoSeivaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cauleDescricaoSeiva',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cauleTamanho',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cauleTamanho',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cauleTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cauleTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cauleTamanho',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cauleTamanhoUnidade',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cauleTamanhoUnidade',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cauleTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cauleTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cauleTamanhoUnidade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cauleTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cauleTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cauleTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cauleTamanhoUnidade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleTamanhoUnidade',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTamanhoUnidadeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cauleTamanhoUnidade',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTemSeivaEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleTemSeiva',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cauleTipoCasca',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cauleTipoCasca',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleTipoCasca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cauleTipoCasca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cauleTipoCasca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cauleTipoCasca',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cauleTipoCasca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cauleTipoCasca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cauleTipoCasca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cauleTipoCasca',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cauleTipoCasca',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      cauleTipoCascaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cauleTipoCasca',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'collectionMethod',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'collectionMethod',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodEqualTo(
    CollectionMethod? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collectionMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodGreaterThan(
    CollectionMethod? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'collectionMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodLessThan(
    CollectionMethod? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'collectionMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodBetween(
    CollectionMethod? lower,
    CollectionMethod? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'collectionMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'collectionMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'collectionMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'collectionMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'collectionMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collectionMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectionMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'collectionMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'collectorNumber',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'collectorNumber',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collectorNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'collectorNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'collectorNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'collectorNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'collectorNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'collectorNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'collectorNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'collectorNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collectorNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      collectorNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'collectorNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commonName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commonName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commonName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commonName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commonName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameFtsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commonNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameFtsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commonNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameFtsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commonNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameFtsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commonNameFts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameFtsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commonNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameFtsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commonNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameFtsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commonNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameFtsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commonNameFts',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameFtsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commonNameFts',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      commonNameFtsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commonNameFts',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contributorName',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contributorName',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contributorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contributorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contributorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contributorName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contributorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contributorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contributorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contributorName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contributorName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      contributorNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contributorName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      countryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'country',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      countryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'country',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> countryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      countryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> countryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> countryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'country',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      countryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> countryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> countryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> countryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'country',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      countryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      countryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'country',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      dateCollectedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateCollected',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      dateCollectedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateCollected',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      dateCollectedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateCollected',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      dateCollectedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateCollected',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'determinationQualifier',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'determinationQualifier',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'determinationQualifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'determinationQualifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'determinationQualifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'determinationQualifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'determinationQualifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'determinationQualifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'determinationQualifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'determinationQualifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'determinationQualifier',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationQualifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'determinationQualifier',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'determinations',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'determinations',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'determinations',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'determinations',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'determinations',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'determinations',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> deviceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      deviceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      deviceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> deviceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      deviceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      deviceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      deviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> deviceIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      deviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      deviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'duplicateOf',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'duplicateOf',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duplicateOf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duplicateOf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duplicateOf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duplicateOf',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'duplicateOf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'duplicateOf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'duplicateOf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'duplicateOf',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duplicateOf',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateOfIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'duplicateOf',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duplicateUuids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duplicateUuids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duplicateUuids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duplicateUuids',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'duplicateUuids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'duplicateUuids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'duplicateUuids',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'duplicateUuids',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duplicateUuids',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'duplicateUuids',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'duplicateUuids',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'duplicateUuids',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'duplicateUuids',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'duplicateUuids',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'duplicateUuids',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      duplicateUuidsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'duplicateUuids',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> familyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'family',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      familyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'family',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> familyEqualTo(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> familyLessThan(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> familyBetween(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> familyEndsWith(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> familyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'family',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> familyMatches(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      familyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'family',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      familyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'family',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florCorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'florCor',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florCorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'florCor',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> florCorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'florCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florCorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'florCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> florCorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'florCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> florCorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'florCor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florCorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'florCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> florCorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'florCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> florCorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'florCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> florCorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'florCor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florCorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'florCor',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florCorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'florCor',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'florDescricao',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'florDescricao',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'florDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'florDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'florDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'florDescricao',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'florDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'florDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'florDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'florDescricao',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'florDescricao',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florDescricaoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'florDescricao',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'florInflorescencia',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'florInflorescencia',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'florInflorescencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'florInflorescencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'florInflorescencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'florInflorescencia',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'florInflorescencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'florInflorescencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'florInflorescencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'florInflorescencia',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'florInflorescencia',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florInflorescenciaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'florInflorescencia',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'florTamanho',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'florTamanho',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'florTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'florTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'florTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'florTamanho',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'florTamanhoUnidade',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'florTamanhoUnidade',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'florTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'florTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'florTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'florTamanhoUnidade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'florTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'florTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'florTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'florTamanhoUnidade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'florTamanhoUnidade',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      florTamanhoUnidadeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'florTamanhoUnidade',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'folhaBainha',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'folhaBainha',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folhaBainha',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folhaBainha',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folhaBainha',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folhaBainha',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'folhaBainha',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'folhaBainha',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'folhaBainha',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'folhaBainha',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folhaBainha',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaBainhaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'folhaBainha',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'folhaDescricao',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'folhaDescricao',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folhaDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folhaDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folhaDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folhaDescricao',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'folhaDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'folhaDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'folhaDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'folhaDescricao',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folhaDescricao',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaDescricaoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'folhaDescricao',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'folhaLamina',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'folhaLamina',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folhaLamina',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folhaLamina',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folhaLamina',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folhaLamina',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'folhaLamina',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'folhaLamina',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'folhaLamina',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'folhaLamina',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folhaLamina',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaLaminaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'folhaLamina',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'folhaPeciolo',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'folhaPeciolo',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folhaPeciolo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folhaPeciolo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folhaPeciolo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folhaPeciolo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'folhaPeciolo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'folhaPeciolo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'folhaPeciolo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'folhaPeciolo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folhaPeciolo',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      folhaPecioloIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'folhaPeciolo',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoCorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'frutoCor',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoCorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'frutoCor',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> frutoCorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frutoCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoCorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'frutoCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoCorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'frutoCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> frutoCorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'frutoCor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoCorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'frutoCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoCorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'frutoCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoCorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'frutoCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> frutoCorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'frutoCor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoCorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frutoCor',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoCorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'frutoCor',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'frutoDescricao',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'frutoDescricao',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frutoDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'frutoDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'frutoDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'frutoDescricao',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'frutoDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'frutoDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'frutoDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'frutoDescricao',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frutoDescricao',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoDescricaoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'frutoDescricao',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'frutoFormato',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'frutoFormato',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frutoFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'frutoFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'frutoFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'frutoFormato',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'frutoFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'frutoFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'frutoFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'frutoFormato',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frutoFormato',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoFormatoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'frutoFormato',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'frutoTamanho',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'frutoTamanho',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frutoTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'frutoTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'frutoTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'frutoTamanho',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'frutoTamanhoUnidade',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'frutoTamanhoUnidade',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frutoTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'frutoTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'frutoTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'frutoTamanhoUnidade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'frutoTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'frutoTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'frutoTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'frutoTamanhoUnidade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frutoTamanhoUnidade',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      frutoTamanhoUnidadeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'frutoTamanhoUnidade',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> genusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'genus',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      genusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'genus',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> genusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      genusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'genus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> genusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'genus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> genusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'genus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> genusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'genus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> genusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'genus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> genusContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'genus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> genusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'genus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> genusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genus',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      genusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'genus',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      habitatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'habitat',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      habitatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'habitat',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> habitatEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      habitatGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'habitat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> habitatLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'habitat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> habitatBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'habitat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      habitatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'habitat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> habitatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'habitat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> habitatContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'habitat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> habitatMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'habitat',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      habitatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitat',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      habitatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'habitat',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      humidityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'humidity',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      humidityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'humidity',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> humidityEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'humidity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      humidityGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'humidity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      humidityLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'humidity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> humidityBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'humidity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'iNaturalistId',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'iNaturalistId',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iNaturalistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iNaturalistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iNaturalistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iNaturalistId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iNaturalistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iNaturalistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iNaturalistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iNaturalistId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iNaturalistId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iNaturalistId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'iNaturalistSyncedAt',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'iNaturalistSyncedAt',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iNaturalistSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistSyncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iNaturalistSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistSyncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iNaturalistSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      iNaturalistSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iNaturalistSyncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> isDraftEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDraft',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      latestDeterminationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'latestDetermination',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      latestDeterminationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'latestDetermination',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      latitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      latitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> latitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      latitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      latitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> latitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      localityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'locality',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      localityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'locality',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> localityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      localityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      localityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> localityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      localityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      localityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      localityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'locality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> localityMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'locality',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      localityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locality',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      localityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'locality',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      longitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      longitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      longitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      longitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      longitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      longitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      measurementsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'measurements',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      measurementsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'measurements',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      measurementsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'measurements',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      measurementsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'measurements',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      measurementsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'measurements',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      measurementsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'measurements',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'moonPhase',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'moonPhase',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moonPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moonPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moonPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moonPhase',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moonPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moonPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moonPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moonPhase',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moonPhase',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      moonPhaseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moonPhase',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'municipality',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'municipality',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'municipality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'municipality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'municipality',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'municipality',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      municipalityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'municipality',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> notesEqualTo(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> notesLessThan(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> notesBetween(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> notesStartsWith(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> notesEndsWith(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> notesContains(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> notesMatches(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      numberOfIndividualsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'numberOfIndividuals',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      numberOfIndividualsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'numberOfIndividuals',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      numberOfIndividualsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfIndividuals',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      numberOfIndividualsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfIndividuals',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      numberOfIndividualsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfIndividuals',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      numberOfIndividualsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfIndividuals',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phenologicalState',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phenologicalState',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateEqualTo(
    PhenologicalState? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phenologicalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateGreaterThan(
    PhenologicalState? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phenologicalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateLessThan(
    PhenologicalState? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phenologicalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateBetween(
    PhenologicalState? lower,
    PhenologicalState? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phenologicalState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phenologicalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phenologicalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phenologicalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phenologicalState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phenologicalState',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologicalStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phenologicalState',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phenologyFournier',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phenologyFournier',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phenologyFournier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phenologyFournier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phenologyFournier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phenologyFournier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phenologyFournier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phenologyFournier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phenologyFournier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phenologyFournier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phenologyFournier',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      phenologyFournierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phenologyFournier',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoMetadataLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoMetadata',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoMetadataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoMetadata',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoMetadataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoMetadata',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoMetadataLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoMetadata',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoMetadataLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoMetadata',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoMetadataLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoMetadata',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoPaths',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoPaths',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoPaths',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoPaths',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoPathsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> raizIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'raiz',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      raizIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'raiz',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> raizEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'raiz',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> raizGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'raiz',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> raizLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'raiz',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> raizBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'raiz',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> raizStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'raiz',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> raizEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'raiz',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> raizContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'raiz',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> raizMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'raiz',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> raizIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'raiz',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      raizIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'raiz',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'registryIdentifier',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'registryIdentifier',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registryIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'registryIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'registryIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'registryIdentifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'registryIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'registryIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'registryIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'registryIdentifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'registryIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      registryIdentifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'registryIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scientificAuthor',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scientificAuthor',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scientificAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scientificAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scientificAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scientificAuthor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scientificAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scientificAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scientificAuthor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scientificAuthor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scientificAuthor',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificAuthorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scientificAuthor',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scientificName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scientificName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scientificName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scientificName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scientificName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scientificName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scientificName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scientificName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scientificName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scientificName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameFtsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scientificNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameFtsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scientificNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameFtsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scientificNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameFtsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scientificNameFts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameFtsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scientificNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameFtsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scientificNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameFtsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scientificNameFts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameFtsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scientificNameFts',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameFtsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scientificNameFts',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      scientificNameFtsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scientificNameFts',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sementeCor',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sementeCor',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sementeCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sementeCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sementeCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sementeCor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sementeCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sementeCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sementeCor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sementeCor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sementeCor',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeCorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sementeCor',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sementeDescricao',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sementeDescricao',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sementeDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sementeDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sementeDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sementeDescricao',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sementeDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sementeDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sementeDescricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sementeDescricao',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sementeDescricao',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeDescricaoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sementeDescricao',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sementeFormato',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sementeFormato',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sementeFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sementeFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sementeFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sementeFormato',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sementeFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sementeFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sementeFormato',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sementeFormato',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sementeFormato',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeFormatoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sementeFormato',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sementeTamanho',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sementeTamanho',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sementeTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sementeTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sementeTamanho',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sementeTamanho',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sementeTamanhoUnidade',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sementeTamanhoUnidade',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sementeTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sementeTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sementeTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sementeTamanhoUnidade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sementeTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sementeTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sementeTamanhoUnidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sementeTamanhoUnidade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sementeTamanhoUnidade',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sementeTamanhoUnidadeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sementeTamanhoUnidade',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sessionId',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sessionId',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      speciesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'species',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      speciesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'species',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> speciesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'species',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      speciesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'species',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> speciesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'species',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> speciesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'species',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      speciesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'species',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> speciesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'species',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> speciesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'species',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> speciesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'species',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      speciesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'species',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      speciesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'species',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> stateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'state',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      stateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'state',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> stateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      stateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> stateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> stateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> stateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> stateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> stateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> stateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'state',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> stateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      stateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'substrate',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'substrate',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'substrate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'substrate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'substrate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'substrate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'substrate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'substrate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'substrate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'substrate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'substrate',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      substrateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'substrate',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxonStatus',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxonStatus',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxonStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxonStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxonStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxonStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taxonStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taxonStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taxonStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taxonStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxonStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      taxonStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taxonStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      temperatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'temperature',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      temperatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'temperature',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      temperatureEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      temperatureGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      temperatureLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      temperatureBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'temperature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'topography',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'topography',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topography',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topography',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topography',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topography',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      topographyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topography',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> uuidStartsWith(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> uuidEndsWith(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> uuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> uuidMatches(
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

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vegetationType',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vegetationType',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vegetationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vegetationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vegetationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vegetationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vegetationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vegetationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vegetationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vegetationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vegetationType',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      vegetationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vegetationType',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weatherCondition',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weatherCondition',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weatherCondition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weatherCondition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weatherCondition',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weatherCondition',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherConditionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weatherCondition',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weatherNotes',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weatherNotes',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weatherNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weatherNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weatherNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weatherNotes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weatherNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weatherNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weatherNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weatherNotes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weatherNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      weatherNotesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weatherNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      windSpeedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'windSpeed',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      windSpeedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'windSpeed',
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      windSpeedEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'windSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      windSpeedGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'windSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      windSpeedLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'windSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      windSpeedBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'windSpeed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PlantRecordQueryObject
    on QueryBuilder<PlantRecord, PlantRecord, QFilterCondition> {
  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      determinationsElement(FilterQuery<Determination> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'determinations');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      latestDetermination(FilterQuery<Determination> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'latestDetermination');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      measurementsElement(FilterQuery<Measurement> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'measurements');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      photoMetadataElement(FilterQuery<PhotoMetadata> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'photoMetadata');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> syncMetadata(
      FilterQuery<SyncMetadata> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'syncMetadata');
    });
  }
}

extension PlantRecordQueryLinks
    on QueryBuilder<PlantRecord, PlantRecord, QFilterCondition> {
  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition> session(
      FilterQuery<CollectionSession> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'session');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterFilterCondition>
      sessionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'session', 0, true, 0, true);
    });
  }
}

extension PlantRecordQuerySortBy
    on QueryBuilder<PlantRecord, PlantRecord, QSortBy> {
  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByAltitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'altitude', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByAltitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'altitude', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByAssociatedTaxa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associatedTaxa', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByAssociatedTaxaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associatedTaxa', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCaule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caule', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCauleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caule', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleCircunferencia() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCircunferencia', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleCircunferenciaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCircunferencia', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleCircunferenciaUnidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCircunferenciaUnidade', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleCircunferenciaUnidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCircunferenciaUnidade', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCauleCor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCor', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCauleCorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCor', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleDescricaoSeiva() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleDescricaoSeiva', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleDescricaoSeivaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleDescricaoSeiva', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCauleTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTamanho', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleTamanhoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTamanho', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleTamanhoUnidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTamanhoUnidade', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleTamanhoUnidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTamanhoUnidade', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCauleTemSeiva() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTemSeiva', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleTemSeivaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTemSeiva', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCauleTipoCasca() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTipoCasca', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCauleTipoCascaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTipoCasca', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCollectionMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionMethod', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCollectionMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionMethod', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCollectorNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectorNumber', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCollectorNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectorNumber', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCommonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonName', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCommonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonName', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCommonNameFts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonNameFts', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByCommonNameFtsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonNameFts', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByContributorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contributorName', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByContributorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contributorName', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByDateCollected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollected', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByDateCollectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollected', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByDeterminationQualifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'determinationQualifier', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByDeterminationQualifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'determinationQualifier', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByDuplicateOf() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicateOf', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByDuplicateOfDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicateOf', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'family', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'family', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFlorCor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florCor', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFlorCorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florCor', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFlorDescricao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florDescricao', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFlorDescricaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florDescricao', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFlorInflorescencia() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florInflorescencia', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFlorInflorescenciaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florInflorescencia', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFlorTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florTamanho', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFlorTamanhoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florTamanho', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFlorTamanhoUnidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florTamanhoUnidade', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFlorTamanhoUnidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florTamanhoUnidade', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFolhaBainha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaBainha', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFolhaBainhaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaBainha', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFolhaDescricao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaDescricao', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFolhaDescricaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaDescricao', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFolhaLamina() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaLamina', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFolhaLaminaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaLamina', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFolhaPeciolo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaPeciolo', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFolhaPecioloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaPeciolo', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFrutoCor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoCor', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFrutoCorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoCor', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFrutoDescricao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoDescricao', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFrutoDescricaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoDescricao', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFrutoFormato() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoFormato', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFrutoFormatoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoFormato', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByFrutoTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoTamanho', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFrutoTamanhoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoTamanho', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFrutoTamanhoUnidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoTamanhoUnidade', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByFrutoTamanhoUnidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoTamanhoUnidade', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByGenus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'genus', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByGenusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'genus', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByHabitat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitat', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByHabitatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitat', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByHumidity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'humidity', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByHumidityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'humidity', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByINaturalistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iNaturalistId', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByINaturalistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iNaturalistId', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByINaturalistSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iNaturalistSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByINaturalistSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iNaturalistSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByIsDraft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDraft', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByIsDraftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDraft', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByLocality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByLocalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByMoonPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moonPhase', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByMoonPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moonPhase', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByMunicipality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipality', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByMunicipalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipality', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByNumberOfIndividuals() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfIndividuals', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByNumberOfIndividualsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfIndividuals', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByPhenologicalState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phenologicalState', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByPhenologicalStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phenologicalState', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByPhenologyFournier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phenologyFournier', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByPhenologyFournierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phenologyFournier', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByRaiz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'raiz', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByRaizDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'raiz', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByRegistryIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registryIdentifier', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByRegistryIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registryIdentifier', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByScientificAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificAuthor', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByScientificAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificAuthor', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByScientificName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificName', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByScientificNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificName', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByScientificNameFts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificNameFts', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByScientificNameFtsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificNameFts', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortBySementeCor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeCor', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortBySementeCorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeCor', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortBySementeDescricao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeDescricao', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortBySementeDescricaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeDescricao', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortBySementeFormato() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeFormato', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortBySementeFormatoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeFormato', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortBySementeTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeTamanho', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortBySementeTamanhoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeTamanho', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortBySementeTamanhoUnidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeTamanhoUnidade', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortBySementeTamanhoUnidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeTamanhoUnidade', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortBySpecies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'species', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortBySpeciesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'species', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortBySubstrate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'substrate', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortBySubstrateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'substrate', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByTaxonStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxonStatus', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByTaxonStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxonStatus', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByTopography() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topography', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByTopographyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topography', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByVegetationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegetationType', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByVegetationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegetationType', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByWeatherCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherCondition', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByWeatherConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherCondition', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByWeatherNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherNotes', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      sortByWeatherNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherNotes', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByWindSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windSpeed', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> sortByWindSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windSpeed', Sort.desc);
    });
  }
}

extension PlantRecordQuerySortThenBy
    on QueryBuilder<PlantRecord, PlantRecord, QSortThenBy> {
  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByAltitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'altitude', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByAltitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'altitude', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByAssociatedTaxa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associatedTaxa', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByAssociatedTaxaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associatedTaxa', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCaule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caule', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCauleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caule', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleCircunferencia() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCircunferencia', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleCircunferenciaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCircunferencia', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleCircunferenciaUnidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCircunferenciaUnidade', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleCircunferenciaUnidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCircunferenciaUnidade', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCauleCor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCor', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCauleCorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleCor', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleDescricaoSeiva() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleDescricaoSeiva', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleDescricaoSeivaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleDescricaoSeiva', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCauleTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTamanho', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleTamanhoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTamanho', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleTamanhoUnidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTamanhoUnidade', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleTamanhoUnidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTamanhoUnidade', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCauleTemSeiva() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTemSeiva', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleTemSeivaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTemSeiva', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCauleTipoCasca() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTipoCasca', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCauleTipoCascaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cauleTipoCasca', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCollectionMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionMethod', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCollectionMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionMethod', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCollectorNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectorNumber', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCollectorNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectorNumber', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCommonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonName', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCommonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonName', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCommonNameFts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonNameFts', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByCommonNameFtsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commonNameFts', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByContributorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contributorName', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByContributorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contributorName', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByDateCollected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollected', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByDateCollectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollected', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByDeterminationQualifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'determinationQualifier', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByDeterminationQualifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'determinationQualifier', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByDuplicateOf() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicateOf', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByDuplicateOfDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duplicateOf', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'family', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'family', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFlorCor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florCor', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFlorCorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florCor', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFlorDescricao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florDescricao', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFlorDescricaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florDescricao', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFlorInflorescencia() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florInflorescencia', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFlorInflorescenciaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florInflorescencia', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFlorTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florTamanho', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFlorTamanhoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florTamanho', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFlorTamanhoUnidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florTamanhoUnidade', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFlorTamanhoUnidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'florTamanhoUnidade', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFolhaBainha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaBainha', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFolhaBainhaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaBainha', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFolhaDescricao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaDescricao', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFolhaDescricaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaDescricao', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFolhaLamina() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaLamina', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFolhaLaminaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaLamina', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFolhaPeciolo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaPeciolo', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFolhaPecioloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folhaPeciolo', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFrutoCor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoCor', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFrutoCorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoCor', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFrutoDescricao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoDescricao', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFrutoDescricaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoDescricao', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFrutoFormato() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoFormato', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFrutoFormatoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoFormato', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByFrutoTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoTamanho', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFrutoTamanhoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoTamanho', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFrutoTamanhoUnidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoTamanhoUnidade', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByFrutoTamanhoUnidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frutoTamanhoUnidade', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByGenus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'genus', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByGenusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'genus', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByHabitat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitat', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByHabitatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitat', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByHumidity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'humidity', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByHumidityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'humidity', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByINaturalistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iNaturalistId', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByINaturalistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iNaturalistId', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByINaturalistSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iNaturalistSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByINaturalistSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iNaturalistSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByIsDraft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDraft', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByIsDraftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDraft', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByLocality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByLocalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByMoonPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moonPhase', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByMoonPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moonPhase', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByMunicipality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipality', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByMunicipalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'municipality', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByNumberOfIndividuals() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfIndividuals', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByNumberOfIndividualsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfIndividuals', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByPhenologicalState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phenologicalState', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByPhenologicalStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phenologicalState', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByPhenologyFournier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phenologyFournier', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByPhenologyFournierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phenologyFournier', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByRaiz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'raiz', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByRaizDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'raiz', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByRegistryIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registryIdentifier', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByRegistryIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'registryIdentifier', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByScientificAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificAuthor', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByScientificAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificAuthor', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByScientificName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificName', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByScientificNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificName', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByScientificNameFts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificNameFts', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByScientificNameFtsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scientificNameFts', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenBySementeCor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeCor', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenBySementeCorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeCor', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenBySementeDescricao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeDescricao', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenBySementeDescricaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeDescricao', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenBySementeFormato() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeFormato', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenBySementeFormatoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeFormato', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenBySementeTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeTamanho', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenBySementeTamanhoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeTamanho', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenBySementeTamanhoUnidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeTamanhoUnidade', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenBySementeTamanhoUnidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sementeTamanhoUnidade', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenBySpecies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'species', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenBySpeciesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'species', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenBySubstrate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'substrate', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenBySubstrateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'substrate', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByTaxonStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxonStatus', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByTaxonStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxonStatus', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByTopography() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topography', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByTopographyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topography', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByVegetationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegetationType', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByVegetationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vegetationType', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByWeatherCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherCondition', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByWeatherConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherCondition', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByWeatherNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherNotes', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy>
      thenByWeatherNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherNotes', Sort.desc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByWindSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windSpeed', Sort.asc);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QAfterSortBy> thenByWindSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'windSpeed', Sort.desc);
    });
  }
}

extension PlantRecordQueryWhereDistinct
    on QueryBuilder<PlantRecord, PlantRecord, QDistinct> {
  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByAltitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'altitude');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByAssociatedTaxa(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'associatedTaxa',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByAudioNotePaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioNotePaths');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByAudioTranscripts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioTranscripts');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCaule(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'caule', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByCauleCircunferencia() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cauleCircunferencia');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByCauleCircunferenciaUnidade({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cauleCircunferenciaUnidade',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCauleCor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cauleCor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByCauleDescricaoSeiva({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cauleDescricaoSeiva',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCauleTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cauleTamanho');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByCauleTamanhoUnidade({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cauleTamanhoUnidade',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCauleTemSeiva() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cauleTemSeiva');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCauleTipoCasca(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cauleTipoCasca',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCollectionMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'collectionMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCollectorNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'collectorNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCommonName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commonName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCommonNameFts(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commonNameFts',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByContributorName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contributorName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCountry(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'country', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByDateCollected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCollected');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByDeterminationQualifier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'determinationQualifier',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByDeviceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByDuplicateOf(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duplicateOf', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByDuplicateUuids() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duplicateUuids');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFamily(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'family', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFlorCor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'florCor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFlorDescricao(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'florDescricao',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByFlorInflorescencia({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'florInflorescencia',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFlorTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'florTamanho');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByFlorTamanhoUnidade({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'florTamanhoUnidade',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFolhaBainha(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folhaBainha', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFolhaDescricao(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folhaDescricao',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFolhaLamina(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folhaLamina', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFolhaPeciolo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folhaPeciolo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFrutoCor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frutoCor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFrutoDescricao(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frutoDescricao',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFrutoFormato(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frutoFormato', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByFrutoTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frutoTamanho');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByFrutoTamanhoUnidade({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frutoTamanhoUnidade',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByGenus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByHabitat(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByHumidity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'humidity');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByINaturalistId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iNaturalistId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByINaturalistSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iNaturalistSyncedAt');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByIsDraft() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDraft');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByLocality(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locality', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByMoonPhase(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moonPhase', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByMunicipality(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'municipality', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByNumberOfIndividuals() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfIndividuals');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByPhenologicalState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phenologicalState',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByPhenologyFournier(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phenologyFournier',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByPhotoPaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoPaths');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByRaiz(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'raiz', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctByRegistryIdentifier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'registryIdentifier',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByScientificAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scientificAuthor',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByScientificName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scientificName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByScientificNameFts(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scientificNameFts',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctBySementeCor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sementeCor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctBySementeDescricao(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sementeDescricao',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctBySementeFormato(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sementeFormato',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctBySementeTamanho() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sementeTamanho');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct>
      distinctBySementeTamanhoUnidade({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sementeTamanhoUnidade',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctBySessionId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctBySpecies(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'species', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctBySubstrate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'substrate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByTaxonStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxonStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'temperature');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByTopography(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topography', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByVegetationType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vegetationType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByWeatherCondition(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weatherCondition',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByWeatherNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weatherNotes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlantRecord, PlantRecord, QDistinct> distinctByWindSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'windSpeed');
    });
  }
}

extension PlantRecordQueryProperty
    on QueryBuilder<PlantRecord, PlantRecord, QQueryProperty> {
  QueryBuilder<PlantRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations> altitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'altitude');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      associatedTaxaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'associatedTaxa');
    });
  }

  QueryBuilder<PlantRecord, List<String>, QQueryOperations>
      audioNotePathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioNotePaths');
    });
  }

  QueryBuilder<PlantRecord, List<String>, QQueryOperations>
      audioTranscriptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioTranscripts');
    });
  }

  QueryBuilder<PlantRecord, PlantCategory, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> cauleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'caule');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations>
      cauleCircunferenciaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cauleCircunferencia');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      cauleCircunferenciaUnidadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cauleCircunferenciaUnidade');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> cauleCorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cauleCor');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      cauleDescricaoSeivaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cauleDescricaoSeiva');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations> cauleTamanhoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cauleTamanho');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      cauleTamanhoUnidadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cauleTamanhoUnidade');
    });
  }

  QueryBuilder<PlantRecord, bool, QQueryOperations> cauleTemSeivaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cauleTemSeiva');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      cauleTipoCascaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cauleTipoCasca');
    });
  }

  QueryBuilder<PlantRecord, CollectionMethod?, QQueryOperations>
      collectionMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collectionMethod');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      collectorNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collectorNumber');
    });
  }

  QueryBuilder<PlantRecord, String, QQueryOperations> commonNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commonName');
    });
  }

  QueryBuilder<PlantRecord, String, QQueryOperations> commonNameFtsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commonNameFts');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      contributorNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contributorName');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> countryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'country');
    });
  }

  QueryBuilder<PlantRecord, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PlantRecord, DateTime, QQueryOperations>
      dateCollectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCollected');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      determinationQualifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'determinationQualifier');
    });
  }

  QueryBuilder<PlantRecord, List<Determination>, QQueryOperations>
      determinationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'determinations');
    });
  }

  QueryBuilder<PlantRecord, String, QQueryOperations> deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceId');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> duplicateOfProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duplicateOf');
    });
  }

  QueryBuilder<PlantRecord, List<String>, QQueryOperations>
      duplicateUuidsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duplicateUuids');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> familyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'family');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> florCorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'florCor');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> florDescricaoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'florDescricao');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      florInflorescenciaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'florInflorescencia');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations> florTamanhoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'florTamanho');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      florTamanhoUnidadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'florTamanhoUnidade');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> folhaBainhaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folhaBainha');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      folhaDescricaoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folhaDescricao');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> folhaLaminaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folhaLamina');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> folhaPecioloProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folhaPeciolo');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> frutoCorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frutoCor');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      frutoDescricaoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frutoDescricao');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> frutoFormatoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frutoFormato');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations> frutoTamanhoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frutoTamanho');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      frutoTamanhoUnidadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frutoTamanhoUnidade');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> genusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genus');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> habitatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitat');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations> humidityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'humidity');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> iNaturalistIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iNaturalistId');
    });
  }

  QueryBuilder<PlantRecord, DateTime?, QQueryOperations>
      iNaturalistSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iNaturalistSyncedAt');
    });
  }

  QueryBuilder<PlantRecord, bool, QQueryOperations> isDraftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDraft');
    });
  }

  QueryBuilder<PlantRecord, Determination?, QQueryOperations>
      latestDeterminationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latestDetermination');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> localityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locality');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<PlantRecord, List<Measurement>, QQueryOperations>
      measurementsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measurements');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> moonPhaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moonPhase');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> municipalityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'municipality');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<PlantRecord, int?, QQueryOperations>
      numberOfIndividualsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfIndividuals');
    });
  }

  QueryBuilder<PlantRecord, PhenologicalState?, QQueryOperations>
      phenologicalStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phenologicalState');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      phenologyFournierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phenologyFournier');
    });
  }

  QueryBuilder<PlantRecord, List<PhotoMetadata>, QQueryOperations>
      photoMetadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoMetadata');
    });
  }

  QueryBuilder<PlantRecord, List<String>, QQueryOperations>
      photoPathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoPaths');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> raizProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'raiz');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      registryIdentifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'registryIdentifier');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      scientificAuthorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scientificAuthor');
    });
  }

  QueryBuilder<PlantRecord, String, QQueryOperations> scientificNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scientificName');
    });
  }

  QueryBuilder<PlantRecord, String, QQueryOperations>
      scientificNameFtsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scientificNameFts');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> sementeCorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sementeCor');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      sementeDescricaoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sementeDescricao');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      sementeFormatoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sementeFormato');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations>
      sementeTamanhoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sementeTamanho');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      sementeTamanhoUnidadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sementeTamanhoUnidade');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> speciesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'species');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> substrateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'substrate');
    });
  }

  QueryBuilder<PlantRecord, SyncMetadata, QQueryOperations>
      syncMetadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncMetadata');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> taxonStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxonStatus');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations> temperatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'temperature');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> topographyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topography');
    });
  }

  QueryBuilder<PlantRecord, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<PlantRecord, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      vegetationTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vegetationType');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations>
      weatherConditionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weatherCondition');
    });
  }

  QueryBuilder<PlantRecord, String?, QQueryOperations> weatherNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weatherNotes');
    });
  }

  QueryBuilder<PlantRecord, double?, QQueryOperations> windSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'windSpeed');
    });
  }
}
