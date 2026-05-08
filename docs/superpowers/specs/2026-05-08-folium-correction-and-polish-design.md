# Folium — Correction & Polish

**Date:** 2026-05-08
**Author:** Brainstorming session w/ Claude Code
**Status:** Design — pending implementation plan

---

## Background

Folium (`field_book/`) is a mature offline-first botanical field collection app: 132 Dart files, 43k lines, 14 feature modules, Riverpod codegen + Isar local DB, Flutter `^3.10.8`. Discipline is high — zero `print()` calls, zero `TODO`/`FIXME` debt.

A focused audit (2026-05-08) found that the project's stated documentation is significantly behind its actual state and that the real work is consolidation, not greenfield:

- `flutter analyze`: **14 info-level issues** (8 real async-context bugs, 2 deprecated Radio API uses, 4 cosmetic).
- **4 screens >1500 lines** (`plant_form_screen.dart` 3,531; `plant_detail_screen.dart` 2,175; `settings_screen.dart` 2,124; `plant_edit_screen.dart` 1,651). All but `settings_screen.dart` are monoliths in a single `State` class. `settings_screen.dart` is already class-decomposed and only needs splitting into separate files.
- **Test coverage effectively zero**: `test/{unit,widget,integration,golden}/` directories exist but are empty; only `test/widget_test.dart` (smoke test) is real.
- **Doc drift**: `ROADMAP.md` (last updated 2026-03-17) lists as P0 work that is already in `lib/` (HTTP client, auth integration, sync service, conflict resolution UI, media upload). `README.md` (v1.8.0) does not mention 5 features, 12 services, and 7 models that exist in code. `RELEASE_NOTES_v1.8.0.md` is linked from README but does not exist.

This spec defines a sequenced, behavior-preserving correction pass. No new features.

---

## Goals

1. Zero `flutter analyze` warnings on `lib/`.
2. Documentation matches code reality (a fresh contributor reading `README.md`, `ROADMAP.md`, `AGENTS.md` gets an accurate picture).
3. Baseline test foundation: ≥70% line coverage on `lib/core/repositories/` and 5 named services; widget tests for all refactored UI components; one full integration test.
4. No source file >500 lines (excluding generated `*.g.dart` and `lib/l10n/` ARB-derived files).
5. Sync orchestrator (`sync_service.dart`) decomposed into testable units.

---

## Non-Goals

- NestJS backend at `../backend/`.
- Next.js frontend at `../frontend/`.
- iOS build, App Store / Play Store readiness.
- Any new language localization.
- Any new feature, design-system change, or visual redesign.
- Any backwards-compatibility migration logic — this is internal refactor only.
- The Phase 2+ ROADMAP items (backend testing, CI/CD, notifications, AI plant ID, etc.).

If we discover a bug or dead code during refactor, it is **logged** in the implementation plan's deferred-followup list, not fixed inline.

---

## Sequencing

A → D → C-stable → B → C-widgets. Each phase is one branch and one merge. Phase N+1 does not start until Phase N is merged green.

Rationale: bugs first because they are the cheapest win and remove flake risk before tests are added. Docs second because the cost is trivial and the refreshed picture informs decisions in later phases. Tests for stable code (repositories, services) third because their target won't move in Phase 4. Refactor fourth, with unit-level safety from Phase 3. Widget/golden/integration tests last, written against the post-refactor component shape so the work isn't redone.

---

## Phase 1 — Bug fixes (~½ day)

Fix all 14 `flutter analyze` issues. No behavior change.

### 1.1 — `use_build_context_synchronously` (8 instances)

| File | Lines |
|------|-------|
| `lib/features/home/screens/home_screen.dart` | 382, 394 |
| `lib/features/plant_detail/screens/plant_detail_screen.dart` | 1689, 1694, 1697 |
| `lib/features/sessions/screens/session_detail_screen.dart` | 81, 93, 140, 152 |

Standard fix pattern:

```dart
final navigator = Navigator.of(context);
final messenger = ScaffoldMessenger.of(context);
final l10n = AppLocalizations.of(context)!;
final result = await someAsyncCall();
if (!mounted) return;
navigator.push(...);
messenger.showSnackBar(...);
```

Verify the `mounted` check refers to the same widget whose `BuildContext` we'd otherwise have used (lint warns when the check is on an unrelated mounted boolean).

### 1.2 — Deprecated Radio API (2 instances)

`lib/shared/widgets/fenologia_fournier_widget.dart:92, 93` use the post-3.32-deprecated `Radio.groupValue` and `Radio.onChanged`. Migrate to `RadioGroup<T>` ancestor + child `Radio<T>` widgets.

### 1.3 — `unnecessary_underscores` (4 instances)

- `lib/features/sync/screens/conflict_resolution_screen.dart:55`
- `lib/shared/widgets/rain_mode_guard.dart:102` (×2)

Trivial: rename `__` to `_`.

### Done when

- `flutter analyze` reports `No issues found.`
- Manual smoke test: open each touched screen, trigger the formerly-faulty path (e.g., navigate to home → trigger the action at line 382), confirm no crash.

---

## Phase 2 — Doc refresh (~1 day)

Bring three documents to current reality.

### 2.1 — `README.md`

- Add 5 missing feature modules to the structure tree and Screens table: `auth`, `sync`, `identification` (dichotomous key), `quick_capture`, conflict resolution.
- Add 12 missing services to the Project Structure section: `weather_service`, `moon_phase_service`, `ocr_service`, `inaturalist_service`, `plantnet_service`, `herbarium_label_service`, `geocoding_service`, `coords_validation_service`, `gps_track_service`, `taxon_service`, `dichotomous_key_service`, `media_upload_service`.
- Add 7 missing models: `taxon_cache`, `gps_point`, `determination`, `collection_template`, `collection_method`, `phenological_state`, `municipality_bounding_box_cache`.
- Either write `RELEASE_NOTES_v1.8.0.md` (with content matching the v1.8.0 entry already in README) or remove the broken link.
- Update Dependencies table to include `dio`, `http`, `flutter_secure_storage`, `geocoding`, `google_mlkit_text_recognition`, `pdf`, `printing`, `url_launcher`.

### 2.2 — `ROADMAP.md`

- Move Phase 1 sections **1.1 Flutter HTTP Client Layer**, **1.2 Auth Integration on Flutter**, **1.3 Sync Service on Flutter**, and **1.4 Media Upload Coordination** items that exist in code from open checkboxes to "Done" (e.g., add a `## Done` section or tick the boxes). Verify each line item against `lib/`:
  - `dio` in `pubspec.yaml`: ✓ (line 103)
  - `lib/core/network/api_client.dart`: ✓
  - `lib/core/network/auth_interceptor.dart`: ✓
  - `lib/core/network/connectivity_interceptor.dart`: ✓
  - `flutter_secure_storage`: ✓ (line 105)
  - `lib/core/network/api_endpoints.dart`: ✓
  - `lib/core/services/auth_service.dart`: ✓
  - `AuthNotifier` provider: ✓ (`lib/core/providers/auth_provider.dart`)
  - Login + register screens: ✓ (`lib/features/auth/screens/`)
  - Persist auth state across restarts: ✓ (token storage + `_checkExistingSession`)
  - `lib/core/sync/sync_service.dart`: ✓
  - Conflict resolution UI: ✓ (`lib/features/sync/screens/conflict_resolution_screen.dart`)
  - `lib/core/services/media_upload_service.dart`: ✓
- Update **Current State Summary** maturity ratings: Sync (Flutter ↔ API) from ★1 to ★3.
- Update **Technical Debt** table: remove "No HTTP client in Flutter" row.
- The Priority Matrix's **P0 — Now** row is now empty (all current P0 items are done). Remove the row. Re-prioritization (which P1/P2 item should become the new P0) is a product decision, explicitly out of scope for this correction pass and listed under "Out of scope" below.

### 2.3 — `AGENTS.md`

- "Where to Look" table: confirm pointers, no changes expected.
- The model count and service count are not numbered in the doc, so no edits needed there. Verify the list of `lib/core/services/platforms/` references.

### Done when

A reader of the three updated docs can map every claim to something that exists in `lib/`, and every directory under `lib/features/` is accounted for in `README.md`'s Screens table.

---

## Phase 3 — C-stable: unit tests for stable code (~5 days)

Test only what won't move in Phase 4. Repositories and core services are stable; widget tests come later.

### 3.1 — Test harness setup

- Create `test/test_helpers/isar_test_helper.dart`: opens an Isar instance in `Directory.systemTemp`, returns a closeable handle. Used in `setUp`/`tearDown`.
- Add `mocktail` mock factories under `test/test_helpers/mocks/` for: `Geolocator`, `Dio`, `FlutterSecureStorage`, `ImagePicker`.
- Confirm `flutter test test/widget_test.dart` still passes after harness lands.

### 3.2 — Repository tests (`test/unit/repositories/`)

| Repository | Test cases |
|------------|------------|
| `plant_repository_test.dart` | CRUD; FTS search by scientific/common name; search by registry identifier; GPS bounding-box query (Haversine + indexed lat/lng); duplicate UUID upsert; soft-delete retrieval (drafts vs complete); empty DB |
| `session_repository_test.dart` | CRUD; share-code generation uniqueness; archive/unarchive round-trip; team member add/remove; date-range query |
| `saved_search_repository_test.dart` | CRUD; query persistence with full filter set |
| `template_repository_test.dart` | CRUD; default template handling |

### 3.3 — Critical service tests (`test/unit/services/`)

| Service | Test cases |
|---------|------------|
| `registry_identifier_service_test.dart` | ID format `{Initials}{6-digit}` for various initial lengths (1–4); collision resolution under simulated concurrent calls; manual override; auto-increment counter persistence |
| `photo_service_test.dart` | Compression to target quality (verify byte-size decrease); EXIF preservation toggle; file naming uniqueness; error path on missing file |
| `location_service_test.dart` | Permission states (granted, denied, deniedForever); high-accuracy GPS read; failure fallback |
| `sync_service_test.dart` | Push happy path (mock 200 response); pull happy path; conflict-detection branch (server `lastModifiedAt` > client); auth failure → triggers refresh; network failure → enqueues |
| `export_import_service_test.dart` | JSON round-trip (export → import → identical records); CSV header (Portuguese); Darwin Core core fields; UUID-based merge (existing record updated, new record created) |

### Done when

- `flutter test test/unit/` passes locally.
- `flutter test --coverage test/unit/` reports ≥70% line coverage on `lib/core/repositories/` and the 5 named service files.

---

## Phase 4 — B: refactor oversized screens (~10 days)

Target: no source file >500 lines (excluding generated `*.g.dart` and `lib/l10n/`). Behavior-preserving only.

### 4.1 — `plant_form_screen.dart` (3,531 → shell + 6 tabs + controller)

- Extract `PlantFormController` (Riverpod `Notifier`) holding: form state across tabs, auto-save timer, validation results, draft status, GPS capture, photo list, audio list, measurement list. Place under `lib/features/plant_form/controllers/plant_form_controller.dart`. Generated counterpart at `_.g.dart`.
- Create `lib/features/plant_form/widgets/`:
  - `basic_tab.dart` — scientific/common name, family, genus, species, category, identifier
  - `location_tab.dart` — GPS, map pin, manual coordinates
  - `habitat_tab.dart` — habitat description, phenology widget
  - `measurements_tab.dart` — dynamic measurement list
  - `photos_tab.dart` — gallery + camera
  - `audio_tab.dart` — recording + transcription
- `plant_form_screen.dart` becomes a `TabBar` + `TabBarView` shell consuming `PlantFormController`. Target ≤300 lines.

### 4.2 — `plant_detail_screen.dart` (2,175 → shell + 7 panels)

Create `lib/features/plant_detail/widgets/`:
- `hero_panel.dart` — image + scientific name overlay
- `taxonomy_panel.dart`
- `measurements_panel.dart`
- `photos_panel.dart`
- `audio_panel.dart`
- `map_panel.dart`
- `metadata_panel.dart`

`plant_detail_screen.dart` becomes a scroll-driven layout assembling the panels. Target ≤300 lines.

### 4.3 — `plant_edit_screen.dart` (1,651 → shell + sections)

Same pattern as 4.2: extract `lib/features/plant_edit/widgets/` (taxonomy, family-suggestion, category-picker). Target ≤300 lines.

### 4.4 — `home_screen.dart` (876 → shell + 5 tab contents)

Create `lib/features/home/widgets/tabs/`:
- `plants_tab.dart`
- `sessions_tab.dart`
- `map_tab.dart`
- `statistics_tab.dart`
- `settings_tab.dart` (just the `SettingsScreen` wrapper for tab use)

`home_screen.dart` becomes the `BottomNavigationBar` + `IndexedStack` shell. Target ≤200 lines.

### 4.5 — `quick_capture_screen.dart` (801 → shell + steps)

Extract one widget per capture step under `lib/features/quick_capture/widgets/`. Target ≤300 lines.

### 4.6 — `settings_screen.dart` (2,124 → 1 file per class)

Already class-decomposed. Move each `_*Tile`, `_*Section`, `_*Dialog`, and `_*DialogState` class to its own file under `lib/features/settings/widgets/`. The screen file becomes a small `Scaffold` + `ListView` consuming the widget files. Target ≤300 lines for the screen, ≤200 for any single widget file.

### 4.7 — `sync_service.dart` (966 → orchestrator + collaborators)

Extract under `lib/core/sync/`:
- `sync_pusher.dart` — `SyncPusher` class, push pipeline (batch, retry, error map)
- `sync_puller.dart` — `SyncPuller` class, pull pipeline (delta query, apply)
- `conflict_detector.dart` — `ConflictDetector` class, last-write-wins with override hooks
- `isar_to_api_mapper.dart` — `IsarToApiMapper`, the field-name mapping between Isar models and Mongoose schema (per AGENTS.md, names must match)

`sync_service.dart` keeps the public `sync({String? deviceId})` orchestrator, delegating to the four collaborators. Target ≤200 lines.

### Done when

- `find lib -name "*.dart" ! -name "*.g.dart" ! -path "lib/l10n/*" -exec wc -l {} + | awk '$1 > 500'` returns no rows.
- `flutter analyze` clean.
- All Phase 3 unit tests still pass.
- Manual smoke test on Android: create a session, create a plant draft (touch every tab), save, mark complete, search, view detail, edit, delete, sync push, hit a conflict, resolve it.

---

## Phase 5 — C-widgets: tests for refactored components (~3 days)

### 5.0 — Unit tests for Phase 4.7 sync collaborators (`test/unit/sync/`)

The Phase 3.3 `sync_service_test.dart` covered the orchestrator's public surface. After Phase 4.7 splits the orchestrator, write direct unit tests for the new collaborators:

- `sync_pusher_test.dart` — batch construction, retry on transient HTTP error, idempotency on duplicate UUIDs
- `sync_puller_test.dart` — delta-query handling, server-newer-than-client merge, missing-record handling
- `conflict_detector_test.dart` — last-write-wins matrix (client newer / server newer / equal); override hook fires
- `isar_to_api_mapper_test.dart` — every field on every syncable model maps both directions; field name parity with backend Mongoose schema (the contract per AGENTS.md)

### 5.1 — Widget tests (`test/widget/`)

For each widget extracted in Phase 4:

| Target | Coverage |
|--------|----------|
| `plant_form/widgets/*_tab.dart` | Renders with seeded `PlantFormController` state; field interactions update state; validation messages appear |
| `plant_detail/widgets/*_panel.dart` | Renders with seeded `PlantRecord`; conditional empty states; tap actions emit expected callbacks |
| `home/widgets/tabs/*.dart` | Renders with mocked providers; basic interactions |
| `settings/widgets/_*_tile.dart` | Each tile reads/writes the correct settings field |

### 5.2 — Golden tests (`test/golden/`)

Snapshot the four design-system widgets that change least:
- `ModernPlantCard` (full + compact variants)
- `GlassAppBar`
- `EmptyStateWidget` (3 contextual variants)
- `ShimmerLoading` (1 frame)

Use `flutter test --update-goldens` only on initial creation; subsequent runs verify against committed snapshots.

### 5.3 — Integration test (`test/integration/`)

One end-to-end: `plant_creation_flow_test.dart`:
1. Create a session.
2. From session detail, tap "Add plant".
3. Fill all 6 plant form tabs (text fields, mock GPS, mock camera image, mock audio).
4. Save as draft.
5. Mark complete.
6. Search by scientific name.
7. Open detail.
8. Verify all entered data renders.

### Done when

- `flutter test` (all suites) green.
- Golden snapshots committed under `test/golden/snapshots/`.
- The integration test passes on the Android emulator.

---

## Cross-cutting rules

1. **No new features.** Anything not in this spec is out of scope.
2. **No design changes.** Visual output of every screen is identical before/after.
3. **No backwards-compat shims.** This is internal refactor; old code is deleted, not deprecated.
4. **One phase, one branch, one merge.** Phase N+1 does not start until Phase N is merged.
5. **No `.g.dart` edits.** Run `dart run build_runner build --delete-conflicting-outputs` after any `@riverpod` or `@collection` change.
6. **Comments policy** (per project AGENTS.md): only when WHY is non-obvious.
7. **Defer don't fix.** Bugs found during refactor are logged in the implementation plan's deferred-followup list and fixed in a separate later pass.
8. **AGENTS.md anti-patterns enforced**: no `setState` for non-trivial state, no hardcoded UI strings, no missing `@riverpod` annotations on providers.

---

## Definition of Done (overall)

- `flutter analyze` reports `No issues found.` against `lib/`.
- `flutter test` reports all suites green.
- `flutter test --coverage` shows ≥70% on `lib/core/repositories/` and the 5 named services from Phase 3.3.
- No source file under `lib/` (excluding `*.g.dart` and `lib/l10n/*`) reports >500 with `wc -l` (total lines, including comments and blanks).
- `README.md`, `ROADMAP.md`, `AGENTS.md` accurately reflect `lib/`.
- Manual smoke test on Android passes for the flows in Phase 4 "Done when".

---

## Risks & mitigations

| Risk | Mitigation |
|------|------------|
| Refactor introduces a subtle behavior change | Phase 3 unit tests on stable code; manual smoke test gate at end of Phase 4 |
| Plant form state extraction breaks auto-save timing | Test `PlantFormController` directly under `test/unit/controllers/` (add as 4.1 sub-step) |
| Sync mapper extraction breaks the field-name contract with backend | `IsarToApiMapper` gets dedicated unit tests covering every field; document the contract in a comment header |
| `flutter test --coverage` doesn't cover Isar generated code well | Coverage target excludes `*.g.dart` (which is generated) — use `--exclude-pattern` if needed |
| 500-line target too aggressive for some screens | If a single panel file legitimately needs >500 lines after honest decomposition, document the reason inline and accept it; rule is a guideline, not gospel |
| Doc edits race with active feature work in another branch | Phase 2 edits should land on a fresh branch; rebase if needed |

---

## Out of scope (logged for later)

These items appeared during the audit but are explicitly **not** part of this spec:

- ROADMAP Phase 2 (backend hardening), Phase 3 (CI/CD), Phase 4 (collaboration), Phase 5 (observability).
- New languages (French, German, Italian).
- iOS build readiness.
- Re-prioritizing the `ROADMAP.md` Priority Matrix after Phase 2 of this plan completes (a follow-up task).
- A v1.9.0 release announcement (likely warranted given the unsurfaced features, but a separate effort).
- Deleting `Google Drive backup` if `R2 sync` makes it redundant (per ROADMAP technical debt — needs product decision, not refactor).
