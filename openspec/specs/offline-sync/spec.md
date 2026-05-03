### Requirement: Write-first local persistence
All training data mutations (create, update, delete) on the Flutter side SHALL be written to Drift immediately, before any API call. The UI SHALL update from Drift streams — it SHALL NOT wait for the API response to reflect changes.

#### Scenario: Create routine while offline
- **GIVEN** the device has no network connection
- **WHEN** the user creates a new routine
- **THEN** the routine appears immediately in the UI from Drift, and a sync operation is enqueued

#### Scenario: Log workout set without network
- **GIVEN** the device has no network connection
- **WHEN** the user logs a set (weight, reps, rpe)
- **THEN** the set is persisted in Drift and visible in the UI; a sync operation is enqueued

---

### Requirement: Background sync
The `SyncService` SHALL process enqueued sync operations when network connectivity is available. On success the operation SHALL be marked as synced. On failure the operation SHALL remain in the queue for retry.

#### Scenario: Sync queue is drained when network becomes available
- **GIVEN** 3 sync operations are enqueued from offline activity
- **WHEN** network connectivity is restored
- **THEN** `SyncService` processes all 3 operations, calls the corresponding API endpoints, and clears them from the queue

#### Scenario: Failed sync operation is retried
- **GIVEN** a sync operation fails with a network error
- **WHEN** `SyncService` retries on the next connectivity event
- **THEN** the operation is attempted again and succeeds

---

### Requirement: Initial data load
When the authenticated user first opens the app (no local data) or when the local cache is stale (last synced > 5 minutes ago), the app SHALL fetch exercises and routines from the API and upsert them into Drift.

#### Scenario: First launch — exercises loaded from API
- **GIVEN** the Drift `ExercisesTable` is empty and the user is authenticated
- **WHEN** the app is opened and the `ExerciseRepository` initializes
- **THEN** `SyncService` fetches `GET /exercises` and populates Drift; `ExerciseLibraryScreen` shows the results

#### Scenario: Stale cache triggers refresh
- **GIVEN** the last sync was more than 5 minutes ago
- **WHEN** the user opens `ExerciseLibraryScreen`
- **THEN** the screen first shows cached data from Drift, then `SyncService` fetches fresh data and updates the stream

---

### Requirement: Conflict resolution
When pulling data from the API into Drift, the system SHALL use last-write-wins by `updated_at`. If the server `updated_at` is newer than the local record, the server value SHALL overwrite the local record. If the local record is newer (edited offline), the local value SHALL be preserved until it is successfully pushed.

#### Scenario: Server record is newer
- **GIVEN** the server has a routine with `updated_at: T+10` and Drift has the same routine with `updated_at: T+5`
- **WHEN** `SyncService` pulls the routine
- **THEN** Drift is updated with the server values

#### Scenario: Local record is newer (offline edit)
- **GIVEN** the local Drift has a routine with `updated_at: T+10` (edited offline) and the server has `updated_at: T+5`
- **WHEN** `SyncService` attempts to pull
- **THEN** the local record is preserved; the pending push operation takes priority
