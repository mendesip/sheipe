## Context

Phase 2 shipped `Routine`, `Workout`, and the offline-first stack (Drift + `SyncQueue` + `SyncService`). The pieces this change builds on:
- API: `Routine` model + `RoutinePolicy`, nested-resource controller pattern (parent `authorize!`, child operations through the parent's relation), `BaseController#paginate`.
- Flutter: `SyncQueue` + `SyncService._dispatch` pattern keyed by `entity_type`; `RoutineRepository` as the offline-first reference.

What's missing: the join layer between `User`/`Athlete`, `Routine`, and "day of week" — i.e. the `RoutinePlan` and `RoutinePlanDay` models, plus a UI to author them.

## Goals / Non-Goals

**Goals:**
- Rails models `RoutinePlan` and `RoutinePlanDay` with UUID PKs.
- `action_policy` ownership for plans (creator-only).
- `GET /routine_plans/:id` includes `days` ordered for grid rendering.
- Validation that prevents two days at the same `(week_number, day_of_week)` and prevents pointing to a routine the user can't see.
- Offline-first Drift mirror with `SyncQueue` integration; `SyncService` learns two new entity types.
- `RoutinePlanViewModel` (Cubit) + 3 screens (list, detail grid, form) with `RoutinePickerSheet`.
- RSpec request specs + `bloc_test` view-model specs.

**Non-Goals:**
- Trainer-assigned plans (Phase 4).
- Plan templates / auto-generated periodization (manual `week_number` only).
- "Today's routine" surfaced in `StartWorkoutScreen` (Phase 3.5 follow-up).
- Notifications when a plan changes (Phase 7).

## Decisions

### 1 — `creator_id` and `athlete_id` are both the current user (Phase 3 only)

The data model already separates `athlete_id` (the user the plan applies to) from `creator_id` (who built it — could be a trainer in Phase 4). For Phase 3 the API treats them as the same user: `POST /routine_plans` sets both fields to `Current.user.id`. `RoutinePlanPolicy#scope` filters `WHERE athlete_id = current_user.id`; `update?` / `destroy?` check `record.creator_id == current_user.id`. Phase 4 will add a trainer scope (`POST /athletes/:id/routine_plans`) on top of these without touching the policy's owner-creator path.

### 2 — Uniqueness constraint on `(routine_plan_id, week_number, day_of_week)`

Two days at the same week-number / day-of-week makes no UX sense (one cell in the grid). Enforced at:
- DB level: `CREATE UNIQUE INDEX ... ON routine_plan_days (routine_plan_id, week_number, day_of_week) NULLS NOT DISTINCT` (Postgres 15+; treats `NULL` as equal so single-week plans behave as expected).
- Model level: `validates :day_of_week, uniqueness: { scope: [:routine_plan_id, :week_number] }` so we render a clean 422 instead of a unique-constraint error.

### 3 — `day_of_week` is an integer 0–6 with Sunday = 0

Matches the data model (`0=Dom ... 6=Sab`) and Postgres' `EXTRACT(DOW FROM ...)` convention. Validated `inclusion: 0..6`.

### 4 — Cross-user routine reference is a 422, not a 403

The endpoint that adds a day is owned by the plan's creator (auth passes), but the *body* references a routine. If the user picks a routine they don't own (manual API call — UI prevents it), the right surface is a validation error scoped to the day, not a forbidden on the parent. This mirrors how Phase 2's `POST /routines/:id/exercises` handles a hidden exercise.

### 5 — Drift schema bump v2 → v3, additive only

`RoutinePlansTable` and `RoutinePlanDaysTable` are added in `onUpgrade`; existing v2 tables are untouched. Same pattern fase-2 used for the v1 → v2 jump.

### 6 — `SyncService._dispatch` gains two entity types, not a new file

Pattern set by Phase 2: each entity is a `case` in `_dispatchXxx`. Adding `routine_plan` and `routine_plan_day` to `SyncService._dispatch` keeps the dispatcher dense and discoverable. `SyncOp.{create, update, delete}` cover everything; no new variant needed (no `finish`-style action here).

### 7 — Detail screen renders a `weeks × 7` grid; single-week plans collapse to one row

`RoutinePlanDetailScreen` groups `days` by `week_number` (treating `null` as "single-week"). Empty cells render as a "+ Add" tap target that opens the `RoutinePickerSheet`. The grid uses a fixed 7-column `GridView.count` for consistent visual rhythm. Periodization-aware plans (multiple distinct `week_number`s) get a vertical stack of week labels.

### 8 — `RoutinePickerSheet` reuses `RoutineViewModel` for the list

The picker is a thin bottom sheet that subscribes to the existing `RoutineViewModel` Drift stream and pops with the chosen `Routine`. No new view model — the picker is presentation-only. Same approach Phase 2 used for `AddExerciseSheet`.
