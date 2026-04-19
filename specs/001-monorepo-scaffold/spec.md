# Feature Specification: Monorepo Foundation Scaffold

**Feature Branch**: `001-monorepo-scaffold`
**Created**: 2026-04-19
**Status**: Draft

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Developer Boots Both Apps from a Fresh Clone (Priority: P1)

A developer joins the project, clones the repository, follows the documented
setup steps, and has both the Rails API and the Flutter app running locally
within minutes — with no ambiguity about commands or dependencies.

**Why this priority**: Without a reproducible local setup, no subsequent
development is possible. This is the entry point for every future contributor.

**Independent Test**: A developer with the required tools installed (PostgreSQL,
Ruby, Flutter SDK) can follow CLAUDE.md and reach a running Rails server at
`localhost:3000` and a launched Flutter app on a simulator, without
consulting any source other than the documented steps.

**Acceptance Scenarios**:

1. **Given** a fresh clone of the repo, **When** the developer runs the setup
   commands in `apps/sheipe_api/`, **Then** the Rails server starts without
   errors and responds to `GET /` with a 200 or 404 (not a 500 or boot crash)
2. **Given** a fresh clone of the repo, **When** the developer runs the setup
   commands in `apps/sheipe_app/`, **Then** the Flutter app launches on a
   simulator without compilation errors and displays a placeholder screen
3. **Given** both apps running, **When** the Flutter app makes an HTTP request
   to the Rails API, **Then** CORS headers allow the request to complete
   without a browser-side block (for future web testing)

---

### User Story 2 — API Returns Consistent Error Responses (Priority: P2)

Every error returned by the API — validation failures, not-found resources,
unauthorised access, or unexpected crashes — follows the same JSON shape,
so client developers can write a single error-handling layer.

**Why this priority**: Inconsistent error shapes force client code to handle
multiple formats. Getting this right in the foundation avoids rework across
every future endpoint.

**Independent Test**: Triggering a 404 (unknown route), a 422 (invalid payload),
and an unhandled exception all return JSON with the same top-level structure.

**Acceptance Scenarios**:

1. **Given** a request to an undefined route, **When** the API responds,
   **Then** the body is `{ "error": { "code": "...", "message": "...", "details": ... } }`
   and the status is 404
2. **Given** a future endpoint that raises an unhandled exception in production,
   **When** the API responds, **Then** the body follows the same error shape
   with status 500 and no stack trace exposed
3. **Given** a future endpoint that fails validation, **When** the API responds,
   **Then** the `details` field contains field-level error messages and the
   status is 422

---

### User Story 3 — Flutter App Enforces Authenticated Navigation (Priority: P3)

The Flutter app's navigation shell distinguishes between authenticated and
unauthenticated states and redirects users appropriately, so every future
screen can assume auth state is already resolved.

**Why this priority**: A navigation shell that ignores auth state will require
every screen to independently check auth — inconsistent and fragile. Solving
this once in the foundation is the correct order.

**Independent Test**: With no token stored, launching the app lands on the
auth placeholder. With a dummy token stored, launching the app lands on the
main app placeholder. No screen flicker or redirect loop occurs.

**Acceptance Scenarios**:

1. **Given** no auth token is stored on the device, **When** the app launches,
   **Then** the router redirects to the auth placeholder screen
2. **Given** a valid auth token is stored on the device, **When** the app
   launches, **Then** the router shows the main app shell (tab bar placeholder)
3. **Given** a user is on a protected route and the token is cleared,
   **When** the auth state changes, **Then** the router immediately redirects
   to the auth screen without requiring a restart

---

### User Story 4 — Offline Data Layer Is Ready for Future Tables (Priority: P4)

The local database is initialised and wired into the app's dependency graph,
so future features can add Drift tables without modifying infrastructure code.

**Why this priority**: Setting up the data layer after features already exist
requires retrofitting, which is more disruptive than getting it right upfront.

**Independent Test**: The app boots without database errors even with zero
tables defined. Adding a table in a future PR requires only a new Drift
table class and a migration — no changes to the database bootstrap code.

**Acceptance Scenarios**:

1. **Given** the app launches, **When** the Drift database initialises,
   **Then** no errors are thrown and the database file is created on the device
2. **Given** the database is initialised, **When** a future table is added,
   **Then** the migration runs automatically on the next app launch without
   manual intervention

---

### Edge Cases

- What happens when PostgreSQL is not running when the Rails server boots?
  The server must fail fast with a clear error, not a cryptic stack trace.
- What happens when the Flutter app is built on a machine missing a required
  dependency? The build must fail with an actionable error message.
- What happens if the stored auth token is malformed (not a valid string)?
  The router must treat it as unauthenticated and redirect to auth.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Rails API MUST start and serve requests at `localhost:3000`
  after running the documented setup commands
- **FR-002**: All API error responses MUST conform to the shape
  `{ "error": { "code": string, "message": string, "details": object|null } }`
- **FR-003**: The API MUST include CORS headers that permit requests from
  localhost origins used during development
- **FR-004**: The Flutter app MUST launch without runtime errors on iOS and
  Android simulators after running the documented setup commands
- **FR-005**: The Flutter app MUST redirect unauthenticated users to the auth
  screen and authenticated users to the main shell, resolving on every cold start
- **FR-006**: The Flutter app's HTTP client MUST attach a Bearer token header
  on every outbound request when a token is present in secure storage
- **FR-007**: The offline database MUST initialise on app launch and be
  accessible via dependency injection — with zero tables defined at this stage
- **FR-008**: The Repository abstraction MUST define a `LocalDataSource` and
  `RemoteDataSource` contract that future features implement — no concrete
  implementations are required in this phase
- **FR-009**: All future Rails models MUST use UUID primary keys — the database
  extension enabling this MUST be activated in the initial migration

### Key Entities

- **AppRouter**: Navigation graph; distinguishes authenticated vs unauthenticated
  states; single source of truth for all route names
- **ApiClient**: HTTP client wrapper; injects Bearer token; handles
  de-serialisation of the standard error shape
- **AppDatabase**: Drift database singleton; zero tables; manages migrations
- **Repository contract**: Abstract interfaces `LocalDataSource` and
  `RemoteDataSource` with no concrete implementations

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A developer with prerequisites installed can have both apps
  running locally in under 10 minutes following CLAUDE.md
- **SC-002**: 100% of API error responses across all HTTP status classes
  (4xx, 5xx) return the documented error JSON shape — zero inconsistent formats
- **SC-003**: Auth redirect resolves on cold start in under 300ms on a
  mid-range simulator — no visible flicker between screens
- **SC-004**: Test suite passes with ≥ 95% coverage on all scaffold code
  (base controller, router, API client, database bootstrap)
- **SC-005**: Adding a new Drift table in a future PR requires changes to
  exactly one file (the new table class) plus the database version bump —
  no changes to bootstrap or DI wiring

## Assumptions

- Developer machines have PostgreSQL, Ruby ≥ 3.3, Flutter ≥ 3.x, and
  Dart SDK installed prior to setup
- No authentication logic is implemented in this phase; the auth guard uses
  the presence/absence of a token string as a proxy for auth state
- The Flutter app targets iOS 14+ and Android API 24+ (Flutter stable defaults)
- No UI design system colours or typography are finalised at this stage;
  `AppTheme`, `AppColors`, and `AppTextStyles` expose placeholder values
  that will be overridden in a future design-system feature
- CORS is configured for local development only; production CORS policy is
  out of scope for this phase
