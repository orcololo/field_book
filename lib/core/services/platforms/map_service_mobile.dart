import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import 'package:flutter_map/flutter_map.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MapService {
  static const String _storeName = 'mapTileCache';
  static bool _initialized = false;

  // Initialize the tile caching system
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${directory.path}/map_tiles');
      
      await fmtc.FMTCObjectBoxBackend().initialise(
        rootDirectory: cacheDir.path,
      );

      // Create default store if it doesn't exist
      try {
        await fmtc.FMTCStore(_storeName).manage.create();
      } catch (e) {
        // Store might already exist
      }
      
      _initialized = true;
    } catch (e) {
      // Continue even if initialization fails
      _initialized = true;
    }
  }

  // Get the tile provider with caching
  static TileProvider getTileProvider() {
    if (!_initialized) {
      // Fallback to network provider if not initialized
      return NetworkTileProvider();
    }
    
    try {
      return fmtc.FMTCStore(_storeName).getTileProvider();
    } catch (e) {
      // Fallback to network provider on error
      return NetworkTileProvider();
    }
  }

  // Get cache statistics
  static Future<Map<String, dynamic>> getCacheStats() async {
    if (!_initialized) {
      await initialize();
    }
    
    try {
      final store = fmtc.FMTCStore(_storeName);
      final stats = await store.stats.all;
      
      return {
        'tileCount': stats.length,
        'size': stats.size,
        'hits': stats.hits,
        'misses': stats.misses,
      };
    } catch (e) {
      return {
        'tileCount': 0,
        'size': 0,
        'hits': 0,
        'misses': 0,
      };
    }
  }

  // Clear cache
  static Future<void> clearCache() async {
    if (!_initialized) {
      await initialize();
    }
    
    try {
      final store = fmtc.FMTCStore(_storeName);
      await store.manage.reset();
    } catch (e) {
      // Ignore errors
    }
  }

  // Download tiles for a region (for offline use) - simplified version
  static Future<void> downloadRegion({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    required int minZoom,
    required int maxZoom,
  }) async {
    if (!_initialized) {
      await initialize();
    }
    
    // This is a placeholder - actual implementation would need
    // proper region calculation and download management
    // For now, tiles will be cached automatically as users view the map
  }
}
