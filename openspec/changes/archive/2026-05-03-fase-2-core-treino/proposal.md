## Why

Phase 1 delivers authentication and profile. Phase 2 is the core product value — without it, the app is not useful to anyone. An athlete must be able to browse exercises, build routines, and log workouts (including offline). This is the minimal viable product: after Phase 2 the app can be used for real training sessions without any other phase being complete.

## What Changes

- **Rails**: `Exercise` model with CRUD and system seed. `Routine` + `RoutineExercise` + `RoutineSet` with full CRUD (nested routes). `Workout` + `WorkoutExercise` + `WorkoutSet` with full CRUD + `POST /workouts/:id/finish`. `action_policy` authorization on every resource — athletes own their routines and workouts; system exercises are read-only for non-owners. Alba serializers for all new models.
- **Flutter**: Drift tables for all training entities (`ExercisesTable`, `RoutinesTable`, `RoutineExercisesTable`, `RoutineSetsTable`, `WorkoutsTable`, `WorkoutExercisesTable`, `WorkoutSetsTable`). Offline-first: write to Drift first, background sync to API, conflict resolution by `updated_at`. Exercise, Routine, and Workout features each get their own `Repository` + `ViewModel` (Cubit) + screen tree.

## Capabilities

### New Capabilities

- `exercise-management`: Browse, filter, and manage exercises (system + custom). Filterable by `muscle_group`, `category`, and text query. Athletes can create custom exercises; only owners (or admin) can edit/delete them.
- `routine-management`: Create and manage training routines — add exercises with ordered sets (weight, reps, rest, set_type). Routines are private to the creator.
- `workout-tracking`: Log a training session in real time — from an existing routine (pre-populated exercises/sets) or free-form. Log weight, reps, and RPE per set. Finish a workout to record `finished_at`. Offline-first: all writes go to Drift first.

### Modified Capabilities

- `user-profile` (read-only): `ProfileScreen` gains a Workout tab showing recent workout history once Phase 2 screens are wired.

## Impact

- **API**: New models (`Exercise`, `Routine`, `RoutineExercise`, `RoutineSet`, `Workout`, `WorkoutExercise`, `WorkoutSet`), new migrations, new controllers and nested routes, `action_policy` policies for each resource.
- **Flutter**: New `features/exercise/`, `features/routine/`, `features/workout/` directories; Drift schema extended with 7 new tables; `AppDatabase` singleton updated; DI updated with all new repositories and view models.
- **Docs affected**: `docs/architecture/data-model.md` (training entities), `docs/architecture/api.md` (exercise/routine/workout endpoints), `docs/architecture/screens.md` (training screen tree).

## Non-goals

- `RoutinePlan` / `RoutinePlanDay` (weekly periodization) — Phase 3.
- Trainer scope on workouts (`trainer_notes`, athlete history view) — Phase 4.
- `Gym` / `Equipment` associations on `Workout` (`gym_id`) — Phase 4.
- Social posting of workouts (`WorkoutPost`, `PostMedia`) — Phase 6.
- `ExerciseEquipment` join table — referenced in data model but not required for MVP training flow.
- Push notifications on workout events — Phase 7.
- `rswag` API documentation — Phase 8.
