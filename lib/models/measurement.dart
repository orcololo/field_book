import 'package:isar/isar.dart';

part 'measurement.g.dart';

@embedded
class Measurement {
  String label = '';
  double value = 0.0;
  String unit = '';

  Measurement();
}
