import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import '../../../models/plant_record.dart';
import '../../../models/plant_category.dart';
import '../../../models/collection_method.dart';
import '../../../models/collection_template.dart';
import '../../../models/measurement.dart';
import '../../../models/phenological_state.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/repositories/session_repository.dart';
import '../../../core/repositories/template_repository.dart';
import '../../../core/services/audio_transcription_service.dart';
import '../../../core/services/coords_validation_service.dart';
import '../../../core/services/geocoding_service.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/services/registry_identifier_service.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/services/plantnet_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/ocr_service.dart';
import '../../../core/services/photo_service.dart';
import '../../../core/utils/biome_detector.dart';
import '../../../core/utils/botanical_validator.dart';
import '../../../shared/widgets/map_widget.dart';
import '../../../shared/widgets/ocr_review_dialog.dart';
import '../../../shared/widgets/fenologia_fournier_widget.dart';
import '../../../shared/widgets/plantnet_results_sheet.dart';
import '../../../shared/widgets/audio/audio_recorder_widget.dart';
import '../../../shared/widgets/audio/audio_player_widget.dart';
import '../../../shared/widgets/rain_mode_guard.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/rain_mode_provider.dart';
import '../../../shared/widgets/modern/modern_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _uuid = Uuid();

/// SharedPreferences key for the pre-camera form-state snapshot.
/// Written before launching the camera; cleared when camera returns normally.
/// On Android, the Activity may be killed while the camera is in the
/// foreground — on the next launch this snapshot restores all form fields.
const _kPlantFormSnapshotKey = 'folium_plant_form_snapshot';

enum _OcrImageSource { camera, gallery }

class _LocationSnapshot {
  final String locality;
  final String municipality;
  final String state;
  final String country;

  const _LocationSnapshot({
    required this.locality,
    required this.municipality,
    required this.state,
    required this.country,
  });
}

class PlantFormScreen extends ConsumerStatefulWidget {
  final PlantRecord? plant; // null for new plant, populated for edit

  const PlantFormScreen({super.key, this.plant});

  @override
  ConsumerState<PlantFormScreen> createState() => _PlantFormScreenState();
}

class _PlantFormScreenState extends ConsumerState<PlantFormScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Form fields
  late TextEditingController _scientificNameController;
  late TextEditingController _commonNameController;
  late TextEditingController _familyController;
  late TextEditingController _genusController;
  late TextEditingController _speciesController;
  late TextEditingController _habitatController;
  late TextEditingController _notesController;
  late TextEditingController _identifierController;
  late TextEditingController _localityController;
  late TextEditingController _municipalityController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;

  // Morphology controllers
  late TextEditingController _raizController;
  late TextEditingController _cauleController;
  late TextEditingController _cauleTipoCascaController;
  late TextEditingController _cauleCorController;
  late TextEditingController _cauleTamanhoController;
  String _cauleTamanhoUnidade = 'cm';
  late TextEditingController _cauleCircunferenciaController;
  String _cauleCircunferenciaUnidade = 'cm';
  bool _cauleTemSeiva = false;
  late TextEditingController _cauleDescricaoSeivaController;
  late TextEditingController _folhaDescricaoController;
  late TextEditingController _folhaBainhaController;
  late TextEditingController _folhaPecioloController;
  late TextEditingController _folhaLaminaController;
  // Flor sub-field controllers
  late TextEditingController _florDescricaoController;
  late TextEditingController _florInflorescenciaController;
  late TextEditingController _florCorController;
  late TextEditingController _florTamanhoController;
  String _florTamanhoUnidade = 'cm';
  // Fruto sub-field controllers
  late TextEditingController _frutoDescricaoController;
  late TextEditingController _frutoCorController;
  late TextEditingController _frutoFormatoController;
  late TextEditingController _frutoTamanhoController;
  String _frutoTamanhoUnidade = 'cm';
  // Semente sub-field controllers
  late TextEditingController _sementeDescricaoController;
  late TextEditingController _sementeCorController;
  late TextEditingController _sementeFormatoController;
  late TextEditingController _sementeTamanhoController;
  String _sementeTamanhoUnidade = 'mm';

  PlantCategory? _selectedCategory;
  String? _selectedSessionId;
  DateTime _dateCollected = DateTime.now();
  double? _latitude;
  double? _longitude;
  bool _fetchingLocation = false;
  List<String> _photoPaths = [];
  List<Measurement> _measurements = [];
  List<String> _audioNotePaths = [];
  List<String> _audioTranscripts = [];

  // Environmental data
  final _altitudeController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _humidityController = TextEditingController();
  final _weatherNotesController = TextEditingController();
  final _windSpeedController = TextEditingController();
  String? _weatherCondition;
  String? _moonPhase;
  bool _showOfflineLocationHint = false;
  _LocationSnapshot? _lastLocationSnapshot;

  // Botanical field notebook fields
  final _collectorNumberController = TextEditingController();
  final _collectorNameController = TextEditingController();
  final _numberOfIndividualsController = TextEditingController();
  final _substrateController = TextEditingController();
  final _associatedTaxaController = TextEditingController();
  final _vegetationTypeController = TextEditingController();
  final _topographyController = TextEditingController();
  final _determinationQualifierController = TextEditingController();
  String? _phenologyFournier;
  PhenologicalState? _phenologicalState;
  CollectionMethod? _collectionMethod;

  List<String> _duplicateWarnings = [];
  String? _suggestedFamily;
  Timer? _debounceTimer;
  AsyncValue<void> _plantNetIdentificationState = const AsyncData(null);
  bool _templateSuggestionHandled = false;
  bool _isProcessingOcr = false;

  final _locationService = LocationService();
  final _geocodingService = GeocodingService();
  final _weatherService = WeatherService();
  final _photoService = PhotoService();
  final _ocrService = OcrService();
  final _audioTranscriptionService = AudioTranscriptionService();
  late final BotanicalValidator _validator;
  late final RegistryIdentifierService _identifierService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    final plantRepo = ref.read(plantRepositoryProvider);
    _validator = BotanicalValidator(plantRepo);
    _identifierService = RegistryIdentifierService(plantRepository: plantRepo);

    // Initialize controllers
    final plant = widget.plant;
    _scientificNameController = TextEditingController(
      text: plant?.scientificName ?? '',
    );
    _commonNameController = TextEditingController(
      text: plant?.commonName ?? '',
    );
    _familyController = TextEditingController(text: plant?.family ?? '');
    _genusController = TextEditingController(text: plant?.genus ?? '');
    _speciesController = TextEditingController(text: plant?.species ?? '');
    _habitatController = TextEditingController(text: plant?.habitat ?? '');
    _notesController = TextEditingController(text: plant?.notes ?? '');
    _identifierController = TextEditingController(
      text: plant?.registryIdentifier ?? '',
    );
    _localityController = TextEditingController(text: plant?.locality ?? '');
    _municipalityController = TextEditingController(
      text: plant?.municipality ?? '',
    );
    _stateController = TextEditingController(text: plant?.state ?? '');
    _countryController = TextEditingController(text: plant?.country ?? '');

    // Morphology controllers
    _raizController = TextEditingController(text: plant?.raiz ?? '');
    _cauleController = TextEditingController(text: plant?.caule ?? '');
    _cauleTipoCascaController = TextEditingController(
      text: plant?.cauleTipoCasca ?? '',
    );
    _cauleCorController = TextEditingController(text: plant?.cauleCor ?? '');
    _cauleTamanhoController = TextEditingController(
      text: plant?.cauleTamanho != null ? plant!.cauleTamanho.toString() : '',
    );
    _cauleTamanhoUnidade = plant?.cauleTamanhoUnidade ?? 'cm';
    _cauleCircunferenciaController = TextEditingController(
      text: plant?.cauleCircunferencia != null
          ? plant!.cauleCircunferencia.toString()
          : '',
    );
    _cauleCircunferenciaUnidade = plant?.cauleCircunferenciaUnidade ?? 'cm';
    _cauleTemSeiva = plant?.cauleTemSeiva ?? false;
    _cauleDescricaoSeivaController = TextEditingController(
      text: plant?.cauleDescricaoSeiva ?? '',
    );
    _folhaDescricaoController = TextEditingController(
      text: plant?.folhaDescricao ?? '',
    );
    _folhaBainhaController = TextEditingController(
      text: plant?.folhaBainha ?? '',
    );
    _folhaPecioloController = TextEditingController(
      text: plant?.folhaPeciolo ?? '',
    );
    _folhaLaminaController = TextEditingController(
      text: plant?.folhaLamina ?? '',
    );
    // Flor
    _florDescricaoController = TextEditingController(
      text: plant?.florDescricao ?? '',
    );
    _florInflorescenciaController = TextEditingController(
      text: plant?.florInflorescencia ?? '',
    );
    _florCorController = TextEditingController(text: plant?.florCor ?? '');
    _florTamanhoController = TextEditingController(
      text: plant?.florTamanho != null ? plant!.florTamanho.toString() : '',
    );
    _florTamanhoUnidade = plant?.florTamanhoUnidade ?? 'cm';
    // Fruto
    _frutoDescricaoController = TextEditingController(
      text: plant?.frutoDescricao ?? '',
    );
    _frutoCorController = TextEditingController(text: plant?.frutoCor ?? '');
    _frutoFormatoController = TextEditingController(
      text: plant?.frutoFormato ?? '',
    );
    _frutoTamanhoController = TextEditingController(
      text: plant?.frutoTamanho != null ? plant!.frutoTamanho.toString() : '',
    );
    _frutoTamanhoUnidade = plant?.frutoTamanhoUnidade ?? 'cm';
    // Semente
    _sementeDescricaoController = TextEditingController(
      text: plant?.sementeDescricao ?? '',
    );
    _sementeCorController = TextEditingController(
      text: plant?.sementeCor ?? '',
    );
    _sementeFormatoController = TextEditingController(
      text: plant?.sementeFormato ?? '',
    );
    _sementeTamanhoController = TextEditingController(
      text: plant?.sementeTamanho != null
          ? plant!.sementeTamanho.toString()
          : '',
    );
    _sementeTamanhoUnidade = plant?.sementeTamanhoUnidade ?? 'mm';

    // Add listeners for auto-suggestions
    _scientificNameController.addListener(_onScientificNameChanged);
    _genusController.addListener(_onGenusChanged);

    // Initialize values
    if (plant != null) {
      _selectedCategory = plant.category;
      _selectedSessionId = plant.sessionId;
      _dateCollected = plant.dateCollected;
      _latitude = plant.latitude;
      _longitude = plant.longitude;
      _photoPaths = List.from(plant.photoPaths);
      _audioNotePaths = List.from(plant.audioNotePaths);
      _audioTranscripts = List.from(plant.audioTranscripts);
      _measurements = plant.measurements.map((m) {
        return Measurement()
          ..label = m.label
          ..value = m.value
          ..unit = m.unit;
      }).toList();
      // Environmental data
      _altitudeController.text = plant.altitude?.toString() ?? '';
      _temperatureController.text = plant.temperature?.toString() ?? '';
      _humidityController.text = plant.humidity?.toString() ?? '';
      _weatherNotesController.text = plant.weatherNotes ?? '';
      _windSpeedController.text = plant.windSpeed?.toString() ?? '';
      _weatherCondition = plant.weatherCondition;
      _moonPhase = plant.moonPhase;
      // Botanical field notebook fields
      _collectorNameController.text = plant.contributorName ?? '';
      _collectorNumberController.text = plant.collectorNumber ?? '';
      _numberOfIndividualsController.text =
          plant.numberOfIndividuals?.toString() ?? '';
      _substrateController.text = plant.substrate ?? '';
      _associatedTaxaController.text = plant.associatedTaxa ?? '';
      _vegetationTypeController.text = plant.vegetationType ?? '';
      _topographyController.text = plant.topography ?? '';
      _determinationQualifierController.text =
          plant.determinationQualifier ?? '';
      _phenologicalState = plant.phenologicalState;
      _phenologyFournier = plant.phenologyFournier;
      _collectionMethod = plant.collectionMethod;
    }

    if (plant == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        _suggestTemplateFromCurrentGps();
        await _tryRestoreFromSnapshot();
        await _tryRecoverLostPhoto();
      });
    }
  }

  void _onScientificNameChanged() {
    final name = _scientificNameController.text;
    if (name.isEmpty) return;

    // Parse genus and species
    final parsed = _validator.parseScientificName(name);
    if (parsed['genus'] != null && _genusController.text != parsed['genus']) {
      _genusController.text = parsed['genus']!;
    }
    if (parsed['species'] != null &&
        _speciesController.text != parsed['species']) {
      _speciesController.text = parsed['species']!;
    }

    // Check for duplicates with debounce to avoid excessive DB queries
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _checkDuplicates();
    });
  }

  void _onGenusChanged() {
    final genus = _genusController.text;
    if (genus.isEmpty) {
      setState(() => _suggestedFamily = null);
      return;
    }

    // Suggest family
    final suggestedFamily = _validator.suggestFamily(genus);
    if (suggestedFamily != null && suggestedFamily != _familyController.text) {
      setState(() => _suggestedFamily = suggestedFamily);
    } else {
      setState(() => _suggestedFamily = null);
    }
  }

  Future<void> _checkDuplicates() async {
    final duplicates = await _validator.checkForDuplicates(
      _scientificNameController.text,
      excludeId: widget.plant?.uuid,
    );
    if (!mounted) return;

    setState(() {
      _duplicateWarnings = duplicates;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _tabController.dispose();
    _scientificNameController.dispose();
    _commonNameController.dispose();
    _familyController.dispose();
    _genusController.dispose();
    _speciesController.dispose();
    _habitatController.dispose();
    _notesController.dispose();
    _identifierController.dispose();
    _localityController.dispose();
    _municipalityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _raizController.dispose();
    _cauleController.dispose();
    _cauleTipoCascaController.dispose();
    _cauleCorController.dispose();
    _cauleTamanhoController.dispose();
    _cauleCircunferenciaController.dispose();
    _cauleDescricaoSeivaController.dispose();
    _folhaDescricaoController.dispose();
    _folhaBainhaController.dispose();
    _folhaPecioloController.dispose();
    _folhaLaminaController.dispose();
    _florDescricaoController.dispose();
    _florInflorescenciaController.dispose();
    _florCorController.dispose();
    _florTamanhoController.dispose();
    _frutoDescricaoController.dispose();
    _frutoCorController.dispose();
    _frutoFormatoController.dispose();
    _frutoTamanhoController.dispose();
    _sementeDescricaoController.dispose();
    _sementeCorController.dispose();
    _sementeFormatoController.dispose();
    _sementeTamanhoController.dispose();
    _altitudeController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _weatherNotesController.dispose();
    _windSpeedController.dispose();
    _collectorNameController.dispose();
    _collectorNumberController.dispose();
    _numberOfIndividualsController.dispose();
    _substrateController.dispose();
    _associatedTaxaController.dispose();
    _vegetationTypeController.dispose();
    _topographyController.dispose();
    _determinationQualifierController.dispose();
    super.dispose();
  }

  Future<void> _generateIdentifier() async {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    try {
      final identifier = await _identifierService.generateNextIdentifier();
      if (!mounted) return;
      setState(() {
        _identifierController.text = identifier;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.identifierGenerated(identifier)),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorGeneratingIdentifier(e.toString())),
          backgroundColor: colorScheme.error,
        ),
      );
    }
  }

  Future<void> _savePlant({required bool asDraft}) async {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    if (!asDraft && !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillRequiredFields),
          backgroundColor: colorScheme.error,
        ),
      );
      return;
    }

    final settings = await ref.read(settingsNotifierProvider.future);
    final plantRepo = ref.read(plantRepositoryProvider);

    // Handle registry identifier
    String? registryIdentifier = _identifierController.text.trim();
    final bool isEditing = widget.plant != null;
    final String? existingIdentifier = widget.plant?.registryIdentifier;

    if (registryIdentifier.isEmpty &&
        settings.autoGenerateIdentifier &&
        !asDraft &&
        !isEditing) {
      // Auto-generate identifier for NEW non-draft plants only
      try {
        registryIdentifier = await _identifierService.generateNextIdentifier();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorGeneratingIdentifier(e.toString())),
              backgroundColor: colorScheme.error,
            ),
          );
        }
        return;
      }
    } else if (registryIdentifier.isNotEmpty) {
      // Only validate if identifier has changed or it's a new plant
      if (!isEditing || registryIdentifier != existingIdentifier) {
        final validationError = await _identifierService
            .validateCustomIdentifier(
              registryIdentifier,
              excludePlantUuid: widget.plant?.uuid,
            );

        if (validationError != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(validationError),
                backgroundColor: colorScheme.error,
              ),
            );
          }
          return;
        }
      }
    } else {
      // Empty identifier for drafts is acceptable
      registryIdentifier = null;
    }

    final shouldContinue = await _confirmCoordsValidationIfNeeded();
    if (!shouldContinue) {
      return;
    }

    final isNewPlant = widget.plant == null;
    final plant = widget.plant ?? PlantRecord();

    // Update all fields
    plant
      ..uuid = isNewPlant ? _uuid.v4() : plant.uuid
      ..scientificName = _scientificNameController.text.trim()
      ..commonName = _commonNameController.text.trim()
      ..family = _familyController.text.trim().isEmpty
          ? null
          : _familyController.text.trim()
      ..genus = _genusController.text.trim().isEmpty
          ? null
          : _genusController.text.trim()
      ..species = _speciesController.text.trim().isEmpty
          ? null
          : _speciesController.text.trim()
      ..habitat = _habitatController.text.trim().isEmpty
          ? null
          : _habitatController.text.trim()
      ..notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim()
      ..raiz = _raizController.text.trim().isEmpty
          ? null
          : _raizController.text.trim()
      ..caule = _cauleController.text.trim().isEmpty
          ? null
          : _cauleController.text.trim()
      ..cauleTipoCasca = _cauleTipoCascaController.text.trim().isEmpty
          ? null
          : _cauleTipoCascaController.text.trim()
      ..cauleCor = _cauleCorController.text.trim().isEmpty
          ? null
          : _cauleCorController.text.trim()
      ..cauleTamanho = _cauleTamanhoController.text.trim().isNotEmpty
          ? double.tryParse(_cauleTamanhoController.text.trim())
          : null
      ..cauleTamanhoUnidade = _cauleTamanhoController.text.trim().isNotEmpty
          ? _cauleTamanhoUnidade
          : null
      ..cauleCircunferencia =
          _cauleCircunferenciaController.text.trim().isNotEmpty
          ? double.tryParse(_cauleCircunferenciaController.text.trim())
          : null
      ..cauleCircunferenciaUnidade =
          _cauleCircunferenciaController.text.trim().isNotEmpty
          ? _cauleCircunferenciaUnidade
          : null
      ..cauleTemSeiva = _cauleTemSeiva
      ..cauleDescricaoSeiva = _cauleDescricaoSeivaController.text.trim().isEmpty
          ? null
          : _cauleDescricaoSeivaController.text.trim()
      ..folhaDescricao = _folhaDescricaoController.text.trim().isEmpty
          ? null
          : _folhaDescricaoController.text.trim()
      ..folhaBainha = _folhaBainhaController.text.trim().isEmpty
          ? null
          : _folhaBainhaController.text.trim()
      ..folhaPeciolo = _folhaPecioloController.text.trim().isEmpty
          ? null
          : _folhaPecioloController.text.trim()
      ..folhaLamina = _folhaLaminaController.text.trim().isEmpty
          ? null
          : _folhaLaminaController.text.trim()
      ..florDescricao = _florDescricaoController.text.trim().isEmpty
          ? null
          : _florDescricaoController.text.trim()
      ..florInflorescencia = _florInflorescenciaController.text.trim().isEmpty
          ? null
          : _florInflorescenciaController.text.trim()
      ..florCor = _florCorController.text.trim().isEmpty
          ? null
          : _florCorController.text.trim()
      ..florTamanho = _florTamanhoController.text.trim().isNotEmpty
          ? double.tryParse(_florTamanhoController.text.trim())
          : null
      ..florTamanhoUnidade = _florTamanhoController.text.trim().isNotEmpty
          ? _florTamanhoUnidade
          : null
      ..frutoDescricao = _frutoDescricaoController.text.trim().isEmpty
          ? null
          : _frutoDescricaoController.text.trim()
      ..frutoCor = _frutoCorController.text.trim().isEmpty
          ? null
          : _frutoCorController.text.trim()
      ..frutoFormato = _frutoFormatoController.text.trim().isEmpty
          ? null
          : _frutoFormatoController.text.trim()
      ..frutoTamanho = _frutoTamanhoController.text.trim().isNotEmpty
          ? double.tryParse(_frutoTamanhoController.text.trim())
          : null
      ..frutoTamanhoUnidade = _frutoTamanhoController.text.trim().isNotEmpty
          ? _frutoTamanhoUnidade
          : null
      ..sementeDescricao = _sementeDescricaoController.text.trim().isEmpty
          ? null
          : _sementeDescricaoController.text.trim()
      ..sementeCor = _sementeCorController.text.trim().isEmpty
          ? null
          : _sementeCorController.text.trim()
      ..sementeFormato = _sementeFormatoController.text.trim().isEmpty
          ? null
          : _sementeFormatoController.text.trim()
      ..sementeTamanho = _sementeTamanhoController.text.trim().isNotEmpty
          ? double.tryParse(_sementeTamanhoController.text.trim())
          : null
      ..sementeTamanhoUnidade = _sementeTamanhoController.text.trim().isNotEmpty
          ? _sementeTamanhoUnidade
          : null
      ..category = _selectedCategory ?? PlantCategory.herbs
      ..dateCollected = _dateCollected
      ..latitude = _latitude
      ..longitude = _longitude
      ..locality = _emptyToNull(_localityController.text)
      ..municipality = _emptyToNull(_municipalityController.text)
      ..state = _emptyToNull(_stateController.text)
      ..country = _emptyToNull(_countryController.text)
      ..determinations = isNewPlant
          ? []
          : widget.plant!.determinations.map((determination) {
              return determination;
            }).toList()
      ..altitude = _altitudeController.text.trim().isNotEmpty
          ? double.tryParse(_altitudeController.text.trim())
          : null
      ..temperature = _temperatureController.text.trim().isNotEmpty
          ? double.tryParse(_temperatureController.text.trim())
          : null
      ..humidity = _humidityController.text.trim().isNotEmpty
          ? double.tryParse(_humidityController.text.trim())
          : null
      ..windSpeed = _windSpeedController.text.trim().isNotEmpty
          ? double.tryParse(_windSpeedController.text.trim())
          : null
      ..weatherCondition = _weatherCondition
      ..weatherNotes = _emptyToNull(_weatherNotesController.text)
      ..moonPhase = _moonPhase
      ..contributorName = _collectorNameController.text.trim().isNotEmpty
          ? _collectorNameController.text.trim()
          : settings.deviceName
      ..collectorNumber = _collectorNumberController.text.trim().isNotEmpty
          ? _collectorNumberController.text.trim()
          : null
      ..numberOfIndividuals =
          _numberOfIndividualsController.text.trim().isNotEmpty
          ? int.tryParse(_numberOfIndividualsController.text.trim())
          : null
      ..substrate = _substrateController.text.trim().isNotEmpty
          ? _substrateController.text.trim()
          : null
      ..associatedTaxa = _associatedTaxaController.text.trim().isNotEmpty
          ? _associatedTaxaController.text.trim()
          : null
      ..vegetationType = _vegetationTypeController.text.trim().isNotEmpty
          ? _vegetationTypeController.text.trim()
          : null
      ..topography = _topographyController.text.trim().isNotEmpty
          ? _topographyController.text.trim()
          : null
      ..determinationQualifier =
          _determinationQualifierController.text.trim().isNotEmpty
          ? _determinationQualifierController.text.trim()
          : null
      ..phenologicalState = _phenologicalState
      ..phenologyFournier = _phenologyFournier
      ..collectionMethod = _collectionMethod
      ..sessionId = _selectedSessionId
      ..isDraft = asDraft
      ..photoPaths = _photoPaths
      ..audioNotePaths = _audioNotePaths
      ..audioTranscripts = _audioTranscripts
      ..measurements = _measurements
      ..duplicateOf = widget.plant?.duplicateOf
      ..duplicateUuids = List<String>.from(
        widget.plant?.duplicateUuids ?? const [],
      )
      ..deviceId = settings.deviceId
      ..registryIdentifier = registryIdentifier
      ..createdAt = isNewPlant ? DateTime.now() : plant.createdAt
      ..updatedAt = DateTime.now();

    plant.applyLatestDetermination();
    plant.updateFtsFields();

    try {
      await plantRepo.save(plant);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(asDraft ? l10n.savedAsDraft : l10n.plantRecordSaved),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorSavingPlant(e.toString())),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _attemptExitWithoutSaving(AppLocalizations l10n) async {
    if (!_hasUnsavedChanges()) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final confirmed = await RainModeGuard.confirmDestructiveAction(
      context: context,
      rainModeEnabled: ref.read(rainModeEnabledProvider),
      actionLabel: l10n.rainModeExitWithoutSavingTitle,
      overlayTitle: l10n.rainModeOverlayTitle,
      overlayMessage: l10n.rainModeOverlayMessage,
      unlockHint: l10n.rainModeUnlockHold,
      unlockAlternativeHint: l10n.rainModeUnlockTap,
      confirmTitle: l10n.rainModeExitWithoutSavingTitle,
      confirmMessage: l10n.rainModeExitWithoutSavingMessage,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.rainModeDiscardChanges,
      countdownLabel: l10n.rainModeCountdownLabel,
      confirmColor: Theme.of(context).colorScheme.error,
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  bool _hasUnsavedChanges() {
    return _scientificNameController.text.trim().isNotEmpty ||
        _commonNameController.text.trim().isNotEmpty ||
        _familyController.text.trim().isNotEmpty ||
        _genusController.text.trim().isNotEmpty ||
        _speciesController.text.trim().isNotEmpty ||
        _habitatController.text.trim().isNotEmpty ||
        _notesController.text.trim().isNotEmpty ||
        _identifierController.text.trim().isNotEmpty ||
        _collectorNameController.text.trim().isNotEmpty ||
        _selectedCategory != null ||
        _selectedSessionId != null ||
        _photoPaths.isNotEmpty ||
        _measurements.isNotEmpty ||
        _audioNotePaths.isNotEmpty ||
        _latitude != null ||
        _longitude != null;
  }

  Future<void> _suggestTemplateFromCurrentGps() async {
    if (!mounted || widget.plant != null || _templateSuggestionHandled) {
      return;
    }

    try {
      final position = await _locationService.getCurrentLocation();
      if (position == null || !mounted) {
        return;
      }

      await _suggestTemplateForCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      // Ignore automatic suggestion failures to avoid interrupting form startup.
    }
  }

  Future<void> _suggestTemplateForCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    if (!mounted || widget.plant != null || _templateSuggestionHandled) {
      return;
    }

    final template = await ref
        .read(templateRepositoryProvider)
        .getSuggestedTemplateForCoordinates(
          latitude: latitude,
          longitude: longitude,
        );

    _templateSuggestionHandled = true;

    if (template == null || !mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final shouldApply = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.useCollectionTemplateTitle),
        content: Text(
          l10n.useCollectionTemplateBody(
            template.name,
            _getBiomeName(l10n, template.biome),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.useCollectionTemplateAction),
          ),
        ],
      ),
    );

    if (shouldApply == true && mounted) {
      _applyCollectionTemplate(template);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.collectionTemplateApplied(template.name))),
      );
    }
  }

  void _applyCollectionTemplate(CollectionTemplate template) {
    setState(() {
      _habitatController.text = template.habitatTemplate ?? '';
      _vegetationTypeController.text = template.vegetationTypeTemplate ?? '';
      _topographyController.text = template.topographyTemplate ?? '';
      _substrateController.text = template.substrateTemplate ?? '';
      _notesController.text = template.notesTemplate ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.plant != null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _attemptExitWithoutSaving(l10n);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: ModernAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _attemptExitWithoutSaving(l10n),
          ),
          title: isEditing ? l10n.editPlant : l10n.newPlant,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: l10n.basicInfo),
              Tab(text: l10n.locationInfo),
              Tab(text: l10n.habitatInfo),
              Tab(text: l10n.measurementsInfo),
              Tab(text: l10n.photosInfo),
              Tab(text: l10n.audioSection),
            ],
          ),
          bottomHeight: 48,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top +
                    64 +
                    kTextTabBarHeight,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBasicInfoTab(l10n),
                    _buildLocationTab(l10n),
                    _buildHabitatTab(l10n),
                    _buildMeasurementsTab(l10n),
                    _buildPhotosTab(l10n),
                    _buildAudioTab(l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(l10n),
      ),
    );
  }

  Widget _buildBasicInfoTab(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.ocrScanLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isProcessingOcr ? null : _scanLabelWithOcr,
                    icon: _isProcessingOcr
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.document_scanner_outlined),
                    label: Text(
                      _isProcessingOcr
                          ? l10n.ocrProcessing
                          : l10n.ocrScanButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Registry Identifier Field
        Consumer(
          builder: (context, ref, child) {
            final settings = ref.watch(settingsNotifierProvider).valueOrNull;
            final autoGenerate = settings?.autoGenerateIdentifier ?? true;

            return TextFormField(
              controller: _identifierController,
              decoration: InputDecoration(
                labelText: l10n.identifierLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.tag),
                hintText: l10n.identifierHint,
                suffixIcon: autoGenerate
                    ? IconButton(
                        icon: const Icon(Icons.auto_fix_high),
                        tooltip: l10n.generateIdentifierTooltip,
                        onPressed: _generateIdentifier,
                      )
                    : null,
              ),
              readOnly: autoGenerate,
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                // If empty and auto-generate is off, it's optional
                if (trimmed.isEmpty) {
                  return null;
                }
                // Validate format on trimmed value
                if (!_identifierService.isValidIdentifier(trimmed)) {
                  return l10n.invalidIdentifierFormat;
                }
                return null;
              },
              textCapitalization: TextCapitalization.characters,
            );
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _scientificNameController,
          decoration: InputDecoration(
            labelText: l10n.scientificName,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.science),
            hintText: l10n.scientificNameBinomialHint,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.scientificNameRequired;
            }
            return _validator.validateScientificName(value);
          },
          textCapitalization: TextCapitalization.words,
        ),

        // Duplicate warnings
        if (_duplicateWarnings.isNotEmpty) ...[
          const SizedBox(height: 8),
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.possibleDuplicates,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._duplicateWarnings.map(
                    (warning) => Padding(
                      padding: const EdgeInsets.only(left: 28, bottom: 4),
                      child: Text(
                        warning,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 16),
        TextFormField(
          controller: _commonNameController,
          decoration: InputDecoration(
            labelText: l10n.commonName,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.local_florist),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _collectorNameController,
          decoration: InputDecoration(
            labelText: l10n.collector,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person_outline),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<PlantCategory>(
          initialValue: _selectedCategory,
          decoration: InputDecoration(
            labelText: l10n.category,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.category),
          ),
          items: PlantCategory.values.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(_getCategoryName(l10n, category)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return l10n.categoryRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        Text(l10n.taxonomyInfo, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        TextFormField(
          controller: _genusController,
          decoration: InputDecoration(
            labelText: l10n.genus,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.category),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _speciesController,
          decoration: InputDecoration(
            labelText: l10n.species,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.grain),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _familyController,
          decoration: InputDecoration(
            labelText: l10n.family,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.account_tree),
            suffixIcon:
                _suggestedFamily != null &&
                    _familyController.text != _suggestedFamily
                ? IconButton(
                    icon: Icon(
                      Icons.lightbulb,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    tooltip: l10n.suggestionWithName(_suggestedFamily!),
                    onPressed: () {
                      setState(() {
                        _familyController.text = _suggestedFamily!;
                        _suggestedFamily = null;
                      });
                    },
                  )
                : null,
          ),
          textCapitalization: TextCapitalization.words,
        ),

        // Family suggestion card
        if (_suggestedFamily != null &&
            _familyController.text != _suggestedFamily) ...[
          const SizedBox(height: 8),
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: ListTile(
              leading: Icon(
                Icons.lightbulb,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: Text(l10n.suggestionWithName(_suggestedFamily!), maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(l10n.basedOnGenus),
              trailing: TextButton(
                onPressed: () {
                  setState(() {
                    _familyController.text = _suggestedFamily!;
                    _suggestedFamily = null;
                  });
                },
                child: Text(l10n.apply),
              ),
            ),
          ),
        ],

        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: Text(l10n.collectionDate),
          subtitle: Text(
            '${_dateCollected.day}/${_dateCollected.month}/${_dateCollected.year}',
          ),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dateCollected,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() {
                _dateCollected = date;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _buildSessionSelector(l10n),
        const SizedBox(height: 24),

        // Morphology section
        Text(
          l10n.morphology,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(),
        const SizedBox(height: 4),

        // Raiz
        _buildOrganSection(
          title: l10n.root,
          icon: Icons.grass,
          children: [
            _buildMorphTextField(
              controller: _raizController,
              label: l10n.descriptionLabel,
              hint: l10n.rootDescriptionHint,
              icon: Icons.description,
            ),
          ],
        ),

        // Caule
        _buildOrganSection(
          title: l10n.stem,
          icon: Icons.park,
          children: [
            _buildMorphTextField(
              controller: _cauleController,
              label: l10n.descriptionLabel,
              hint: l10n.stemDescriptionHint,
              icon: Icons.description,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _cauleTipoCascaController,
              label: l10n.stemBarkType,
              hint: l10n.stemBarkTypeHint,
              icon: Icons.texture,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _cauleCorController,
              label: l10n.colorLabel,
              hint: l10n.stemColorHint,
              icon: Icons.color_lens,
            ),
            const SizedBox(height: 12),
            _buildInlineMeasurement(
              label: l10n.sizeHeight,
              controller: _cauleTamanhoController,
              selectedUnit: _cauleTamanhoUnidade,
              onUnitChanged: (v) => setState(() => _cauleTamanhoUnidade = v),
            ),
            const SizedBox(height: 12),
            _buildInlineMeasurement(
              label: l10n.circumference,
              controller: _cauleCircunferenciaController,
              selectedUnit: _cauleCircunferenciaUnidade,
              onUnitChanged: (v) =>
                  setState(() => _cauleCircunferenciaUnidade = v),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: Text(l10n.sapPresence),
              subtitle: Text(l10n.sapPresenceSubtitle),
              value: _cauleTemSeiva,
              onChanged: (v) => setState(() => _cauleTemSeiva = v),
              secondary: const Icon(Icons.water_drop),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
            if (_cauleTemSeiva) ...[
              const SizedBox(height: 12),
              _buildMorphTextField(
                controller: _cauleDescricaoSeivaController,
                label: l10n.sapDescription,
                hint: l10n.sapDescriptionHint,
                icon: Icons.water_drop,
              ),
            ],
          ],
        ),

        // Folha
        _buildOrganSection(
          title: l10n.leaf,
          icon: Icons.eco,
          children: [
            _buildMorphTextField(
              controller: _folhaDescricaoController,
              label: l10n.descriptionLabel,
              hint: l10n.leafDescriptionHint,
              icon: Icons.description,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _folhaBainhaController,
              label: l10n.sheathLabel,
              hint: l10n.sheathHint,
              icon: Icons.eco,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _folhaPecioloController,
              label: l10n.petioleLabel,
              hint: l10n.petioleHint,
              icon: Icons.eco,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _folhaLaminaController,
              label: l10n.bladeLabel,
              hint: l10n.bladeHint,
              icon: Icons.eco,
            ),
          ],
        ),

        // Flor
        _buildOrganSection(
          title: l10n.flower,
          icon: Icons.local_florist,
          children: [
            _buildMorphTextField(
              controller: _florDescricaoController,
              label: l10n.descriptionLabel,
              hint: l10n.flowerDescriptionHint,
              icon: Icons.description,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _florInflorescenciaController,
              label: l10n.inflorescenceLabel,
              hint: l10n.inflorescenceHint,
              icon: Icons.filter_vintage,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _florCorController,
              label: l10n.colorLabel,
              hint: l10n.flowerColorHint,
              icon: Icons.color_lens,
            ),
            const SizedBox(height: 12),
            _buildInlineMeasurement(
              label: l10n.sizeLabel,
              controller: _florTamanhoController,
              selectedUnit: _florTamanhoUnidade,
              onUnitChanged: (v) => setState(() => _florTamanhoUnidade = v),
            ),
          ],
        ),

        // Fruto
        _buildOrganSection(
          title: l10n.fruitLabel,
          icon: Icons.spa,
          children: [
            _buildMorphTextField(
              controller: _frutoDescricaoController,
              label: l10n.descriptionLabel,
              hint: l10n.fruitDescriptionHint,
              icon: Icons.description,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _frutoCorController,
              label: l10n.colorLabel,
              hint: l10n.fruitColorHint,
              icon: Icons.color_lens,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _frutoFormatoController,
              label: l10n.shapeLabel,
              hint: l10n.fruitShapeHint,
              icon: Icons.category,
            ),
            const SizedBox(height: 12),
            _buildInlineMeasurement(
              label: l10n.sizeLabel,
              controller: _frutoTamanhoController,
              selectedUnit: _frutoTamanhoUnidade,
              onUnitChanged: (v) => setState(() => _frutoTamanhoUnidade = v),
            ),
          ],
        ),

        // Semente
        _buildOrganSection(
          title: l10n.seedLabel,
          icon: Icons.grain,
          children: [
            _buildMorphTextField(
              controller: _sementeDescricaoController,
              label: l10n.descriptionLabel,
              hint: l10n.seedDescriptionHint,
              icon: Icons.description,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _sementeCorController,
              label: l10n.colorLabel,
              hint: l10n.seedColorHint,
              icon: Icons.color_lens,
            ),
            const SizedBox(height: 12),
            _buildMorphTextField(
              controller: _sementeFormatoController,
              label: l10n.shapeLabel,
              hint: l10n.seedShapeHint,
              icon: Icons.category,
            ),
            const SizedBox(height: 12),
            _buildInlineMeasurement(
              label: l10n.sizeLabel,
              controller: _sementeTamanhoController,
              selectedUnit: _sementeTamanhoUnidade,
              onUnitChanged: (v) => setState(() => _sementeTamanhoUnidade = v),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSessionSelector(AppLocalizations l10n) {
    final sessionRepo = ref.watch(sessionRepositoryProvider);

    return FutureBuilder(
      future: sessionRepo.getAll(isArchived: false),
      builder: (context, snapshot) {
        final sessions = snapshot.data ?? [];

        return DropdownButtonFormField<String>(
          initialValue: _selectedSessionId,
          decoration: InputDecoration(
            labelText: l10n.sessionName,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.folder),
          ),
          items: [
            DropdownMenuItem(value: null, child: Text(l10n.noSession)),
            ...sessions.map((session) {
              return DropdownMenuItem(
                value: session.uuid,
                child: Text(session.tripName, maxLines: 1, overflow: TextOverflow.ellipsis),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _selectedSessionId = value;
            });
          },
        );
      },
    );
  }

  Widget _buildLocationTab(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.gpsCoordinates,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                if (_latitude != null && _longitude != null)
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(l10n.latitude),
                        subtitle: Text(_latitude!.toStringAsFixed(6)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(l10n.longitude),
                        subtitle: Text(_longitude!.toStringAsFixed(6)),
                      ),
                    ],
                  )
                else
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.noLocationSet),
                    ),
                  ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _fetchingLocation ? null : _getCurrentLocation,
                  icon: _fetchingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(
                    _fetchingLocation
                        ? l10n.gpsAcquiring
                        : l10n.getCurrentLocation,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _localityController,
                  decoration: InputDecoration(
                    labelText: l10n.locality,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.place_outlined),
                    hintText: _locationHintText(l10n),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _municipalityController,
                  decoration: InputDecoration(
                    labelText: l10n.municipality,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_city),
                    hintText: _locationHintText(l10n),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          labelText: l10n.state,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.map_outlined),
                          hintText: _locationHintText(l10n),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _countryController,
                        decoration: InputDecoration(
                          labelText: l10n.country,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.public),
                          hintText: _locationHintText(l10n),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
                if (_latitude != null && _longitude != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _latitude = null;
                                _longitude = null;
                                _clearLocationFields();
                                _showOfflineLocationHint = false;
                              });
                            },
                            icon: const Icon(Icons.clear),
                            label: Text(l10n.clearLocation),
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.map, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.locationMap),
                    const Spacer(),
                    if (_latitude != null && _longitude != null)
                      TextButton.icon(
                        onPressed: () {
                          // Center map on current location
                          setState(() {});
                        },
                        icon: const Icon(Icons.my_location, size: 16),
                        label: Text(l10n.recenter),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: _latitude != null && _longitude != null
                    ? MapWidget(
                        latitude: _latitude,
                        longitude: _longitude,
                        zoom: 15.0,
                        interactive: true,
                        showMarker: true,
                        onLocationSelected: (latLng) {
                          setState(() {
                            _latitude = latLng.latitude;
                            _longitude = latLng.longitude;
                          });
                        },
                      )
                    : Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              size: 64,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(height: 8),
                            Text(
                              l10n.tapToShowMap,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              if (_latitude != null && _longitude != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.tapToAdjustMarker,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHabitatTab(AppLocalizations l10n) {
    final weatherOptions = <String, String>{
      'sunny': l10n.weatherSunny,
      'cloudy': l10n.weatherCloudy,
      'overcast': l10n.weatherOvercast,
      'rainy': l10n.weatherRainy,
      'stormy': l10n.weatherStormy,
      'foggy': l10n.weatherFoggy,
      'windy': l10n.weatherWindy,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          controller: _habitatController,
          decoration: InputDecoration(
            labelText: l10n.habitat,
            border: const OutlineInputBorder(),
            hintText: l10n.habitatHint,
            prefixIcon: const Icon(Icons.landscape),
          ),
          maxLines: 5,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _notesController,
          decoration: InputDecoration(
            labelText: l10n.notes,
            border: const OutlineInputBorder(),
            hintText: l10n.notesHint,
            prefixIcon: const Icon(Icons.notes),
          ),
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 24),
        // Environmental Data Section
        Text(
          l10n.environmentalData,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        // Weather condition chips
        Text(
          l10n.weatherCondition,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: weatherOptions.entries.map((entry) {
            final isSelected = _weatherCondition == entry.key;
            return ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _weatherCondition = selected ? entry.key : null;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _altitudeController,
                decoration: InputDecoration(
                  labelText: l10n.altitude,
                  border: const OutlineInputBorder(),
                  hintText: l10n.altitudeHint,
                  prefixIcon: const Icon(Icons.terrain, size: 20),
                  isDense: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _temperatureController,
                decoration: InputDecoration(
                  labelText: l10n.temperatureLabel,
                  border: const OutlineInputBorder(),
                  hintText: l10n.temperatureHint,
                  prefixIcon: const Icon(Icons.thermostat, size: 20),
                  isDense: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _humidityController,
                decoration: InputDecoration(
                  labelText: l10n.humidityLabel,
                  border: const OutlineInputBorder(),
                  hintText: l10n.humidityHint,
                  prefixIcon: const Icon(Icons.water_drop, size: 20),
                  isDense: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _windSpeedController,
                decoration: InputDecoration(
                  labelText: l10n.windSpeed,
                  border: const OutlineInputBorder(),
                  hintText: l10n.windSpeedHint,
                  prefixIcon: const Icon(Icons.air, size: 20),
                  isDense: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _weatherNotesController,
          decoration: InputDecoration(
            labelText: l10n.weatherNotes,
            border: const OutlineInputBorder(),
            hintText: l10n.weatherNotesHint,
            prefixIcon: const Icon(Icons.cloud_outlined),
          ),
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: ValueKey(_moonPhase),
          initialValue: _moonPhase == null
              ? ''
              : _getMoonPhaseLabel(l10n, _moonPhase!),
          decoration: InputDecoration(
            labelText: l10n.moonPhase,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.dark_mode_outlined),
          ),
          readOnly: true,
        ),
        const SizedBox(height: 24),
        // ── Habitat Details ──────────────────────────────────────────
        Text(
          l10n.habitatDetails,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Divider(),
        const SizedBox(height: 8),
        TextFormField(
          controller: _substrateController,
          decoration: InputDecoration(
            labelText: l10n.substrate,
            border: const OutlineInputBorder(),
            hintText: l10n.substrateHint,
            prefixIcon: const Icon(Icons.layers),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _vegetationTypeController,
          decoration: InputDecoration(
            labelText: l10n.vegetationType,
            border: const OutlineInputBorder(),
            hintText: l10n.vegetationTypeHint,
            prefixIcon: const Icon(Icons.forest),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _topographyController,
          decoration: InputDecoration(
            labelText: l10n.topography,
            border: const OutlineInputBorder(),
            hintText: l10n.topographyHint,
            prefixIcon: const Icon(Icons.terrain),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _associatedTaxaController,
          decoration: InputDecoration(
            labelText: l10n.associatedTaxa,
            border: const OutlineInputBorder(),
            hintText: l10n.associatedTaxaHint,
            prefixIcon: const Icon(Icons.diversity_3),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 24),
        // ── Collection Info ──────────────────────────────────────────
        Text(
          l10n.collectionInfo,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _collectorNumberController,
                decoration: InputDecoration(
                  labelText: l10n.collectorNumber,
                  border: const OutlineInputBorder(),
                  hintText: l10n.collectorNumberHint,
                  prefixIcon: const Icon(Icons.tag, size: 20),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _numberOfIndividualsController,
                decoration: InputDecoration(
                  labelText: l10n.numberOfIndividuals,
                  border: const OutlineInputBorder(),
                  hintText: l10n.numberOfIndividualsHint,
                  prefixIcon: const Icon(Icons.group, size: 20),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _determinationQualifierController,
          decoration: InputDecoration(
            labelText: l10n.determinationQualifier,
            border: const OutlineInputBorder(),
            hintText: l10n.determinationQualifierHint,
            prefixIcon: const Icon(Icons.help_outline),
          ),
        ),
        const SizedBox(height: 16),
        FenologiaFournierWidget(
          initialValue: _phenologyFournier,
          onChanged: (value) => setState(() => _phenologyFournier = value),
        ),
        const SizedBox(height: 16),
        // Phenological State chips
        Text(
          l10n.phenologicalState,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PhenologicalState.values.map((state) {
            final isSelected = _phenologicalState == state;
            return ChoiceChip(
              label: Text(_getPhenologicalStateName(l10n, state)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _phenologicalState = selected ? state : null;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Collection Method dropdown
        DropdownButtonFormField<CollectionMethod>(
          initialValue: _collectionMethod,
          decoration: InputDecoration(
            labelText: l10n.collectionMethod,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.science),
          ),
          items: [
            DropdownMenuItem(value: null, child: Text(l10n.notSpecified)),
            ...CollectionMethod.values.map((method) {
              return DropdownMenuItem(
                value: method,
                child: Text(_getCollectionMethodName(l10n, method)),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _collectionMethod = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildOrganSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: Icon(icon, size: 22),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: children,
      ),
    );
  }

  Widget _buildMorphTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 2,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        isDense: true,
      ),
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildInlineMeasurement({
    required String label,
    required TextEditingController controller,
    required String selectedUnit,
    required ValueChanged<String> onUnitChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              hintText: AppLocalizations.of(context)!.measurementHint,
              prefixIcon: const Icon(Icons.straighten, size: 20),
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            initialValue: selectedUnit,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.unitLabel,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: 'mm', child: Text('mm')),
              DropdownMenuItem(value: 'cm', child: Text('cm')),
              DropdownMenuItem(value: 'm', child: Text('m')),
            ],
            onChanged: (v) {
              if (v != null) onUnitChanged(v);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementsTab(AppLocalizations l10n) {
    return Column(
      children: [
        Expanded(
          child: _measurements.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.straighten,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma medição ainda',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Toque no botão + abaixo para adicionar medições',
                      ),
                    ],
                  ),
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _measurements.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item = _measurements.removeAt(oldIndex);
                      _measurements.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (context, index) {
                    final measurement = _measurements[index];
                    return Card(
                      key: ValueKey('measurement_$index'),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.straighten),
                        title: Text(measurement.label),
                        subtitle: Text(
                          '${measurement.value} ${measurement.unit}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _editMeasurement(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              color: Theme.of(context).colorScheme.error,
                              onPressed: () => _removeMeasurement(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: FilledButton.icon(
              onPressed: _addMeasurement,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Medição'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addMeasurement() async {
    final result = await _showMeasurementDialog();
    if (result != null && mounted) {
      setState(() {
        _measurements.add(result);
      });
    }
  }

  Future<void> _editMeasurement(int index) async {
    final result = await _showMeasurementDialog(
      initialMeasurement: _measurements[index],
    );
    if (result != null && mounted) {
      setState(() {
        _measurements[index] = result;
      });
    }
  }

  void _removeMeasurement(int index) {
    setState(() {
      _measurements.removeAt(index);
    });
  }

  Future<Measurement?> _showMeasurementDialog({
    Measurement? initialMeasurement,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final labelController = TextEditingController(
      text: initialMeasurement?.label ?? '',
    );
    final valueController = TextEditingController(
      text: initialMeasurement?.value.toString() ?? '',
    );
    String selectedUnit = initialMeasurement?.unit ?? 'cm';

    return showDialog<Measurement>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            initialMeasurement == null
                ? l10n.addMeasurement
                : l10n.editMeasurement,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: labelController,
                  decoration: InputDecoration(
                    labelText: l10n.measurementDescriptionRequired,
                    hintText: l10n.measurementDescriptionHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.label),
                  ),
                  textCapitalization: TextCapitalization.words,
                  autofocus: initialMeasurement == null,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: valueController,
                  decoration: InputDecoration(
                    labelText: l10n.measurementValueRequired,
                    hintText: l10n.measurementValueHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.numbers),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedUnit,
                  decoration: InputDecoration(
                    labelText: l10n.unitLabel,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.straighten),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'mm',
                      child: Text('Milímetros (mm)'),
                    ),
                    DropdownMenuItem(
                      value: 'cm',
                      child: Text('Centímetros (cm)'),
                    ),
                    DropdownMenuItem(value: 'm', child: Text('Metros (m)')),
                    DropdownMenuItem(
                      value: 'in',
                      child: Text('Polegadas (in)'),
                    ),
                    DropdownMenuItem(value: 'ft', child: Text('Pés (ft)')),
                    DropdownMenuItem(
                      value: 'mg',
                      child: Text('Miligramas (mg)'),
                    ),
                    DropdownMenuItem(value: 'g', child: Text('Gramas (g)')),
                    DropdownMenuItem(
                      value: 'kg',
                      child: Text('Quilogramas (kg)'),
                    ),
                    DropdownMenuItem(value: 'oz', child: Text('Onças (oz)')),
                    DropdownMenuItem(value: 'lb', child: Text('Libras (lb)')),
                    DropdownMenuItem(value: '°C', child: Text('Celsius (°C)')),
                    DropdownMenuItem(
                      value: '°F',
                      child: Text('Fahrenheit (°F)'),
                    ),
                    DropdownMenuItem(
                      value: '%',
                      child: Text('Porcentagem (%)'),
                    ),
                    DropdownMenuItem(value: 'count', child: Text('Contagem')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedUnit = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final label = labelController.text.trim();
                if (label.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.enterDescription)),
                  );
                  return;
                }

                final valueText = valueController.text.trim();
                if (valueText.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.enterValue)));
                  return;
                }

                final value = double.tryParse(valueText);
                if (value == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.enterValidNumber)),
                  );
                  return;
                }

                if (value < 0) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.negativeValue)));
                  return;
                }

                if (value > 999999) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.valueTooBig)));
                  return;
                }

                final measurement = Measurement()
                  ..label = label
                  ..value = value
                  ..unit = selectedUnit;

                Navigator.of(context).pop(measurement);
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosTab(AppLocalizations l10n) {
    final settings = ref.watch(settingsNotifierProvider).valueOrNull;
    final hasPlantNetApiKey =
        settings?.plantnetApiKey.trim().isNotEmpty ?? false;
    final isIdentifying = _plantNetIdentificationState.isLoading;

    return Column(
      children: [
        Expanded(
          child: _photoPaths.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noPhotos,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.addPhotosMsg),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _photoPaths.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_photoPaths[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () => _removePhoto(index),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (hasPlantNetApiKey)
                      FutureBuilder<ConnectivityResult>(
                        future: Connectivity().checkConnectivity(),
                        builder: (context, snapshot) {
                          final hasConnection =
                              snapshot.data != ConnectivityResult.none;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FilledButton.icon(
                                onPressed:
                                    !hasConnection ||
                                        _photoPaths.isEmpty ||
                                        isIdentifying
                                    ? null
                                    : _identifyWithPlantNet,
                                icon: isIdentifying
                                     ? SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Theme.of(context).colorScheme.onPrimary,
                                         ),
                                      )
                                    : const Icon(Icons.auto_awesome),
                                label: Text(
                                  isIdentifying
                                      ? l10n.plantNetIdentifying
                                      : l10n.plantNetIdentifyButton,
                                ),
                              ),
                              if (!hasConnection) ...[
                                const SizedBox(height: 8),
                                Text(
                                  l10n.plantNetNoInternet,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    if (hasPlantNetApiKey) const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _takePhoto,
                            icon: const Icon(Icons.camera_alt),
                            label: Text(l10n.takePhoto),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickFromGallery,
                            icon: const Icon(Icons.photo_library),
                            label: Text(l10n.chooseFromGallery),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _identifyWithPlantNet() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _plantNetIdentificationState = const AsyncLoading();
    });

    try {
      final results = await ref
          .read(plantNetServiceProvider)
          .identify(_photoPaths, organ: _inferPlantNetOrgan());

      if (!mounted) {
        return;
      }

      setState(() {
        _plantNetIdentificationState = const AsyncData(null);
      });

      if (results.isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.plantNetNoResults)));
        return;
      }

      final selected = await showModalBottomSheet<PlantNetResult>(
        context: context,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.8,
          child: PlantNetResultsSheet(results: results),
        ),
      );

      if (selected == null || !mounted) {
        return;
      }

      setState(() {
        _scientificNameController.text = selected.scientificName;
        _familyController.text = selected.family ?? '';
        _suggestedFamily = null;
      });

      messenger.showSnackBar(
        SnackBar(content: Text(l10n.plantNetSuggestionApplied)),
      );
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      setState(() {
        _plantNetIdentificationState = AsyncError(error, stackTrace);
      });

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.plantNetIdentificationFailed(
              _localizePlantNetError(l10n, error),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String? _inferPlantNetOrgan() {
    if (_florDescricaoController.text.trim().isNotEmpty ||
        _florCorController.text.trim().isNotEmpty ||
        _florInflorescenciaController.text.trim().isNotEmpty) {
      return 'flower';
    }

    if (_frutoDescricaoController.text.trim().isNotEmpty ||
        _frutoCorController.text.trim().isNotEmpty ||
        _frutoFormatoController.text.trim().isNotEmpty) {
      return 'fruit';
    }

    if (_folhaDescricaoController.text.trim().isNotEmpty ||
        _folhaBainhaController.text.trim().isNotEmpty ||
        _folhaPecioloController.text.trim().isNotEmpty ||
        _folhaLaminaController.text.trim().isNotEmpty) {
      return 'leaf';
    }

    if (_cauleController.text.trim().isNotEmpty ||
        _cauleTipoCascaController.text.trim().isNotEmpty) {
      return 'bark';
    }

    return null;
  }

  String _localizePlantNetError(AppLocalizations l10n, Object error) {
    if (error is PlantNetException) {
      switch (error.code) {
        case 'missingApiKey':
          return l10n.plantNetMissingApiKey;
        case 'noInternetConnection':
          return l10n.plantNetNoInternet;
        case 'requestFailed':
        case 'invalidResponse':
          return error.toString();
      }
    }

    return error.toString();
  }

  Widget _buildAudioTab(AppLocalizations l10n) {
    final transcriptionEnabled =
        ref.watch(settingsNotifierProvider).valueOrNull?.transcriptionEnabled ??
        false;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.audioNotes, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Grave notas de voz durante a coleta',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 24),

        // Audio recorder
        AudioRecorderWidget(
          resolveQuality: () async {
            final settings = await ref.read(settingsNotifierProvider.future);
            return settings.audioQuality;
          },
          onRecordingComplete: (audioPath) {
            setState(() {
              _audioNotePaths.add(audioPath);
              _audioTranscripts.add(''); // Empty transcript initially
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nota de áudio salva')),
            );
          },
        ),

        const SizedBox(height: 24),

        // Audio notes list
        if (_audioNotePaths.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(Icons.audiotrack, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 8),
                Text(
                  'Nenhuma nota de áudio gravada',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notas gravadas (${_audioNotePaths.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ..._audioNotePaths.asMap().entries.map((entry) {
                final index = entry.key;
                final audioPath = entry.value;
                final transcript = index < _audioTranscripts.length
                    ? _audioTranscripts[index]
                    : '';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AudioPlayerWidget(
                    audioPath: audioPath,
                    transcript: transcript.isNotEmpty ? transcript : null,
                    onDelete: () {
                      setState(() {
                        _audioNotePaths.removeAt(index);
                        if (index < _audioTranscripts.length) {
                          _audioTranscripts.removeAt(index);
                        }
                      });
                      // Delete the file
                      final file = File(audioPath);
                      if (file.existsSync()) {
                        file.delete();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nota de áudio excluída')),
                      );
                    },
                    onTranscribe: (path) async {
                      if (transcriptionEnabled) {
                        await _transcribeAudio(index, path);
                      }
                    },
                  ),
                );
              }),
            ],
          ),
      ],
    );
  }

  Future<void> _transcribeAudio(int index, String audioPath) async {
    try {
      final settings = await ref.read(settingsNotifierProvider.future);
      if (!settings.transcriptionEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transcrição desativada nas configurações'),
            ),
          );
        }
        return;
      }

      final audioFile = File(audioPath);
      if (!audioFile.existsSync()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Arquivo de áudio não encontrado')),
          );
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Transcrevendo áudio... Isso pode levar alguns minutos.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Use the new file-based transcription
      final transcript = await _audioTranscriptionService.transcribeFile(
        audioPath: audioPath,
        localeId: settings.transcriptionLocale,
      );

      if (!mounted) return;

      setState(() {
        while (_audioTranscripts.length <= index) {
          _audioTranscripts.add('');
        }
        _audioTranscripts[index] = transcript;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            transcript.isEmpty
                ? 'Nenhuma fala detectada'
                : 'Transcrição concluída com sucesso!',
          ),
          backgroundColor: transcript.isEmpty
              ? Theme.of(context).colorScheme.tertiary
              : null,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorTranscribeMsg(e.toString()),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => _savePlant(asDraft: true),
                icon: const Icon(Icons.save, size: 18),
                label: Text(l10n.saveDraft, overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _savePlant(asDraft: false),
                icon: const Icon(Icons.check, size: 18),
                label: Text(l10n.markComplete, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(AppLocalizations l10n, PlantCategory category) {
    switch (category) {
      case PlantCategory.trees:
        return l10n.categoryTrees;
      case PlantCategory.shrubs:
        return l10n.categoryShrubs;
      case PlantCategory.herbs:
        return l10n.categoryHerbs;
      case PlantCategory.ferns:
        return l10n.categoryFerns;
      case PlantCategory.grasses:
        return l10n.categoryGrasses;
      case PlantCategory.vines:
        return l10n.categoryVines;
      case PlantCategory.cacti:
        return l10n.categoryCacti;
      case PlantCategory.aquatic:
        return l10n.categoryAquatic;
    }
  }

  String _getPhenologicalStateName(
    AppLocalizations l10n,
    PhenologicalState state,
  ) {
    switch (state) {
      case PhenologicalState.flowering:
        return l10n.phenoFlowering;
      case PhenologicalState.fruiting:
        return l10n.phenoFruiting;
      case PhenologicalState.budding:
        return l10n.phenoBudding;
      case PhenologicalState.withFruit:
        return l10n.phenoWithFruit;
      case PhenologicalState.vegetative:
        return l10n.phenoVegetative;
      case PhenologicalState.sterile:
        return l10n.phenoSterile;
      case PhenologicalState.unknown:
        return l10n.phenoUnknown;
    }
  }

  String _getCollectionMethodName(
    AppLocalizations l10n,
    CollectionMethod method,
  ) {
    switch (method) {
      case CollectionMethod.voucherCollected:
        return l10n.methodVoucherCollected;
      case CollectionMethod.photoOnly:
        return l10n.methodPhotoOnly;
      case CollectionMethod.sterileMaterial:
        return l10n.methodSterileMaterial;
      case CollectionMethod.livingMaterial:
        return l10n.methodLivingMaterial;
    }
  }

  Future<void> _getCurrentLocation() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _fetchingLocation = true;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null && mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          if (_altitudeController.text.trim().isEmpty &&
              position.altitude != 0) {
            _altitudeController.text = position.altitude.toStringAsFixed(1);
          }
          _fetchingLocation = false;
        });

        unawaited(_autofillLocation(position.latitude, position.longitude));
        unawaited(
          _autofillWeather(
            position.latitude,
            position.longitude,
            _dateCollected,
          ),
        );
        unawaited(
          _suggestTemplateForCoordinates(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.locationObtained)));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fetchingLocation = false;
        });

        // Check if error message suggests service disabled or permission issue
        final errorMessage = e.toString().toLowerCase();
        final isServiceDisabled = errorMessage.contains('disabled');
        final isPermissionDenied = errorMessage.contains('permission');
        final isPermanentlyDenied = errorMessage.contains('forever');

        if (isServiceDisabled) {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.locationServicesDisabled),
              content: Text(l10n.enableLocationServicesMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(l10n.openSettings),
                ),
              ],
            ),
          );

          if (result == true) {
            await _locationService.openLocationSettings();
          }
        } else if (isPermissionDenied) {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.locationPermissionRequired),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancel),
                ),
                if (isPermanentlyDenied)
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(l10n.openSettings),
                  ),
              ],
            ),
          );

          if (result == true) {
            await _locationService.openAppSettings();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.errorLocationMsg(e.toString()),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _autofillLocation(double latitude, double longitude) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (!mounted) return;
      setState(() {
        _showOfflineLocationHint = true;
        _clearLocationFields();
      });
      return;
    }

    final locationData = await _geocodingService.reverseGeocode(
      latitude,
      longitude,
    );
    if (!mounted || locationData == null) {
      return;
    }

    final previousSnapshot = _captureLocationSnapshot();
    setState(() {
      _showOfflineLocationHint = false;
      _lastLocationSnapshot = previousSnapshot;
      _localityController.text = locationData.locality ?? '';
      _municipalityController.text = locationData.municipality ?? '';
      _stateController.text = locationData.state ?? '';
      _countryController.text = locationData.country ?? '';
    });

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.locationAutoFilled),
          action: SnackBarAction(
            label: l10n.undo,
            onPressed: _restorePreviousLocationSnapshot,
          ),
        ),
      );
  }

  Future<void> _autofillWeather(
    double latitude,
    double longitude,
    DateTime date,
  ) async {
    final weatherData = await _weatherService.fetchWeather(
      latitude,
      longitude,
      date,
    );
    if (!mounted || weatherData == null) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    setState(() {
      if (weatherData.temperature != null) {
        _temperatureController.text = weatherData.temperature!.toStringAsFixed(
          1,
        );
      }
      if (weatherData.humidity != null) {
        _humidityController.text = weatherData.humidity!.toString();
      }
      if (weatherData.weatherCondition != null) {
        _weatherCondition = weatherData.weatherCondition;
      }
      _moonPhase = weatherData.moonPhase;
      _weatherNotesController.text = _buildWeatherNotes(l10n, weatherData);
    });
  }

  _LocationSnapshot _captureLocationSnapshot() {
    return _LocationSnapshot(
      locality: _localityController.text,
      municipality: _municipalityController.text,
      state: _stateController.text,
      country: _countryController.text,
    );
  }

  void _restorePreviousLocationSnapshot() {
    final snapshot = _lastLocationSnapshot;
    if (snapshot == null || !mounted) {
      return;
    }

    setState(() {
      _localityController.text = snapshot.locality;
      _municipalityController.text = snapshot.municipality;
      _stateController.text = snapshot.state;
      _countryController.text = snapshot.country;
      _showOfflineLocationHint = false;
    });
  }

  void _clearLocationFields() {
    _localityController.clear();
    _municipalityController.clear();
    _stateController.clear();
    _countryController.clear();
  }

  Future<bool> _confirmCoordsValidationIfNeeded() async {
    final municipality = _municipalityController.text.trim();
    if (_latitude == null || _longitude == null || municipality.isEmpty) {
      return true;
    }

    final validation = await ref
        .read(coordsValidationServiceProvider)
        .validateCoordinates(
          latitude: _latitude!,
          longitude: _longitude!,
          municipality: municipality,
        );

    if (!mounted || !validation.isInconsistent) {
      return true;
    }

    final l10n = AppLocalizations.of(context)!;
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.coordsValidationTitle),
        content: Text(l10n.coordsValidationWarning(municipality)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.continueAction),
          ),
        ],
      ),
    );

    return shouldContinue ?? false;
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String? _locationHintText(AppLocalizations l10n) {
    return _showOfflineLocationHint ? l10n.noConnectionManualFill : null;
  }

  String _buildWeatherNotes(AppLocalizations l10n, WeatherData weatherData) {
    final parts = <String>[];

    if (weatherData.weatherCondition != null) {
      parts.add(_getWeatherConditionLabel(l10n, weatherData.weatherCondition!));
    }
    if (weatherData.sunrise != null) {
      parts.add('${l10n.sunriseLabel} ${_formatTime(weatherData.sunrise!)}');
    }
    if (weatherData.sunset != null) {
      parts.add('${l10n.sunsetLabel} ${_formatTime(weatherData.sunset!)}');
    }
    if (weatherData.weatherCode != null) {
      parts.add(l10n.weatherCode(weatherData.weatherCode!));
    }

    return parts.join(' • ');
  }

  String _formatTime(DateTime dateTime) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  String _getWeatherConditionLabel(AppLocalizations l10n, String condition) {
    switch (condition) {
      case 'sunny':
        return l10n.weatherSunny;
      case 'cloudy':
        return l10n.weatherCloudy;
      case 'overcast':
        return l10n.weatherOvercast;
      case 'rainy':
        return l10n.weatherRainy;
      case 'stormy':
        return l10n.weatherStormy;
      case 'foggy':
        return l10n.weatherFoggy;
      case 'windy':
        return l10n.weatherWindy;
      default:
        return condition;
    }
  }

  String _getMoonPhaseLabel(AppLocalizations l10n, String moonPhase) {
    switch (moonPhase) {
      case 'new':
        return l10n.moonPhaseNew;
      case 'waxing':
        return l10n.moonPhaseWaxing;
      case 'full':
        return l10n.moonPhaseFull;
      case 'waning':
        return l10n.moonPhaseWaning;
      default:
        return moonPhase;
    }
  }

  // ── Camera form-state snapshot (Android activity recreation recovery) ──────

  /// Serialises the entire form state into a plain JSON-encodable map.
  Map<String, dynamic> _captureSnapshot() => {
    'scientificName': _scientificNameController.text,
    'commonName': _commonNameController.text,
    'family': _familyController.text,
    'genus': _genusController.text,
    'species': _speciesController.text,
    'habitat': _habitatController.text,
    'notes': _notesController.text,
    'identifier': _identifierController.text,
    'locality': _localityController.text,
    'municipality': _municipalityController.text,
    'state': _stateController.text,
    'country': _countryController.text,
    'raiz': _raizController.text,
    'caule': _cauleController.text,
    'cauleTipoCasca': _cauleTipoCascaController.text,
    'cauleCor': _cauleCorController.text,
    'cauleTamanho': _cauleTamanhoController.text,
    'cauleTamanhoUnidade': _cauleTamanhoUnidade,
    'cauleCircunferencia': _cauleCircunferenciaController.text,
    'cauleCircunferenciaUnidade': _cauleCircunferenciaUnidade,
    'cauleTemSeiva': _cauleTemSeiva,
    'cauleDescricaoSeiva': _cauleDescricaoSeivaController.text,
    'folhaDescricao': _folhaDescricaoController.text,
    'folhaBainha': _folhaBainhaController.text,
    'folhaPeciolo': _folhaPecioloController.text,
    'folhaLamina': _folhaLaminaController.text,
    'florDescricao': _florDescricaoController.text,
    'florInflorescencia': _florInflorescenciaController.text,
    'florCor': _florCorController.text,
    'florTamanho': _florTamanhoController.text,
    'florTamanhoUnidade': _florTamanhoUnidade,
    'frutoDescricao': _frutoDescricaoController.text,
    'frutoCor': _frutoCorController.text,
    'frutoFormato': _frutoFormatoController.text,
    'frutoTamanho': _frutoTamanhoController.text,
    'frutoTamanhoUnidade': _frutoTamanhoUnidade,
    'sementeDescricao': _sementeDescricaoController.text,
    'sementeCor': _sementeCorController.text,
    'sementeFormato': _sementeFormatoController.text,
    'sementeTamanho': _sementeTamanhoController.text,
    'sementeTamanhoUnidade': _sementeTamanhoUnidade,
    'altitude': _altitudeController.text,
    'temperature': _temperatureController.text,
    'humidity': _humidityController.text,
    'weatherNotes': _weatherNotesController.text,
    'windSpeed': _windSpeedController.text,
    'weatherCondition': _weatherCondition,
    'moonPhase': _moonPhase,
    'collectorName': _collectorNameController.text,
    'collectorNumber': _collectorNumberController.text,
    'numberOfIndividuals': _numberOfIndividualsController.text,
    'substrate': _substrateController.text,
    'associatedTaxa': _associatedTaxaController.text,
    'vegetationType': _vegetationTypeController.text,
    'topography': _topographyController.text,
    'determinationQualifier': _determinationQualifierController.text,
    'phenologyFournier': _phenologyFournier,
    'selectedCategory': _selectedCategory?.name,
    'phenologicalState': _phenologicalState?.name,
    'collectionMethod': _collectionMethod?.name,
    'selectedSessionId': _selectedSessionId,
    'dateCollected': _dateCollected.toIso8601String(),
    'latitude': _latitude,
    'longitude': _longitude,
    'photoPaths': _photoPaths,
    'audioNotePaths': _audioNotePaths,
    'audioTranscripts': _audioTranscripts,
    'measurements': _measurements
        .map((m) => {'label': m.label, 'value': m.value, 'unit': m.unit})
        .toList(),
  };

  /// Restores all mutable form fields from a previously captured snapshot map.
  void _restoreFromSnapshot(Map<String, dynamic> data) {
    _scientificNameController.text = (data['scientificName'] as String?) ?? '';
    _commonNameController.text = (data['commonName'] as String?) ?? '';
    _familyController.text = (data['family'] as String?) ?? '';
    _genusController.text = (data['genus'] as String?) ?? '';
    _speciesController.text = (data['species'] as String?) ?? '';
    _habitatController.text = (data['habitat'] as String?) ?? '';
    _notesController.text = (data['notes'] as String?) ?? '';
    _identifierController.text = (data['identifier'] as String?) ?? '';
    _localityController.text = (data['locality'] as String?) ?? '';
    _municipalityController.text = (data['municipality'] as String?) ?? '';
    _stateController.text = (data['state'] as String?) ?? '';
    _countryController.text = (data['country'] as String?) ?? '';
    _raizController.text = (data['raiz'] as String?) ?? '';
    _cauleController.text = (data['caule'] as String?) ?? '';
    _cauleTipoCascaController.text = (data['cauleTipoCasca'] as String?) ?? '';
    _cauleCorController.text = (data['cauleCor'] as String?) ?? '';
    _cauleTamanhoController.text = (data['cauleTamanho'] as String?) ?? '';
    _cauleTamanhoUnidade = (data['cauleTamanhoUnidade'] as String?) ?? 'cm';
    _cauleCircunferenciaController.text =
        (data['cauleCircunferencia'] as String?) ?? '';
    _cauleCircunferenciaUnidade =
        (data['cauleCircunferenciaUnidade'] as String?) ?? 'cm';
    _cauleTemSeiva = (data['cauleTemSeiva'] as bool?) ?? false;
    _cauleDescricaoSeivaController.text =
        (data['cauleDescricaoSeiva'] as String?) ?? '';
    _folhaDescricaoController.text =
        (data['folhaDescricao'] as String?) ?? '';
    _folhaBainhaController.text = (data['folhaBainha'] as String?) ?? '';
    _folhaPecioloController.text = (data['folhaPeciolo'] as String?) ?? '';
    _folhaLaminaController.text = (data['folhaLamina'] as String?) ?? '';
    _florDescricaoController.text =
        (data['florDescricao'] as String?) ?? '';
    _florInflorescenciaController.text =
        (data['florInflorescencia'] as String?) ?? '';
    _florCorController.text = (data['florCor'] as String?) ?? '';
    _florTamanhoController.text = (data['florTamanho'] as String?) ?? '';
    _florTamanhoUnidade = (data['florTamanhoUnidade'] as String?) ?? 'cm';
    _frutoDescricaoController.text =
        (data['frutoDescricao'] as String?) ?? '';
    _frutoCorController.text = (data['frutoCor'] as String?) ?? '';
    _frutoFormatoController.text = (data['frutoFormato'] as String?) ?? '';
    _frutoTamanhoController.text = (data['frutoTamanho'] as String?) ?? '';
    _frutoTamanhoUnidade = (data['frutoTamanhoUnidade'] as String?) ?? 'cm';
    _sementeDescricaoController.text =
        (data['sementeDescricao'] as String?) ?? '';
    _sementeCorController.text = (data['sementeCor'] as String?) ?? '';
    _sementeFormatoController.text =
        (data['sementeFormato'] as String?) ?? '';
    _sementeTamanhoController.text =
        (data['sementeTamanho'] as String?) ?? '';
    _sementeTamanhoUnidade = (data['sementeTamanhoUnidade'] as String?) ?? 'mm';
    _altitudeController.text = (data['altitude'] as String?) ?? '';
    _temperatureController.text = (data['temperature'] as String?) ?? '';
    _humidityController.text = (data['humidity'] as String?) ?? '';
    _weatherNotesController.text = (data['weatherNotes'] as String?) ?? '';
    _windSpeedController.text = (data['windSpeed'] as String?) ?? '';
    _weatherCondition = data['weatherCondition'] as String?;
    _moonPhase = data['moonPhase'] as String?;
    _collectorNameController.text = (data['collectorName'] as String?) ?? '';
    _collectorNumberController.text =
        (data['collectorNumber'] as String?) ?? '';
    _numberOfIndividualsController.text =
        (data['numberOfIndividuals'] as String?) ?? '';
    _substrateController.text = (data['substrate'] as String?) ?? '';
    _associatedTaxaController.text =
        (data['associatedTaxa'] as String?) ?? '';
    _vegetationTypeController.text =
        (data['vegetationType'] as String?) ?? '';
    _topographyController.text = (data['topography'] as String?) ?? '';
    _determinationQualifierController.text =
        (data['determinationQualifier'] as String?) ?? '';
    _phenologyFournier = data['phenologyFournier'] as String?;

    final categoryName = data['selectedCategory'] as String?;
    if (categoryName != null) {
      try {
        _selectedCategory = PlantCategory.values.byName(categoryName);
      } catch (_) {}
    }
    final phenoName = data['phenologicalState'] as String?;
    if (phenoName != null) {
      try {
        _phenologicalState = PhenologicalState.values.byName(phenoName);
      } catch (_) {}
    }
    final methodName = data['collectionMethod'] as String?;
    if (methodName != null) {
      try {
        _collectionMethod = CollectionMethod.values.byName(methodName);
      } catch (_) {}
    }

    _selectedSessionId = data['selectedSessionId'] as String?;

    final dateStr = data['dateCollected'] as String?;
    if (dateStr != null) {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) _dateCollected = parsed;
    }

    _latitude = (data['latitude'] as num?)?.toDouble();
    _longitude = (data['longitude'] as num?)?.toDouble();

    _photoPaths = List<String>.from((data['photoPaths'] as List?) ?? []);
    _audioNotePaths =
        List<String>.from((data['audioNotePaths'] as List?) ?? []);
    _audioTranscripts =
        List<String>.from((data['audioTranscripts'] as List?) ?? []);

    final measurementsRaw = data['measurements'] as List?;
    if (measurementsRaw != null) {
      _measurements = measurementsRaw.map((raw) {
        final m = raw as Map<String, dynamic>;
        return Measurement()
          ..label = (m['label'] as String?) ?? ''
          ..value = (m['value'] as num?)?.toDouble() ?? 0.0
          ..unit = (m['unit'] as String?) ?? '';
      }).toList();
    }
  }

  /// Persists current form state to SharedPreferences before launching camera.
  Future<void> _saveSnapshotToPrefs() async {
    if (!Platform.isAndroid) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _kPlantFormSnapshotKey,
        jsonEncode(_captureSnapshot()),
      );
    } catch (e) {
      // Non-fatal: worst case is empty form on activity kill, same as before.
      debugPrint('PlantForm: failed to save snapshot: $e');
    }
  }

  /// On init, checks if a pre-camera snapshot exists and restores form state.
  /// Only applies to new-plant forms (editing plants are persisted in Isar).
  Future<void> _tryRestoreFromSnapshot() async {
    if (widget.plant != null || !mounted) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kPlantFormSnapshotKey);
      if (raw == null) return;
      // Clear immediately — if restore fails we don't want a corrupt loop.
      await prefs.remove(_kPlantFormSnapshotKey);
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if (mounted) setState(() => _restoreFromSnapshot(data));
    } catch (e) {
      debugPrint('PlantForm: failed to restore snapshot: $e');
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_kPlantFormSnapshotKey);
      } catch (_) {}
    }
  }

  /// Checks image_picker for a photo that was captured before the Activity
  /// was killed (Android activity recreation recovery).
  Future<void> _tryRecoverLostPhoto() async {
    if (!mounted) return;
    final recovered = await _photoService.retrieveLostPhoto();
    if (recovered != null && mounted) {
      setState(() => _photoPaths.add(recovered.path));
    }
  }

  Future<void> _takePhoto() async {
    // Persist all form state before handing off to the camera.  If Android
    // kills this Activity while the camera is in the foreground, the snapshot
    // will be read back in initState on the next launch.
    await _saveSnapshotToPrefs();
    try {
      final photo = await _photoService.takePhoto();
      if (photo != null && mounted) {
        setState(() {
          _photoPaths.add(photo.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorPhotoMsg(e.toString()),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      // Camera returned normally (or was cancelled / threw) — the snapshot
      // is no longer needed.  If the Activity was killed the finally block
      // never runs, which is intentional: the snapshot stays in prefs and
      // will be consumed on the next launch.
      if (Platform.isAndroid) {
        SharedPreferences.getInstance()
            .then((p) => p.remove(_kPlantFormSnapshotKey))
            .ignore();
      }
    }
  }

  Future<void> _scanLabelWithOcr() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final imageSource = await _selectOcrImageSource(l10n);
    if (imageSource == null || !mounted) {
      return;
    }

    File? imageFile;
    setState(() {
      _isProcessingOcr = true;
    });

    try {
      imageFile = imageSource == _OcrImageSource.camera
          ? await _photoService.takePhoto()
          : await _photoService.pickFromGallery();

      if (imageFile == null || !mounted) {
        return;
      }

      final result = await _ocrService.extractFromImage(imageFile);

      if (!mounted) {
        return;
      }

      if (result.rawText.trim().isEmpty || result.fields.isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.ocrNoTextFound)));
        return;
      }

      final reviewedFields = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) => OcrReviewDialog(initialFields: result.fields),
      );

      if (reviewedFields == null || !mounted) {
        return;
      }

      _applyOcrFields(reviewedFields);
    } catch (error) {
      debugPrint('OCR scan failed: $error');
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.errorOccurred),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    } finally {
      if (imageFile != null) {
        await _photoService.deletePhoto(imageFile.path);
      }
      if (mounted) {
        setState(() {
          _isProcessingOcr = false;
        });
      }
    }
  }

  Future<_OcrImageSource?> _selectOcrImageSource(AppLocalizations l10n) {
    return showModalBottomSheet<_OcrImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(l10n.takePhoto),
                onTap: () {
                  Navigator.of(context).pop(_OcrImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(l10n.chooseFromGallery),
                onTap: () {
                  Navigator.of(context).pop(_OcrImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyOcrFields(Map<String, String> fields) {
    final parsedDate = _parseOcrDate(fields['collectionDate']);
    final parsedLatitude = double.tryParse(fields['latitude']?.trim() ?? '');
    final parsedLongitude = double.tryParse(fields['longitude']?.trim() ?? '');

    setState(() {
      final scientificName = fields['scientificName']?.trim();
      if (scientificName != null && scientificName.isNotEmpty) {
        _scientificNameController.text = scientificName;
      }

      final family = fields['family']?.trim();
      if (family != null && family.isNotEmpty) {
        _familyController.text = family;
        _suggestedFamily = null;
      }

      final collectorName = fields['collectorName']?.trim();
      if (collectorName != null && collectorName.isNotEmpty) {
        _collectorNameController.text = collectorName;
      }

      final collectionNumber = fields['collectionNumber']?.trim();
      if (collectionNumber != null && collectionNumber.isNotEmpty) {
        _collectorNumberController.text = collectionNumber;
      }

      final locality = fields['locality']?.trim();
      if (locality != null && locality.isNotEmpty) {
        _localityController.text = locality;
      }

      if (parsedDate != null) {
        _dateCollected = parsedDate;
      }

      if (parsedLatitude != null) {
        _latitude = parsedLatitude;
      }

      if (parsedLongitude != null) {
        _longitude = parsedLongitude;
      }
    });
  }

  DateTime? _parseOcrDate(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    final slashMatch = RegExp(
      r'^(\d{2})\/(\d{2})\/(\d{4})$',
    ).firstMatch(trimmed);
    if (slashMatch != null) {
      final day = int.parse(slashMatch.group(1)!);
      final month = int.parse(slashMatch.group(2)!);
      final year = int.parse(slashMatch.group(3)!);
      return DateTime.tryParse(
        '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
      );
    }

    return DateTime.tryParse(trimmed);
  }

  Future<void> _pickFromGallery() async {
    await _saveSnapshotToPrefs();
    try {
      final photos = await _photoService.pickMultipleFromGallery();
      if (photos.isNotEmpty && mounted) {
        setState(() {
          _photoPaths.addAll(photos.map((f) => f.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorPickPhotoMsg(e.toString()),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (Platform.isAndroid) {
        SharedPreferences.getInstance()
            .then((p) => p.remove(_kPlantFormSnapshotKey))
            .ignore();
      }
    }
  }

  void _removePhoto(int index) {
    final path = _photoPaths[index];
    setState(() {
      _photoPaths.removeAt(index);
    });
    // Delete file if not from original plant (editing mode)
    if (widget.plant == null || !widget.plant!.photoPaths.contains(path)) {
      _photoService.deletePhoto(path);
    }
  }

  String _getBiomeName(AppLocalizations l10n, String biome) {
    switch (biome) {
      case BiomeDetector.cerrado:
        return l10n.biomeCerrado;
      case BiomeDetector.mataAtlantica:
        return l10n.biomeMataAtlantica;
      case BiomeDetector.amazonia:
        return l10n.biomeAmazonia;
      case BiomeDetector.caatinga:
        return l10n.biomeCaatinga;
      case BiomeDetector.pampa:
        return l10n.biomePampa;
      case BiomeDetector.pantanal:
        return l10n.biomePantanal;
      default:
        return biome;
    }
  }
}
