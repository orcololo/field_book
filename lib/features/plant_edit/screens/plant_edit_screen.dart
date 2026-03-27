import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/plant_record.dart';
import '../../../models/plant_category.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/utils/botanical_validator.dart';
import '../../../l10n/app_localizations.dart';

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

  late PlantCategory _selectedCategory;
  bool _isSaving = false;
  List<String> _duplicateWarnings = [];
  String? _suggestedFamily;

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

    // Listen to scientific name changes for auto-suggestions
    _scientificNameController.addListener(_onScientificNameChanged);
    _genusController.addListener(_onGenusChanged);
  }

  @override
  void dispose() {
    _scientificNameController.dispose();
    _commonNameController.dispose();
    _familyController.dispose();
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
    super.dispose();
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

    // Check for duplicates
    _checkDuplicates();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editPlant),
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
            // Scientific Name
            TextFormField(
              controller: _scientificNameController,
              decoration: InputDecoration(
                labelText: '${l10n.scientificName} *',
                hintText: 'Genus species',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.science),
              ),
              textCapitalization: TextCapitalization.words,
              validator: _validator.validateScientificName,
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
                suffixIcon:
                    _suggestedFamily != null &&
                        _familyController.text != _suggestedFamily
                    ? IconButton(
                        icon: Icon(
                          Icons.lightbulb,
                          color: colorScheme.tertiary,
                        ),
                        tooltip: l10n.suggestionWithName(_suggestedFamily!),
                        onPressed: () {
                          _familyController.text = _suggestedFamily!;
                          setState(() => _suggestedFamily = null);
                        },
                      )
                    : null,
              ),
              textCapitalization: TextCapitalization.words,
            ),

            if (_suggestedFamily != null &&
                _familyController.text != _suggestedFamily) ...[
              const SizedBox(height: 8),
              Card(
                color: colorScheme.tertiaryContainer,
                child: ListTile(
                  leading: Icon(Icons.lightbulb, color: colorScheme.tertiary),
                  title: Text(l10n.suggestionWithName(_suggestedFamily!)),
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
}
