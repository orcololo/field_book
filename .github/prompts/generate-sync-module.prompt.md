---
description: "Generate a complete sync module: NestJS sync endpoint + Flutter sync service for a given entity. Produces both backend and frontend sync code in one pass."
agent: "agent"
tools: [read, edit, search, execute, todo]
argument-hint: "Entity name to sync (e.g., PlantRecord, CollectionSession)"
---

# Generate Sync Module

Create a complete bidirectional sync implementation for the specified entity, covering both the NestJS backend endpoint and the Flutter client sync service.

## Step 1 — Understand the Entity

Read the Flutter Isar model in `lib/models/` and the corresponding Mongoose schema in `backend/src/modules/` for the target entity. Identify:
- All fields that need syncing
- The `SyncMetadata` embedded object (serverId, lastSyncedAt, syncStatus, conflictData)
- The `uuid` field used as client-side identity

## Step 2 — Backend Sync Endpoint (NestJS)

Create or update `backend/src/modules/<entity>/` with:

### Sync DTO (`dto/sync-<entity>.dto.ts`)
```ts
class SyncRequestDto {
  @IsDateString() lastSyncedAt: string;
  @ValidateNested({ each: true }) @Type(() => SyncEntityDto)
  changes: SyncEntityDto[];
}
```

### Sync Controller endpoint
```ts
@Post('sync')
@UseGuards(JwtAuthGuard)
async sync(@Body() dto: SyncRequestDto, @CurrentUser() user)
```

### Sync Service logic
- Accept client changes (upsert by `uuid`)
- Return server changes since `lastSyncedAt`
- Detect conflicts via `syncVersion` comparison
- Response: `{ synced: Entity[], conflicts: ConflictDto[], serverTimestamp: Date }`

## Step 3 — Flutter Sync Service

Create or update `lib/core/sync/` with:

### Sync Service (`<entity>_sync_service.dart`)
- `@riverpod` annotated class
- Method: `Future<SyncResult> sync()` that:
  1. Reads local pending changes from Isar (where `syncStatus != synced`)
  2. Sends batch to `POST /api/v1/<entity>/sync`
  3. Applies server changes to local Isar database
  4. Updates `SyncMetadata` on each record
  5. Handles conflicts by setting `syncStatus = conflict` and storing `conflictData`
- Uses Dio or http package for API calls
- Respects connectivity (only sync when online)

### Sync Repository (`<entity>_sync_repository.dart`)
- Methods: `getPendingChanges()`, `applyServerChanges()`, `markSynced()`, `markConflict()`

## Step 4 — Wire Everything

- Register sync endpoint in the NestJS module
- Register sync service as Riverpod provider
- Ensure both sides use identical field names and enum values

## Output

Produce all files with complete, production-ready code. No placeholders or TODOs.
