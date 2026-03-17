import 'package:flutter_map/flutter_map.dart';

class MapService {
  // Initialize the tile caching system (no-op on web)
  static Future<void> initialize() async {
    // No-op on web
  }

  // Get the tile provider with caching (always network on web)
  static TileProvider getTileProvider() {
    return NetworkTileProvider();
  }

  // Get cache statistics (always zero on web)
  static Future<Map<String, dynamic>> getCacheStats() async {
    return {
      'tileCount': 0,
      'size': 0,
      'hits': 0,
      'misses': 0,
    };
  }

  // Clear cache (no-op on web)
  static Future<void> clearCache() async {
    // No-op on web
  }

  // Download tiles for a region (no-op on web)
  static Future<void> downloadRegion({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    required int minZoom,
    required int maxZoom,
  }) async {
    // No-op on web - tiles are cached by browser
  }
}
