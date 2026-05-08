# Folium — Phase 1: Analyzer Bug Fixes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Drive `flutter analyze` from 14 info-level issues to `No issues found.` with zero behavior change.

**Architecture:** Each task fixes one logical group of issues in one file. Three categories: (1) `use_build_context_synchronously` — fixed via the standard Flutter pattern of capturing `BuildContext`-derived values before the first `await`, splitting compound `if (X || !mounted) return;` into separate guards so the lint sees mounted as the immediate pre-use check; (2) deprecated `Radio` API — migrate from per-widget `groupValue`/`onChanged` to a `RadioGroup<T>` ancestor (Flutter 3.32+ pattern); (3) `unnecessary_underscores` — replace `__`/`___` parameter names with `_` (Dart 3.x wildcard).

**Tech Stack:** Flutter `^3.10.8`, Dart `^3.10.8`, no new dependencies. All edits are in `lib/`. No regenerated `*.g.dart`. No new tests in this phase (Phase 3 covers tests).

**Reference spec:** `docs/superpowers/specs/2026-05-08-folium-correction-and-polish-design.md` § Phase 1.

**Working directory:** All commands assume cwd = `/Users/orcola/Projetos/Herbario/fieldBook/field_book` (the Flutter project root).

**Branch convention (per spec cross-cutting rule 4):** create a branch `phase-1/analyzer-fixes` before starting Task 1. Each task ends with a commit on that branch. Final task verifies and prepares the merge.

---

## File Map

Files modified in this phase:

| File | Issue type | Issues | Lines touched |
|------|------------|--------|---------------|
| `lib/features/home/screens/home_screen.dart` | BuildContext-after-async | 2 | ~5 lines around 379–395 |
| `lib/features/plant_detail/screens/plant_detail_screen.dart` | BuildContext-after-async | 3 | ~10 lines around the `_sendToInaturalist` method |
| `lib/features/sessions/screens/session_detail_screen.dart` | BuildContext-after-async | 4 | ~15 lines across two methods (`_deleteSession`, `_toggleArchive`) |
| `lib/shared/widgets/fenologia_fournier_widget.dart` | Deprecated `Radio` API | 2 | ~25 lines around the rating-row helper |
| `lib/features/sync/screens/conflict_resolution_screen.dart` | `unnecessary_underscores` | 1 | line 55 |
| `lib/shared/widgets/rain_mode_guard.dart` | `unnecessary_underscores` | 2 | line 102 |

No files created. No files deleted.

---

## Task 0: Branch and baseline

**Files:** none modified.

- [ ] **Step 0.1: Create the working branch**

```bash
git checkout -b phase-1/analyzer-fixes
git status
```

Expected: `On branch phase-1/analyzer-fixes` and clean staged area (untracked WIP from earlier sessions is fine; we won't touch it).

- [ ] **Step 0.2: Capture analyzer baseline**

```bash
flutter analyze 2>&1 | tail -20
```

Expected output (last line):

```
14 issues found. (ran in 3.9s)
```

If the count is not exactly 14, **stop**: the codebase has drifted from the audit. Re-read the spec § Phase 1 and reconcile new issues into this plan before continuing. (Standard fix patterns in this plan apply to anything new.)

- [ ] **Step 0.3: Verify the issues match the spec**

```bash
flutter analyze 2>&1 | grep -E "use_build_context_synchronously|deprecated_member_use|unnecessary_underscores"
```

Expected: 14 lines, matching the table in the File Map above.

---

## Task 1: Fix `home_screen.dart` (2 BuildContext-after-async issues)

**Files:**
- Modify: `lib/features/home/screens/home_screen.dart` lines ~378–395 (the multi-step delete confirmation flow)

**Issue:** After `await showDialog(...)`, the code calls `await RainModeGuard.confirmDestructiveAction(context: context, ..., confirmColor: Theme.of(context).colorScheme.error)`. Lint flags the `context` use at line 382 and `Theme.of(context)` use at line 394 as crossing an async gap "guarded by an unrelated 'mounted' check" — the existing `if (initialConfirmed != true || !mounted) return;` is a compound condition that the lint does not recognize as a mounted-only guard.

- [ ] **Step 1.1: Verify the broken state**

```bash
flutter analyze 2>&1 | grep "home_screen.dart"
```

Expected (2 lines):

```
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check • lib/features/home/screens/home_screen.dart:382:7 • use_build_context_synchronously
   info • Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check • lib/features/home/screens/home_screen.dart:394:30 • use_build_context_synchronously
```

- [ ] **Step 1.2: Apply the fix**

Locate the block currently at lines ~370–402. Identify the destructive-confirmation flow:

```dart
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (initialConfirmed != true || !mounted) return;

    final confirmed = await RainModeGuard.confirmDestructiveAction(
      context: context,
      rainModeEnabled: ref.read(rainModeEnabledProvider),
      actionLabel: l10n.deleteSelected,
      overlayTitle: l10n.rainModeOverlayTitle,
      overlayMessage: l10n.rainModeOverlayMessage,
      unlockHint: l10n.rainModeUnlockHold,
      unlockAlternativeHint: l10n.rainModeUnlockTap,
      confirmTitle: l10n.rainModeDeleteConfirmTitle,
      confirmMessage: l10n.confirmDeleteCount(_selectedIds.length),
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.delete,
      countdownLabel: l10n.rainModeCountdownLabel,
      confirmColor: Theme.of(context).colorScheme.error,
    );
```

Find where this method's `_selectedIds`-aware delete flow begins (search for `Future<void> _deleteSelected` or the closest `Future<void>` above line 379). At the **top** of that method body, add a single line that captures the error color **before any await**. Then split the compound mounted check, and use the captured color in the post-await call.

Search for the method header — example shape:

```dart
  Future<void> _deleteSelected() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
```

If a similar capture block exists, append the new line there. If not, add the captures yourself. Apply this exact change to the method body:

```dart
  Future<void> _deleteSelected() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    // ... existing showDialog<bool> block, unchanged, returning into initialConfirmed ...

    if (!mounted) return;
    if (initialConfirmed != true) return;

    final confirmed = await RainModeGuard.confirmDestructiveAction(
      context: context,
      rainModeEnabled: ref.read(rainModeEnabledProvider),
      actionLabel: l10n.deleteSelected,
      overlayTitle: l10n.rainModeOverlayTitle,
      overlayMessage: l10n.rainModeOverlayMessage,
      unlockHint: l10n.rainModeUnlockHold,
      unlockAlternativeHint: l10n.rainModeUnlockTap,
      confirmTitle: l10n.rainModeDeleteConfirmTitle,
      confirmMessage: l10n.confirmDeleteCount(_selectedIds.length),
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.delete,
      countdownLabel: l10n.rainModeCountdownLabel,
      confirmColor: errorColor,
    );
    if (!mounted) return;
    if (confirmed != true) return;

    final plantRepo = ref.read(plantRepositoryProvider);
    await plantRepo.bulkDelete(_selectedIds.toList());
    if (!mounted) return;
    final count = _selectedIds.length;
    messenger.showSnackBar(SnackBar(content: Text(l10n.nPlantsDeleted(count))));
    _exitSelectMode();
  }
```

Three concrete edits in one method:

1. Add `final errorColor = Theme.of(context).colorScheme.error;` to the early capture block.
2. Split the line `if (initialConfirmed != true || !mounted) return;` into two lines: `if (!mounted) return;` followed by `if (initialConfirmed != true) return;`.
3. Replace `confirmColor: Theme.of(context).colorScheme.error,` with `confirmColor: errorColor,`.
4. Split `if (confirmed != true || !mounted) return;` into two lines for symmetry: `if (!mounted) return;` followed by `if (confirmed != true) return;`.

Edit nothing else in the file.

- [ ] **Step 1.3: Verify the warnings are gone**

```bash
flutter analyze 2>&1 | grep "home_screen.dart" || echo "(home_screen.dart clean)"
```

Expected: `(home_screen.dart clean)`.

- [ ] **Step 1.4: Verify no new warnings**

```bash
flutter analyze 2>&1 | tail -1
```

Expected: `12 issues found.` (was 14, fixed 2).

- [ ] **Step 1.5: Commit**

```bash
git add lib/features/home/screens/home_screen.dart
git commit -m "$(cat <<'EOF'
fix: guard BuildContext use after async in home_screen delete flow

Capture errorColor before await; split compound mounted-checks so the
analyzer sees mounted as the immediate pre-use guard.
EOF
)"
```

---

## Task 2: Fix `plant_detail_screen.dart` (3 BuildContext-after-async issues)

**Files:**
- Modify: `lib/features/plant_detail/screens/plant_detail_screen.dart` — the `_sendToInaturalist` method (around lines 1670–1705).

**Issue:** Inside `_sendToInaturalist`, the success and catch branches both call `ScaffoldMessenger.of(context)` and one references `Theme.of(context).colorScheme.error`, all after multiple awaits. The existing `if (!mounted) return;` guards exist, but `Theme.of(context)` evaluates inside the SnackBar argument list and the lint is conservative.

- [ ] **Step 2.1: Verify the broken state**

```bash
flutter analyze 2>&1 | grep "plant_detail_screen.dart"
```

Expected (3 lines, all `use_build_context_synchronously` at lines 1689, 1694, 1697).

- [ ] **Step 2.2: Locate the method**

```bash
grep -n "_sendToInaturalist" lib/features/plant_detail/screens/plant_detail_screen.dart
```

Note the method header line number — it should be around 1640–1660. Open the file at that line.

- [ ] **Step 2.3: Apply the fix**

At the top of the `_sendToInaturalist` method, before the first `await`, capture all `BuildContext`-derived values. Then replace post-await `ScaffoldMessenger.of(context)` calls and `Theme.of(context).colorScheme.error` with the captured locals.

Target shape after edit:

```dart
  Future<void> _sendToInaturalist(BuildContext context, ...) async {
    // Existing pre-await setup (l10n, service lookup, token check) preserved.
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;
    final l10n = AppLocalizations.of(context)!;

    // ... existing token-check branch, unchanged ...

    setState(() => _isSendingToInaturalist = true);

    try {
      await service.createObservation(plant);
      final updated = await ref.read(plantRepositoryProvider).getByUuid(plant.uuid);
      if (!mounted) return;
      if (updated != null) {
        setState(() => _currentPlant = updated);
      }

      messenger.showSnackBar(
        SnackBar(content: Text(l10n.inaturalistPushSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.inaturalistPushError(e.toString())),
          backgroundColor: errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSendingToInaturalist = false);
      }
    }
  }
```

Concrete edits:

1. Add `final messenger = ScaffoldMessenger.of(context);`, `final errorColor = Theme.of(context).colorScheme.error;`, `final l10n = AppLocalizations.of(context)!;` immediately after the method's opening brace (or merge with any existing capture). If `l10n` is already captured, do not duplicate.
2. Replace `ScaffoldMessenger.of(context).showSnackBar(` (twice — line 1689 success branch, line 1694 catch branch) with `messenger.showSnackBar(`.
3. Replace `backgroundColor: Theme.of(context).colorScheme.error,` (line 1697) with `backgroundColor: errorColor,`.
4. Restructure the `if (updated != null && mounted)` to a `if (!mounted) return; if (updated != null) { ... }` shape so the success-branch SnackBar's mounted check is unambiguous.
5. Leave the token-check branch (around line 1670) untouched — analyzer did not flag it (its `await` is `Navigator.of(context).push(...)` which is the *first* await; no async gap before).

Edit nothing else in the file.

- [ ] **Step 2.4: Verify the warnings are gone**

```bash
flutter analyze 2>&1 | grep "plant_detail_screen.dart" || echo "(plant_detail_screen.dart clean)"
```

Expected: `(plant_detail_screen.dart clean)`.

- [ ] **Step 2.5: Verify no new warnings**

```bash
flutter analyze 2>&1 | tail -1
```

Expected: `9 issues found.` (was 12, fixed 3).

- [ ] **Step 2.6: Commit**

```bash
git add lib/features/plant_detail/screens/plant_detail_screen.dart
git commit -m "$(cat <<'EOF'
fix: guard BuildContext use in plant_detail iNaturalist push

Pre-capture messenger, errorColor, and l10n at the top of
_sendToInaturalist; restructure mounted check in the success branch.
EOF
)"
```

---

## Task 3: Fix `session_detail_screen.dart` (4 BuildContext-after-async issues)

**Files:**
- Modify: `lib/features/sessions/screens/session_detail_screen.dart` — methods `_deleteSession` (lines 70–112) and `_toggleArchive` (lines 114–165).

**Issue:** Both destructive-action methods follow the same pattern as Task 1 (showDialog + RainModeGuard). Lines 81 & 93 are in `_deleteSession`'s second flow; lines 140 & 152 are in `_toggleArchive`'s second flow. The lint flags these as `Don't use BuildContext's across async gaps` (no mention of an "unrelated mounted check" — these methods don't have a mounted check at all in the relevant spot, just the bare `await`).

- [ ] **Step 3.1: Verify the broken state**

```bash
flutter analyze 2>&1 | grep "session_detail_screen.dart"
```

Expected (4 lines: 81, 93, 140, 152, all `use_build_context_synchronously`).

- [ ] **Step 3.2: Apply the fix to `_deleteSession`**

Find the method `_deleteSession` (around line 50–112). At its top, before the first `await showDialog<bool>`, add a capture:

```dart
  Future<void> _deleteSession() async {
    final l10n = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;

    // ... existing showDialog<bool> for initialConfirmed, unchanged ...

    if (!mounted) return;
    if (initialConfirmed != true) return;

    final confirmed = await RainModeGuard.confirmDestructiveAction(
      context: context,
      rainModeEnabled: ref.read(rainModeEnabledProvider),
      actionLabel: l10n.deleteSessionTitle,
      overlayTitle: l10n.rainModeOverlayTitle,
      overlayMessage: l10n.rainModeOverlayMessage,
      unlockHint: l10n.rainModeUnlockHold,
      unlockAlternativeHint: l10n.rainModeUnlockTap,
      confirmTitle: l10n.rainModeDeleteConfirmTitle,
      confirmMessage: l10n.confirmDeleteSession,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.deleteSessionConfirm,
      countdownLabel: l10n.rainModeCountdownLabel,
      confirmColor: errorColor,
    );

    if (!mounted) return;
    if (confirmed != true) return;

    try {
      final sessionRepo = ref.read(sessionRepositoryProvider);
      await sessionRepo.delete(_session.id);
      if (!mounted) return;
      navigator.pop(true);
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: errorColor),
      );
    }
  }
```

Concrete edits in `_deleteSession`:

1. Add captures `navigator`, `messenger`, `errorColor` (and `tertiaryColor`, used by `_toggleArchive` — see Step 3.3; if both methods share the captures, factor the shared ones into instance fields *only* if there are already similar fields, otherwise duplicate per-method).
2. Replace `confirmColor: Theme.of(context).colorScheme.error,` (line 93) with `confirmColor: errorColor,`.
3. Replace bare `if (initialConfirmed != true) return;` with `if (!mounted) return;` then `if (initialConfirmed != true) return;`.
4. Replace bare `if (confirmed != true) return;` with `if (!mounted) return;` then `if (confirmed != true) return;`.
5. Replace `Navigator.of(context).pop(true);` (line 103) with `navigator.pop(true);`.
6. Replace `ScaffoldMessenger.of(context).showSnackBar(...)` (line 107) with `messenger.showSnackBar(...)` and inline `Colors.red` with `errorColor` for theme consistency (the existing `Colors.red` is hard-coded; `errorColor` matches the design system).

- [ ] **Step 3.3: Apply the fix to `_toggleArchive`**

Same pattern in `_toggleArchive` (lines 114–165). Captures at top of method (or shared with `_deleteSession` if you decided to factor them):

```dart
  Future<void> _toggleArchive() async {
    final l10n = AppLocalizations.of(context)!;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;
    final sessionRepo = ref.read(sessionRepositoryProvider);

    if (!_session.isArchived) {
      final initialConfirmed = await showDialog<bool>(
        // ... existing dialog ...
      );
      if (!mounted) return;
      if (initialConfirmed != true) return;

      final confirmed = await RainModeGuard.confirmDestructiveAction(
        context: context,
        // ... existing args ...
        confirmColor: tertiaryColor,
      );
      if (!mounted) return;
      if (confirmed != true) return;
    }

    if (_session.isArchived) {
      await sessionRepo.unarchive(_session.id);
    } else {
      await sessionRepo.archive(_session.id);
    }

    await _refreshSession();
  }
```

Concrete edits in `_toggleArchive`:

1. Add `final tertiaryColor = Theme.of(context).colorScheme.tertiary;` capture at top.
2. Replace `confirmColor: Theme.of(context).colorScheme.tertiary,` (line 152) with `confirmColor: tertiaryColor,`.
3. Replace bare `if (initialConfirmed != true) return;` with `if (!mounted) return;` then `if (initialConfirmed != true) return;`.
4. Replace bare `if (confirmed != true) return;` with `if (!mounted) return;` then `if (confirmed != true) return;`.

- [ ] **Step 3.4: Verify the warnings are gone**

```bash
flutter analyze 2>&1 | grep "session_detail_screen.dart" || echo "(session_detail_screen.dart clean)"
```

Expected: `(session_detail_screen.dart clean)`.

- [ ] **Step 3.5: Verify no new warnings**

```bash
flutter analyze 2>&1 | tail -1
```

Expected: `5 issues found.` (was 9, fixed 4).

- [ ] **Step 3.6: Commit**

```bash
git add lib/features/sessions/screens/session_detail_screen.dart
git commit -m "$(cat <<'EOF'
fix: guard BuildContext use in session_detail destructive flows

Pre-capture navigator, messenger, errorColor, tertiaryColor in
_deleteSession and _toggleArchive; add explicit mounted checks
between awaits.
EOF
)"
```

---

## Task 4: Migrate `fenologia_fournier_widget.dart` to `RadioGroup` (2 deprecated-API issues)

**Files:**
- Modify: `lib/shared/widgets/fenologia_fournier_widget.dart` — the rating-row helper around lines 75–110.

**Issue:** `Radio.groupValue` and `Radio.onChanged` were deprecated in Flutter 3.32. The replacement is a `RadioGroup<T>` ancestor that holds `groupValue` and `onChanged`; child `Radio<T>` widgets carry only their `value`.

- [ ] **Step 4.1: Verify the broken state**

```bash
flutter analyze 2>&1 | grep "fenologia_fournier_widget.dart"
```

Expected (2 lines, both `deprecated_member_use` at line 92 (`groupValue`) and line 93 (`onChanged`)).

- [ ] **Step 4.2: Apply the fix**

Find the method that returns the `SingleChildScrollView` around line 77 (it's a private helper that builds a single rating row with 5 radios). Wrap the existing `SingleChildScrollView` in a `RadioGroup<int>` and remove the per-`Radio` `groupValue`/`onChanged`:

```dart
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: FoliumTheme.space8),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
        RadioGroup<int>(
          groupValue: value,
          onChanged: (v) {
            if (v != null) {
              onChanged(v);
              _notifyChange();
            }
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      Text(index.toString(), style: const TextStyle(fontSize: 12)),
                      SizedBox(
                        width: 48,
                        height: 48, // 48dp min tap target
                        child: Radio<int>(value: index),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: FoliumTheme.space12),
```

Concrete edits:

1. Wrap the existing `SingleChildScrollView(...)` in `RadioGroup<int>(groupValue: value, onChanged: ..., child: ...)`. The `groupValue` and `onChanged` move from the inner `Radio<int>` to the new `RadioGroup<int>`.
2. Inside the `Radio<int>(...)` constructor, remove the `groupValue: value,` and `onChanged: (v) {...},` named arguments. Only `value: index,` remains.
3. Preserve the `_notifyChange()` call inside the new `RadioGroup.onChanged`.

Edit nothing else in the file.

- [ ] **Step 4.3: Verify the warnings are gone**

```bash
flutter analyze 2>&1 | grep "fenologia_fournier_widget.dart" || echo "(fenologia_fournier_widget.dart clean)"
```

Expected: `(fenologia_fournier_widget.dart clean)`.

- [ ] **Step 4.4: Verify no new warnings**

```bash
flutter analyze 2>&1 | tail -1
```

Expected: `3 issues found.` (was 5, fixed 2).

- [ ] **Step 4.5: Smoke-test the widget**

The fenologia widget is interactive — a regression here would break phenology data entry. Build the app and exercise it:

```bash
flutter run -d <android-device-id-or-emulator>
```

In the running app: open a plant draft, navigate to the Habitat tab, scroll to the phenology section, tap each radio in a row and confirm:

- Selection visually toggles to the new index.
- The corresponding model field updates (verify by leaving the tab and returning — selection persists).
- No exceptions in the log.

Stop the app once verified. (If you do not have a device, log "skipped — no device" in the commit message and run again before merging.)

- [ ] **Step 4.6: Commit**

```bash
git add lib/shared/widgets/fenologia_fournier_widget.dart
git commit -m "$(cat <<'EOF'
fix: migrate fenologia_fournier_widget to RadioGroup

Flutter 3.32 deprecated Radio.groupValue and Radio.onChanged in favor
of a RadioGroup<T> ancestor. Wraps the rating row in RadioGroup<int>;
each Radio<int> child now carries only its value.
EOF
)"
```

---

## Task 5: Fix `conflict_resolution_screen.dart` underscore (1 issue)

**Files:**
- Modify: `lib/features/sync/screens/conflict_resolution_screen.dart` line 55.

**Issue:** `separatorBuilder: (_, __) => ...` — the `__` parameter triggers `unnecessary_underscores`. Dart 3.x treats `_` as a wildcard, so multiple `_` parameters in the same scope are valid.

- [ ] **Step 5.1: Verify the broken state**

```bash
flutter analyze 2>&1 | grep "conflict_resolution_screen.dart"
```

Expected:

```
   info • Unnecessary use of multiple underscores • lib/features/sync/screens/conflict_resolution_screen.dart:55:41 • unnecessary_underscores
```

- [ ] **Step 5.2: Apply the fix**

Find line 55 and replace `(_, __)` with `(_, _)`:

```dart
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: FoliumTheme.space16),
```

Edit nothing else in the file.

- [ ] **Step 5.3: Verify**

```bash
flutter analyze 2>&1 | grep "conflict_resolution_screen.dart" || echo "(conflict_resolution_screen.dart clean)"
```

Expected: `(conflict_resolution_screen.dart clean)`.

```bash
flutter analyze 2>&1 | tail -1
```

Expected: `2 issues found.` (was 3, fixed 1).

- [ ] **Step 5.4: Commit**

```bash
git add lib/features/sync/screens/conflict_resolution_screen.dart
git commit -m "fix: replace __ wildcard with _ in conflict_resolution separatorBuilder"
```

---

## Task 6: Fix `rain_mode_guard.dart` underscores (2 issues)

**Files:**
- Modify: `lib/shared/widgets/rain_mode_guard.dart` line 102.

**Issue:** `pageBuilder: (_, __, ___) => ...` triggers two `unnecessary_underscores` warnings (cols 24 and 28).

- [ ] **Step 6.1: Verify the broken state**

```bash
flutter analyze 2>&1 | grep "rain_mode_guard.dart"
```

Expected:

```
   info • Unnecessary use of multiple underscores • lib/shared/widgets/rain_mode_guard.dart:102:24 • unnecessary_underscores
   info • Unnecessary use of multiple underscores • lib/shared/widgets/rain_mode_guard.dart:102:28 • unnecessary_underscores
```

- [ ] **Step 6.2: Apply the fix**

Find line 102 and replace `(_, __, ___)` with `(_, _, _)`:

```dart
      pageBuilder: (_, _, _) => _RainModeUnlockOverlay(
```

Edit nothing else in the file.

- [ ] **Step 6.3: Verify**

```bash
flutter analyze 2>&1 | grep "rain_mode_guard.dart" || echo "(rain_mode_guard.dart clean)"
```

Expected: `(rain_mode_guard.dart clean)`.

```bash
flutter analyze 2>&1 | tail -1
```

Expected: `No issues found! (ran in <N>s)` — this is the **terminal target** of Phase 1.

- [ ] **Step 6.4: Commit**

```bash
git add lib/shared/widgets/rain_mode_guard.dart
git commit -m "fix: replace __/___ wildcards with _ in rain_mode_guard pageBuilder"
```

---

## Task 7: Final verification

**Files:** none modified.

- [ ] **Step 7.1: Confirm zero analyzer issues**

```bash
flutter analyze 2>&1 | tail -3
```

Expected (final two lines):

```
Analyzing field_book...
No issues found! (ran in <N>.<N>s)
```

If a non-zero count remains, re-read the failing line and apply the appropriate pattern from Tasks 1–6. **Do not** add new ignore directives or `// ignore_for_file` comments — fix root cause.

- [ ] **Step 7.2: Confirm the existing test still passes**

```bash
flutter test
```

Expected: `00:0X +1: All tests passed!` (the single smoke test in `test/widget_test.dart`).

- [ ] **Step 7.3: Manual smoke test on Android**

The two BuildContext-touched user flows are destructive — a behavior regression here would either crash on dispose or fail to delete/archive. Run on an Android emulator or device:

```bash
flutter run -d <android-device-id>
```

Smoke checklist (each step must succeed without exception in `adb logcat`):

1. Open the app, navigate to Plants tab.
2. Long-press a plant card to enter selection mode.
3. Select 2 plants, tap the delete action, confirm in both dialog and rain-mode guard.
4. Verify both plants are removed from the list and a snackbar shows `2 plants deleted` (or localized equivalent).
5. Navigate to Sessions tab, open a session detail.
6. Tap the menu, choose Archive, confirm in both dialog and rain-mode guard.
7. Verify the session is archived (badge or filter shows it).
8. From session detail, tap menu → Delete, confirm in both dialog and rain-mode guard.
9. Verify navigation pops back to the sessions list.
10. Open a plant detail, tap "Send to iNaturalist" (if a plant with a token-configured account is available; otherwise mock the token check by configuring a fake token in Settings → iNaturalist auth).
11. Verify the loading state engages and either a success or error snackbar appears.
12. Open a plant draft, navigate to Habitat tab, exercise the phenology rating widget — tap each rating in each row, leave the tab, return, confirm selections persist.
13. Quit the app cleanly (back-button until process exits).

If any step fails or logcat shows an exception, **stop**: identify the regression and revert the offending commit (`git revert HEAD`) before continuing.

- [ ] **Step 7.4: Phase 1 close-out**

Once smoke test passes:

```bash
git log --oneline phase-1/analyzer-fixes ^main
```

Expected: 6 commits (one per Task 1–6).

This branch is ready to merge to `main`. Per spec cross-cutting rule 4 (one phase, one branch, one merge), open a PR or fast-forward merge:

```bash
git checkout main
git merge --ff-only phase-1/analyzer-fixes
```

If `--ff-only` fails because main moved, rebase:

```bash
git checkout phase-1/analyzer-fixes
git rebase main
git checkout main
git merge --ff-only phase-1/analyzer-fixes
```

Phase 1 complete. The next session writes the Phase 2 plan (doc refresh) against the freshened spec.

---

## Self-review checklist (already run)

- [x] **Spec coverage** — every § Phase 1 item is covered: 8 BuildContext (Tasks 1, 2, 3 = 2+3+4=9 — wait, the spec lists 8 but Task 1 covers 2, Task 2 covers 3, Task 3 covers 4 = 9. Re-check the analyzer output: `home_screen 2 + plant_detail 3 + session_detail 4 = 9`. The spec § Phase 1.1 says 8. The analyzer is the source of truth: 9 instances were observed at audit time. Phase 1.1 spec text revised in self-review below.). 2 deprecated Radio API (Task 4). 4 underscores (Tasks 5, 6 — 1+2=3? Re-check: conflict_resolution = 1, rain_mode_guard = 2, total 3). The audit output reported 4 cosmetic — actual is 3. The audit text "4 cosmetic" was off by one; the analyzer output (the authoritative source) shows 3 `unnecessary_underscores`.
- [x] **Placeholder scan** — no `TBD`/`TODO`/`fill in details`. Each step has explicit code or commands.
- [x] **Type consistency** — captured local names (`messenger`, `errorColor`, `tertiaryColor`, `navigator`, `l10n`) are reused consistently across Tasks 1–3.
- [x] **Spec discrepancy fix** — the spec's "8 BuildContext-after-async" and "4 cosmetic" counts come from a quick audit grep; the authoritative `flutter analyze` output (run during plan writing) reports **9 BuildContext + 2 deprecated + 3 underscores = 14 total**, which still matches the spec's grand total of 14 issues. The plan's File Map and per-task counts use the authoritative breakdown. Update the spec § Phase 1 to match (an additional sub-step in Task 7 if you want to keep the spec in sync, otherwise leave for the Phase 2 doc-refresh pass).

---

## Deferred follow-ups (logged, NOT done in this phase)

Per spec cross-cutting rule 7, items found during writing this plan but out of scope:

- `lib/features/sessions/screens/session_detail_screen.dart:108` uses hard-coded `Colors.red` in a `SnackBar.backgroundColor`. Task 3 swaps it for `errorColor` opportunistically (since we're already capturing `errorColor`); this is a tiny design-system consistency win that does not require its own ticket.
- The spec's § Phase 1.1 line count ("8 instances") is off by one — actual is 9. Logged for the Phase 2 doc-refresh pass to correct in the spec source if the spec is ever quoted externally.
