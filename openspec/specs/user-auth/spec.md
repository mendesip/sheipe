### Requirement: User registration
A new user SHALL be able to create an account by providing name, email, password, password_confirmation, and role (`athlete` or `trainer`). The system SHALL return both an `access_token`, a `refresh_token`, and the full user object on success. The role `admin` SHALL be rejected at registration.

#### Scenario: Successful registration as athlete
- **WHEN** `POST /api/v1/auth/register` is called with `{ name, email, password, password_confirmation, role: "athlete" }`
- **THEN** the system creates a `User` and `Session`, returns HTTP 201 with `{ access_token: "<uuid>", refresh_token: "<uuid>", user: { id, name, email, role, created_at } }`

#### Scenario: Successful registration as trainer
- **WHEN** `POST /api/v1/auth/register` is called with `role: "trainer"`
- **THEN** the system creates a `User` and `Session`, returns HTTP 201 with `{ access_token, refresh_token, user }`

#### Scenario: Registration with duplicate email
- **WHEN** `POST /api/v1/auth/register` is called with an email already in use (case-insensitive)
- **THEN** the system returns HTTP 422 with `{ error: { code: "validation_failed", details: { email: ["has already been taken"] } } }`

#### Scenario: Registration with mismatched passwords
- **WHEN** `POST /api/v1/auth/register` is called with `password != password_confirmation`
- **THEN** the system returns HTTP 422 with `{ error: { code: "validation_failed" } }`

#### Scenario: Registration with admin role
- **WHEN** `POST /api/v1/auth/register` is called with `role: "admin"`
- **THEN** the system returns HTTP 422 with `{ error: { code: "validation_failed" } }`

#### Scenario: Registration with blank name
- **WHEN** `POST /api/v1/auth/register` is called with `name: ""`
- **THEN** the system returns HTTP 422 with `{ error: { code: "validation_failed", details: { name: ["can't be blank"] } } }`

---

### Requirement: User login
A registered user SHALL be able to authenticate with email and password. The system SHALL return a new `access_token`, `refresh_token`, and user object. The error message SHALL be identical for wrong password and unknown email to prevent email enumeration.

#### Scenario: Successful login
- **WHEN** `POST /api/v1/auth/login` is called with valid `{ email, password }`
- **THEN** the system creates a new `Session`, returns HTTP 200 with `{ access_token: "<uuid>", refresh_token: "<uuid>", user: { id, name, email, role, created_at } }`

#### Scenario: Login with wrong password
- **WHEN** `POST /api/v1/auth/login` is called with incorrect password
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized", message: "Invalid email or password" } }`

#### Scenario: Login with unknown email
- **WHEN** `POST /api/v1/auth/login` is called with an email not in the database
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized", message: "Invalid email or password" } }`

---

### Requirement: User logout
An authenticated user SHALL be able to invalidate their current session. The `access_token` SHALL not be usable after logout. Other sessions (other devices) SHALL remain active.

#### Scenario: Successful logout
- **WHEN** `DELETE /api/v1/auth/logout` is called with a valid Bearer `access_token`
- **THEN** the system destroys the `Session` row, returns HTTP 204 No Content

#### Scenario: Using access_token after logout
- **WHEN** any authenticated endpoint is called with an `access_token` whose session was destroyed
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized" } }`

#### Scenario: Logout without Authorization header
- **WHEN** `DELETE /api/v1/auth/logout` is called without an Authorization header
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized" } }`

---

### Requirement: Access token refresh
The system SHALL allow clients to obtain a new `access_token` using a valid, non-expired `refresh_token` without re-authenticating. The `access_token` SHALL be rotated (new UUID, new 24h expiry); the `refresh_token` SHALL remain unchanged.

#### Scenario: Successful token refresh
- **WHEN** `POST /api/v1/auth/refresh` is called with a valid `{ refresh_token }`
- **THEN** the system returns HTTP 200 with `{ access_token: "<new-uuid>" }` and the session's `access_token` is updated

#### Scenario: New access_token differs from previous
- **WHEN** `POST /api/v1/auth/refresh` is called with a valid `refresh_token`
- **THEN** the returned `access_token` SHALL differ from the previous `access_token`

#### Scenario: Refresh with invalid refresh_token
- **WHEN** `POST /api/v1/auth/refresh` is called with an unknown `refresh_token`
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized" } }`

#### Scenario: Refresh with expired refresh_token
- **WHEN** `POST /api/v1/auth/refresh` is called with a `refresh_token` whose `refresh_token_expires_at` is in the past
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized" } }`

---

### Requirement: Bearer token authentication
Every protected endpoint SHALL require a valid `Authorization: Bearer <access_token>` header. The token SHALL be looked up in the `sessions` table and validated against `access_token_expires_at`.

#### Scenario: Request without Authorization header
- **WHEN** a protected endpoint is called without `Authorization` header
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized" } }`

#### Scenario: Request with invalid token
- **WHEN** a protected endpoint is called with `Authorization: Bearer invalid-token`
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized" } }`

#### Scenario: Request with expired access_token
- **WHEN** a protected endpoint is called with an `access_token` whose `access_token_expires_at` is in the past
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized" } }`

---

### Requirement: Flutter auth state management
The Flutter app SHALL maintain auth state reactively via `AuthViewModel` (Cubit). All navigation SHALL respond to auth state changes without manual redirection calls from screens.

#### Scenario: App launch with stored tokens and user JSON
- **WHEN** the app starts and `auth_access_token` and `auth_user_json` exist in `flutter_secure_storage`
- **THEN** `AuthViewModel.checkAuthStatus()` emits `AuthAuthenticated(user)` and GoRouter navigates to home

#### Scenario: App launch without stored token — onboarding not seen
- **WHEN** the app starts, no token in storage, and `onboarding_seen` is not set
- **THEN** `AuthViewModel` emits `AuthUnauthenticated` and GoRouter navigates to `/onboarding`

#### Scenario: App launch without stored token — onboarding seen
- **WHEN** the app starts, no token in storage, and `onboarding_seen` is `"true"`
- **THEN** `AuthViewModel` emits `AuthUnauthenticated` and GoRouter navigates to `/auth/login`

#### Scenario: Successful login from Flutter
- **WHEN** user submits valid credentials on `LoginScreen`
- **THEN** `AuthViewModel` emits `AuthLoading`, calls `AuthRepository.login()`, saves both tokens + user JSON to storage, emits `AuthAuthenticated(user)`, GoRouter redirects to home

#### Scenario: Failed login from Flutter
- **WHEN** user submits invalid credentials on `LoginScreen`
- **THEN** `AuthViewModel` emits `AuthLoading` then `AuthError("Invalid email or password")`, screen shows inline error, no navigation

#### Scenario: Logout from Flutter
- **WHEN** user triggers logout
- **THEN** `AuthViewModel` calls `AuthRepository.logout()` (clears tokens locally regardless of API result), emits `AuthUnauthenticated`, GoRouter redirects to `/auth/login`

#### Scenario: 401 response triggers forced logout
- **WHEN** any API call returns 401 and `AuthInterceptor` cannot refresh (no refresh token or refresh fails)
- **THEN** `AuthInterceptor` clears tokens from storage and pushes `AuthUnauthorized` to `Stream<AuthEvent>`; `AuthViewModel` receives the event and emits `AuthUnauthenticated`

#### Scenario: Concurrent 401 responses — single refresh attempt
- **WHEN** two parallel API calls both receive 401 simultaneously
- **THEN** `QueuedInterceptorsWrapper` ensures only one `POST /auth/refresh` call is made; both original requests are retried with the new `access_token`
