### Requirement: View own profile
An authenticated user SHALL be able to retrieve their full profile. The response SHALL include `id`, `name`, `email`, `role`, and `created_at`. The `avatar_url` field SHALL NOT be included in Phase 1 — the API omits it; the Flutter UI shows initials instead.

#### Scenario: Get own profile
- **WHEN** `GET /api/v1/me` is called with a valid Bearer `access_token`
- **THEN** the system returns HTTP 200 with `{ id, name, email, role, created_at }` (no `password_digest`, no `avatar_url`)

#### Scenario: Unauthenticated access to /me
- **WHEN** `GET /api/v1/me` is called without an Authorization header
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized" } }`

---

### Requirement: Edit own profile
An authenticated user SHALL be able to update their `name`. No other fields are editable in Phase 1. The updated user object SHALL be returned.

#### Scenario: Successful name update
- **WHEN** `PATCH /api/v1/me` is called with `{ name: "New Name" }`
- **THEN** the system updates the `User` record and returns HTTP 200 with `{ id, name, email, role, created_at }` reflecting the new name

#### Scenario: Update with blank name
- **WHEN** `PATCH /api/v1/me` is called with `{ name: "" }`
- **THEN** the system returns HTTP 422 with `{ error: { code: "validation_failed", details: { name: ["can't be blank"] } } }`

---

### Requirement: View public profile
Any authenticated user SHALL be able to view another user's public profile by their UUID. The public profile SHALL NOT include `email` or `password_digest`.

#### Scenario: View existing user's public profile
- **WHEN** `GET /api/v1/users/:id` is called with a valid UUID of an existing user
- **THEN** the system returns HTTP 200 with `{ id, name, role, created_at }` (no `email`)

#### Scenario: View non-existent user
- **WHEN** `GET /api/v1/users/:id` is called with an unknown UUID
- **THEN** the system returns HTTP 404 with `{ error: { code: "not_found" } }`

#### Scenario: Unauthenticated access to public profile
- **WHEN** `GET /api/v1/users/:id` is called without an Authorization header
- **THEN** the system returns HTTP 401 with `{ error: { code: "unauthorized" } }`

---

### Requirement: Flutter profile screens
The app SHALL provide screens to view and edit the authenticated user's profile. The avatar SHALL display the user's first initial in a colored circle (initials avatar — no image upload in Phase 1).

#### Scenario: View own profile on ProfileScreen
- **WHEN** user navigates to `ProfileScreen`
- **THEN** the screen displays the initials avatar, name, role badge, and a logout button; data is read from `AuthViewModel` state (no additional API call)

#### Scenario: Edit profile and save
- **WHEN** user submits `EditProfileScreen` with a valid non-blank name
- **THEN** app calls `PATCH /api/v1/me`, saves updated `User` to `auth_user_json` in storage, updates `AuthViewModel` state, and navigates back to `ProfileScreen` with the updated name

#### Scenario: Edit profile with blank name — client-side validation
- **WHEN** user submits `EditProfileScreen` with a blank name
- **THEN** screen shows inline validation error; no API call is made
