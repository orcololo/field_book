import 'package:isar/isar.dart';

part 'municipality_bounding_box_cache.g.dart';

@collection
class MunicipalityBoundingBoxCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String municipalityKey;

  late String municipalityName;
  late double south;
  late double north;
  late double west;
  late double east;

  @Index()
  late DateTime cachedAt;
}
