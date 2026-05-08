class _BiomeBoundingBox {
  final String biome;
  final double minLatitude;
  final double maxLatitude;
  final double minLongitude;
  final double maxLongitude;

  const _BiomeBoundingBox({
    required this.biome,
    required this.minLatitude,
    required this.maxLatitude,
    required this.minLongitude,
    required this.maxLongitude,
  });

  bool contains({required double latitude, required double longitude}) {
    return latitude >= minLatitude &&
        latitude <= maxLatitude &&
        longitude >= minLongitude &&
        longitude <= maxLongitude;
  }
}

class BiomeDetector {
  static const String cerrado = 'cerrado';
  static const String mataAtlantica = 'mata_atlantica';
  static const String amazonia = 'amazonia';
  static const String caatinga = 'caatinga';
  static const String pampa = 'pampa';
  static const String pantanal = 'pantanal';

  static const List<String> allBiomes = <String>[
    cerrado,
    mataAtlantica,
    amazonia,
    caatinga,
    pampa,
    pantanal,
  ];

  static const List<_BiomeBoundingBox> _boundingBoxes = <_BiomeBoundingBox>[
    _BiomeBoundingBox(
      biome: pantanal,
      minLatitude: -22,
      maxLatitude: -14,
      minLongitude: -62,
      maxLongitude: -55,
    ),
    _BiomeBoundingBox(
      biome: pampa,
      minLatitude: -34,
      maxLatitude: -27,
      minLongitude: -57,
      maxLongitude: -49,
    ),
    _BiomeBoundingBox(
      biome: caatinga,
      minLatitude: -17,
      maxLatitude: -2,
      minLongitude: -44,
      maxLongitude: -35,
    ),
    _BiomeBoundingBox(
      biome: cerrado,
      minLatitude: -24,
      maxLatitude: -5,
      minLongitude: -60,
      maxLongitude: -40,
    ),
    _BiomeBoundingBox(
      biome: mataAtlantica,
      minLatitude: -30,
      maxLatitude: -5,
      minLongitude: -50,
      maxLongitude: -34,
    ),
    _BiomeBoundingBox(
      biome: amazonia,
      minLatitude: -15,
      maxLatitude: 5,
      minLongitude: -74,
      maxLongitude: -44,
    ),
  ];

  static String? detectBiome({
    required double latitude,
    required double longitude,
  }) {
    for (final boundingBox in _boundingBoxes) {
      if (boundingBox.contains(latitude: latitude, longitude: longitude)) {
        return boundingBox.biome;
      }
    }

    return null;
  }
}
