import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrResult {
  final Map<String, String> fields;
  final String rawText;

  const OcrResult({required this.fields, required this.rawText});
}

class OcrService {
  static final RegExp _lineScientificNamePattern = RegExp(
    r'\b([A-Z][A-Za-zÀ-ÿ-]+\s+[a-z][A-Za-zÀ-ÿ-]+(?:\s+(?:subsp\.|var\.)\s+[a-z][A-Za-zÀ-ÿ-]+)?)\b',
  );

  Future<OcrResult> extractFromImage(File imageFile) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await textRecognizer.processImage(inputImage);
      final rawText = recognizedText.text.trim();

      return OcrResult(fields: _parseFields(rawText), rawText: rawText);
    } finally {
      await textRecognizer.close();
    }
  }

  Map<String, String> _parseFields(String rawText) {
    if (rawText.trim().isEmpty) {
      return const {};
    }

    final normalizedText = rawText.replaceAll('\r\n', '\n');
    final lines = normalizedText
        .split('\n')
        .map(_normalizeWhitespace)
        .where((line) => line.isNotEmpty)
        .toList();

    final fields = <String, String>{};

    final scientificName = _extractScientificName(normalizedText, lines);
    if (scientificName != null) {
      fields['scientificName'] = scientificName;
    }

    final collectorName = _extractFirstMatch(normalizedText, [
      RegExp(
        r'(?:^|\n)\s*(?:Collector|Collected by|Coletor|Colector|Leg\.?|Coll\.)\s*[:\-]?\s*([^\n]+)',
        caseSensitive: false,
        multiLine: true,
      ),
    ]);
    if (collectorName != null) {
      fields['collectorName'] = collectorName;
    }

    final collectionNumber = _extractFirstMatch(normalizedText, [
      RegExp(
        r'(?:#\s*|n[º°o]\s*|n(?:o|ro)\.?\s*|record\s*(?:number|no\.)\s*|collection\s*(?:number|no\.)\s*|coleta\s*(?:n[º°o]?|n[úu]mero)\s*|colector\s*(?:n[úu]mero)?\s*|collector\s*(?:number|no\.)\s*)[:\-]?\s*([A-Za-z0-9\-\/]+)',
        caseSensitive: false,
        multiLine: true,
      ),
    ]);
    if (collectionNumber != null) {
      fields['collectionNumber'] = collectionNumber;
    }

    final collectionDate = _extractDate(normalizedText);
    if (collectionDate != null) {
      fields['collectionDate'] = collectionDate;
    }

    final locality = _extractFirstMatch(normalizedText, [
      RegExp(
        r'(?:^|\n)\s*(?:Locality|Localidade|Localidad|Place)\s*[:\-]?\s*([^\n]+)',
        caseSensitive: false,
        multiLine: true,
      ),
    ]);
    if (locality != null) {
      fields['locality'] = locality;
    }

    final family = _extractFirstMatch(normalizedText, [
      RegExp(
        r'(?:^|\n)\s*(?:Family|Fam\.)\s*[:\-]?\s*([^\n]+)',
        caseSensitive: false,
        multiLine: true,
      ),
    ]);
    if (family != null) {
      fields['family'] = family;
    }

    final coordinates = _extractCoordinates(normalizedText);
    if (coordinates != null) {
      fields['latitude'] = coordinates.$1;
      fields['longitude'] = coordinates.$2;
    }

    return fields;
  }

  String? _extractScientificName(String normalizedText, List<String> lines) {
    final labeled = _extractFirstMatch(normalizedText, [
      RegExp(
        r'(?:^|\n)\s*(?:Scientific name|Nome cient[íi]fico|Nombre cient[íi]fico)\s*[:\-]?\s*([^\n]+)',
        caseSensitive: false,
        multiLine: true,
      ),
    ]);
    if (labeled != null) {
      final match = _lineScientificNamePattern.firstMatch(labeled);
      if (match != null) {
        return _normalizeWhitespace(match.group(1)!);
      }
    }

    for (final line in lines) {
      if (_looksLikeMetadataLine(line)) {
        continue;
      }

      final match = _lineScientificNamePattern.firstMatch(line);
      if (match != null) {
        return _normalizeWhitespace(match.group(1)!);
      }
    }

    return null;
  }

  String? _extractDate(String text) {
    final match = RegExp(
      r'\b(\d{2}\/\d{2}\/\d{4}|\d{4}-\d{2}-\d{2})\b',
      multiLine: true,
    ).firstMatch(text);

    return match == null ? null : _normalizeWhitespace(match.group(1)!);
  }

  (String, String)? _extractCoordinates(String text) {
    final decimalWithHemisphere = RegExp(
      r'\b(\d{1,2}(?:\.\d+)?)\s*°?\s*([NS])\s*[,; ]+\s*(\d{1,3}(?:\.\d+)?)\s*°?\s*([EW])\b',
      caseSensitive: false,
    ).firstMatch(text);
    if (decimalWithHemisphere != null) {
      final latitude = _applyHemisphere(
        double.parse(decimalWithHemisphere.group(1)!),
        decimalWithHemisphere.group(2)!,
      );
      final longitude = _applyHemisphere(
        double.parse(decimalWithHemisphere.group(3)!),
        decimalWithHemisphere.group(4)!,
      );

      if (_isValidCoordinatePair(latitude, longitude)) {
        return (_formatCoordinate(latitude), _formatCoordinate(longitude));
      }
    }

    final decimalPair = RegExp(
      r'\b([+-]?\d{1,2}\.\d+)\s*[,; ]\s*([+-]?\d{1,3}\.\d+)\b',
    ).firstMatch(text);
    if (decimalPair != null) {
      final latitude = double.parse(decimalPair.group(1)!);
      final longitude = double.parse(decimalPair.group(2)!);

      if (_isValidCoordinatePair(latitude, longitude)) {
        return (_formatCoordinate(latitude), _formatCoordinate(longitude));
      }
    }

    final dmsPair = RegExp(
      r'''(\d{1,2})[°º]\s*(\d{1,2})['′]\s*(\d{1,2}(?:\.\d+)?)?["″]?\s*([NS])\s*[,; ]+\s*(\d{1,3})[°º]\s*(\d{1,2})['′]\s*(\d{1,2}(?:\.\d+)?)?["″]?\s*([EW])''',
      caseSensitive: false,
    ).firstMatch(text);
    if (dmsPair != null) {
      final latitude = _dmsToDecimal(
        degrees: int.parse(dmsPair.group(1)!),
        minutes: int.parse(dmsPair.group(2)!),
        seconds: double.tryParse(dmsPair.group(3) ?? '0') ?? 0,
        hemisphere: dmsPair.group(4)!,
      );
      final longitude = _dmsToDecimal(
        degrees: int.parse(dmsPair.group(5)!),
        minutes: int.parse(dmsPair.group(6)!),
        seconds: double.tryParse(dmsPair.group(7) ?? '0') ?? 0,
        hemisphere: dmsPair.group(8)!,
      );

      if (_isValidCoordinatePair(latitude, longitude)) {
        return (_formatCoordinate(latitude), _formatCoordinate(longitude));
      }
    }

    return null;
  }

  String? _extractFirstMatch(String text, List<RegExp> patterns) {
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      final value = match?.groupCount == 0 ? match?.group(0) : match?.group(1);
      final cleaned = value == null ? null : _cleanCapturedValue(value);
      if (cleaned != null) {
        return cleaned;
      }
    }

    return null;
  }

  String? _cleanCapturedValue(String value) {
    final cleaned = _normalizeWhitespace(
      value
          .replaceAll(RegExp(r'^[\s:;,.\-]+'), '')
          .replaceAll(RegExp(r'[\s;,.]+$'), ''),
    );

    return cleaned.isEmpty ? null : cleaned;
  }

  String _normalizeWhitespace(String value) {
    return value.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool _looksLikeMetadataLine(String line) {
    final lowerLine = line.toLowerCase();
    const metadataPrefixes = [
      'family',
      'fam.',
      'collector',
      'coletor',
      'colector',
      'locality',
      'localidade',
      'localidad',
      'date',
      'data',
      'fecha',
      'leg.',
      'coll.',
    ];

    return metadataPrefixes.any(lowerLine.startsWith) || line.contains(':');
  }

  double _applyHemisphere(double value, String hemisphere) {
    final upperHemisphere = hemisphere.toUpperCase();
    if (upperHemisphere == 'S' || upperHemisphere == 'W') {
      return -value.abs();
    }
    return value.abs();
  }

  double _dmsToDecimal({
    required int degrees,
    required int minutes,
    required double seconds,
    required String hemisphere,
  }) {
    final decimal = degrees + (minutes / 60) + (seconds / 3600);
    return _applyHemisphere(decimal, hemisphere);
  }

  bool _isValidCoordinatePair(double latitude, double longitude) {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  String _formatCoordinate(double value) => value.toStringAsFixed(6);
}
