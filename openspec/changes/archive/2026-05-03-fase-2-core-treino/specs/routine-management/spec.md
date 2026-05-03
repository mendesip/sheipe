## ADDED Requirements

### Requirement: List routines
An authenticated user SHALL be able to list their own routines. Routines belonging to other users SHALL NOT be returned.

#### Scenario: List own routines
- **GIVEN** user A has 3 routines and user B is authenticated
- **WHEN** `GET /api/v1/routines` is called by user B (who has 2 routines)
- **THEN** the system returns only user B's 2 routines

#### Scenario: Empty list
- **GIVEN** the authenticated user has no routines
- **WHEN** `GET /api/v1/routines` is called
- **THEN** the system returns HTTP 200 with `{ data: [], meta: { ... } }`

---

### Requirement: Get routine details
An authenticated user SHALL be able to retrieve the full detail of their own routine, including all `RoutineExercise` records (ordered by `position`) and their nested `RoutineSet` records (ordered by `set_number`).

#### Scenario: Get own routine with exercises and sets
- **GIVEN** user A has a routine with 2 exercises and each exercise has 3 sets
- **WHEN** `GET /api/v1/routines/:id` is called by user A
- **THEN** the system returns HTTP 200 with the routine including `exercises` array, each with a `sets` array

#### Scenario: Get another user's routine
- **GIVEN** user A owns a routine
- **WHEN** user B calls `GET /api/v1/routines/:id` for that routine
- **THEN** the system returns HTTP 403

---

### Requirement: Create routine
An authenticated user SHALL be able to create a routine. The routine SHALL be associated with the authenticated user as `creator_id`.

#### Scenario: Successful routine creation
- **WHEN** `POST /api/v1/routines` is called with `{ name: "Upper A", description: "..." }`
- **THEN** the system returns HTTP 201 with `{ id, name, description, creator_id: <current_user_id>, created_at }`

#### Scenario: Missing name
- **WHEN** `POST /api/v1/routines` is called with `name: ""`
- **THEN** the system returns HTTP 422 with validation error on `name`

---

### Requirement: Update and delete routine
Only the routine owner SHALL be able to update or delete a routine.

#### Scenario: Owner updates routine name
- **WHEN** the owner calls `PATCH /api/v1/routines/:id` with `{ name: "Upper B" }`
- **THEN** the system returns HTTP 200 with updated routine

#### Scenario: Non-owner update attempt
- **WHEN** a different authenticated user calls `PATCH /api/v1/routines/:id`
- **THEN** the system returns HTTP 403

#### Scenario: Owner deletes routine
- **WHEN** the owner calls `DELETE /api/v1/routines/:id`
- **THEN** the system returns HTTP 204

---

### Requirement: Manage routine exercises
The routine owner SHALL be able to add, update (position, notes), and remove exercises from a routine. Each `RoutineExercise` SHALL reference a valid `Exercise` visible to the user.

#### Scenario: Add exercise to routine
- **WHEN** `POST /api/v1/routines/:id/exercises` is called with `{ exercise_id, position: 1 }`
- **THEN** the system returns HTTP 201 with `{ id, exercise_id, position, notes }`

#### Scenario: Add exercise not visible to user
- **GIVEN** the exercise belongs to another user (not system)
- **WHEN** `POST /api/v1/routines/:id/exercises` is called with that exercise_id
- **THEN** the system returns HTTP 422

#### Scenario: Update exercise position
- **WHEN** `PATCH /api/v1/routines/:id/exercises/:re_id` is called with `{ position: 2 }`
- **THEN** the system returns HTTP 200 with updated position

#### Scenario: Remove exercise from routine
- **WHEN** `DELETE /api/v1/routines/:id/exercises/:re_id` is called
- **THEN** the system returns HTTP 204 and the exercise is no longer in the routine

---

### Requirement: Manage routine sets
The routine owner SHALL be able to add, update, and remove sets on a routine exercise. Each set SHALL have `set_number`, `weight`, `reps`, `rest_seconds`, and `set_type`.

#### Scenario: Add set to routine exercise
- **WHEN** `POST /api/v1/routines/:id/exercises/:re_id/sets` is called with `{ set_number: 1, weight: 80.0, reps: 8, rest_seconds: 90, set_type: "working" }`
- **THEN** the system returns HTTP 201 with the set object

#### Scenario: Invalid set_type
- **WHEN** a set is created with `set_type: "invalid"`
- **THEN** the system returns HTTP 422

#### Scenario: Update set weight and reps
- **WHEN** `PATCH /api/v1/routines/:id/exercises/:re_id/sets/:set_id` is called with `{ weight: 85.0, reps: 6 }`
- **THEN** the system returns HTTP 200 with updated values

#### Scenario: Delete set
- **WHEN** `DELETE /api/v1/routines/:id/exercises/:re_id/sets/:set_id` is called
- **THEN** the system returns HTTP 204
