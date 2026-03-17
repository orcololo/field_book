import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import '../../../core/services/map_service.dart';

class OfflineMapsScreen extends StatefulWidget {
  const OfflineMapsScreen({super.key});

  @override
  State<OfflineMapsScreen> createState() => _OfflineMapsScreenState();
}

class _OfflineMapsScreenState extends State<OfflineMapsScreen> {
  final MapController _mapController = MapController();
  bool _isLoading = true;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _downloadingRegionName;
  int _cachedTiles = 0;
  int _cacheSize = 0;

  // Download area bounds
  LatLng? _northEast;
  LatLng? _southWest;
  bool _isSelectingArea = false;

  @override
  void initState() {
    super.initState();
    _loadCacheStats();
  }

  Future<void> _loadCacheStats() async {
    setState(() => _isLoading = true);
    
    try {
      await MapService.initialize();
      final stats = await MapService.getCacheStats();
      
      setState(() {
        _cachedTiles = stats['tileCount'] as int;
        _cacheSize = stats['size'] as int;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _startAreaSelection() {
    setState(() {
      _isSelectingArea = true;
      _northEast = null;
      _southWest = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Toque no mapa para definir a área de download'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _handleMapTap(TapPosition tapPosition, LatLng position) {
    if (!_isSelectingArea) return;

    setState(() {
      if (_northEast == null) {
        _northEast = position;
      } else if (_southWest == null) {
        _southWest = position;
        _isSelectingArea = false;
        _showDownloadDialog();
      }
    });
  }

  void _showDownloadDialog() {
    if (_northEast == null || _southWest == null) return;

    final TextEditingController nameController = TextEditingController(
      text: 'Região ${DateTime.now().day}/${DateTime.now().month}',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Baixar Área Offline'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da área',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Zoom levels: 8-15',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Isso pode demorar alguns minutos e consumir dados móveis.',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _northEast = null;
                _southWest = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startDownload(nameController.text);
            },
            child: const Text('Baixar'),
          ),
        ],
      ),
    );
  }

  Future<void> _startDownload(String regionName) async {
    if (_northEast == null || _southWest == null) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _downloadingRegionName = regionName;
    });

    try {
      final store = fmtc.FMTCStore('mapTileCache');
      
      final bounds = LatLngBounds(_southWest!, _northEast!);
      final region = fmtc.RectangleRegion(bounds);

      final downloadable = region.toDownloadable(
        minZoom: 8,
        maxZoom: 15,
        options: TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
      );

      await for (final progress in store.download.startForeground(
        region: downloadable,
      )) {
        setState(() {
          _downloadProgress = progress.percentageProgress / 100;
        });
      }

      await _loadCacheStats();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Download concluído!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao baixar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
        _downloadingRegionName = null;
        _northEast = null;
        _southWest = null;
      });
    }
  }

  Future<void> _clearCache() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar cache'),
        content: const Text(
          'Tem certeza que deseja excluir todos os mapas offline?\n\n'
          'Isso liberará espaço mas você precisará estar online para ver os mapas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await MapService.clearCache();
        await _loadCacheStats();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cache limpo com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao limpar cache: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapas Offline'),
        actions: [
          if (!_isDownloading)
            IconButton(
              icon: const Icon(Icons.add_location),
              onPressed: _startAreaSelection,
              tooltip: 'Baixar nova área',
            ),
        ],
      ),
      body: Column(
        children: [
          // Map for area selection
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(-15.7801, -47.9292),
                    initialZoom: 4.0,
                    onTap: _handleMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.field_book',
                      tileProvider: MapService.getTileProvider(),
                    ),
                    
                    // Show selection markers
                    if (_northEast != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _northEast!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                          if (_southWest != null)
                            Marker(
                              point: _southWest!,
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                        ],
                      ),
                    
                    // Show selection rectangle
                    if (_northEast != null && _southWest != null)
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: [
                              _northEast!,
                              LatLng(_northEast!.latitude, _southWest!.longitude),
                              _southWest!,
                              LatLng(_southWest!.latitude, _northEast!.longitude),
                            ],
                            color: Colors.blue.withValues(alpha: 0.2),
                            borderColor: Colors.blue,
                            borderStrokeWidth: 2,
                            isFilled: true,
                          ),
                        ],
                      ),
                  ],
                ),
                
                // Download progress overlay
                if (_isDownloading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.7),
                    child: Center(
                      child: Card(
                        margin: const EdgeInsets.all(32),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(
                                'Baixando $_downloadingRegionName',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: _downloadProgress,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                
                // Selection instructions
                if (_isSelectingArea)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      color: Colors.blue.shade700,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          _northEast == null
                              ? '1. Toque no primeiro canto da área'
                              : '2. Toque no canto oposto da área',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Cache statistics
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cache de Mapas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                      
                      // Cache stats
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Tiles em cache:'),
                                        Text(
                                          _cachedTiles.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Espaço usado:'),
                                        Text(
                                          _formatBytes(_cacheSize),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed:
                                            _cachedTiles > 0 ? _clearCache : null,
                                        icon: const Icon(Icons.delete),
                                        label: const Text('Limpar Cache'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    
                    const SizedBox(height: 16),
                    
                    // Instructions
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Como usar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              '1. Toque em + para baixar área\n'
                              '2. Toque em dois pontos no mapa\n'
                              '3. Confirme o download\n'
                              '4. Use mapas offline no campo!',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
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
