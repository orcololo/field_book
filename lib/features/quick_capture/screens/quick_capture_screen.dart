import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../core/repositories/plant_repository.dart';
import '../../../core/services/geocoding_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/services/photo_service.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/theme/folium_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/plant_category.dart';
import '../../../models/plant_record.dart';
import '../../../shared/widgets/modern/modern_app_bar.dart';

const _uuid = Uuid();

/// SharedPreferences key for the QuickCapture form snapshot.  Written just
/// before the camera is opened on Android so that form state survives an
/// Activity kill; cleared immediately on restoration or when the camera
/// returns normally.
const _kQuickCaptureSnapshotKey = 'folium_quick_capture_snapshot';

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

/// Minimal quick-capture screen optimised for field conditions.
/// Auto-acquires GPS, offers one-tap photo, and saves as draft.
class QuickCaptureScreen extends ConsumerStatefulWidget {
  const QuickCaptureScreen({super.key});

  @override
  ConsumerState<QuickCaptureScreen> createState() => _QuickCaptureScreenState();
}

class _QuickCaptureScreenState extends ConsumerState<QuickCaptureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scientificNameController = TextEditingController();
  final _commonNameController = TextEditingController();
  final _notesController = TextEditingController();
  final _localityController = TextEditingController();
  final _municipalityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _altitudeController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _humidityController = TextEditingController();
  final _weatherNotesController = TextEditingController();

  PlantCategory _category = PlantCategory.herbs;
  String? _weatherCondition;
  String? _moonPhase;
  bool _showOfflineLocationHint = false;
  _LocationSnapshot? _lastLocationSnapshot;

  // GPS
  double? _latitude;
  double? _longitude;
  bool _fetchingGps = false;

  // Photo
  final List<String> _photoPaths = [];
  final _photoService = PhotoService();
  final _locationService = LocationService();
  final _geocodingService = GeocodingService();
  final _weatherService = WeatherService();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _acquireGps();
    // On Android, restore any form state persisted before the Activity was
    // killed while the camera was open, then recover any photo captured during
    // that session.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _tryRestoreSnapshot();
      // Only recover a lost photo if QuickCapture was the screen that opened
      // the camera.  Clear the owner key unconditionally so a stale value
      // never leaks into a later session on a different screen.
      if (Platform.isAndroid) {
        final prefs = await SharedPreferences.getInstance();
        final owner = prefs.getString(kRecoveryOwnerKey);
        await prefs.remove(kRecoveryOwnerKey);
        if (owner == 'quick_capture_camera') {
          final recovered = await _photoService.retrieveLostPhotos();
          if (recovered.isNotEmpty && mounted) {
            setState(() => _photoPaths.addAll(recovered.map((f) => f.path)));
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scientificNameController.dispose();
    _commonNameController.dispose();
    _notesController.dispose();
    _localityController.dispose();
    _municipalityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _altitudeController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _weatherNotesController.dispose();
    super.dispose();
  }

  Future<void> _acquireGps() async {
    setState(() {
      _fetchingGps = true;
    });
    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null && mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          if (_altitudeController.text.isEmpty && position.altitude != 0) {
            _altitudeController.text = position.altitude.toStringAsFixed(1);
          }
          _fetchingGps = false;
        });
        unawaited(_autofillLocation(position.latitude, position.longitude));
        unawaited(
          _autofillWeather(
            position.latitude,
            position.longitude,
            DateTime.now(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fetchingGps = false;
        });
      }
    }
  }

  /// Persists all form fields to SharedPreferences so they can be restored if
  /// Android kills this Activity while the camera is open.
  Future<void> _saveSnapshot() async {
    if (!Platform.isAndroid) return;
    final data = jsonEncode({
      'scientificName': _scientificNameController.text,
      'commonName': _commonNameController.text,
      'notes': _notesController.text,
      'locality': _localityController.text,
      'municipality': _municipalityController.text,
      'state': _stateController.text,
      'country': _countryController.text,
      'altitude': _altitudeController.text,
      'temperature': _temperatureController.text,
      'humidity': _humidityController.text,
      'weatherNotes': _weatherNotesController.text,
      'latitude': _latitude,
      'longitude': _longitude,
      'category': _category.name,
      'weatherCondition': _weatherCondition,
      'moonPhase': _moonPhase,
      'photoPaths': _photoPaths,
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kQuickCaptureSnapshotKey, data);
  }

  /// Reads any previously-persisted snapshot and restores all form fields.
  /// The snapshot is deleted immediately so it cannot be replayed on a
  /// subsequent cold start.
  Future<void> _tryRestoreSnapshot() async {
    if (!Platform.isAndroid) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kQuickCaptureSnapshotKey);
    if (raw == null || raw.isEmpty) return;
    await prefs.remove(_kQuickCaptureSnapshotKey);
    final data = jsonDecode(raw) as Map<String, dynamic>;
    if (!mounted) return;
    setState(() {
      _scientificNameController.text = data['scientificName'] as String? ?? '';
      _commonNameController.text = data['commonName'] as String? ?? '';
      _notesController.text = data['notes'] as String? ?? '';
      _localityController.text = data['locality'] as String? ?? '';
      _municipalityController.text = data['municipality'] as String? ?? '';
      _stateController.text = data['state'] as String? ?? '';
      _countryController.text = data['country'] as String? ?? '';
      _altitudeController.text = data['altitude'] as String? ?? '';
      _temperatureController.text = data['temperature'] as String? ?? '';
      _humidityController.text = data['humidity'] as String? ?? '';
      _weatherNotesController.text = data['weatherNotes'] as String? ?? '';
      _latitude = (data['latitude'] as num?)?.toDouble();
      _longitude = (data['longitude'] as num?)?.toDouble();
      final categoryName = data['category'] as String?;
      if (categoryName != null) {
        _category = PlantCategory.values.firstWhere(
          (c) => c.name == categoryName,
          orElse: () => PlantCategory.herbs,
        );
      }
      _weatherCondition = data['weatherCondition'] as String?;
      _moonPhase = data['moonPhase'] as String?;
      _photoPaths.addAll(
        (data['photoPaths'] as List?)?.cast<String>() ?? [],
      );
    });
  }

  Future<void> _takePhoto() async {
    // Persist form state before handing control to the camera. If Android
    // kills this Activity while the camera is open, _tryRestoreSnapshot()
    // in initState will recover everything.
    if (Platform.isAndroid) {
      await _saveSnapshot();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kRecoveryOwnerKey, 'quick_capture_camera');
    }
    try {
      final file = await _photoService.takePhoto();
      if (file != null && mounted) {
        setState(() => _photoPaths.add(file.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      // Clear snapshot and owner key now that the camera has returned normally.
      if (Platform.isAndroid) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_kQuickCaptureSnapshotKey);
        await prefs.remove(kRecoveryOwnerKey);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final settings = await ref.read(settingsNotifierProvider.future);
      final plantRepo = ref.read(plantRepositoryProvider);

      final plant = PlantRecord()
        ..uuid = _uuid.v4()
        ..scientificName = _scientificNameController.text.trim()
        ..commonName = _commonNameController.text.trim()
        ..category = _category
        ..dateCollected = DateTime.now()
        ..latitude = _latitude
        ..longitude = _longitude
        ..locality = _emptyToNull(_localityController.text)
        ..municipality = _emptyToNull(_municipalityController.text)
        ..state = _emptyToNull(_stateController.text)
        ..country = _emptyToNull(_countryController.text)
        ..determinations = []
        ..altitude = double.tryParse(_altitudeController.text.trim())
        ..temperature = double.tryParse(_temperatureController.text.trim())
        ..humidity = double.tryParse(_humidityController.text.trim())
        ..weatherCondition = _weatherCondition
        ..weatherNotes = _emptyToNull(_weatherNotesController.text)
        ..moonPhase = _moonPhase
        ..notes = _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim()
        ..photoPaths = _photoPaths
        ..duplicateUuids = []
        ..isDraft = true
        ..deviceId = settings.deviceId
        ..contributorName = settings.deviceName
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      plant.updateFtsFields();
      await plantRepo.save(plant);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.savedAsDraftSuccess)));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ModernAppBar(
        title: l10n.quickCapture,
        showBackButton: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildGpsChip(l10n, colorScheme),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(FoliumTheme.space16),
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 64,
              ),
              // ── Photo strip ──
              _buildPhotoSection(l10n, colorScheme),
              const SizedBox(height: FoliumTheme.space16),

              // ── Scientific name (required) ──
              TextFormField(
                controller: _scientificNameController,
                decoration: InputDecoration(
                  labelText: '${l10n.scientificName} *',
                  hintText: 'Genus species',
                  prefixIcon: const Icon(Icons.eco),
                ),
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                validator: (v) => v == null || v.trim().isEmpty
                    ? l10n.fillRequiredFields
                    : null,
              ),
              const SizedBox(height: FoliumTheme.space12),

              // ── Common name ──
              TextFormField(
                controller: _commonNameController,
                decoration: InputDecoration(
                  labelText: l10n.commonName,
                  prefixIcon: const Icon(Icons.local_florist),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: FoliumTheme.space12),

              // ── Category chips ──
              _buildCategoryChips(l10n, colorScheme),
              const SizedBox(height: FoliumTheme.space16),

              // ── Quick notes ──
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: l10n.quickNotes,
                  hintText: l10n.quickNotesHint,
                  prefixIcon: const Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: FoliumTheme.space16),

              TextFormField(
                controller: _localityController,
                decoration: InputDecoration(
                  labelText: l10n.locality,
                  prefixIcon: const Icon(Icons.place_outlined),
                  hintText: _locationHintText(l10n),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: FoliumTheme.space12),
              TextFormField(
                controller: _municipalityController,
                decoration: InputDecoration(
                  labelText: l10n.municipality,
                  prefixIcon: const Icon(Icons.location_city),
                  hintText: _locationHintText(l10n),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: FoliumTheme.space12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        labelText: l10n.state,
                        prefixIcon: const Icon(Icons.map_outlined),
                        hintText: _locationHintText(l10n),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  const SizedBox(width: FoliumTheme.space12),
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: InputDecoration(
                        labelText: l10n.country,
                        prefixIcon: const Icon(Icons.public),
                        hintText: _locationHintText(l10n),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FoliumTheme.space16),

              // ── Environmental data (collapsible) ──
              _buildEnvironmentalSection(l10n, colorScheme),

              const SizedBox(height: FoliumTheme.space24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FoliumTheme.space16),
          child: FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(_saving ? l10n.saving : l10n.save),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ),
      ),
    );
  }

  // ── GPS chip ──
  Widget _buildGpsChip(AppLocalizations l10n, ColorScheme colorScheme) {
    if (_fetchingGps) {
      return Chip(
        avatar: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
        label: Text(l10n.gpsAcquiring, style: const TextStyle(fontSize: 12)),
      );
    }
    if (_latitude != null) {
      return ActionChip(
        avatar: Icon(Icons.gps_fixed, size: 16, color: colorScheme.secondary),
        label: Text(
          '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
          style: const TextStyle(fontSize: 11),
        ),
        tooltip: l10n.gpsAcquired,
        backgroundColor: colorScheme.secondaryContainer,
        onPressed: _acquireGps,
      );
    }
    return ActionChip(
      avatar: Icon(Icons.gps_off, size: 16, color: colorScheme.error),
      label: Text(l10n.gpsFailed, style: const TextStyle(fontSize: 12)),
      onPressed: _acquireGps,
    );
  }

  // ── Photo strip ──
  Widget _buildPhotoSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Add photo button
          GestureDetector(
            onTap: _takePhoto,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(FoliumTheme.radiusMedium),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 36, color: colorScheme.primary),
                  const SizedBox(height: 4),
                  Text(
                    l10n.takePhoto,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Existing photos
          ..._photoPaths.map(
            (path) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(FoliumTheme.radiusMedium),
                child: Stack(
                  children: [
                    Image.file(
                      File(path),
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () async {
                          await _photoService.deletePhoto(path);
                          if (mounted) {
                            setState(() => _photoPaths.remove(path));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category chips ──
  Widget _buildCategoryChips(AppLocalizations l10n, ColorScheme colorScheme) {
    final categories = {
      PlantCategory.trees: l10n.categoryTrees,
      PlantCategory.shrubs: l10n.categoryShrubs,
      PlantCategory.herbs: l10n.categoryHerbs,
      PlantCategory.ferns: l10n.categoryFerns,
      PlantCategory.grasses: l10n.categoryGrasses,
      PlantCategory.vines: l10n.categoryVines,
      PlantCategory.cacti: l10n.categoryCacti,
      PlantCategory.aquatic: l10n.categoryAquatic,
    };

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: categories.entries.map((e) {
        final selected = _category == e.key;
        return ChoiceChip(
          label: Text(e.value),
          selected: selected,
          onSelected: (_) => setState(() => _category = e.key),
          selectedColor: colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: selected ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  // ── Environmental data ──
  Widget _buildEnvironmentalSection(
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final weatherOptions = {
      'sunny': l10n.weatherSunny,
      'cloudy': l10n.weatherCloudy,
      'overcast': l10n.weatherOvercast,
      'rainy': l10n.weatherRainy,
      'stormy': l10n.weatherStormy,
      'foggy': l10n.weatherFoggy,
      'windy': l10n.weatherWindy,
    };

    return ExpansionTile(
      leading: const Icon(Icons.thermostat),
      title: Text(l10n.environmentalData),
      initiallyExpanded: false,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FoliumTheme.space16,
            vertical: FoliumTheme.space8,
          ),
          child: Column(
            children: [
              // Weather condition chips
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.weatherCondition,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: weatherOptions.entries.map((e) {
                  final selected = _weatherCondition == e.key;
                  return ChoiceChip(
                    label: Text(e.value),
                    selected: selected,
                    onSelected: (_) => setState(
                      () => _weatherCondition = selected ? null : e.key,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: FoliumTheme.space12),
              // Numeric fields row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _altitudeController,
                      decoration: InputDecoration(
                        labelText: l10n.altitude,
                        hintText: l10n.altitudeHint,
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
                      controller: _temperatureController,
                      decoration: InputDecoration(
                        labelText: l10n.temperatureLabel,
                        hintText: l10n.temperatureHint,
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
              const SizedBox(height: FoliumTheme.space12),
              TextFormField(
                controller: _humidityController,
                decoration: InputDecoration(
                  labelText: l10n.humidityLabel,
                  hintText: l10n.humidityHint,
                  isDense: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: FoliumTheme.space12),
              TextFormField(
                controller: _weatherNotesController,
                decoration: InputDecoration(
                  labelText: l10n.weatherNotes,
                  hintText: l10n.weatherNotesHint,
                  isDense: true,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: FoliumTheme.space12),
              TextFormField(
                key: ValueKey(_moonPhase),
                initialValue:
                    _moonPhase == null ? '' : _getMoonPhaseLabel(l10n, _moonPhase!),
                decoration: InputDecoration(
                  labelText: l10n.moonPhase,
                  isDense: true,
                ),
                readOnly: true,
              ),
              const SizedBox(height: FoliumTheme.space8),
            ],
          ),
        ),
      ],
    );
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
        _temperatureController.text = weatherData.temperature!.toStringAsFixed(1);
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
}
