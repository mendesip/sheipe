---
description: "Task list for Monorepo Foundation Scaffold"
---

# Tasks: Monorepo Foundation Scaffold

**Input**: Design documents from `specs/001-monorepo-scaffold/`
**Prerequisites**: plan.md ✅ spec.md ✅ research.md ✅ data-model.md ✅ contracts/ ✅

**Tests**: MANDATORY per constitution (TDD, ≥ 95% coverage). Tests MUST be written before implementation — failing tests first, then implement.

**Organization**: Tasks grouped by user story for independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US4)

---

## Phase 1: Setup

**Purpose**: Scaffold both apps from scratch.

- [x] T001 Create `apps/` directory in repo root
- [x] T002 [P] Run `rails new sheipe_api --api --database=postgresql` inside `apps/`
- [x] T003 [P] Run `flutter create --org br.com.sheipe sheipe_app` inside `apps/`

---

## Phase 2: Foundational ⚠️ BLOCKS all user stories

**Purpose**: Wire dependencies, database extension, and core architecture before any user story work begins.

### Rails

- [x] T004 Replace `apps/sheipe_api/Gemfile` gems: add `rack-cors`, `pagy`, `alba`, `action_policy`, `ar_lazy_preload`, `rack-attack`; add `rswag-rails` to dev; add `rswag-specs`, `rspec-rails` to dev/test; remove unused default gems
- [x] T005 Run `bundle install` in `apps/sheipe_api/`
- [x] T006 Run `rails generate rspec:install` to set up RSpec in `apps/sheipe_api/`
- [x] T007 Run `rails g rswag:install` to initialise rswag in `apps/sheipe_api/`
- [x] T008 Generate migration `enable_pgcrypto` in `apps/sheipe_api/db/migrate/` — `enable_extension 'pgcrypto'`
- [x] T009 Run `rails db:create db:migrate` in `apps/sheipe_api/`
- [x] T010 Add `namespace :api do; namespace :v1 do; end; end` skeleton to `apps/sheipe_api/config/routes.rb`

### Flutter

- [x] T011 Add dependencies to `apps/sheipe_app/pubspec.yaml`: `flutter_bloc`, `go_router`, `dio`, `drift`, `sqlite3_flutter_libs`, `flutter_secure_storage`, `get_it`, `path`, `path_provider`; add dev deps: `build_runner`, `drift_dev`, `bloc_test`, `mocktail`
- [x] T012 Run `flutter pub get` in `apps/sheipe_app/`
- [x] T013 Create folder skeleton: `apps/sheipe_app/lib/core/di/`, `core/network/interceptors/`, `core/storage/`, `core/repository/`, `features/`, `shared/theme/`, `shared/widgets/`
- [x] T014 [P] Implement `AppColors` with placeholder values in `apps/sheipe_app/lib/shared/theme/app_colors.dart`
- [x] T015 [P] Implement `AppTextStyles` with placeholder values in `apps/sheipe_app/lib/shared/theme/app_text_styles.dart`
- [x] T016 [P] Implement `AppTheme` wiring `AppColors` and `AppTextStyles` in `apps/sheipe_app/lib/shared/theme/app_theme.dart`
- [x] T017 Implement `AppDatabase` (`@DriftDatabase(tables: [])`, schema version 1, `LazyDatabase` on device path) in `apps/sheipe_app/lib/core/storage/app_database.dart`
- [x] T018 Run `flutter pub run build_runner build` to generate `app_database.g.dart`
- [x] T019 Implement `ServiceLocator` (`GetIt`) with `AppDatabase` registered as `lazySingleton` (with `dispose`) in `apps/sheipe_app/lib/core/di/service_locator.dart`

**Checkpoint**: Foundation complete — user story phases can now begin.

---

## Phase 3: User Story 1 — Developer Boots Both Apps (Priority: P1) 🎯 MVP

**Goal**: Developer follows CLAUDE.md and has both apps running locally in ≤ 10 min.

**Independent Test**: A fresh-clone setup produces a running Rails server at `localhost:3000`
and a launched Flutter simulator app — no additional steps needed beyond CLAUDE.md.

### Tests for US1 ⚠️ MANDATORY — Write FIRST, ensure they FAIL before implementing

- [x] T020 [P] [US1] Write RSpec request spec asserting Rails server boots and returns any non-500 response for `GET /` in `apps/sheipe_api/spec/requests/api/v1/health_spec.rb`
- [x] T021 [P] [US1] Write Flutter widget test asserting `MyApp` renders without exceptions in `apps/sheipe_app/test/app_test.dart`

### Implementation for US1

- [x] T022 [P] [US1] Create `ApplicationController < ActionController::API` in `apps/sheipe_api/app/controllers/application_controller.rb`
- [x] T023 [US1] Configure CORS for localhost origins in `apps/sheipe_api/config/initializers/cors.rb` (see `contracts/error-response.md` for dev origins)
- [x] T024 [US1] Implement `main.dart` with `WidgetsFlutterBinding.ensureInitialized()`, `ServiceLocator.init()`, and `runApp(MyApp())` in `apps/sheipe_app/lib/main.dart`
- [x] T025 [US1] Implement `MyApp` widget wiring `AppTheme` and a placeholder `MaterialApp.router` in `apps/sheipe_app/lib/app.dart`

**Checkpoint**: US1 complete — both apps boot and basic test suite passes.

---

## Phase 4: User Story 2 — API Returns Consistent Error Responses (Priority: P2)

**Goal**: All 4xx/5xx responses share the same `{ error: { code, message, details } }` shape.

**Independent Test**: `curl localhost:3000/nonexistent`, a forced 422, and a forced 500
all return the documented error JSON (see `contracts/error-response.md`).

### Tests for US2 ⚠️ MANDATORY — Write FIRST, ensure they FAIL before implementing

- [x] T026 [P] [US2] Write RSpec request spec asserting unknown route returns `{ error: { code: 'not_found', ... } }` with status 404 in `apps/sheipe_api/spec/requests/api/v1/error_shape_spec.rb`
- [x] T027 [P] [US2] Write RSpec request spec asserting unhandled exception returns `{ error: { code: 'internal_error', ... } }` with status 500 and no stack trace in `apps/sheipe_api/spec/requests/api/v1/error_shape_spec.rb`
- [x] T028 [P] [US2] Write RSpec unit spec for `BaseController#render_error` helper covering all 5 error codes in `apps/sheipe_api/spec/requests/api/v1/base_controller_spec.rb`

### Implementation for US2

- [x] T029 [US2] Implement `Api::V1::BaseController < ApplicationController` with `rescue_from` for all 5 exceptions, `render_error` helper, and a `not_found` action in `apps/sheipe_api/app/controllers/api/v1/base_controller.rb` (see `contracts/error-response.md`)
- [x] T030 [US2] Add catch-all route `match '*path', to: 'api/v1/base#not_found', via: :all` in `apps/sheipe_api/config/routes.rb` — route MUST point to `BaseController#not_found` so the response uses `render_error` and conforms to the error shape contract (FR-002)

**Checkpoint**: US2 complete — all error responses conform to contract.

---

## Phase 5: User Story 3 — Flutter Enforces Authenticated Navigation (Priority: P3)

**Goal**: On cold start, unauthenticated users land on auth screen; authenticated users land
on main shell. Auth state changes trigger immediate redirect with no flicker.

**Independent Test**: Manually write/clear token in secure storage and cold-start app —
router resolves to correct screen within 300ms with no redirect loop.

### Tests for US3 ⚠️ MANDATORY — Write FIRST, ensure they FAIL before implementing

- [x] T031 [P] [US3] Write `AuthViewModel` unit tests (no token → unauthenticated, token present → authenticated, token cleared → unauthenticated) in `apps/sheipe_app/test/features/auth/auth_view_model_test.dart`
- [x] T032 [P] [US3] Write `AppRouter` unit tests (unauthenticated state → redirects to `/auth`, authenticated state → redirects to `/`) in `apps/sheipe_app/test/app_router_test.dart`
- [x] T033 [P] [US3] Write `AuthInterceptor` unit test asserting Bearer token header is attached when token is present in `apps/sheipe_app/test/core/network/auth_interceptor_test.dart`
- [x] T033b [US3] Write `AuthInterceptor` unit test asserting a 401 response calls `AuthViewModel.logout()` and clears the stored token in `apps/sheipe_app/test/core/network/auth_interceptor_test.dart`

### Implementation for US3

- [x] T034 [US3] Implement `AuthState` (sealed: `Unauthenticated`, `Authenticated`) and `AuthViewModel` (Cubit reading token from `flutter_secure_storage`) in `apps/sheipe_app/lib/features/auth/presentation/viewmodels/auth_view_model.dart`
- [x] T035 [US3] Implement `AuthInterceptor` (`Interceptor` subclass, reads token, attaches header, on 401 emits logout) in `apps/sheipe_app/lib/core/network/interceptors/auth_interceptor.dart`
- [x] T036 [US3] Implement `ApiClient` wrapping `Dio` with `AuthInterceptor` and base URL config in `apps/sheipe_app/lib/core/network/api_client.dart`
- [x] T037 [US3] Implement `AppRouter` (GoRouter with `redirect` callback + `refreshListenable` bridged to `AuthViewModel` stream) in `apps/sheipe_app/lib/app_router.dart`
- [x] T038 [P] [US3] Implement placeholder `AuthScreen` in `apps/sheipe_app/lib/features/auth/presentation/screens/auth_screen.dart`
- [x] T039 [P] [US3] Implement placeholder `MainShell` (tab bar skeleton) in `apps/sheipe_app/lib/shared/widgets/main_shell.dart`
- [x] T040 [US3] Register `AuthViewModel`, `ApiClient`, `AppRouter` in `apps/sheipe_app/lib/core/di/service_locator.dart`
- [x] T041 [US3] Update `main.dart` to provide `AuthViewModel` via `BlocProvider` and pass `AppRouter` to `MaterialApp.router` in `apps/sheipe_app/lib/main.dart`

**Checkpoint**: US3 complete — navigation correctly enforces auth state.

---

## Phase 6: User Story 4 — Offline Data Layer Ready (Priority: P4)

**Goal**: Drift database initialises on launch with zero tables; future features add tables
without touching bootstrap code.

**Independent Test**: App boots without DB errors; adding a Drift table in a future PR
requires only the new table class + schema version bump — no changes to DI wiring.

### Tests for US4 ⚠️ MANDATORY — Write FIRST, ensure they FAIL before implementing

- [x] T042 [US4] Write Drift integration test asserting `AppDatabase` opens without error and `schemaVersion` is 1 in `apps/sheipe_app/test/core/storage/app_database_test.dart`
- [x] T042b [US4] Write unit tests for repository contracts in `apps/sheipe_app/test/core/repository/repository_contracts_test.dart`: (1) a concrete stub implementing `LocalDataSource<T>` compiles and satisfies all method signatures; (2) a concrete stub implementing `RemoteDataSource<T>` compiles and satisfies all method signatures; (3) a concrete stub implementing `BaseRepository<T>` wires both sources and exposes them via the expected fields

### Implementation for US4

- [x] T043 [US4] Define `abstract class LocalDataSource<T>` with `Future<List<T>> getAll()`, `Future<T?> getById(String id)`, `Future<void> save(T entity)`, `Future<void> delete(String id)` in `apps/sheipe_app/lib/core/repository/local_data_source.dart`
- [x] T044 [US4] Define `abstract class RemoteDataSource<T>` with `Future<List<T>> fetchAll()`, `Future<T> fetchById(String id)`, `Future<T> create(T entity)`, `Future<T> update(T entity)`, `Future<void> delete(String id)` in `apps/sheipe_app/lib/core/repository/remote_data_source.dart`
- [x] T045 [US4] Define `abstract class BaseRepository<T>` composing `LocalDataSource<T>` and `RemoteDataSource<T>` in `apps/sheipe_app/lib/core/repository/base_repository.dart`

**Checkpoint**: US4 complete — offline data layer ready for Phase 1 feature tables.

---

## Phase 7: Polish & Cross-Cutting

**Purpose**: Coverage gate, static analysis, and documentation validation.

- [x] T046 Run `bundle exec rspec --format documentation` in `apps/sheipe_api/` — 10/10 passing
- [x] T047 Run `flutter test --coverage` in `apps/sheipe_app/` — fix any failures; verify coverage ≥ 95% (34/34 passing, 95.2% coverage)
- [x] T048 [P] Run `rubocop` in `apps/sheipe_api/` — fix all offences (0 offenses)
- [x] T049 [P] Run `flutter analyze` in `apps/sheipe_app/` — fix all warnings and errors (0 issues)
- [x] T050 Validate `specs/001-monorepo-scaffold/quickstart.md` steps produce running apps end-to-end

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 ⚠️ **BLOCKS all user stories**
- **US1 (Phase 3)**: Depends on Foundational
- **US2 (Phase 4)**: Depends on Foundational (independent of US1)
- **US3 (Phase 5)**: Depends on Foundational (independent of US1, US2)
- **US4 (Phase 6)**: Depends on Foundational (independent of US1–US3)
- **Polish (Phase 7)**: Depends on all user stories complete

### Within Each User Story

Tests MUST be written and FAIL before implementation begins.
Each story is independently completable and testable after Foundational phase.

### Parallel Opportunities

| Within Phase 1 | T002, T003 |
|---|---|
| Within Phase 2 (Flutter theme) | T014, T015, T016 |
| US1 tests | T020, T021 |
| US2 tests | T026, T027, T028 |
| US3 tests | T031, T032, T033, T033b |
| US3 screens | T038, T039 |
| Polish | T046+T048 (API), T047+T049 (Flutter) |

---

## Implementation Strategy

### MVP (US1 only)

1. Phase 1: Setup
2. Phase 2: Foundational (critical — blocks all stories)
3. Phase 3: US1 — both apps boot
4. **Validate**: Run tests, confirm both apps start
5. Deploy/demo if ready

### Full Increment

Phase 1 → Phase 2 → Phase 3 (US1) → Phase 4 (US2) → Phase 5 (US3) → Phase 6 (US4) → Phase 7 (Polish)

Each phase delivers a testable increment before moving to the next.

---

## Notes

- [P] = different files, no dependencies within the same phase
- Tests MUST fail before implementing (RED → GREEN)
- Commit after each user story phase completion
- Stop at each checkpoint to validate story independently
- `contracts/error-response.md` is the source of truth for error shapes in US2
