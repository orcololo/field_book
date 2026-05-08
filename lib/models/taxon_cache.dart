import 'package:isar/isar.dart';

part 'taxon_cache.g.dart';

@collection
class TaxonCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  @Index()
  late String query;

  late String results;

  @Index()
  late DateTime cachedAt;
}
