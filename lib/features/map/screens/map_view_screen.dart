import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/plant_record.dart';
import '../../../models/plant_category.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/services/map_service.dart';
import '../../plant_detail/screens/plant_detail_screen.dart';
import 'offline_maps_screen.dart';

class MapViewScreen extends ConsumerStatefulWidget {
  const MapViewScreen({super.key});

  @override
  ConsumerState<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends ConsumerState<MapViewScreen> {
  final MapController _mapController = MapController();
  late final PlantRepository _plantRepo;
  
  List<PlantRecord> _plants = [];
  List<PlantRecord> _filteredPlants = [];
  bool _isLoading = true;
  PlantCategory? _filterCategory;
  bool _showDraftsOnly = false;
  bool _showCompletedOnly = false;

  @override
  void initState() {
    super.initState();
    _plantRepo = ref.read(plantRepositoryProvider);
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    setState(() => _isLoading = true);
    
    try {
      final plants = await _plantRepo.getPaginated(limit: 100000);
      // Filter only plants with coordinates
      final plantsWithCoords = plants.where((p) => 
        p.latitude != null && p.longitude != null
      ).toList();
      
      setState(() {
        _plants = plantsWithCoords;
        _applyFilters();
        _isLoading = false;
      });

      // Center map on plants if available
      if (_filteredPlants.isNotEmpty) {
        _centerMapOnPlants();
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    _filteredPlants = _plants.where((plant) {
      if (_filterCategory != null && plant.category != _filterCategory) {
        return false;
      }
      if (_showDraftsOnly && !plant.isDraft) {
        return false;
      }
      if (_showCompletedOnly && plant.isDraft) {
        return false;
      }
      return true;
    }).toList();
  }

  void _centerMapOnPlants() {
    if (_filteredPlants.isEmpty) return;

    double minLat = _filteredPlants.first.latitude!;
    double maxLat = _filteredPlants.first.latitude!;
    double minLng = _filteredPlants.first.longitude!;
    double maxLng = _filteredPlants.first.longitude!;

    for (final plant in _filteredPlants) {
      if (plant.latitude! < minLat) minLat = plant.latitude!;
      if (plant.latitude! > maxLat) maxLat = plant.latitude!;
      if (plant.longitude! < minLng) minLng = plant.longitude!;
      if (plant.longitude! > maxLng) maxLng = plant.longitude!;
    }

    final center = LatLng(
      (minLat + maxLat) / 2,
      (minLng + maxLng) / 2,
    );

    // Calculate appropriate zoom level
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    
    double zoom = 15.0;
    if (maxDiff > 0.1) zoom = 10.0;
    if (maxDiff > 1.0) zoom = 8.0;
    if (maxDiff > 5.0) zoom = 6.0;

    _mapController.move(center, zoom);
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _filterCategory = null;
                        _showDraftsOnly = false;
                        _showCompletedOnly = false;
                      });
                      setState(() => _applyFilters());
                    },
                    child: const Text('Limpar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Category filter
              const Text(
                'Categoria',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Todas'),
                    selected: _filterCategory == null,
                    onSelected: (selected) {
                      setModalState(() => _filterCategory = null);
                      setState(() => _applyFilters());
                    },
                  ),
                  ...PlantCategory.values.map((category) {
                    return FilterChip(
                      label: Text(_getCategoryName(category)),
                      selected: _filterCategory == category,
                      onSelected: (selected) {
                        setModalState(() {
                          _filterCategory = selected ? category : null;
                        });
                        setState(() => _applyFilters());
                      },
                    );
                  }),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Status filter
              const Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Todos'),
                    selected: !_showDraftsOnly && !_showCompletedOnly,
                    onSelected: (selected) {
                      setModalState(() {
                        _showDraftsOnly = false;
                        _showCompletedOnly = false;
                      });
                      setState(() => _applyFilters());
                    },
                  ),
                  FilterChip(
                    label: const Text('Rascunhos'),
                    selected: _showDraftsOnly,
                    onSelected: (selected) {
                      setModalState(() {
                        _showDraftsOnly = selected;
                        _showCompletedOnly = false;
                      });
                      setState(() => _applyFilters());
                    },
                  ),
                  FilterChip(
                    label: const Text('Completos'),
                    selected: _showCompletedOnly,
                    onSelected: (selected) {
                      setModalState(() {
                        _showCompletedOnly = selected;
                        _showDraftsOnly = false;
                      });
                      setState(() => _applyFilters());
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Results count
              Text(
                '${_filteredPlants.length} plantas no mapa',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryName(PlantCategory category) {
    switch (category) {
      case PlantCategory.trees:
        return 'Árvores';
      case PlantCategory.shrubs:
        return 'Arbustos';
      case PlantCategory.herbs:
        return 'Ervas';
      case PlantCategory.vines:
        return 'Trepadeiras';
      case PlantCategory.ferns:
        return 'Samambaias';
      case PlantCategory.grasses:
        return 'Gramíneas';
      case PlantCategory.cacti:
        return 'Cactos';
      case PlantCategory.aquatic:
        return 'Aquáticas';
    }
  }

  IconData _getCategoryIcon(PlantCategory category) {
    switch (category) {
      case PlantCategory.trees:
        return Icons.park;
      case PlantCategory.shrubs:
        return Icons.forest;
      case PlantCategory.herbs:
        return Icons.grass;
      case PlantCategory.vines:
        return Icons.account_tree;
      case PlantCategory.ferns:
        return Icons.eco;
      case PlantCategory.grasses:
        return Icons.waves;
      case PlantCategory.cacti:
        return Icons.filter_vintage;
      case PlantCategory.aquatic:
        return Icons.water;
    }
  }

  Color _getCategoryColor(PlantCategory category) {
    switch (category) {
      case PlantCategory.trees:
        return Colors.green.shade700;
      case PlantCategory.shrubs:
        return Colors.green;
      case PlantCategory.herbs:
        return Colors.lightGreen;
      case PlantCategory.vines:
        return Colors.brown;
      case PlantCategory.ferns:
        return Colors.teal;
      case PlantCategory.grasses:
        return Colors.lime;
      case PlantCategory.cacti:
        return Colors.orange;
      case PlantCategory.aquatic:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Plantas'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text(_filteredPlants.length.toString()),
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _showFilterSheet,
            tooltip: 'Filtros',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OfflineMapsScreen(),
                ),
              );
            },
            tooltip: 'Mapas Offline',
          ),
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: _centerMapOnPlants,
            tooltip: 'Centralizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _plants.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Nenhuma planta com localização',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: const LatLng(-15.7801, -47.9292), // Brasília
                        initialZoom: 4.0,
                        minZoom: 2.0,
                        maxZoom: 18.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.field_book',
                          tileProvider: MapService.getTileProvider(),
                        ),
                        MarkerLayer(
                          markers: _filteredPlants.map((plant) {
                            return Marker(
                              point: LatLng(plant.latitude!, plant.longitude!),
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () async {
                                  // Fetch full plant record
                                  final fullPlant = await _plantRepo.getById(plant.id);
                                  if (fullPlant != null) {
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlantDetailScreen(
                                            plant: fullPlant,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(plant.category),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _getCategoryIcon(plant.category),
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    
                    // Legend
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Legenda',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_filteredPlants.length} plantas',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
