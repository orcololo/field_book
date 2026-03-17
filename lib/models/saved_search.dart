import 'package:isar/isar.dart';

part 'saved_search.g.dart';

@collection
class SavedSearch {
  Id id = Isar.autoIncrement;

  late String uuid;
  late String name;
  late String query;
  // Store filters as JSON string since Map isn't supported
  String filtersJson = '{}';
  late DateTime createdAt;
}
