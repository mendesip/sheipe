## 1. API — RoutinePlan model + policy

- [ ] 1.1 Write failing model spec `spec/models/routine_plan_spec.rb` (valid, blank name, missing start_date, end_date < start_date, athlete required, creator required)
- [ ] 1.2 Generate migration `CreateRoutinePlans` with UUID PK, `name`, `athlete_id` UUID FK → users, `creator_id` UUID FK → users, `start_date` date NOT NULL, `end_date` date nullable, `notes` text, indexes on `athlete_id` and `(athlete_id, start_date DESC)`
- [ ] 1.3 Create `app/models/routine_plan.rb` — `belongs_to :athlete, class_name: "User"`, `belongs_to :creator, class_name: "User"`, `has_many :routine_plan_days, dependent: :destroy`, validates `name`/`start_date` presence, custom validation `end_date_after_start_date`
- [ ] 1.4 Create `spec/factories/routine_plans.rb` — `association :athlete, factory: :user`, `creator { athlete }` so the default factory has athlete == creator (Phase 3 contract)
- [ ] 1.5 Run `rails db:migrate` (dev + test) and model spec — verify passing
- [ ] 1.6 Create `app/policies/routine_plan_policy.rb` — `index?`/`create?` for any authenticated user; `show?`/`update?`/`destroy?` only when `record.creator_id == user.id`; `relation_scope` filters `WHERE athlete_id = user.id`
- [ ] 1.7 Write `spec/policies/routine_plan_policy_spec.rb` — owner allowed, non-owner denied, scope filters correctly
- [ ] 1.8 Add `has_many :routine_plans, foreign_key: :athlete_id, dependent: :destroy` to `User`
- [ ] 1.9 Commit: `feat(api): add RoutinePlan model and RoutinePlanPolicy`

## 2. API — RoutinePlanDay model

- [ ] 2.1 Write failing model spec `spec/models/routine_plan_day_spec.rb` — valid, missing routine, missing routine_plan, day_of_week out of range (negative, 7), uniqueness on (routine_plan_id, week_number, day_of_week)
- [ ] 2.2 Generate migration `CreateRoutinePlanDays` — UUID PK, `routine_plan_id` UUID FK NOT NULL, `routine_id` UUID FK NOT NULL, `day_of_week` integer NOT NULL, `week_number` integer nullable; add unique index `(routine_plan_id, week_number, day_of_week) NULLS NOT DISTINCT`; cascade delete on routine_plan FK
- [ ] 2.3 Create `app/models/routine_plan_day.rb` — `belongs_to :routine_plan`, `belongs_to :routine`, validates `day_of_week` inclusion 0..6, validates `day_of_week` uniqueness scoped to `[:routine_plan_id, :week_number]`
- [ ] 2.4 Create `spec/factories/routine_plan_days.rb`
- [ ] 2.5 Run `db:migrate` and model spec
- [ ] 2.6 Commit: `feat(api): add RoutinePlanDay model with uniqueness on (week_number, day_of_week)`

## 3. API — Serializers + endpoints

- [ ] 3.1 Create `app/serializers/routine_plan_day_serializer.rb` — `attributes :id, :routine_plan_id, :routine_id, :day_of_week, :week_number, :created_at, :updated_at`
- [ ] 3.2 Create `app/serializers/routine_plan_serializer.rb` — attributes (`id, name, athlete_id, creator_id, start_date, end_date, notes, created_at, updated_at`) + `many :days, resource: RoutinePlanDaySerializer, source: ->(_p) { routine_plan_days.order(Arel.sql("week_number NULLS FIRST"), :day_of_week) }`
- [ ] 3.3 Write `spec/requests/api/v1/routine_plans_spec.rb` — list (own only), show (own with days, foreign → 403), create (201/422 for blank name, missing start_date, end_date<start_date), update (owner/non-owner), delete (owner)
- [ ] 3.4 Write `spec/requests/api/v1/routine_plan_days_spec.rb` — POST (valid, with week_number, foreign routine → 422, duplicate (week_number, day_of_week) → 422, day_of_week=7 → 422), PATCH, DELETE
- [ ] 3.5 Run both specs — verify failures
- [ ] 3.6 Create `app/controllers/api/v1/routine_plans_controller.rb` — full CRUD with `authorize!`; `create` sets `athlete_id` and `creator_id` to `Current.user.id`
- [ ] 3.7 Create `app/controllers/api/v1/routine_plan_days_controller.rb` — POST/PATCH/DELETE; authorize on parent plan; reject `routine_id` not visible to user (return 422 RecordInvalid)
- [ ] 3.8 Add nested routes: `resources :routine_plans { resources :days, controller: "routine_plan_days", as: :routine_plan_days, only: [:create, :update, :destroy] }`
- [ ] 3.9 Run both request specs — verify passing
- [ ] 3.10 Run full suite `bundle exec rspec` — verify 0 failures
- [ ] 3.11 Commit: `feat(api): add RoutinePlan CRUD with nested days`

## 4. Flutter — Drift schema extension

- [ ] 4.1 Add `RoutinePlansTable` to `lib/core/storage/app_database.dart` (id text PK, name, athleteId, creatorId, startDate, endDate nullable, notes nullable, createdAt/updatedAt nullable)
- [ ] 4.2 Add `RoutinePlanDaysTable` (id text PK, routinePlanId references RoutinePlans cascade, routineId, dayOfWeek int, weekNumber int nullable, createdAt/updatedAt nullable)
- [ ] 4.3 Bump `schemaVersion` 2 → 3; extend `onUpgrade` to `createAll()` for the two new tables when `from < 3`
- [ ] 4.4 Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] 4.5 Add a database test that inserts a plan + 2 days and reads them back
- [ ] 4.6 Run `flutter analyze lib/` — verify clean
- [ ] 4.7 Commit: `feat(app): extend Drift schema with RoutinePlansTable and RoutinePlanDaysTable`

## 5. Flutter — RoutinePlan feature data layer

- [ ] 5.1 Create entities: `lib/features/routine_plan/domain/entities/routine_plan.dart` and `routine_plan_day.dart` with `fromJson` / `toJson` / `copyWith`. `RoutinePlan` carries a `List<RoutinePlanDay> days`
- [ ] 5.2 Create `lib/features/routine_plan/data/local/routine_plan_local_data_source.dart` — `watchAll`, `watchById`, `findById`, `upsert` (transaction: replace days), `upsertAll`, `deleteById`
- [ ] 5.3 Create `lib/features/routine_plan/data/remote/routine_plan_remote_data_source.dart` — `getAll`, `getById`, `create`, `update`, `delete`, `addDay`, `updateDay`, `removeDay`
- [ ] 5.4 Write failing test `test/features/routine_plan/data/repositories/routine_plan_repository_test.dart` — watchAll emits Drift contents, create writes to Drift then enqueues sync, delete enqueues delete op, addDay enqueues a `routine_plan_day` create
- [ ] 5.5 Create `lib/features/routine_plan/data/repositories/routine_plan_repository.dart` — same offline-first pattern as `RoutineRepository`; `addDay` / `removeDay` produce per-day sync ops with `entity_type: "routine_plan_day"`
- [ ] 5.6 Run repository test — verify all passing
- [ ] 5.7 Commit: `feat(app): add RoutinePlan data layer with offline-first repository`

## 6. Flutter — SyncService extension

- [ ] 6.1 Add a failing case to `test/core/sync/sync_service_test.dart` — drains a `routine_plan` create op (calls `RoutinePlanRemoteDataSource.create`)
- [ ] 6.2 Add a failing case for `routine_plan_day` create (calls `addDay`)
- [ ] 6.3 Extend `SyncService` constructor to accept a `RoutinePlanRemoteDataSource`; add `_dispatchRoutinePlan` and `_dispatchRoutinePlanDay` methods following the existing pattern
- [ ] 6.4 Run sync service test — verify all passing
- [ ] 6.5 Commit: `feat(app): teach SyncService to dispatch routine_plan and routine_plan_day ops`

## 7. Flutter — RoutinePlanViewModel + tests

- [ ] 7.1 Create `lib/features/routine_plan/presentation/viewmodels/routine_plan_state.dart` (`Initial`, `Loading`, `Loaded(items)`, `Error(message)`)
- [ ] 7.2 Write `test/features/routine_plan/presentation/viewmodels/routine_plan_view_model_test.dart` — `loadPlans` emits Loading then Loaded; `createPlan` delegates to repo; `addDay` appends a day to the in-memory plan and calls update; `removeDay`; `deletePlan`
- [ ] 7.3 Create `lib/features/routine_plan/presentation/viewmodels/routine_plan_view_model.dart` (Cubit) implementing the methods above; `addDay` produces a stamped UUID for the new `RoutinePlanDay`
- [ ] 7.4 Run view-model tests — verify all passing
- [ ] 7.5 Commit: `feat(app): add RoutinePlanViewModel with offline-first plan editing`

## 8. Flutter — RoutinePlan screens + RoutinePicker

- [ ] 8.1 Create `lib/features/routine_plan/presentation/screens/routine_plans_list_screen.dart` — list from Drift stream, ordered by start_date DESC; FAB to `/routine_plans/new`; tap → `/routine_plans/:id`
- [ ] 8.2 Create `lib/features/routine_plan/presentation/widgets/routine_picker_sheet.dart` — bottom sheet that subscribes to `RoutineViewModel` and pops with the picked `Routine`
- [ ] 8.3 Create `lib/features/routine_plan/presentation/screens/routine_plan_detail_screen.dart` — group `days` by `week_number` (null treated as "single-week"); render each week as a 7-cell row (Sun → Sat); empty cell opens `RoutinePickerSheet` and on result calls `viewModel.addDay`; cell with a routine shows routine name + tap-to-remove
- [ ] 8.4 Create `lib/features/routine_plan/presentation/screens/routine_plan_form_screen.dart` — name, start_date (date picker), end_date (optional), notes; submit → `viewModel.createPlan`
- [ ] 8.5 Run `flutter analyze lib/` — verify clean
- [ ] 8.6 Commit: `feat(app): add routine plan screens (list, detail grid, form, routine picker)`

## 9. Flutter — Routing + DI wiring

- [ ] 9.1 Register `RoutinePlanLocalDataSource`, `RoutinePlanRemoteDataSource`, `RoutinePlanRepository`, `RoutinePlanViewModel` in `lib/core/di/service_locator.dart`
- [ ] 9.2 Pass `RoutinePlanRemoteDataSource` to `SyncService` in DI
- [ ] 9.3 Add routes to `lib/app_router.dart`: `/routine_plans`, `/routine_plans/new`, `/routine_plans/:id` (each scoped under the right BlocProviders; detail screen also needs `RoutineViewModel` available for the picker)
- [ ] 9.4 Add a "Plans" entry to the existing navigation surface (smallest change: a tile inside `_HomePlaceholder` or a tab on profile — choose at implementation time)
- [ ] 9.5 Run `flutter analyze lib/` — verify clean
- [ ] 9.6 Run full Flutter test suite `flutter test` — verify all passing
- [ ] 9.7 Commit: `feat(app): wire routine plan routes and DI for Phase 3`
