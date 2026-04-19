# Research: Monorepo Foundation Scaffold

## Rails 8 API

### UUID Primary Keys

**Decision**: Use `pgcrypto` extension with `gen_random_uuid()`

**Rationale**: Rails 7+ standardised on pgcrypto. `uuid-ossp` is the legacy
extension; `pgcrypto` is lighter, ships with PostgreSQL by default, and
`gen_random_uuid()` is the function Rails migrations reference natively.

**Migration**:
```ruby
enable_extension 'pgcrypto'
# All create_table calls use: id: :uuid, default: "gen_random_uuid()"
```

**Action**: CLAUDE.md references `uuid-ossp` — update to `pgcrypto`.

---

### BaseController rescue_from

**Decision**: Rescue the following exceptions centrally in `Api::V1::BaseController`:

| Exception | HTTP Status | Error Code |
|---|---|---|
| `ActiveRecord::RecordNotFound` | 404 | `not_found` |
| `ActionController::ParameterMissing` | 400 | `bad_request` |
| `ActiveRecord::RecordInvalid` | 422 | `validation_failed` |
| `ActionPolicy::Unauthorized` | 403 | `forbidden` |
| `StandardError` | 500 | `internal_error` |

Stack traces are logged server-side but never exposed in the response body.

---

### rswag Setup

**Decision**: Use `rswag-rails` + `rswag-specs` gems.

**Generator**: `rails g rswag:install` creates `spec/swagger_helper.rb` and
`config/initializers/rswag-*.rb`. Specs live in `spec/requests/api/v1/`.

---

### CORS

**Decision**: `rack-cors` initializer allows all localhost origins in
development; production origins read from `ENV['CORS_ORIGINS']`.

---

## Flutter App

### Folder Structure

**Decision**: Feature-first under `lib/`:

```
lib/
├── core/
│   ├── di/            # get_it service locator
│   ├── network/       # Dio client + interceptors
│   └── storage/       # Drift database + secure storage
├── features/          # One folder per domain feature
│   └── <feature>/
│       ├── data/      # datasources, repository impl, models
│       ├── domain/    # entities, abstract repos
│       └── presentation/  # screens, viewmodels (cubits), widgets
├── shared/
│   ├── theme/         # AppTheme, AppColors, AppTextStyles
│   └── widgets/       # Cross-feature reusable widgets
└── main.dart
```

---

### GoRouter Auth Guard

**Decision**: `redirect` callback reads token from `flutter_secure_storage`
synchronously via a `ChangeNotifier` bridge that listens to the `AuthCubit`
stream and calls `notifyListeners()` on every state change. GoRouter uses
`refreshListenable` to re-evaluate the redirect on state changes.

---

### Drift Singleton

**Decision**: `AppDatabase` registered as `lazySingleton` in get_it.
Zero tables at this phase — `@DriftDatabase(tables: [])`. Schema version = 1.
`dispose` callback calls `db.close()`.

---

### Dio Bearer Token Interceptor

**Decision**: Custom `Interceptor` subclass (`AuthInterceptor`) that:
1. Reads `auth_token` from `flutter_secure_storage` on every request
2. Attaches `Authorization: Bearer <token>` header if token is present
3. On 401 response, clears token and notifies `AuthCubit` to trigger logout
   (token refresh is a Phase 1 concern — not in scope for scaffold)

---

### Abstract Repository Pattern

**Decision**: Three-layer contract per feature:
- `abstract class <Feature>Repository` — domain layer interface
- `abstract class <Feature>RemoteDataSource` — remote contract
- `abstract class <Feature>LocalDataSource` — local contract

Concrete implementations (`*Impl`) are not created in this phase.
The scaffold only defines the base contracts in `core/`.
