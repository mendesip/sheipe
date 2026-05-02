## Context

Phase 0 scaffold is complete. Rails API has `BaseController`, CORS, all gems (Alba, Rack::Attack, ActionPolicy). Flutter has DI (`get_it`), GoRouter with auth guard, Dio with `AuthInterceptor` stub, `flutter_secure_storage`, and Repository abstractions. `AuthViewModel` exists as a stub. What's missing: `User` + `Session` models on the API, all auth endpoints, Flutter auth screens, and full `AuthRepository` + `AuthInterceptor` implementations.

## Goals / Non-Goals

**Goals:**
- Hand-rolled `User` + `Session` models with UUID PKs and `has_secure_password`
- Two-token scheme: `access_token` (opaque UUID, 24h) + `refresh_token` (opaque UUID, 30d)
- `POST /auth/refresh` rotates the `access_token` using a valid `refresh_token`
- `Session` invalidated on logout; multiple sessions per user allowed (one per device)
- Flutter `AuthRepository` connecting `AuthRemoteDataSource` (Dio) → `AuthLocalDataSource` (flutter_secure_storage)
- `AuthInterceptor` rewrite: `QueuedInterceptorsWrapper` — intercepts 401, refreshes token once, retries; on failure pushes `AuthUnauthorized` to `StreamController<AuthEvent>`
- `AuthViewModel` subscribes to `Stream<AuthEvent>` → auto-logout on stream event
- Auth screens: Splash → Onboarding → Login → Register (2-step) + ProfileScreen + EditProfileScreen
- RSpec request specs + FactoryBot for all API endpoints
- Flutter unit tests with `bloc_test` + `mocktail` for `AuthViewModel` and `AuthRepository`

**Non-Goals:**
- `rails generate authentication` generator — rejected (see Decision 1)
- JWT — rejected (see Decision 2)
- Password reset / email verification
- OAuth / social login
- Avatar upload (`avatar_url` column reserved, not editable in Phase 1)
- Account deletion (`DELETE /me`)
- Trainer-athlete relationship (Phase 4)

## Decisions

### 1 — Hand-rolled User + Session models, not `rails generate authentication`

`rails generate authentication` creates a `User` with `has_secure_password` and a `Session` with a single `token`. It does not support two-token schemes (access + refresh) or UUID PKs out of the box — adapting it adds more work than writing from scratch.

**Decision:** Hand-roll `CreateUsers` and `CreateSessions` migrations with:
- UUID PKs (`id: :uuid, default: "gen_random_uuid()"`)
- `users.role` integer enum (`athlete: 0, trainer: 1, admin: 2`), default `athlete`
- `sessions.access_token` (UUID, unique index), `sessions.access_token_expires_at` (+24h)
- `sessions.refresh_token` (UUID, unique index), `sessions.refresh_token_expires_at` (+30d)
- Case-insensitive email uniqueness index: `lower(email)` functional index

**Alternative considered:** `rails generate authentication` — rejected because UUID PKs + two-token scheme require non-trivial migration of generated files.

### 2 — Opaque UUID tokens, not JWT

Opaque tokens stored in `sessions` table are invalidated immediately by deleting the row (logout, forced invalidation). JWTs can't be revoked server-side without a blocklist, adding infrastructure complexity.

**Decision:** `SecureRandom.uuid` stored as `sessions.access_token` and `sessions.refresh_token`. Lookup: `Session.find_by(access_token: bearer)`. Rotation: `session.update!(access_token: SecureRandom.uuid, access_token_expires_at: 24.hours.from_now)`.

### 3 — Two-token scheme: access (24h) + refresh (30d)

Short-lived access token limits exposure window. Long-lived refresh token enables seamless re-auth without password re-entry.

`POST /auth/refresh` accepts `refresh_token`, validates expiry, calls `session.rotate_access_token!`, returns `{ access_token }`. The refresh token itself is not rotated (simplicity — single device, MVP).

### 4 — AuthInterceptor as QueuedInterceptorsWrapper

Concurrent 401 responses (e.g., two parallel API calls with an expired token) must not trigger two simultaneous refresh calls. `QueuedInterceptorsWrapper` serializes error handling — the first 401 triggers a refresh; subsequent 401s queue and retry with the new token.

**Flow:**
1. `onRequest` — reads `access_token` from storage, injects `Authorization: Bearer <token>`
2. `onError` (401) — reads `refresh_token`; if absent → push `AuthUnauthorized` to stream
3. Call `POST /auth/refresh` via a separate `Dio` instance (no interceptor — avoids loop)
4. Success → `saveTokens(newAccess, refresh)` → retry original request with new token
5. Failure → `clearTokens()` → push `AuthUnauthorized` to stream

`AuthInterceptor` never imports `AuthViewModel` — decoupled via `StreamController<AuthEvent>`.

### 5 — User JSON cached in flutter_secure_storage

`checkAuthStatus()` reads `auth_user_json` from storage (written on login/register) rather than calling `GET /me` on every app launch. This avoids a network round-trip for the splash screen and keeps the app functional offline for the auth state check.

**Storage keys:**
- `auth_access_token`
- `auth_refresh_token`
- `auth_user_json` — full `User` serialized as JSON
- `onboarding_seen` — `"true"` once seen

### 6 — Two-step Register UI, single API call

Registration is split into two screens (personal data → role selection) via `PageView` for UX, but submits one `POST /auth/register` call with all data on step 2 submit. No partial submission or draft persistence.

### 7 — RSpec + FactoryBot for API tests

`factory_bot_rails` added to test group. `FactoryBot::Syntax::Methods` included globally in `rails_helper.rb`. `JsonHelper#json_body` helper included for `:request` specs. Follows TDD: write failing spec → implement → verify green.

## Risks / Trade-offs

- **`flutter_secure_storage` on rooted Android devices**: may fail to write — acceptable limitation for MVP; documented.
- **Session not invalidated if API unreachable during logout**: mitigated by Decision 4 (clear tokens locally regardless of API response).
- **Refresh token not rotated**: simplifies implementation but means a stolen refresh token remains valid for 30d. Acceptable for MVP; refresh rotation can be added in a future phase.
- **`access_token` as UUID (not cryptographically random bytes)**: UUIDs generated by `gen_random_uuid()` (PostgreSQL) are version 4 (random) — 122 bits of entropy. Sufficient for opaque tokens in this threat model.

## Migration Plan

1. Add `factory_bot_rails` + RSpec setup; verify `bundle exec rspec` runs with 0 examples
2. Write `CreateUsers` migration + `User` model + factory → run migration
3. Write `CreateSessions` migration + `Session` model + `Current` + factory → run migration
4. Rewrite `BaseController` with `authenticate` before-action + error handlers
5. Create `UserSerializer` + `PublicUserSerializer` (Alba)
6. Create `RegistrationsController` + `SessionsController` (login) with request specs
7. Create `RefreshesController` + `SessionsController#destroy` (logout) with request specs
8. Implement `MeController` (replace stub) + `UsersController` with request specs
9. Flutter: create `AuthEvent` sealed class + `User` entity
10. Flutter: implement `AuthLocalDataSource` with tests
11. Flutter: implement `AuthRemoteDataSource`
12. Flutter: implement `AuthRepository` with tests
13. Flutter: rewrite `AuthInterceptor` (`QueuedInterceptorsWrapper`)
14. Flutter: rewrite `AuthState` + `AuthViewModel` with `bloc_test` tests
15. Flutter: implement auth screens (Splash, Onboarding, Login, Register, Profile, EditProfile)
16. Flutter: wire all routes in `AppRouter`; update `ServiceLocator`

## Open Questions

(none — all decisions made above)
