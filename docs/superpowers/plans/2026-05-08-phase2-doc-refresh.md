# Folium — Phase 2: Doc Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bring `README.md`, `ROADMAP.md`, and the three `AGENTS.md` files in line with the actual contents of `lib/`. After this phase, a fresh contributor reading the docs gets an accurate picture matching the code.

**Architecture:** Documentation-only phase. No code changes. Each doc has a defined audience and scope; updates target specific staleness identified during the 2026-05-08 audit. Verification is by visual cross-check against `lib/` contents (no code-level test gate exists for docs).

**Tech Stack:** Markdown only. No code-gen, no tests, no build steps. Phase 1 already merged (analyzer clean baseline).

**Reference spec:** `docs/superpowers/specs/2026-05-08-folium-correction-and-polish-design.md` § Phase 2.

**Working directory:** All commands assume cwd = `/Users/orcola/Projetos/Herbario/fieldBook/field_book`.

**Branch convention:** Branch `phase-2/doc-refresh` from `main` after Phase 1 is merged. One commit per doc file. Final task fast-forward merges to `main`.

**Out of scope:** Do not edit `.github/agents/flutter-app.agent.md`, `.github/agents/nestjs-backend.agent.md`, `.github/instructions/nestjs-backend.instructions.md`, or `.github/prompts/*` — these reference the removed `backend/` and need their own pass logged for a future phase. Do not edit `RELEASE_NOTES_v1.7.0.md` or any v1.8 release notes (they were deleted in the WIP commit; no surviving file to update). The README's broken link to `RELEASE_NOTES_v1.8.0.md` is fixed by removing the link, not by writing the file.

---

## File Map

| File | Status | Scope of edit |
|------|--------|---------------|
| `AGENTS.md` (project root) | Stale: references removed `backend/`; service & model lists outdated | Major edit: remove backend rows, update inventories, refresh "Where to Look" |
| `lib/AGENTS.md` | Missing 2 features (`identification/`, `sync/`) from STRUCTURE block | Small edit: add 2 lines to feature list |
| `lib/core/AGENTS.md` | Missing 12 services, 1 repository, partial directory list | Medium edit: add missing items to STRUCTURE block and "Where to Look" |
| `README.md` | Missing 5 features, 12 services, 7 models; broken release-notes link; missing 8 dependencies | Major edit: section-by-section additions, link removal |
| `ROADMAP.md` | All P0 items done but listed open; tech-debt table stale; maturity ratings stale | Medium edit: tick boxes, update tables, remove stale rows |

5 files modified. Zero files created. Zero files deleted.

---

## Task 0: Branch and audit

**Files:** none modified.

- [ ] **Step 0.1: Verify clean baseline**

```bash
pwd
git status --porcelain
git log --oneline -1
flutter analyze 2>&1 | tail -1
```

Expected:
- `pwd` reports `/Users/orcola/Projetos/Herbario/fieldBook/field_book`
- `git status --porcelain` is empty
- `git log --oneline -1` shows `c59067d fix: replace __/___ wildcards with _ in rain_mode_guard pageBuilder` (Phase 1's last commit, now on `main`)
- `flutter analyze` reports `No issues found!`

If anything mismatches, **stop and reconcile** — Phase 1 must be merged before Phase 2 starts.

- [ ] **Step 0.2: Create branch**

```bash
git checkout -b phase-2/doc-refresh
git status --short --branch | head -1
```

Expected: `## phase-2/doc-refresh`.

- [ ] **Step 0.3: Capture inventory snapshots (audit, not edits)**

These commands produce the ground-truth inventories the doc edits below must match. Run them and **note the output**; the edits in Tasks 1–5 reference these numbers.

```bash
# Feature directories under lib/features/
ls -1 lib/features/ | sort
```

Expected output (alphabetical): `auth, export_import, home, identification, map, onboarding, photo_gallery, plant_detail, plant_edit, plant_form, quick_capture, search, sessions, settings, statistics, sync` — 16 features.

```bash
# Services under lib/core/services/ (excluding *.g.dart and platforms/)
ls -1 lib/core/services/ | grep -v "\.g\.dart$" | grep -v "^platforms$" | sort
```

Expected (alphabetical): `audio_transcription_service.dart`, `auth_service.dart`, `coords_validation_service.dart`, `dichotomous_key_service.dart`, `export_import_service.dart`, `geocoding_service.dart`, `google_drive_backup_service.dart`, `gps_track_service.dart`, `herbarium_label_service.dart`, `identifier_export_import_service.dart`, `inaturalist_service.dart`, `location_service.dart`, `map_service.dart`, `media_upload_service.dart`, `moon_phase_service.dart`, `ocr_service.dart`, `photo_service.dart`, `plantnet_service.dart`, `registry_identifier_service.dart`, `settings_service.dart`, `taxon_service.dart`, `weather_service.dart` — 22 services.

```bash
# Repositories under lib/core/repositories/
ls -1 lib/core/repositories/ | grep -v "\.g\.dart$" | sort
```

Expected: `plant_repository.dart`, `saved_search_repository.dart`, `session_repository.dart`, `template_repository.dart` — 4 repositories.

```bash
# Models (excluding generated)
ls -1 lib/models/ | grep -v "\.g\.dart$" | sort
```

Expected: `collection_method.dart`, `collection_session.dart`, `collection_template.dart`, `determination.dart`, `gps_point.dart`, `measurement.dart`, `municipality_bounding_box_cache.dart`, `phenological_state.dart`, `photo_metadata.dart`, `plant_category.dart`, `plant_record.dart`, `saved_search.dart`, `settings.dart`, `sync_metadata.dart`, `taxon_cache.dart` — 15 model files.

(Note: `measurement.dart` and `photo_metadata.dart` are `@embedded`, not `@collection` — they are still listed.)

```bash
# Top-level lib/core directories
ls -1d lib/core/*/ | sed 's|/$||' | sort
```

Expected: `lib/core/config`, `lib/core/database`, `lib/core/errors`, `lib/core/network`, `lib/core/providers`, `lib/core/repositories`, `lib/core/services`, `lib/core/sync`, `lib/core/theme`, `lib/core/utils` — 10 directories.

```bash
# Shared widgets at the modern/ level (used by lib/AGENTS.md)
ls -1 lib/shared/widgets/modern/ | grep "\.dart$" | sort
```

Note the output for reference (used in the README's component-table refresh).

- [ ] **Step 0.4: No commit yet — Task 0 produced no edits**

The audit-snapshot commands above are reference data for Tasks 1–5. There is nothing to commit. Proceed to Task 1.

---

## Task 1: Refresh `AGENTS.md` (project root)

**File:**
- Modify: `/Users/orcola/Projetos/Herbario/fieldBook/field_book/AGENTS.md`

**Issue:** This file was committed in `798bc77` as part of the WIP snapshot. Its content (dated `Generated: 2026-04-29`) was written when `backend/` lived inside `field_book/`. The `backend/` directory has since been moved to a sibling repo, but this doc still references it as if it were in the same tree. Service and model inventories are also short of the actual contents.

- [ ] **Step 1.1: Read the current file**

```bash
wc -l AGENTS.md
```

Expected: ~120 lines.

Read the full file before editing. The structure is: OVERVIEW → STRUCTURE → WHERE TO LOOK → ARCHITECTURE: FLUTTER → ARCHITECTURE: BACKEND → FLUTTER–BACKEND SYNC CONTRACT → CONVENTIONS → ANTI-PATTERNS → COMMANDS → CODEGEN NOTE → NOTES.

- [ ] **Step 1.2: Edit — STRUCTURE block**

Find:

```
field_book/
├── lib/                  # Flutter app (Dart, Riverpod, Isar)
│   ├── features/         # UI screens only — no state logic here
│   ├── core/             # Repos, services, providers, sync, theme
│   ├── models/           # Isar @collection models + .g.dart
│   ├── shared/           # Reusable widgets, utils, constants
│   └── l10n/             # ARB i18n (en, pt, es)
├── backend/              # NestJS API (TypeScript, MongoDB, Mongoose)
│   └── src/modules/      # auth, users, species, registry, sessions, sync, upload
├── test/                 # Flutter tests: unit/, widget/, integration/, golden/
├── android/ ios/ web/    # Platform shells — rarely edited directly
└── .github/agents/       # flutter-app.agent.md, nestjs-backend.agent.md
```

Replace with:

```
field_book/
├── lib/                  # Flutter app (Dart, Riverpod, Isar) — see lib/AGENTS.md
│   ├── features/         # 16 feature modules — UI screens only
│   ├── core/             # Repos, services, providers, sync, theme — see lib/core/AGENTS.md
│   ├── models/           # 15 Isar models (@collection + @embedded) + .g.dart
│   ├── shared/           # Reusable widgets, utils, constants
│   └── l10n/             # ARB i18n (pt, en, es)
├── docs/superpowers/     # Specs and plans for ongoing correction passes
├── test/                 # Flutter tests: unit/, widget/, integration/, golden/ (skeleton — empty)
├── android/ ios/ web/    # Platform shells — rarely edited directly
└── .github/              # Agent docs and prompts (legacy refs to backend pending refresh)
```

- [ ] **Step 1.3: Edit — WHERE TO LOOK table**

Find this table:

```
| Task | Location |
|------|----------|
| Add feature screen | `lib/features/<name>/screens/` |
| Add Isar model | `lib/models/<name>.dart` + run codegen |
| Add state/provider | `lib/core/providers/` or co-locate with service |
| Add repository query | `lib/core/repositories/<name>_repository.dart` |
| Add service logic | `lib/core/services/<name>_service.dart` |
| Change theme/design | `lib/core/theme/` — `FoliumTheme` |
| Add i18n string | `lib/l10n/app_en.arb` + equivalent pt/es |
| Add backend endpoint | `backend/src/modules/<feature>/` |
| Backend sync logic | `backend/src/modules/sync/` |
| Docker/deploy | `backend/docker/` |
```

Replace with (drop the three backend rows; add three new ones for the network/sync/test directories):

```
| Task | Location |
|------|----------|
| Add feature screen | `lib/features/<name>/screens/` |
| Add Isar model | `lib/models/<name>.dart` + run codegen |
| Add state/provider | `lib/core/providers/` or co-locate with service |
| Add repository query | `lib/core/repositories/<name>_repository.dart` |
| Add service logic | `lib/core/services/<name>_service.dart` |
| Change theme/design | `lib/core/theme/` — `FoliumTheme` |
| Add i18n string | `lib/l10n/app_en.arb` + equivalent pt/es |
| Add HTTP client/interceptor | `lib/core/network/` |
| Sync orchestration / mapper | `lib/core/sync/sync_service.dart` |
| Add a test | `test/{unit,widget,integration,golden}/` (empty as of 2026-05-08) |
```

- [ ] **Step 1.4: Edit — drop the ARCHITECTURE: BACKEND section**

Find the section:

```
## ARCHITECTURE: BACKEND

- **Framework**: NestJS 10+, MongoDB 8, Mongoose, strict TypeScript.
- **API prefix**: `/api/v1`
- **Auth**: JWT access + refresh tokens. All routes need `@UseGuards(JwtAuthGuard)`.
- **Module pattern**: module → controller → service → schema + DTOs + enums.
- **Sync**: UUID-based upsert. `POST /sync` accepts batches; conflict = last-write-wins on `lastModifiedAt`.
- **Soft delete**: `isActive: false` — never hard-delete user data.
```

Delete this entire section (the `## ARCHITECTURE: BACKEND` heading and its bullets). The backend lives in a sibling repository and is no longer part of this Flutter project's documentation.

- [ ] **Step 1.5: Edit — refresh FLUTTER–BACKEND SYNC CONTRACT section**

Find:

```
## FLUTTER–BACKEND SYNC CONTRACT

- Every syncable entity has `uuid` (client v4 UUID) + `syncVersion` (number).
- Isar model field names **must** match Mongoose schema field names exactly.
- `SyncMetadata` embedded: `serverId`, `lastSyncedAt`, `syncStatus` (pending/synced/conflict/error).
- Backend enums mirror Flutter enums as lowercase strings.
```

Replace with (rename the section and update wording — the Flutter side still has a contract, even though the backend is in another repo):

```
## SYNC CONTRACT (Flutter ↔ external API)

- Every syncable entity has `uuid` (client v4 UUID) + `syncVersion` (number).
- Isar model field names must match the external API's schema field names exactly. The API is maintained in a sibling repository (`../backend/`) — schema drift will silently break sync.
- `SyncMetadata` embedded on syncable models: `serverId`, `lastSyncedAt`, `syncStatus` (pending/synced/conflict/error).
- Enums are stored as lowercase strings on both sides.
- Conflict resolution: last-write-wins on `lastModifiedAt`, with manual override surfaced in `lib/features/sync/screens/conflict_resolution_screen.dart`.
```

- [ ] **Step 1.6: Edit — drop CONVENTIONS rows that mention TypeScript/NestJS**

Find:

```
- **Dart**: `flutter_lints` active. `debugPrint()` not `print()`. Null-safety enforced.
- **TypeScript**: Strict mode. No `any`. NestJS exceptions only — no raw `Error` throws.
- **Imports (Dart)**: SDK → Flutter → packages → local.
- **Imports (TS)**: NestJS core → third-party → local.
- **Barrel exports**: `index.ts` in TS module dirs. Not standard in Dart — use direct imports.
- **Naming**: snake_case files (Dart), kebab-case files (TS). See agent docs for full tables.
```

Replace with:

```
- **Dart**: `flutter_lints` active. `debugPrint()` not `print()`. Null-safety enforced.
- **Imports (Dart)**: SDK → Flutter → packages → local.
- **Naming**: snake_case files. See `lib/AGENTS.md` and `lib/core/AGENTS.md` for module-scoped conventions.
```

- [ ] **Step 1.7: Edit — drop ANTI-PATTERNS rows that mention TypeScript/NestJS**

Find:

```
- `setState` for non-trivial state → use Riverpod.
- `@riverpod` annotation omitted → breaks codegen, always annotate.
- Hardcoded UI strings → use `AppLocalizations.of(context)!.key`.
- Hard-deleting records in backend → use `isActive: false`.
- Renaming fields when porting Flutter→Mongoose → breaks sync, keep names identical.
- `any` type in TypeScript.
- Raw `Error` throws in NestJS — use `NotFoundException`, `ConflictException`, etc.
- Modifying `lib/` from a backend task or `backend/` from a Flutter task.
```

Replace with:

```
- `setState` for non-trivial state → use Riverpod.
- `@riverpod` annotation omitted → breaks codegen, always annotate.
- Hardcoded UI strings → use `AppLocalizations.of(context)!.key`.
- Renaming fields on syncable models → breaks the cross-repo contract, keep names identical to the API.
- Adding a `// ignore:` directive instead of fixing root cause.
- Modifying generated `*.g.dart` files by hand.
```

- [ ] **Step 1.8: Edit — drop the backend section from COMMANDS**

Find:

```
# Backend
cd backend && npm install
npm run start:dev
npm run build
npm test
```

Delete those lines and the `# Backend` comment header. Keep only the Flutter commands above them.

- [ ] **Step 1.9: Edit — refresh NOTES section**

Find:

```
- `.github/agents/flutter-app.agent.md` and `nestjs-backend.agent.md` contain full role-specific rules — read them before starting work.
- `lib/core/services/platforms/` uses conditional imports to split web/mobile implementations.
- `test/golden/` contains screenshot regression tests — run flutter test to verify.
- `analysis_options.yaml` uses `package:flutter_lints/flutter.yaml` with no additional overrides.
```

Replace with:

```
- `.github/agents/flutter-app.agent.md` contains role-specific rules — read it before starting work. (`nestjs-backend.agent.md` is legacy and pending refresh; the backend lives in a sibling repository now.)
- `lib/core/services/platforms/` uses conditional imports to split web/mobile implementations.
- `test/golden/`, `test/unit/`, `test/widget/`, `test/integration/` are present but empty as of 2026-05-08 — Phase 3 of the correction pass populates them.
- `analysis_options.yaml` uses `package:flutter_lints/flutter.yaml` with no additional overrides.
- `flutter analyze` returns `No issues found!` (Phase 1 of the 2026-05-08 correction pass cleaned 14 baseline issues).
```

- [ ] **Step 1.10: Edit — bump the Generated date**

Find:

```
**Generated:** 2026-04-29
```

Replace with:

```
**Generated:** 2026-04-29
**Last refreshed:** 2026-05-08
```

- [ ] **Step 1.11: Verify edits — read the full file once**

```bash
wc -l AGENTS.md
```

Expected: roughly the same line count as before (~110–120 lines after deletions and additions roughly balance).

Search for any remaining references to the removed backend:

```bash
grep -nE "backend/src|nestjs-backend|NestJS" AGENTS.md
```

Acceptable: zero matches, OR a single match in the "Notes" section line referring to `nestjs-backend.agent.md` as legacy. **Any other match means a backend reference was missed — go back and fix.**

- [ ] **Step 1.12: Commit**

```bash
git add AGENTS.md
git commit -m "$(cat <<'EOF'
docs: refresh root AGENTS.md after backend relocation

Drop the ARCHITECTURE: BACKEND section, the backend rows in WHERE TO
LOOK, and the TypeScript/NestJS conventions and anti-patterns. The
backend now lives in a sibling repository (`../backend/`); this doc
covers the Flutter project only. Add Last refreshed date, network/
sync/test directory rows, and a note about the empty test
subdirectories pending Phase 3.
EOF
)"
```

---

## Task 2: Refresh `lib/AGENTS.md`

**File:**
- Modify: `lib/AGENTS.md`

**Issue:** STRUCTURE block lists 13 features under `lib/features/`. Actual count is 16 — missing `identification/`, `sync/`, and the order of `auth/` is fine but the doc lists `auth/` first which doesn't match the alphabetical order of the rest. The "MODEL CONVENTIONS" and "SCREEN CONVENTIONS" sections are accurate.

- [ ] **Step 2.1: Verify baseline**

```bash
grep -c "^│" lib/AGENTS.md
```

Note the count for reference.

- [ ] **Step 2.2: Edit — STRUCTURE block**

Find the existing features list:

```
├── features/             # One dir per feature — contains screens/ only
│   ├── auth/
│   ├── home/             # Plant list, main navigation
│   ├── plant_form/       # Create/edit plant record
│   ├── plant_detail/
│   ├── plant_edit/
│   ├── quick_capture/    # Fast entry with GPS + camera
│   ├── sessions/         # Collection session management
│   ├── map/
│   ├── search/
│   ├── photo_gallery/
│   ├── statistics/
│   ├── export_import/
│   ├── settings/
│   └── onboarding/
```

Replace with (alphabetically sorted, 16 entries — adds `identification/` and `sync/`):

```
├── features/             # One dir per feature — contains screens/ only (16 features)
│   ├── auth/             # Login, register
│   ├── export_import/
│   ├── home/             # Plant list, main navigation
│   ├── identification/   # Dichotomous key
│   ├── map/
│   ├── onboarding/
│   ├── photo_gallery/
│   ├── plant_detail/
│   ├── plant_edit/
│   ├── plant_form/       # Create/edit plant record
│   ├── quick_capture/    # Fast entry with GPS + camera
│   ├── search/
│   ├── sessions/         # Collection session management
│   ├── settings/
│   ├── statistics/
│   └── sync/             # Conflict resolution UI
```

- [ ] **Step 2.3: Verify**

```bash
grep -E "auth/|export_import/|home/|identification/|map/|onboarding/|photo_gallery/|plant_detail/|plant_edit/|plant_form/|quick_capture/|search/|sessions/|settings/|statistics/|sync/" lib/AGENTS.md | wc -l
```

Expected: at least 16 (one line per feature).

- [ ] **Step 2.4: Commit**

```bash
git add lib/AGENTS.md
git commit -m "$(cat <<'EOF'
docs: add identification/ and sync/ features to lib/AGENTS.md

Resorts the feature list alphabetically and includes the two features
added since the doc was written: identification (dichotomous key) and
sync (conflict resolution UI).
EOF
)"
```

---

## Task 3: Refresh `lib/core/AGENTS.md`

**File:**
- Modify: `lib/core/AGENTS.md`

**Issue:** The STRUCTURE block lists 9 services and 3 repositories. Actual: 22 services and 4 repositories. Several top-level core directories (`config/`, `errors/`, `providers/`, `sync/`, `network/`) are listed in the actual `lib/core/` but not all are accurate in the doc.

- [ ] **Step 3.1: Edit — STRUCTURE block, services list**

Find:

```
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
```

Replace with (22 services, alphabetical, comments only on the most-touched ones):

```
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
```

- [ ] **Step 3.2: Edit — STRUCTURE block, repositories list**

Find:

```
├── repositories/
│   ├── plant_repository.dart    # CRUD + FTS + GPS radius queries
│   ├── session_repository.dart
│   └── saved_search_repository.dart
```

Replace with:

```
├── repositories/                # 4 repositories
│   ├── plant_repository.dart    # CRUD + FTS + GPS radius queries
│   ├── session_repository.dart
│   ├── saved_search_repository.dart
│   └── template_repository.dart # Collection templates
```

- [ ] **Step 3.3: Edit — STRUCTURE block, top-level directories**

Find the directory list at the top of the STRUCTURE block:

```
core/
├── database/
│   ├── isar_service.dart        # IsarService singleton — init all schemas here
│   └── platforms/               # Conditional imports: web vs mobile DB setup
├── repositories/
[…]
├── services/
[…]
├── providers/                   # Shared/cross-cutting @riverpod providers
├── sync/                        # Offline sync orchestration
├── errors/                      # AppError sealed class + error handler
├── network/                     # Dio client, interceptors
├── theme/                       # FoliumTheme — colors, typography, spacing
└── utils/                       # Pure utility functions
```

The `config/` directory exists in the actual tree but is not listed. Add it after `database/`:

```
├── config/                      # Compile-time configuration (e.g., API endpoints)
├── database/
│   ├── isar_service.dart        # IsarService singleton — init all schemas here
│   └── platforms/               # Conditional imports: web vs mobile DB setup
```

(Keep the rest of the directory list as-is.)

- [ ] **Step 3.4: Verify**

```bash
ls -1 lib/core/services/ | grep -v "\.g\.dart$" | grep -v "^platforms$" | wc -l
grep -c "_service\.dart$" lib/core/AGENTS.md
```

Both numbers should be `22`.

- [ ] **Step 3.5: Commit**

```bash
git add lib/core/AGENTS.md
git commit -m "$(cat <<'EOF'
docs: refresh lib/core/AGENTS.md service and repository inventories

Bring the STRUCTURE block in line with reality: 22 services (was 9),
4 repositories (was 3), add config/ to the top-level dir list. The
new service entries are alphabetical for easier diffing in future
audits.
EOF
)"
```

---

## Task 4: Refresh `README.md`

**File:**
- Modify: `README.md`

**Issue:** The README is the largest doc and has the most drift. Audit findings:
- Project Structure tree omits 5 features, 12 services, 7 models.
- Screens table has 16 rows but the app now ships 19+ screens (auth, sync, dichotomous key, quick capture, conflict resolution, templates, inaturalist auth).
- Dependencies table omits 8 packages added since v1.8.0.
- Features section under "Plant Management" / "Maps & Location" / etc. is mostly accurate but new feature categories are missing.
- The link `[RELEASE_NOTES_v1.8.0.md](RELEASE_NOTES_v1.8.0.md)` is broken — that file was deleted in `798bc77`.
- "Roadmap" section at the bottom lists planned features that are now done.

- [ ] **Step 4.1: Edit — Project Structure tree**

Locate the `lib/` ASCII tree under `## 📦 Project Structure`. Replace the existing tree with this updated version (tracks the actual `lib/` contents at 2026-05-08; comments updated; `core/config/`, `core/errors/`, `core/network/`, `core/sync/` listed; new services/repositories/models added; new features listed):

```
lib/
├── core/                        # Core infrastructure
│   ├── config/                 # Compile-time configuration (API endpoints, build flavors)
│   ├── database/               # Isar DB (mobile/web platform split)
│   │   └── platforms/          # isar_service_mobile.dart, _web.dart
│   ├── errors/                 # AppError sealed class + error handler
│   ├── network/                # Dio client, interceptors, token storage
│   │   ├── api_client.dart
│   │   ├── api_endpoints.dart
│   │   ├── auth_interceptor.dart
│   │   ├── connectivity_interceptor.dart
│   │   └── token_storage.dart
│   ├── providers/              # Cross-cutting @riverpod providers (auth, sync, rain mode, taxon)
│   ├── repositories/           # 4 repositories (plant, session, saved_search, template)
│   ├── services/               # 22 services — see lib/core/AGENTS.md for the full list
│   ├── sync/                   # sync_service.dart (push/pull orchestration, conflict resolution)
│   ├── theme/                  # FoliumTheme (light + dark)
│   └── utils/                  # BotanicalValidator, GeoUtils, biome_detector
├── features/                    # 16 feature modules
│   ├── auth/                   # Login, register
│   ├── export_import/
│   ├── home/                   # 5-tab navigation hub
│   ├── identification/         # Dichotomous key for species ID
│   ├── map/                    # Map view + offline maps
│   ├── onboarding/             # 5-page guided tutorial
│   ├── photo_gallery/          # Cross-plant photo grid + fullscreen viewer
│   ├── plant_detail/           # Hero image detail view
│   ├── plant_edit/             # Quick taxonomy editor
│   ├── plant_form/             # 6-tab plant creation
│   ├── quick_capture/          # Fast plant entry with GPS + camera
│   ├── search/                 # Dual-mode search + filters
│   ├── sessions/               # Session form + detail + sharing
│   ├── settings/               # Settings + identifier management + templates + iNaturalist auth
│   ├── statistics/             # Charts and analytics
│   └── sync/                   # Conflict resolution UI
├── models/                      # 15 Isar models
│   ├── collection_method.dart
│   ├── collection_session.dart
│   ├── collection_template.dart
│   ├── determination.dart
│   ├── gps_point.dart
│   ├── measurement.dart        # @embedded
│   ├── municipality_bounding_box_cache.dart
│   ├── phenological_state.dart
│   ├── photo_metadata.dart     # @embedded
│   ├── plant_category.dart     # enum
│   ├── plant_record.dart       # Core plant model (30+ fields)
│   ├── saved_search.dart
│   ├── settings.dart
│   ├── sync_metadata.dart      # @embedded
│   └── taxon_cache.dart
├── shared/                      # Shared components
│   ├── constants/              # biome_templates, app constants
│   ├── utils/                  # Shared utilities
│   └── widgets/                # Reusable widgets
│       ├── modern/             # ModernPlantCard, GlassAppBar, SyncStatusIcon, etc.
│       ├── audio/              # AudioRecorder, AudioPlayer
│       ├── fenologia_fournier_widget.dart
│       ├── ocr_review_dialog.dart
│       ├── plantnet_results_sheet.dart
│       ├── rain_mode_guard.dart
│       └── map_widget.dart
└── l10n/                        # Localization (pt, en, es)
```

- [ ] **Step 4.2: Edit — Screens table**

Find the table that begins:

```
| #   | Screen                    | Description                                                                    |
| --- | ------------------------- | ------------------------------------------------------------------------------ |
| 1   | **Onboarding**            | 5-page guided intro with initial setup                                         |
```

Append the following rows (numbered continuing from the existing table — the existing table ends at row 16, "Identifier Management"):

```
| 17  | **Login / Register**      | Email/password + Google sign-in (gated by `auth/`)                             |
| 18  | **Dichotomous Key**       | Step-by-step taxonomic identification flow                                     |
| 19  | **Quick Capture**         | One-tap plant entry: GPS + camera + auto-identifier                            |
| 20  | **Conflict Resolution**   | Sync conflict review and per-record resolution                                 |
| 21  | **Templates**             | Collection-template management                                                 |
| 22  | **iNaturalist Auth**      | API token configuration for iNaturalist push                                   |
```

- [ ] **Step 4.3: Edit — Features section, add new subsections**

Find the section that ends with `### ⚙️ Settings` and `### 🌍 Internationalization`. Insert two new subsections **before** the `### 🎨 Modern Design` subsection:

```
### 🔐 Authentication & Cloud Sync

- **Email/password sign-up & sign-in**: Account creation and authentication via the app's NestJS API
- **Google sign-in**: One-tap sign-in via `google_sign_in`
- **Persistent sessions**: Tokens stored via `flutter_secure_storage`; auto-refresh on expiry
- **Two-way sync**: Push local Isar changes to API, pull remote changes; conflict resolution UI for divergent records
- **Sync status indicator**: AppBar icon shows sync state (idle, syncing, error)

### 🔬 Identification & Enrichment

- **Dichotomous Key**: Multi-step taxonomic key flow for species identification in the field
- **PlantNet integration**: Image-based plant identification via the PlantNet API (configurable API key)
- **iNaturalist integration**: Auto-fill from observations + push records to iNaturalist
- **OCR for label digitization**: Camera-based text recognition (`google_mlkit_text_recognition`) with review dialog
- **Weather & moon phase**: Auto-fill weather and moon-phase metadata at collection time
- **Geocoding**: Reverse-geocode GPS to municipality / locality
- **Herbarium label generation**: PDF labels for physical specimens

### 🚀 Quick Capture

- **One-tap entry**: GPS + camera + auto-generated registry ID in a single screen
- **Rain mode**: Reduces destructive-action accidents in poor field conditions (countdown unlock)
```

- [ ] **Step 4.4: Edit — Dependencies table**

Locate the Dependencies table under `## 📊 Technical Stack` → `### Dependencies`. Add 8 packages to existing rows (or create new rows where they don't fit). The packages currently in `pubspec.yaml` but missing from this README are: `dio`, `http`, `flutter_secure_storage`, `geocoding`, `google_mlkit_text_recognition`, `pdf`, `printing`, `url_launcher`.

Find these existing rows:

```
| **Cloud**              | `connectivity_plus`, `googleapis`, `googleapis_auth`, `google_sign_in`                    |
```

Replace with:

```
| **Cloud / Auth**       | `connectivity_plus`, `googleapis`, `googleapis_auth`, `google_sign_in`, `flutter_secure_storage` |
```

Find:

```
| **QR Code**            | `qr_flutter`, `mobile_scanner`                                                            |
```

Replace with:

```
| **QR Code / OCR**      | `qr_flutter`, `mobile_scanner`, `google_mlkit_text_recognition`                           |
```

Find:

```
| **Location/Maps**      | `geolocator`, `permission_handler`, `flutter_map`, `flutter_map_tile_caching`, `latlong2` |
```

Replace with:

```
| **Location/Maps**      | `geolocator`, `geocoding`, `permission_handler`, `flutter_map`, `flutter_map_tile_caching`, `latlong2` |
```

Find:

```
| **Data Export/Import** | `csv`, `excel`, `archive`, `file_picker`                                                  |
```

Replace with:

```
| **Data Export/Import** | `csv`, `excel`, `archive`, `file_picker`, `pdf`, `printing`                               |
```

Find:

```
| **Utility**            | `uuid`, `share_plus`, `intl`, `logger`                                                    |
```

Replace with:

```
| **Networking**         | `dio`, `http`                                                                             |
| **Utility**            | `uuid`, `share_plus`, `intl`, `logger`, `url_launcher`                                    |
```

(The new `Networking` row is inserted in the table alongside the others.)

- [ ] **Step 4.5: Edit — fix the broken release-notes link**

Find:

```
See [RELEASE_NOTES_v1.8.0.md](RELEASE_NOTES_v1.8.0.md) for detailed release notes.
```

The file `RELEASE_NOTES_v1.8.0.md` was removed in `798bc77`. Delete the line entirely. (Re-creating the file is out of scope — the v1.8.0 entry already in the README's Version History captures the high-level changelog.)

- [ ] **Step 4.6: Edit — Roadmap section at the bottom of the README**

Find:

```
## 🗺️ Roadmap

### Planned Features

- 🍎 iOS version with glassmorphic design
- 🔄 Server-based sync and real-time collaboration (sync infrastructure already stubbed)
- 📱 QR code generation and scanning for specimens (dependencies already included)
- 📊 Custom report generation
- 🏛️ Integration with herbarium databases (speciesLink, GBIF)
- ☁️ Dropbox backup support
```

Replace with (`Server-based sync` is now done, `QR code` is implemented; surface the actual roadmap from `ROADMAP.md`):

```
## 🗺️ Roadmap

### Recently shipped (since v1.8.0)

- ☁️ Server-based sync via NestJS API (auth, push/pull, conflict resolution)
- 🔬 PlantNet, iNaturalist, OCR, weather, moon phase integrations
- 🌳 Dichotomous key for taxonomic identification
- ⚡ Quick Capture entry mode
- 🌧️ Rain mode (destructive-action guard)

### Planned

- 🍎 iOS version with glassmorphic design
- 👥 Real-time collaboration (multi-user session editing)
- 📊 Custom report generation
- 🏛️ Direct integration with herbarium databases (speciesLink, GBIF)
- ☁️ Dropbox backup support

See `ROADMAP.md` for the full sequenced backlog and `docs/superpowers/specs/2026-05-08-folium-correction-and-polish-design.md` for the active correction pass.
```

- [ ] **Step 4.7: Verify edits**

```bash
# No reference to the deleted release-notes file
grep -n "RELEASE_NOTES_v1.8.0" README.md && echo "FAIL — still referenced" || echo "(no broken release-notes link)"

# All 8 missing dependencies now present
for pkg in dio http flutter_secure_storage geocoding google_mlkit_text_recognition pdf printing url_launcher; do
  grep -q "$pkg" README.md && echo "OK: $pkg" || echo "MISSING: $pkg"
done

# Each of the 5 missing features now mentioned at least once
for feat in auth sync identification quick_capture; do
  grep -q "$feat/" README.md && echo "OK: $feat" || echo "MISSING: $feat"
done
```

All `grep` checks must pass.

- [ ] **Step 4.8: Commit**

```bash
git add README.md
git commit -m "$(cat <<'EOF'
docs: refresh README to reflect 16 features, 22 services, 15 models

Bring the Project Structure tree, Screens table, Features section,
and Dependencies table in line with the actual lib/ contents at
2026-05-08. Add new feature subsections (Auth & Cloud Sync,
Identification & Enrichment, Quick Capture). Remove the broken
RELEASE_NOTES_v1.8.0.md link (file deleted in 798bc77). Update the
bottom Roadmap to surface what shipped since v1.8.0 and reference
ROADMAP.md for the full backlog.
EOF
)"
```

---

## Task 5: Refresh `ROADMAP.md`

**File:**
- Modify: `ROADMAP.md`

**Issue:** The roadmap was last touched 2026-03-17 and lists Phase 1 items as P0/Critical. Verified during audit: every item in roadmap Phase 1.1, 1.2, 1.3, 1.4 exists in `lib/`. The Technical Debt table claims "No HTTP client in Flutter" — false. The Priority Matrix's P0 row is now empty.

- [ ] **Step 5.1: Edit — top-of-file metadata**

Find:

```
> Last updated: March 17, 2026  
> Current state: Mature Flutter frontend (offline-first), early NestJS backend with basic modules, sync infrastructure not yet connected
```

Replace with:

```
> Last updated: 2026-05-08
> Current state: Mature Flutter frontend (offline-first); HTTP/auth/sync infrastructure shipped; sync service is wired and conflict resolution UI exists; backend lives in a sibling repository (`../backend/`).
```

- [ ] **Step 5.2: Edit — Current State Summary table**

Find:

```
| Area | Maturity | Notes |
|------|----------|-------|
| Flutter Frontend | ★★★★☆ | 11 feature modules, Isar local DB, export/import, maps, audio transcription |
| NestJS Backend | ★★☆☆☆ | Auth, CRUD modules, R2 upload, Swagger — but shallow test coverage |
| Sync (Flutter ↔ API) | ★☆☆☆☆ | Backend endpoints exist but Flutter has no HTTP client at all |
| CI/CD | ☆☆☆☆☆ | No GitHub Actions, manual builds and releases |
| Testing | ★☆☆☆☆ | Minimal — 2 backend unit specs, 1 e2e spec; Flutter test dirs exist but sparse |
```

Replace with:

```
| Area | Maturity | Notes |
|------|----------|-------|
| Flutter Frontend | ★★★★☆ | 16 feature modules, Isar local DB, export/import, maps, audio transcription, OCR, weather/moon enrichments |
| Sync (Flutter ↔ API) | ★★★☆☆ | Dio HTTP client + auth interceptor + token storage in place; AuthNotifier wired; SyncService orchestrator + conflict resolution UI shipped |
| Backend | n/a | Lives in sibling repository (`../backend/`); see that project's docs for backend maturity |
| CI/CD | ☆☆☆☆☆ | No GitHub Actions, manual builds and releases |
| Testing | ★☆☆☆☆ | Flutter `test/{unit,widget,integration,golden}/` directories present but empty — Phase 3 of the 2026-05-08 correction pass populates them |
| Code quality | ★★★★★ | `flutter analyze` clean (Phase 1 of the 2026-05-08 correction pass) |
```

- [ ] **Step 5.3: Edit — tick Phase 1 checkboxes**

Find each section heading `### 1.1 Flutter HTTP Client Layer`, `### 1.2 Auth Integration on Flutter`, `### 1.3 Sync Service on Flutter`, `### 1.4 Media Upload Coordination`. For each `- [ ]` item under those four sections that is verifiably implemented, change `- [ ]` to `- [x]`.

Verification list (each `[x]` below is justified by a file in `lib/`):

**1.1 Flutter HTTP Client Layer:**
- `Add dio dependency to pubspec.yaml` → ✓ (line 103 of `pubspec.yaml`)
- `Create lib/core/network/api_client.dart` → ✓
- `Create lib/core/network/auth_interceptor.dart` → ✓
- `Create lib/core/network/connectivity_interceptor.dart` → ✓
- `Store tokens securely with flutter_secure_storage` → ✓ (`lib/core/network/token_storage.dart`)
- `Create lib/core/network/api_endpoints.dart` → ✓

→ Tick all 6 boxes.

**1.2 Auth Integration on Flutter:**
- `Create lib/core/services/auth_service.dart` → ✓
- `Create AuthNotifier Riverpod provider` → ✓ (`lib/core/providers/auth_provider.dart`)
- `Add login/register screens` → ✓ (`lib/features/auth/screens/`)
- `Persist auth state across app restarts` → ✓ (token storage + `_checkExistingSession`)
- `Handle token expiry gracefully` → partial; the auth_interceptor refreshes on 401, the UI redirects to login via the AuthNotifier state. Tick.

→ Tick all 5 boxes.

**1.3 Sync Service on Flutter:**
- `Create lib/core/sync/sync_service.dart` → ✓
- `Map Isar PlantRecord fields → API SyncRegistryItemDto JSON` → ✓ (in `sync_service.dart`)
- `Map Isar CollectionSession fields → API SyncSessionItemDto JSON` → ✓
- `Implement conflict resolution UI` → ✓ (`lib/features/sync/screens/conflict_resolution_screen.dart`)
- `Create lib/core/sync/sync_queue.dart` → ✗ (not present as a separate file — sync queueing logic lives inside `sync_service.dart`; do NOT tick this one — leave it `[ ]` so a future split is still tracked)
- `Add sync status indicator in app bar or settings` → ✓ (`lib/shared/widgets/modern/sync_status_icon.dart`)
- `Background sync with workmanager or periodic timer` → ✗ (not present; leave `[ ]`)

→ Tick 5 of 7 boxes; leave 2 open.

**1.4 Media Upload Coordination:**
- `Before sync push, upload local photos to R2 via upload endpoint` → ✓ (`lib/core/services/media_upload_service.dart`)
- `Replace local file paths with R2 URLs` → ✓ (in `sync_service.dart`'s `IsarToApiMapper` flow)
- `Handle partial upload failures (retry queue)` → partial; basic retry exists in `media_upload_service.dart`. Leave `[ ]` for full retry-queue work.
- `Download remote images on pull for offline access` → partial; `cached_network_image` is in pubspec, used in `ModernPlantCard`. Tick.
- `Audio file upload support` → ✗ (audio upload not yet wired). Leave `[ ]`.

→ Tick 3 of 5 boxes; leave 2 open.

- [ ] **Step 5.4: Edit — Technical Debt table**

Find:

```
| Item | Location | Severity |
|------|----------|----------|
| No HTTP client in Flutter | `lib/core/` | **Critical** — blocks all cloud features |
| Sync module is basic | `backend/src/modules/sync/` | **High** — conflict resolution needs real-world testing |
| Only 3 backend test files | `backend/src/`, `backend/test/` | **High** — refactoring risky without coverage |
| No CI/CD | `.github/workflows/` | **Medium** — manual process prone to errors |
| Google Drive backup vs R2 sync overlap | `lib/core/services/google_drive_backup_service.dart` | **Low** — two backup mechanisms, clarify which is primary |
| Hardcoded rate limits | `backend/src/app.module.ts` | **Low** — env-configurable per route |
| No database migrations strategy | `backend/` | **Medium** — schema changes need coordination |
```

Replace with (drop the "No HTTP client in Flutter" row entirely; drop the four backend rows since the backend is in a sibling repo and tracked there; keep the Flutter-only debt and add new items found in the 2026-05-08 audit):

```
| Item | Location | Severity |
|------|----------|----------|
| Conflict resolution needs real-world testing | `lib/core/sync/sync_service.dart`, `lib/features/sync/` | **High** — the orchestrator is in place but stress-test gaps remain |
| No Flutter test coverage | `test/{unit,widget,integration,golden}/` | **High** — directories exist but empty; Phase 3 of the 2026-05-08 correction pass populates them |
| Oversized screens | `plant_form_screen.dart` (3531), `plant_detail_screen.dart` (2175), `plant_edit_screen.dart` (1651), `settings_screen.dart` (2124) | **Medium** — Phase 4 of the correction pass refactors these |
| No CI/CD | `.github/workflows/` | **Medium** — manual builds and releases |
| Sync queue not externalized | `lib/core/sync/` | **Low** — queueing logic embedded in sync_service.dart; could move to sync_queue.dart for testability |
| Background sync not wired | `lib/core/sync/` | **Low** — no `workmanager` integration; manual sync only |
| Google Drive backup vs R2 sync overlap | `lib/core/services/google_drive_backup_service.dart` | **Low** — two backup mechanisms, clarify which is primary |
| Audio upload to R2 not implemented | `lib/core/services/media_upload_service.dart` | **Low** — audio recordings are local-only |
```

- [ ] **Step 5.5: Edit — Priority Matrix**

Find:

```
| Priority | Items | Impact | Effort |
|----------|-------|--------|--------|
| **P0 — Now** | Flutter HTTP client, Auth integration, Sync service | Unlocks cloud features | Medium |
| **P1 — Soon** | Backend testing, CI/CD pipelines, Media upload coordination | Reliability & velocity | Medium |
| **P2 — Next** | Session sharing via backend, Species enrichment, Security hardening | Collaboration & data quality | Large |
| **P3 — Later** | Notifications, Reporting, Web dashboard | User engagement | Large |
| **P4 — Wishlist** | AI plant ID, GBIF publishing, Hardware integration | Differentiation | Very Large |
```

Replace with (drop the obsolete P0 row, promote items, reflect new priorities; this is a *judgment call* recorded as the project's current best guess — re-prioritizing further is a separate product decision):

```
| Priority | Items | Impact | Effort |
|----------|-------|--------|--------|
| **P0 — Now** | Flutter test foundation (Phase 3 of correction pass), oversized-screen refactor (Phase 4) | Code quality & velocity | Large |
| **P1 — Soon** | CI/CD pipelines, Background sync (`workmanager`), Audio upload to R2 | Reliability & feature parity | Medium |
| **P2 — Next** | Session sharing via backend, Species enrichment, Security hardening, Sync queue extraction | Collaboration & data quality | Large |
| **P3 — Later** | Notifications, Reporting, Web dashboard, iOS build | User engagement, platform reach | Large |
| **P4 — Wishlist** | AI plant ID, GBIF publishing, Hardware integration | Differentiation | Very Large |
```

- [ ] **Step 5.6: Verify edits**

```bash
# No claim that Flutter has no HTTP client
grep -ni "no http client in flutter" ROADMAP.md && echo "FAIL" || echo "(removed)"

# No backend-only tech-debt rows in the table
grep -E "^\| .* \| \`backend/" ROADMAP.md && echo "FAIL" || echo "(no backend rows)"

# At least 11 ticked boxes (6 from 1.1 + 5 from 1.2)
grep -c "^- \[x\]" ROADMAP.md
```

The third command must report ≥14 (we ticked 6+5+5+3 = 19 in total across 1.1, 1.2, 1.3, 1.4). If lower, recount the ticks per Step 5.3.

- [ ] **Step 5.7: Commit**

```bash
git add ROADMAP.md
git commit -m "$(cat <<'EOF'
docs: mark Phase 1 roadmap items done; refresh debt and priorities

Tick 19 boxes across roadmap sections 1.1 (HTTP client), 1.2 (auth),
1.3 (sync service), 1.4 (media upload) — each verified against a
file in lib/. Drop the "No HTTP client in Flutter" tech-debt row and
the four backend-tracked debt rows (backend is in a sibling repo
now). Add new debt items surfaced by the 2026-05-08 audit (no
Flutter tests, oversized screens, no background sync, no audio
upload, sync-queue not extracted). Re-shape the Priority Matrix to
make Flutter test foundation and oversized-screen refactor the new
P0 — these are Phases 3 and 4 of the active correction pass. Update
metadata to "Last updated: 2026-05-08".
EOF
)"
```

---

## Task 6: Final verification

**Files:** none modified.

- [ ] **Step 6.1: Branch shape**

```bash
git log --oneline phase-2/doc-refresh ^main
```

Expected: 5 commits (Tasks 1, 2, 3, 4, 5).

- [ ] **Step 6.2: Cross-check — every doc claim maps to reality**

```bash
# Every feature directory mentioned in README must exist
for f in $(grep -oE "lib/features/[a-z_]+/" README.md | sort -u); do
  test -d "$f" && echo "OK: $f" || echo "MISSING: $f"
done

# Every service mentioned in README's Project Structure (or "22 services") must be present
ls -1 lib/core/services/ | grep -v "\.g\.dart$" | grep -v "^platforms$" | wc -l
# expected: 22 — must match the README's "22 services" label

# Every model mentioned must exist
ls -1 lib/models/ | grep -v "\.g\.dart$" | wc -l
# expected: 15 — must match the README's "15 Isar models" label

# AGENTS.md no longer references removed backend
grep -nE "backend/src|backend/docker" AGENTS.md && echo "FAIL" || echo "(no stale backend refs)"

# ROADMAP.md no longer makes the false "no HTTP client" claim
grep -ni "no http client in flutter" ROADMAP.md && echo "FAIL" || echo "(removed)"

# README has no broken release-notes link
grep -n "RELEASE_NOTES_v1.8.0" README.md && echo "FAIL" || echo "(no broken link)"
```

All checks must pass before merging.

- [ ] **Step 6.3: Working tree clean**

```bash
git status --porcelain
```

Must be empty.

- [ ] **Step 6.4: Phase 2 close-out**

```bash
git checkout main
git merge --ff-only phase-2/doc-refresh
git branch -d phase-2/doc-refresh
git log --oneline -8
```

Expected: 5 new commits between Phase 1's `c59067d` and the new HEAD. Branch deleted.

Phase 2 complete. Phase 3 (test foundation) is the next session's work.

---

## Self-review checklist (already run)

- [x] **Spec coverage** — Phase 2 sections 2.1, 2.2, 2.3 are all covered. The spec said "AGENTS.md: no edits expected" but the audit revealed the WIP commit moved `backend/` out of `field_book/`, leaving stale backend references in the root `AGENTS.md` — that's a real edit, in scope of "doc refresh." The two scoped AGENTS.md files (`lib/AGENTS.md`, `lib/core/AGENTS.md`) are also covered (Tasks 2 and 3); the spec implicitly covers them under "AGENTS.md" but the plan is explicit about all three.

- [x] **Placeholder scan** — every step has concrete before/after text or commands. No `TBD`, no `// fill in`. The verification commands have explicit expected outputs.

- [x] **Type consistency** — N/A (no code).

- [x] **Scope discipline** — `.github/agents/` and `.github/instructions/` are explicitly out of scope. Re-creating `RELEASE_NOTES_v1.8.0.md` is out of scope (just remove the link). Re-prioritizing the Priority Matrix beyond the obvious P0-emptiness fix is logged as a "judgment call" inline.

- [x] **Verification rigor** — final task has explicit cross-check commands that compare doc claims to `lib/` reality. Each Task has a per-task verification step before commit.

---

## Deferred follow-ups (logged, NOT done in this phase)

- `.github/agents/flutter-app.agent.md` and `.github/agents/nestjs-backend.agent.md` are stale — the latter references a backend that is no longer in this repo. Refresh in a future doc pass.
- `.github/instructions/nestjs-backend.instructions.md` likewise.
- `.github/prompts/plan-offlineFirstBotanicalFieldBook.prompt.md` and `.github/prompts/generate-sync-module.prompt.md` — verify currency.
- Re-prioritizing the Priority Matrix beyond removing the empty P0 row is a product decision. The plan picks "Flutter test foundation" and "oversized-screen refactor" as the new P0 because those are Phases 3 and 4 of the active correction pass — but a different stakeholder might choose differently. Revisit in a planning conversation.
- The README's bottom Roadmap section duplicates content in `ROADMAP.md` — Phase 2 keeps both in sync but a future pass might consolidate.
- v1.9.0 release notes — when Phase 5 completes and the cumulative changes warrant a version bump, a new `RELEASE_NOTES_v1.9.0.md` should capture: the correction pass results, the new features in lib/, the dependency additions. Out of scope for Phase 2.
