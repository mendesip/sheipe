## Why

After Phase 2 athletes can create routines and log workouts ad hoc, but they can't organize routines into a weekly schedule. A serious training program is structured (push/pull/legs across the week, periodization across weeks), and athletes need a place to plan that out and pick "today's routine" from a recurring schedule. Phase 3 delivers exactly that, while keeping trainer-assigned plans deferred to Phase 4 — this change is athlete-self-managed.

## What Changes

- **Rails**: `RoutinePlan` model (`name`, `athlete_id`, `creator_id`, `start_date`, `end_date`, `notes`) with full CRUD. `RoutinePlanDay` join table (`routine_plan_id`, `routine_id`, `day_of_week` 0–6, optional `week_number` for periodization) with nested CRUD. `action_policy` ownership: only the athlete (also the creator in Phase 3) can read/write their plans. `GET /routine_plans/:id` returns the plan with `days` array (each carrying its `routine_id` plus `day_of_week` / `week_number`).
- **Flutter**: Two new Drift tables (`RoutinePlansTable`, `RoutinePlanDaysTable`). `RoutinePlanRepository` follows the same offline-first contract used by Routine/Workout (write to Drift first, enqueue sync). New screens: `RoutinePlansListScreen`, `RoutinePlanDetailScreen` (grid of week × day with `week_number` support), `RoutinePlanFormScreen`, plus a `RoutinePickerSheet` to assign one of the user's routines to a day cell.
- **Sync**: extend `SyncService` to dispatch `routine_plan` and `routine_plan_day` operations to the new remote data source.

## Capabilities

### New Capabilities

- `routine-plan-management`: Create, view, update, and delete weekly training plans. A plan owns ordered `RoutinePlanDay` rows that map a `Routine` to a `day_of_week` (0=Sun … 6=Sat) and an optional `week_number` for multi-week periodization. Plans are private to the creator/athlete.

### Modified Capabilities

- `routine-management` (read-only impact): no behavioural change; routines listed for selection on the plan form come from the existing `GET /routines` endpoint.
- `offline-sync` (extension): the sync queue now also dispatches `routine_plan` and `routine_plan_day` entity types.

## Impact

- **API**: New models (`RoutinePlan`, `RoutinePlanDay`), new migrations, new controllers and nested routes, `action_policy` policies for both. New Alba serializers.
- **Flutter**: New `features/routine_plan/` directory; Drift schema bumped (v2 → v3) with two new tables; DI updated with the plan repository and view model; `SyncService._dispatch` extended to handle the new entity types; `app_router` adds routes for the three new screens.
- **Docs affected**: none (`docs/architecture/data-model.md`, `docs/architecture/api.md`, and `docs/architecture/screens.md` already cover RoutinePlan).

## Non-goals

- **Trainer-assigned plans** (`POST /athletes/:id/routine_plans`) — Phase 4 (trainer scope is the trigger).
- **"Start today's workout from plan"** integration in `StartWorkoutScreen` — this Phase 3 ships the plan editor; surfacing the day-of-week routine inside `StartWorkoutScreen` can land as a tiny Phase 3.5 follow-up. Tracking it as TODO in the screen, not blocking.
- **Periodization templates** (auto-generate week 1/2/3/4 from a single template) — power-user feature; Phase 3 only stores the `week_number` field on each day so an athlete can author it manually.
- **Notifications when a plan is assigned** — Phase 7.
- **Trainer-side read of athlete plans** — Phase 4.
