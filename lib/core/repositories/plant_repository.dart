// ignore_for_file: deprecated_member_use

import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/determination.dart';
import '../../models/plant_record.dart';
import '../../models/plant_category.dart';
import '../../models/sync_metadata.dart';
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

      // Mark as pending so the next sync cycle pushes this change
      if (plant.syncMetadata.syncStatus == SyncStatus.synced) {
        plant.syncMetadata
          ..syncStatus = SyncStatus.pending
          ..localModifiedAt = DateTime.now();
      }

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
      _log.e(
        'Error getting paginated plants',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Get plants modified after a given timestamp (for incremental backup)
  Future<List<PlantRecord>> getModifiedAfter(DateTime since) async {
    try {
      final isar = await _isar;
      return await isar.plantRecords
          .filter()
          .updatedAtGreaterThan(since)
          .sortByUpdatedAtDesc()
          .findAll();
    } catch (e, stackTrace) {
      _log.e(
        'Error getting plants modified after $since',
        error: e,
        stackTrace: stackTrace,
      );
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
      return await isar.plantRecords.filter().categoryEqualTo(category).count();
    } else if (isDraft != null) {
      return await isar.plantRecords.filter().isDraftEqualTo(isDraft).count();
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
  Future<bool> identifierExists(
    String identifier, {
    String? excludeUuid,
  }) async {
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

  Future<List<PlantRecord>> searchByCollectorNumber(
    String collectorNumber, {
    int limit = 20,
  }) async {
    final isar = await _isar;
    final query = collectorNumber.trim();

    if (query.isEmpty) {
      return [];
    }

    return await isar.plantRecords
        .filter()
        .collectorNumberStartsWith(query, caseSensitive: false)
        .sortByDateCollectedDesc()
        .limit(limit)
        .findAll();
  }

  Future<List<PlantRecord>> getByUuids(List<String> uuids) async {
    if (uuids.isEmpty) return [];

    final isar = await _isar;
    final plants = await isar.plantRecords
        .filter()
        .anyOf(uuids, (q, uuid) => q.uuidEqualTo(uuid))
        .findAll();

    final byUuid = {for (final plant in plants) plant.uuid: plant};
    return uuids.map((uuid) => byUuid[uuid]).whereType<PlantRecord>().toList();
  }

  Future<void> addDetermination(
    String plantUuid,
    Determination determination,
  ) async {
    final plant = await getByUuid(plantUuid);

    if (plant == null) {
      throw StateError('Plant not found: $plantUuid');
    }

    plant.determinations = [...plant.determinations, determination]
      ..sort((a, b) => b.determinedAt.compareTo(a.determinedAt));
    plant.applyLatestDetermination();

    await save(plant);
  }

  Future<void> markAsDuplicate({
    required String duplicateUuid,
    required String originalUuid,
  }) async {
    if (duplicateUuid == originalUuid) {
      throw ArgumentError('A plant cannot be a duplicate of itself');
    }

    final isar = await _isar;
    final duplicate = await getByUuid(duplicateUuid);
    final selectedOriginal = await getByUuid(originalUuid);

    if (duplicate == null || selectedOriginal == null) {
      throw StateError('Plant not found for duplicate linking');
    }

    final rootOriginal = selectedOriginal.duplicateOf != null
        ? await getByUuid(selectedOriginal.duplicateOf!) ?? selectedOriginal
        : selectedOriginal;

    final previousOriginalUuid = duplicate.duplicateOf;
    duplicate.duplicateOf = rootOriginal.uuid;

    rootOriginal.duplicateUuids = {
      ...rootOriginal.duplicateUuids,
      duplicate.uuid,
    }.toList();

    await isar.writeTxn(() async {
      if (previousOriginalUuid != null &&
          previousOriginalUuid != rootOriginal.uuid) {
        final previousOriginal = await isar.plantRecords
            .filter()
            .uuidEqualTo(previousOriginalUuid)
            .findFirst();
        if (previousOriginal != null) {
          previousOriginal.duplicateUuids = previousOriginal.duplicateUuids
              .where((uuid) => uuid != duplicate.uuid)
              .toList();
          previousOriginal.updatedAt = DateTime.now();
          if (previousOriginal.syncMetadata.syncStatus == SyncStatus.synced) {
            previousOriginal.syncMetadata
              ..syncStatus = SyncStatus.pending
              ..localModifiedAt = DateTime.now();
          }
          await isar.plantRecords.put(previousOriginal);
        }
      }

      duplicate.updatedAt = DateTime.now();
      rootOriginal.updatedAt = DateTime.now();
      if (duplicate.syncMetadata.syncStatus == SyncStatus.synced) {
        duplicate.syncMetadata
          ..syncStatus = SyncStatus.pending
          ..localModifiedAt = DateTime.now();
      }
      if (rootOriginal.syncMetadata.syncStatus == SyncStatus.synced) {
        rootOriginal.syncMetadata
          ..syncStatus = SyncStatus.pending
          ..localModifiedAt = DateTime.now();
      }

      await isar.plantRecords.put(duplicate);
      await isar.plantRecords.put(rootOriginal);
    });
  }

  Future<List<PlantRecord>> getDuplicateSeries(String plantUuid) async {
    final plant = await getByUuid(plantUuid);
    if (plant == null) return [];

    final root = plant.duplicateOf != null
        ? await getByUuid(plant.duplicateOf!)
        : plant;
    if (root == null) return [];

    final linkedUuids = <String>{root.uuid, ...root.duplicateUuids};
    final linkedPlants = await getByUuids(linkedUuids.toList());
    linkedPlants.sort((a, b) {
      final aId = a.registryIdentifier ?? a.collectorNumber ?? a.scientificName;
      final bId = b.registryIdentifier ?? b.collectorNumber ?? b.scientificName;
      return aId.compareTo(bId);
    });
    return linkedPlants;
  }

  // Get all registry identifiers (non-null)
  Future<List<String>> getAllIdentifiers() async {
    final isar = await _isar;
    final plants = await isar.plantRecords
        .filter()
        .registryIdentifierIsNotNull()
        .findAll();

    return plants.map((p) => p.registryIdentifier!).toList()..sort();
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
