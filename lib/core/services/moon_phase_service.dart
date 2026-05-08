class MoonPhaseService {
  static const String newMoon = 'new';
  static const String waxingMoon = 'waxing';
  static const String fullMoon = 'full';
  static const String waningMoon = 'waning';

  static const double _synodicMonth = 29.53059;
  static final DateTime _knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);

  String getMoonPhase(DateTime date) {
    final difference = date.toUtc().difference(_knownNewMoon);
    final days = difference.inMilliseconds / Duration.millisecondsPerDay;
    final cyclePosition = ((days % _synodicMonth) + _synodicMonth) % _synodicMonth;
    final normalized = cyclePosition / _synodicMonth;

    if (normalized < 0.125 || normalized >= 0.875) {
      return newMoon;
    }
    if (normalized < 0.375) {
      return waxingMoon;
    }
    if (normalized < 0.625) {
      return fullMoon;
    }
    return waningMoon;
  }
}
