<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-05-13 -->

# models — Isar Database Models

## Purpose

Isar collection and embedded object definitions. These are the offline-first source of truth. Field names here define the sync contract — they must match the backend Mongoose schemas exactly.

## Key Files

| File | Description |
|------|-------------|
| `plant_record.dart` | Primary collection — botanical specimen data |
| `collection_session.dart` | Field collection session grouping |
| `collection_template.dart` | Reusable templates for quick data entry |
| `determination.dart` | Taxonomic determination (embedded) |
| `gps_point.dart` | GPS coordinate with altitude/accuracy (embedded) |
| `measurement.dart` | Plant measurements — height, DBH, etc. (embedded) |
| `photo_metadata.dart` | Photo file reference with EXIF data (embedded) |
| `saved_search.dart` | Persisted search filters |
| `settings.dart` | App settings (single-row collection) |
| `sync_metadata.dart` | Sync state: serverId, lastSyncedAt, syncStatus (embedded) |
| `taxon_cache.dart` | Cached taxon lookup results |
| `municipality_bounding_box_cache.dart` | Cached municipality geo bounds |
| `plant_category.dart` | PlantCategory enum definition |
| `collection_method.dart` | CollectionMethod enum definition |
| `phenological_state.dart` | PhenologicalState enum definition |
| `*.g.dart` | Generated code — do NOT edit |

## For AI Agents

### Working In This Directory

- `@collection` on top-level documents; `@embedded` on subdocuments.
- `@Index()` required on queryable fields. FTS: `@Index(type: IndexType.value)`.
- All syncable models include `SyncMetadata` embedded object.
- Enums stored as lowercase strings — must mirror backend enum strings exactly.
- After any change: `dart run build_runner build --delete-conflicting-outputs`.
- Never edit `*.g.dart` files — they are regenerated.

### Sync-Critical Rules

- Field names are the sync contract. Renaming a field here silently breaks sync with the backend.
- `uuid` (String, client-generated v4) is the cross-system identifier.
- `syncVersion` (int) tracks optimistic concurrency.
- `lastModifiedAt` (DateTime) drives last-write-wins conflict resolution.

### Testing Requirements

- Model-level tests use `IsarTestHelper` from `test/test_helpers/`.
- Repository tests in `test/unit/repositories/` exercise queries against real Isar instances.

## Dependencies

### Internal

- Used by `core/repositories/` for all data access
- Used by `core/sync/` for sync mapping
- Referenced (read-only) by `features/` screens for type info

### External

- `isar` + `isar_flutter_libs` — embedded database
- `build_runner` + `isar_generator` — code generation

<!-- MANUAL: -->
