import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../providers/connectivity_provider.dart';
import '../services/taxon_service.dart';

final taxonServiceProvider = Provider<TaxonService>((ref) {
  return TaxonService(api: ref.read(apiClientProvider));
});

final taxonSearchProvider = FutureProvider.family<List<TaxonSuggestion>, String>((ref, query) async {
  final normalizedQuery = query.trim();
  if (normalizedQuery.length < 2) {
    return const [];
  }

  return ref.read(taxonServiceProvider).search(normalizedQuery);
});

/// Triggers a bulk sync of the species catalog when online.
/// Call this on app startup or when connectivity is restored.
final speciesCatalogSyncProvider = FutureProvider<void>((ref) async {
  final isOnline = ref.watch(isOnlineValueProvider);
  if (!isOnline) return;

  await ref.read(taxonServiceProvider).syncSpeciesCatalog();
});
