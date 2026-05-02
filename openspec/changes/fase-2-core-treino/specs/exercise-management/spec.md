## ADDED Requirements

### Requirement: List and filter exercises
The system SHALL return exercises visible to the authenticated user: all system exercises (`is_system: true`) plus exercises created by the authenticated user. Filtering by `muscle_group`, `category`, and text `query` (name contains) SHALL be supported. Results SHALL be paginated.

#### Scenario: List all exercises (no filters)
- **GIVEN** the user is authenticated and there are 3 system exercises and 2 custom exercises created by the user
- **WHEN** `GET /api/v1/exercises` is called
- **THEN** the system returns HTTP 200 with all 5 exercises in `{ data: [...], meta: { ... } }`

#### Scenario: Filter by muscle_group
- **GIVEN** exercises exist for `chest`, `back`, and `legs`
- **WHEN** `GET /api/v1/exercises?muscle_group=chest` is called
- **THEN** the system returns only exercises with `muscle_group: "chest"`

#### Scenario: Filter by category
- **WHEN** `GET /api/v1/exercises?category=cardio` is called
- **THEN** the system returns only exercises with `category: "cardio"`

#### Scenario: Filter by text query
- **WHEN** `GET /api/v1/exercises?query=bench` is called
- **THEN** the system returns only exercises whose name contains "bench" (case-insensitive)

#### Scenario: Custom exercises from other users are excluded
- **GIVEN** user A has a custom exercise and user B is authenticated
- **WHEN** `GET /api/v1/exercises` is called by user B
- **THEN** user A's custom exercise is NOT included in the response

#### Scenario: Unauthenticated request
- **WHEN** `GET /api/v1/exercises` is called without an Authorization header
- **THEN** the system returns HTTP 401

---

### Requirement: Get exercise details
An authenticated user SHALL be able to retrieve the full details of any system exercise or their own custom exercise.

#### Scenario: Get a system exercise
- **WHEN** `GET /api/v1/exercises/:id` is called for a system exercise
- **THEN** the system returns HTTP 200 with `{ id, name, description, muscle_group, category, is_system, creator_id }`

#### Scenario: Get another user's custom exercise
- **GIVEN** user A created a custom exercise
- **WHEN** user B calls `GET /api/v1/exercises/:id` for that exercise
- **THEN** the system returns HTTP 404

#### Scenario: Get non-existent exercise
- **WHEN** `GET /api/v1/exercises/:id` is called with a random UUID
- **THEN** the system returns HTTP 404

---

### Requirement: Create custom exercise
An authenticated user SHALL be able to create a custom exercise. The created exercise SHALL have `is_system: false` and `creator_id` set to the authenticated user's ID.

#### Scenario: Successful custom exercise creation
- **WHEN** `POST /api/v1/exercises` is called with `{ name, muscle_group, category }` and a valid token
- **THEN** the system returns HTTP 201 with the exercise object including `id`, `is_system: false`, `creator_id: <current_user_id>`

#### Scenario: Missing required name
- **WHEN** `POST /api/v1/exercises` is called with `name: ""`
- **THEN** the system returns HTTP 422 with `{ error: { code: "validation_failed", details: { name: ["can't be blank"] } } }`

#### Scenario: Invalid muscle_group value
- **WHEN** `POST /api/v1/exercises` is called with `muscle_group: "fingers"`
- **THEN** the system returns HTTP 422

---

### Requirement: Update custom exercise
Only the exercise owner or an admin SHALL be able to update an exercise. System exercises SHALL NOT be editable by non-admins.

#### Scenario: Owner updates their exercise
- **GIVEN** user A created a custom exercise
- **WHEN** user A calls `PATCH /api/v1/exercises/:id` with `{ name: "New Name" }`
- **THEN** the system returns HTTP 200 with the updated exercise

#### Scenario: Non-owner attempts update
- **GIVEN** user A created a custom exercise
- **WHEN** user B calls `PATCH /api/v1/exercises/:id`
- **THEN** the system returns HTTP 403

#### Scenario: Attempt to update a system exercise
- **WHEN** a non-admin user calls `PATCH /api/v1/exercises/:id` for a system exercise
- **THEN** the system returns HTTP 403

---

### Requirement: Delete custom exercise
Only the exercise owner or an admin SHALL be able to delete a custom exercise. System exercises SHALL NOT be deletable.

#### Scenario: Owner deletes their exercise
- **GIVEN** user A created a custom exercise not referenced by any routine or workout
- **WHEN** user A calls `DELETE /api/v1/exercises/:id`
- **THEN** the system returns HTTP 204

#### Scenario: Non-owner attempts delete
- **GIVEN** user A created a custom exercise
- **WHEN** user B calls `DELETE /api/v1/exercises/:id`
- **THEN** the system returns HTTP 403
