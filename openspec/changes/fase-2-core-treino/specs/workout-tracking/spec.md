## ADDED Requirements

### Requirement: Start a workout
An authenticated user SHALL be able to start a workout. If a `routine_id` is provided, the workout SHALL be pre-populated with `WorkoutExercise` and `WorkoutSet` records mirroring the routine's exercises and sets. Pre-population SHALL happen in a single DB transaction.

#### Scenario: Start a free workout (no routine)
- **WHEN** `POST /api/v1/workouts` is called with `{}` (no routine_id)
- **THEN** the system returns HTTP 201 with `{ id, user_id, routine_id: null, started_at, finished_at: null, notes: null }` and no exercises

#### Scenario: Start a workout from a routine
- **GIVEN** the user has a routine with 2 exercises (3 sets each)
- **WHEN** `POST /api/v1/workouts` is called with `{ routine_id: "<uuid>" }`
- **THEN** the system returns HTTP 201 with the workout including `exercises` array (2 items, each with 3 sets), `completed: false` on all sets

#### Scenario: Start a workout from another user's routine
- **GIVEN** user A owns a routine
- **WHEN** user B calls `POST /api/v1/workouts` with user A's `routine_id`
- **THEN** the system returns HTTP 422

---

### Requirement: Finish a workout
An authenticated user SHALL be able to finalize a workout by calling `POST /workouts/:id/finish`. The system SHALL record `finished_at = Time.current`. Calling finish on an already-finished workout SHALL be idempotent (HTTP 200, no error).

#### Scenario: Finish an in-progress workout
- **GIVEN** a workout with `finished_at: null`
- **WHEN** `POST /api/v1/workouts/:id/finish` is called
- **THEN** the system returns HTTP 200 with `finished_at` set to the current timestamp

#### Scenario: Finish an already-finished workout (idempotent)
- **GIVEN** a workout with `finished_at` already set
- **WHEN** `POST /api/v1/workouts/:id/finish` is called again
- **THEN** the system returns HTTP 200 and `finished_at` is unchanged

#### Scenario: Finish another user's workout
- **WHEN** user B calls `POST /api/v1/workouts/:id/finish` for user A's workout
- **THEN** the system returns HTTP 403

---

### Requirement: List and view workout history
An authenticated user SHALL be able to list their past workouts, optionally filtered by `date_range` and `routine_id`. Workouts SHALL be ordered by `started_at` descending.

#### Scenario: List own workouts
- **GIVEN** the user has 5 workouts
- **WHEN** `GET /api/v1/workouts` is called
- **THEN** the system returns the 5 workouts ordered by `started_at DESC`

#### Scenario: Filter by date range
- **WHEN** `GET /api/v1/workouts?start_date=2026-04-01&end_date=2026-04-30` is called
- **THEN** only workouts with `started_at` within April 2026 are returned

#### Scenario: Get workout detail
- **WHEN** `GET /api/v1/workouts/:id` is called for the user's own workout
- **THEN** the system returns HTTP 200 with the full workout including exercises and sets

#### Scenario: Get another user's workout
- **WHEN** `GET /api/v1/workouts/:id` is called for a workout owned by another user
- **THEN** the system returns HTTP 403

---

### Requirement: Manage workout exercises
The workout owner SHALL be able to add, update (position, notes), and remove exercises during an active workout.

#### Scenario: Add exercise to workout
- **WHEN** `POST /api/v1/workouts/:id/exercises` is called with `{ exercise_id, position: 1 }`
- **THEN** the system returns HTTP 201 with the new `WorkoutExercise`

#### Scenario: Remove exercise from workout
- **WHEN** `DELETE /api/v1/workouts/:id/exercises/:we_id` is called
- **THEN** the system returns HTTP 204

---

### Requirement: Log workout sets
The workout owner SHALL be able to add, update, and delete sets on a workout exercise. Each set SHALL record `weight`, `reps`, `rpe` (1–10), and `completed` flag.

#### Scenario: Log a set with weight and reps
- **WHEN** `POST /api/v1/workouts/:id/exercises/:we_id/sets` is called with `{ set_number: 1, weight: 100.0, reps: 5, rpe: 8.0, completed: true }`
- **THEN** the system returns HTTP 201 with the set object

#### Scenario: Mark set as incomplete
- **WHEN** a set is created with `completed: false`
- **THEN** `completed` is stored as `false`

#### Scenario: Update set after logging
- **WHEN** `PATCH /api/v1/workouts/:id/exercises/:we_id/sets/:set_id` is called with `{ weight: 102.5, completed: true }`
- **THEN** the system returns HTTP 200 with updated values

#### Scenario: RPE out of range
- **WHEN** a set is created with `rpe: 11`
- **THEN** the system returns HTTP 422 with a validation error on `rpe`

#### Scenario: Delete set
- **WHEN** `DELETE /api/v1/workouts/:id/exercises/:we_id/sets/:set_id` is called
- **THEN** the system returns HTTP 204
