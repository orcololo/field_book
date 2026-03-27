// ignore_for_file: deprecated_member_use

import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/plant_record.dart';
import '../../models/plant_category.dart';
import '../database/isar_service.dart';
import '../utils/geo_utils.dart';

part 'plant_repository.g.dart';

@riverpod
PlantRepository plantRepository(PlantRepositoryRef ref) {
  return PlantRepository();
}

class PlantRepository {
  static final _log = Logger(printer: PrettyPrinter(methodCount: 2));
  Future<Isar> get _isar => IsarService.instance.isar;

  // Create or update plant record
  Future<void> save(PlantRecord plant) async {
    try {
      final isar = await _isar;
      plant.updatedAt = DateTime.now();
      plant.updateFtsFields();
      
      await isar.writeTxn(() async {
        await isar.plantRecords.put(plant);
      });
    } catch (e, stackTrace) {
      _log.e('Error saving plant', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Get by ID
  Future<PlantRecord?> getById(int id) async {
    try {
      final isar = await _isar;
      return await isar.plantRecords.get(id);
    } catch (e, stackTrace) {
      _log.e('Error getting plant by ID', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Get by UUID
  Future<PlantRecord?> getByUuid(String uuid) async {
    try {
      final isar = await _isar;
      return await isar.plantRecords.filter().uuidEqualTo(uuid).findFirst();
    } catch (e, stackTrace) {
      _log.e('Error getting plant by UUID', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Delete
  Future<void> delete(int id) async {
    try {
      final isar = await _isar;
      await isar.writeTxn(() async {
        await isar.plantRecords.delete(id);
      });
    } catch (e, stackTrace) {
      _log.e('Error deleting plant', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Get paginated plants
  Future<List<PlantRecord>> getPaginated({
    int offset = 0,
    int limit = 20,
    PlantCategory? category,
    bool? isDraft,
  }) async {
    try {
      final isar = await _isar;
    
    if (category != null && isDraft != null) {
      return await isar.plantRecords
          .filter()
          .categoryEqualTo(category)
          .and()
          .isDraftEqualTo(isDraft)
          .sortByDateCollectedDesc()
          .offset(offset)
          .limit(limit)
          .findAll();
    } else if (category != null) {
      return await isar.plantRecords
          .filter()
          .categoryEqualTo(category)
          .sortByDateCollectedDesc()
          .offset(offset)
          .limit(limit)
          .findAll();
    } else if (isDraft != null) {
      return await isar.plantRecords
          .filter()
          .isDraftEqualTo(isDraft)
          .sortByDateCollectedDesc()
          .offset(offset)
          .limit(limit)
          .findAll();
    } else {
      return await isar.plantRecords
          .where()
          .sortByDateCollectedDesc()
          .offset(offset)
          .limit(limit)
          .findAll();
    }
    } catch (e, stackTrace) {
      _log.e('Error getting paginated plants', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Full-text search
  Future<List<PlantRecord>> fullTextSearch(
    String query, {
    int offset = 0,
    int limit = 20,
  }) async {
    final isar = await _isar;
    final lowerQuery = query.toLowerCase();

    return await isar.plantRecords
        .filter()
        .scientificNameFtsContains(lowerQuery)
        .or()
        .commonNameFtsContains(lowerQuery)
        .sortByDateCollectedDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
  }

  // Search by registry identifier (exact or prefix match)
  Future<List<PlantRecord>> searchByIdentifier(
    String identifier, {
    int offset = 0,
    int limit = 20,
  }) async {
    final isar = await _isar;
    final upperIdentifier = identifier.toUpperCase().trim();

    if (upperIdentifier.isEmpty) {
      return [];
    }

    // Use indexed query for exact match first
    final exactMatch = await isar.plantRecords
        .filter()
        .registryIdentifierEqualTo(upperIdentifier)
        .findFirst();

    if (exactMatch != null) {
      return [exactMatch];
    }

    // Fallback to prefix search for partial matches
    return await isar.plantRecords
        .filter()
        .registryIdentifierStartsWith(upperIdentifier)
        .sortByRegistryIdentifier()
        .offset(offset)
        .limit(limit)
        .findAll();
  }

  // Get plants without registry identifier
  Future<List<PlantRecord>> getPlantsWithoutIdentifier({
    int offset = 0,
    int limit = 1000,
  }) async {
    final isar = await _isar;
    return await isar.plantRecords
        .filter()
        .registryIdentifierIsNull()
        .sortByDateCollectedDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
  }

  // Search by GPS radius using optimized bounding box + Haversine formula
  // OPTIMIZED: Uses indexed range queries to pre-filter candidates
  Future<List<PlantRecord>> searchByGpsRadius({
    required double latitude,
    required double longitude,
    required double radiusKm,
    int offset = 0,
    int limit = 20,
  }) async {
    final isar = await _isar;

    // Calculate bounding box for indexed pre-filtering
    final bounds = GeoUtils.calculateBoundingBox(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );

    // Use indexed queries to get candidates within bounding box
    // This dramatically reduces the number of distance calculations needed
    final candidates = await isar.plantRecords
        .filter()
        .latitudeBetween(bounds.minLat, bounds.maxLat)
        .and()
        .longitudeBetween(bounds.minLon, bounds.maxLon)
        .findAll();

    // Precise distance filtering on the reduced candidate set
    final nearby = candidates.where((plant) {
      if (plant.latitude == null || plant.longitude == null) return false;
      
      final distance = GeoUtils.calculateDistance(
        lat1: latitude,
        lon1: longitude,
        lat2: plant.latitude!,
        lon2: plant.longitude!,
      );
      
      return distance <= radiusKm;
    }).toList();

    // Sort by date collected descending
    nearby.sort((a, b) => b.dateCollected.compareTo(a.dateCollected));

    // Apply pagination
    final start = offset.clamp(0, nearby.length);
    final end = (offset + limit).clamp(0, nearby.length);
    
    return nearby.sublist(start, end);
  }

  // Search by date range
  Future<List<PlantRecord>> searchByDateRange({
    required DateTime start,
    required DateTime end,
    int offset = 0,
    int limit = 20,
  }) async {
    final isar = await _isar;
    return await isar.plantRecords
        .filter()
        .dateCollectedBetween(start, end)
        .sortByDateCollectedDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
  }

  // Get by session
  Future<List<PlantRecord>> getBySession(String sessionId) async {
    final isar = await _isar;
    return await isar.plantRecords
        .filter()
        .sessionIdEqualTo(sessionId)
        .sortByDateCollectedDesc()
        .findAll();
  }

  // Get count
  Future<int> count({PlantCategory? category, bool? isDraft}) async {
    final isar = await _isar;
    
    if (category != null && isDraft != null) {
      return await isar.plantRecords
          .filter()
          .categoryEqualTo(category)
          .and()
          .isDraftEqualTo(isDraft)
          .count();
    } else if (category != null) {
      return await isar.plantRecords
          .filter()
          .categoryEqualTo(category)
          .count();
    } else if (isDraft != null) {
      return await isar.plantRecords
          .filter()
          .isDraftEqualTo(isDraft)
          .count();
    } else {
      return await isar.plantRecords.count();
    }
  }

  // Bulk delete
  Future<void> bulkDelete(List<int> ids) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.plantRecords.deleteAll(ids);
    });
  }

  // Get multiple plants by IDs
  Future<List<PlantRecord>> getByIds(List<int> ids) async {
    final isar = await _isar;
    final results = await isar.plantRecords.getAll(ids);
    return results.whereType<PlantRecord>().toList();
  }

  // Check if registry identifier exists
  Future<bool> identifierExists(String identifier, {String? excludeUuid}) async {
    final isar = await _isar;
    
    if (excludeUuid != null) {
      // Exclude specific plant (for editing)
      final plant = await isar.plantRecords
          .filter()
          .registryIdentifierEqualTo(identifier)
          .and()
          .not()
          .uuidEqualTo(excludeUuid)
          .findFirst();
      return plant != null;
    } else {
      final plant = await isar.plantRecords
          .filter()
          .registryIdentifierEqualTo(identifier)
          .findFirst();
      return plant != null;
    }
  }

  // Find plant by registry identifier
  Future<PlantRecord?> findByIdentifier(String identifier) async {
    final isar = await _isar;
    return await isar.plantRecords
        .filter()
        .registryIdentifierEqualTo(identifier)
        .findFirst();
  }

  // Get all registry identifiers (non-null)
  Future<List<String>> getAllIdentifiers() async {
    final isar = await _isar;
    final plants = await isar.plantRecords
        .filter()
        .registryIdentifierIsNotNull()
        .findAll();
    
    return plants
        .map((p) => p.registryIdentifier!)
        .toList()
      ..sort();
  }

  // Get all unique families using Isar distinctBy + property query
  Future<List<String>> getDistinctFamilies() async {
    final isar = await _isar;
    final families = await isar.plantRecords
        .filter()
        .familyIsNotNull()
        .and()
        .familyIsNotEmpty()
        .distinctByFamily()
        .familyProperty()
        .findAll();
    
    final nonNull = families.whereType<String>().toList()..sort();
    return nonNull;
  }

  // Get all unique genera using Isar distinctBy + property query
  Future<List<String>> getDistinctGenera() async {
    final isar = await _isar;
    final genera = await isar.plantRecords
        .filter()
        .genusIsNotNull()
        .and()
        .genusIsNotEmpty()
        .distinctByGenus()
        .genusProperty()
        .findAll();
    
    final nonNull = genera.whereType<String>().toList()..sort();
    return nonNull;
  }
}
