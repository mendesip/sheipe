# Auth & Profile — Design Spec
_Phase 1 | 2026-05-01_

## Overview

Implements user registration, login, token-based auth, and profile management. Every subsequent phase depends on this layer. Phase 0 scaffold (Rails API + Flutter DI/routing/network/storage) is already complete.

---

## Architecture

```
┌─────────────────────────────────────────────┐
│  Rails API                                  │
│  User (has_secure_password, role enum)      │
│  Session (access_token 24h, refresh 30d)    │
│  POST /auth/register  → 201 {tokens, user}  │
│  POST /auth/login     → 200 {tokens, user}  │
│  POST /auth/refresh   → 200 {access_token}  │
│  DELETE /auth/logout  → 204                 │
│  GET/PATCH /me        → 200 {user}          │
│  GET /users/:id       → 200 {public user}   │
└──────────────────┬──────────────────────────┘
                   │ Bearer access_token
┌──────────────────▼──────────────────────────┐
│  Flutter                                    │
│                                             │
│  AuthInterceptor (Dio / Queued)             │
│    ├─ adds Bearer header to every request   │
│    ├─ 401 → POST /auth/refresh              │
│    │     ├─ success → retry original        │
│    │     └─ fail → Stream<AuthEvent>        │
│                                             │
│  AuthRepository                             │
│    ├─ AuthRemoteDataSource (Dio)            │
│    ├─ AuthLocalDataSource (SecureStorage)   │
│    └─ exposes Stream<AuthEvent>             │
│                                             │
│  AuthViewModel (Cubit)                      │
│    ├─ subscribes to Stream<AuthEvent>       │
│    ├─ states: Initial / Loading /           │
│    │          Authenticated(user) /         │
│    │          Unauthenticated / Error(msg)  │
│    └─ drives GoRouter redirect              │
└─────────────────────────────────────────────┘
```

---

## API Layer

### Models

```ruby
# User
# id: uuid (gen_random_uuid())
# name: string, not null
# email: string, not null, unique (case-insensitive index)
# password_digest: string (has_secure_password)
# role: integer enum { athlete: 0, trainer: 1, admin: 2 }, default: athlete
# avatar_url: string, nullable (reserved — not editable in Phase 1)
# created_at: datetime

# Session
# id: uuid
# user_id: uuid FK → users
# access_token: uuid (gen_random_uuid()), unique
# access_token_expires_at: datetime  (+24h from creation)
# refresh_token: uuid (gen_random_uuid()), unique
# refresh_token_expires_at: datetime (+30d from creation)
# created_at: datetime
```

### Endpoints

| Method | Path | Auth | Description |
|---|---|---|---|
| `POST` | `/api/v1/auth/register` | — | Create User + Session, return tokens + user |
| `POST` | `/api/v1/auth/login` | — | Authenticate, create Session, return tokens + user |
| `POST` | `/api/v1/auth/refresh` | — | Exchange refresh_token for new access_token |
| `DELETE` | `/api/v1/auth/logout` | Bearer | Destroy current Session |
| `GET` | `/api/v1/me` | Bearer | Return authenticated user (full) |
| `PATCH` | `/api/v1/me` | Bearer | Update name; returns updated user |
| `GET` | `/api/v1/users/:id` | Bearer | Return public profile (no email) |

### Auth mechanism

`authenticate` before-action in `BaseController`:
```ruby
Session.find_by!(access_token: bearer_token)
  .tap { |s| raise Unauthorized if s.access_token_expires_at < Time.current }
```

### Role constraint

Registration accepts only `athlete` or `trainer`. Submitting `admin` → 422 `validation_failed`. Role is immutable after creation in Phase 1.

### Serializers (Alba)

- `UserSerializer` — full: `id, name, email, role, created_at` (`avatar_url` omitted — Phase 1 has no upload)
- `PublicUserSerializer` — no email: `id, name, role, created_at`

### Response format

```json
// register / login
{
  "access_token": "<uuid>",
  "refresh_token": "<uuid>",
  "user": { "id", "name", "email", "role", "created_at" }
}

// refresh
{ "access_token": "<uuid>" }
```

### Error responses (via BaseController#rescue_from)

| Scenario | HTTP | code |
|---|---|---|
| Duplicate email | 422 | `validation_failed` |
| Wrong password or unknown email | 401 | `unauthorized` (same message — no enumeration) |
| Expired / invalid access_token | 401 | `unauthorized` |
| Expired / invalid refresh_token | 401 | `unauthorized` |
| User not found | 404 | `not_found` |

---

## Flutter Data Layer

```
features/auth/
├── domain/
│   └── entities/user.dart           # freezed: id, name, email, role, createdAt
├── data/
│   ├── local/
│   │   └── auth_local_data_source.dart
│   │         saveTokens(access, refresh)
│   │         getAccessToken() → String?
│   │         getRefreshToken() → String?
│   │         clearTokens()
│   │         saveUser(User)
│   │         getUser() → User?
│   │         saveOnboardingSeen()
│   │         isOnboardingSeen() → bool
│   ├── remote/
│   │   └── auth_remote_data_source.dart
│   │         register(name, email, password, role) → (tokens, User)
│   │         login(email, password) → (tokens, User)
│   │         refresh(refreshToken) → String  // new access_token
│   │         logout()
│   │         getMe() → User
│   │         updateMe(name) → User
│   └── repositories/
│       └── auth_repository.dart
│             register/login → remote → saveTokens → return User
│             logout → remote (best-effort) → clearTokens
│             checkAuth → getAccessToken → present? Authenticated : Unauthenticated
│             exposes Stream<AuthEvent> (fed by AuthInterceptor)
```

**Storage keys (flutter_secure_storage):**
- `auth_access_token`
- `auth_refresh_token`
- `auth_user_json` — User serialized as JSON; saved on login/register, cleared on logout
- `onboarding_seen` (value `"true"`)

**`AuthInterceptor` (QueuedInterceptorsWrapper):**
1. Injects `Authorization: Bearer <access_token>` on every request
2. On 401 → call `POST /auth/refresh` with stored `refresh_token`
   - Success → save new `access_token` → retry original request (once)
   - Fail → push `AuthEvent.unauthorized()` to stream → do not retry
3. `QueuedInterceptorsWrapper` ensures only one refresh call fires for concurrent 401s

**`AuthEvent`:**
```dart
sealed class AuthEvent {
  const factory AuthEvent.unauthorized() = _Unauthorized;
}
```

---

## Flutter Presentation Layer

### `AuthState`

```dart
sealed class AuthState {
  const factory AuthState.initial()                 = _Initial;
  const factory AuthState.loading()                 = _Loading;
  const factory AuthState.authenticated(User user)  = _Authenticated;
  const factory AuthState.unauthenticated()         = _Unauthenticated;
  const factory AuthState.error(String message)     = _Error;
}
```

### `AuthViewModel` (Cubit)

- Constructor: subscribes to `AuthRepository.authEvents` → `unauthorized` event → `logout()`
- `checkAuthStatus()` — reads `auth_access_token` from storage; if present, deserializes `auth_user_json` → emits `Authenticated(user)`; if absent, emits `Unauthenticated`. No API call on launch.
- `register/login` → `Loading` → call repo → `Authenticated` or `Error`
- `logout()` → call repo → `Unauthenticated`

### Navigation flow

```
App start → SplashScreen
  token absent →
    isOnboardingSeen?
      false → /onboarding → /auth/login
      true  → /auth/login
  token present → Authenticated → /home (Phase 2+)

/auth/login → "Create account" → /auth/register (step 1: name, email, password)
                                               → (step 2: role selection)
                                               → Authenticated → /home
```

### Screens

| Screen | Route | Notes |
|---|---|---|
| `SplashScreen` | `/` | Runs `checkAuthStatus`, no visible UI delay |
| `OnboardingScreen` | `/onboarding` | Static slides; sets `onboarding_seen` flag on CTA tap |
| `LoginScreen` | `/auth/login` | Inline error on `AuthError`; no navigation |
| `RegisterScreen` | `/auth/register` | 2-step PageView; single `register()` call on step 2 submit |
| `ProfileScreen` | `/profile` | Initials avatar (first letter, colored circle), name, role badge, logout |
| `EditProfileScreen` | `/profile/edit` | Name field only; client-side blank validation; no API call if invalid |

---

## Key Invariants

- `AuthInterceptor` never imports `AuthViewModel` — communicates only via `Stream<AuthEvent>`
- Token lives only in `flutter_secure_storage` — never in memory alone
- `avatar_url` field exists in DB but is not editable or displayed from API in Phase 1 — UI shows initials
- `DELETE /me` (account deletion) deferred — not in Phase 1
- Multiple sessions allowed — each device/login gets its own `Session` row; logout destroys only current session
- Registration role limited to `athlete | trainer`; `admin` rejected at API level

---

## Out of Scope (Phase 1)

- Password reset / email verification
- OAuth / social login
- Avatar upload or URL input
- Account deletion (`DELETE /me`)
- Trainer-athlete relationship
