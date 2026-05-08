# PROJECT KNOWLEDGE BASE

**Generated:** 2026-04-29
**Last refreshed:** 2026-05-08
**App:** Folium — Offline-first botanical field collection app

## OVERVIEW

Flutter cross-platform app (`lib/`). Offline-first (Isar is source of truth); network is supplementary. The REST API backend lives in a sibling repository (`../backend/`). See `.github/agents/` for per-role developer docs.

## STRUCTURE

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

## WHERE TO LOOK

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

## ARCHITECTURE: FLUTTER

- **State**: Riverpod codegen (`@riverpod`). All providers use annotations — no manual providers.
- **DB**: Isar (offline-first). `IsarService` singleton initialized at app start.
- **Layer order**: Screen → Provider (Notifier) → Repository → IsarService / Service
- **Features contain only screens** — state and business logic live in `lib/core/`.
- **Async state**: Always handle with `AsyncValue.when(loading:, error:, data:)`.
- **Platform splits**: Conditional imports for web vs mobile in `lib/core/database/platforms/` and `lib/core/services/platforms/`.

## SYNC CONTRACT (Flutter ↔ external API)

- Every syncable entity has `uuid` (client v4 UUID) + `syncVersion` (number).
- Isar model field names must match the external API's schema field names exactly. The API is maintained in a sibling repository (`../backend/`) — schema drift will silently break sync.
- `SyncMetadata` embedded on syncable models: `serverId`, `lastSyncedAt`, `syncStatus` (pending/synced/conflict/error).
- Enums are stored as lowercase strings on both sides.
- Conflict resolution: last-write-wins on `lastModifiedAt`, with manual override surfaced in `lib/features/sync/screens/conflict_resolution_screen.dart`.

## CONVENTIONS

- **Dart**: `flutter_lints` active. `debugPrint()` not `print()`. Null-safety enforced.
- **Imports (Dart)**: SDK → Flutter → packages → local.
- **Naming**: snake_case files. See `lib/AGENTS.md` and `lib/core/AGENTS.md` for module-scoped conventions.

## ANTI-PATTERNS

- `setState` for non-trivial state → use Riverpod.
- `@riverpod` annotation omitted → breaks codegen, always annotate.
- Hardcoded UI strings → use `AppLocalizations.of(context)!.key`.
- Renaming fields on syncable models → breaks the cross-repo contract, keep names identical to the API.
- Adding a `// ignore:` directive instead of fixing root cause.
- Modifying generated `*.g.dart` files by hand.

## COMMANDS

```bash
# Flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # After model/provider changes
flutter analyze
flutter test
flutter run
```

## CODEGEN NOTE

After any change to Isar models (`.dart` in `lib/models/`) or Riverpod providers annotated with `@riverpod`, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```
Generated files (`*.g.dart`) are committed — do not delete them.

## NOTES

- `.github/agents/flutter-app.agent.md` contains role-specific rules — read it before starting work. (`nestjs-backend.agent.md` is legacy and pending refresh; the backend lives in a sibling repository now.)
- `lib/core/services/platforms/` uses conditional imports to split web/mobile implementations.
- `test/golden/`, `test/unit/`, `test/widget/`, `test/integration/` are present but empty as of 2026-05-08 — Phase 3 of the correction pass populates them.
- `analysis_options.yaml` uses `package:flutter_lints/flutter.yaml` with no additional overrides.
- `flutter analyze` returns `No issues found!` (Phase 1 of the 2026-05-08 correction pass cleaned 14 baseline issues).
