# PROJECT KNOWLEDGE BASE

**Generated:** 2026-04-29
**App:** Folium — Offline-first botanical field collection app

## OVERVIEW

Monorepo: Flutter cross-platform app (`lib/`) + NestJS REST API (`backend/`). Offline-first (Isar is source of truth); network is supplementary. See `.github/agents/` for per-role developer docs.

## STRUCTURE

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
| Add backend endpoint | `backend/src/modules/<feature>/` |
| Backend sync logic | `backend/src/modules/sync/` |
| Docker/deploy | `backend/docker/` |

## ARCHITECTURE: FLUTTER

- **State**: Riverpod codegen (`@riverpod`). All providers use annotations — no manual providers.
- **DB**: Isar (offline-first). `IsarService` singleton initialized at app start.
- **Layer order**: Screen → Provider (Notifier) → Repository → IsarService / Service
- **Features contain only screens** — state and business logic live in `lib/core/`.
- **Async state**: Always handle with `AsyncValue.when(loading:, error:, data:)`.
- **Platform splits**: Conditional imports for web vs mobile in `lib/core/database/platforms/` and `lib/core/services/platforms/`.

## ARCHITECTURE: BACKEND

- **Framework**: NestJS 10+, MongoDB 8, Mongoose, strict TypeScript.
- **API prefix**: `/api/v1`
- **Auth**: JWT access + refresh tokens. All routes need `@UseGuards(JwtAuthGuard)`.
- **Module pattern**: module → controller → service → schema + DTOs + enums.
- **Sync**: UUID-based upsert. `POST /sync` accepts batches; conflict = last-write-wins on `lastModifiedAt`.
- **Soft delete**: `isActive: false` — never hard-delete user data.

## FLUTTER–BACKEND SYNC CONTRACT

- Every syncable entity has `uuid` (client v4 UUID) + `syncVersion` (number).
- Isar model field names **must** match Mongoose schema field names exactly.
- `SyncMetadata` embedded: `serverId`, `lastSyncedAt`, `syncStatus` (pending/synced/conflict/error).
- Backend enums mirror Flutter enums as lowercase strings.

## CONVENTIONS

- **Dart**: `flutter_lints` active. `debugPrint()` not `print()`. Null-safety enforced.
- **TypeScript**: Strict mode. No `any`. NestJS exceptions only — no raw `Error` throws.
- **Imports (Dart)**: SDK → Flutter → packages → local.
- **Imports (TS)**: NestJS core → third-party → local.
- **Barrel exports**: `index.ts` in TS module dirs. Not standard in Dart — use direct imports.
- **Naming**: snake_case files (Dart), kebab-case files (TS). See agent docs for full tables.

## ANTI-PATTERNS

- `setState` for non-trivial state → use Riverpod.
- `@riverpod` annotation omitted → breaks codegen, always annotate.
- Hardcoded UI strings → use `AppLocalizations.of(context)!.key`.
- Hard-deleting records in backend → use `isActive: false`.
- Renaming fields when porting Flutter→Mongoose → breaks sync, keep names identical.
- `any` type in TypeScript.
- Raw `Error` throws in NestJS — use `NotFoundException`, `ConflictException`, etc.
- Modifying `lib/` from a backend task or `backend/` from a Flutter task.

## COMMANDS

```bash
# Flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs  # After model/provider changes
flutter analyze
flutter test
flutter run

# Backend
cd backend && npm install
npm run start:dev
npm run build
npm test
```

## CODEGEN NOTE

After any change to Isar models (`.dart` in `lib/models/`) or Riverpod providers annotated with `@riverpod`, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```
Generated files (`*.g.dart`) are committed — do not delete them.

## NOTES

- `.github/agents/flutter-app.agent.md` and `nestjs-backend.agent.md` contain full role-specific rules — read them before starting work.
- `lib/core/services/platforms/` uses conditional imports to split web/mobile implementations.
- `test/golden/` contains screenshot regression tests — run flutter test to verify.
- `analysis_options.yaml` uses `package:flutter_lints/flutter.yaml` with no additional overrides.
