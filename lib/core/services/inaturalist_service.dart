import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/plant_record.dart';
import '../../models/settings.dart';
import '../repositories/plant_repository.dart';
import 'settings_service.dart';

part 'inaturalist_service.g.dart';

class InaturalistException implements Exception {
  final String message;

  const InaturalistException(this.message);

  @override
  String toString() => message;
}

@riverpod
InaturalistService inaturalistService(InaturalistServiceRef ref) {
  return InaturalistService(
    plantRepository: ref.read(plantRepositoryProvider),
    loadSettings: () => ref.read(settingsNotifierProvider.future),
  );
}

class InaturalistService {
  static const String _baseUrl = 'https://api.inaturalist.org/v1';

  final PlantRepository _plantRepository;
  final Future<Settings> Function() _loadSettings;

  InaturalistService({
    required PlantRepository plantRepository,
    required Future<Settings> Function() loadSettings,
  }) : _plantRepository = plantRepository,
        _loadSettings = loadSettings;

  Future<String?> createObservation(PlantRecord record) async {
    final settings = await _requireSettings();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/observations'),
    )..headers.addAll(_authHeaders(settings));

    if (record.scientificName.trim().isEmpty) {
      throw const InaturalistException('Scientific name is required.');
    }

    request.fields['taxon_name'] = record.scientificName.trim();
    request.fields['observed_on'] = _formatObservedOn(record.dateCollected);
    request.fields['observed_time_string'] = record.dateCollected.toIso8601String();

    if (record.latitude != null) {
      request.fields['latitude'] = record.latitude!.toString();
    }
    if (record.longitude != null) {
      request.fields['longitude'] = record.longitude!.toString();
    }

    final description = _buildDescription(record);
    if (description.isNotEmpty) {
      request.fields['description'] = description;
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw InaturalistException(_extractErrorMessage(body));
    }

    final observationId = _extractObservationId(body);
    if (observationId == null || observationId.isEmpty) {
      throw const InaturalistException('iNaturalist returned no observation id.');
    }

    for (final photoPath in record.photoPaths) {
      if (photoPath.trim().isEmpty) continue;
      if (!File(photoPath).existsSync()) continue;
      await uploadPhoto(observationId, photoPath);
    }

    record.iNaturalistId = observationId;
    record.iNaturalistSyncedAt = DateTime.now();
    await _plantRepository.save(record);

    return observationId;
  }

  Future<void> uploadPhoto(String observationId, String photoPath) async {
    final settings = await _requireSettings();
    final file = File(photoPath);

    if (!file.existsSync()) {
      throw InaturalistException('Photo not found: $photoPath');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/observation_photos'),
    )..headers.addAll(_authHeaders(settings));

    request.fields['observation_id'] = observationId;
    request.files.add(await http.MultipartFile.fromPath('file', photoPath));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw InaturalistException(_extractErrorMessage(body));
    }
  }

  Future<List<String>> bulkPush(
    List<PlantRecord> records, {
    void Function(int completed, int total)? onProgress,
  }) async {
    final total = records.length;
    final observationIds = <String>[];

    for (var index = 0; index < records.length; index++) {
      final record = records[index];

      try {
        if (record.iNaturalistId?.isNotEmpty ?? false) {
          observationIds.add(record.iNaturalistId!);
        } else {
          final observationId = await createObservation(record);
          if (observationId != null && observationId.isNotEmpty) {
            observationIds.add(observationId);
          }
        }
      } finally {
        onProgress?.call(index + 1, total);
      }
    }

    return observationIds;
  }

  Future<bool> hasToken() async {
    final settings = await _loadSettings();
    return settings.inatAccessToken?.trim().isNotEmpty ?? false;
  }

  Future<Settings> _requireSettings() async {
    final settings = await _loadSettings();
    if (settings.inatAccessToken?.trim().isEmpty ?? true) {
      throw const InaturalistException(
        'iNaturalist access token not configured.',
      );
    }
    return settings;
  }

  Map<String, String> _authHeaders(Settings settings) {
    final token = settings.inatAccessToken!.trim();
    return {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: token,
    };
  }

  String _formatObservedOn(DateTime date) => date.toIso8601String().split('T').first;

  String _buildDescription(PlantRecord record) {
    final buffer = StringBuffer();

    if (record.notes?.trim().isNotEmpty ?? false) {
      buffer.writeln(record.notes!.trim());
    }

    final localityParts = [
      record.locality,
      record.municipality,
      record.state,
      record.country,
    ].where((part) => part?.trim().isNotEmpty ?? false).map((part) => part!.trim()).toList();

    if (localityParts.isNotEmpty) {
      if (buffer.isNotEmpty) buffer.writeln();
      buffer.write(localityParts.join(', '));
    }

    return buffer.toString().trim();
  }

  String? _extractObservationId(String body) {
    if (body.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        final id = decoded['id'] ??
            decoded['observation_id'] ??
            (decoded['results'] is List && decoded['results'].isNotEmpty
                ? (decoded['results'].first as Map<String, dynamic>)['id']
                : null);
        return id?.toString();
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  String _extractErrorMessage(String body) {
    if (body.trim().isEmpty) {
      return 'iNaturalist request failed.';
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        for (final key in ['error', 'errors', 'message']) {
          final value = decoded[key];
          if (value is String && value.trim().isNotEmpty) {
            return value.trim();
          }
          if (value is List && value.isNotEmpty) {
            return value.join(', ');
          }
          if (value is Map<String, dynamic> && value.isNotEmpty) {
            return value.values.join(', ');
          }
        }
      }
    } catch (_) {
      // Fall through to raw body.
    }

    return body;
  }
}
