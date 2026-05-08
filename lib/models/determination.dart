import 'package:isar/isar.dart';

part 'determination.g.dart';

@embedded
class Determination {
  String determinedBy = '';
  DateTime determinedAt = DateTime.now();
  String scientificName = '';
  String? family;
  String? notes;
  String? basis;

  Determination();
}
