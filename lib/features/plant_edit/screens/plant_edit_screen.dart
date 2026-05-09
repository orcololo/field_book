import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/taxon_provider.dart';
import '../../../features/identification/screens/dichotomous_key_screen.dart';
import '../../../models/plant_record.dart';
import '../../../models/plant_category.dart';
import '../../../models/collection_method.dart';
import '../../../models/phenological_state.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/services/taxon_service.dart';
import '../../../core/utils/botanical_validator.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/modern/modern_app_bar.dart';

class PlantEditScreen extends ConsumerStatefulWidget {
  final PlantRecord plant;

  const PlantEditScreen({super.key, required this.plant});

  @override
  ConsumerState<PlantEditScreen> createState() => _PlantEditScreenState();
}

class _PlantEditScreenState extends ConsumerState<PlantEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final PlantRepository _plantRepo;
  late final BotanicalValidator _validator;

  late TextEditingController _scientificNameController;
  late TextEditingController _commonNameController;
  late TextEditingController _familyController;
  late TextEditingController _scientificAuthorController;
  late TextEditingController _taxonStatusController;
  late TextEditingController _genusController;
  late TextEditingController _speciesController;
  late TextEditingController _habitatController;
  late TextEditingController _notesController;

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

  // Environmental data
  late TextEditingController _altitudeController;
  late TextEditingController _temperatureController;
  late TextEditingController _humidityController;
  late TextEditingController _windSpeedController;
  String? _weatherCondition;

  // Botanical field notebook fields
  late TextEditingController _collectorNumberController;
  late TextEditingController _numberOfIndividualsController;
  late TextEditingController _substrateController;
  late TextEditingController _associatedTaxaController;
  late TextEditingController _vegetationTypeController;
  late TextEditingController _topographyController;
  late TextEditingController _determinationQualifierController;
  PhenologicalState? _phenologicalState;
  CollectionMethod? _collectionMethod;

  late PlantCategory _selectedCategory;
  bool _isSaving = false;
  List<String> _duplicateWarnings = [];
  String? _suggestedFamily;
  Timer? _taxonSearchDebounce;
  List<TaxonSuggestion> _taxonSuggestions = const [];

  @override
  void initState() {
    super.initState();
    _plantRepo = ref.read(plantRepositoryProvider);
    _validator = BotanicalValidator(_plantRepo);

    _scientificNameController = TextEditingController(
      text: widget.plant.scientificName,
    );
    _commonNameController = TextEditingController(
      text: widget.plant.commonName,
    );
    _familyController = TextEditingController(text: widget.plant.family ?? '');
    _scientificAuthorController = TextEditingController(
      text: widget.plant.scientificAuthor ?? '',
    );
    _taxonStatusController = TextEditingController(
      text: widget.plant.taxonStatus ?? '',
    );
    _genusController = TextEditingController(text: widget.plant.genus ?? '');
    _speciesController = TextEditingController(
      text: widget.plant.species ?? '',
    );
    _habitatController = TextEditingController(
      text: widget.plant.habitat ?? '',
    );
    _notesController = TextEditingController(text: widget.plant.notes ?? '');
    _selectedCategory = widget.plant.category;

    // Morphology controllers
    _raizController = TextEditingController(text: widget.plant.raiz ?? '');
    _cauleController = TextEditingController(text: widget.plant.caule ?? '');
    _cauleTipoCascaController = TextEditingController(
      text: widget.plant.cauleTipoCasca ?? '',
    );
    _cauleCorController = TextEditingController(
      text: widget.plant.cauleCor ?? '',
    );
    _cauleTamanhoController = TextEditingController(
      text: widget.plant.cauleTamanho != null
          ? widget.plant.cauleTamanho.toString()
          : '',
    );
    _cauleTamanhoUnidade = widget.plant.cauleTamanhoUnidade ?? 'cm';
    _cauleCircunferenciaController = TextEditingController(
      text: widget.plant.cauleCircunferencia != null
          ? widget.plant.cauleCircunferencia.toString()
          : '',
    );
    _cauleCircunferenciaUnidade =
        widget.plant.cauleCircunferenciaUnidade ?? 'cm';
    _cauleTemSeiva = widget.plant.cauleTemSeiva;
    _cauleDescricaoSeivaController = TextEditingController(
      text: widget.plant.cauleDescricaoSeiva ?? '',
    );
    _folhaDescricaoController = TextEditingController(
      text: widget.plant.folhaDescricao ?? '',
    );
    _folhaBainhaController = TextEditingController(
      text: widget.plant.folhaBainha ?? '',
    );
    _folhaPecioloController = TextEditingController(
      text: widget.plant.folhaPeciolo ?? '',
    );
    _folhaLaminaController = TextEditingController(
      text: widget.plant.folhaLamina ?? '',
    );
    // Flor
    _florDescricaoController = TextEditingController(
      text: widget.plant.florDescricao ?? '',
    );
    _florInflorescenciaController = TextEditingController(
      text: widget.plant.florInflorescencia ?? '',
    );
    _florCorController = TextEditingController(
      text: widget.plant.florCor ?? '',
    );
    _florTamanhoController = TextEditingController(
      text: widget.plant.florTamanho != null
          ? widget.plant.florTamanho.toString()
          : '',
    );
    _florTamanhoUnidade = widget.plant.florTamanhoUnidade ?? 'cm';
    // Fruto
    _frutoDescricaoController = TextEditingController(
      text: widget.plant.frutoDescricao ?? '',
    );
    _frutoCorController = TextEditingController(
      text: widget.plant.frutoCor ?? '',
    );
    _frutoFormatoController = TextEditingController(
      text: widget.plant.frutoFormato ?? '',
    );
    _frutoTamanhoController = TextEditingController(
      text: widget.plant.frutoTamanho != null
          ? widget.plant.frutoTamanho.toString()
          : '',
    );
    _frutoTamanhoUnidade = widget.plant.frutoTamanhoUnidade ?? 'cm';
    // Semente
    _sementeDescricaoController = TextEditingController(
      text: widget.plant.sementeDescricao ?? '',
    );
    _sementeCorController = TextEditingController(
      text: widget.plant.sementeCor ?? '',
    );
    _sementeFormatoController = TextEditingController(
      text: widget.plant.sementeFormato ?? '',
    );
    _sementeTamanhoController = TextEditingController(
      text: widget.plant.sementeTamanho != null
          ? widget.plant.sementeTamanho.toString()
          : '',
    );
    _sementeTamanhoUnidade = widget.plant.sementeTamanhoUnidade ?? 'mm';

    // Environmental data
    _altitudeController = TextEditingController(
      text: widget.plant.altitude?.toString() ?? '',
    );
    _temperatureController = TextEditingController(
      text: widget.plant.temperature?.toString() ?? '',
    );
    _humidityController = TextEditingController(
      text: widget.plant.humidity?.toString() ?? '',
    );
    _windSpeedController = TextEditingController(
      text: widget.plant.windSpeed?.toString() ?? '',
    );
    _weatherCondition = widget.plant.weatherCondition;

    // Botanical field notebook fields
    _collectorNumberController = TextEditingController(
      text: widget.plant.collectorNumber ?? '',
    );
    _numberOfIndividualsController = TextEditingController(
      text: widget.plant.numberOfIndividuals?.toString() ?? '',
    );
    _substrateController = TextEditingController(
      text: widget.plant.substrate ?? '',
    );
    _associatedTaxaController = TextEditingController(
      text: widget.plant.associatedTaxa ?? '',
    );
    _vegetationTypeController = TextEditingController(
      text: widget.plant.vegetationType ?? '',
    );
    _topographyController = TextEditingController(
      text: widget.plant.topography ?? '',
    );
    _determinationQualifierController = TextEditingController(
      text: widget.plant.determinationQualifier ?? '',
    );
    _phenologicalState = widget.plant.phenologicalState;
    _collectionMethod = widget.plant.collectionMethod;

    // Listen to scientific name changes for auto-suggestions
    _scientificNameController.addListener(_onScientificNameChanged);
    _genusController.addListener(_onGenusChanged);
  }

  @override
  void dispose() {
    _taxonSearchDebounce?.cancel();
    _scientificNameController.dispose();
    _commonNameController.dispose();
    _familyController.dispose();
    _scientificAuthorController.dispose();
    _taxonStatusController.dispose();
    _genusController.dispose();
    _speciesController.dispose();
    _habitatController.dispose();
    _notesController.dispose();
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
    _windSpeedController.dispose();
    _collectorNumberController.dispose();
    _numberOfIndividualsController.dispose();
    _substrateController.dispose();
    _associatedTaxaController.dispose();
    _vegetationTypeController.dispose();
    _topographyController.dispose();
    _determinationQualifierController.dispose();
    super.dispose();
  }

  void _onScientificNameChanged() {
    final name = _scientificNameController.text.trim();
    _scheduleTaxonSearch(name);

    if (name.isEmpty) {
      setState(() => _taxonSuggestions = const []);
      return;
    }

    // Parse genus and species
    final parsed = _validator.parseScientificName(name);
    if (parsed['genus'] != null && _genusController.text != parsed['genus']) {
      _genusController.text = parsed['genus']!;
    }
    if (parsed['species'] != null &&
        _speciesController.text != parsed['species']) {
      _speciesController.text = parsed['species']!;
    }

    // Check for duplicates
    _checkDuplicates();
  }

  void _scheduleTaxonSearch(String query) {
    _taxonSearchDebounce?.cancel();

    final normalizedQuery = query.trim();
    if (normalizedQuery.length < 2) {
      if (mounted) {
        setState(() => _taxonSuggestions = const []);
      }
      return;
    }

    _taxonSearchDebounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final suggestions = await ref.read(
          taxonSearchProvider(normalizedQuery).future,
        );

        if (!mounted ||
            _scientificNameController.text.trim().toLowerCase() !=
                normalizedQuery.toLowerCase()) {
          return;
        }

        setState(() => _taxonSuggestions = suggestions);
      } catch (_) {
        if (mounted) {
          setState(() => _taxonSuggestions = const []);
        }
      }
    });
  }

  void _onGenusChanged() {
    final genus = _genusController.text;
    if (genus.isEmpty) return;

    // Suggest family
    final suggestedFamily = _validator.suggestFamily(genus);
    if (suggestedFamily != null) {
      setState(() {
        _suggestedFamily = suggestedFamily;
      });
    }
  }

  Future<void> _checkDuplicates() async {
    final duplicates = await _validator.checkForDuplicates(
      _scientificNameController.text,
      excludeId: widget.plant.uuid,
    );

    if (mounted) {
      setState(() {
        _duplicateWarnings = duplicates;
      });
    }
  }

  Future<void> _savePlant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // Update plant record
      widget.plant.scientificName = _scientificNameController.text.trim();
      widget.plant.commonName = _commonNameController.text.trim();
      widget.plant.family = _familyController.text.trim().isEmpty
          ? null
          : _familyController.text.trim();
      widget.plant.scientificAuthor =
          _scientificAuthorController.text.trim().isEmpty
          ? null
          : _scientificAuthorController.text.trim();
      widget.plant.taxonStatus = _taxonStatusController.text.trim().isEmpty
          ? null
          : _taxonStatusController.text.trim();
      widget.plant.genus = _genusController.text.trim().isEmpty
          ? null
          : _genusController.text.trim();
      widget.plant.species = _speciesController.text.trim().isEmpty
          ? null
          : _speciesController.text.trim();
      widget.plant.habitat = _habitatController.text.trim().isEmpty
          ? null
          : _habitatController.text.trim();
      widget.plant.notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();
      widget.plant.raiz = _raizController.text.trim().isEmpty
          ? null
          : _raizController.text.trim();
      widget.plant.caule = _cauleController.text.trim().isEmpty
          ? null
          : _cauleController.text.trim();
      widget.plant.cauleTipoCasca =
          _cauleTipoCascaController.text.trim().isEmpty
          ? null
          : _cauleTipoCascaController.text.trim();
      widget.plant.cauleCor = _cauleCorController.text.trim().isEmpty
          ? null
          : _cauleCorController.text.trim();
      widget.plant.cauleTamanho = _cauleTamanhoController.text.trim().isNotEmpty
          ? double.tryParse(_cauleTamanhoController.text.trim())
          : null;
      widget.plant.cauleTamanhoUnidade =
          _cauleTamanhoController.text.trim().isNotEmpty
          ? _cauleTamanhoUnidade
          : null;
      widget.plant.cauleCircunferencia =
          _cauleCircunferenciaController.text.trim().isNotEmpty
          ? double.tryParse(_cauleCircunferenciaController.text.trim())
          : null;
      widget.plant.cauleCircunferenciaUnidade =
          _cauleCircunferenciaController.text.trim().isNotEmpty
          ? _cauleCircunferenciaUnidade
          : null;
      widget.plant.cauleTemSeiva = _cauleTemSeiva;
      widget.plant.cauleDescricaoSeiva =
          _cauleDescricaoSeivaController.text.trim().isEmpty
          ? null
          : _cauleDescricaoSeivaController.text.trim();
      widget.plant.folhaDescricao =
          _folhaDescricaoController.text.trim().isEmpty
          ? null
          : _folhaDescricaoController.text.trim();
      widget.plant.folhaBainha = _folhaBainhaController.text.trim().isEmpty
          ? null
          : _folhaBainhaController.text.trim();
      widget.plant.folhaPeciolo = _folhaPecioloController.text.trim().isEmpty
          ? null
          : _folhaPecioloController.text.trim();
      widget.plant.folhaLamina = _folhaLaminaController.text.trim().isEmpty
          ? null
          : _folhaLaminaController.text.trim();
      widget.plant.florDescricao = _florDescricaoController.text.trim().isEmpty
          ? null
          : _florDescricaoController.text.trim();
      widget.plant.florInflorescencia =
          _florInflorescenciaController.text.trim().isEmpty
          ? null
          : _florInflorescenciaController.text.trim();
      widget.plant.florCor = _florCorController.text.trim().isEmpty
          ? null
          : _florCorController.text.trim();
      widget.plant.florTamanho = _florTamanhoController.text.trim().isNotEmpty
          ? double.tryParse(_florTamanhoController.text.trim())
          : null;
      widget.plant.florTamanhoUnidade =
          _florTamanhoController.text.trim().isNotEmpty
          ? _florTamanhoUnidade
          : null;
      widget.plant.frutoDescricao =
          _frutoDescricaoController.text.trim().isEmpty
          ? null
          : _frutoDescricaoController.text.trim();
      widget.plant.frutoCor = _frutoCorController.text.trim().isEmpty
          ? null
          : _frutoCorController.text.trim();
      widget.plant.frutoFormato = _frutoFormatoController.text.trim().isEmpty
          ? null
          : _frutoFormatoController.text.trim();
      widget.plant.frutoTamanho = _frutoTamanhoController.text.trim().isNotEmpty
          ? double.tryParse(_frutoTamanhoController.text.trim())
          : null;
      widget.plant.frutoTamanhoUnidade =
          _frutoTamanhoController.text.trim().isNotEmpty
          ? _frutoTamanhoUnidade
          : null;
      widget.plant.sementeDescricao =
          _sementeDescricaoController.text.trim().isEmpty
          ? null
          : _sementeDescricaoController.text.trim();
      widget.plant.sementeCor = _sementeCorController.text.trim().isEmpty
          ? null
          : _sementeCorController.text.trim();
      widget.plant.sementeFormato =
          _sementeFormatoController.text.trim().isEmpty
          ? null
          : _sementeFormatoController.text.trim();
      widget.plant.sementeTamanho =
          _sementeTamanhoController.text.trim().isNotEmpty
          ? double.tryParse(_sementeTamanhoController.text.trim())
          : null;
      widget.plant.sementeTamanhoUnidade =
          _sementeTamanhoController.text.trim().isNotEmpty
          ? _sementeTamanhoUnidade
          : null;
      widget.plant.category = _selectedCategory;
      // Environmental data
      widget.plant.altitude = _altitudeController.text.trim().isNotEmpty
          ? double.tryParse(_altitudeController.text.trim())
          : null;
      widget.plant.temperature = _temperatureController.text.trim().isNotEmpty
          ? double.tryParse(_temperatureController.text.trim())
          : null;
      widget.plant.humidity = _humidityController.text.trim().isNotEmpty
          ? double.tryParse(_humidityController.text.trim())
          : null;
      widget.plant.windSpeed = _windSpeedController.text.trim().isNotEmpty
          ? double.tryParse(_windSpeedController.text.trim())
          : null;
      widget.plant.weatherCondition = _weatherCondition;
      widget.plant.collectorNumber =
          _collectorNumberController.text.trim().isNotEmpty
              ? _collectorNumberController.text.trim()
              : null;
      widget.plant.numberOfIndividuals =
          _numberOfIndividualsController.text.trim().isNotEmpty
              ? int.tryParse(_numberOfIndividualsController.text.trim())
              : null;
      widget.plant.substrate = _substrateController.text.trim().isNotEmpty
          ? _substrateController.text.trim()
          : null;
      widget.plant.associatedTaxa =
          _associatedTaxaController.text.trim().isNotEmpty
              ? _associatedTaxaController.text.trim()
              : null;
      widget.plant.vegetationType =
          _vegetationTypeController.text.trim().isNotEmpty
              ? _vegetationTypeController.text.trim()
              : null;
      widget.plant.topography = _topographyController.text.trim().isNotEmpty
          ? _topographyController.text.trim()
          : null;
      widget.plant.determinationQualifier =
          _determinationQualifierController.text.trim().isNotEmpty
              ? _determinationQualifierController.text.trim()
              : null;
      widget.plant.phenologicalState = _phenologicalState;
      widget.plant.collectionMethod = _collectionMethod;
      widget.plant.updatedAt = DateTime.now();

      widget.plant.updateFtsFields();

      await _plantRepo.save(widget.plant);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.plantUpdatedSuccessfully)));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorUpdatingPlant(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _applyTaxonSuggestion(TaxonSuggestion suggestion) {
    _scientificNameController.value = TextEditingValue(
      text: suggestion.name,
      selection: TextSelection.collapsed(offset: suggestion.name.length),
    );
    _familyController.text = suggestion.family ?? _familyController.text;
    _scientificAuthorController.text = suggestion.author ?? '';
    _taxonStatusController.text = suggestion.status;

    final parsed = _validator.parseScientificName(suggestion.name);
    _genusController.text = parsed['genus'] ?? _genusController.text;
    _speciesController.text = parsed['species'] ?? _speciesController.text;

    setState(() {
      _suggestedFamily = suggestion.family ?? _suggestedFamily;
      _taxonSuggestions = const [];
    });
  }

  Future<void> _openDichotomousKey() async {
    final selectedFamily = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const DichotomousKeyScreen()),
    );

    if (!mounted || selectedFamily == null || selectedFamily.isEmpty) {
      return;
    }

    setState(() {
      _familyController.text = selectedFamily;
      if (_suggestedFamily == selectedFamily) {
        _suggestedFamily = null;
      }
    });
  }

  Widget _buildFamilyFieldSuffixIcon(
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final hasSuggestion =
        _suggestedFamily != null && _familyController.text != _suggestedFamily;

    return SizedBox(
      width: hasSuggestion ? 96 : 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: l10n.identifyFamilyWithKey,
            onPressed: _openDichotomousKey,
          ),
          if (hasSuggestion)
            IconButton(
              icon: Icon(
                Icons.lightbulb,
                color: colorScheme.tertiary,
              ),
              tooltip: l10n.suggestionWithName(_suggestedFamily!),
              onPressed: () {
                _familyController.text = _suggestedFamily!;
                setState(() => _suggestedFamily = null);
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ModernAppBar(
        title: l10n.editPlant,
        showBackButton: true,
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _savePlant,
              tooltip: l10n.save,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 64,
            ),
            // Scientific Name
            Autocomplete<TaxonSuggestion>(
              displayStringForOption: (option) => option.name,
              optionsBuilder: (textEditingValue) {
                final query = textEditingValue.text.trim().toLowerCase();
                if (query.length < 2) {
                  return const Iterable<TaxonSuggestion>.empty();
                }

                return _taxonSuggestions.where((suggestion) {
                  final haystack = [
                    suggestion.name,
                    suggestion.author ?? '',
                    suggestion.family ?? '',
                    suggestion.rank ?? '',
                  ].join(' ').toLowerCase();
                  return haystack.contains(query);
                });
              },
              onSelected: _applyTaxonSuggestion,
              fieldViewBuilder:
                  (context, textEditingController, focusNode, onFieldSubmitted) {
                    if (!identical(
                      textEditingController,
                      _scientificNameController,
                    )) {
                      textEditingController.value = _scientificNameController.value;
                    }

                    return TextFormField(
                      controller: _scientificNameController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: '${l10n.scientificName} *',
                        hintText: l10n.taxonSearchHint,
                        helperText: l10n.taxonOfflineHint,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.science),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: _validator.validateScientificName,
                      onFieldSubmitted: (_) => onFieldSubmitted(),
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                final optionsList = options.toList(growable: false);
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                        maxHeight: 280,
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        itemCount: optionsList.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final option = optionsList[index];
                          final subtitle = option.subtitleParts.isEmpty
                              ? _getTaxonStatusLabel(l10n, option.status)
                              : '${option.subtitleParts} • ${_getTaxonStatusLabel(l10n, option.status)}';

                          return ListTile(
                            leading: Icon(
                              option.status == 'synonym'
                                  ? Icons.link
                                  : Icons.check_circle_outline,
                            ),
                            title: Text(option.name),
                            subtitle: Text(subtitle),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),

            // Duplicate warnings
            if (_duplicateWarnings.isNotEmpty) ...[
              const SizedBox(height: 8),
              Card(
                color: colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: colorScheme.error,
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

            // Common Name
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

            // Taxonomy Section
            Text(
              l10n.taxonomyInfo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Genus
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

            // Species
            TextFormField(
              controller: _speciesController,
              decoration: InputDecoration(
                labelText: l10n.species,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.grain),
              ),
            ),

            const SizedBox(height: 16),

            // Family
            TextFormField(
              controller: _familyController,
              decoration: InputDecoration(
                labelText: l10n.family,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.account_tree),
                suffixIcon: _buildFamilyFieldSuffixIcon(l10n, colorScheme),
              ),
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _scientificAuthorController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: l10n.taxonAuthor,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _taxonStatusController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: l10n.taxonStatus,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.verified_outlined),
                    ),
                  ),
                ),
              ],
            ),

            if (_suggestedFamily != null &&
                _familyController.text != _suggestedFamily) ...[
              const SizedBox(height: 8),
              Card(
                color: colorScheme.tertiaryContainer,
                child: ListTile(
                  leading: Icon(Icons.lightbulb, color: colorScheme.tertiary),
                  title: Text(l10n.suggestionWithName(_suggestedFamily!), maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(l10n.basedOnGenus),
                  trailing: TextButton(
                    onPressed: () {
                      _familyController.text = _suggestedFamily!;
                      setState(() => _suggestedFamily = null);
                    },
                    child: Text(l10n.apply),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<PlantCategory>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: l10n.category,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: PlantCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(_getCategoryName(category)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),

            const SizedBox(height: 16),

            // Habitat
            TextFormField(
              controller: _habitatController,
              decoration: InputDecoration(
                labelText: l10n.habitat,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.terrain),
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l10n.observations,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.notes),
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: 24),

            // Environmental Data Section
            Text(
              l10n.environmentalData,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              l10n.weatherCondition,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  <MapEntry<String, String>>[
                    MapEntry('sunny', l10n.weatherSunny),
                    MapEntry('cloudy', l10n.weatherCloudy),
                    MapEntry('overcast', l10n.weatherOvercast),
                    MapEntry('rainy', l10n.weatherRainy),
                    MapEntry('stormy', l10n.weatherStormy),
                    MapEntry('foggy', l10n.weatherFoggy),
                    MapEntry('windy', l10n.weatherWindy),
                  ].map((entry) {
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

            const SizedBox(height: 24),
            // ── Habitat Details ──────────────────────────────────────
            Text(
              l10n.habitatDetails,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
            // ── Collection Info ──────────────────────────────────────
            Text(
              l10n.collectionInfo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
            DropdownButtonFormField<CollectionMethod>(
              initialValue: _collectionMethod,
              decoration: InputDecoration(
                labelText: l10n.collectionMethod,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.science),
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.notSpecified),
                ),
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

            const SizedBox(height: 24),

            // Morphology Section
            Text(
              l10n.morphology,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  onUnitChanged: (v) =>
                      setState(() => _cauleTamanhoUnidade = v),
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
                  onUnitChanged: (v) =>
                      setState(() => _frutoTamanhoUnidade = v),
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
                  onUnitChanged: (v) =>
                      setState(() => _sementeTamanhoUnidade = v),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Save Button
            FilledButton.icon(
              onPressed: _isSaving ? null : _savePlant,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? l10n.saving : l10n.saveChanges),
            ),
          ],
        ),
      ),
    );
  }

  // --- Morphology helper widgets ---

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

  String _getCategoryName(PlantCategory category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case PlantCategory.trees:
        return l10n.categoryTrees;
      case PlantCategory.shrubs:
        return l10n.categoryShrubs;
      case PlantCategory.herbs:
        return l10n.categoryHerbs;
      case PlantCategory.vines:
        return l10n.categoryVines;
      case PlantCategory.ferns:
        return l10n.categoryFerns;
      case PlantCategory.grasses:
        return l10n.categoryGrasses;
      case PlantCategory.cacti:
        return l10n.categoryCacti;
      case PlantCategory.aquatic:
        return l10n.categoryAquatic;
    }
  }

  String _getPhenologicalStateName(
      AppLocalizations l10n, PhenologicalState state) {
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
      AppLocalizations l10n, CollectionMethod method) {
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

  String _getTaxonStatusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'synonym':
        return l10n.taxonStatusSynonym;
      case 'accepted':
      default:
        return l10n.taxonStatusAccepted;
    }
  }
}
