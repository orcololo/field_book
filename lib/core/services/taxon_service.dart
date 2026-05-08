import 'dart:convert';

import 'package:isar/isar.dart';

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

  final ApiClient _api;

  Future<List<TaxonSuggestion>> search(String query) async {
    final normalizedQuery = _normalizeQuery(query);
    if (normalizedQuery.length < 2) {
      return const [];
    }

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
      return suggestions;
    } catch (_) {
      return _searchCache(normalizedQuery);
    }
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
