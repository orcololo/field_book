import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import '../../../core/services/map_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/modern/modern_app_bar.dart';

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

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.tapMapToDefineArea),
        duration: const Duration(seconds: 3),
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

    final now = DateTime.now();
    final TextEditingController nameController = TextEditingController(
      text: AppLocalizations.of(context)!.offlineRegionName(
        '${now.day}/${now.month}',
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
        title: Text(l10n.downloadOfflineAreaTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.areaNameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.zoomLevelsLabel,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.downloadWarnMsg,
              style: const TextStyle(fontSize: 12, color: Colors.orange),
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
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startDownload(nameController.text);
            },
            child: Text(l10n.download),
          ),
        ],
      );
      },
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.downloadCompletedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorDownloadMapMsg(e.toString())),
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
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
        title: Text(l10n.clearCacheTitle),
        content: Text(l10n.clearCacheBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.clearCacheConfirmBtn),
          ),
        ],
      );
      },
    );

    if (confirm == true) {
      try {
        await MapService.clearCache();
        await _loadCacheStats();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.cacheClearedSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.errorClearCacheMsg(e.toString())),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: ModernAppBar(
        title: l10n.offlineMapsTitle,
        showBackButton: true,
        actions: [
          if (!_isDownloading)
            IconButton(
              icon: const Icon(Icons.add_location),
              onPressed: _startAreaSelection,
              tooltip: l10n.downloadNewAreaTooltip,
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
                                l10n.downloadingRegion(_downloadingRegionName ?? ''),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
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
                              ? l10n.selectFirstAreaCorner
                              : l10n.selectOppositeAreaCorner,
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
                    Text(
                      l10n.mapCacheTitle,
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
                                         Text(l10n.cachedTilesLabel),
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
                                         Text(l10n.usedSpaceLabel),
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
                                        label: Text(l10n.clearCacheLabel),
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.howToUseLabel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.offlineMapsHowToUse,
                              style: const TextStyle(fontSize: 12),
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
