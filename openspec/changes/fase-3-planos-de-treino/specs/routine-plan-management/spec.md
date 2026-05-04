## ADDED Requirements

### Requirement: List routine plans
An authenticated user SHALL be able to list their own routine plans. Plans belonging to other users SHALL NOT be returned. Plans SHALL be ordered by `start_date` descending.

#### Scenario: List own plans
- **GIVEN** user A has 2 plans and user B is authenticated
- **WHEN** `GET /api/v1/routine_plans` is called by user B (who has 1 plan)
- **THEN** the system returns HTTP 200 with only user B's 1 plan

#### Scenario: Empty list
- **GIVEN** the authenticated user has no plans
- **WHEN** `GET /api/v1/routine_plans` is called
- **THEN** the system returns HTTP 200 with `{ data: [], meta: { ... } }`

#### Scenario: Unauthenticated request
- **WHEN** `GET /api/v1/routine_plans` is called without an Authorization header
- **THEN** the system returns HTTP 401

---

### Requirement: Get routine plan details
An authenticated user SHALL be able to retrieve the full detail of their own routine plan, including all `RoutinePlanDay` records ordered by `(week_number ASC NULLS FIRST, day_of_week ASC)`.

#### Scenario: Get own plan with days
- **GIVEN** user A has a plan with 3 days (Mon/Wed/Fri, no week_number)
- **WHEN** `GET /api/v1/routine_plans/:id` is called by user A
- **THEN** the system returns HTTP 200 with the plan including a `days` array of length 3, each entry carrying `routine_id`, `day_of_week`, and `week_number`

#### Scenario: Get another user's plan
- **GIVEN** user A owns a plan
- **WHEN** user B calls `GET /api/v1/routine_plans/:id` for that plan
- **THEN** the system returns HTTP 403

---

### Requirement: Create routine plan
An authenticated user SHALL be able to create a routine plan. The plan SHALL be associated with the authenticated user as both `athlete_id` and `creator_id`. `start_date` SHALL be required; `end_date` MAY be null (open-ended plan).

#### Scenario: Successful plan creation
- **WHEN** `POST /api/v1/routine_plans` is called with `{ name: "Spring Push/Pull/Legs", start_date: "2026-05-04" }`
- **THEN** the system returns HTTP 201 with `{ id, name, athlete_id: <current_user_id>, creator_id: <current_user_id>, start_date: "2026-05-04", end_date: null, notes: null, days: [] }`

#### Scenario: Missing name
- **WHEN** `POST /api/v1/routine_plans` is called with `name: ""`
- **THEN** the system returns HTTP 422 with validation error on `name`

#### Scenario: Missing start_date
- **WHEN** `POST /api/v1/routine_plans` is called without `start_date`
- **THEN** the system returns HTTP 422 with validation error on `start_date`

#### Scenario: end_date before start_date
- **WHEN** `POST /api/v1/routine_plans` is called with `start_date: "2026-06-01", end_date: "2026-05-15"`
- **THEN** the system returns HTTP 422 with validation error on `end_date`

---

### Requirement: Update and delete routine plan
Only the plan owner SHALL be able to update or delete a plan.

#### Scenario: Owner updates plan name
- **WHEN** the owner calls `PATCH /api/v1/routine_plans/:id` with `{ name: "Summer Program" }`
- **THEN** the system returns HTTP 200 with updated plan

#### Scenario: Non-owner update attempt
- **WHEN** a different authenticated user calls `PATCH /api/v1/routine_plans/:id`
- **THEN** the system returns HTTP 403

#### Scenario: Owner deletes plan
- **WHEN** the owner calls `DELETE /api/v1/routine_plans/:id`
- **THEN** the system returns HTTP 204 and all `RoutinePlanDay` rows are removed (cascade)

---

### Requirement: Manage routine plan days
The plan owner SHALL be able to add, update (`routine_id`, `day_of_week`, `week_number`), and remove days from a plan. Each day SHALL reference a `Routine` owned by the same user. A plan SHALL NOT contain two days with the same `(week_number, day_of_week)` pair — adding a duplicate SHALL return 422.

#### Scenario: Add day to plan
- **GIVEN** the user owns a routine `r1` and a plan `p1`
- **WHEN** `POST /api/v1/routine_plans/p1/days` is called with `{ routine_id: "r1", day_of_week: 1 }`
- **THEN** the system returns HTTP 201 with `{ id, routine_plan_id: "p1", routine_id: "r1", day_of_week: 1, week_number: null }`

#### Scenario: Add day with week_number for periodization
- **WHEN** `POST /api/v1/routine_plans/p1/days` is called with `{ routine_id: "r1", day_of_week: 1, week_number: 2 }`
- **THEN** the system returns HTTP 201 with `week_number: 2`

#### Scenario: Add day pointing to another user's routine
- **GIVEN** the user does not own routine `r9`
- **WHEN** `POST /api/v1/routine_plans/p1/days` is called with `{ routine_id: "r9", day_of_week: 1 }`
- **THEN** the system returns HTTP 422 with a validation error on `routine`

#### Scenario: Add duplicate day
- **GIVEN** the plan already has a day with `(week_number: null, day_of_week: 1)`
- **WHEN** `POST /api/v1/routine_plans/p1/days` is called with `{ routine_id: "r2", day_of_week: 1 }` (no week_number)
- **THEN** the system returns HTTP 422 with a validation error on `day_of_week`

#### Scenario: Invalid day_of_week
- **WHEN** `POST /api/v1/routine_plans/p1/days` is called with `day_of_week: 7`
- **THEN** the system returns HTTP 422

#### Scenario: Update day to a different routine
- **WHEN** `PATCH /api/v1/routine_plans/p1/days/:day_id` is called with `{ routine_id: "r2" }`
- **THEN** the system returns HTTP 200 with the updated row

#### Scenario: Remove day from plan
- **WHEN** `DELETE /api/v1/routine_plans/p1/days/:day_id` is called
- **THEN** the system returns HTTP 204 and the day is no longer in the plan
