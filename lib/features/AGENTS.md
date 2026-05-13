<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-05-13 -->

# features — UI Feature Modules

## Purpose

Each subdirectory is a feature containing only screen widgets. No business logic lives here — all state management, data access, and domain logic is in `core/`. Features are organized by user-facing functionality.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `auth/screens/` | Login, registration screens |
| `export_import/screens/` | CSV/JSON export and import UI |
| `home/screens/` | Main plant list, navigation hub |
| `identification/screens/` | Dichotomous key identification flow |
| `map/screens/` | Map view with GPS tracks and plant markers |
| `onboarding/screens/` | First-launch tutorial/setup |
| `photo_gallery/screens/` | Photo browsing and management |
| `plant_detail/screens/` | Read-only plant record view |
| `plant_edit/screens/` | Edit existing plant record |
| `plant_form/screens/` | Create new plant record |
| `quick_capture/screens/` | Fast entry with GPS + camera |
| `search/screens/` | Full-text and filtered search |
| `sessions/screens/` | Collection session management |
| `settings/screens/` | App settings and preferences |
| `statistics/screens/` | Collection statistics and charts |
| `sync/screens/` | Sync status, conflict resolution UI |

## For AI Agents

### Working In This Directory

- Every screen is a `ConsumerWidget` or `ConsumerStatefulWidget` (Riverpod).
- Screens delegate all logic to providers via `ref.watch` / `ref.read`.
- No `setState` for non-trivial state — use Riverpod providers in `core/providers/`.
- All user-visible strings must use `AppLocalizations.of(context)!.key` — add keys to all 3 ARB files in `l10n/`.
- Use `FoliumTheme` for colors/typography. Use widgets from `shared/widgets/modern/`.

### Adding a New Feature

1. Create `lib/features/<name>/screens/<name>_screen.dart`.
2. Add route in the app's router/navigation.
3. If new state is needed, add provider in `core/providers/` or service in `core/services/`.
4. Add i18n keys to `l10n/app_en.arb`, `app_pt.arb`, `app_es.arb`.

### Testing Requirements

- Widget tests go in `test/widget/screens/`.
- Integration tests in `test/integration/`.

## Dependencies

### Internal

- `core/providers/` — all state access
- `core/theme/` — `FoliumTheme`
- `shared/widgets/` — reusable UI components
- `l10n/` — localized strings
- `models/` — type definitions (read-only from screens)

<!-- MANUAL: -->
