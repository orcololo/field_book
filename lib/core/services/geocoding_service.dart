import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationData {
  final String? locality;
  final String? municipality;
  final String? state;
  final String? country;

  const LocationData({
    this.locality,
    this.municipality,
    this.state,
    this.country,
  });

  bool get hasAnyValue =>
      _hasText(locality) ||
      _hasText(municipality) ||
      _hasText(state) ||
      _hasText(country);

  static bool _hasText(String? value) => value != null && value.trim().isNotEmpty;
}

class GeocodingService {
  Future<LocationData?> reverseGeocode(double lat, double lon) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return null;
    }

    try {
      final placemarks = await geo.placemarkFromCoordinates(lat, lon);
      if (placemarks.isEmpty) {
        return null;
      }

      final placemark = placemarks.first;
      final data = LocationData(
        locality: _firstNotEmpty([
          placemark.subLocality,
          placemark.street,
          placemark.name,
        ]),
        municipality: _firstNotEmpty([
          placemark.locality,
          placemark.subAdministrativeArea,
        ]),
        state: _firstNotEmpty([placemark.administrativeArea]),
        country: _firstNotEmpty([placemark.country]),
      );

      return data.hasAnyValue ? data : null;
    } catch (_) {
      return null;
    }
  }

  String? _firstNotEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }
}
