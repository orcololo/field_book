# CORE — State, Data, Business Logic

## OVERVIEW

Everything non-UI: repositories, services, providers, sync, database init, theme, error handling. Features depend on this layer; this layer never imports from `features/`.

## STRUCTURE

```
core/
├── database/
│   ├── isar_service.dart        # IsarService singleton — init all schemas here
│   └── platforms/               # Conditional imports: web vs mobile DB setup
├── repositories/
│   ├── plant_repository.dart    # CRUD + FTS + GPS radius queries
│   ├── session_repository.dart
│   └── saved_search_repository.dart
├── services/
│   ├── photo_service.dart       # Compression, EXIF extraction
│   ├── location_service.dart    # GPS + permission handling
│   ├── audio_transcription_service.dart
│   ├── export_import_service.dart
│   ├── google_drive_backup_service.dart
│   ├── registry_identifier_service.dart
│   ├── media_upload_service.dart
│   ├── settings_service.dart    # @riverpod singleton
│   ├── auth_service.dart
│   └── platforms/               # Platform splits for services
├── providers/                   # Shared/cross-cutting @riverpod providers
├── sync/                        # Offline sync orchestration
├── errors/                      # AppError sealed class + error handler
├── network/                     # Dio client, interceptors
├── theme/                       # FoliumTheme — colors, typography, spacing
└── utils/                       # Pure utility functions
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
