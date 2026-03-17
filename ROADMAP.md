# Field Book — Roadmap & Next Steps

> Last updated: March 17, 2026  
> Current state: Mature Flutter frontend (offline-first), early NestJS backend with basic modules, sync infrastructure not yet connected

---

## Current State Summary

| Area | Maturity | Notes |
|------|----------|-------|
| Flutter Frontend | ★★★★☆ | 11 feature modules, Isar local DB, export/import, maps, audio transcription |
| NestJS Backend | ★★☆☆☆ | Auth, CRUD modules, R2 upload, Swagger — but shallow test coverage |
| Sync (Flutter ↔ API) | ★☆☆☆☆ | Backend endpoints exist but Flutter has no HTTP client at all |
| CI/CD | ☆☆☆☆☆ | No GitHub Actions, manual builds and releases |
| Testing | ★☆☆☆☆ | Minimal — 2 backend unit specs, 1 e2e spec; Flutter test dirs exist but sparse |

---

## Phase 1 — Connect Flutter to Backend (Critical)

The app is 100% offline today. This phase bridges it to the API.

### 1.1 Flutter HTTP Client Layer
- [ ] Add `dio` dependency to `pubspec.yaml`
- [ ] Create `lib/core/network/api_client.dart` — base Dio instance with base URL, timeouts, content-type
- [ ] Create `lib/core/network/auth_interceptor.dart` — attach JWT access token to every request, auto-refresh on 401
- [ ] Create `lib/core/network/connectivity_interceptor.dart` — queue requests when offline (leverage existing `connectivity_plus`)
- [ ] Store tokens securely with `flutter_secure_storage`
- [ ] Create `lib/core/network/api_endpoints.dart` — centralized endpoint constants

### 1.2 Auth Integration on Flutter
- [ ] Create `lib/core/services/auth_service.dart` — login, Google sign-in, refresh, logout calls
- [ ] Create `AuthNotifier` Riverpod provider managing auth state (unauthenticated → authenticated → expired)
- [ ] Add login/register screens (or gate in onboarding flow)
- [ ] Persist auth state across app restarts (secure storage)
- [ ] Handle token expiry gracefully — silent refresh or redirect to login

### 1.3 Sync Service on Flutter
- [ ] Create `lib/core/sync/sync_service.dart` — orchestrate push/pull cycles
- [ ] Map Isar `PlantRecord` fields → API `SyncRegistryItemDto` JSON (47 fields)
- [ ] Map Isar `CollectionSession` fields → API `SyncSessionItemDto` JSON
- [ ] Implement conflict resolution UI — show diff, let user pick version
- [ ] Create `lib/core/sync/sync_queue.dart` — track pending changes (created/updated/deleted since last sync)
- [ ] Add sync status indicator in app bar or settings
- [ ] Background sync with `workmanager` or periodic timer

### 1.4 Media Upload Coordination
- [ ] Before sync push, upload local photos to R2 via upload endpoint
- [ ] Replace local file paths with R2 URLs in registry data before pushing
- [ ] Handle partial upload failures (retry queue)
- [ ] Download remote images on pull for offline access (cache with `cached_network_image`)
- [ ] Audio file upload support (field recordings, transcriptions)

---

## Phase 2 — Backend Hardening

### 2.1 Testing
- [ ] **Unit tests** for every service (Species, Registry, CollectionSessions, Sync, Upload)
- [ ] **Integration tests** — full request cycle with in-memory MongoDB (`mongodb-memory-server`)
- [ ] **Auth flow e2e** — register → login → access protected route → refresh → logout
- [ ] **Sync e2e** — push records → pull delta → conflict resolution
- [ ] **Upload e2e** — upload image → verify R2 key → delete → verify removed
- [ ] Target: ≥80% line coverage

### 2.2 Error Handling & Resilience
- [ ] Add retry logic for R2 operations (transient S3 errors)
- [ ] Add database transaction support for sync batch operations (Mongoose sessions)
- [ ] Implement idempotency keys for push endpoints to prevent duplicate processing
- [ ] Add request-scoped correlation IDs for distributed tracing

### 2.3 Security Enhancements
- [ ] Add rate limiting per-route (stricter on auth endpoints: 5 req/min for login)
- [ ] Implement refresh token rotation (invalidate old token on use)
- [ ] Store refresh tokens in database with device fingerprint
- [ ] Add CSRF protection for cookie-based sessions (if applicable)
- [ ] Validate file types & scan uploads (not just extension checks)
- [ ] Add API key support for service-to-service calls

### 2.4 Performance
- [ ] Add Redis caching layer (`@nestjs/cache-manager` + `cache-manager-redis-yet`)
  - Cache species lookups (changes rarely)
  - Cache user profile data
- [ ] Add database indexes review — ensure compound indexes cover common queries
- [ ] Implement cursor-based pagination for large collections (instead of skip/limit)
- [ ] Add response compression for large payloads (already using `compression` middleware, verify gzip)
- [ ] Connection pooling tuning for MongoDB

---

## Phase 3 — CI/CD & DevOps

### 3.1 GitHub Actions Workflows
- [ ] **Backend CI** — on PR: lint → build → unit tests → e2e tests
- [ ] **Flutter CI** — on PR: analyze → test → build APK (debug)
- [ ] **Release workflow** — on tag: build signed APK → create GitHub release → upload artifact
- [ ] **Docker build** — on main: build & push Docker image to registry

### 3.2 Environment & Deployment
- [ ] Set up staging environment (separate MongoDB, R2 bucket)
- [ ] Create production deployment config (Docker Compose or Kubernetes manifests)
- [ ] Configure MongoDB Atlas for production (or managed MongoDB service)
- [ ] Set up monitoring — health check pings, uptime alerts
- [ ] Add structured logging (JSON format) for production log aggregation
- [ ] Set up `.env.production`, `.env.staging` templates

### 3.3 Database Operations
- [ ] Create migration scripts for schema changes (Mongoose doesn't have built-in migrations)
- [ ] Set up automated database backups
- [ ] Create seed scripts for development data
- [ ] Add database connection health checks with configurable timeouts

---

## Phase 4 — Feature Enhancements

### 4.1 Collaboration & Sharing
- [ ] **Session sharing via backend** — currently local QR/code sharing; add server-mediated sharing
- [ ] **Real-time collaboration** — WebSocket gateway (`@nestjs/websockets`) for live session participants
- [ ] **Team workspaces** — group multiple users under an organization/team
- [ ] **Activity feed** — show recent changes by team members
- [ ] **Comments/annotations** — allow notes on shared registries between collaborators

### 4.2 Species Database Enrichment
- [ ] **Bulk species import** — CSV/JSON upload to populate taxonomy database
- [ ] **External API integration** — auto-complete from GBIF, iNaturalist, or Flora do Brasil
- [ ] **Species suggestions** — based on location, season, and morphology inputs
- [ ] **Taxonomic hierarchy** — kingdom → phylum → class → order → family → genus → species
- [ ] **Species images** — reference photos from verified databases
- [ ] **Synonymy handling** — link synonymous species names

### 4.3 Advanced Search & Discovery
- [ ] **Full-text search on backend** — MongoDB Atlas Search or Elasticsearch for richer queries
- [ ] **Faceted search** — filter by multiple dimensions simultaneously with counts
- [ ] **Geospatial queries** — find registries near a coordinate (MongoDB `$geoNear`)
- [ ] **Date range analytics** — collection frequency over time, seasonal patterns
- [ ] **Duplicate detection** — flag potential duplicate registries (same species + location + date)

### 4.4 Reporting & Analytics
- [ ] **Collection reports** — PDF generation with charts, maps, and specimen tables
- [ ] **Dashboard API** — stats endpoint (total species, registries per month, coverage maps)
- [ ] **Export evolution** — server-side export for large datasets (async job + download link)
- [ ] **Darwin Core compliance** — ensure exported data meets DwC-A standard for biodiversity portals

### 4.5 Notifications
- [ ] **Push notifications** — Firebase Cloud Messaging for sync completion, team invites, sharing
- [ ] **Email notifications** — welcome email, password reset, weekly collection summary
- [ ] **In-app notifications** — new shared sessions, sync conflicts requiring attention

---

## Phase 5 — Quality & Polish

### 5.1 Observability
- [ ] **Application Performance Monitoring** — Sentry for both Flutter and NestJS
- [ ] **Structured logging** — correlation IDs, request context, log levels
- [ ] **Metrics** — Prometheus metrics endpoint (`/metrics`) with Grafana dashboards
  - Request rate, latency percentiles, error rate
  - Sync operations per hour, conflict rate
  - Storage usage (R2 bucket size)
- [ ] **Uptime monitoring** — external health check pings

### 5.2 Documentation
- [ ] **API documentation** — enhance Swagger descriptions, add example values to all DTOs
- [ ] **Developer onboarding guide** — setup instructions for new contributors
- [ ] **Architecture Decision Records (ADRs)** — document key technical decisions
- [ ] **Data model diagram** — ERD for MongoDB collections and their relationships
- [ ] **Sync protocol documentation** — flowchart of push/pull/conflict resolution

### 5.3 Accessibility & i18n
- [ ] **Accessibility audit** — ensure all screens pass WCAG 2.1 AA
- [ ] **RTL language support** — Arabic, Hebrew if needed
- [ ] **Additional localizations** — French, German, Italian for international researchers
- [ ] **Offline locale bundles** — ensure translations work without network

### 5.4 App Store Readiness
- [ ] **iOS build** — configure signing, provisioning profiles, App Store Connect
- [ ] **Play Store listing** — screenshots, description, privacy policy
- [ ] **Privacy policy & terms** — GDPR/LGPD compliant data handling docs
- [ ] **App review preparation** — test on multiple devices, screen sizes, OS versions

---

## Nice-to-Have Features

### AI & Machine Learning
- [ ] **Plant identification from photos** — integrate TensorFlow Lite or cloud vision API
- [ ] **Smart field suggestions** — predict habitat, soil type, elevation from GPS coordinates
- [ ] **Voice-to-structured-data** — use audio transcription to auto-fill morphology fields
- [ ] **Handwriting recognition** — OCR for field notebook digitization

### Offline & Performance
- [ ] **Offline map tiles** — pre-download region tiles for field areas without connectivity
- [ ] **Incremental sync** — sync only changed fields instead of full records
- [ ] **Compression** — gzip sync payloads for bandwidth savings in remote areas
- [ ] **Battery optimization** — reduce GPS polling frequency when stationary

### Data Interoperability
- [ ] **GBIF publishing** — direct dataset publishing to Global Biodiversity Information Facility
- [ ] **iNaturalist sync** — two-way sync with iNaturalist observations
- [ ] **Herbarium label printing** — generate formatted specimen labels (PDF/thermal printer)
- [ ] **Barcode/QR tracking** — print and scan specimen labels for physical herbarium management

### Web Dashboard
- [ ] **Admin panel** — web interface for managing users, species, bulk operations
- [ ] **Collection viewer** — public or team web view of collection data with maps
- [ ] **Data visualization** — interactive charts, heatmaps, timeline views on web

### Hardware Integration
- [ ] **Bluetooth sensors** — temperature, humidity, soil pH from field instruments
- [ ] **External GPS** — high-precision GPS receiver integration
- [ ] **Drone integration** — import drone survey photos with GPS coordinates

---

## Priority Matrix

| Priority | Items | Impact | Effort |
|----------|-------|--------|--------|
| **P0 — Now** | Flutter HTTP client, Auth integration, Sync service | Unlocks cloud features | Medium |
| **P1 — Soon** | Backend testing, CI/CD pipelines, Media upload coordination | Reliability & velocity | Medium |
| **P2 — Next** | Session sharing via backend, Species enrichment, Security hardening | Collaboration & data quality | Large |
| **P3 — Later** | Notifications, Reporting, Web dashboard | User engagement | Large |
| **P4 — Wishlist** | AI plant ID, GBIF publishing, Hardware integration | Differentiation | Very Large |

---

## Technical Debt

| Item | Location | Severity |
|------|----------|----------|
| No HTTP client in Flutter | `lib/core/` | **Critical** — blocks all cloud features |
| Sync module is basic | `backend/src/modules/sync/` | **High** — conflict resolution needs real-world testing |
| Only 3 backend test files | `backend/src/`, `backend/test/` | **High** — refactoring risky without coverage |
| No CI/CD | `.github/workflows/` | **Medium** — manual process prone to errors |
| Google Drive backup vs R2 sync overlap | `lib/core/services/google_drive_backup_service.dart` | **Low** — two backup mechanisms, clarify which is primary |
| Hardcoded rate limits | `backend/src/app.module.ts` | **Low** — should be env-configurable per route |
| No database migrations strategy | `backend/` | **Medium** — schema changes need coordination |
