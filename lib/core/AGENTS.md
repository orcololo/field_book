<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-05-10 | Updated: 2026-05-13 -->

# CORE — State, Data, Business Logic

## OVERVIEW

Everything non-UI: repositories, services, providers, sync, database init, theme, error handling. Features depend on this layer; this layer never imports from `features/`.

## STRUCTURE

```
core/
├── config/                      # Compile-time configuration (app_config.dart — API endpoints)
├── database/
│   ├── isar_service.dart        # IsarService singleton — init all schemas here
│   └── platforms/               # Conditional imports: web (isar_service_web) vs mobile (isar_service_mobile) + interface
├── repositories/                # 4 repositories
│   ├── plant_repository.dart    # CRUD + FTS + GPS radius queries
│   ├── session_repository.dart
│   ├── saved_search_repository.dart
│   └── template_repository.dart # Collection templates
├── services/                    # 22 services
│   ├── audio_transcription_service.dart
│   ├── auth_service.dart
│   ├── coords_validation_service.dart
│   ├── dichotomous_key_service.dart
│   ├── export_import_service.dart
│   ├── geocoding_service.dart
│   ├── google_drive_backup_service.dart
│   ├── gps_track_service.dart
│   ├── herbarium_label_service.dart
│   ├── identifier_export_import_service.dart
│   ├── inaturalist_service.dart
│   ├── location_service.dart    # GPS + permission handling
│   ├── map_service.dart         # FMTC tile cache
│   ├── media_upload_service.dart
│   ├── moon_phase_service.dart
│   ├── ocr_service.dart
│   ├── photo_service.dart       # Compression, EXIF extraction
│   ├── plantnet_service.dart
│   ├── registry_identifier_service.dart
│   ├── settings_service.dart    # @riverpod singleton
│   ├── taxon_service.dart
│   ├── weather_service.dart
│   └── platforms/               # Platform splits for services
├── providers/                   # Shared @riverpod providers (auth, rain_mode, sync, taxon)
├── sync/                        # Offline sync orchestration
├── errors/                      # AppError sealed class + error handler
├── network/                     # Dio client (api_client), auth + connectivity interceptors, token storage, endpoints
├── theme/                       # FoliumTheme — colors, typography, spacing
└── utils/                       # Pure utilities: biome_detector, botanical_validator, geo_utils
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Add Isar query | `repositories/<model>_repository.dart` |
| Add business logic | `services/<domain>_service.dart` |
| Add shared provider | `providers/` |
| Sync orchestration | `sync/` |
| Error types | `errors/app_error.dart` |
| HTTP client setup | `network/` |
| FoliumTheme changes | `theme/` |

## REPOSITORY PATTERN

- Repositories wrap Isar queries only — no HTTP calls, no UI logic.
- Exposed as `@riverpod` singletons.
- Standard methods: `save()`, `getById()`, `getByUuid()`, `delete()`, `getPaginated()`.
- GPS radius search: haversine distance filter in `plant_repository.dart`.
- FTS: use Isar `.filter().fieldMatches(query)` — never `LIKE`-style string matching.

## SERVICES

- Services contain business logic that doesn't belong in repos.
- All services are `@riverpod` annotated.
- Platform-specific implementations in `platforms/` subdir with conditional imports.
- `IsarService` must be initialized before any repository is used.

## ANTI-PATTERNS

- Importing `features/` from `core/` — strictly forbidden.
- Network calls inside repositories — use services or providers.
- Platform-specific code without conditional import guard.
- Non-`@riverpod` providers.
