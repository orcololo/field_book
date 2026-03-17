# Folium 🌿

**Version 1.8.0** — Botanical Field Collection & Documentation App

Folium (_Latin for "leaf"_) is a modern, offline-first mobile application for documenting and managing botanical field collections. Built with an eco-modern design system and powerful scientific features, it turns your phone into a complete digital field notebook.

![Version](https://img.shields.io/badge/version-1.8.0-green)
![Platform](https://img.shields.io/badge/platform-Android-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.10.8-blue)
![Dart](https://img.shields.io/badge/Dart-3.10.8-blue)
![Database](https://img.shields.io/badge/DB-Isar%203.1.0-orange)
![License](https://img.shields.io/badge/license-TBD-lightgrey)

---

## ✨ Features

### 🌱 Plant Management

- **Complete Documentation**: Record scientific names, common names, families, genera, species, habitats, and free-form notes
- **Dynamic Measurements**: Add unlimited measurement entries (label, value, unit) per plant
- **Photo Gallery**: Capture photos via camera or gallery (single & multi-pick), JPEG compression, EXIF metadata extraction and display
- **Audio Notes**: Record voice observations with configurable quality (64–192 kbps AAC), playback, and **dual transcription** — on-device Whisper ML model + live `SpeechToText`
- **GPS Location**: Automatic high-accuracy coordinate capture with interactive map pin placement
- **Draft System**: Save incomplete records and finish later; status tracking (draft/complete)
- **Registry Identifiers**: Thread-safe auto-generation (`{Initials}{6-digit}`, e.g. `RC000042`) with unique constraint, collision resolution, and manual override
- **Botanical Validation**: Binomial nomenclature format checking, auto-suggest family from genus (15 families, 50+ genera mapped), duplicate scientific name detection with debounce

### 🔍 Search & Organization

- **Dual Search Modes**: By scientific/common name (full-text search on indexed fields) or by registry identifier (exact + prefix match)
- **Advanced Filters**: Category, status (all/complete/draft), date range (start/end pickers) — all combinable
- **8 Plant Categories**: Trees, shrubs, herbs, ferns, grasses, vines, cacti, aquatic
- **Collection Sessions**: Group plants by field trips with trip name, location, date range, team members, and notes
- **Session Sharing**: Generate unique 6-character share codes for multi-device collaboration
- **Session Archiving**: Archive completed sessions without deleting data; unarchive anytime
- **Saved Searches**: Persist search queries and filters for quick reuse

### 🗺️ Maps & Location

- **Interactive Map View**: Full-screen OpenStreetMap with **color-coded markers** per plant category, auto-centering, category/status filter legend
- **GPS Radius Search**: Optimized with **bounding-box pre-filtering** on indexed lat/lng + Haversine distance calculation
- **Offline Maps**: Download map tile regions for use without internet (FMTC + ObjectBox backend), cache stats, clear cache
- **Configurable Provider**: OpenStreetMap, Mapbox Streets, or Mapbox Satellite
- **Map Pin Placement**: Tap-to-place GPS coordinates on an interactive map during plant registration

### 📸 Photo Gallery

- **Cross-Plant Gallery**: Grid view of all photos across all plants, sortable by date or plant name
- **Fullscreen Viewer**: Pinch-to-zoom, pan, swipe between photos via `PhotoViewGallery`
- **EXIF Data Overlay**: Camera make/model, ISO, aperture, shutter speed, resolution
- **Filter by Category & Date**: Narrow down the gallery to specific plant types or time periods

### 📊 Statistics & Analytics

- **Overview Cards**: Total plants, total sessions, drafts count, this month's collections
- **Pie Chart**: Plants distributed by category
- **Bar Chart**: Collections per month (last 6 months)
- **Recent Activity**: Last 5 plants collected with draft badges
- **Localized Labels**: Category names displayed in the user's language

### 🗂️ Data Management

- **Export Formats**: JSON (complete, with optional sessions), CSV (Portuguese headers), **Darwin Core** (GBIF/iNaturalist-compatible international biodiversity standard)
- **Import**: JSON file picker with UUID-based merge strategy (update existing, create new) and detailed result dialog
- **Identifier Export/Import**: JSON, CSV, and **Excel (XLSX)** with configuration sheet and **formula injection protection**
- **Bulk Identifier Assignment**: Select plants without identifiers, preview assignments, atomic all-or-nothing operation
- **Cloud Backup**: Google Drive (`appDataFolder`) with Google Sign-In, WiFi-only option, restore with merge, timestamp tracking
- **Local Backup & Restore**: Full data backup to device storage
- **Offline-First**: Isar embedded NoSQL database — all data stored locally, no server required

### 🎓 Onboarding

- **5-Page Guided Tutorial**: Welcome, Collection Sessions, Plant Registration (photos/GPS/audio), Export & Share, Setup
- **Initial Setup**: Configure user initials (1–4 uppercase letters) and starting registry number with live preview
- **Re-triggerable**: Access the tutorial anytime from Settings → "Show Tutorial"

### ⚙️ Settings

- **General**: Language selection (Portuguese, English, Spanish)
- **Registry Identifier**: User initials, last number, auto-generate toggle, identifier management screen
- **Map**: Provider (OSM/Mapbox), cache radius (1–50 km), auto-cache toggle
- **Form**: Auto-save interval
- **Photos**: Compression quality (30–100), preserve EXIF toggle
- **Audio**: Transcription on/off, transcription locale, audio quality (low/medium/high)
- **Cloud Backup**: Provider (Google Drive/Dropbox/None), enable/disable, WiFi-only, manual backup/restore buttons
- **Performance**: Pagination size, thumbnail cache toggle
- **About**: App version, device ID, show tutorial

### 🌍 Internationalization

- **3 Languages**: Portuguese (BR, default), English, Spanish
- **~130 Localized Keys**: Navigation, forms, categories, actions, errors, permissions, onboarding, backup, identifiers, audio

### 🎨 Modern Design

- **Eco-Modern Theme**: Nature-inspired palette — Forest Green `#3D7A52`, Earth Brown `#6D4C41`, Sky Blue `#0288D1`
- **Light & Dark Themes**: Full Material 3 `ColorScheme` for both modes
- **Glassmorphism**: Premium frosted glass effect on app bar
- **Custom Leaf Icon**: Branding throughout splash screen, launcher, and navigation
- **Shimmer Loading**: Skeleton placeholders for smooth perceived performance
- **Hero Animations**: Seamless transitions between plant list and detail views
- **Spacing System**: Consistent 4–64px scale with 5 border-radius levels (8–999px)

---

## 📱 Screens

| #   | Screen                    | Description                                                                    |
| --- | ------------------------- | ------------------------------------------------------------------------------ |
| 1   | **Onboarding**            | 5-page guided intro with initial setup                                         |
| 2   | **Home**                  | 5-tab navigation hub (Plants, Sessions, Map, Statistics, Settings)             |
| 3   | **Plant Form**            | 6-tab creation/editing (Basic, Location, Habitat, Measurements, Photos, Audio) |
| 4   | **Plant Detail**          | Hero image, taxonomy, photos, audio, measurements, map, metadata               |
| 5   | **Plant Edit**            | Quick taxonomy-only editor (name, family, genus, species, category)            |
| 6   | **Search**                | Dual-mode search with advanced filters                                         |
| 7   | **Session Form**          | Create/edit collection sessions with team members                              |
| 8   | **Session Detail**        | View session, team, notes, associated plants, share code                       |
| 9   | **Map View**              | Full-screen map with colored markers and legend                                |
| 10  | **Offline Maps**          | Download tile regions, cache stats                                             |
| 11  | **Photo Gallery**         | Cross-plant photo grid with sort/filter                                        |
| 12  | **Photo Viewer**          | Fullscreen zoom/pan gallery with EXIF overlay                                  |
| 13  | **Statistics**            | Charts, analytics, recent activity                                             |
| 14  | **Settings**              | Comprehensive app configuration                                                |
| 15  | **Export/Import**         | JSON, CSV, Darwin Core export; JSON import                                     |
| 16  | **Identifier Management** | Batch assignment, export/import identifiers                                    |

---

## 🚀 Installation

### Requirements

- Android 5.0 (API 21) or higher
- ~85MB free storage
- GPS, camera, microphone, and storage permissions (optional, requested at use)

### Download

```
folium-v1.8.0-beta.apk (85MB)
```

### Install

```bash
adb install folium-v1.8.0-beta.apk
```

Or transfer to device and install manually.

---

## 🛠️ Development

### Prerequisites

- Flutter SDK 3.10.8+
- Dart SDK 3.10.8+
- Android Studio or VS Code
- Android SDK (API 21–34)

### Setup

```bash
# Clone the repository
git clone <repository-url>
cd field_book

# Install dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Build Release APK

```bash
flutter build apk --release
```

### Code Quality

```bash
flutter analyze       # Static analysis
flutter format lib/   # Code formatting
flutter test          # Unit & widget tests
```

---

## 📦 Project Structure

```
lib/
├── core/                        # Core infrastructure
│   ├── database/               # Isar DB (mobile/web platform split)
│   │   └── platforms/          # isar_service_mobile.dart, _web.dart
│   ├── errors/                 # Error handling
│   ├── repositories/           # Data access layer
│   │   ├── plant_repository    # PlantRecord CRUD, FTS, GPS search
│   │   ├── session_repository  # Session CRUD, share codes, archiving
│   │   └── saved_search_repo   # Saved search persistence
│   ├── services/               # Business logic
│   │   ├── audio_transcription # Whisper ML + SpeechToText
│   │   ├── export_import       # JSON, CSV, Darwin Core
│   │   ├── google_drive_backup # Cloud backup via Drive API
│   │   ├── identifier_export   # Identifier JSON/CSV/XLSX
│   │   ├── location_service    # GPS + permissions
│   │   ├── map_service         # FMTC tile caching
│   │   ├── photo_service       # Camera, gallery, compression
│   │   ├── registry_identifier # Thread-safe ID generation
│   │   └── settings_service    # Riverpod AsyncNotifier
│   ├── sync/                   # Sync infrastructure (planned)
│   ├── theme/                  # FoliumTheme (light + dark)
│   └── utils/                  # BotanicalValidator, GeoUtils
├── features/                    # Feature modules (12)
│   ├── home/                   # 5-tab navigation hub
│   ├── onboarding/             # 5-page guided tutorial
│   ├── plant_form/             # 6-tab plant creation (1632 lines)
│   ├── plant_detail/           # Hero image detail view (989 lines)
│   ├── plant_edit/             # Quick taxonomy editor
│   ├── search/                 # Dual-mode search + filters
│   ├── sessions/               # Session form + detail + sharing
│   ├── map/                    # Map view + offline maps
│   ├── photo_gallery/          # Gallery grid + fullscreen viewer
│   ├── statistics/             # Charts and analytics
│   ├── export_import/          # Export/import data
│   └── settings/               # Settings + identifier management
├── models/                      # Isar data models
│   ├── plant_record.dart       # Core plant model (30+ fields)
│   ├── collection_session.dart # Session with team & sharing
│   ├── measurement.dart        # Embedded: label, value, unit
│   ├── photo_metadata.dart     # Embedded: EXIF, GPS, file size
│   ├── saved_search.dart       # Persisted search queries
│   ├── settings.dart           # Singleton app settings
│   ├── sync_metadata.dart      # Embedded: sync status (planned)
│   └── plant_category.dart     # Enum: 8 categories
├── shared/                      # Shared components
│   ├── constants/              # App-wide constants
│   ├── utils/                  # Shared utilities
│   └── widgets/                # Reusable widgets
│       ├── modern/             # ModernPlantCard, GlassAppBar, etc.
│       ├── audio/              # AudioRecorder, AudioPlayer
│       └── map_widget.dart     # Reusable FlutterMap
└── l10n/                        # Localization (pt, en, es)
```

---

## 🎨 Design System

### FoliumTheme

Complete Material Design 3 implementation with light & dark modes:

| Aspect               | Details                                                               |
| -------------------- | --------------------------------------------------------------------- |
| **Primary Colors**   | Forest Green `#3D7A52`, Deep Forest `#234A30`                         |
| **Secondary Colors** | Rich Soil `#6D4C41`, Clay Brown `#8D6E63`                             |
| **Tertiary Colors**  | Water Blue `#0288D1`, Sky Blue `#4FC3F7`                              |
| **Semantic**         | Success `#4CAF50`, Warning `#FF9800`, Error `#E53935`, Info `#2196F3` |
| **Spacing**          | 4, 8, 10, 12, 16, 20, 24, 32, 48, 64 px                               |
| **Border Radius**    | small(8), medium(16), large(24), xlarge(32), full(999)                |
| **Elevations**       | 4 levels with `BoxShadow`                                             |
| **Animations**       | fast(150ms), normal(300ms), slow(500ms)                               |

### Components

| Widget                  | Purpose                                               |
| ----------------------- | ----------------------------------------------------- |
| **ModernPlantCard**     | Full-size & compact card with image, badges, metadata |
| **GlassAppBar**         | Frosted glass effect with backdrop blur               |
| **ModernSearchBar**     | Search input with clear button                        |
| **EmptyStateWidget**    | Contextual empty state illustrations                  |
| **ShimmerLoading**      | Skeleton loading for cards and lists                  |
| **AudioRecorderWidget** | Record with start/pause/resume/stop/cancel            |
| **AudioPlayerWidget**   | Playback for recorded audio notes                     |
| **MapWidget**           | Reusable FlutterMap with markers and selection        |

See [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) for complete documentation.

---

## 📊 Technical Stack

### Core Technologies

| Category             | Technology                                               |
| -------------------- | -------------------------------------------------------- |
| **Framework**        | Flutter 3.10.8                                           |
| **Language**         | Dart 3.10.8                                              |
| **State Management** | Riverpod 2.6.1 (`riverpod_annotation` + code generation) |
| **Database**         | Isar 3.1.0 (embedded NoSQL, offline-first)               |
| **UI**               | Material Design 3 (light + dark themes)                  |

### Dependencies

| Category               | Packages                                                                                  |
| ---------------------- | ----------------------------------------------------------------------------------------- |
| **State**              | `flutter_riverpod`, `riverpod_annotation`                                                 |
| **Database**           | `isar`, `isar_flutter_libs`                                                               |
| **Images**             | `image_picker`, `flutter_image_compress`, `exif`, `photo_view`, `cached_network_image`    |
| **Location/Maps**      | `geolocator`, `permission_handler`, `flutter_map`, `flutter_map_tile_caching`, `latlong2` |
| **Data Export/Import** | `csv`, `excel`, `archive`, `file_picker`                                                  |
| **Audio**              | `record`, `audioplayers`, `speech_to_text`, `whisper_flutter_new`                         |
| **Charts**             | `fl_chart`                                                                                |
| **Cloud**              | `connectivity_plus`, `googleapis`, `googleapis_auth`, `google_sign_in`                    |
| **QR Code**            | `qr_flutter`, `mobile_scanner`                                                            |
| **UI**                 | `introduction_screen`, `infinite_scroll_pagination`, `flutter_svg`                        |
| **Storage**            | `path_provider`, `shared_preferences`                                                     |
| **Utility**            | `uuid`, `share_plus`, `intl`, `logger`                                                    |

---

## 🔧 Configuration

### Settings

| Setting           | Options                                                   |
| ----------------- | --------------------------------------------------------- |
| **Language**      | Portuguese (default), English, Spanish                    |
| **Identifier**    | Configurable initials (1–4 chars) + auto-increment number |
| **Map Provider**  | OpenStreetMap, Mapbox Streets, Mapbox Satellite           |
| **Map Cache**     | Radius 1–50 km, auto-cache toggle                         |
| **Photo Quality** | JPEG compression 30–100                                   |
| **Photo EXIF**    | Preserve on/off                                           |
| **Audio Quality** | Low (64 kbps), Medium (128 kbps), High (192 kbps)         |
| **Transcription** | On/off with locale selection                              |
| **Cloud Backup**  | Google Drive / Dropbox / None, WiFi-only toggle           |
| **Performance**   | Pagination size, thumbnail cache                          |

### Permissions

| Permission     | Usage                              |
| -------------- | ---------------------------------- |
| **Camera**     | Plant photography                  |
| **Storage**    | Photo and data management          |
| **Location**   | GPS coordinate capture             |
| **Microphone** | Audio note recording               |
| **Internet**   | Cloud backup, map tiles (optional) |

---

## 🔄 Version History

### v1.8.0 (Current) — February 5, 2026

- Complete UI/UX redesign with eco-modern theme
- Glassmorphic app bar with custom leaf icon
- Native splash screen and new launcher icon
- 5-page onboarding tutorial with initial setup
- Photo gallery with fullscreen viewer and EXIF overlay
- Statistics dashboard with charts and analytics
- Offline map tile downloading
- Dark theme support
- Fixed all layout overflow issues
- Code quality improvements (71% warning reduction)

### v1.7.0 — January 2026

- Search by identifier functionality
- Bulk identifier assignment tool
- GPS radius search optimization
- Export/import in Darwin Core format
- Export/import identifier sequences (JSON/CSV/XLSX)
- App rebranding to Folium
- Cloud backup via Google Drive

### v1.6.0–1.6.4 — December 2025

- Complete identifier system implementation
- Critical bug fixes (22 bugs fixed)
- Performance optimizations
- Data integrity improvements

See [RELEASE_NOTES_v1.8.0.md](RELEASE_NOTES_v1.8.0.md) for detailed release notes.

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Follow the existing code style
4. Write tests for new features
5. Submit a pull request

---

## 📄 License

_License information to be added_

---

## 🙏 Acknowledgments

- Material Design 3 guidelines
- Flutter community
- OpenStreetMap contributors
- Botanical research community
- Whisper ML model for on-device transcription

---

## 📞 Support

For issues, questions, or feedback:

- Check the in-app Settings → About section
- Review documentation files
- Submit bug reports with detailed reproduction steps

---

## 🗺️ Roadmap

### Planned Features

- 🍎 iOS version with glassmorphic design
- 🔄 Server-based sync and real-time collaboration (sync infrastructure already stubbed)
- 📱 QR code generation and scanning for specimens (dependencies already included)
- 📊 Custom report generation
- 🏛️ Integration with herbarium databases (speciesLink, GBIF)
- ☁️ Dropbox backup support

---

**Made with 🌿 for botanical field research**

_Current Release: v1.8.0-beta | February 2026_
