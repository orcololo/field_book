<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-05-10 | Updated: 2026-05-13 -->

# LIB — Flutter App Source

## OVERVIEW

All Flutter application code. Architecture: features (screens only) + core (state, data, logic) + models (Isar) + shared (widgets/utils).

## STRUCTURE

```
lib/
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
├── core/                 # See core/AGENTS.md
├── models/               # Isar @collection models
├── shared/widgets/       # Reusable UI components
│   ├── modern/           # Glassmorphic design system widgets
│   └── audio/            # Audio recording/playback widgets
└── l10n/                 # app_en.arb, app_pt.arb, app_es.arb
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| New feature screen | `features/<name>/screens/<name>_screen.dart` |
| Isar model | `models/<name>.dart` — run codegen after changes |
| Generated model code | `models/<name>.g.dart` — do not edit |
| Glass/modern UI components | `shared/widgets/modern/` |
| Audio widgets | `shared/widgets/audio/` |
| Design tokens, colors | `core/theme/` → `FoliumTheme` |
| i18n keys | `l10n/app_en.arb` (add to all 3 ARB files) |
| App constants | `shared/constants/` |
| Shared utilities | `shared/utils/` |

## MODEL CONVENTIONS (Isar)

- `@collection` on top-level documents; `@embedded` on subdocuments.
- `@Index()` required on queryable fields. FTS: `@Index(type: IndexType.value)`.
- `SyncMetadata` embedded on all syncable entities.
- Enums stored as string values — mirror backend enum strings exactly.
- After adding/changing a model: `dart run build_runner build --delete-conflicting-outputs`.

## SCREEN CONVENTIONS

- All screens: `ConsumerWidget` or `ConsumerStatefulWidget`.
- No business logic in screens — delegate to providers via `ref.watch`/`ref.read`.
- All strings via `AppLocalizations.of(context)!.key` — no hardcoded text.
- Use `FoliumTheme` for colors/typography. Use `GlassAppBar`, `ModernPlantCard`, `ShimmerLoading`, `EmptyStateWidget` from `shared/widgets/`.

## ANTI-PATTERNS

- Business logic in screen files.
- `setState` for non-trivial state.
- Hardcoded strings (must be in l10n ARB files).
- Skipping `@riverpod` annotation on providers.
- Ignoring platform differences (use conditional imports for web vs mobile).
