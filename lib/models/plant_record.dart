import 'package:isar/isar.dart';
import 'measurement.dart';
import 'photo_metadata.dart';
import 'plant_category.dart';
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

  @Enumerated(EnumType.name)
  @Index()
  late PlantCategory category;

  List<Measurement> measurements = [];
  List<String> photoPaths = [];
  List<PhotoMetadata> photoMetadata = [];
  List<String> audioNotePaths = [];
  List<String> audioTranscripts = [];
  String? notes;

  // Environmental / field conditions
  double? altitude; // meters above sea level
  double? temperature; // °C
  double? humidity; // % relative humidity
  String? weatherCondition; // e.g. sunny, cloudy, rainy, overcast
  double? windSpeed; // km/h

  @Index()
  bool isDraft = true;

  @Index()
  String? sessionId;

  final session = IsarLink<CollectionSession>();

  late String deviceId;
  String? contributorName;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  // Registry identifier (e.g., "RC000001")
  @Index(unique: true, replace: false)
  String? registryIdentifier;

  SyncMetadata syncMetadata = SyncMetadata();

  // Helper method to update FTS fields
  void updateFtsFields() {
    scientificNameFts = scientificName.toLowerCase();
    commonNameFts = commonName.toLowerCase();
  }
}
