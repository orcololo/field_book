import 'package:isar/isar.dart';

import 'gps_point.dart';
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
  List<GpsPoint> track = [];
  String? notes;
  bool isArchived = false;

  late DateTime createdAt;
  SyncMetadata syncMetadata = SyncMetadata();
}
