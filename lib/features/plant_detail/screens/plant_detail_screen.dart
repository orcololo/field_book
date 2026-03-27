import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:math';
import '../../../models/plant_record.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/theme/folium_theme.dart';
import '../../../shared/widgets/map_widget.dart';
import '../../../shared/widgets/audio/audio_player_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../../plant_form/screens/plant_form_screen.dart';

class PlantDetailScreen extends ConsumerWidget {
  final PlantRecord plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlantFormScreen(plant: plant),
                ),
              );
              if (result == true && context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            tooltip: l10n.edit,
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onPressed: () => _confirmDelete(context, ref, l10n),
            tooltip: l10n.delete,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Hero image section
          SliverToBoxAdapter(child: _buildHeroSection(context)),
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(FoliumTheme.space16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildBasicInfoCard(context, l10n),
                const SizedBox(height: FoliumTheme.space16),
                if (plant.family != null ||
                    plant.genus != null ||
                    plant.species != null)
                  _buildTaxonomyCard(context, l10n),
                const SizedBox(height: FoliumTheme.space16),
                if (plant.photoPaths.isNotEmpty)
                  _buildPhotosCard(context, l10n),
                const SizedBox(height: FoliumTheme.space16),
                if (plant.audioNotePaths.isNotEmpty)
                  _buildAudioNotesCard(context, l10n),
                const SizedBox(height: FoliumTheme.space16),
                if (plant.measurements.isNotEmpty)
                  _buildMeasurementsCard(context, l10n),
                const SizedBox(height: FoliumTheme.space16),
                if (plant.latitude != null && plant.longitude != null)
                  _buildLocationCard(context, l10n),
                const SizedBox(height: FoliumTheme.space16),
                if (plant.habitat != null ||
                    plant.notes != null ||
                    plant.raiz != null ||
                    plant.caule != null ||
                    plant.cauleTipoCasca != null ||
                    plant.cauleCor != null ||
                    plant.cauleTamanho != null ||
                    plant.cauleCircunferencia != null ||
                    plant.cauleTemSeiva ||
                    plant.cauleDescricaoSeiva != null ||
                    plant.folhaDescricao != null ||
                    plant.folhaBainha != null ||
                    plant.folhaPeciolo != null ||
                    plant.folhaLamina != null ||
                    plant.florDescricao != null ||
                    plant.florInflorescencia != null ||
                    plant.florCor != null ||
                    plant.florTamanho != null ||
                    plant.frutoDescricao != null ||
                    plant.frutoCor != null ||
                    plant.frutoFormato != null ||
                    plant.frutoTamanho != null ||
                    plant.sementeDescricao != null ||
                    plant.sementeCor != null ||
                    plant.sementeFormato != null ||
                    plant.sementeTamanho != null)
                  _buildNotesCard(context, l10n),
                const SizedBox(height: FoliumTheme.space16),
                _buildRelatedPlantsCard(context, ref),
                const SizedBox(height: FoliumTheme.space16),
                _buildMetadataCard(context, l10n),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    if (plant.photoPaths.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              Theme.of(context).colorScheme.primary,
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.eco,
            size: 100,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    final firstPhoto = File(plant.photoPaths.first);
    return Hero(
      tag: 'plant_image_${plant.uuid}',
      child: Stack(
        children: [
          // Image
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(firstPhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Title overlay
          Positioned(
            bottom: FoliumTheme.space24,
            left: FoliumTheme.space16,
            right: FoliumTheme.space16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant.scientificName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
                if (plant.commonName.isNotEmpty) ...[
                  const SizedBox(height: FoliumTheme.space8),
                  Text(
                    plant.commonName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: FoliumTheme.cardDecoration(),
      padding: const EdgeInsets.all(FoliumTheme.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Identifier badge if present
          if (plant.registryIdentifier != null)
            Container(
              margin: const EdgeInsets.only(bottom: FoliumTheme.space16),
              padding: const EdgeInsets.symmetric(
                horizontal: FoliumTheme.space12,
                vertical: FoliumTheme.space8,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tag, size: 16, color: colorScheme.primary),
                  const SizedBox(width: FoliumTheme.space4),
                  Text(
                    plant.registryIdentifier!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Status chips
          Wrap(
            spacing: FoliumTheme.space8,
            runSpacing: FoliumTheme.space8,
            children: [
              _buildStatusChip(
                context,
                _getCategoryName(context, plant.category),
                colorScheme.primaryContainer,
                colorScheme.primary,
              ),
              if (plant.isDraft)
                _buildStatusChip(
                  context,
                  l10n.draft,
                  colorScheme.tertiaryContainer,
                  colorScheme.tertiary,
                ),
              if (plant.latitude != null && plant.longitude != null)
                _buildStatusChip(
                  context,
                  'GPS',
                  colorScheme.secondaryContainer,
                  colorScheme.secondary,
                  icon: Icons.location_on,
                ),
              if (plant.photoPaths.isNotEmpty)
                _buildStatusChip(
                  context,
                  '${plant.photoPaths.length}',
                  colorScheme.tertiaryContainer,
                  colorScheme.tertiary,
                  icon: Icons.photo_camera,
                ),
            ],
          ),

          // Date collected
          const SizedBox(height: FoliumTheme.space16),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: FoliumTheme.space8),
              Text(
                l10n.collectedOn(
                  '${plant.dateCollected.day}/${plant.dateCollected.month}/${plant.dateCollected.year}',
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
    BuildContext context,
    String label,
    Color backgroundColor,
    Color textColor, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FoliumTheme.space12,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: FoliumTheme.space4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxonomyCard(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: FoliumTheme.cardDecoration(),
      padding: const EdgeInsets.all(FoliumTheme.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(FoliumTheme.space8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(FoliumTheme.radiusSmall),
                ),
                child: Icon(
                  Icons.account_tree,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: FoliumTheme.space12),
              Text(
                l10n.taxonomyInfo,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: FoliumTheme.space16),
          if (plant.family != null ||
              plant.genus != null ||
              plant.species != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plant.family != null)
                  _buildHierarchyRow(
                    context,
                    Icons.folder_outlined,
                    l10n.family,
                    plant.family!,
                    0,
                  ),
                if (plant.genus != null)
                  _buildHierarchyRow(
                    context,
                    Icons.category_outlined,
                    l10n.genus,
                    plant.genus!,
                    1,
                  ),
                if (plant.species != null)
                  _buildHierarchyRow(
                    context,
                    Icons.grain,
                    l10n.species,
                    plant.species!,
                    2,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHierarchyRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    int level,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(left: level * 20.0, top: 8, bottom: 8),
      child: Row(
        children: [
          if (level > 0)
            Container(
              width: 2,
              height: 20,
              color: colorScheme.outlineVariant,
              margin: const EdgeInsets.only(right: 12),
            ),
          Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.photosInfo,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  l10n.nPhotos(plant.photoPaths.length),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Divider(),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: plant.photoPaths.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(plant.photoPaths[index]),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.imageNotFound,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          );
                        },
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

  Widget _buildAudioNotesCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.audiotrack,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.audioNotes,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${plant.audioNotePaths.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Divider(),
            ...plant.audioNotePaths.asMap().entries.map((entry) {
              final index = entry.key;
              final audioPath = entry.value;
              final transcript = index < plant.audioTranscripts.length
                  ? plant.audioTranscripts[index]
                  : '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AudioPlayerWidget(
                  audioPath: audioPath,
                  transcript: transcript.isNotEmpty ? transcript : null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.locationInfo,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Latitude'),
              subtitle: Text(plant.latitude!.toStringAsFixed(6)),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: plant.latitude!.toStringAsFixed(6)),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.copiedToClipboard)),
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Longitude'),
              subtitle: Text(plant.longitude!.toStringAsFixed(6)),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: plant.longitude!.toStringAsFixed(6)),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.copiedToClipboard)),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 200,
                child: MapWidget(
                  latitude: plant.latitude,
                  longitude: plant.longitude,
                  zoom: 15.0,
                  interactive: true,
                  showMarker: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementsCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.measurementsInfo,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  l10n.nMeasurements(plant.measurements.length),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Divider(),
            ...plant.measurements.map(
              (measurement) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.straighten, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        measurement.label,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      '${measurement.value} ${measurement.unit}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.notes, style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            if (plant.habitat != null) ...[
              Text(
                l10n.habitat,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(plant.habitat!),
              const SizedBox(height: 16),
            ],
            if (plant.notes != null) ...[
              Text(l10n.notes, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(plant.notes!),
            ],
            // Morphology fields
            if (plant.raiz != null ||
                plant.caule != null ||
                plant.cauleTipoCasca != null ||
                plant.cauleCor != null ||
                plant.cauleTamanho != null ||
                plant.cauleCircunferencia != null ||
                plant.cauleTemSeiva ||
                plant.cauleDescricaoSeiva != null ||
                plant.folhaDescricao != null ||
                plant.folhaBainha != null ||
                plant.folhaPeciolo != null ||
                plant.folhaLamina != null ||
                plant.florDescricao != null ||
                plant.florInflorescencia != null ||
                plant.florCor != null ||
                plant.florTamanho != null ||
                plant.frutoDescricao != null ||
                plant.frutoCor != null ||
                plant.frutoFormato != null ||
                plant.frutoTamanho != null ||
                plant.sementeDescricao != null ||
                plant.sementeCor != null ||
                plant.sementeFormato != null ||
                plant.sementeTamanho != null) ...[
              const SizedBox(height: 16),
              Text(
                l10n.morphology,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              if (plant.raiz != null) _buildInfoRow(l10n.root, plant.raiz!),
              if (plant.caule != null ||
                  plant.cauleTipoCasca != null ||
                  plant.cauleCor != null ||
                  plant.cauleTamanho != null ||
                  plant.cauleCircunferencia != null ||
                  plant.cauleTemSeiva ||
                  plant.cauleDescricaoSeiva != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.stem,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (plant.caule != null)
                  _buildInfoRow(l10n.descriptionLabel, plant.caule!),
                if (plant.cauleTipoCasca != null)
                  _buildInfoRow(l10n.stemBarkType, plant.cauleTipoCasca!),
                if (plant.cauleCor != null)
                  _buildInfoRow(l10n.colorLabel, plant.cauleCor!),
                if (plant.cauleTamanho != null)
                  _buildInfoRow(
                    l10n.sizeLabel,
                    '${plant.cauleTamanho} ${plant.cauleTamanhoUnidade ?? 'cm'}',
                  ),
                if (plant.cauleCircunferencia != null)
                  _buildInfoRow(
                    l10n.circumference,
                    '${plant.cauleCircunferencia} ${plant.cauleCircunferenciaUnidade ?? 'cm'}',
                  ),
                if (plant.cauleTemSeiva)
                  _buildInfoRow(l10n.sapPresence, l10n.yes),
                if (plant.cauleDescricaoSeiva != null)
                  _buildInfoRow(
                    l10n.sapDescription,
                    plant.cauleDescricaoSeiva!,
                  ),
              ],
              if (plant.folhaDescricao != null ||
                  plant.folhaBainha != null ||
                  plant.folhaPeciolo != null ||
                  plant.folhaLamina != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.leaf,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (plant.folhaDescricao != null)
                  _buildInfoRow(l10n.descriptionLabel, plant.folhaDescricao!),
                if (plant.folhaBainha != null)
                  _buildInfoRow(l10n.sheathLabel, plant.folhaBainha!),
                if (plant.folhaPeciolo != null)
                  _buildInfoRow(l10n.petioleLabel, plant.folhaPeciolo!),
                if (plant.folhaLamina != null)
                  _buildInfoRow(l10n.bladeLabel, plant.folhaLamina!),
              ],
              if (plant.florDescricao != null ||
                  plant.florInflorescencia != null ||
                  plant.florCor != null ||
                  plant.florTamanho != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.flower,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (plant.florDescricao != null)
                  _buildInfoRow(l10n.descriptionLabel, plant.florDescricao!),
                if (plant.florInflorescencia != null)
                  _buildInfoRow(
                    l10n.inflorescenceLabel,
                    plant.florInflorescencia!,
                  ),
                if (plant.florCor != null)
                  _buildInfoRow(l10n.colorLabel, plant.florCor!),
                if (plant.florTamanho != null)
                  _buildInfoRow(
                    l10n.sizeLabel,
                    '${plant.florTamanho} ${plant.florTamanhoUnidade ?? 'cm'}',
                  ),
              ],
              if (plant.frutoDescricao != null ||
                  plant.frutoCor != null ||
                  plant.frutoFormato != null ||
                  plant.frutoTamanho != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.fruitLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (plant.frutoDescricao != null)
                  _buildInfoRow(l10n.descriptionLabel, plant.frutoDescricao!),
                if (plant.frutoCor != null)
                  _buildInfoRow(l10n.colorLabel, plant.frutoCor!),
                if (plant.frutoFormato != null)
                  _buildInfoRow(l10n.shapeLabel, plant.frutoFormato!),
                if (plant.frutoTamanho != null)
                  _buildInfoRow(
                    l10n.sizeLabel,
                    '${plant.frutoTamanho} ${plant.frutoTamanhoUnidade ?? 'cm'}',
                  ),
              ],
              if (plant.sementeDescricao != null ||
                  plant.sementeCor != null ||
                  plant.sementeFormato != null ||
                  plant.sementeTamanho != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.seedLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (plant.sementeDescricao != null)
                  _buildInfoRow(l10n.descriptionLabel, plant.sementeDescricao!),
                if (plant.sementeCor != null)
                  _buildInfoRow(l10n.colorLabel, plant.sementeCor!),
                if (plant.sementeFormato != null)
                  _buildInfoRow(l10n.shapeLabel, plant.sementeFormato!),
                if (plant.sementeTamanho != null)
                  _buildInfoRow(
                    l10n.sizeLabel,
                    '${plant.sementeTamanho} ${plant.sementeTamanhoUnidade ?? 'mm'}',
                  ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.metadata, style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            if (plant.registryIdentifier != null)
              _buildInfoRow(l10n.identifierLabel, plant.registryIdentifier!),
            _buildInfoRow(
              l10n.collectionDate,
              '${plant.dateCollected.day}/${plant.dateCollected.month}/${plant.dateCollected.year}',
            ),
            _buildInfoRow(l10n.createdAt, _formatDateTime(plant.createdAt)),
            _buildInfoRow(l10n.lastUpdated, _formatDateTime(plant.updatedAt)),
            if (plant.contributorName != null)
              _buildInfoRow(l10n.contributor, plant.contributorName!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getCategoryName(BuildContext context, dynamic category) {
    final l10n = AppLocalizations.of(context)!;
    final categoryStr = category.toString().split('.').last;
    switch (categoryStr) {
      case 'trees':
        return l10n.categoryTrees;
      case 'shrubs':
        return l10n.categoryShrubs;
      case 'herbs':
        return l10n.categoryHerbs;
      case 'ferns':
        return l10n.categoryFerns;
      case 'grasses':
        return l10n.categoryGrasses;
      case 'vines':
        return l10n.categoryVines;
      case 'cacti':
        return l10n.categoryCacti;
      case 'aquatic':
        return l10n.categoryAquatic;
      default:
        return categoryStr;
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.confirmDeletePlant),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final plantRepo = ref.read(plantRepositoryProvider);
        await plantRepo.delete(plant.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.plantDeletedName(plant.scientificName)),
            ),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorDeletingPlant(e.toString())),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Widget _buildRelatedPlantsCard(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<List<PlantRecord>>(
      future: _findRelatedPlants(ref),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final relatedPlants = snapshot.data!;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.link, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      l10n.relatedPlants,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.sameGenusOrNearbyLocation,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                ...relatedPlants.map(
                  (relatedPlant) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      child: Text(
                        relatedPlant.scientificName.isNotEmpty
                            ? relatedPlant.scientificName[0].toUpperCase()
                            : '?',
                      ),
                    ),
                    title: Text(
                      relatedPlant.scientificName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      relatedPlant.commonName.isEmpty
                          ? _formatDate(relatedPlant.dateCollected)
                          : '${relatedPlant.commonName} • ${_formatDate(relatedPlant.dateCollected)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlantDetailScreen(plant: relatedPlant),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<PlantRecord>> _findRelatedPlants(WidgetRef ref) async {
    final plantRepo = ref.read(plantRepositoryProvider);
    final allPlants = await plantRepo.getPaginated(limit: 1000);

    final related = <PlantRecord>[];

    for (final p in allPlants) {
      if (p.uuid == plant.uuid) continue;

      // Same genus
      if (plant.genus != null &&
          p.genus != null &&
          plant.genus!.toLowerCase() == p.genus!.toLowerCase()) {
        related.add(p);
        continue;
      }

      // Close location (within ~1km)
      if (plant.latitude != null &&
          plant.longitude != null &&
          p.latitude != null &&
          p.longitude != null) {
        final distance = _calculateDistance(
          plant.latitude!,
          plant.longitude!,
          p.latitude!,
          p.longitude!,
        );
        if (distance < 1.0) {
          // Less than 1 km
          related.add(p);
        }
      }

      if (related.length >= 5) break; // Limit to 5 related plants
    }

    return related;
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // Simple Haversine distance calculation (approximate)
    const r = 6371; // Earth radius in km
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
