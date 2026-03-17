import 'dart:math';

/// Geographic utilities for location-based searches
class GeoUtils {
  /// Earth's radius in kilometers
  static const double earthRadiusKm = 6371.0;

  /// Calculate bounding box for a point and radius
  /// Returns min/max latitude and longitude that encompasses the circle
  static LatLngBounds calculateBoundingBox({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) {
    // Convert radius to angular distance (radians)
    final angularDistance = radiusKm / earthRadiusKm;

    // Latitude bounds are straightforward
    final latMin = latitude - _radiansToDegrees(angularDistance);
    final latMax = latitude + _radiansToDegrees(angularDistance);

    // Longitude bounds depend on latitude (convergence at poles)
    final deltaLon = _radiansToDegrees(
      asin(sin(angularDistance) / cos(_degreesToRadians(latitude))),
    );

    final lonMin = longitude - deltaLon;
    final lonMax = longitude + deltaLon;

    return LatLngBounds(
      minLat: latMin,
      maxLat: latMax,
      minLon: lonMin,
      maxLon: lonMax,
    );
  }

  /// Calculate distance between two points using Haversine formula
  /// Returns distance in kilometers
  static double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  /// Convert degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  /// Convert radians to degrees
  static double _radiansToDegrees(double radians) {
    return radians * 180.0 / pi;
  }

  /// Check if a point is within a bounding box
  static bool isInBoundingBox({
    required double latitude,
    required double longitude,
    required LatLngBounds bounds,
  }) {
    return latitude >= bounds.minLat &&
        latitude <= bounds.maxLat &&
        longitude >= bounds.minLon &&
        longitude <= bounds.maxLon;
  }
}

/// Represents a geographic bounding box
class LatLngBounds {
  final double minLat;
  final double maxLat;
  final double minLon;
  final double maxLon;

  const LatLngBounds({
    required this.minLat,
    required this.maxLat,
    required this.minLon,
    required this.maxLon,
  });

  @override
  String toString() {
    return 'LatLngBounds(lat: [$minLat, $maxLat], lon: [$minLon, $maxLon])';
  }
}
