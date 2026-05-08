import 'package:isar/isar.dart';
import 'plant_category.dart';

part 'settings.g.dart';

enum CloudBackupProvider {
  none,
  googleDrive,
  dropbox,
}

enum MapProvider {
  openStreetMap,
  mapboxStreets,
  mapboxSatellite,
}

@collection
class Settings {
  Id id = 1; // Singleton - always ID 1

  // Accessibility settings
  double fontScale = 1.0;
  bool highContrastMode = false;
  bool rainModeEnabled = false;

  // Map settings
  @Enumerated(EnumType.name)
  MapProvider mapProvider = MapProvider.openStreetMap;
  String? mapboxToken;
  double mapCacheRadius = 10.0; // in km
  bool autoCache = false;

  // Form settings
  int autoSaveInterval = 30; // in seconds, 0 = disabled
  @Enumerated(EnumType.name)
  PlantCategory? defaultCategory;

  // Photo settings
  int photoCompressionQuality = 70; // 30-100
  bool preserveExif = true;
  String plantnetApiKey = '';

  // Audio settings
  bool transcriptionEnabled = false;
  String transcriptionLocale = 'pt';
  String audioQuality = 'medium'; // low, medium, high

  // Export settings
  String exportFilenameFormat = 'plant_{scientificName}_{date}';
  String duplicateHandling = 'skip'; // skip, overwrite, rename
  String? inatAccessToken;
  String? inatUsername;

  // Performance settings
  int paginationSize = 20;
  bool enableThumbnailCache = true;

  // Localization
  String localeCode = 'pt'; // en, pt, es

  // Cloud backup
  @Enumerated(EnumType.name)
  CloudBackupProvider cloudBackupProvider = CloudBackupProvider.none;
  bool cloudBackupEnabled = false;
  bool cloudBackupWifiOnly = true;
  DateTime? lastCloudBackup;

  // Device info
  late String deviceId;
  late String deviceName;

  // Onboarding
  bool hasCompletedOnboarding = false;

  // Backup
  DateTime? lastLocalBackup;

  // Registry identifier settings
  String userInitials = 'RC'; // User initials for registry identifier
  int lastRegistryNumber = 0; // Last used registry number
  bool autoGenerateIdentifier = true; // Auto-generate identifier on plant save

  // Creation timestamp
  late DateTime createdAt;
}
