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

  /// No description provided for @scientificNameBinomialHint.
  ///
  /// In en, this message translates to:
  /// **'Genus species'**
  String get scientificNameBinomialHint;

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

  /// No description provided for @taxonAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get taxonAuthor;

  /// No description provided for @taxonStatus.
  ///
  /// In en, this message translates to:
  /// **'Taxonomic Status'**
  String get taxonStatus;

  /// No description provided for @taxonSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search scientific name via POWO'**
  String get taxonSearchHint;

  /// No description provided for @taxonOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Suggestions use online search and fall back to local cache offline'**
  String get taxonOfflineHint;

  /// No description provided for @taxonStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get taxonStatusAccepted;

  /// No description provided for @taxonStatusSynonym.
  ///
  /// In en, this message translates to:
  /// **'Synonym'**
  String get taxonStatusSynonym;

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

  /// No description provided for @categorySamambaia.
  ///
  /// In en, this message translates to:
  /// **'Fern'**
  String get categorySamambaia;

  /// No description provided for @categoryErva.
  ///
  /// In en, this message translates to:
  /// **'Herb'**
  String get categoryErva;

  /// No description provided for @categorySemiArbusto.
  ///
  /// In en, this message translates to:
  /// **'Subshrub'**
  String get categorySemiArbusto;

  /// No description provided for @categoryArbusto.
  ///
  /// In en, this message translates to:
  /// **'Shrub'**
  String get categoryArbusto;

  /// No description provided for @categoryArvore.
  ///
  /// In en, this message translates to:
  /// **'Tree'**
  String get categoryArvore;

  /// No description provided for @categoryErvaTrepadeira.
  ///
  /// In en, this message translates to:
  /// **'Climbing herb'**
  String get categoryErvaTrepadeira;

  /// No description provided for @categoryErvaEpifita.
  ///
  /// In en, this message translates to:
  /// **'Epiphytic herb'**
  String get categoryErvaEpifita;

  /// No description provided for @categoryHemiepifita.
  ///
  /// In en, this message translates to:
  /// **'Hemiepiphyte'**
  String get categoryHemiepifita;

  /// No description provided for @categoryProstrada.
  ///
  /// In en, this message translates to:
  /// **'Prostrate'**
  String get categoryProstrada;

  /// No description provided for @categoryRastejante.
  ///
  /// In en, this message translates to:
  /// **'Creeping'**
  String get categoryRastejante;

  /// No description provided for @categoryPlantaRupicola.
  ///
  /// In en, this message translates to:
  /// **'Rupicolous plant'**
  String get categoryPlantaRupicola;

  /// No description provided for @categoryCiofila.
  ///
  /// In en, this message translates to:
  /// **'Sciophilous'**
  String get categoryCiofila;

  /// No description provided for @categoryEpilitica.
  ///
  /// In en, this message translates to:
  /// **'Epilithic'**
  String get categoryEpilitica;

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

  /// No description provided for @identifyFamilyWithKey.
  ///
  /// In en, this message translates to:
  /// **'Identify family with dichotomous key'**
  String get identifyFamilyWithKey;

  /// No description provided for @dichotomousKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Dichotomous key'**
  String get dichotomousKeyTitle;

  /// No description provided for @dichotomousKeyIntro.
  ///
  /// In en, this message translates to:
  /// **'Answer each question using characters visible in the field. The key starts broad and narrows to a suggested family.'**
  String get dichotomousKeyIntro;

  /// No description provided for @dichotomousKeyHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get dichotomousKeyHowToUse;

  /// No description provided for @dichotomousKeyGeneralBranch.
  ///
  /// In en, this message translates to:
  /// **'General key'**
  String get dichotomousKeyGeneralBranch;

  /// No description provided for @dichotomousKeyCurrentBranch.
  ///
  /// In en, this message translates to:
  /// **'Current branch: {family}'**
  String dichotomousKeyCurrentBranch(String family);

  /// No description provided for @dichotomousKeyTrail.
  ///
  /// In en, this message translates to:
  /// **'Decision trail'**
  String get dichotomousKeyTrail;

  /// No description provided for @dichotomousKeyBackStep.
  ///
  /// In en, this message translates to:
  /// **'Back one step'**
  String get dichotomousKeyBackStep;

  /// No description provided for @dichotomousKeyRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart key'**
  String get dichotomousKeyRestart;

  /// No description provided for @dichotomousKeySuggestedFamily.
  ///
  /// In en, this message translates to:
  /// **'Suggested family'**
  String get dichotomousKeySuggestedFamily;

  /// No description provided for @dichotomousKeyUseFamily.
  ///
  /// In en, this message translates to:
  /// **'Use this family'**
  String get dichotomousKeyUseFamily;

  /// No description provided for @dichotomousKeyQuestionCounter.
  ///
  /// In en, this message translates to:
  /// **'Step {step}'**
  String dichotomousKeyQuestionCounter(int step);

  /// No description provided for @dichotomousKeyResultHelp.
  ///
  /// In en, this message translates to:
  /// **'Use the suggestion below to fill the family field of the current record.'**
  String get dichotomousKeyResultHelp;

  /// No description provided for @dichotomousKeyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading dichotomous key: {error}'**
  String dichotomousKeyLoadError(String error);

  /// No description provided for @dichotomousKeyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No dichotomous keys available.'**
  String get dichotomousKeyEmpty;

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

  /// No description provided for @fullBackup.
  ///
  /// In en, this message translates to:
  /// **'Full Backup'**
  String get fullBackup;

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

  /// No description provided for @inaturalist.
  ///
  /// In en, this message translates to:
  /// **'iNaturalist'**
  String get inaturalist;

  /// No description provided for @inaturalistAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to iNaturalist'**
  String get inaturalistAuthTitle;

  /// No description provided for @inaturalistTokenSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal access token'**
  String get inaturalistTokenSetupTitle;

  /// No description provided for @inaturalistTokenSetupDescription.
  ///
  /// In en, this message translates to:
  /// **'Use a personal iNaturalist token first. You can generate it in your iNaturalist account and paste it here to enable observation uploads.'**
  String get inaturalistTokenSetupDescription;

  /// No description provided for @inaturalistOpenTokenPage.
  ///
  /// In en, this message translates to:
  /// **'Open token page'**
  String get inaturalistOpenTokenPage;

  /// No description provided for @inaturalistUsername.
  ///
  /// In en, this message translates to:
  /// **'iNaturalist username'**
  String get inaturalistUsername;

  /// No description provided for @inaturalistUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Optional username for display'**
  String get inaturalistUsernameHint;

  /// No description provided for @inaturalistAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Access token'**
  String get inaturalistAccessToken;

  /// No description provided for @inaturalistAccessTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Paste your iNaturalist token'**
  String get inaturalistAccessTokenHint;

  /// No description provided for @inaturalistTokenHelp.
  ///
  /// In en, this message translates to:
  /// **'Your token is stored locally on this device and used only for sending observations.'**
  String get inaturalistTokenHelp;

  /// No description provided for @inaturalistSaveCredentials.
  ///
  /// In en, this message translates to:
  /// **'Save iNaturalist credentials'**
  String get inaturalistSaveCredentials;

  /// No description provided for @inaturalistClearCredentials.
  ///
  /// In en, this message translates to:
  /// **'Clear iNaturalist credentials'**
  String get inaturalistClearCredentials;

  /// No description provided for @inaturalistCredentialsSaved.
  ///
  /// In en, this message translates to:
  /// **'iNaturalist credentials saved'**
  String get inaturalistCredentialsSaved;

  /// No description provided for @inaturalistCredentialsCleared.
  ///
  /// In en, this message translates to:
  /// **'iNaturalist credentials cleared'**
  String get inaturalistCredentialsCleared;

  /// No description provided for @inaturalistConfigured.
  ///
  /// In en, this message translates to:
  /// **'Configured for @{username}'**
  String inaturalistConfigured(String username);

  /// No description provided for @inaturalistNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get inaturalistNotConfigured;

  /// No description provided for @sendToInaturalist.
  ///
  /// In en, this message translates to:
  /// **'Send to iNaturalist'**
  String get sendToInaturalist;

  /// No description provided for @sendSelectedToInaturalist.
  ///
  /// In en, this message translates to:
  /// **'Send selected records to iNaturalist'**
  String get sendSelectedToInaturalist;

  /// No description provided for @inaturalistAlreadySent.
  ///
  /// In en, this message translates to:
  /// **'Already sent to iNaturalist'**
  String get inaturalistAlreadySent;

  /// No description provided for @inaturalistObservationId.
  ///
  /// In en, this message translates to:
  /// **'Observation ID: {id}'**
  String inaturalistObservationId(String id);

  /// No description provided for @inaturalistSyncBadge.
  ///
  /// In en, this message translates to:
  /// **'📤 iNat'**
  String get inaturalistSyncBadge;

  /// No description provided for @inaturalistPushSuccess.
  ///
  /// In en, this message translates to:
  /// **'Observation sent to iNaturalist'**
  String get inaturalistPushSuccess;

  /// No description provided for @inaturalistBulkSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} record(s) sent to iNaturalist'**
  String inaturalistBulkSuccess(int count);

  /// No description provided for @inaturalistPushError.
  ///
  /// In en, this message translates to:
  /// **'Failed to send to iNaturalist: {error}'**
  String inaturalistPushError(String error);

  /// No description provided for @inaturalistRequiresToken.
  ///
  /// In en, this message translates to:
  /// **'Configure your iNaturalist token in Settings before sending records.'**
  String get inaturalistRequiresToken;

  /// No description provided for @inaturalistProgress.
  ///
  /// In en, this message translates to:
  /// **'Sending {current} of {total}'**
  String inaturalistProgress(int current, int total);

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

  /// No description provided for @collectionTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Collection Templates'**
  String get collectionTemplatesTitle;

  /// No description provided for @collectionTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage biome-based presets for smart prefill'**
  String get collectionTemplatesSubtitle;

  /// No description provided for @newCollectionTemplate.
  ///
  /// In en, this message translates to:
  /// **'New Template'**
  String get newCollectionTemplate;

  /// No description provided for @editCollectionTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit Template'**
  String get editCollectionTemplate;

  /// No description provided for @duplicateCollectionTemplate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate template'**
  String get duplicateCollectionTemplate;

  /// No description provided for @collectionTemplateSaved.
  ///
  /// In en, this message translates to:
  /// **'Template saved successfully'**
  String get collectionTemplateSaved;

  /// No description provided for @collectionTemplateDeleted.
  ///
  /// In en, this message translates to:
  /// **'Template deleted successfully'**
  String get collectionTemplateDeleted;

  /// No description provided for @collectionTemplateDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Template duplicated successfully'**
  String get collectionTemplateDuplicated;

  /// No description provided for @collectionTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get collectionTemplateName;

  /// No description provided for @collectionTemplateNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a template name'**
  String get collectionTemplateNameRequired;

  /// No description provided for @collectionTemplateBiome.
  ///
  /// In en, this message translates to:
  /// **'Biome'**
  String get collectionTemplateBiome;

  /// No description provided for @collectionTemplateHabitat.
  ///
  /// In en, this message translates to:
  /// **'Default habitat'**
  String get collectionTemplateHabitat;

  /// No description provided for @collectionTemplateVegetationType.
  ///
  /// In en, this message translates to:
  /// **'Default vegetation type'**
  String get collectionTemplateVegetationType;

  /// No description provided for @collectionTemplateTopography.
  ///
  /// In en, this message translates to:
  /// **'Default topography'**
  String get collectionTemplateTopography;

  /// No description provided for @collectionTemplateSubstrate.
  ///
  /// In en, this message translates to:
  /// **'Default substrate'**
  String get collectionTemplateSubstrate;

  /// No description provided for @collectionTemplateNotes.
  ///
  /// In en, this message translates to:
  /// **'Frequent notes'**
  String get collectionTemplateNotes;

  /// No description provided for @useCollectionTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Use template?'**
  String get useCollectionTemplateTitle;

  /// No description provided for @useCollectionTemplateBody.
  ///
  /// In en, this message translates to:
  /// **'We found the template \"{templateName}\" for the {biomeName} biome. Do you want to prefill the form?'**
  String useCollectionTemplateBody(String templateName, String biomeName);

  /// No description provided for @useCollectionTemplateAction.
  ///
  /// In en, this message translates to:
  /// **'Use template'**
  String get useCollectionTemplateAction;

  /// No description provided for @collectionTemplateApplied.
  ///
  /// In en, this message translates to:
  /// **'Template \"{templateName}\" applied'**
  String collectionTemplateApplied(String templateName);

  /// No description provided for @deleteCollectionTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete template'**
  String get deleteCollectionTemplateTitle;

  /// No description provided for @deleteCollectionTemplateBody.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the template \"{templateName}\"?'**
  String deleteCollectionTemplateBody(String templateName);

  /// No description provided for @templateCopyName.
  ///
  /// In en, this message translates to:
  /// **'Copy of {name}'**
  String templateCopyName(String name);

  /// No description provided for @biomeCerrado.
  ///
  /// In en, this message translates to:
  /// **'Cerrado'**
  String get biomeCerrado;

  /// No description provided for @biomeMataAtlantica.
  ///
  /// In en, this message translates to:
  /// **'Atlantic Forest'**
  String get biomeMataAtlantica;

  /// No description provided for @biomeAmazonia.
  ///
  /// In en, this message translates to:
  /// **'Amazon'**
  String get biomeAmazonia;

  /// No description provided for @biomeCaatinga.
  ///
  /// In en, this message translates to:
  /// **'Caatinga'**
  String get biomeCaatinga;

  /// No description provided for @biomePampa.
  ///
  /// In en, this message translates to:
  /// **'Pampa'**
  String get biomePampa;

  /// No description provided for @biomePantanal.
  ///
  /// In en, this message translates to:
  /// **'Pantanal'**
  String get biomePantanal;

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

  /// No description provided for @appUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available: {version}'**
  String appUpdateAvailable(String version);

  /// No description provided for @appUpdateDownloadAction.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get appUpdateDownloadAction;

  /// No description provided for @appUpdateDismissAction.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get appUpdateDismissAction;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @checkForUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Look for a new Android APK on GitHub'**
  String get checkForUpdatesSubtitle;

  /// No description provided for @noUpdatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'You are using the latest version.'**
  String get noUpdatesAvailable;

  /// No description provided for @updateCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not check for updates.'**
  String get updateCheckFailed;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current version: {version}'**
  String currentVersion(String version);

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

  /// No description provided for @plantNetIdentifyButton.
  ///
  /// In en, this message translates to:
  /// **'Identify with PlantNet'**
  String get plantNetIdentifyButton;

  /// No description provided for @plantNetSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'PlantNet suggestions'**
  String get plantNetSuggestionsTitle;

  /// No description provided for @plantNetSelectSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Select a suggestion to fill the fields automatically'**
  String get plantNetSelectSuggestion;

  /// No description provided for @plantNetNoResults.
  ///
  /// In en, this message translates to:
  /// **'No suggestions found for these photos'**
  String get plantNetNoResults;

  /// No description provided for @plantNetConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {score}%'**
  String plantNetConfidence(String score);

  /// No description provided for @plantNetApiKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'PlantNet API Key'**
  String get plantNetApiKeyTitle;

  /// No description provided for @plantNetApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'PlantNet API key'**
  String get plantNetApiKeyLabel;

  /// No description provided for @plantNetApiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Paste your API key here'**
  String get plantNetApiKeyHint;

  /// No description provided for @plantNetApiKeyHelper.
  ///
  /// In en, this message translates to:
  /// **'Required to identify species from photos'**
  String get plantNetApiKeyHelper;

  /// No description provided for @plantNetApiKeyConfigured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get plantNetApiKeyConfigured;

  /// No description provided for @plantNetApiKeyNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get plantNetApiKeyNotConfigured;

  /// No description provided for @plantNetMissingApiKey.
  ///
  /// In en, this message translates to:
  /// **'Configure the PlantNet API key in settings to use image identification'**
  String get plantNetMissingApiKey;

  /// No description provided for @plantNetNoInternet.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to identify species with PlantNet'**
  String get plantNetNoInternet;

  /// No description provided for @plantNetRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'PlantNet request failed. Please try again.'**
  String get plantNetRequestFailed;

  /// No description provided for @plantNetInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'PlantNet returned an unexpected response. Please try again.'**
  String get plantNetInvalidResponse;

  /// No description provided for @plantNetIdentifying.
  ///
  /// In en, this message translates to:
  /// **'Identifying species...'**
  String get plantNetIdentifying;

  /// No description provided for @plantNetIdentificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to identify species: {error}'**
  String plantNetIdentificationFailed(String error);

  /// No description provided for @plantNetSuggestionApplied.
  ///
  /// In en, this message translates to:
  /// **'PlantNet suggestion applied'**
  String get plantNetSuggestionApplied;

  /// No description provided for @ocrScanLabel.
  ///
  /// In en, this message translates to:
  /// **'Label digitization'**
  String get ocrScanLabel;

  /// No description provided for @ocrScanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan label'**
  String get ocrScanButton;

  /// No description provided for @ocrReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review identified fields'**
  String get ocrReviewTitle;

  /// No description provided for @ocrConfirmFill.
  ///
  /// In en, this message translates to:
  /// **'Fill form'**
  String get ocrConfirmFill;

  /// No description provided for @ocrNoTextFound.
  ///
  /// In en, this message translates to:
  /// **'No readable text was found on the label'**
  String get ocrNoTextFound;

  /// No description provided for @ocrProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing label...'**
  String get ocrProcessing;

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
  /// **'Enter a valid number (≥ 0)'**
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

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

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

  /// No description provided for @weatherNotes.
  ///
  /// In en, this message translates to:
  /// **'Weather notes'**
  String get weatherNotes;

  /// No description provided for @weatherNotesHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. sunrise, sunset and WMO code'**
  String get weatherNotesHint;

  /// No description provided for @moonPhase.
  ///
  /// In en, this message translates to:
  /// **'Moon phase'**
  String get moonPhase;

  /// No description provided for @moonPhaseNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get moonPhaseNew;

  /// No description provided for @moonPhaseWaxing.
  ///
  /// In en, this message translates to:
  /// **'Waxing'**
  String get moonPhaseWaxing;

  /// No description provided for @moonPhaseFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get moonPhaseFull;

  /// No description provided for @moonPhaseWaning.
  ///
  /// In en, this message translates to:
  /// **'Waning'**
  String get moonPhaseWaning;

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

  /// No description provided for @municipality.
  ///
  /// In en, this message translates to:
  /// **'Municipality'**
  String get municipality;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @gpsTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'GPS Track'**
  String get gpsTrackTitle;

  /// No description provided for @startTrack.
  ///
  /// In en, this message translates to:
  /// **'Start Track'**
  String get startTrack;

  /// No description provided for @pauseTrack.
  ///
  /// In en, this message translates to:
  /// **'Pause Track'**
  String get pauseTrack;

  /// No description provided for @gpsTrackActive.
  ///
  /// In en, this message translates to:
  /// **'Tracking active'**
  String get gpsTrackActive;

  /// No description provided for @gpsTrackPaused.
  ///
  /// In en, this message translates to:
  /// **'Tracking paused'**
  String get gpsTrackPaused;

  /// No description provided for @gpsTrackPoints.
  ///
  /// In en, this message translates to:
  /// **'{count} points recorded'**
  String gpsTrackPoints(int count);

  /// No description provided for @coordsValidationTitle.
  ///
  /// In en, this message translates to:
  /// **'Coordinate check'**
  String get coordsValidationTitle;

  /// No description provided for @coordsValidationWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ The coordinates may be outside {municipality}. Do you want to continue?'**
  String coordsValidationWarning(String municipality);

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @rainModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Rain Mode'**
  String get rainModeTitle;

  /// No description provided for @rainModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add extra protection for destructive actions on wet screens'**
  String get rainModeSubtitle;

  /// No description provided for @rainModeBadge.
  ///
  /// In en, this message translates to:
  /// **'Rain mode active'**
  String get rainModeBadge;

  /// No description provided for @enableRainModeQuickAction.
  ///
  /// In en, this message translates to:
  /// **'Enable rain mode'**
  String get enableRainModeQuickAction;

  /// No description provided for @disableRainModeQuickAction.
  ///
  /// In en, this message translates to:
  /// **'Disable rain mode'**
  String get disableRainModeQuickAction;

  /// No description provided for @rainModeEnabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Rain mode enabled'**
  String get rainModeEnabledMessage;

  /// No description provided for @rainModeDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Rain mode disabled'**
  String get rainModeDisabledMessage;

  /// No description provided for @rainModeOverlayTitle.
  ///
  /// In en, this message translates to:
  /// **'Rain mode protection'**
  String get rainModeOverlayTitle;

  /// No description provided for @rainModeOverlayMessage.
  ///
  /// In en, this message translates to:
  /// **'Wet screens can trigger ghost touches. Unlock this action intentionally before continuing.'**
  String get rainModeOverlayMessage;

  /// No description provided for @rainModeUnlockHold.
  ///
  /// In en, this message translates to:
  /// **'Press and hold the drop for 2 seconds'**
  String get rainModeUnlockHold;

  /// No description provided for @rainModeUnlockTap.
  ///
  /// In en, this message translates to:
  /// **'or tap the drop 3 times'**
  String get rainModeUnlockTap;

  /// No description provided for @rainModeDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm destructive action'**
  String get rainModeDeleteConfirmTitle;

  /// No description provided for @rainModeArchiveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive session?'**
  String get rainModeArchiveConfirmTitle;

  /// No description provided for @rainModeArchiveConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Archiving hides this session from active work, but keeps the data stored.'**
  String get rainModeArchiveConfirmMessage;

  /// No description provided for @rainModeOverwriteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm overwrite'**
  String get rainModeOverwriteConfirmTitle;

  /// No description provided for @rainModeExitWithoutSavingTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving?'**
  String get rainModeExitWithoutSavingTitle;

  /// No description provided for @rainModeExitWithoutSavingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your unsaved changes will be lost if you leave this screen now.'**
  String get rainModeExitWithoutSavingMessage;

  /// No description provided for @rainModeDiscardChanges.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving'**
  String get rainModeDiscardChanges;

  /// No description provided for @rainModeCountdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Action available in {seconds}s'**
  String rainModeCountdownLabel(int seconds);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @locationAutoFilled.
  ///
  /// In en, this message translates to:
  /// **'Location filled automatically'**
  String get locationAutoFilled;

  /// No description provided for @noConnectionManualFill.
  ///
  /// In en, this message translates to:
  /// **'No connection — fill in manually'**
  String get noConnectionManualFill;

  /// No description provided for @getCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Get Current Location'**
  String get getCurrentLocation;

  /// No description provided for @tapToShowMap.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Get Current Location\" to show the map'**
  String get tapToShowMap;

  /// No description provided for @tapToAdjustMarker.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to adjust the marker position'**
  String get tapToAdjustMarker;

  /// No description provided for @enableLocationServicesMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services to record plant locations'**
  String get enableLocationServicesMessage;

  /// No description provided for @sunriseLabel.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunriseLabel;

  /// No description provided for @sunsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunsetLabel;

  /// No description provided for @weatherCode.
  ///
  /// In en, this message translates to:
  /// **'WMO code {code}'**
  String weatherCode(int code);

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

  /// No description provided for @collectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Collection Info'**
  String get collectionInfo;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @collectorNumber.
  ///
  /// In en, this message translates to:
  /// **'Collector Number'**
  String get collectorNumber;

  /// No description provided for @collectorNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Collector\'s sequential number (e.g. 1234)'**
  String get collectorNumberHint;

  /// No description provided for @coCollectors.
  ///
  /// In en, this message translates to:
  /// **'Co-collectors'**
  String get coCollectors;

  /// No description provided for @coCollectorsHint.
  ///
  /// In en, this message translates to:
  /// **'Separate names with commas or new lines'**
  String get coCollectorsHint;

  /// No description provided for @numberOfIndividuals.
  ///
  /// In en, this message translates to:
  /// **'Number of Individuals'**
  String get numberOfIndividuals;

  /// No description provided for @numberOfIndividualsHint.
  ///
  /// In en, this message translates to:
  /// **'How many specimens observed'**
  String get numberOfIndividualsHint;

  /// No description provided for @determinationQualifier.
  ///
  /// In en, this message translates to:
  /// **'Taxonomic Certainty'**
  String get determinationQualifier;

  /// No description provided for @determinationQualifierHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. cf., aff., ?'**
  String get determinationQualifierHint;

  /// No description provided for @habitatDetails.
  ///
  /// In en, this message translates to:
  /// **'Habitat Details'**
  String get habitatDetails;

  /// No description provided for @substrate.
  ///
  /// In en, this message translates to:
  /// **'Substrate / Soil'**
  String get substrate;

  /// No description provided for @substrateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. clay soil, rock, epiphyte, sand'**
  String get substrateHint;

  /// No description provided for @vegetationType.
  ///
  /// In en, this message translates to:
  /// **'Vegetation Type'**
  String get vegetationType;

  /// No description provided for @vegetationTypeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cerrado, Atlantic Forest, Caatinga, Restinga'**
  String get vegetationTypeHint;

  /// No description provided for @topography.
  ///
  /// In en, this message translates to:
  /// **'Topography'**
  String get topography;

  /// No description provided for @topographyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. slope, valley, hilltop, riparian, plateau'**
  String get topographyHint;

  /// No description provided for @associatedTaxa.
  ///
  /// In en, this message translates to:
  /// **'Associated Species'**
  String get associatedTaxa;

  /// No description provided for @associatedTaxaHint.
  ///
  /// In en, this message translates to:
  /// **'Other species found nearby (comma-separated)'**
  String get associatedTaxaHint;

  /// No description provided for @phenologicalState.
  ///
  /// In en, this message translates to:
  /// **'Phenological State'**
  String get phenologicalState;

  /// No description provided for @phenoFlowering.
  ///
  /// In en, this message translates to:
  /// **'Flowering'**
  String get phenoFlowering;

  /// No description provided for @phenoFruiting.
  ///
  /// In en, this message translates to:
  /// **'Fruiting'**
  String get phenoFruiting;

  /// No description provided for @phenoBudding.
  ///
  /// In en, this message translates to:
  /// **'Budding'**
  String get phenoBudding;

  /// No description provided for @phenoWithFruit.
  ///
  /// In en, this message translates to:
  /// **'With Fruit'**
  String get phenoWithFruit;

  /// No description provided for @phenoVegetative.
  ///
  /// In en, this message translates to:
  /// **'Vegetative'**
  String get phenoVegetative;

  /// No description provided for @phenoSterile.
  ///
  /// In en, this message translates to:
  /// **'Sterile'**
  String get phenoSterile;

  /// No description provided for @phenoUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get phenoUnknown;

  /// No description provided for @collectionMethod.
  ///
  /// In en, this message translates to:
  /// **'Collection Method'**
  String get collectionMethod;

  /// No description provided for @methodVoucherCollected.
  ///
  /// In en, this message translates to:
  /// **'Voucher Collected'**
  String get methodVoucherCollected;

  /// No description provided for @methodPhotoOnly.
  ///
  /// In en, this message translates to:
  /// **'Photo Only'**
  String get methodPhotoOnly;

  /// No description provided for @methodSterileMaterial.
  ///
  /// In en, this message translates to:
  /// **'Sterile Material'**
  String get methodSterileMaterial;

  /// No description provided for @methodLivingMaterial.
  ///
  /// In en, this message translates to:
  /// **'Living Material'**
  String get methodLivingMaterial;

  /// No description provided for @confirmAssignTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Assignment'**
  String get confirmAssignTitle;

  /// No description provided for @confirmAssignBody.
  ///
  /// In en, this message translates to:
  /// **'{count} identifier(s) will be assigned:'**
  String confirmAssignBody(int count);

  /// No description provided for @errorLoadingPlants2.
  ///
  /// In en, this message translates to:
  /// **'Error loading plants: {error}'**
  String errorLoadingPlants2(String error);

  /// No description provided for @errorGeneratingPreview.
  ///
  /// In en, this message translates to:
  /// **'Error generating preview: {error}'**
  String errorGeneratingPreview(String error);

  /// No description provided for @errorAssigningIdentifiers.
  ///
  /// In en, this message translates to:
  /// **'Error assigning identifiers: {error}'**
  String errorAssigningIdentifiers(String error);

  /// No description provided for @exportIdentifiersTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Identifiers'**
  String get exportIdentifiersTitle;

  /// No description provided for @exportFormatJson.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get exportFormatJson;

  /// No description provided for @exportFormatJsonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Structured, complete format'**
  String get exportFormatJsonSubtitle;

  /// No description provided for @exportFormatCsv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get exportFormatCsv;

  /// No description provided for @exportFormatCsvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Simple spreadsheet, compatible'**
  String get exportFormatCsvSubtitle;

  /// No description provided for @exportFormatExcel.
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get exportFormatExcel;

  /// No description provided for @exportFormatExcelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Excel spreadsheet with formatting'**
  String get exportFormatExcelSubtitle;

  /// No description provided for @exportCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export completed'**
  String get exportCompletedSuccess;

  /// No description provided for @errorExporting.
  ///
  /// In en, this message translates to:
  /// **'Error exporting: {error}'**
  String errorExporting(String error);

  /// No description provided for @errorImporting2.
  ///
  /// In en, this message translates to:
  /// **'Error importing: {error}'**
  String errorImporting2(String error);

  /// No description provided for @manageIdentifiersTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Identifiers'**
  String get manageIdentifiersTitle;

  /// No description provided for @assignIdentifiers.
  ///
  /// In en, this message translates to:
  /// **'Assign ({count})'**
  String assignIdentifiers(int count);

  /// No description provided for @assignSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Assign identifiers to existing plants'**
  String get assignSubtitle;

  /// No description provided for @syncErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync error'**
  String get syncErrorTitle;

  /// No description provided for @deleteSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSessionTitle;

  /// No description provided for @deleteSessionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteSessionConfirm;

  /// No description provided for @exportImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export & Import'**
  String get exportImportTitle;

  /// No description provided for @exportSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Export completed successfully!'**
  String get exportSuccessMsg;

  /// No description provided for @errorExportMsg.
  ///
  /// In en, this message translates to:
  /// **'Error exporting: {error}'**
  String errorExportMsg(String error);

  /// No description provided for @errorImportMsg.
  ///
  /// In en, this message translates to:
  /// **'Error importing: {error}'**
  String errorImportMsg(String error);

  /// No description provided for @errorTranscribeMsg.
  ///
  /// In en, this message translates to:
  /// **'Error transcribing: {error}'**
  String errorTranscribeMsg(String error);

  /// No description provided for @errorLocationMsg.
  ///
  /// In en, this message translates to:
  /// **'Error getting location: {error}'**
  String errorLocationMsg(String error);

  /// No description provided for @errorPhotoMsg.
  ///
  /// In en, this message translates to:
  /// **'Error taking photo: {error}'**
  String errorPhotoMsg(String error);

  /// No description provided for @errorPickPhotoMsg.
  ///
  /// In en, this message translates to:
  /// **'Error choosing photos: {error}'**
  String errorPickPhotoMsg(String error);

  /// No description provided for @errorSearchMsg.
  ///
  /// In en, this message translates to:
  /// **'Search error: {error}'**
  String errorSearchMsg(String error);

  /// No description provided for @errorDownloadMapMsg.
  ///
  /// In en, this message translates to:
  /// **'Error downloading: {error}'**
  String errorDownloadMapMsg(String error);

  /// No description provided for @errorClearCacheMsg.
  ///
  /// In en, this message translates to:
  /// **'Error clearing cache: {error}'**
  String errorClearCacheMsg(String error);

  /// No description provided for @downloadOfflineArea.
  ///
  /// In en, this message translates to:
  /// **'Download Offline Area'**
  String get downloadOfflineArea;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @clearCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCacheTitle;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearCacheConfirm;

  /// No description provided for @downloadNewAreaTooltip.
  ///
  /// In en, this message translates to:
  /// **'Download new area'**
  String get downloadNewAreaTooltip;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @errorsLabel.
  ///
  /// In en, this message translates to:
  /// **'Errors:'**
  String get errorsLabel;

  /// No description provided for @searchByLabel.
  ///
  /// In en, this message translates to:
  /// **'Search by:'**
  String get searchByLabel;

  /// No description provided for @searchByIdentifierHint.
  ///
  /// In en, this message translates to:
  /// **'Search by identifier (e.g. RC000001)...'**
  String get searchByIdentifierHint;

  /// No description provided for @searchPlantsHint.
  ///
  /// In en, this message translates to:
  /// **'Search plants...'**
  String get searchPlantsHint;

  /// No description provided for @autoDownloadTiles.
  ///
  /// In en, this message translates to:
  /// **'Download tiles automatically'**
  String get autoDownloadTiles;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncing2.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing2;

  /// No description provided for @syncCloud.
  ///
  /// In en, this message translates to:
  /// **'Sync your data in the cloud'**
  String get syncCloud;

  /// No description provided for @errorCalcNext.
  ///
  /// In en, this message translates to:
  /// **'Error calculating next'**
  String get errorCalcNext;

  /// No description provided for @excluir.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get excluir;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @unarchive.
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get unarchive;

  /// No description provided for @shareCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Code'**
  String get shareCodeTitle;

  /// No description provided for @shareWithUsersHint.
  ///
  /// In en, this message translates to:
  /// **'Share this code with other users:'**
  String get shareWithUsersHint;

  /// No description provided for @archivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedLabel;

  /// No description provided for @sharedLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get sharedLabel;

  /// No description provided for @importResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Result'**
  String get importResultTitle;

  /// No description provided for @importedLabel.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get importedLabel;

  /// No description provided for @updatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updatedLabel;

  /// No description provided for @skippedLabel.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skippedLabel;

  /// No description provided for @aboutFormats.
  ///
  /// In en, this message translates to:
  /// **'About Formats'**
  String get aboutFormats;

  /// No description provided for @exportBackupHint.
  ///
  /// In en, this message translates to:
  /// **'Export your plants for backup or sharing'**
  String get exportBackupHint;

  /// No description provided for @formatLabel.
  ///
  /// In en, this message translates to:
  /// **'Format:'**
  String get formatLabel;

  /// No description provided for @jsonFormatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete format with all data'**
  String get jsonFormatSubtitle;

  /// No description provided for @csvFormatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Simple spreadsheet (Excel, LibreOffice)'**
  String get csvFormatSubtitle;

  /// No description provided for @pdfFormatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visual report with photos and details'**
  String get pdfFormatSubtitle;

  /// No description provided for @darwinCoreFormatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'International standard for biodiversity'**
  String get darwinCoreFormatSubtitle;

  /// No description provided for @includeCollectionSessions.
  ///
  /// In en, this message translates to:
  /// **'Include collection sessions'**
  String get includeCollectionSessions;

  /// No description provided for @importFromJson.
  ///
  /// In en, this message translates to:
  /// **'Import plants from an exported JSON file'**
  String get importFromJson;

  /// No description provided for @importWarnMsg.
  ///
  /// In en, this message translates to:
  /// **'Existing plants will be updated. Only JSON files are supported.'**
  String get importWarnMsg;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @jsonFormatDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete format that preserves all data including photos, audio, measurements and metadata. Ideal for full backup and restore.'**
  String get jsonFormatDesc;

  /// No description provided for @csvFormatDesc.
  ///
  /// In en, this message translates to:
  /// **'Simple spreadsheet format that can be opened in Excel, LibreOffice or Google Sheets. Contains only basic data.'**
  String get csvFormatDesc;

  /// No description provided for @pdfFormatDesc.
  ///
  /// In en, this message translates to:
  /// **'Visual report format with photos, measurements and collection details. Ideal for printing or sharing as a document.'**
  String get pdfFormatDesc;

  /// No description provided for @darwinCoreDesc.
  ///
  /// In en, this message translates to:
  /// **'International standard for biodiversity data. Compatible with scientific portals such as GBIF and iNaturalist.'**
  String get darwinCoreDesc;

  /// No description provided for @offlineMapsTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Maps'**
  String get offlineMapsTitle;

  /// No description provided for @downloadOfflineAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Download Offline Area'**
  String get downloadOfflineAreaTitle;

  /// No description provided for @areaNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Area name'**
  String get areaNameLabel;

  /// No description provided for @zoomLevelsLabel.
  ///
  /// In en, this message translates to:
  /// **'Zoom levels: 8-15'**
  String get zoomLevelsLabel;

  /// No description provided for @downloadWarnMsg.
  ///
  /// In en, this message translates to:
  /// **'This may take a few minutes and use mobile data.'**
  String get downloadWarnMsg;

  /// No description provided for @downloadCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Download completed!'**
  String get downloadCompletedSuccess;

  /// No description provided for @cacheClearedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheClearedSuccess;

  /// No description provided for @clearCacheBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all offline maps?\n\nThis will free up space but you will need to be online to view maps.'**
  String get clearCacheBody;

  /// No description provided for @clearCacheConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearCacheConfirmBtn;

  /// No description provided for @clearCacheLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCacheLabel;

  /// No description provided for @userInitialsTitle.
  ///
  /// In en, this message translates to:
  /// **'User Initials'**
  String get userInitialsTitle;

  /// No description provided for @initialsLabel.
  ///
  /// In en, this message translates to:
  /// **'Initials'**
  String get initialsLabel;

  /// No description provided for @initialsHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: RC, ABC'**
  String get initialsHint;

  /// No description provided for @initialsHelper.
  ///
  /// In en, this message translates to:
  /// **'1-4 uppercase letters'**
  String get initialsHelper;

  /// No description provided for @lastRegistryNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Last Registry Number'**
  String get lastRegistryNumberTitle;

  /// No description provided for @numberLabel.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get numberLabel;

  /// No description provided for @numberHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: 0, 40, 1000'**
  String get numberHint;

  /// No description provided for @numberBetweenError.
  ///
  /// In en, this message translates to:
  /// **'Number must be between 0 and 999999'**
  String get numberBetweenError;

  /// No description provided for @nextRegistryWillUse.
  ///
  /// In en, this message translates to:
  /// **'Next registry will use: {next}'**
  String nextRegistryWillUse(int next);

  /// No description provided for @changeNumberWarning.
  ///
  /// In en, this message translates to:
  /// **'Changing this number will affect the next records created.'**
  String get changeNumberWarning;

  /// No description provided for @enterLastRegistryNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter the last registry number'**
  String get enterLastRegistryNumber;

  /// No description provided for @digitsOnly.
  ///
  /// In en, this message translates to:
  /// **'Enter digits only'**
  String get digitsOnly;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @loginToSync.
  ///
  /// In en, this message translates to:
  /// **'Log in to sync'**
  String get loginToSync;

  /// No description provided for @lastSync.
  ///
  /// In en, this message translates to:
  /// **'Last: {date}'**
  String lastSync(String date);

  /// No description provided for @neverSynced.
  ///
  /// In en, this message translates to:
  /// **'Never synced'**
  String get neverSynced;

  /// No description provided for @initialsCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Initials cannot be empty'**
  String get initialsCannotBeEmpty;

  /// No description provided for @initialsFormatError.
  ///
  /// In en, this message translates to:
  /// **'Use 1-4 uppercase letters'**
  String get initialsFormatError;

  /// No description provided for @numberCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Number cannot be empty'**
  String get numberCannotBeEmpty;

  /// No description provided for @numberTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Number too large (max: 999999)'**
  String get numberTooLarge;

  /// No description provided for @portugueseBR.
  ///
  /// In en, this message translates to:
  /// **'Português (BR)'**
  String get portugueseBR;

  /// No description provided for @mapProvider.
  ///
  /// In en, this message translates to:
  /// **'Map Provider'**
  String get mapProvider;

  /// No description provided for @selectMapProvider.
  ///
  /// In en, this message translates to:
  /// **'Select Provider'**
  String get selectMapProvider;

  /// No description provided for @mapboxSatellite.
  ///
  /// In en, this message translates to:
  /// **'Mapbox Satellite'**
  String get mapboxSatellite;

  /// No description provided for @mapCacheRadius.
  ///
  /// In en, this message translates to:
  /// **'Map Cache Radius'**
  String get mapCacheRadius;

  /// No description provided for @autoSaveInterval.
  ///
  /// In en, this message translates to:
  /// **'Auto-save Interval'**
  String get autoSaveInterval;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @nSeconds.
  ///
  /// In en, this message translates to:
  /// **'{n} seconds'**
  String nSeconds(int n);

  /// No description provided for @nMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n} minute(s)'**
  String nMinutes(int n);

  /// No description provided for @compressionQuality.
  ///
  /// In en, this message translates to:
  /// **'Compression Quality'**
  String get compressionQuality;

  /// No description provided for @preserveExifTitle.
  ///
  /// In en, this message translates to:
  /// **'Preserve EXIF Metadata'**
  String get preserveExifTitle;

  /// No description provided for @preserveExifSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep GPS and camera information'**
  String get preserveExifSubtitle;

  /// No description provided for @transcriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio Transcription'**
  String get transcriptionTitle;

  /// No description provided for @transcriptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Convert speech to text'**
  String get transcriptionSubtitle;

  /// No description provided for @transcriptionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Transcription Language'**
  String get transcriptionLanguage;

  /// No description provided for @audioQualityTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio Quality'**
  String get audioQualityTitle;

  /// No description provided for @audioQualityLow.
  ///
  /// In en, this message translates to:
  /// **'Low (smaller size)'**
  String get audioQualityLow;

  /// No description provided for @audioQualityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get audioQualityMedium;

  /// No description provided for @audioQualityHigh.
  ///
  /// In en, this message translates to:
  /// **'High (best quality)'**
  String get audioQualityHigh;

  /// No description provided for @audioQualityLowShort.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get audioQualityLowShort;

  /// No description provided for @audioQualityHighShort.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get audioQualityHighShort;

  /// No description provided for @paginationSize.
  ///
  /// In en, this message translates to:
  /// **'Items per Page'**
  String get paginationSize;

  /// No description provided for @nItems.
  ///
  /// In en, this message translates to:
  /// **'{n} items'**
  String nItems(int n);

  /// No description provided for @thumbnailCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail Cache'**
  String get thumbnailCacheTitle;

  /// No description provided for @thumbnailCacheSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Improve list performance'**
  String get thumbnailCacheSubtitle;

  /// No description provided for @autoGenerateTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-generate'**
  String get autoGenerateTitle;

  /// No description provided for @autoGenerateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create identifier when saving a record'**
  String get autoGenerateSubtitle;

  /// No description provided for @manageIdentifiersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Assign identifiers to existing plants'**
  String get manageIdentifiersSubtitle;

  /// No description provided for @nextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next: {id}'**
  String nextLabel(String id);

  /// No description provided for @lastSyncResult.
  ///
  /// In en, this message translates to:
  /// **'Last result'**
  String get lastSyncResult;

  /// No description provided for @autoCache.
  ///
  /// In en, this message translates to:
  /// **'Automatic Cache'**
  String get autoCache;

  /// No description provided for @syncResultSummary.
  ///
  /// In en, this message translates to:
  /// **'{pushed} sent, {pulled} received'**
  String syncResultSummary(int pushed, int pulled);

  /// No description provided for @syncResultConflicts.
  ///
  /// In en, this message translates to:
  /// **', {conflicts} conflicts'**
  String syncResultConflicts(int conflicts);

  /// No description provided for @exportingNPlants.
  ///
  /// In en, this message translates to:
  /// **'Exporting {n} selected plant(s)'**
  String exportingNPlants(int n);

  /// No description provided for @editSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Session'**
  String get editSessionTitle;

  /// No description provided for @sessionTripNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Trip Name *'**
  String get sessionTripNameLabel;

  /// No description provided for @sessionTripNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Collection in Serra do Mar'**
  String get sessionTripNameHint;

  /// No description provided for @sessionTripNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Trip name is required'**
  String get sessionTripNameRequired;

  /// No description provided for @sessionLocationHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. State Park, São Paulo'**
  String get sessionLocationHint;

  /// No description provided for @teamLabel.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamLabel;

  /// No description provided for @teamMemberNameHint.
  ///
  /// In en, this message translates to:
  /// **'Team member name'**
  String get teamMemberNameHint;

  /// No description provided for @noTeamMembersAdded.
  ///
  /// In en, this message translates to:
  /// **'No members added'**
  String get noTeamMembersAdded;

  /// No description provided for @sessionNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Additional information about the collection...'**
  String get sessionNotesHint;

  /// No description provided for @saveSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Save Session'**
  String get saveSessionLabel;

  /// No description provided for @sessionStartDateValue.
  ///
  /// In en, this message translates to:
  /// **'Start: {date}'**
  String sessionStartDateValue(String date);

  /// No description provided for @sessionEndDateValue.
  ///
  /// In en, this message translates to:
  /// **'End: {date}'**
  String sessionEndDateValue(String date);

  /// No description provided for @sessionCollaborators.
  ///
  /// In en, this message translates to:
  /// **'{count} collaborators'**
  String sessionCollaborators(int count);

  /// No description provided for @sessionTeamCount.
  ///
  /// In en, this message translates to:
  /// **'Team ({count})'**
  String sessionTeamCount(int count);

  /// No description provided for @sessionCollectedPlantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Collected Plants'**
  String get sessionCollectedPlantsTitle;

  /// No description provided for @noPlantsCollectedInSession.
  ///
  /// In en, this message translates to:
  /// **'No plants collected in this session'**
  String get noPlantsCollectedInSession;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @allLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allLabel;

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @mapPlantsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} plants on the map'**
  String mapPlantsCount(int count);

  /// No description provided for @mapPlantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant Map'**
  String get mapPlantsTitle;

  /// No description provided for @legendLabel.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get legendLabel;

  /// No description provided for @plantsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} plants'**
  String plantsCount(int count);

  /// No description provided for @tapMapToDefineArea.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to define the download area'**
  String get tapMapToDefineArea;

  /// No description provided for @offlineRegionName.
  ///
  /// In en, this message translates to:
  /// **'Region {date}'**
  String offlineRegionName(String date);

  /// No description provided for @downloadingRegion.
  ///
  /// In en, this message translates to:
  /// **'Downloading {region}'**
  String downloadingRegion(String region);

  /// No description provided for @selectFirstAreaCorner.
  ///
  /// In en, this message translates to:
  /// **'1. Tap the first corner of the area'**
  String get selectFirstAreaCorner;

  /// No description provided for @selectOppositeAreaCorner.
  ///
  /// In en, this message translates to:
  /// **'2. Tap the opposite corner of the area'**
  String get selectOppositeAreaCorner;

  /// No description provided for @mapCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Map Cache'**
  String get mapCacheTitle;

  /// No description provided for @cachedTilesLabel.
  ///
  /// In en, this message translates to:
  /// **'Cached tiles:'**
  String get cachedTilesLabel;

  /// No description provided for @usedSpaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Used space:'**
  String get usedSpaceLabel;

  /// No description provided for @howToUseLabel.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get howToUseLabel;

  /// No description provided for @offlineMapsHowToUse.
  ///
  /// In en, this message translates to:
  /// **'1. Tap + to download an area\n2. Tap two points on the map\n3. Confirm the download\n4. Use offline maps in the field!'**
  String get offlineMapsHowToUse;

  /// No description provided for @accessibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibilityTitle;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get highContrast;

  /// No description provided for @highContrastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Increases color contrast and reduces grays'**
  String get highContrastSubtitle;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @phenologyFournier.
  ///
  /// In en, this message translates to:
  /// **'Phenology (Fournier Scale)'**
  String get phenologyFournier;

  /// No description provided for @fournierFlowerBud.
  ///
  /// In en, this message translates to:
  /// **'Flower Bud'**
  String get fournierFlowerBud;

  /// No description provided for @fournierOpenFlower.
  ///
  /// In en, this message translates to:
  /// **'Open Flower'**
  String get fournierOpenFlower;

  /// No description provided for @fournierImmatureFruit.
  ///
  /// In en, this message translates to:
  /// **'Immature Fruit'**
  String get fournierImmatureFruit;

  /// No description provided for @fournierMatureFruit.
  ///
  /// In en, this message translates to:
  /// **'Mature Fruit'**
  String get fournierMatureFruit;

  /// No description provided for @fournierLeafFall.
  ///
  /// In en, this message translates to:
  /// **'Leaf Fall'**
  String get fournierLeafFall;

  /// No description provided for @exportLabelPdf.
  ///
  /// In en, this message translates to:
  /// **'Export Label PDF'**
  String get exportLabelPdf;

  /// No description provided for @exportLabelPdfTooltip.
  ///
  /// In en, this message translates to:
  /// **'Preview and share herbarium label PDF'**
  String get exportLabelPdfTooltip;

  /// No description provided for @herbariumLabelTitle.
  ///
  /// In en, this message translates to:
  /// **'Herbarium label'**
  String get herbariumLabelTitle;

  /// No description provided for @collector.
  ///
  /// In en, this message translates to:
  /// **'Collector'**
  String get collector;

  /// No description provided for @locality.
  ///
  /// In en, this message translates to:
  /// **'Locality'**
  String get locality;

  /// No description provided for @morphologicalNotes.
  ///
  /// In en, this message translates to:
  /// **'Morphological notes'**
  String get morphologicalNotes;

  /// No description provided for @errorExportingLabelPdf.
  ///
  /// In en, this message translates to:
  /// **'Error exporting label PDF: {error}'**
  String errorExportingLabelPdf(String error);

  /// No description provided for @conflictResolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Resolve conflicts'**
  String get conflictResolutionTitle;

  /// No description provided for @syncConflictBadge.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get syncConflictBadge;

  /// No description provided for @syncConflictBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'{count} sync conflict(s) need review.'**
  String syncConflictBannerMessage(int count);

  /// No description provided for @resolveConflicts.
  ///
  /// In en, this message translates to:
  /// **'Resolve conflicts'**
  String get resolveConflicts;

  /// No description provided for @pendingConflictsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pending conflict(s)'**
  String pendingConflictsCount(int count);

  /// No description provided for @conflictResolutionHelper.
  ///
  /// In en, this message translates to:
  /// **'Compare local and server values, then decide field by field or resolve the whole record at once.'**
  String get conflictResolutionHelper;

  /// No description provided for @resolveAllKeepMostRecent.
  ///
  /// In en, this message translates to:
  /// **'Resolve all → keep most recent'**
  String get resolveAllKeepMostRecent;

  /// No description provided for @conflictsResolvedMostRecent.
  ///
  /// In en, this message translates to:
  /// **'Conflicts resolved using the most recent version.'**
  String get conflictsResolvedMostRecent;

  /// No description provided for @syncConflictLocalVersion.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get syncConflictLocalVersion;

  /// No description provided for @syncConflictServerVersion.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get syncConflictServerVersion;

  /// No description provided for @keepLocalField.
  ///
  /// In en, this message translates to:
  /// **'Keep local field'**
  String get keepLocalField;

  /// No description provided for @acceptServerField.
  ///
  /// In en, this message translates to:
  /// **'Accept server field'**
  String get acceptServerField;

  /// No description provided for @fieldResolvedKeepingLocal.
  ///
  /// In en, this message translates to:
  /// **'Resolved \"{field}\" keeping local value.'**
  String fieldResolvedKeepingLocal(String field);

  /// No description provided for @fieldResolvedKeepingServer.
  ///
  /// In en, this message translates to:
  /// **'Resolved \"{field}\" accepting server value.'**
  String fieldResolvedKeepingServer(String field);

  /// No description provided for @keepLocalRecord.
  ///
  /// In en, this message translates to:
  /// **'Keep local record'**
  String get keepLocalRecord;

  /// No description provided for @acceptServerRecord.
  ///
  /// In en, this message translates to:
  /// **'Accept server record'**
  String get acceptServerRecord;

  /// No description provided for @conflictResolvedKeepingLocal.
  ///
  /// In en, this message translates to:
  /// **'Conflict resolved keeping local record.'**
  String get conflictResolvedKeepingLocal;

  /// No description provided for @conflictResolvedKeepingServer.
  ///
  /// In en, this message translates to:
  /// **'Conflict resolved accepting server record.'**
  String get conflictResolvedKeepingServer;

  /// No description provided for @syncConflictLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load conflicts'**
  String get syncConflictLoadErrorTitle;

  /// No description provided for @noPendingConflictsTitle.
  ///
  /// In en, this message translates to:
  /// **'No pending conflicts'**
  String get noPendingConflictsTitle;

  /// No description provided for @noPendingConflictsMessage.
  ///
  /// In en, this message translates to:
  /// **'Everything is in sync right now.'**
  String get noPendingConflictsMessage;

  /// No description provided for @determinationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Determinations'**
  String get determinationsTitle;

  /// No description provided for @newDetermination.
  ///
  /// In en, this message translates to:
  /// **'New determination'**
  String get newDetermination;

  /// No description provided for @determinedBy.
  ///
  /// In en, this message translates to:
  /// **'Determined by'**
  String get determinedBy;

  /// No description provided for @determinedAt.
  ///
  /// In en, this message translates to:
  /// **'Determined at'**
  String get determinedAt;

  /// No description provided for @determinationBasis.
  ///
  /// In en, this message translates to:
  /// **'Basis'**
  String get determinationBasis;

  /// No description provided for @determinationNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes about this determination...'**
  String get determinationNotesHint;

  /// No description provided for @determinationBasisHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. herbarium comparison, specialist review'**
  String get determinationBasisHint;

  /// No description provided for @noDeterminationsYet.
  ///
  /// In en, this message translates to:
  /// **'No determinations recorded yet'**
  String get noDeterminationsYet;

  /// No description provided for @latestDeterminationLabel.
  ///
  /// In en, this message translates to:
  /// **'Latest determination'**
  String get latestDeterminationLabel;

  /// No description provided for @duplicatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicates'**
  String get duplicatesTitle;

  /// No description provided for @markAsDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Mark as duplicate'**
  String get markAsDuplicate;

  /// No description provided for @duplicateOfLabel.
  ///
  /// In en, this message translates to:
  /// **'Duplicate of #{identifier}'**
  String duplicateOfLabel(String identifier);

  /// No description provided for @noDuplicatesLinked.
  ///
  /// In en, this message translates to:
  /// **'No linked duplicates'**
  String get noDuplicatesLinked;

  /// No description provided for @searchCollectorNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by collector number'**
  String get searchCollectorNumber;

  /// No description provided for @searchCollectorNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 42 or RC000042'**
  String get searchCollectorNumberHint;

  /// No description provided for @duplicateSearchHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose the original voucher from the same collection series'**
  String get duplicateSearchHelp;

  /// No description provided for @originalVoucher.
  ///
  /// In en, this message translates to:
  /// **'Original voucher'**
  String get originalVoucher;

  /// No description provided for @linkedDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Linked duplicates'**
  String get linkedDuplicates;

  /// No description provided for @duplicateLinkedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Duplicate linked successfully'**
  String get duplicateLinkedSuccess;

  /// No description provided for @determinationSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Determination saved successfully'**
  String get determinationSavedSuccess;

  /// No description provided for @fillDeterminationRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Fill in the required determination fields'**
  String get fillDeterminationRequiredFields;

  /// No description provided for @noMatchingRecords.
  ///
  /// In en, this message translates to:
  /// **'No matching records found'**
  String get noMatchingRecords;

  /// No description provided for @identificationHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Identification history'**
  String get identificationHistoryLabel;

  /// No description provided for @prepareExsiccatae.
  ///
  /// In en, this message translates to:
  /// **'Prepare exsiccatae'**
  String get prepareExsiccatae;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Label template'**
  String get selectTemplate;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{selected} of {total} selected'**
  String selectedCount(int selected, int total);

  /// No description provided for @generatePdf.
  ///
  /// In en, this message translates to:
  /// **'Generate PDF'**
  String get generatePdf;

  /// No description provided for @noRecordsToExport.
  ///
  /// In en, this message translates to:
  /// **'No records to export'**
  String get noRecordsToExport;

  /// No description provided for @labelTemplateStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard (A4, 4 per page)'**
  String get labelTemplateStandard;

  /// No description provided for @labelTemplateCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact (A4, 8 per page)'**
  String get labelTemplateCompact;

  /// No description provided for @labelTemplateLarge.
  ///
  /// In en, this message translates to:
  /// **'Large (A4, 1 per page)'**
  String get labelTemplateLarge;
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
