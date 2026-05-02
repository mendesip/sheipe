## Why

Phase 0 scaffold is complete (Rails API + Flutter app with DI, routing, network, and storage layers fully in place). Phase 1 delivers the auth and profile layer that every subsequent phase depends on — without it no user can register, log in, or take any action in the app.

## What Changes

- **Rails**: Hand-rolled `User` + `Session` models with UUID PKs. `Session` issues two opaque tokens: an `access_token` (24h) and a `refresh_token` (30d). New endpoints: `POST /auth/register`, `POST /auth/login`, `POST /auth/refresh`, `DELETE /auth/logout`, `GET/PATCH /me`, `GET /users/:id`. `BaseController` gains `authenticate` before-action.
- **Flutter**: `AuthLocalDataSource` persists both tokens + user JSON in `flutter_secure_storage`. `AuthRemoteDataSource` + `AuthRepository` implement the full auth contract. `AuthInterceptor` rewrites to `QueuedInterceptorsWrapper` — intercepts 401s, attempts one refresh, retries the original request, or emits `AuthUnauthorized` event on failure. `AuthViewModel` (Cubit) subscribes to `Stream<AuthEvent>` for forced logout. Auth screens: Splash → Onboarding → Login/Register (2-step) + ProfileScreen + EditProfileScreen.

## Capabilities

### New Capabilities

- `user-auth`: Registration, login, logout, access+refresh token lifecycle — issuance, rotation, expiry, and invalidation. Includes Flutter-side automatic token refresh via `AuthInterceptor`.
- `user-profile`: Viewing and editing the authenticated user's own profile; viewing other users' public profiles.

### Modified Capabilities

(none — no existing specs)

## Impact

- **API**: New models (`User`, `Session`), new migrations, new controllers under `api/v1/auth` and `api/v1`. `BaseController` gains `authenticate` before-action. All future controllers inherit auth.
- **Flutter**: New `features/auth/` data layer; `AuthInterceptor` rewrites from stub to full `QueuedInterceptorsWrapper`; `AuthViewModel` fully implemented; `core/di/service_locator.dart` gains all new registrations.
- **Docs affected**: `docs/architecture/api.md` (auth endpoints), `docs/architecture/data-model.md` (User + Session entities).

## Non-goals

- Social profile (followers, posts) — Phase 6.
- Trainer-athlete role relationship — Phase 4.
- Password reset / email verification — not in roadmap scope for MVP.
- Avatar upload or URL input — Phase 1 shows initials only; `avatar_url` column reserved.
- Account deletion (`DELETE /me`) — deferred.
- OAuth / social login — deferred.
