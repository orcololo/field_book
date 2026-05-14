# Folium 🌿

**Botanical Field Collection & Documentation App**

Folium (_Latin for "leaf"_) is an offline-first mobile app for documenting botanical field collections. It turns your phone into a complete digital field notebook — with GPS, camera, audio notes, species identification, and scientific data export.

[![Release](https://img.shields.io/github/v/release/orcololo/field_book?include_prereleases)](https://github.com/orcololo/field_book/releases/latest)
![Platform](https://img.shields.io/badge/platform-Android-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.38.9-blue)
![License](https://img.shields.io/badge/license-TBD-lightgrey)

---

## Download

Get the latest APK from [GitHub Releases](https://github.com/orcololo/field_book/releases/latest).

Three architecture-specific APKs are available:

| APK | Device |
|-----|--------|
| `folium-*-arm64-v8a.apk` | Most modern phones (recommended) |
| `folium-*-armeabi-v7a.apk` | Older 32-bit ARM devices |
| `folium-*-x86_64.apk` | Emulators and x86 devices |

### Requirements

- Android 5.0 (API 21) or higher
- ~85 MB free storage
- GPS, camera, microphone permissions (requested at use)

### Install

Transfer the APK to your device and open it, or via ADB:

```bash
adb install folium-<version>-arm64-v8a.apk
```

---

## Features

### Plant Documentation
- Scientific names with binomial nomenclature validation
- Dynamic measurements (unlimited entries per plant)
- Photo gallery with EXIF metadata extraction
- Audio notes with on-device Whisper transcription
- GPS coordinates with interactive map pin placement
- Draft system for incomplete records
- Auto-generated registry identifiers (e.g. `RC000042`)

### Collection Sessions
- Group plants by field trips
- Team members, location, date range, notes
- Share sessions via 6-character codes
- Archive completed sessions

### Maps & Location
- Interactive OpenStreetMap with color-coded markers per category
- GPS radius search with bounding-box optimization
- Offline map tile downloads for fieldwork without internet
- Configurable providers (OSM, Mapbox Streets, Mapbox Satellite)

### Species Identification
- Dichotomous key for taxonomic identification
- PlantNet image-based identification
- iNaturalist integration
- OCR for herbarium label digitization

### Data Export & Backup
- **JSON** — complete format with all data
- **CSV** — spreadsheet-compatible
- **Darwin Core** — international biodiversity standard (GBIF/iNaturalist)
- **PDF** — visual report with photos and details
- Google Drive cloud backup
- Import with UUID-based merge strategy

### Statistics & Analytics
- Collection overview cards
- Distribution by category (pie chart)
- Monthly collection trends (bar chart)
- Recent activity feed

### Quick Capture
- One-tap entry: GPS + camera + auto-identifier
- Rain mode for adverse field conditions

### Internationalization
- Portuguese (BR), English, Spanish

---

## Development

### Prerequisites

- Flutter SDK 3.38.9+
- Dart SDK 3.10.8+
- Android SDK (API 21–36)
- Java 17

### Setup

```bash
git clone https://github.com/orcololo/field_book.git
cd field_book
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Build Release APKs

```bash
flutter build apk --split-per-abi --release
```

### Code Quality

```bash
flutter analyze
dart format lib/
flutter test
```

---

## CI/CD

Releases are automated via GitHub Actions. Push a tag to trigger the pipeline:

```bash
git tag v1.9.0
git push origin v1.9.0
```

The workflow builds split APKs per architecture, uploads them as artifacts, and creates a GitHub Release with auto-generated release notes.

---

## Architecture

- **State Management**: Riverpod with code generation
- **Database**: Isar (embedded NoSQL, offline-first)
- **Networking**: Dio with auth interceptor and connectivity handling
- **Maps**: flutter_map + OpenStreetMap
- **Audio**: Whisper ML (on-device) + SpeechToText
- **Design**: Material 3 with custom eco-modern theme (Forest Green, Earth Brown, Sky Blue)

### Project Structure

```
lib/
├── core/           # Infrastructure (network, database, services, theme, sync)
├── features/       # 16 feature modules (auth, map, plant_form, sessions, etc.)
├── models/         # 15 Isar data models
├── shared/         # Reusable widgets and utilities
└── l10n/           # Localization (pt, en, es)
```

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a Pull Request

---

## License

TBD
