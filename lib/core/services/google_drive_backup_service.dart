import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/plant_repository.dart';
import '../repositories/session_repository.dart';
import '../../models/settings.dart';
import '../services/export_import_service.dart';
import '../services/settings_service.dart';

part 'google_drive_backup_service.g.dart';

const _backupFileName = 'folium_backup.json';
const _incrementalBackupFileName = 'folium_backup_incremental.json';
const _lastBackupTimestampKey = 'google_drive_last_backup_timestamp';

class BackupException implements Exception {
  final String message;
  const BackupException(this.message);
  @override
  String toString() => message;
}

class RestoreException implements Exception {
  final String message;
  const RestoreException(this.message);
  @override
  String toString() => message;
}

@riverpod
GoogleDriveBackupService googleDriveBackupService(
    GoogleDriveBackupServiceRef ref) {
  final plantRepo = ref.read(plantRepositoryProvider);
  final sessionRepo = ref.read(sessionRepositoryProvider);
  final settingsNotifier = ref.read(settingsNotifierProvider.notifier);
  final currentSettings = ref.read(settingsNotifierProvider).valueOrNull;
  return GoogleDriveBackupService(
    plantRepo: plantRepo,
    sessionRepo: sessionRepo,
    settingsNotifier: settingsNotifier,
    currentSettings: currentSettings,
  );
}

class GoogleDriveBackupService {
  static final _log = Logger(
    printer: PrettyPrinter(methodCount: 0),
    filter: ProductionFilter(),
  );

  final PlantRepository plantRepo;
  final SessionRepository sessionRepo;
  final SettingsNotifier settingsNotifier;
  final Settings? currentSettings;

  GoogleDriveBackupService({
    required this.plantRepo,
    required this.sessionRepo,
    required this.settingsNotifier,
    this.currentSettings,
  });

  GoogleSignIn? _googleSignIn;
  drive.DriveApi? _driveApi;

  GoogleSignIn get _signIn {
    _googleSignIn ??= GoogleSignIn(
      scopes: [drive.DriveApi.driveAppdataScope],
    );
    return _googleSignIn!;
  }

  /// Sign in with Google and obtain a Drive API client.
  Future<drive.DriveApi> _getOrCreateDriveApi() async {
    if (_driveApi != null) return _driveApi!;

    final account = _signIn.currentUser ?? await _signIn.signInSilently();
    if (account == null) {
      final signedIn = await _signIn.signIn();
      if (signedIn == null) {
        throw const BackupException('Google sign-in cancelled');
      }
    }

    final auth.AuthClient? httpClient =
        await _signIn.authenticatedClient();
    if (httpClient == null) {
      throw const BackupException('Failed to obtain auth client');
    }

    _driveApi = drive.DriveApi(httpClient);
    return _driveApi!;
  }

  /// Whether the user is currently signed in.
  bool get isSignedIn => _signIn.currentUser != null;

  /// The signed-in user's email, or null.
  String? get currentUserEmail => _signIn.currentUser?.email;

  /// Sign out and clear cached API client.
  Future<void> signOut() async {
    await _signIn.signOut();
    _driveApi = null;
  }

  // ─── Backup ───────────────────────────────────────────────

  /// Perform an incremental backup to Google Drive appDataFolder.
  ///
  /// Only backs up records modified since the last backup.
  /// Falls back to full backup if no previous backup timestamp exists.
  ///
  /// Throws [BackupException] on failure.
  Future<void> backup({bool respectWifiSetting = true}) async {
    // 1. Connectivity check
    if (respectWifiSetting) {
      await _ensureConnectivity();
    }

    // 2. Get last backup timestamp
    final lastBackupTimestamp = await _getLastBackupTimestamp();

    // 3. Build JSON payload — incremental if we have a previous timestamp
    final exportService = ExportImportService(plantRepo, sessionRepo);
    final String jsonString;

    if (lastBackupTimestamp != null) {
      jsonString = await exportService.exportToJsonString(
        includeSessions: true,
        modifiedAfter: lastBackupTimestamp,
      );
    } else {
      // First backup is always full
      jsonString = await exportService.exportToJsonString(
        includeSessions: true,
      );
    }

    // 4. Sign in & get Drive API
    final api = await _getOrCreateDriveApi();

    // 5. Determine which file to upload to
    final targetFileName =
        lastBackupTimestamp != null ? _incrementalBackupFileName : _backupFileName;
    final existingFileId = await _findFileId(api, targetFileName);
    final media = drive.Media(
      Stream.value(utf8.encode(jsonString)),
      utf8.encode(jsonString).length,
    );

    if (existingFileId != null) {
      await api.files.update(
        drive.File()..name = targetFileName,
        existingFileId,
        uploadMedia: media,
      );
      _log.i('Cloud backup updated ($targetFileName, fileId=$existingFileId)');
    } else {
      final fileMetadata = drive.File()
        ..name = targetFileName
        ..parents = ['appDataFolder'];
      await api.files.create(fileMetadata, uploadMedia: media);
      _log.i('Cloud backup created ($targetFileName)');
    }

    // 6. Save backup timestamp and update settings
    await _saveLastBackupTimestamp(DateTime.now());
    await settingsNotifier.updateLastCloudBackup();
  }

  /// Perform a full backup to Google Drive appDataFolder.
  ///
  /// Exports all data regardless of last backup timestamp.
  /// Resets the incremental backup state.
  ///
  /// Throws [BackupException] on failure.
  Future<void> fullBackup({bool respectWifiSetting = true}) async {
    // 1. Connectivity check
    if (respectWifiSetting) {
      await _ensureConnectivity();
    }

    // 2. Build full JSON payload
    final exportService = ExportImportService(plantRepo, sessionRepo);
    final jsonString = await exportService.exportToJsonString(
      includeSessions: true,
    );

    // 3. Sign in & get Drive API
    final api = await _getOrCreateDriveApi();

    // 4. Upload full backup
    final existingFileId = await _findFileId(api, _backupFileName);
    final media = drive.Media(
      Stream.value(utf8.encode(jsonString)),
      utf8.encode(jsonString).length,
    );

    if (existingFileId != null) {
      await api.files.update(
        drive.File()..name = _backupFileName,
        existingFileId,
        uploadMedia: media,
      );
      _log.i('Full cloud backup updated (fileId=$existingFileId)');
    } else {
      final fileMetadata = drive.File()
        ..name = _backupFileName
        ..parents = ['appDataFolder'];
      await api.files.create(fileMetadata, uploadMedia: media);
      _log.i('Full cloud backup created');
    }

    // 5. Remove stale incremental file since full backup supersedes it
    final incrementalFileId =
        await _findFileId(api, _incrementalBackupFileName);
    if (incrementalFileId != null) {
      await api.files.delete(incrementalFileId);
      _log.i('Removed stale incremental backup');
    }

    // 6. Save backup timestamp and update settings
    await _saveLastBackupTimestamp(DateTime.now());
    await settingsNotifier.updateLastCloudBackup();
  }

  // ─── Restore ──────────────────────────────────────────────

  /// Restore from Google Drive backup.
  ///
  /// First restores the full backup, then merges any incremental data on top.
  /// Returns the combined [ImportResult] with counts.
  /// Throws [RestoreException] on failure.
  Future<ImportResult> restore() async {
    // Connectivity check
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw const RestoreException('noInternetConnection');
    }

    final api = await _getOrCreateDriveApi();
    final exportService = ExportImportService(plantRepo, sessionRepo);

    int totalImported = 0;
    int totalUpdated = 0;

    // 1. Restore full backup first
    final fullFileId = await _findFileId(api, _backupFileName);
    if (fullFileId != null) {
      final fullJson = await _downloadFile(api, fullFileId);
      final fullResult = await exportService.importFromJsonString(fullJson);
      totalImported += fullResult.imported;
      totalUpdated += fullResult.updated;
      _log.i(
        'Full backup restored: imported=${fullResult.imported}, '
        'updated=${fullResult.updated}',
      );
    }

    // 2. Merge incremental backup on top
    final incrementalFileId =
        await _findFileId(api, _incrementalBackupFileName);
    if (incrementalFileId != null) {
      final incrementalJson = await _downloadFile(api, incrementalFileId);
      final incrementalResult =
          await exportService.importFromJsonString(incrementalJson);
      totalImported += incrementalResult.imported;
      totalUpdated += incrementalResult.updated;
      _log.i(
        'Incremental backup merged: imported=${incrementalResult.imported}, '
        'updated=${incrementalResult.updated}',
      );
    }

    if (fullFileId == null && incrementalFileId == null) {
      throw const RestoreException('noBackupFound');
    }

    _log.i(
      'Cloud restore complete: imported=$totalImported, updated=$totalUpdated',
    );
    return ImportResult(imported: totalImported, updated: totalUpdated, skipped: 0, errors: []);
  }

  // ─── Helpers ──────────────────────────────────────────────

  /// Find a file by name in appDataFolder.
  Future<String?> _findFileId(drive.DriveApi api, String fileName) async {
    final fileList = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$fileName'",
      $fields: 'files(id, name)',
    );
    final files = fileList.files;
    if (files != null && files.isNotEmpty) {
      return files.first.id;
    }
    return null;
  }

  /// Download file content as a UTF-8 string.
  Future<String> _downloadFile(drive.DriveApi api, String fileId) async {
    final response = await api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final bytes = <int>[];
    await for (final chunk in response.stream) {
      bytes.addAll(chunk);
    }
    return utf8.decode(bytes);
  }

  /// Get the last backup timestamp from SharedPreferences.
  Future<DateTime?> _getLastBackupTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString(_lastBackupTimestampKey);
    if (timestamp != null) {
      return DateTime.tryParse(timestamp);
    }
    return null;
  }

  /// Save the last backup timestamp to SharedPreferences.
  Future<void> _saveLastBackupTimestamp(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _lastBackupTimestampKey,
      timestamp.toIso8601String(),
    );
  }

  /// Ensure network connectivity respecting the wifi-only setting.
  Future<void> _ensureConnectivity() async {
    final settings = currentSettings;
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      throw const BackupException('noInternetConnection');
    }

    if (settings != null &&
        settings.cloudBackupWifiOnly &&
        connectivityResult != ConnectivityResult.wifi) {
      throw const BackupException('wifiRequired');
    }
  }
}
