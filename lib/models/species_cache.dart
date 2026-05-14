import 'package:isar/isar.dart';

part 'species_cache.g.dart';

@collection
class SpeciesCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String speciesId;

  @Index(type: IndexType.value, caseSensitive: false)
  late String name;

  String? author;

  @Index(type: IndexType.value, caseSensitive: false)
  String? family;

  late String status;

  String? rank;

  @Index()
  late DateTime syncedAt;
}
