## Context

Phase 1 is complete. Rails has `User`, `Session`, `BaseController` with `authenticate` before-action, and Alba serializers. Flutter has `AuthRepository`, `AuthInterceptor` (QueuedInterceptorsWrapper), `AuthViewModel`, DI, GoRouter, Drift singleton, and the abstract Repository pattern. What's missing: all training domain models on the API, all training Drift tables on Flutter, and the feature screens.

## Goals / Non-Goals

**Goals:**
- Rails models: `Exercise`, `Routine`, `RoutineExercise`, `RoutineSet`, `Workout`, `WorkoutExercise`, `WorkoutSet` with UUID PKs
- `action_policy` policies enforcing ownership on every writable resource
- `POST /workouts` with optional `routine_id` pre-populates `WorkoutExercise` + `WorkoutSet` from the routine
- `POST /workouts/:id/finish` sets `finished_at = Time.current`; idempotent (no error if already finished)
- System exercises seeded at startup (`is_system: true`, `creator_id: nil`)
- Alba serializers for all new models with appropriate nesting
- RSpec request specs + FactoryBot for all new endpoints
- Drift tables for all 7 new entities; `AppDatabase` singleton updated
- Offline-first: `LocalDataSource` (Drift) writes first; `SyncService` background sync to API; conflict resolution by `updated_at`
- Flutter unit tests with `bloc_test` + `mocktail` for each ViewModel and Repository

**Non-Goals:** RoutinePlan, trainer scope, Gym/Equipment, social, ExerciseEquipment join table, rswag docs.

## Decisions

### 1 — action_policy ownership rules

Each resource belongs to the authenticated user. Policies:
- `ExercisePolicy`: `index?` and `show?` — any authenticated user. `create?` — any authenticated user. `update?` / `destroy?` — `record.creator == current_user || current_user.admin?`. System exercises (`is_system: true`) are not editable by anyone except admins.
- `RoutinePolicy`, `WorkoutPolicy` — full CRUD only for `record.creator == current_user`.
- Nested resources (`RoutineExercise`, `RoutineSet`, `WorkoutExercise`, `WorkoutSet`) inherit from their parent: authorization is checked on the parent resource (e.g., `authorize! routine, to: :update?`).

### 2 — Workout from routine: pre-population on create

`POST /workouts` accepts optional `routine_id`. When present:
1. Create `Workout` with `routine_id`
2. For each `RoutineExercise` (ordered by `position`): create `WorkoutExercise` with `routine_exercise_id`
3. For each `RoutineSet` under that `RoutineExercise`: create `WorkoutSet` with `completed: false`, copying `weight`, `reps`, `set_number`

This is done in a single DB transaction. If `routine_id` is absent, the workout starts empty.

### 3 — Offline-first sync strategy (Flutter)

All user writes go to Drift first, then sync to the API in the background. The `SyncService` is a singleton registered in DI, started at app boot after `AuthAuthenticated`.

**Write flow:**
1. ViewModel calls `repository.create/update/delete(entity)`
2. Repository writes to `LocalDataSource` (Drift) — assigns a client-generated UUID if `id` is null
3. Repository enqueues the operation in `SyncQueue` (Drift table: `sync_operations`)
4. UI updates immediately from Drift stream
5. `SyncService` picks up queued operations, calls `RemoteDataSource`, marks as synced on success

**Read flow:**
- App always reads from Drift (streams via `watchAll`)
- Initial load: if `lastSyncedAt` is null or stale (>5 min), `SyncService` fetches from API and upserts into Drift

**Conflict resolution:** last-write-wins by `updated_at`. Server value wins on pull; local value wins on push (client is source of truth for active workout).

**Active workout exception:** `WorkoutSet` writes during an active workout session skip the sync queue and go directly to both Drift and the API (fire-and-forget, with retry on reconnect). This ensures real-time persistence without waiting for the queue.

### 4 — Drift tables: UUID PKs as Text

Drift does not have a native UUID column type. All IDs are stored as `TextColumn` with the naming convention `id`, and client-side UUIDs are generated with `const Uuid().v4()` from the `uuid` package.

### 5 — ExerciseLibraryScreen uses server-side filtering

`GET /exercises?muscle_group=&category=&query=` handles filtering on the server. The local Drift cache is used for offline display (last synced list). When online, the `ExerciseRepository` always hits the API for searches and upserts results into Drift.

### 6 — ActiveWorkoutScreen is a fullscreen modal route

In GoRouter, `ActiveWorkoutScreen` is pushed as a `ShellRoute` modal. It cannot be dismissed by the back button — only via "Finish Workout" or an explicit "Discard" confirmation dialog. This prevents accidental loss of in-progress workout data.

### 7 — RestTimerOverlay is a stateful widget (exception to Cubit rule)

The rest timer is a countdown purely driven by `Duration` — no business logic, no API calls, no state persistence. It is implemented as a `StatefulWidget` using a `Timer`. The `ActiveWorkoutViewModel` tracks `currentRestSeconds` as state so it can be restored if the screen is rebuilt.
