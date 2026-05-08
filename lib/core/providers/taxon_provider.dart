import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
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
