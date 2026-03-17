import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../models/plant_record.dart';
import '../../../core/repositories/plant_repository.dart';
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
          photos.add(PhotoItem(
            path: photoPath,
            plant: plant,
          ));
        }
      }
      
      setState(() {
        _allPhotos = photos;
        _applyFiltersAndSort();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar fotos: $e')),
        );
      }
    }
  }

  void _applyFiltersAndSort() {
    var filtered = List<PhotoItem>.from(_allPhotos);
    
    if (_filterByCategory != null) {
      filtered = filtered.where((p) => p.plant.category.name == _filterByCategory).toList();
    }
    
    if (_filterStartDate != null) {
      filtered = filtered.where((p) => 
        p.plant.dateCollected.isAfter(_filterStartDate!) ||
        p.plant.dateCollected.isAtSameMomentAs(_filterStartDate!)
      ).toList();
    }
    if (_filterEndDate != null) {
      filtered = filtered.where((p) => 
        p.plant.dateCollected.isBefore(_filterEndDate!) ||
        p.plant.dateCollected.isAtSameMomentAs(_filterEndDate!)
      ).toList();
    }
    
    switch (_sortBy) {
      case 'date_desc':
        filtered.sort((a, b) => b.plant.dateCollected.compareTo(a.plant.dateCollected));
        break;
      case 'date_asc':
        filtered.sort((a, b) => a.plant.dateCollected.compareTo(b.plant.dateCollected));
        break;
      case 'plant_name':
        filtered.sort((a, b) => a.plant.scientificName.compareTo(b.plant.scientificName));
        break;
    }
    
    setState(() => _filteredPhotos = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria de Fotos'),
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
              const PopupMenuItem(value: 'date_desc', child: Text('Data (Mais recente)')),
              const PopupMenuItem(value: 'date_asc', child: Text('Data (Mais antiga)')),
              const PopupMenuItem(value: 'plant_name', child: Text('Nome da planta')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredPhotos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('Nenhuma foto encontrada',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (_filterByCategory != null || _filterStartDate != null || _filterEndDate != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.blue.shade50,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Filtros ativos: ${_getActiveFiltersText()}',
                                  style: TextStyle(fontSize: 12, color: Colors.blue.shade700)),
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
                              child: const Text('Limpar'),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(4),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: _filteredPhotos.length,
                        itemBuilder: (context, index) => _buildPhotoTile(_filteredPhotos[index], index),
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
            builder: (context) => PhotoViewerScreen(photos: _filteredPhotos, initialIndex: index),
          ),
        );
      },
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlantDetailScreen(plant: photoItem.plant)),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          file.existsSync()
              ? Image.file(file, fit: BoxFit.cover)
              : Container(color: Colors.grey.shade300, child: const Icon(Icons.broken_image)),
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
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                ),
              ),
              child: Text(
                photoItem.plant.scientificName,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getActiveFiltersText() {
    final filters = <String>[];
    if (_filterByCategory != null) filters.add('Categoria');
    if (_filterStartDate != null || _filterEndDate != null) filters.add('Data');
    return filters.join(', ');
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filtros'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Categoria', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String?>(
                  value: _filterByCategory,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Todas')),
                    DropdownMenuItem(value: 'tree', child: Text('Árvore')),
                    DropdownMenuItem(value: 'shrub', child: Text('Arbusto')),
                    DropdownMenuItem(value: 'herb', child: Text('Herbácea')),
                    DropdownMenuItem(value: 'vine', child: Text('Trepadeira')),
                    DropdownMenuItem(value: 'fern', child: Text('Samambaia')),
                    DropdownMenuItem(value: 'moss', child: Text('Musgo')),
                    DropdownMenuItem(value: 'aquatic', child: Text('Aquática')),
                  ],
                  onChanged: (value) => setState(() => _filterByCategory = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                _applyFiltersAndSort();
                Navigator.pop(context);
              },
              child: const Text('Aplicar'),
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
