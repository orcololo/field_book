import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/municipality_bounding_box_cache.dart';
import '../database/isar_service.dart';

part 'coords_validation_service.g.dart';

const _nominatimUserAgent = 'Folium/1.8 (herbario field app)';

enum CoordsValidationStatus { consistent, inconsistent, skipped }

class CoordsValidationResult {
  final CoordsValidationStatus status;
  final String informedMunicipality;
  final String? detectedMunicipality;

  const CoordsValidationResult({
    required this.status,
    required this.informedMunicipality,
    this.detectedMunicipality,
  });

  bool get isInconsistent => status == CoordsValidationStatus.inconsistent;
}

class _BoundingBox {
  final double south;
  final double north;
  final double west;
  final double east;

  const _BoundingBox({
    required this.south,
    required this.north,
    required this.west,
    required this.east,
  });
}

@riverpod
CoordsValidationService coordsValidationService(CoordsValidationServiceRef ref) {
  return CoordsValidationService();
}

class CoordsValidationService {
  CoordsValidationService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<CoordsValidationResult> validateCoordinates({
    required double latitude,
    required double longitude,
    required String municipality,
  }) async {
    final informedMunicipality = municipality.trim();
    final municipalityKey = _normalizeText(informedMunicipality);

    if (municipalityKey.isEmpty) {
      return CoordsValidationResult(
        status: CoordsValidationStatus.skipped,
        informedMunicipality: informedMunicipality,
      );
    }

    final cached = await _getCachedBoundingBox(municipalityKey);
    if (cached != null && _containsPoint(cached, latitude, longitude)) {
      return CoordsValidationResult(
        status: CoordsValidationStatus.consistent,
        informedMunicipality: informedMunicipality,
        detectedMunicipality: cached.municipalityName,
      );
    }

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return CoordsValidationResult(
        status: CoordsValidationStatus.skipped,
        informedMunicipality: informedMunicipality,
      );
    }

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json',
      );
      final response = await _client.get(
        uri,
        headers: const {
          'User-Agent': _nominatimUserAgent,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return CoordsValidationResult(
          status: CoordsValidationStatus.skipped,
          informedMunicipality: informedMunicipality,
        );
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final detectedMunicipality = _extractMunicipality(
        data['address'] as Map<String, dynamic>?,
      );
      final boundingBox = _parseBoundingBox(data['boundingbox']);

      if (boundingBox != null && detectedMunicipality != null) {
        await _saveBoundingBox(detectedMunicipality, boundingBox);

        if (_normalizeText(detectedMunicipality) == municipalityKey) {
          await _saveBoundingBox(informedMunicipality, boundingBox);
          return CoordsValidationResult(
            status: CoordsValidationStatus.consistent,
            informedMunicipality: informedMunicipality,
            detectedMunicipality: detectedMunicipality,
          );
        }
      }

      return CoordsValidationResult(
        status: CoordsValidationStatus.inconsistent,
        informedMunicipality: informedMunicipality,
        detectedMunicipality: detectedMunicipality,
      );
    } catch (_) {
      return CoordsValidationResult(
        status: CoordsValidationStatus.skipped,
        informedMunicipality: informedMunicipality,
      );
    }
  }

  Future<MunicipalityBoundingBoxCache?> _getCachedBoundingBox(String municipalityKey) async {
    final isar = await IsarService.instance.isar;
    return isar.municipalityBoundingBoxCaches.getByMunicipalityKey(
      municipalityKey,
    );
  }

  Future<void> _saveBoundingBox(String municipality, _BoundingBox box) async {
    final isar = await IsarService.instance.isar;

    final cache = MunicipalityBoundingBoxCache()
      ..municipalityKey = _normalizeText(municipality)
      ..municipalityName = municipality.trim()
      ..south = box.south
      ..north = box.north
      ..west = box.west
      ..east = box.east
      ..cachedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.municipalityBoundingBoxCaches.put(cache);
    });
  }

  bool _containsPoint(
    MunicipalityBoundingBoxCache cache,
    double latitude,
    double longitude,
  ) {
    return latitude >= cache.south &&
        latitude <= cache.north &&
        longitude >= cache.west &&
        longitude <= cache.east;
  }

  _BoundingBox? _parseBoundingBox(dynamic rawBoundingBox) {
    if (rawBoundingBox is! List || rawBoundingBox.length != 4) {
      return null;
    }

    final values = rawBoundingBox
        .map((value) => double.tryParse(value.toString()))
        .toList();

    if (values.any((value) => value == null)) {
      return null;
    }

    return _BoundingBox(
      south: values[0]!,
      north: values[1]!,
      west: values[2]!,
      east: values[3]!,
    );
  }

  String? _extractMunicipality(Map<String, dynamic>? address) {
    if (address == null) {
      return null;
    }

    for (final key in [
      'city',
      'town',
      'municipality',
      'county',
      'state_district',
    ]) {
      final value = address[key]?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  String _normalizeText(String value) {
    return value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
