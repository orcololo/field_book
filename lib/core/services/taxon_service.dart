import 'dart:convert';

import 'package:isar/isar.dart';

import '../../models/species_cache.dart';
import '../../models/taxon_cache.dart';
import '../database/isar_service.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class TaxonSuggestion {
  const TaxonSuggestion({
    required this.id,
    required this.name,
    this.author,
    this.family,
    required this.status,
    this.rank,
  });

  final String id;
  final String name;
  final String? author;
  final String? family;
  final String status;
  final String? rank;

  factory TaxonSuggestion.fromJson(Map<String, dynamic> json) {
    return TaxonSuggestion(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      author: json['author'] as String?,
      family: json['family'] as String?,
      status: json['status'] as String? ?? 'accepted',
      rank: json['rank'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'author': author,
      'family': family,
      'status': status,
      'rank': rank,
    };
  }

  String get subtitleParts {
    return [
      if ((author ?? '').isNotEmpty) author!,
      if ((family ?? '').isNotEmpty) family!,
      if ((rank ?? '').isNotEmpty) rank!,
    ].join(' • ');
  }
}

class TaxonService {
  TaxonService({required ApiClient api}) : _api = api;

  static const Duration cacheTtl = Duration(days: 7);
  static const Duration catalogRefreshInterval = Duration(days: 1);

  final ApiClient _api;

  /// Search species offline-first: queries local SpeciesCache, then falls back
  /// to API when online (and updates the cache with results).
  Future<List<TaxonSuggestion>> search(String query) async {
    final normalizedQuery = _normalizeQuery(query);
    if (normalizedQuery.length < 2) {
      return const [];
    }

    // Always try local species catalog first
    final localResults = await _searchSpeciesCatalog(normalizedQuery);
    if (localResults.isNotEmpty) {
      // Also try API in background to keep cache fresh, but return local immediately
      _refreshFromApi(query, normalizedQuery);
      return localResults;
    }

    // If no local results, try API
    try {
      final response = await _api.get<List<dynamic>>(
        ApiEndpoints.taxaSearch,
        queryParameters: {
          'q': query.trim(),
          'limit': 10,
        },
      );

      final suggestions = response
          .whereType<Map<String, dynamic>>()
          .map(TaxonSuggestion.fromJson)
          .where(
            (suggestion) => suggestion.id.isNotEmpty && suggestion.name.isNotEmpty,
          )
          .toList(growable: false);

      await _storeCache(normalizedQuery, suggestions);
      await _storeSpeciesFromSuggestions(suggestions);
      return suggestions;
    } catch (_) {
      // Fallback to query-based cache
      return _searchCache(normalizedQuery);
    }
  }

  /// Syncs the full species catalog from the backend into local SpeciesCache.
  /// Call this when online to ensure offline search works for all species.
  Future<void> syncSpeciesCatalog() async {
    try {
      final isar = await IsarService.instance.isar;

      // Check if catalog is fresh enough
      final latestEntry = await isar.speciesCaches
          .where()
          .sortBySyncedAtDesc()
          .findFirst();

      if (latestEntry != null &&
          DateTime.now().difference(latestEntry.syncedAt) < catalogRefreshInterval) {
        return; // Catalog is fresh, skip sync
      }

      // Fetch all taxa from backend
      final response = await _api.get<List<dynamic>>(
        ApiEndpoints.taxaAll,
        queryParameters: {'limit': 5000},
      );

      final species = response
          .whereType<Map<String, dynamic>>()
          .map(TaxonSuggestion.fromJson)
          .where(
            (s) => s.id.isNotEmpty && s.name.isNotEmpty,
          )
          .toList(growable: false);

      if (species.isEmpty) return;

      // Store all species in bulk
      await isar.writeTxn(() async {
        await isar.speciesCaches.clear();
        final entries = species.map((s) {
          final entry = SpeciesCache()
            ..speciesId = s.id
            ..name = s.name
            ..author = s.author
            ..family = s.family
            ..status = s.status
            ..rank = s.rank
            ..syncedAt = DateTime.now();
          return entry;
        }).toList(growable: false);
        await isar.speciesCaches.putAll(entries);
      });
    } catch (_) {
      // Sync failed silently — offline search still works with existing cache
    }
  }

  /// Searches the local species catalog by name or family.
  Future<List<TaxonSuggestion>> _searchSpeciesCatalog(
    String normalizedQuery,
  ) async {
    try {
      final isar = await IsarService.instance.isar;

      // Search by name prefix first
      final byName = await isar.speciesCaches
          .where()
          .nameStartsWith(normalizedQuery)
          .limit(10)
          .findAll();

      if (byName.isNotEmpty) {
        return byName.map(_speciesCacheToSuggestion).toList(growable: false);
      }

      // Fallback: search by family or contains match
      final allEntries = await isar.speciesCaches.where().findAll();
      final matches = allEntries
          .where((entry) => _matchesSpeciesCache(entry, normalizedQuery))
          .take(10)
          .map(_speciesCacheToSuggestion)
          .toList(growable: false);

      return matches;
    } on UnsupportedError {
      return const [];
    } catch (_) {
      return const [];
    }
  }

  /// Fire-and-forget API refresh to keep cache updated.
  Future<void> _refreshFromApi(String query, String normalizedQuery) async {
    try {
      final response = await _api.get<List<dynamic>>(
        ApiEndpoints.taxaSearch,
        queryParameters: {
          'q': query.trim(),
          'limit': 10,
        },
      );

      final suggestions = response
          .whereType<Map<String, dynamic>>()
          .map(TaxonSuggestion.fromJson)
          .where(
            (suggestion) => suggestion.id.isNotEmpty && suggestion.name.isNotEmpty,
          )
          .toList(growable: false);

      await _storeCache(normalizedQuery, suggestions);
      await _storeSpeciesFromSuggestions(suggestions);
    } catch (_) {
      // Ignore — local results already returned
    }
  }

  /// Stores individual species from search results into the catalog.
  Future<void> _storeSpeciesFromSuggestions(
    List<TaxonSuggestion> suggestions,
  ) async {
    try {
      final isar = await IsarService.instance.isar;
      await isar.writeTxn(() async {
        final entries = suggestions.map((s) {
          final entry = SpeciesCache()
            ..speciesId = s.id
            ..name = s.name
            ..author = s.author
            ..family = s.family
            ..status = s.status
            ..rank = s.rank
            ..syncedAt = DateTime.now();
          return entry;
        }).toList(growable: false);
        await isar.speciesCaches.putAll(entries);
      });
    } catch (_) {
      // Non-critical — ignore
    }
  }

  bool _matchesSpeciesCache(SpeciesCache entry, String normalizedQuery) {
    final haystack = [
      entry.name,
      entry.author ?? '',
      entry.family ?? '',
      entry.rank ?? '',
    ].join(' ').toLowerCase();
    return haystack.contains(normalizedQuery);
  }

  TaxonSuggestion _speciesCacheToSuggestion(SpeciesCache entry) {
    return TaxonSuggestion(
      id: entry.speciesId,
      name: entry.name,
      author: entry.author,
      family: entry.family,
      status: entry.status,
      rank: entry.rank,
    );
  }

  Future<List<TaxonSuggestion>> _searchCache(String normalizedQuery) async {
    try {
      final isar = await IsarService.instance.isar;
      final cacheEntries = await isar.taxonCaches.where().anyId().findAll();
      final validAfter = DateTime.now().subtract(cacheTtl);

      final exactMatch = cacheEntries
          .where(
            (entry) =>
                entry.cachedAt.isAfter(validAfter) &&
                _normalizeQuery(entry.query) == normalizedQuery,
          )
          .toList(growable: false);

      if (exactMatch.isNotEmpty) {
        return _decodeResults(exactMatch.first.results);
      }

      final suggestions = <TaxonSuggestion>[];
      final seenIds = <String>{};

      for (final entry in cacheEntries) {
        if (entry.cachedAt.isBefore(validAfter)) {
          continue;
        }

        for (final suggestion in _decodeResults(entry.results)) {
          if (_matchesQuery(suggestion, normalizedQuery) &&
              seenIds.add(suggestion.id)) {
            suggestions.add(suggestion);
          }
        }
      }

      return suggestions.take(10).toList(growable: false);
    } on UnsupportedError {
      return const [];
    } catch (_) {
      return const [];
    }
  }

  Future<void> _storeCache(
    String normalizedQuery,
    List<TaxonSuggestion> suggestions,
  ) async {
    try {
      final isar = await IsarService.instance.isar;
      final existingEntries = await isar.taxonCaches.where().anyId().findAll();
      TaxonCache? existing;
      for (final entry in existingEntries) {
        if (_normalizeQuery(entry.query) == normalizedQuery) {
          existing = entry;
          break;
        }
      }

      final cache = existing ?? TaxonCache();
      cache.uuid = normalizedQuery;
      cache.query = normalizedQuery;
      cache.results = jsonEncode(
        suggestions.map((item) => item.toJson()).toList(growable: false),
      );
      cache.cachedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.taxonCaches.put(cache);
      });
    } on UnsupportedError {
      return;
    } catch (_) {
      return;
    }
  }

  List<TaxonSuggestion> _decodeResults(String jsonString) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(TaxonSuggestion.fromJson)
        .where(
          (suggestion) => suggestion.id.isNotEmpty && suggestion.name.isNotEmpty,
        )
        .toList(growable: false);
  }

  bool _matchesQuery(TaxonSuggestion suggestion, String normalizedQuery) {
    final haystack = [
      suggestion.name,
      suggestion.author ?? '',
      suggestion.family ?? '',
      suggestion.rank ?? '',
    ]
        .join(' ')
        .toLowerCase();
    return haystack.contains(normalizedQuery);
  }

  String _normalizeQuery(String query) => query.trim().toLowerCase();
}
