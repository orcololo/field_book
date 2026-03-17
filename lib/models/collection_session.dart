import 'package:isar/isar.dart';
import 'sync_metadata.dart';

part 'collection_session.g.dart';

@collection
class CollectionSession {
  Id id = Isar.autoIncrement;

  @Index()
  late String uuid;

  @Index()
  late String tripName;

  late DateTime startDate;
  DateTime? endDate;
  String? location;
  List<String> teamMembers = [];

  @Index(unique: true, replace: false)
  String? shareCode;

  List<String> sharedWith = []; // Device IDs
  String? notes;
  bool isArchived = false;

  late DateTime createdAt;
  SyncMetadata syncMetadata = SyncMetadata();
}
