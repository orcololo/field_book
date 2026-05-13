<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-05-13 -->

# test — Flutter Test Suite

## Purpose

All Flutter tests: unit tests for repositories and services, widget tests for screens, integration tests for end-to-end flows, and golden tests for visual regression.

## Key Files

| File | Description |
|------|-------------|
| `widget_test.dart` | Smoke test — app launches without crashing |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `unit/repositories/` | Repository unit tests (real Isar instances via `IsarTestHelper`) |
| `unit/services/` | Service unit tests (mocked dependencies) |
| `test_helpers/` | Shared test infrastructure |
| `widget/screens/` | Widget tests for individual screens |
| `integration/` | End-to-end integration tests (currently empty) |
| `golden/` | Golden image tests for visual regression (currently empty) |

## Key Test Helpers

| File | Description |
|------|-------------|
| `test_helpers/isar_test_helper.dart` | Sets up isolated Isar instances for testing |
| `test_helpers/isar_test_helper_smoke_test.dart` | Verifies the helper itself works |
| `test_helpers/mocks.dart` | Shared mock definitions (Mockito/Mocktail) |

## For AI Agents

### Working In This Directory

- Repository tests use real Isar (via `IsarTestHelper`) — not mocked.
- Service tests mock their dependencies (repositories, external APIs).
- Follow existing test patterns in `unit/` before writing new tests.
- Use `IsarTestHelper.setUp()` / `tearDown()` in repository tests.
- Import mocks from `test_helpers/mocks.dart` — don't duplicate.

### Running Tests

```bash
cd field_book
flutter test                          # All tests
flutter test test/unit/               # Unit tests only
flutter test test/widget/             # Widget tests only
flutter test --coverage               # With coverage report
```

### Adding Tests

- New repository test: `test/unit/repositories/<name>_repository_test.dart`
- New service test: `test/unit/services/<name>_service_test.dart`
- New widget test: `test/widget/screens/<name>_screen_test.dart`
- New integration test: `test/integration/<flow>_test.dart`

## Dependencies

### Internal

- `lib/models/` — Isar model definitions
- `lib/core/repositories/` — repository implementations under test
- `lib/core/services/` — service implementations under test

### External

- `flutter_test` — test framework
- `isar` + `isar_flutter_libs` — real DB in repository tests
- `mocktail` or `mockito` — mocking (check `mocks.dart` for which)

<!-- MANUAL: -->
