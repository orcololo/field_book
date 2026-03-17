// ignore_for_file: deprecated_member_use

import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/saved_search.dart';
import '../database/isar_service.dart';

part 'saved_search_repository.g.dart';

@riverpod
SavedSearchRepository savedSearchRepository(SavedSearchRepositoryRef ref) {
  return SavedSearchRepository();
}

class SavedSearchRepository {
  Future<Isar> get _isar => IsarService.instance.isar;

  // Create or update saved search
  Future<void> save(SavedSearch search) async {
    final isar = await _isar;
    
    await isar.writeTxn(() async {
      await isar.savedSearchs.put(search);
    });
  }

  // Get by ID
  Future<SavedSearch?> getById(int id) async {
    final isar = await _isar;
    return await isar.savedSearchs.get(id);
  }

  // Get by UUID
  Future<SavedSearch?> getByUuid(String uuid) async {
    final isar = await _isar;
    return await isar.savedSearchs.filter().uuidEqualTo(uuid).findFirst();
  }

  // Delete
  Future<void> delete(int id) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.savedSearchs.delete(id);
    });
  }

  // Get all saved searches
  Future<List<SavedSearch>> getAll() async {
    final isar = await _isar;
    return await isar.savedSearchs.where().sortByCreatedAtDesc().findAll();
  }

  // Search by name
  Future<List<SavedSearch>> searchByName(String query) async {
    final isar = await _isar;
    final lowerQuery = query.toLowerCase();
    
    return await isar.savedSearchs
        .filter()
        .nameContains(lowerQuery, caseSensitive: false)
        .sortByCreatedAtDesc()
        .findAll();
  }

  // Count
  Future<int> count() async {
    final isar = await _isar;
    return await isar.savedSearchs.count();
  }
}
