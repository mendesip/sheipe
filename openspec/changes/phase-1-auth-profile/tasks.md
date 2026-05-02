## 1. API — RSpec + FactoryBot setup

- [ ] 1.1 Add `factory_bot_rails` to test group in `apps/sheipe_api/Gemfile`
- [ ] 1.2 Run `bundle install` in `apps/sheipe_api`
- [ ] 1.3 Run `bundle exec rails generate rspec:install` — creates `spec/spec_helper.rb`, `spec/rails_helper.rb`, `.rspec`
- [ ] 1.4 Add `config.include FactoryBot::Syntax::Methods` to `RSpec.configure` block in `rails_helper.rb`
- [ ] 1.5 Create `spec/support/json_helper.rb` with `json_body` helper; require `spec/support/**/*.rb` in `rails_helper.rb`; include `JsonHelper, type: :request`
- [ ] 1.6 Verify `bundle exec rspec` runs with `0 examples, 0 failures`
- [ ] 1.7 Commit: `chore(api): add rspec + factory_bot setup`

## 2. API — User model

- [ ] 2.1 Write failing model spec `spec/models/user_spec.rb` (valid, name blank, email blank, duplicate email, malformed email, admin role rejected, athlete/trainer allowed, has_secure_password)
- [ ] 2.2 Run spec — verify `FAILED — uninitialized constant User`
- [ ] 2.3 Generate migration `CreateUsers` with UUID PK, `name`, `email`, `password_digest`, `role` integer default 0, `avatar_url`, case-insensitive email unique index
- [ ] 2.4 Create `app/models/user.rb` — `has_secure_password`, `enum :role`, validates `name`, `email` uniqueness + format, `validate :role_not_admin on: :create`, `before_save` email downcase
- [ ] 2.5 Create `spec/factories/users.rb` — sequence email, name, password, role: `:athlete`
- [ ] 2.6 Run `rails db:migrate`
- [ ] 2.7 Run model spec — verify `8 examples, 0 failures`
- [ ] 2.8 Commit: `feat(api): add User model with role enum and validations`

## 3. API — Session model + Current

- [ ] 3.1 Write failing model spec `spec/models/session_spec.rb` (access_token generated, expires_at +24h, refresh_token generated, expires_at +30d, access_token unique)
- [ ] 3.2 Run spec — verify `FAILED — uninitialized constant Session`
- [ ] 3.3 Generate migration `CreateSessions` with UUID PK, `user_id` UUID FK, `access_token` + `access_token_expires_at`, `refresh_token` + `refresh_token_expires_at`, unique indexes on both tokens
- [ ] 3.4 Create `app/models/session.rb` — `belongs_to :user`, `before_create :generate_tokens`, `rotate_access_token!`
- [ ] 3.5 Create `app/models/current.rb` — `CurrentAttributes` with `session`, delegates `user`
- [ ] 3.6 Create `spec/factories/sessions.rb` — `association :user`
- [ ] 3.7 Run `rails db:migrate`
- [ ] 3.8 Run session model spec — verify `5 examples, 0 failures`
- [ ] 3.9 Commit: `feat(api): add Session model with access+refresh token generation`

## 4. API — BaseController authenticate

- [ ] 4.1 Write failing request spec `spec/requests/api/v1/authentication_spec.rb` — 401 without header, 401 invalid token, 401 expired access_token
- [ ] 4.2 Run spec — verify `FAILED — No route matches [GET] "/api/v1/me"`
- [ ] 4.3 Rewrite `app/controllers/api/v1/base_controller.rb` — `authenticate` before_action, all `rescue_from` handlers, `render_error` helper
- [ ] 4.4 Add stub `resource :me, only: [:show]` route + stub `MeController#show` for spec to run
- [ ] 4.5 Run authentication spec — verify `3 examples, 0 failures`
- [ ] 4.6 Commit: `feat(api): add Bearer token authenticate before_action to BaseController`

## 5. API — Alba serializers

- [ ] 5.1 Create `app/serializers/user_serializer.rb` — `attributes :id, :name, :email, :role, :created_at`
- [ ] 5.2 Create `app/serializers/public_user_serializer.rb` — `attributes :id, :name, :role, :created_at`
- [ ] 5.3 Verify serializers load via `rails runner` — expect JSON with correct keys
- [ ] 5.4 Commit: `feat(api): add UserSerializer and PublicUserSerializer with Alba`

## 6. API — Register + Login endpoints

- [ ] 6.1 Write `spec/requests/api/v1/auth/registrations_spec.rb` — 201 with tokens+user, 422 duplicate email, 422 password mismatch, 422 admin role, 422 blank name
- [ ] 6.2 Write `spec/requests/api/v1/auth/sessions_spec.rb` — 200 with tokens+user, 401 wrong password, 401 unknown email (same message)
- [ ] 6.3 Run specs — verify `FAILED — No route matches`
- [ ] 6.4 Create `app/controllers/api/v1/auth/registrations_controller.rb` — `skip_before_action :authenticate`, `create` action returning `{ access_token, refresh_token, user }`
- [ ] 6.5 Create `app/controllers/api/v1/auth/sessions_controller.rb` — `skip_before_action :authenticate`, `create` action, same response shape
- [ ] 6.6 Add routes: `namespace :auth { post :register, post :login, post :refresh, delete :logout }` + `resource :me, only: [:show, :update]` + `resources :users, only: [:show]`
- [ ] 6.7 Run registrations + sessions specs — verify `8 examples, 0 failures`
- [ ] 6.8 Commit: `feat(api): add register and login endpoints`

## 7. API — Refresh + Logout endpoints

- [ ] 7.1 Write `spec/requests/api/v1/auth/refreshes_spec.rb` — 200 new access_token, 401 invalid refresh_token, 401 expired refresh_token
- [ ] 7.2 Write `spec/requests/api/v1/auth/logouts_spec.rb` — 204 destroys session, 401 after logout, 401 without header
- [ ] 7.3 Run specs — verify `FAILED — uninitialized constant` or routing error
- [ ] 7.4 Create `app/controllers/api/v1/auth/refreshes_controller.rb` — `skip_before_action :authenticate`, validates refresh_token + expiry, calls `rotate_access_token!`
- [ ] 7.5 Update `sessions_controller.rb` — add `destroy` action (`skip_before_action` only for `:create`)
- [ ] 7.6 Run refresh + logout specs — verify `6 examples, 0 failures`
- [ ] 7.7 Commit: `feat(api): add refresh token rotation and logout endpoints`

## 8. API — Me + Users endpoints

- [ ] 8.1 Write `spec/requests/api/v1/me_spec.rb` — GET 200 (correct fields, no password_digest), GET 401 without token, PATCH 200 updated name, PATCH 422 blank name
- [ ] 8.2 Write `spec/requests/api/v1/users_spec.rb` — GET 200 (no email), GET 404 unknown user, GET 401 without token
- [ ] 8.3 Run specs — verify failures
- [ ] 8.4 Replace `MeController` stub with full implementation (`show` → `UserSerializer`, `update` → `me_params`)
- [ ] 8.5 Create `app/controllers/api/v1/users_controller.rb` — `show` → `User.find(params[:id])` → `PublicUserSerializer`
- [ ] 8.6 Run me + users specs — verify `7 examples, 0 failures`
- [ ] 8.7 Run full suite `bundle exec rspec` — verify all passing, 0 failures
- [ ] 8.8 Commit: `feat(api): add GET/PATCH /me and GET /users/:id endpoints`

## 9. Flutter — AuthEvent + User entity

- [ ] 9.1 Create `lib/core/network/auth_event.dart` — `sealed class AuthEvent` + `AuthUnauthorized`
- [ ] 9.2 Create `lib/features/auth/domain/entities/user.dart` — plain Dart class, `fromJson`/`toJson`/`copyWith`
- [ ] 9.3 Run `flutter analyze` on both files — verify `No issues found!`
- [ ] 9.4 Commit: `feat(app): add AuthEvent sealed class and User entity`

## 10. Flutter — AuthLocalDataSource

- [ ] 10.1 Write failing test `test/features/auth/data/local/auth_local_data_source_test.dart` — saveTokens, clearTokens, saveUser/getUser, onboarding flag
- [ ] 10.2 Run test — verify `FAILED — Target file not found`
- [ ] 10.3 Create `lib/features/auth/data/local/auth_local_data_source.dart` — wraps `FlutterSecureStorage` with keys: `auth_access_token`, `auth_refresh_token`, `auth_user_json`, `onboarding_seen`
- [ ] 10.4 Run test — verify `All tests passed!`
- [ ] 10.5 Commit: `feat(app): add AuthLocalDataSource with SecureStorage`

## 11. Flutter — AuthRemoteDataSource

- [ ] 11.1 Create `lib/features/auth/data/remote/auth_remote_data_source.dart` — `register`, `login`, `refresh`, `logout`, `getMe`, `updateMe`; uses record types `AuthTokens` + `AuthResult`
- [ ] 11.2 Run `flutter analyze` — verify `No issues found!`
- [ ] 11.3 Commit: `feat(app): add AuthRemoteDataSource`

## 12. Flutter — AuthRepository

- [ ] 12.1 Write failing test `test/features/auth/data/repositories/auth_repository_test.dart` — login saves tokens+user, logout clears tokens even if remote throws, checkAuth returns user/null
- [ ] 12.2 Run test — verify `FAILED — Target file not found`
- [ ] 12.3 Create `lib/features/auth/data/repositories/auth_repository.dart` — composes remote + local; exposes `Stream<AuthEvent>`; `logout` clears locally regardless of API error; `checkAuth` reads from storage (no API call)
- [ ] 12.4 Run test — verify `All tests passed!`
- [ ] 12.5 Commit: `feat(app): add AuthRepository`

## 13. Flutter — AuthInterceptor rewrite

- [ ] 13.1 Rewrite `lib/core/network/interceptors/auth_interceptor.dart` — `QueuedInterceptorsWrapper`; `onRequest` injects Bearer; `onError` (401) → refresh via separate `Dio`, retry original; on failure → `clearTokens` + push `AuthUnauthorized` to sink
- [ ] 13.2 Run `flutter analyze` — verify `No issues found!`
- [ ] 13.3 Commit: `feat(app): rewrite AuthInterceptor with QueuedInterceptorsWrapper and refresh token support`

## 14. Flutter — AuthState + AuthViewModel rewrite

- [ ] 14.1 Write `AuthViewModel` tests `test/features/auth/presentation/viewmodels/auth_view_model_test.dart` — checkAuthStatus (authenticated/unauthenticated), login (loading→authenticated, loading→error), register (loading→authenticated), logout (unauthenticated), `AuthUnauthorized` stream event triggers logout
- [ ] 14.2 Run tests — verify failures
- [ ] 14.3 Rewrite `lib/features/auth/presentation/viewmodels/auth_state.dart` — sealed class with 5 states: `AuthInitial`, `AuthLoading`, `AuthAuthenticated(User)`, `AuthUnauthenticated`, `AuthError(String)`
- [ ] 14.4 Rewrite `lib/features/auth/presentation/viewmodels/auth_view_model.dart` — Cubit; constructor subscribes to `AuthRepository.authEvents`; implements `checkAuthStatus`, `login`, `register`, `logout`, `updateProfile`
- [ ] 14.5 Run tests — verify all passing
- [ ] 14.6 Commit: `feat(app): rewrite AuthState and AuthViewModel with stream-based forced logout`

## 15. Flutter — Auth screens

- [ ] 15.1 Create `lib/features/auth/presentation/screens/splash_screen.dart` — calls `checkAuthStatus()` on init, no visible delay, navigates via GoRouter based on state
- [ ] 15.2 Create `lib/features/auth/presentation/screens/onboarding_screen.dart` — static slides, CTA calls `markOnboardingSeen()` then navigates to `/auth/login`
- [ ] 15.3 Create `lib/features/auth/presentation/screens/login_screen.dart` — email + password form, `AuthViewModel.login()`, inline error on `AuthError`, no navigation on error
- [ ] 15.4 Create `lib/features/auth/presentation/screens/register_screen.dart` — `PageView` step 1 (name, email, password) + step 2 (role: athlete/trainer), single `register()` call on step 2 submit
- [ ] 15.5 Create `lib/features/auth/presentation/screens/profile_screen.dart` — initials avatar (first letter, colored circle), name, role badge, logout button; reads from `AuthViewModel` state
- [ ] 15.6 Create `lib/features/auth/presentation/screens/edit_profile_screen.dart` — pre-filled name field, client-side blank validation, calls `updateProfile(name)`, navigates back on success

## 16. Flutter — Routing + DI wiring

- [ ] 16.1 Update `lib/app_router.dart` — add routes: `/` (SplashScreen), `/onboarding`, `/auth/login`, `/auth/register`, `/profile`, `/profile/edit`
- [ ] 16.2 Update `lib/core/di/service_locator.dart` — register `StreamController<AuthEvent>`, `AuthLocalDataSource`, `AuthRemoteDataSource`, `AuthRepository`, `AuthViewModel`; wire `AuthInterceptor` with stream sink
- [ ] 16.3 Run `flutter analyze lib/` — verify `No issues found!`
- [ ] 16.4 Run full Flutter test suite `flutter test` — verify all passing
- [ ] 16.5 Commit: `feat(app): wire auth screens, routes, and DI for Phase 1`
