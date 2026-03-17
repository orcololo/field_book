import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/plant_repository.dart';
import '../repositories/session_repository.dart';
import '../../models/settings.dart';
import '../services/export_import_service.dart';
import '../services/settings_service.dart';

part 'google_drive_backup_service.g.dart';

const _backupFileName = 'folium_backup.json';

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

  /// Perform a full backup to Google Drive appDataFolder.
  ///
  /// Throws [BackupException] on failure.
  Future<void> backup({bool respectWifiSetting = true}) async {
    // 1. Connectivity check
    if (respectWifiSetting) {
      await _ensureConnectivity();
    }

    // 2. Build JSON payload using existing export infrastructure
    final exportService = ExportImportService(plantRepo, sessionRepo);
    final jsonString =
        await exportService.exportToJsonString(includeSessions: true);

    // 3. Sign in & get Drive API
    final api = await _getOrCreateDriveApi();

    // 4. Upload / update the backup file
    final existingFileId = await _findBackupFileId(api);
    final media = drive.Media(
      Stream.value(utf8.encode(jsonString)),
      utf8.encode(jsonString).length,
    );

    if (existingFileId != null) {
      // Update in-place to avoid accumulating files
      await api.files.update(
        drive.File()..name = _backupFileName,
        existingFileId,
        uploadMedia: media,
      );
      _log.i('Cloud backup updated (fileId=$existingFileId)');
    } else {
      // Create new
      final fileMetadata = drive.File()
        ..name = _backupFileName
        ..parents = ['appDataFolder'];
      await api.files.create(fileMetadata, uploadMedia: media);
      _log.i('Cloud backup created');
    }

    // 5. Update last backup timestamp
    await settingsNotifier.updateLastCloudBackup();
  }

  // ─── Restore ──────────────────────────────────────────────

  /// Restore from the latest Google Drive backup.
  ///
  /// Returns the [ImportResult] with counts.
  /// Throws [RestoreException] on failure.
  Future<ImportResult> restore() async {
    final api = await _getOrCreateDriveApi();

    final fileId = await _findBackupFileId(api);
    if (fileId == null) {
      throw const RestoreException('noBackupFound');
    }

    // Download the file content
    final response = await api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final bytes = <int>[];
    await for (final chunk in response.stream) {
      bytes.addAll(chunk);
    }
    final jsonString = utf8.decode(bytes);

    // Import using shared infrastructure
    final exportService = ExportImportService(plantRepo, sessionRepo);
    final result = await exportService.importFromJsonString(jsonString);

    _log.i(
        'Cloud restore complete: imported=${result.imported}, updated=${result.updated}');
    return result;
  }

  // ─── Helpers ──────────────────────────────────────────────

  /// Find the existing backup file in appDataFolder, if any.
  Future<String?> _findBackupFileId(drive.DriveApi api) async {
    final fileList = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$_backupFileName'",
      $fields: 'files(id, name)',
    );
    final files = fileList.files;
    if (files != null && files.isNotEmpty) {
      return files.first.id;
    }
    return null;
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
