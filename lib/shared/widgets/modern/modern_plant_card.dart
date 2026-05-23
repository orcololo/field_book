import 'package:flutter/material.dart';
import '../../../models/plant_record.dart';
import '../../../models/sync_metadata.dart';
import '../../../core/theme/folium_theme.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/geo_utils.dart';
import '../../utils/plant_category_presentation.dart';
import '../adaptive_image.dart';

/// Modern plant card with eco-design aesthetic
class ModernPlantCard extends StatelessWidget {
  final PlantRecord plant;
  final VoidCallback? onTap;
  final bool showImage;
  final bool compact;

  const ModernPlantCard({
    super.key,
    required this.plant,
    this.onTap,
    this.showImage = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }

  Widget _buildFullCard(BuildContext context) {
    final isConflict = plant.syncMetadata.syncStatus == SyncStatus.conflict;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: FoliumTheme.space16,
              vertical: FoliumTheme.space8,
            ),
            decoration: FoliumTheme.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                if (showImage && plant.photoPaths.isNotEmpty)
                  _buildImageSection(context),

                // Content section
                Padding(
                  padding: const EdgeInsets.all(FoliumTheme.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Scientific name
                      Text(
                        plant.scientificName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Common name
                      if (plant.commonName.isNotEmpty) ...[
                        const SizedBox(height: FoliumTheme.space4),
                        Text(
                          plant.commonName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      const SizedBox(height: FoliumTheme.space12),

                      // Metadata row
                      _buildMetadataRow(context),

                      // Identifier badge
                      if (plant.registryIdentifier != null) ...[
                        const SizedBox(height: FoliumTheme.space12),
                        _buildIdentifierBadge(context),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isConflict)
            Positioned(
              top: 4,
              left: FoliumTheme.space16 + 4,
              child: _buildConflictBadge(context),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    final isConflict = plant.syncMetadata.syncStatus == SyncStatus.conflict;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: FoliumTheme.space16,
          vertical: FoliumTheme.space4,
        ),
        decoration: FoliumTheme.cardDecoration(shadows: FoliumTheme.elevation1),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: FoliumTheme.space16,
            vertical: FoliumTheme.space8,
          ),
          leading: showImage && plant.photoPaths.isNotEmpty
              ? _buildCompactImage(context)
              : _buildPlaceholderIcon(context),
          title: Text(
            plant.scientificName,
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: plant.commonName.isNotEmpty
              ? Text(
                  plant.commonName,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: isConflict
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildConflictBadge(context),
                    const SizedBox(width: FoliumTheme.space8),
                    _buildCategoryIcon(context),
                  ],
                )
              : _buildCategoryIcon(context),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(FoliumTheme.radiusMedium),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            AdaptiveImage(
              path: plant.photoPaths.first,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder(context);
              },
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: FoliumTheme.imageOverlayGradient(),
              ),
            ),

            // Category badge
            Positioned(
              top: FoliumTheme.space12,
              right: FoliumTheme.space12,
              child: _buildCategoryBadge(context),
            ),

            // Date badge
            Positioned(
              bottom: FoliumTheme.space12,
              left: FoliumTheme.space12,
              child: _buildDateBadge(context),
            ),

            // Photo count badge
            if (plant.photoPaths.length > 1)
              Positioned(
                bottom: FoliumTheme.space12,
                right: FoliumTheme.space12,
                child: _buildPhotoCountBadge(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.primaryContainer,
      child: Icon(Icons.eco, size: 64, color: colorScheme.primary),
    );
  }

  Widget _buildCompactImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
      child: SizedBox(
        width: 56,
        height: 56,
        child: AdaptiveImage(
          path: plant.photoPaths.first,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: colorScheme.primaryContainer,
              child: Icon(Icons.eco, color: colorScheme.primary),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
      ),
      child: Icon(Icons.eco, color: colorScheme.primary),
    );
  }

  Widget _buildMetadataRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        // Category icon
        Icon(_getCategoryIcon(), size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: FoliumTheme.space4),
        Flexible(
          child: Text(
            _getCategoryLabel(context),
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Photo count indicator (when image section not shown)
        if (plant.photoPaths.isNotEmpty) ...[
          const SizedBox(width: FoliumTheme.space8),
          Icon(Icons.camera_alt, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 2),
          Text(
            '${plant.photoPaths.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const Spacer(),
        // Location icon
        if (plant.latitude != null && plant.longitude != null) ...[
          Icon(Icons.location_on, size: 16, color: colorScheme.tertiary),
          const SizedBox(width: FoliumTheme.space4),
          Flexible(
            child: Text(
              GeoUtils.formatCoordinatesDMS(plant.latitude!, plant.longitude!),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.tertiary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: FoliumTheme.space8),
        ],
        if (plant.iNaturalistId?.isNotEmpty ?? false) ...[
          Icon(Icons.outbox_outlined, size: 16, color: colorScheme.primary),
          const SizedBox(width: FoliumTheme.space4),
          Flexible(
            child: Text(
              l10n.inaturalistSyncBadge,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FoliumTheme.space12,
        vertical: FoliumTheme.space4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
        boxShadow: FoliumTheme.elevation1,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getCategoryIcon(), size: 14, color: colorScheme.primary),
          const SizedBox(width: FoliumTheme.space4),
          Text(
            _getCategoryLabel(context),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBadge(BuildContext context) {
    final dateStr = DateFormat(
      'dd MMM yyyy',
      'pt_BR',
    ).format(plant.dateCollected);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FoliumTheme.space12,
        vertical: FoliumTheme.space4,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, size: 12, color: Colors.white),
          const SizedBox(width: FoliumTheme.space4),
          Text(
            dateStr,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCountBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FoliumTheme.space8,
        vertical: FoliumTheme.space4,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.camera_alt, size: 12, color: Colors.white),
          const SizedBox(width: FoliumTheme.space4),
          Text(
            '${plant.photoPaths.length}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentifierBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FoliumTheme.space12,
        vertical: FoliumTheme.space4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.tag, size: 14, color: colorScheme.secondary),
          const SizedBox(width: FoliumTheme.space4),
          Text(
            plant.registryIdentifier!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConflictBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FoliumTheme.space8,
        vertical: FoliumTheme.space4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sync_problem_outlined,
            size: 12,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: FoliumTheme.space4),
          Text(
            'Conflito',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(FoliumTheme.space8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
      ),
      child: Icon(_getCategoryIcon(), size: 20, color: colorScheme.primary),
    );
  }

  IconData _getCategoryIcon() {
    return plant.category.icon;
  }

  String _getCategoryLabel(BuildContext context) {
    return plant.category.localizedLabel(AppLocalizations.of(context)!);
  }
}
