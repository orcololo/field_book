import 'package:isar/isar.dart';
import 'collection_method.dart';
import 'measurement.dart';
import 'phenological_state.dart';
import 'photo_metadata.dart';
import 'plant_category.dart';
import 'determination.dart';
import 'sync_metadata.dart';
import 'collection_session.dart';

part 'plant_record.g.dart';

@collection
class PlantRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late String uuid;

  @Index()
  late String scientificName;

  @Index()
  String commonName = '';

  // Full-text search fields (lowercase for FTS)
  late String scientificNameFts;
  late String commonNameFts;

  String? family;
  String? scientificAuthor;
  String? taxonStatus;
  String? genus;
  String? species;
  String? habitat;

  // Morphology fields
  String? raiz;
  String? caule;
  String? cauleTipoCasca;
  String? cauleCor;
  double? cauleTamanho;
  String? cauleTamanhoUnidade;
  double? cauleCircunferencia;
  String? cauleCircunferenciaUnidade;
  bool cauleTemSeiva = false;
  String? cauleDescricaoSeiva;
  String? folhaDescricao;
  String? folhaBainha;
  String? folhaPeciolo;
  String? folhaLamina;

  // Flor (Flower) sub-fields
  String? florDescricao;
  String? florInflorescencia;
  String? florCor;
  double? florTamanho;
  String? florTamanhoUnidade;

  // Fruto (Fruit) sub-fields
  String? frutoDescricao;
  String? frutoCor;
  String? frutoFormato;
  double? frutoTamanho;
  String? frutoTamanhoUnidade;

  // Semente (Seed) sub-fields
  String? sementeDescricao;
  String? sementeCor;
  String? sementeFormato;
  double? sementeTamanho;
  String? sementeTamanhoUnidade;

  @Index()
  late DateTime dateCollected;

  @Index()
  double? latitude;

  @Index()
  double? longitude;

  String? locality;
  String? state;
  String? country;

  @Index()
  String? municipality;

  @Enumerated(EnumType.name)
  @Index()
  late PlantCategory category;

  List<Determination> determinations = [];
  List<Measurement> measurements = [];
  List<String> photoPaths = [];
  List<String> imageRefsJson = [];
  List<PhotoMetadata> photoMetadata = [];
  List<String> audioNotePaths = [];
  List<String> audioTranscripts = [];
  String? duplicateOf;
  List<String> duplicateUuids = [];
  String? notes;
  String? iNaturalistId;
  DateTime? iNaturalistSyncedAt;

  // Environmental / field conditions
  double? altitude; // meters above sea level
  double? temperature; // °C
  double? humidity; // % relative humidity
  String? weatherCondition; // e.g. sunny, cloudy, rainy, overcast
  String? weatherNotes;
  String? moonPhase; // canonical values: new, waxing, full, waning
  double? windSpeed; // km/h

  // Botanical field notebook fields (herbarium standards)
  String?
  collectorNumber; // Darwin Core: recordNumber (collector's personal sequential number)
  int? numberOfIndividuals; // Darwin Core: individualCount
  String?
  substrate; // soil/substrate type (e.g. "solo argiloso", "rocha", "epífita")
  String? associatedTaxa; // Darwin Core: other species found alongside
  String?
  vegetationType; // biome/vegetation type (e.g. "Cerrado", "Mata Atlântica")
  String? topography; // terrain description (slope, valley, hilltop, riparian)
  String?
  determinationQualifier; // taxonomic uncertainty marker: "cf.", "aff.", "?"

  @Enumerated(EnumType.name)
  PhenologicalState? phenologicalState;

  // Escala Fournier fenologia (String estruturada tipo "botão:3,flor:2,fruto_imaturo:0,fruto_maduro:1,queda_foliar:0")
  String? phenologyFournier;

  @Enumerated(EnumType.name)
  CollectionMethod? collectionMethod;

  @Index()
  bool isDraft = true;

  @Index()
  String? sessionId;

  final session = IsarLink<CollectionSession>();

  late String deviceId;
  String? contributorName;
  List<String> coCollectors = [];

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  // Registry identifier (e.g., "RC000001")
  @Index(unique: true, replace: false)
  String? registryIdentifier;

  SyncMetadata syncMetadata = SyncMetadata();

  Determination? get latestDetermination {
    if (determinations.isEmpty) return null;

    final sorted = [...determinations]
      ..sort((a, b) => b.determinedAt.compareTo(a.determinedAt));

    return sorted.first;
  }

  void applyLatestDetermination() {
    final latest = latestDetermination;
    if (latest == null) return;

    scientificName = latest.scientificName;
    family = latest.family;
  }

  // Helper method to update FTS fields
  void updateFtsFields() {
    scientificNameFts = scientificName.toLowerCase();
    commonNameFts = commonName.toLowerCase();
  }
}
