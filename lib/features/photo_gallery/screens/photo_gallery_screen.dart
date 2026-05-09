import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../models/plant_record.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/modern/modern_app_bar.dart';
import '../../plant_detail/screens/plant_detail_screen.dart';
import 'photo_viewer_screen.dart';

class PhotoGalleryScreen extends ConsumerStatefulWidget {
  const PhotoGalleryScreen({super.key});

  @override
  ConsumerState<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends ConsumerState<PhotoGalleryScreen> {
  String _sortBy = 'date_desc';
  String? _filterByCategory;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  List<PhotoItem> _allPhotos = [];
  List<PhotoItem> _filteredPhotos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    setState(() => _isLoading = true);

    try {
      final plantRepo = ref.read(plantRepositoryProvider);
      final plants = await plantRepo.getPaginated(limit: 10000);

      final photos = <PhotoItem>[];
      for (final plant in plants) {
        for (final photoPath in plant.photoPaths) {
          photos.add(PhotoItem(path: photoPath, plant: plant));
        }
      }

      if (!mounted) return;
      setState(() {
        _allPhotos = photos;
        _applyFiltersAndSort();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorLoadingPhotos(e.toString()),
            ),
          ),
        );
      }
    }
  }

  void _applyFiltersAndSort() {
    var filtered = List<PhotoItem>.from(_allPhotos);

    if (_filterByCategory != null) {
      filtered = filtered
          .where((p) => p.plant.category.name == _filterByCategory)
          .toList();
    }

    if (_filterStartDate != null) {
      filtered = filtered
          .where(
            (p) =>
                p.plant.dateCollected.isAfter(_filterStartDate!) ||
                p.plant.dateCollected.isAtSameMomentAs(_filterStartDate!),
          )
          .toList();
    }
    if (_filterEndDate != null) {
      filtered = filtered
          .where(
            (p) =>
                p.plant.dateCollected.isBefore(_filterEndDate!) ||
                p.plant.dateCollected.isAtSameMomentAs(_filterEndDate!),
          )
          .toList();
    }

    switch (_sortBy) {
      case 'date_desc':
        filtered.sort(
          (a, b) => b.plant.dateCollected.compareTo(a.plant.dateCollected),
        );
        break;
      case 'date_asc':
        filtered.sort(
          (a, b) => a.plant.dateCollected.compareTo(b.plant.dateCollected),
        );
        break;
      case 'plant_name':
        filtered.sort(
          (a, b) => a.plant.scientificName.compareTo(b.plant.scientificName),
        );
        break;
    }

    setState(() => _filteredPhotos = filtered);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ModernAppBar(
        title: l10n.photoGallery,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
                _applyFiltersAndSort();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'date_desc', child: Text(l10n.sortDateDesc)),
              PopupMenuItem(value: 'date_asc', child: Text(l10n.sortDateAsc)),
              PopupMenuItem(
                value: 'plant_name',
                child: Text(l10n.sortByPlantName),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 64,
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPhotos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noPhotosFound,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      if (_filterByCategory != null ||
                          _filterStartDate != null ||
                          _filterEndDate != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: colorScheme.tertiaryContainer,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.activeFilters(_getActiveFiltersText(context)),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onTertiaryContainer,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _filterByCategory = null;
                                    _filterStartDate = null;
                                    _filterEndDate = null;
                                    _applyFiltersAndSort();
                                  });
                                },
                                child: Text(l10n.clearFilters),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(4),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                          itemCount: _filteredPhotos.length,
                          itemBuilder: (context, index) =>
                              _buildPhotoTile(_filteredPhotos[index], index),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoTile(PhotoItem photoItem, int index) {
    final file = File(photoItem.path);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PhotoViewerScreen(photos: _filteredPhotos, initialIndex: index),
          ),
        );
      },
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailScreen(plant: photoItem.plant),
          ),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          file.existsSync()
              ? Image.file(file, fit: BoxFit.cover)
              : Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Text(
                photoItem.plant.scientificName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getActiveFiltersText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = <String>[];
    if (_filterByCategory != null) filters.add(l10n.category);
    if (_filterStartDate != null || _filterEndDate != null) {
      filters.add(l10n.dateFilter);
    }
    return filters.join(', ');
  }

  void _showFilterDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.filters),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.category,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String?>(
                  value: _filterByCategory,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.allCategories),
                    ),
                    DropdownMenuItem(
                      value: 'tree',
                      child: Text(l10n.categoryTrees),
                    ),
                    DropdownMenuItem(
                      value: 'shrub',
                      child: Text(l10n.categoryShrubs),
                    ),
                    DropdownMenuItem(
                      value: 'herb',
                      child: Text(l10n.categoryHerbs),
                    ),
                    DropdownMenuItem(
                      value: 'vine',
                      child: Text(l10n.categoryVines),
                    ),
                    DropdownMenuItem(
                      value: 'fern',
                      child: Text(l10n.categoryFerns),
                    ),
                    DropdownMenuItem(
                      value: 'aquatic',
                      child: Text(l10n.categoryAquatic),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _filterByCategory = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                _applyFiltersAndSort();
                Navigator.pop(context);
              },
              child: Text(l10n.apply),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoItem {
  final String path;
  final PlantRecord plant;

  PhotoItem({required this.path, required this.plant});
}
