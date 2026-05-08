import 'package:isar/isar.dart';

part 'collection_template.g.dart';

@collection
class CollectionTemplate {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index(caseSensitive: false)
  late String name;

  @Index()
  late String biome;

  @Index()
  bool isBuiltIn = false;

  String? habitatTemplate;
  String? vegetationTypeTemplate;
  String? topographyTemplate;
  String? substrateTemplate;
  String? notesTemplate;
}
