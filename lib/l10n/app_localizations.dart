import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Field Book'**
  String get appTitle;

  /// No description provided for @plants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get plants;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @scientificName.
  ///
  /// In en, this message translates to:
  /// **'Scientific Name'**
  String get scientificName;

  /// No description provided for @commonName.
  ///
  /// In en, this message translates to:
  /// **'Common Name'**
  String get commonName;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @genus.
  ///
  /// In en, this message translates to:
  /// **'Genus'**
  String get genus;

  /// No description provided for @species.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get species;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @habitat.
  ///
  /// In en, this message translates to:
  /// **'Habitat'**
  String get habitat;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurements;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @audioNotes.
  ///
  /// In en, this message translates to:
  /// **'Audio Notes'**
  String get audioNotes;

  /// No description provided for @categoryTrees.
  ///
  /// In en, this message translates to:
  /// **'Trees'**
  String get categoryTrees;

  /// No description provided for @categoryShrubs.
  ///
  /// In en, this message translates to:
  /// **'Shrubs'**
  String get categoryShrubs;

  /// No description provided for @categoryHerbs.
  ///
  /// In en, this message translates to:
  /// **'Herbs'**
  String get categoryHerbs;

  /// No description provided for @categoryFerns.
  ///
  /// In en, this message translates to:
  /// **'Ferns'**
  String get categoryFerns;

  /// No description provided for @categoryGrasses.
  ///
  /// In en, this message translates to:
  /// **'Grasses'**
  String get categoryGrasses;

  /// No description provided for @categoryVines.
  ///
  /// In en, this message translates to:
  /// **'Vines'**
  String get categoryVines;

  /// No description provided for @categoryCacti.
  ///
  /// In en, this message translates to:
  /// **'Cacti'**
  String get categoryCacti;

  /// No description provided for @categoryAquatic.
  ///
  /// In en, this message translates to:
  /// **'Aquatic'**
  String get categoryAquatic;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save as Draft'**
  String get saveDraft;

  /// No description provided for @markComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get markComplete;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @newPlant.
  ///
  /// In en, this message translates to:
  /// **'New Plant'**
  String get newPlant;

  /// No description provided for @newPlantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete form with all fields'**
  String get newPlantSubtitle;

  /// No description provided for @plantDetails.
  ///
  /// In en, this message translates to:
  /// **'Plant Details'**
  String get plantDetails;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// No description provided for @taxonomyInfo.
  ///
  /// In en, this message translates to:
  /// **'Taxonomy'**
  String get taxonomyInfo;

  /// No description provided for @locationInfo.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationInfo;

  /// No description provided for @habitatInfo.
  ///
  /// In en, this message translates to:
  /// **'Habitat'**
  String get habitatInfo;

  /// No description provided for @habitatHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the habitat where the plant was found...'**
  String get habitatHint;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Additional observations or notes...'**
  String get notesHint;

  /// No description provided for @measurementsInfo.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurementsInfo;

  /// No description provided for @photosInfo.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosInfo;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @recordAudio.
  ///
  /// In en, this message translates to:
  /// **'Record Audio'**
  String get recordAudio;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get startRecording;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get stopRecording;

  /// No description provided for @pauseRecording.
  ///
  /// In en, this message translates to:
  /// **'Pause Recording'**
  String get pauseRecording;

  /// No description provided for @resumeRecording.
  ///
  /// In en, this message translates to:
  /// **'Resume Recording'**
  String get resumeRecording;

  /// No description provided for @sessionName.
  ///
  /// In en, this message translates to:
  /// **'Session Name'**
  String get sessionName;

  /// No description provided for @newSession.
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get newSession;

  /// No description provided for @joinSession.
  ///
  /// In en, this message translates to:
  /// **'Join Session'**
  String get joinSession;

  /// No description provided for @shareSession.
  ///
  /// In en, this message translates to:
  /// **'Share Session'**
  String get shareSession;

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @cloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackup;

  /// No description provided for @localBackup.
  ///
  /// In en, this message translates to:
  /// **'Local Backup'**
  String get localBackup;

  /// No description provided for @lastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last Backup'**
  String get lastBackup;

  /// No description provided for @googleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get googleDrive;

  /// No description provided for @dropbox.
  ///
  /// In en, this message translates to:
  /// **'Dropbox'**
  String get dropbox;

  /// No description provided for @advancedSearch.
  ///
  /// In en, this message translates to:
  /// **'Advanced Search'**
  String get advancedSearch;

  /// No description provided for @savedSearches.
  ///
  /// In en, this message translates to:
  /// **'Saved Searches'**
  String get savedSearches;

  /// No description provided for @searchRadius.
  ///
  /// In en, this message translates to:
  /// **'Search Radius'**
  String get searchRadius;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database error'**
  String get errorDatabase;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get errorNetwork;

  /// No description provided for @errorPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get errorPermission;

  /// No description provided for @errorFileSystem.
  ///
  /// In en, this message translates to:
  /// **'File system error'**
  String get errorFileSystem;

  /// No description provided for @permissionCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get permissionCamera;

  /// No description provided for @permissionLocation.
  ///
  /// In en, this message translates to:
  /// **'Location permission required'**
  String get permissionLocation;

  /// No description provided for @permissionMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission required'**
  String get permissionMicrophone;

  /// No description provided for @permissionStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage permission required'**
  String get permissionStorage;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get importing;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @noPlants.
  ///
  /// In en, this message translates to:
  /// **'No plants recorded'**
  String get noPlants;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions'**
  String get noSessions;

  /// No description provided for @noPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos'**
  String get noPhotos;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get confirmDelete;

  /// No description provided for @confirmDeletePlant.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this plant?'**
  String get confirmDeletePlant;

  /// No description provided for @confirmDeleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete this session?'**
  String get confirmDeleteSession;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @totalPlants.
  ///
  /// In en, this message translates to:
  /// **'Total Plants'**
  String get totalPlants;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessions;

  /// No description provided for @totalPhotos.
  ///
  /// In en, this message translates to:
  /// **'Total Photos'**
  String get totalPhotos;

  /// No description provided for @storageUsed.
  ///
  /// In en, this message translates to:
  /// **'Storage Used'**
  String get storageUsed;

  /// No description provided for @editPlant.
  ///
  /// In en, this message translates to:
  /// **'Edit Plant'**
  String get editPlant;

  /// No description provided for @collectionDate.
  ///
  /// In en, this message translates to:
  /// **'Collection Date'**
  String get collectionDate;

  /// No description provided for @gpsCoordinates.
  ///
  /// In en, this message translates to:
  /// **'GPS Coordinates'**
  String get gpsCoordinates;

  /// No description provided for @noSession.
  ///
  /// In en, this message translates to:
  /// **'No session'**
  String get noSession;

  /// No description provided for @noLocationSet.
  ///
  /// In en, this message translates to:
  /// **'No location set'**
  String get noLocationSet;

  /// No description provided for @recenter.
  ///
  /// In en, this message translates to:
  /// **'Recenter'**
  String get recenter;

  /// No description provided for @fillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fillRequiredFields;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @clearLocation.
  ///
  /// In en, this message translates to:
  /// **'Clear Location'**
  String get clearLocation;

  /// No description provided for @locationMap.
  ///
  /// In en, this message translates to:
  /// **'Location Map'**
  String get locationMap;

  /// No description provided for @addMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Add Measurement'**
  String get addMeasurement;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// No description provided for @basedOnGenus.
  ///
  /// In en, this message translates to:
  /// **'Based on reported genus'**
  String get basedOnGenus;

  /// No description provided for @audioNoteSaved.
  ///
  /// In en, this message translates to:
  /// **'Audio note saved'**
  String get audioNoteSaved;

  /// No description provided for @audioNoteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Audio note deleted'**
  String get audioNoteDeleted;

  /// No description provided for @locationObtained.
  ///
  /// In en, this message translates to:
  /// **'Location obtained successfully'**
  String get locationObtained;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location Services Disabled'**
  String get locationServicesDisabled;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationPermissionRequired;

  /// No description provided for @identifierGenerated.
  ///
  /// In en, this message translates to:
  /// **'Identifier generated: {identifier}'**
  String identifierGenerated(String identifier);

  /// No description provided for @errorGeneratingIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Error generating identifier: {error}'**
  String errorGeneratingIdentifier(String error);

  /// No description provided for @errorSavingPlant.
  ///
  /// In en, this message translates to:
  /// **'Error saving plant: {error}'**
  String errorSavingPlant(String error);

  /// No description provided for @errorUpdatingPlant.
  ///
  /// In en, this message translates to:
  /// **'Error updating plant: {error}'**
  String errorUpdatingPlant(String error);

  /// No description provided for @plantUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Plant updated successfully'**
  String get plantUpdatedSuccessfully;

  /// No description provided for @errorObtainingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error obtaining location: {error}'**
  String errorObtainingLocation(String error);

  /// No description provided for @errorTakingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Error taking photo: {error}'**
  String errorTakingPhoto(String error);

  /// No description provided for @errorChoosingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Error choosing photos: {error}'**
  String errorChoosingPhotos(String error);

  /// No description provided for @transcriptionDisabled.
  ///
  /// In en, this message translates to:
  /// **'Transcription disabled in settings'**
  String get transcriptionDisabled;

  /// No description provided for @audioFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Audio file not found'**
  String get audioFileNotFound;

  /// No description provided for @errorTranscribing.
  ///
  /// In en, this message translates to:
  /// **'Error transcribing: {error}'**
  String errorTranscribing(String error);

  /// No description provided for @imageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Image not found'**
  String get imageNotFound;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @errorDeletingPlant.
  ///
  /// In en, this message translates to:
  /// **'Error deleting plant: {error}'**
  String errorDeletingPlant(String error);

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @shared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get shared;

  /// No description provided for @shareCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Share this code with other users:'**
  String get shareCodeMessage;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date *'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @errorSavingSession.
  ///
  /// In en, this message translates to:
  /// **'Error saving session: {error}'**
  String errorSavingSession(String error);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @selectAtLeastOnePlant.
  ///
  /// In en, this message translates to:
  /// **'Select at least one plant'**
  String get selectAtLeastOnePlant;

  /// No description provided for @confirmAssignment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Assignment'**
  String get confirmAssignment;

  /// No description provided for @manageIdentifiers.
  ///
  /// In en, this message translates to:
  /// **'Manage Identifiers'**
  String get manageIdentifiers;

  /// No description provided for @exportIdentifiers.
  ///
  /// In en, this message translates to:
  /// **'Export Identifiers'**
  String get exportIdentifiers;

  /// No description provided for @exportCompleted.
  ///
  /// In en, this message translates to:
  /// **'Export completed'**
  String get exportCompleted;

  /// No description provided for @importCompleted.
  ///
  /// In en, this message translates to:
  /// **'Import completed'**
  String get importCompleted;

  /// No description provided for @allPlantsHaveIdentifiers.
  ///
  /// In en, this message translates to:
  /// **'All plants have identifiers'**
  String get allPlantsHaveIdentifiers;

  /// No description provided for @noPlantsWithoutIdentifiers.
  ///
  /// In en, this message translates to:
  /// **'No plants without identifiers at the moment.'**
  String get noPlantsWithoutIdentifiers;

  /// No description provided for @plantsWithoutIdentifier.
  ///
  /// In en, this message translates to:
  /// **'{count} plant(s) without identifier'**
  String plantsWithoutIdentifier(int count);

  /// No description provided for @assignCount.
  ///
  /// In en, this message translates to:
  /// **'Assign ({count})'**
  String assignCount(int count);

  /// No description provided for @identifiersAssigned.
  ///
  /// In en, this message translates to:
  /// **'{count} identifier(s) assigned successfully'**
  String identifiersAssigned(int count);

  /// No description provided for @microphonePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get microphonePermissionDenied;

  /// No description provided for @errorStartingRecording.
  ///
  /// In en, this message translates to:
  /// **'Error starting recording: {error}'**
  String errorStartingRecording(String error);

  /// No description provided for @startRecordingLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get startRecordingLabel;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Folium'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Your botanical field book for documenting and organizing plant collections in the field.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Collection Sessions'**
  String get onboardingSessionsTitle;

  /// No description provided for @onboardingSessionsBody.
  ///
  /// In en, this message translates to:
  /// **'Create field trips, define locations, add team members and organize your collections by session.'**
  String get onboardingSessionsBody;

  /// No description provided for @onboardingCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Record Plants'**
  String get onboardingCollectionTitle;

  /// No description provided for @onboardingCollectionBody.
  ///
  /// In en, this message translates to:
  /// **'Capture scientific data with photos, GPS location, audio notes, measurements and automatic transcription.'**
  String get onboardingCollectionBody;

  /// No description provided for @onboardingExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export & Share'**
  String get onboardingExportTitle;

  /// No description provided for @onboardingExportBody.
  ///
  /// In en, this message translates to:
  /// **'Export your data in JSON, CSV or Darwin Core format and share with herbarium databases.'**
  String get onboardingExportBody;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingDone;

  /// No description provided for @onboardingSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Identifier'**
  String get onboardingSetupTitle;

  /// No description provided for @onboardingSetupBody.
  ///
  /// In en, this message translates to:
  /// **'Set your initials and starting number for plant registry identifiers (e.g. RC000001).'**
  String get onboardingSetupBody;

  /// No description provided for @onboardingInitialsLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Initials'**
  String get onboardingInitialsLabel;

  /// No description provided for @onboardingInitialsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. RC'**
  String get onboardingInitialsHint;

  /// No description provided for @onboardingLastNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Used Number'**
  String get onboardingLastNumberLabel;

  /// No description provided for @onboardingLastNumberHint.
  ///
  /// In en, this message translates to:
  /// **'0 if starting fresh'**
  String get onboardingLastNumberHint;

  /// No description provided for @onboardingIdentifierPreview.
  ///
  /// In en, this message translates to:
  /// **'Next identifier: {identifier}'**
  String onboardingIdentifierPreview(String identifier);

  /// No description provided for @showTutorial.
  ///
  /// In en, this message translates to:
  /// **'Show Tutorial'**
  String get showTutorial;

  /// No description provided for @showTutorialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Replay the introduction walkthrough'**
  String get showTutorialSubtitle;

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Backup Now'**
  String get backupNow;

  /// No description provided for @restoreFromCloud.
  ///
  /// In en, this message translates to:
  /// **'Restore from Cloud'**
  String get restoreFromCloud;

  /// No description provided for @backupInProgress.
  ///
  /// In en, this message translates to:
  /// **'Backup in progress...'**
  String get backupInProgress;

  /// No description provided for @backupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup completed successfully'**
  String get backupSuccess;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String backupFailed(String error);

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from Cloud?'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Cloud data will be merged with your local data. Existing records will be updated.'**
  String get restoreConfirmBody;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restore completed successfully'**
  String get restoreSuccess;

  /// No description provided for @restoreInProgress.
  ///
  /// In en, this message translates to:
  /// **'Restoring data...'**
  String get restoreInProgress;

  /// No description provided for @restoreResult.
  ///
  /// In en, this message translates to:
  /// **'Imported: {imported}, Updated: {updated}, Skipped: {skipped}'**
  String restoreResult(int imported, int updated, int skipped);

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String signedInAs(String email);

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @wifiRequired.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi connection required for backup'**
  String get wifiRequired;

  /// No description provided for @noBackupFound.
  ///
  /// In en, this message translates to:
  /// **'No backup found in the cloud'**
  String get noBackupFound;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @backupAndData.
  ///
  /// In en, this message translates to:
  /// **'Backup & Data'**
  String get backupAndData;

  /// No description provided for @exportAndImport.
  ///
  /// In en, this message translates to:
  /// **'Export & Import'**
  String get exportAndImport;

  /// No description provided for @localDataBackup.
  ///
  /// In en, this message translates to:
  /// **'Local data backup'**
  String get localDataBackup;

  /// No description provided for @syncAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Sync data automatically'**
  String get syncAutomatically;

  /// No description provided for @backupProvider.
  ///
  /// In en, this message translates to:
  /// **'Backup Provider'**
  String get backupProvider;

  /// No description provided for @wifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Only'**
  String get wifiOnly;

  /// No description provided for @backupOnlyWifi.
  ///
  /// In en, this message translates to:
  /// **'Back up only on Wi-Fi'**
  String get backupOnlyWifi;

  /// No description provided for @lastBackupLabel.
  ///
  /// In en, this message translates to:
  /// **'Last backup'**
  String get lastBackupLabel;

  /// No description provided for @providerNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get providerNone;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutApp;

  /// No description provided for @deviceId.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceId;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Error signing in'**
  String get loginError;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @googleSignInError.
  ///
  /// In en, this message translates to:
  /// **'Error signing in with Google: {error}'**
  String googleSignInError(String error);

  /// No description provided for @botanicalFieldBook.
  ///
  /// In en, this message translates to:
  /// **'Botanical field book'**
  String get botanicalFieldBook;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @continueOffline.
  ///
  /// In en, this message translates to:
  /// **'Continue offline'**
  String get continueOffline;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDoNotMatch;

  /// No description provided for @registerError.
  ///
  /// In en, this message translates to:
  /// **'Error registering'**
  String get registerError;

  /// No description provided for @drafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get drafts;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @plantsByCategory.
  ///
  /// In en, this message translates to:
  /// **'Plants by Category'**
  String get plantsByCategory;

  /// No description provided for @noPlantsYet.
  ///
  /// In en, this message translates to:
  /// **'No plants recorded yet'**
  String get noPlantsYet;

  /// No description provided for @collectionsByMonth.
  ///
  /// In en, this message translates to:
  /// **'Collections by Month'**
  String get collectionsByMonth;

  /// No description provided for @noActivityRecorded.
  ///
  /// In en, this message translates to:
  /// **'No activity recorded'**
  String get noActivityRecorded;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @registryIdentification.
  ///
  /// In en, this message translates to:
  /// **'Registry Identification'**
  String get registryIdentification;

  /// No description provided for @formSection.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get formSection;

  /// No description provided for @audioSection.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audioSection;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @syncSection.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncSection;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings'**
  String get errorLoadingSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @startCollectionMsg.
  ///
  /// In en, this message translates to:
  /// **'Start your collection by adding the first plant'**
  String get startCollectionMsg;

  /// No description provided for @addPlant.
  ///
  /// In en, this message translates to:
  /// **'Add Plant'**
  String get addPlant;

  /// No description provided for @noCollectionSessions.
  ///
  /// In en, this message translates to:
  /// **'No collection sessions'**
  String get noCollectionSessions;

  /// No description provided for @createSessionMsg.
  ///
  /// In en, this message translates to:
  /// **'Create a session to organize your field collections'**
  String get createSessionMsg;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @noResultsForQuery.
  ///
  /// In en, this message translates to:
  /// **'No results found for \"{query}\"'**
  String noResultsForQuery(String query);

  /// No description provided for @adjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting the search filters'**
  String get adjustFilters;

  /// No description provided for @addPhotosMsg.
  ///
  /// In en, this message translates to:
  /// **'Add photos to document this plant'**
  String get addPhotosMsg;

  /// No description provided for @noMeasurementsTitle.
  ///
  /// In en, this message translates to:
  /// **'No measurements'**
  String get noMeasurementsTitle;

  /// No description provided for @recordMeasurementsMsg.
  ///
  /// In en, this message translates to:
  /// **'Record measurements for scientific analysis'**
  String get recordMeasurementsMsg;

  /// No description provided for @errorLoadingPlants.
  ///
  /// In en, this message translates to:
  /// **'Error loading plants: {error}'**
  String errorLoadingPlants(String error);

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'An app for recording and documenting plants in the field.'**
  String get aboutAppDescription;

  /// No description provided for @searchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search plants'**
  String get searchTooltip;

  /// No description provided for @savedAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Saved as draft'**
  String get savedAsDraft;

  /// No description provided for @plantRecordSaved.
  ///
  /// In en, this message translates to:
  /// **'Plant record saved'**
  String get plantRecordSaved;

  /// No description provided for @identifierLabel.
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get identifierLabel;

  /// No description provided for @identifierHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: RC000001'**
  String get identifierHint;

  /// No description provided for @generateIdentifierTooltip.
  ///
  /// In en, this message translates to:
  /// **'Generate identifier'**
  String get generateIdentifierTooltip;

  /// No description provided for @invalidIdentifierFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format (E.g.: RC000001)'**
  String get invalidIdentifierFormat;

  /// No description provided for @scientificNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Scientific name is required'**
  String get scientificNameRequired;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Category is required'**
  String get categoryRequired;

  /// No description provided for @possibleDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicates:'**
  String get possibleDuplicates;

  /// No description provided for @collectedOn.
  ///
  /// In en, this message translates to:
  /// **'Collected on {date}'**
  String collectedOn(String date);

  /// No description provided for @morphology.
  ///
  /// In en, this message translates to:
  /// **'Morphology'**
  String get morphology;

  /// No description provided for @root.
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get root;

  /// No description provided for @stem.
  ///
  /// In en, this message translates to:
  /// **'Stem'**
  String get stem;

  /// No description provided for @stemBarkType.
  ///
  /// In en, this message translates to:
  /// **'Bark type'**
  String get stemBarkType;

  /// No description provided for @stemBarkTypeHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: smooth, rough, fissured...'**
  String get stemBarkTypeHint;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @stemColorHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: brown, gray, green...'**
  String get stemColorHint;

  /// No description provided for @sizeHeight.
  ///
  /// In en, this message translates to:
  /// **'Size (height)'**
  String get sizeHeight;

  /// No description provided for @circumference.
  ///
  /// In en, this message translates to:
  /// **'Circumference'**
  String get circumference;

  /// No description provided for @sapPresence.
  ///
  /// In en, this message translates to:
  /// **'Sap presence'**
  String get sapPresence;

  /// No description provided for @sapPresenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Does the plant exude sap?'**
  String get sapPresenceSubtitle;

  /// No description provided for @sapDescription.
  ///
  /// In en, this message translates to:
  /// **'Sap description'**
  String get sapDescription;

  /// No description provided for @sapDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the sap (color, consistency, odor...)'**
  String get sapDescriptionHint;

  /// No description provided for @leaf.
  ///
  /// In en, this message translates to:
  /// **'Leaf'**
  String get leaf;

  /// No description provided for @sheathLabel.
  ///
  /// In en, this message translates to:
  /// **'Sheath'**
  String get sheathLabel;

  /// No description provided for @sheathHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the sheath...'**
  String get sheathHint;

  /// No description provided for @petioleLabel.
  ///
  /// In en, this message translates to:
  /// **'Petiole'**
  String get petioleLabel;

  /// No description provided for @petioleHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the petiole...'**
  String get petioleHint;

  /// No description provided for @bladeLabel.
  ///
  /// In en, this message translates to:
  /// **'Blade'**
  String get bladeLabel;

  /// No description provided for @bladeHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the blade...'**
  String get bladeHint;

  /// No description provided for @flower.
  ///
  /// In en, this message translates to:
  /// **'Flower'**
  String get flower;

  /// No description provided for @inflorescenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Inflorescence'**
  String get inflorescenceLabel;

  /// No description provided for @inflorescenceHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the inflorescence...'**
  String get inflorescenceHint;

  /// No description provided for @flowerColorHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: white, yellow, pink...'**
  String get flowerColorHint;

  /// No description provided for @fruitLabel.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get fruitLabel;

  /// No description provided for @fruitColorHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: green, red, yellow...'**
  String get fruitColorHint;

  /// No description provided for @shapeLabel.
  ///
  /// In en, this message translates to:
  /// **'Shape'**
  String get shapeLabel;

  /// No description provided for @fruitShapeHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: spherical, elongated, flat...'**
  String get fruitShapeHint;

  /// No description provided for @seedLabel.
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get seedLabel;

  /// No description provided for @seedColorHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: brown, black, white...'**
  String get seedColorHint;

  /// No description provided for @seedShapeHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: oval, round, winged...'**
  String get seedShapeHint;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe...'**
  String get descriptionHint;

  /// No description provided for @sizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sizeLabel;

  /// No description provided for @sizeHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: 2.5'**
  String get sizeHint;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @photoGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGallery;

  /// No description provided for @noPhotosFound.
  ///
  /// In en, this message translates to:
  /// **'No photos found'**
  String get noPhotosFound;

  /// No description provided for @sortDateDesc.
  ///
  /// In en, this message translates to:
  /// **'Date (Newest)'**
  String get sortDateDesc;

  /// No description provided for @sortDateAsc.
  ///
  /// In en, this message translates to:
  /// **'Date (Oldest)'**
  String get sortDateAsc;

  /// No description provided for @sortByPlantName.
  ///
  /// In en, this message translates to:
  /// **'Plant name'**
  String get sortByPlantName;

  /// No description provided for @activeFilters.
  ///
  /// In en, this message translates to:
  /// **'Active filters: {filters}'**
  String activeFilters(String filters);

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearFilters;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @observations.
  ///
  /// In en, this message translates to:
  /// **'Observations'**
  String get observations;

  /// No description provided for @suggestionWithName.
  ///
  /// In en, this message translates to:
  /// **'Suggestion: {name}'**
  String suggestionWithName(String name);

  /// No description provided for @rootDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the root...'**
  String get rootDescriptionHint;

  /// No description provided for @stemDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the stem...'**
  String get stemDescriptionHint;

  /// No description provided for @leafDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'General description of the leaf...'**
  String get leafDescriptionHint;

  /// No description provided for @flowerDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'General description of the flower...'**
  String get flowerDescriptionHint;

  /// No description provided for @fruitDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'General description of the fruit...'**
  String get fruitDescriptionHint;

  /// No description provided for @seedDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'General description of the seed...'**
  String get seedDescriptionHint;

  /// No description provided for @metadata.
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get metadata;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get createdAt;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @contributor.
  ///
  /// In en, this message translates to:
  /// **'Contributor'**
  String get contributor;

  /// No description provided for @plantDeleted.
  ///
  /// In en, this message translates to:
  /// **'Plant deleted'**
  String get plantDeleted;

  /// No description provided for @measurementHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: 2.5'**
  String get measurementHint;

  /// No description provided for @editMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Edit Measurement'**
  String get editMeasurement;

  /// No description provided for @measurementDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get measurementDescriptionRequired;

  /// No description provided for @measurementDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Height, Width, Diameter'**
  String get measurementDescriptionHint;

  /// No description provided for @measurementValueRequired.
  ///
  /// In en, this message translates to:
  /// **'Value *'**
  String get measurementValueRequired;

  /// No description provided for @measurementValueHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: 15.5'**
  String get measurementValueHint;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get enterDescription;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Please enter a value'**
  String get enterValue;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @negativeValue.
  ///
  /// In en, this message translates to:
  /// **'Value cannot be negative'**
  String get negativeValue;

  /// No description provided for @valueTooBig.
  ///
  /// In en, this message translates to:
  /// **'Value too large (maximum: 999999)'**
  String get valueTooBig;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @relatedPlants.
  ///
  /// In en, this message translates to:
  /// **'Related Plants'**
  String get relatedPlants;

  /// No description provided for @sameGenusOrNearbyLocation.
  ///
  /// In en, this message translates to:
  /// **'Same genus or nearby location'**
  String get sameGenusOrNearbyLocation;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @nPhotos.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{photo} other{photos}}'**
  String nPhotos(int count);

  /// No description provided for @nMeasurements.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{measurement} other{measurements}}'**
  String nMeasurements(int count);

  /// No description provided for @plantDeletedName.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String plantDeletedName(String name);

  /// No description provided for @errorLoadingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Error loading photos: {error}'**
  String errorLoadingPhotos(String error);

  /// No description provided for @dateFilter.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateFilter;

  /// No description provided for @quickCapture.
  ///
  /// In en, this message translates to:
  /// **'Quick Capture'**
  String get quickCapture;

  /// No description provided for @quickCaptureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rapid field recording'**
  String get quickCaptureSubtitle;

  /// No description provided for @photoAdded.
  ///
  /// In en, this message translates to:
  /// **'Photo added'**
  String get photoAdded;

  /// No description provided for @gpsAcquired.
  ///
  /// In en, this message translates to:
  /// **'GPS acquired'**
  String get gpsAcquired;

  /// No description provided for @gpsAcquiring.
  ///
  /// In en, this message translates to:
  /// **'Acquiring GPS...'**
  String get gpsAcquiring;

  /// No description provided for @gpsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to get GPS'**
  String get gpsFailed;

  /// No description provided for @savedAsDraftSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved as draft'**
  String get savedAsDraftSuccess;

  /// No description provided for @quickNotes.
  ///
  /// In en, this message translates to:
  /// **'Quick notes'**
  String get quickNotes;

  /// No description provided for @quickNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Field observations...'**
  String get quickNotesHint;

  /// No description provided for @environmentalData.
  ///
  /// In en, this message translates to:
  /// **'Environmental Data'**
  String get environmentalData;

  /// No description provided for @altitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude (m)'**
  String get altitude;

  /// No description provided for @altitudeHint.
  ///
  /// In en, this message translates to:
  /// **'Meters above sea level'**
  String get altitudeHint;

  /// No description provided for @temperatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Temperature (°C)'**
  String get temperatureLabel;

  /// No description provided for @temperatureHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 25.5'**
  String get temperatureHint;

  /// No description provided for @humidityLabel.
  ///
  /// In en, this message translates to:
  /// **'Humidity (%)'**
  String get humidityLabel;

  /// No description provided for @humidityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 70'**
  String get humidityHint;

  /// No description provided for @weatherCondition.
  ///
  /// In en, this message translates to:
  /// **'Weather condition'**
  String get weatherCondition;

  /// No description provided for @weatherSunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get weatherSunny;

  /// No description provided for @weatherCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCloudy;

  /// No description provided for @weatherOvercast.
  ///
  /// In en, this message translates to:
  /// **'Overcast'**
  String get weatherOvercast;

  /// No description provided for @weatherRainy.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get weatherRainy;

  /// No description provided for @weatherStormy.
  ///
  /// In en, this message translates to:
  /// **'Stormy'**
  String get weatherStormy;

  /// No description provided for @weatherFoggy.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get weatherFoggy;

  /// No description provided for @weatherWindy.
  ///
  /// In en, this message translates to:
  /// **'Windy'**
  String get weatherWindy;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind speed (km/h)'**
  String get windSpeed;

  /// No description provided for @windSpeedHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15'**
  String get windSpeedHint;

  /// No description provided for @selectMode.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectMode;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @nSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String nSelected(int count);

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get deleteSelected;

  /// No description provided for @exportSelected.
  ///
  /// In en, this message translates to:
  /// **'Export Selected'**
  String get exportSelected;

  /// No description provided for @confirmDeleteCount.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} plant(s)?'**
  String confirmDeleteCount(int count);

  /// No description provided for @nPlantsDeleted.
  ///
  /// In en, this message translates to:
  /// **'{count} plant(s) deleted'**
  String nPlantsDeleted(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
