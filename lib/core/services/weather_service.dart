import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import 'moon_phase_service.dart';

class WeatherData {
  final double? temperature;
  final int? humidity;
  final String? weatherCondition;
  final int? weatherCode;
  final DateTime? sunrise;
  final DateTime? sunset;
  final String moonPhase;

  const WeatherData({
    required this.moonPhase,
    this.temperature,
    this.humidity,
    this.weatherCondition,
    this.weatherCode,
    this.sunrise,
    this.sunset,
  });
}

class WeatherService {
  WeatherService({http.Client? client, MoonPhaseService? moonPhaseService})
    : _client = client ?? http.Client(),
      _moonPhaseService = moonPhaseService ?? MoonPhaseService();

  final http.Client _client;
  final MoonPhaseService _moonPhaseService;

  Future<WeatherData?> fetchWeather(
    double lat,
    double lon,
    DateTime date,
  ) async {
    final moonPhase = _moonPhaseService.getMoonPhase(date);
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return WeatherData(moonPhase: moonPhase);
    }

    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': lat.toString(),
      'longitude': lon.toString(),
      'current': 'temperature_2m,relative_humidity_2m,weathercode',
      'daily': 'sunrise,sunset',
      'forecast_days': '1',
      'timezone': 'auto',
    });

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        return WeatherData(moonPhase: moonPhase);
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>?;
      final daily = data['daily'] as Map<String, dynamic>?;

      final weatherCodeRaw = current?['weather_code'] ?? current?['weathercode'];
      final weatherCode = weatherCodeRaw is num ? weatherCodeRaw.toInt() : null;
      final sunrise = _firstString(daily?['sunrise']);
      final sunset = _firstString(daily?['sunset']);

      return WeatherData(
        moonPhase: moonPhase,
        temperature: (current?['temperature_2m'] as num?)?.toDouble(),
        humidity: (current?['relative_humidity_2m'] as num?)?.round(),
        weatherCondition: _mapWeatherCondition(weatherCode),
        weatherCode: weatherCode,
        sunrise: _parseDateTime(sunrise),
        sunset: _parseDateTime(sunset),
      );
    } catch (_) {
      return WeatherData(moonPhase: moonPhase);
    }
  }

  String? _firstString(dynamic value) {
    if (value is List && value.isNotEmpty && value.first is String) {
      return value.first as String;
    }
    return null;
  }

  DateTime? _parseDateTime(String? isoValue) {
    if (isoValue == null || isoValue.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(isoValue);
    } catch (_) {
      return null;
    }
  }

  String? _mapWeatherCondition(int? weatherCode) {
    if (weatherCode == null) {
      return null;
    }

    if (weatherCode == 0) return 'sunny';
    if (weatherCode == 1 || weatherCode == 2) return 'cloudy';
    if (weatherCode == 3 || (weatherCode >= 71 && weatherCode <= 77)) {
      return 'overcast';
    }
    if (weatherCode == 45 || weatherCode == 48) return 'foggy';
    if ((weatherCode >= 51 && weatherCode <= 67) ||
        (weatherCode >= 80 && weatherCode <= 82)) {
      return 'rainy';
    }
    if (weatherCode >= 95 && weatherCode <= 99) return 'stormy';
    if (weatherCode == 56 || weatherCode == 57 || weatherCode == 66 || weatherCode == 67) {
      return 'rainy';
    }

    return null;
  }
}
