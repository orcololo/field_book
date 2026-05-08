import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/settings.dart';
import 'settings_service.dart';

part 'plantnet_service.g.dart';

class PlantNetException implements Exception {
  final String code;
  final String? details;

  const PlantNetException(this.code, [this.details]);

  @override
  String toString() => details == null || details!.isEmpty ? code : details!;
}

class PlantNetResult {
  final String scientificName;
  final String? family;
  final double score;
  final String? imageUrl;

  const PlantNetResult({
    required this.scientificName,
    required this.score,
    this.family,
    this.imageUrl,
  });
}

@riverpod
PlantNetService plantNetService(PlantNetServiceRef ref) {
  return PlantNetService(
    loadSettings: () => ref.read(settingsNotifierProvider.future),
  );
}

class PlantNetService {
  final Future<Settings> Function() loadSettings;
  final Connectivity _connectivity;

  PlantNetService({
    required this.loadSettings,
    Connectivity? connectivity,
  }) : _connectivity = connectivity ?? Connectivity();

  Future<List<PlantNetResult>> identify(
    List<String> imagePaths, {
    String? organ,
  }) async {
    final settings = await loadSettings();
    final apiKey = settings.plantnetApiKey.trim();

    if (apiKey.isEmpty) {
      throw const PlantNetException('missingApiKey');
    }

    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw const PlantNetException('noInternetConnection');
    }

    final validImagePaths = imagePaths
        .where((path) => path.trim().isNotEmpty)
        .where((path) => File(path).existsSync())
        .toList();

    if (validImagePaths.isEmpty) {
      return const [];
    }

    final uri = Uri.parse(
      'https://my-api.plantnet.org/v2/identify/all',
    ).replace(queryParameters: {'api-key': apiKey, 'lang': 'pt'});

    final request = http.MultipartRequest('POST', uri);

    for (final imagePath in validImagePaths) {
      request.files.add(
        await http.MultipartFile.fromPath('images[]', imagePath),
      );

      if (organ != null && organ.trim().isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromString('organs[]', organ.trim()),
        );
      }
    }

    http.StreamedResponse response;
    try {
      response = await request.send();
    } on SocketException catch (error) {
      throw PlantNetException('noInternetConnection', error.message);
    } catch (error) {
      throw PlantNetException('requestFailed', error.toString());
    }

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw PlantNetException('requestFailed', responseBody);
    }

    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is! Map<String, dynamic>) {
        throw const PlantNetException('invalidResponse');
      }

      final rawResults = decoded['results'];
      if (rawResults is! List) {
        return const [];
      }

      final results = rawResults
          .map((item) => _parseResult(item))
          .whereType<PlantNetResult>()
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      return results;
    } on PlantNetException {
      rethrow;
    } catch (error) {
      throw PlantNetException('invalidResponse', error.toString());
    }
  }

  PlantNetResult? _parseResult(dynamic item) {
    if (item is! Map<String, dynamic>) {
      return null;
    }

    final species = item['species'];
    if (species is! Map<String, dynamic>) {
      return null;
    }

    final scientificName =
        (species['scientificName'] ?? species['scientificNameWithoutAuthor'])
            ?.toString()
            .trim();

    if (scientificName == null || scientificName.isEmpty) {
      return null;
    }

    final familyData = species['family'];
    final family = familyData is Map<String, dynamic>
        ? familyData['name']?.toString().trim()
        : null;

    final images = item['images'];
    String? imageUrl;
    if (images is List && images.isNotEmpty) {
      final firstImage = images.first;
      if (firstImage is Map<String, dynamic>) {
        imageUrl = _extractImageUrl(firstImage['url']);
      }
    }

    final scoreValue = item['score'];
    final score = scoreValue is num
        ? scoreValue.toDouble()
        : double.tryParse(scoreValue.toString()) ?? 0;

    return PlantNetResult(
      scientificName: scientificName,
      family: family,
      score: score,
      imageUrl: imageUrl,
    );
  }

  String? _extractImageUrl(dynamic rawUrl) {
    if (rawUrl is String && rawUrl.trim().isNotEmpty) {
      return rawUrl.trim();
    }

    if (rawUrl is Map<String, dynamic>) {
      for (final key in ['m', 'o', 'l', 's']) {
        final value = rawUrl[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }

    return null;
  }
}
