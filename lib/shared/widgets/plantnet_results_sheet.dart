import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/services/plantnet_service.dart';
import '../../l10n/app_localizations.dart';

class PlantNetResultsSheet extends StatelessWidget {
  final List<PlantNetResult> results;

  const PlantNetResultsSheet({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.plantNetSuggestionsTitle,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.plantNetSelectSuggestion,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: results.isEmpty
                  ? Center(child: Text(l10n.plantNetNoResults))
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: results.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final result = results[index];

                        return Material(
                          color: theme.colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Navigator.of(context).pop(result),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _ReferenceImage(imageUrl: result.imageUrl),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          result.scientificName,
                                          style: theme.textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${l10n.family}: ${result.family ?? l10n.notSpecified}',
                                          style:
                                              theme.textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme
                                                .primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            l10n.plantNetConfidence(
                                              (result.score * 100)
                                                  .toStringAsFixed(1),
                                            ),
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                                  color: theme.colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.chevron_right,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferenceImage extends StatelessWidget {
  final String? imageUrl;

  const _ReferenceImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72,
        height: 72,
        child: imageUrl == null || imageUrl!.isEmpty
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
      ),
    );
  }
}
