## 1. API — Exercise model + policy

- [x] 1.1 Write failing model spec `spec/models/exercise_spec.rb` (valid, blank name, invalid muscle_group, invalid category, is_system default false, creator optional)
- [x] 1.2 Run spec — verify `FAILED — uninitialized constant Exercise`
- [x] 1.3 Generate migration `CreateExercises` with UUID PK, `name`, `description`, `muscle_group` string, `category` string, `is_system` boolean default false, `creator_id` UUID nullable FK → users
- [x] 1.4 Create `app/models/exercise.rb` — `belongs_to :creator, class_name: "User", optional: true`, `enum :muscle_group`, `enum :category`, validates `name` presence
- [x] 1.5 Create `spec/factories/exercises.rb` — sequence name, trait `:system` sets `is_system: true, creator: nil`
- [x] 1.6 Run `rails db:migrate`
- [x] 1.7 Run model spec — verify all passing
- [x] 1.8 Create `app/policies/exercise_policy.rb` — `index?`/`show?` open; `create?` any auth; `update?`/`destroy?` owner or admin; system exercises block update/destroy for non-admins
- [x] 1.9 Write policy spec `spec/policies/exercise_policy_spec.rb` covering all 5 actions and edge cases
- [x] 1.10 Commit: `feat(api): add Exercise model and ExercisePolicy`

## 2. API — Exercise serializer + seed

- [x] 2.1 Create `app/serializers/exercise_serializer.rb` — `attributes :id, :name, :description, :muscle_group, :category, :is_system, :creator_id`
- [x] 2.2 Create `db/seeds/exercises.rb` with ~30 system exercises across all muscle groups; require from `db/seeds.rb`
- [x] 2.3 Run `rails db:seed` — verify 30 exercises created with `is_system: true`
- [x] 2.4 Commit: `feat(api): add ExerciseSerializer and system exercise seed`

## 3. API — Exercise endpoints

- [ ] 3.1 Write `spec/requests/api/v1/exercises_spec.rb` — GET index (all filters), GET show (own + other user's custom → 404, system → 200), POST 201/422, PATCH (owner/non-owner/system), DELETE (owner/non-owner)
- [ ] 3.2 Run spec — verify `FAILED — No route matches`
- [ ] 3.3 Create `app/controllers/api/v1/exercises_controller.rb` — `index` (scope: system + creator), `show`, `create`, `update`, `destroy`; `authorize! @exercise` on each action
- [ ] 3.4 Add `resources :exercises, only: [:index, :show, :create, :update, :destroy]` to routes
- [ ] 3.5 Run exercise request spec — verify all passing
- [ ] 3.6 Commit: `feat(api): add Exercise CRUD endpoints with ActionPolicy`

## 4. API — Routine model + policy

- [ ] 4.1 Write failing model spec `spec/models/routine_spec.rb` (valid, blank name, creator required)
- [ ] 4.2 Generate migration `CreateRoutines` with UUID PK, `name`, `description`, `creator_id` UUID FK → users, `is_template` boolean default false
- [ ] 4.3 Create `app/models/routine.rb` — `belongs_to :creator, class_name: "User"`, `has_many :routine_exercises`, validates `name` presence
- [ ] 4.4 Create `spec/factories/routines.rb` — `association :creator, factory: :user`
- [ ] 4.5 Run `rails db:migrate` and model spec — verify passing
- [ ] 4.6 Create `app/policies/routine_policy.rb` — full CRUD only for creator
- [ ] 4.7 Write policy spec `spec/policies/routine_policy_spec.rb`
- [ ] 4.8 Commit: `feat(api): add Routine model and RoutinePolicy`

## 5. API — RoutineExercise + RoutineSet models

- [ ] 5.1 Write failing model specs for `RoutineExercise` and `RoutineSet`
- [ ] 5.2 Generate migration `CreateRoutineExercises` — UUID PK, `routine_id`, `exercise_id`, `position` integer, `notes` text
- [ ] 5.3 Generate migration `CreateRoutineSets` — UUID PK, `routine_exercise_id`, `set_number`, `weight` decimal, `reps` integer, `rest_seconds` integer, `set_type` string
- [ ] 5.4 Create `app/models/routine_exercise.rb` — `belongs_to :routine`, `belongs_to :exercise`, `has_many :routine_sets`, validates `position` presence
- [ ] 5.5 Create `app/models/routine_set.rb` — `belongs_to :routine_exercise`, `enum :set_type`, validates `set_number`, `set_type` presence
- [ ] 5.6 Create factories for both models; run `db:migrate` and model specs
- [ ] 5.7 Commit: `feat(api): add RoutineExercise and RoutineSet models`

## 6. API — Routine serializer + endpoints

- [ ] 6.1 Create `app/serializers/routine_serializer.rb` — includes nested `routine_exercises` (with nested `routine_sets`)
- [ ] 6.2 Create `app/serializers/routine_exercise_serializer.rb` and `routine_set_serializer.rb`
- [ ] 6.3 Write `spec/requests/api/v1/routines_spec.rb` — list (own only), show (own detail + foreign → 403), create (201/422), update (owner/non-owner), delete (owner)
- [ ] 6.4 Write `spec/requests/api/v1/routine_exercises_spec.rb` — POST (valid/invalid exercise), PATCH, DELETE
- [ ] 6.5 Write `spec/requests/api/v1/routine_sets_spec.rb` — POST (valid/invalid set_type), PATCH, DELETE
- [ ] 6.6 Run all three specs — verify failures
- [ ] 6.7 Create `app/controllers/api/v1/routines_controller.rb` — full CRUD with `authorize!`
- [ ] 6.8 Create `app/controllers/api/v1/routine_exercises_controller.rb` — POST, PATCH, DELETE; authorizes on parent routine
- [ ] 6.9 Create `app/controllers/api/v1/routine_sets_controller.rb` — POST, PATCH, DELETE
- [ ] 6.10 Add nested routes: `resources :routines { resources :exercises (as: routine_exercises) { resources :sets (as: routine_sets) } }`
- [ ] 6.11 Run all three request specs — verify all passing
- [ ] 6.12 Run full suite `bundle exec rspec` — verify 0 failures
- [ ] 6.13 Commit: `feat(api): add Routine CRUD with nested exercises and sets`

## 7. API — Workout model + policy

- [ ] 7.1 Write failing model spec `spec/models/workout_spec.rb`
- [ ] 7.2 Generate migration `CreateWorkouts` — UUID PK, `user_id`, `routine_id` nullable, `gym_id` nullable, `started_at`, `finished_at` nullable, `notes`, `trainer_notes`
- [ ] 7.3 Create `app/models/workout.rb` — `belongs_to :user`, `belongs_to :routine, optional: true`, `has_many :workout_exercises`, `scope :finished`
- [ ] 7.4 Create factory; run `db:migrate` and model spec
- [ ] 7.5 Create `app/policies/workout_policy.rb` — full CRUD for owner; `finish?` for owner
- [ ] 7.6 Write policy spec
- [ ] 7.7 Commit: `feat(api): add Workout model and WorkoutPolicy`

## 8. API — WorkoutExercise + WorkoutSet models

- [ ] 8.1 Write failing model specs for `WorkoutExercise` and `WorkoutSet`
- [ ] 8.2 Generate migration `CreateWorkoutExercises` — UUID PK, `workout_id`, `exercise_id`, `routine_exercise_id` nullable, `position`, `notes`
- [ ] 8.3 Generate migration `CreateWorkoutSets` — UUID PK, `workout_exercise_id`, `set_number`, `weight` decimal, `reps`, `rpe` decimal, `completed` boolean default false, `notes`
- [ ] 8.4 Create `app/models/workout_exercise.rb` and `app/models/workout_set.rb` with associations and validations (`rpe` between 1 and 10)
- [ ] 8.5 Create factories; run `db:migrate` and model specs
- [ ] 8.6 Commit: `feat(api): add WorkoutExercise and WorkoutSet models`

## 9. API — Workout endpoints

- [ ] 9.1 Create serializers: `WorkoutSerializer` (nested exercises + sets), `WorkoutExerciseSerializer`, `WorkoutSetSerializer`
- [ ] 9.2 Write `spec/requests/api/v1/workouts_spec.rb` — POST free/from-routine/foreign-routine, GET list (filters), GET show, PATCH, DELETE, POST finish (in-progress, already finished, foreign → 403)
- [ ] 9.3 Write `spec/requests/api/v1/workout_exercises_spec.rb` and `spec/requests/api/v1/workout_sets_spec.rb`
- [ ] 9.4 Run specs — verify failures
- [ ] 9.5 Create `app/controllers/api/v1/workouts_controller.rb` — CRUD + `finish` action; pre-population from routine in a transaction
- [ ] 9.6 Create `app/controllers/api/v1/workout_exercises_controller.rb` and `workout_sets_controller.rb`
- [ ] 9.7 Add routes: `resources :workouts { post :finish; resources :exercises (as: workout_exercises) { resources :sets (as: workout_sets) } }`
- [ ] 9.8 Run all workout specs — verify passing
- [ ] 9.9 Run full suite `bundle exec rspec` — verify 0 failures
- [ ] 9.10 Commit: `feat(api): add Workout CRUD with finish action and nested exercises/sets`

## 10. Flutter — Drift schema extension

- [ ] 10.1 Add `uuid` package to `pubspec.yaml`
- [ ] 10.2 Create `ExercisesTable`, `RoutinesTable`, `RoutineExercisesTable`, `RoutineSetsTable` in `lib/core/storage/app_database.dart`
- [ ] 10.3 Create `WorkoutsTable`, `WorkoutExercisesTable`, `WorkoutSetsTable` in the same file
- [ ] 10.4 Add `SyncOperationsTable` (id, entity_type, entity_id, operation enum create/update/delete, payload JSON, created_at, synced_at nullable)
- [ ] 10.5 Bump Drift schema version and write migration
- [ ] 10.6 Run `flutter pub run build_runner build` — verify generated code compiles
- [ ] 10.7 Run `flutter analyze lib/` — verify `No issues found!`
- [ ] 10.8 Commit: `feat(app): extend Drift schema with 7 training tables and SyncOperationsTable`

## 11. Flutter — Exercise feature (data layer)

- [ ] 11.1 Create `lib/features/exercise/domain/entities/exercise.dart` — plain Dart class, `fromJson`/`toJson`/`copyWith`
- [ ] 11.2 Create `lib/features/exercise/data/local/exercise_local_data_source.dart` — `watchAll`, `upsert`, `deleteById`, `findById`
- [ ] 11.3 Create `lib/features/exercise/data/remote/exercise_remote_data_source.dart` — `getAll`, `create`, `update`, `delete`
- [ ] 11.4 Write failing test `test/features/exercise/data/repositories/exercise_repository_test.dart` — list returns Drift stream, create writes to Drift first then enqueues sync, delete enqueues sync
- [ ] 11.5 Create `lib/features/exercise/data/repositories/exercise_repository.dart`
- [ ] 11.6 Run test — verify all passing
- [ ] 11.7 Commit: `feat(app): add Exercise data layer with offline-first repository`

## 12. Flutter — Routine feature (data layer)

- [ ] 12.1 Create entities: `lib/features/routine/domain/entities/routine.dart`, `routine_exercise.dart`, `routine_set.dart`
- [ ] 12.2 Create local data sources for Routine, RoutineExercise, RoutineSet
- [ ] 12.3 Create remote data sources for Routine and nested resources
- [ ] 12.4 Write failing tests for `RoutineRepository` — same offline-first contract as ExerciseRepository
- [ ] 12.5 Create `lib/features/routine/data/repositories/routine_repository.dart`
- [ ] 12.6 Run tests — verify all passing
- [ ] 12.7 Commit: `feat(app): add Routine data layer with offline-first repository`

## 13. Flutter — Workout feature (data layer)

- [ ] 13.1 Create entities: `workout.dart`, `workout_exercise.dart`, `workout_set.dart`
- [ ] 13.2 Create local and remote data sources for all three entities
- [ ] 13.3 Write failing tests for `WorkoutRepository` — offline-first, active workout sets use fire-and-forget API path
- [ ] 13.4 Create `lib/features/workout/data/repositories/workout_repository.dart`
- [ ] 13.5 Run tests — verify all passing
- [ ] 13.6 Commit: `feat(app): add Workout data layer with offline-first repository`

## 14. Flutter — SyncService

- [ ] 14.1 Write failing test `test/core/sync/sync_service_test.dart` — drains queue, marks ops synced, retries on failure
- [ ] 14.2 Create `lib/core/sync/sync_service.dart` — singleton; `start()` subscribes to connectivity; `_processQueue()` iterates `SyncOperationsTable` where `synced_at IS NULL`; dispatches to correct remote data source by `entity_type`
- [ ] 14.3 Run test — verify all passing
- [ ] 14.4 Register `SyncService` in `service_locator.dart`; call `syncService.start()` in `AuthAuthenticated` state listener in `main.dart`
- [ ] 14.5 Run `flutter analyze lib/` — verify `No issues found!`
- [ ] 14.6 Commit: `feat(app): add SyncService for offline-first background sync`

## 15. Flutter — Exercise ViewModels + screens

- [ ] 15.1 Write `ExerciseViewModel` tests — `loadExercises` (with filters), `createExercise`, `deleteExercise` states
- [ ] 15.2 Create `lib/features/exercise/presentation/viewmodels/exercise_view_model.dart` (Cubit)
- [ ] 15.3 Run tests — verify all passing
- [ ] 15.4 Create `lib/features/exercise/presentation/screens/exercise_library_screen.dart` — search bar, filter chips (muscle_group, category), list from Drift stream
- [ ] 15.5 Create `lib/features/exercise/presentation/screens/exercise_detail_screen.dart` — name, category, muscle_group, description; edit FAB (owner only)
- [ ] 15.6 Create `lib/features/exercise/presentation/screens/exercise_form_screen.dart` — name, muscle_group dropdown, category dropdown, description; create/update on submit
- [ ] 15.7 Commit: `feat(app): add exercise screens (library, detail, form)`

## 16. Flutter — Routine ViewModels + screens

- [ ] 16.1 Write `RoutineViewModel` tests — `loadRoutines`, `createRoutine`, `addExercise`, `addSet`, `deleteRoutine`
- [ ] 16.2 Create `lib/features/routine/presentation/viewmodels/routine_view_model.dart`
- [ ] 16.3 Run tests — verify all passing
- [ ] 16.4 Create `lib/features/routine/presentation/screens/routines_list_screen.dart` — list from Drift, FAB to create
- [ ] 16.5 Create `lib/features/routine/presentation/screens/routine_detail_screen.dart` — exercises ordered by position, each with sets; edit/delete actions
- [ ] 16.6 Create `lib/features/routine/presentation/screens/routine_form_screen.dart` — name, description, add exercise button → ExercisePickerScreen
- [ ] 16.7 Create `lib/features/routine/presentation/screens/exercise_picker_screen.dart` — delegates to ExerciseLibraryScreen with a "select" mode flag
- [ ] 16.8 Commit: `feat(app): add routine screens (list, detail, form, exercise picker)`

## 17. Flutter — Active Workout ViewModels

- [ ] 17.1 Write `ActiveWorkoutViewModel` tests — `startWorkout`, `addExercise`, `logSet`, `updateSet`, `finishWorkout`, `restTimerState`
- [ ] 17.2 Create `lib/features/workout/presentation/viewmodels/active_workout_view_model.dart` — `currentRestSeconds` tracked in state
- [ ] 17.3 Write `WorkoutHistoryViewModel` tests — `loadHistory` (pagination), `deleteWorkout`
- [ ] 17.4 Create `lib/features/workout/presentation/viewmodels/workout_history_view_model.dart`
- [ ] 17.5 Run all workout VM tests — verify all passing
- [ ] 17.6 Commit: `feat(app): add ActiveWorkoutViewModel and WorkoutHistoryViewModel`

## 18. Flutter — Workout screens

- [ ] 18.1 Create `lib/features/workout/presentation/screens/start_workout_screen.dart` — list routines (or "start free"), button triggers `startWorkout(routineId?)`
- [ ] 18.2 Create `lib/features/workout/presentation/screens/active_workout_screen.dart` — fullscreen modal; exercise list with sets; FAB to add exercise; "Finish" button with confirmation
- [ ] 18.3 Create `lib/features/workout/presentation/widgets/exercise_set_logger_sheet.dart` — bottom sheet: weight, reps, rpe inputs; "Done" saves set via ViewModel
- [ ] 18.4 Create `lib/features/workout/presentation/widgets/rest_timer_overlay.dart` — `StatefulWidget`; countdown from `currentRestSeconds`; skip button
- [ ] 18.5 Create `lib/features/workout/presentation/widgets/add_exercise_sheet.dart` — search exercises, add to active workout via ViewModel
- [ ] 18.6 Create `lib/features/workout/presentation/screens/workout_summary_screen.dart` — total sets, volume, duration; "Share" button (navigates to future CreatePostScreen, disabled for now)
- [ ] 18.7 Create `lib/features/workout/presentation/screens/workout_history_screen.dart` — list from Drift stream, ordered by started_at DESC
- [ ] 18.8 Create `lib/features/workout/presentation/screens/workout_detail_screen.dart` — workout header + exercises with logged sets
- [ ] 18.9 Commit: `feat(app): add workout screens (start, active, summary, history, detail)`

## 19. Flutter — Routing + DI wiring

- [ ] 19.1 Add routes to `lib/app_router.dart`: `/exercises`, `/exercises/:id`, `/exercises/new`, `/exercises/:id/edit`, `/routines`, `/routines/:id`, `/routines/new`, `/workouts`, `/workouts/new` (StartWorkout), `/workouts/:id/active` (modal), `/workouts/:id/summary`, `/workouts/:id`
- [ ] 19.2 Update `lib/core/di/service_locator.dart` — register all Exercise/Routine/Workout LocalDataSource, RemoteDataSource, Repository, ViewModel; register `SyncService`
- [ ] 19.3 Run `flutter analyze lib/` — verify `No issues found!`
- [ ] 19.4 Run full Flutter test suite `flutter test` — verify all passing
- [ ] 19.5 Commit: `feat(app): wire training feature routes and DI for Phase 2`
