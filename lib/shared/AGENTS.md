<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-05-13 -->

# shared — Reusable Widgets, Constants, and Utilities

## Purpose

Cross-feature UI components, app-wide constants, and utility functions. Everything here is imported by multiple features — changes have broad impact.

## Key Files

| File | Description |
|------|-------------|
| `widgets/fenologia_fournier_widget.dart` | Phenology Fournier scale visual selector |
| `widgets/map_widget.dart` | Reusable map component |
| `widgets/ocr_review_dialog.dart` | OCR text review/correction dialog |
| `widgets/plantnet_results_sheet.dart` | PlantNet identification results bottom sheet |
| `widgets/rain_mode_guard.dart` | Guard widget for rain mode (large touch targets) |
| `constants/biome_templates.dart` | Biome-specific collection templates |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `widgets/modern/` | Glassmorphic design system components |
| `widgets/audio/` | Audio recording and playback widgets |
| `constants/` | App-wide constant definitions |
| `utils/` | Shared utility functions |

## Key Widgets (modern/)

| Widget | Description |
|--------|-------------|
| `glass_app_bar.dart` | Glassmorphic app bar with blur effect |
| `modern_app_bar.dart` | Standard modern app bar variant |
| `modern_plant_card.dart` | Plant record card for lists |
| `empty_state_widget.dart` | Empty state placeholder with illustration |
| `shimmer_loading.dart` | Shimmer loading skeleton |
| `sync_status_icon.dart` | Animated sync status indicator |

## Key Widgets (audio/)

| Widget | Description |
|--------|-------------|
| `audio_recorder_widget.dart` | Audio recording with waveform visualization |
| `audio_player_widget.dart` | Audio playback with progress |

## For AI Agents

### Working In This Directory

- Widgets here are used across multiple features — test broadly after changes.
- Follow `FoliumTheme` for all colors, typography, and spacing.
- All text must use `AppLocalizations` — no hardcoded strings.
- `modern/` widgets implement the glassmorphic design language — maintain visual consistency.

### Testing Requirements

- Widget tests in `test/widget/`.
- Visual regression: golden tests in `test/golden/` (currently empty — add when needed).

## Dependencies

### Internal

- `core/theme/` — `FoliumTheme` design tokens
- `core/providers/` — state access for stateful widgets
- `l10n/` — localized strings

### External

- `flutter/material.dart` — base widgets
- `flutter_riverpod` — state access in consumer widgets

<!-- MANUAL: -->
