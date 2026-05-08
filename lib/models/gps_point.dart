import 'package:isar/isar.dart';

part 'gps_point.g.dart';

@embedded
class GpsPoint {
  double latitude = 0;
  double longitude = 0;
  double? altitude;
  DateTime timestamp = DateTime.now();

  GpsPoint();
}
