# Phase 1 — Auth & Profile Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement complete auth (register/login/logout with access+refresh tokens) and profile (view/edit) for both the Rails API and Flutter app.

**Architecture:** Rails API uses hand-rolled User + Session models (access_token 24h, refresh_token 30d) with Bearer token auth. Flutter uses a Repository pattern with `AuthInterceptor` (QueuedInterceptorsWrapper) handling token refresh; `AuthViewModel` subscribes to a `Stream<AuthEvent>` for forced logout on 401.

**Tech Stack:** Rails 8, PostgreSQL (pgcrypto UUIDs), Alba serializers, RSpec + FactoryBot | Flutter, Bloc/Cubit, Dio 5, flutter_secure_storage, get_it, mocktail, bloc_test

---

## File Map

### Rails API — New files
```
apps/sheipe_api/
├── db/migrate/
│   ├── YYYYMMDDXXXXXX_create_users.rb
│   └── YYYYMMDDXXXXXX_create_sessions.rb
├── app/models/
│   ├── current.rb
│   ├── user.rb
│   └── session.rb
├── app/controllers/api/v1/auth/
│   ├── registrations_controller.rb
│   ├── sessions_controller.rb
│   └── refreshes_controller.rb
├── app/controllers/api/v1/
│   ├── me_controller.rb
│   └── users_controller.rb
├── app/serializers/
│   ├── user_serializer.rb
│   └── public_user_serializer.rb
├── spec/
│   ├── rails_helper.rb
│   ├── spec_helper.rb
│   ├── factories/
│   │   ├── users.rb
│   │   └── sessions.rb
│   └── requests/api/v1/
│       ├── auth/registrations_spec.rb
│       ├── auth/sessions_spec.rb
│       ├── auth/refreshes_spec.rb
│       ├── auth/logouts_spec.rb
│       ├── me_spec.rb
│       └── users_spec.rb
```

### Rails API — Modified files
```
apps/sheipe_api/
├── Gemfile                                    (add factory_bot_rails)
├── config/routes.rb                           (add auth + me + users routes)
└── app/controllers/api/v1/base_controller.rb  (add authenticate before_action)
```

### Flutter — New files
```
apps/sheipe_app/lib/
├── features/auth/
│   ├── domain/entities/user.dart
│   ├── data/
│   │   ├── local/auth_local_data_source.dart
│   │   ├── remote/auth_remote_data_source.dart
│   │   └── repositories/auth_repository.dart
│   └── presentation/
│       └── screens/
│           ├── splash_screen.dart
│           ├── onboarding_screen.dart
│           ├── login_screen.dart
│           ├── register_screen.dart
│           ├── profile_screen.dart
│           └── edit_profile_screen.dart
├── core/network/auth_event.dart
└── test/features/auth/
    ├── auth_view_model_test.dart
    └── auth_repository_test.dart
```

### Flutter — Modified files
```
apps/sheipe_app/lib/
├── core/network/interceptors/auth_interceptor.dart   (rewrite — QueuedInterceptorsWrapper)
├── features/auth/presentation/viewmodels/
│   ├── auth_state.dart                               (rewrite — 5 states + User)
│   └── auth_view_model.dart                          (rewrite — full impl)
├── core/di/service_locator.dart                      (rewire DI)
└── app_router.dart                                   (add all routes)
```

---

## Task 1: API — Add factory_bot_rails + RSpec setup

**Files:**
- Modify: `apps/sheipe_api/Gemfile`
- Create: `apps/sheipe_api/spec/rails_helper.rb`
- Create: `apps/sheipe_api/spec/spec_helper.rb`
- Create: `apps/sheipe_api/spec/support/json_helper.rb`

- [ ] **Step 1: Add factory_bot_rails to Gemfile**

In `apps/sheipe_api/Gemfile`, update the test group:
```ruby
group :test do
  gem "rswag-specs"
  gem "rspec-rails"
  gem "factory_bot_rails"
end
```

- [ ] **Step 2: Install gems**

```bash
cd apps/sheipe_api && bundle install
```
Expected: `Bundle complete!`

- [ ] **Step 3: Run RSpec install generator**

```bash
cd apps/sheipe_api && bundle exec rails generate rspec:install
```
Expected: Creates `spec/spec_helper.rb`, `spec/rails_helper.rb`, `.rspec`

- [ ] **Step 4: Add FactoryBot + JSON helper to rails_helper**

In `apps/sheipe_api/spec/rails_helper.rb`, inside the `RSpec.configure` block, add:
```ruby
config.include FactoryBot::Syntax::Methods
```

- [ ] **Step 5: Create JSON helper**

Create `apps/sheipe_api/spec/support/json_helper.rb`:
```ruby
module JsonHelper
  def json_body
    JSON.parse(response.body)
  end
end
```

In `apps/sheipe_api/spec/rails_helper.rb`, add before the `RSpec.configure` block:
```ruby
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
```

And inside `RSpec.configure`:
```ruby
config.include JsonHelper, type: :request
```

- [ ] **Step 6: Verify RSpec runs**

```bash
cd apps/sheipe_api && bundle exec rspec
```
Expected: `0 examples, 0 failures`

- [ ] **Step 7: Commit**

```bash
git add apps/sheipe_api/Gemfile apps/sheipe_api/Gemfile.lock apps/sheipe_api/spec/
git commit -m "chore(api): add rspec + factory_bot setup"
```

---

## Task 2: API — User migration + model

**Files:**
- Create: `apps/sheipe_api/db/migrate/TIMESTAMP_create_users.rb`
- Create: `apps/sheipe_api/app/models/user.rb`
- Create: `apps/sheipe_api/spec/factories/users.rb`

- [ ] **Step 1: Write the failing model test**

Create `apps/sheipe_api/spec/models/user_spec.rb`:
```ruby
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'is invalid without name' do
    user.name = ''
    expect(user).not_to be_valid
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without email' do
    user.email = ''
    expect(user).not_to be_valid
  end

  it 'is invalid with duplicate email (case-insensitive)' do
    create(:user, email: 'alice@example.com')
    user.email = 'ALICE@example.com'
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include('has already been taken')
  end

  it 'is invalid with malformed email' do
    user.email = 'notanemail'
    expect(user).not_to be_valid
  end

  it 'does not allow admin role at registration' do
    user.role = :admin
    expect(user).not_to be_valid
    expect(user.errors[:role]).to be_present
  end

  it 'allows athlete role' do
    user.role = :athlete
    expect(user).to be_valid
  end

  it 'allows trainer role' do
    user.role = :trainer
    expect(user).to be_valid
  end

  it 'has secure password' do
    expect(user).to respond_to(:authenticate)
  end
end
```

- [ ] **Step 2: Run test — verify it fails**

```bash
cd apps/sheipe_api && bundle exec rspec spec/models/user_spec.rb
```
Expected: `FAILED — uninitialized constant User`

- [ ] **Step 3: Generate User migration**

```bash
cd apps/sheipe_api && bundle exec rails generate migration CreateUsers
```

Open the generated file and replace content with:
```ruby
class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false, default: 0
      t.string :avatar_url

      t.timestamps
    end

    add_index :users, "lower(email)", unique: true, name: "index_users_on_lower_email"
  end
end
```

- [ ] **Step 4: Create User model**

Create `apps/sheipe_api/app/models/user.rb`:
```ruby
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :role, { athlete: 0, trainer: 1, admin: 2 }, default: :athlete

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :role_not_admin, on: :create

  before_save { self.email = email.strip.downcase }

  private

  def role_not_admin
    errors.add(:role, "is not valid for registration") if admin?
  end
end
```

- [ ] **Step 5: Create User factory**

Create `apps/sheipe_api/spec/factories/users.rb`:
```ruby
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { "Test User" }
    password { "password123" }
    role { :athlete }
  end
end
```

- [ ] **Step 6: Run migration**

```bash
cd apps/sheipe_api && bundle exec rails db:migrate
```
Expected: `== CreateUsers: migrated`

- [ ] **Step 7: Run model tests — verify they pass**

```bash
cd apps/sheipe_api && bundle exec rspec spec/models/user_spec.rb
```
Expected: `8 examples, 0 failures`

- [ ] **Step 8: Commit**

```bash
git add apps/sheipe_api/
git commit -m "feat(api): add User model with role enum and validations"
```

---

## Task 3: API — Session migration + model + Current

**Files:**
- Create: `apps/sheipe_api/db/migrate/TIMESTAMP_create_sessions.rb`
- Create: `apps/sheipe_api/app/models/session.rb`
- Create: `apps/sheipe_api/app/models/current.rb`
- Create: `apps/sheipe_api/spec/factories/sessions.rb`

- [ ] **Step 1: Write the failing model test**

Create `apps/sheipe_api/spec/models/session_spec.rb`:
```ruby
require 'rails_helper'

RSpec.describe Session, type: :model do
  subject(:session) { build(:session) }

  it 'auto-generates access_token on create' do
    session.save!
    expect(session.access_token).to be_present
  end

  it 'sets access_token_expires_at to ~24 hours from now' do
    freeze_time do
      session.save!
      expect(session.access_token_expires_at).to be_within(1.second).of(24.hours.from_now)
    end
  end

  it 'auto-generates refresh_token on create' do
    session.save!
    expect(session.refresh_token).to be_present
  end

  it 'sets refresh_token_expires_at to ~30 days from now' do
    freeze_time do
      session.save!
      expect(session.refresh_token_expires_at).to be_within(1.second).of(30.days.from_now)
    end
  end

  it 'access_token is unique' do
    session.save!
    other = build(:session, access_token: session.access_token)
    expect { other.save! }.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
```

- [ ] **Step 2: Run test — verify it fails**

```bash
cd apps/sheipe_api && bundle exec rspec spec/models/session_spec.rb
```
Expected: `FAILED — uninitialized constant Session`

- [ ] **Step 3: Generate Session migration**

```bash
cd apps/sheipe_api && bundle exec rails generate migration CreateSessions
```

Replace content:
```ruby
class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions, id: :uuid, default: "gen_random_uuid()" do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :access_token, null: false
      t.datetime :access_token_expires_at, null: false
      t.string :refresh_token, null: false
      t.datetime :refresh_token_expires_at, null: false

      t.timestamps
    end

    add_index :sessions, :access_token, unique: true
    add_index :sessions, :refresh_token, unique: true
  end
end
```

- [ ] **Step 4: Create Session model**

Create `apps/sheipe_api/app/models/session.rb`:
```ruby
class Session < ApplicationRecord
  belongs_to :user

  before_create :generate_tokens

  def rotate_access_token!
    update!(
      access_token: SecureRandom.uuid,
      access_token_expires_at: 24.hours.from_now
    )
  end

  private

  def generate_tokens
    self.access_token = SecureRandom.uuid
    self.access_token_expires_at = 24.hours.from_now
    self.refresh_token = SecureRandom.uuid
    self.refresh_token_expires_at = 30.days.from_now
  end
end
```

- [ ] **Step 5: Create Current**

Create `apps/sheipe_api/app/models/current.rb`:
```ruby
class Current < ActiveSupport::CurrentAttributes
  attribute :session

  delegate :user, to: :session, allow_nil: true
end
```

- [ ] **Step 6: Create Session factory**

Create `apps/sheipe_api/spec/factories/sessions.rb`:
```ruby
FactoryBot.define do
  factory :session do
    association :user
  end
end
```

- [ ] **Step 7: Run migration**

```bash
cd apps/sheipe_api && bundle exec rails db:migrate
```
Expected: `== CreateSessions: migrated`

- [ ] **Step 8: Run session model tests — verify they pass**

```bash
cd apps/sheipe_api && bundle exec rspec spec/models/session_spec.rb
```
Expected: `5 examples, 0 failures`

- [ ] **Step 9: Commit**

```bash
git add apps/sheipe_api/
git commit -m "feat(api): add Session model with access+refresh token generation"
```

---

## Task 4: API — BaseController authenticate

**Files:**
- Modify: `apps/sheipe_api/app/controllers/api/v1/base_controller.rb`

- [ ] **Step 1: Write the failing request spec**

Create `apps/sheipe_api/spec/requests/api/v1/authentication_spec.rb`:
```ruby
require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { create(:user) }
  let(:session) { user.sessions.create! }

  describe 'protected endpoint (GET /api/v1/me)' do
    it 'returns 401 without Authorization header' do
      get '/api/v1/me'
      expect(response).to have_http_status(:unauthorized)
      expect(json_body.dig('error', 'code')).to eq('unauthorized')
    end

    it 'returns 401 with invalid token' do
      get '/api/v1/me', headers: { 'Authorization' => 'Bearer invalid-token' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 with expired access_token' do
      session.update!(access_token_expires_at: 1.hour.ago)
      get '/api/v1/me', headers: { 'Authorization' => "Bearer #{session.access_token}" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
```

- [ ] **Step 2: Run test — verify it fails**

```bash
cd apps/sheipe_api && bundle exec rspec spec/requests/api/v1/authentication_spec.rb
```
Expected: `FAILED — No route matches [GET] "/api/v1/me"` (or 404 from catch-all)

- [ ] **Step 3: Add authenticate to BaseController**

Replace full content of `apps/sheipe_api/app/controllers/api/v1/base_controller.rb`:
```ruby
module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate

      rescue_from StandardError,                        with: :render_internal_error
      rescue_from ActionPolicy::Unauthorized,           with: :render_forbidden
      rescue_from ActiveRecord::RecordInvalid,          with: :render_validation_failed
      rescue_from ActionController::ParameterMissing,   with: :render_bad_request
      rescue_from ActiveRecord::RecordNotFound,         with: :render_not_found

      def not_found
        render_error("not_found", "Not found", nil, :not_found)
      end

      private

      def authenticate
        token = request.headers['Authorization']&.split(' ')&.last
        return render_unauthorized if token.blank?

        session = Session.find_by(access_token: token)
        return render_unauthorized if session.nil? || session.access_token_expires_at < Time.current

        Current.session = session
      end

      def render_unauthorized
        render_error("unauthorized", "Invalid or expired token", nil, :unauthorized)
      end

      def render_not_found(_e)
        render_error("not_found", "Record not found", nil, :not_found)
      end

      def render_bad_request(e)
        render_error("bad_request", e.message, nil, :bad_request)
      end

      def render_validation_failed(e)
        details = e.record.errors.to_hash
        render_error("validation_failed", "Validation failed", details, :unprocessable_entity)
      end

      def render_forbidden(_e)
        render_error("forbidden", "Forbidden", nil, :forbidden)
      end

      def render_internal_error(e)
        Rails.logger.error("#{e.class}: #{e.message}\n#{e.backtrace&.first(5)&.join("\n")}")
        render_error("internal_error", "Internal server error", nil, :internal_server_error)
      end

      def render_error(code, message, details, status)
        render json: { error: { code: code, message: message, details: details } }, status: status
      end
    end
  end
end
```

- [ ] **Step 4: Add stub /me route temporarily to make spec pass**

In `apps/sheipe_api/config/routes.rb`, inside `namespace :v1`:
```ruby
namespace :v1 do
  resource :me, only: [:show]
end
```

And create a stub `apps/sheipe_api/app/controllers/api/v1/me_controller.rb`:
```ruby
module Api
  module V1
    class MeController < BaseController
      def show
        render json: { user: { id: Current.user.id } }
      end
    end
  end
end
```

- [ ] **Step 5: Run authentication spec — verify it passes**

```bash
cd apps/sheipe_api && bundle exec rspec spec/requests/api/v1/authentication_spec.rb
```
Expected: `3 examples, 0 failures`

- [ ] **Step 6: Commit**

```bash
git add apps/sheipe_api/
git commit -m "feat(api): add Bearer token authenticate before_action to BaseController"
```

---

## Task 5: API — Alba serializers

**Files:**
- Create: `apps/sheipe_api/app/serializers/user_serializer.rb`
- Create: `apps/sheipe_api/app/serializers/public_user_serializer.rb`

- [ ] **Step 1: Create UserSerializer**

Create `apps/sheipe_api/app/serializers/user_serializer.rb`:
```ruby
class UserSerializer
  include Alba::Resource

  attributes :id, :name, :email, :role, :created_at
end
```

- [ ] **Step 2: Create PublicUserSerializer**

Create `apps/sheipe_api/app/serializers/public_user_serializer.rb`:
```ruby
class PublicUserSerializer
  include Alba::Resource

  attributes :id, :name, :role, :created_at
end
```

- [ ] **Step 3: Verify serializers load**

```bash
cd apps/sheipe_api && bundle exec rails runner "puts UserSerializer.new(User.new(name: 'A', email: 'a@b.com', password: 'x')).serialize"
```
Expected: JSON with `id, name, email, role, created_at` keys (some nil is fine)

- [ ] **Step 4: Commit**

```bash
git add apps/sheipe_api/app/serializers/
git commit -m "feat(api): add UserSerializer and PublicUserSerializer with Alba"
```

---

## Task 6: API — Auth controllers (register + login)

**Files:**
- Create: `apps/sheipe_api/app/controllers/api/v1/auth/registrations_controller.rb`
- Create: `apps/sheipe_api/app/controllers/api/v1/auth/sessions_controller.rb`
- Create: `apps/sheipe_api/spec/requests/api/v1/auth/registrations_spec.rb`
- Create: `apps/sheipe_api/spec/requests/api/v1/auth/sessions_spec.rb`

- [ ] **Step 1: Write registrations request spec**

Create `apps/sheipe_api/spec/requests/api/v1/auth/registrations_spec.rb`:
```ruby
require 'rails_helper'

RSpec.describe 'POST /api/v1/auth/register', type: :request do
  def register(params)
    post '/api/v1/auth/register', params: params, as: :json
  end

  let(:valid_params) do
    { name: 'Alice', email: 'alice@example.com', password: 'password123',
      password_confirmation: 'password123', role: 'athlete' }
  end

  it 'creates user and returns 201 with tokens and user' do
    register(valid_params)

    expect(response).to have_http_status(:created)
    expect(json_body['access_token']).to be_present
    expect(json_body['refresh_token']).to be_present
    expect(json_body.dig('user', 'email')).to eq('alice@example.com')
    expect(json_body.dig('user', 'role')).to eq('athlete')
    expect(json_body['user'].keys).not_to include('password_digest')
  end

  it 'returns 422 for duplicate email' do
    create(:user, email: 'alice@example.com')
    register(valid_params)

    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_body.dig('error', 'code')).to eq('validation_failed')
  end

  it 'returns 422 for mismatched passwords' do
    register(valid_params.merge(password_confirmation: 'wrong'))

    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'returns 422 for admin role' do
    register(valid_params.merge(role: 'admin'))

    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_body.dig('error', 'code')).to eq('validation_failed')
  end

  it 'returns 422 for missing name' do
    register(valid_params.merge(name: ''))

    expect(response).to have_http_status(:unprocessable_entity)
  end
end
```

- [ ] **Step 2: Write sessions (login) request spec**

Create `apps/sheipe_api/spec/requests/api/v1/auth/sessions_spec.rb`:
```ruby
require 'rails_helper'

RSpec.describe 'POST /api/v1/auth/login', type: :request do
  let!(:user) { create(:user, email: 'alice@example.com', password: 'password123') }

  def login(params)
    post '/api/v1/auth/login', params: params, as: :json
  end

  it 'returns 200 with tokens and user on valid credentials' do
    login(email: 'alice@example.com', password: 'password123')

    expect(response).to have_http_status(:ok)
    expect(json_body['access_token']).to be_present
    expect(json_body['refresh_token']).to be_present
    expect(json_body.dig('user', 'email')).to eq('alice@example.com')
  end

  it 'returns 401 for wrong password' do
    login(email: 'alice@example.com', password: 'wrongpassword')

    expect(response).to have_http_status(:unauthorized)
    expect(json_body.dig('error', 'message')).to eq('Invalid email or password')
  end

  it 'returns 401 for unknown email (same message — no enumeration)' do
    login(email: 'nobody@example.com', password: 'password123')

    expect(response).to have_http_status(:unauthorized)
    expect(json_body.dig('error', 'message')).to eq('Invalid email or password')
  end
end
```

- [ ] **Step 3: Run specs — verify they fail**

```bash
cd apps/sheipe_api && bundle exec rspec spec/requests/api/v1/auth/
```
Expected: `FAILED — No route matches`

- [ ] **Step 4: Create RegistrationsController**

Create `apps/sheipe_api/app/controllers/api/v1/auth/registrations_controller.rb`:
```ruby
module Api
  module V1
    module Auth
      class RegistrationsController < BaseController
        skip_before_action :authenticate

        def create
          user = User.new(registration_params)
          user.save!

          session = user.sessions.create!
          render json: session_response(session, user), status: :created
        end

        private

        def registration_params
          params.require(:registration).permit(:name, :email, :password, :password_confirmation, :role)
        rescue ActionController::ParameterMissing
          params.permit(:name, :email, :password, :password_confirmation, :role)
        end

        def session_response(session, user)
          {
            access_token: session.access_token,
            refresh_token: session.refresh_token,
            user: UserSerializer.new(user).as_json
          }
        end
      end
    end
  end
end
```

- [ ] **Step 5: Create SessionsController**

Create `apps/sheipe_api/app/controllers/api/v1/auth/sessions_controller.rb`:
```ruby
module Api
  module V1
    module Auth
      class SessionsController < BaseController
        skip_before_action :authenticate

        def create
          user = User.find_by("lower(email) = lower(?)", params[:email])
          unless user&.authenticate(params[:password])
            return render_error("unauthorized", "Invalid email or password", nil, :unauthorized)
          end

          session = user.sessions.create!
          render json: session_response(session, user), status: :ok
        end

        private

        def session_response(session, user)
          {
            access_token: session.access_token,
            refresh_token: session.refresh_token,
            user: UserSerializer.new(user).as_json
          }
        end
      end
    end
  end
end
```

- [ ] **Step 6: Add routes**

In `apps/sheipe_api/config/routes.rb`, replace the `namespace :v1` block:
```ruby
namespace :v1 do
  namespace :auth do
    post :register, to: 'registrations#create'
    post :login,    to: 'sessions#create'
    post :refresh,  to: 'refreshes#create'
    delete :logout, to: 'sessions#destroy'
  end

  resource :me, only: [:show, :update]
  resources :users, only: [:show]
end
```

- [ ] **Step 7: Run auth specs — verify they pass**

```bash
cd apps/sheipe_api && bundle exec rspec spec/requests/api/v1/auth/registrations_spec.rb spec/requests/api/v1/auth/sessions_spec.rb
```
Expected: `10 examples, 0 failures`

- [ ] **Step 8: Commit**

```bash
git add apps/sheipe_api/
git commit -m "feat(api): add register and login endpoints"
```

---

## Task 7: API — Auth controllers (refresh + logout)

**Files:**
- Create: `apps/sheipe_api/app/controllers/api/v1/auth/refreshes_controller.rb`
- Modify: `apps/sheipe_api/app/controllers/api/v1/auth/sessions_controller.rb` (add destroy)
- Create: `apps/sheipe_api/spec/requests/api/v1/auth/refreshes_spec.rb`
- Create: `apps/sheipe_api/spec/requests/api/v1/auth/logouts_spec.rb`

- [ ] **Step 1: Write refresh spec**

Create `apps/sheipe_api/spec/requests/api/v1/auth/refreshes_spec.rb`:
```ruby
require 'rails_helper'

RSpec.describe 'POST /api/v1/auth/refresh', type: :request do
  let(:user) { create(:user) }
  let!(:session) { user.sessions.create! }

  it 'returns a new access_token for a valid refresh_token' do
    post '/api/v1/auth/refresh', params: { refresh_token: session.refresh_token }, as: :json

    expect(response).to have_http_status(:ok)
    expect(json_body['access_token']).to be_present
    expect(json_body['access_token']).not_to eq(session.access_token)
  end

  it 'returns 401 for invalid refresh_token' do
    post '/api/v1/auth/refresh', params: { refresh_token: 'invalid' }, as: :json

    expect(response).to have_http_status(:unauthorized)
    expect(json_body.dig('error', 'code')).to eq('unauthorized')
  end

  it 'returns 401 for expired refresh_token' do
    session.update!(refresh_token_expires_at: 1.day.ago)
    post '/api/v1/auth/refresh', params: { refresh_token: session.refresh_token }, as: :json

    expect(response).to have_http_status(:unauthorized)
  end
end
```

- [ ] **Step 2: Write logout spec**

Create `apps/sheipe_api/spec/requests/api/v1/auth/logouts_spec.rb`:
```ruby
require 'rails_helper'

RSpec.describe 'DELETE /api/v1/auth/logout', type: :request do
  let(:user) { create(:user) }
  let!(:session) { user.sessions.create! }
  let(:auth_header) { { 'Authorization' => "Bearer #{session.access_token}" } }

  it 'returns 204 and destroys the session' do
    delete '/api/v1/auth/logout', headers: auth_header

    expect(response).to have_http_status(:no_content)
    expect(Session.find_by(id: session.id)).to be_nil
  end

  it 'returns 401 after logout — token is no longer valid' do
    delete '/api/v1/auth/logout', headers: auth_header
    get '/api/v1/me', headers: auth_header

    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns 401 without Authorization header' do
    delete '/api/v1/auth/logout'

    expect(response).to have_http_status(:unauthorized)
  end
end
```

- [ ] **Step 3: Run specs — verify they fail**

```bash
cd apps/sheipe_api && bundle exec rspec spec/requests/api/v1/auth/refreshes_spec.rb spec/requests/api/v1/auth/logouts_spec.rb
```
Expected: `FAILED — uninitialized constant` or routing error

- [ ] **Step 4: Create RefreshesController**

Create `apps/sheipe_api/app/controllers/api/v1/auth/refreshes_controller.rb`:
```ruby
module Api
  module V1
    module Auth
      class RefreshesController < BaseController
        skip_before_action :authenticate

        def create
          session = Session.find_by(refresh_token: params[:refresh_token])

          if session.nil? || session.refresh_token_expires_at < Time.current
            return render_error("unauthorized", "Invalid or expired refresh token", nil, :unauthorized)
          end

          session.rotate_access_token!
          render json: { access_token: session.access_token }, status: :ok
        end
      end
    end
  end
end
```

- [ ] **Step 5: Add destroy to SessionsController**

Add `destroy` action to `apps/sheipe_api/app/controllers/api/v1/auth/sessions_controller.rb`:
```ruby
module Api
  module V1
    module Auth
      class SessionsController < BaseController
        skip_before_action :authenticate, only: [:create]

        def create
          user = User.find_by("lower(email) = lower(?)", params[:email])
          unless user&.authenticate(params[:password])
            return render_error("unauthorized", "Invalid email or password", nil, :unauthorized)
          end

          session = user.sessions.create!
          render json: session_response(session, user), status: :ok
        end

        def destroy
          Current.session.destroy
          head :no_content
        end

        private

        def session_response(session, user)
          {
            access_token: session.access_token,
            refresh_token: session.refresh_token,
            user: UserSerializer.new(user).as_json
          }
        end
      end
    end
  end
end
```

- [ ] **Step 6: Run refresh + logout specs**

```bash
cd apps/sheipe_api && bundle exec rspec spec/requests/api/v1/auth/refreshes_spec.rb spec/requests/api/v1/auth/logouts_spec.rb
```
Expected: `6 examples, 0 failures`

- [ ] **Step 7: Commit**

```bash
git add apps/sheipe_api/
git commit -m "feat(api): add refresh token rotation and logout endpoints"
```

---

## Task 8: API — Me + Users controllers + request specs

**Files:**
- Modify: `apps/sheipe_api/app/controllers/api/v1/me_controller.rb` (replace stub)
- Create: `apps/sheipe_api/app/controllers/api/v1/users_controller.rb`
- Create: `apps/sheipe_api/spec/requests/api/v1/me_spec.rb`
- Create: `apps/sheipe_api/spec/requests/api/v1/users_spec.rb`

- [ ] **Step 1: Write me spec**

Create `apps/sheipe_api/spec/requests/api/v1/me_spec.rb`:
```ruby
require 'rails_helper'

RSpec.describe '/api/v1/me', type: :request do
  let(:user) { create(:user, name: 'Alice', email: 'alice@example.com') }
  let!(:session) { user.sessions.create! }
  let(:auth_header) { { 'Authorization' => "Bearer #{session.access_token}" } }

  describe 'GET /api/v1/me' do
    it 'returns the authenticated user' do
      get '/api/v1/me', headers: auth_header

      expect(response).to have_http_status(:ok)
      expect(json_body['id']).to eq(user.id)
      expect(json_body['email']).to eq('alice@example.com')
      expect(json_body['name']).to eq('Alice')
      expect(json_body.keys).not_to include('password_digest')
    end

    it 'returns 401 without token' do
      get '/api/v1/me'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PATCH /api/v1/me' do
    it 'updates and returns the user' do
      patch '/api/v1/me', params: { name: 'Alice Updated' }, headers: auth_header, as: :json

      expect(response).to have_http_status(:ok)
      expect(json_body['name']).to eq('Alice Updated')
    end

    it 'returns 422 for blank name' do
      patch '/api/v1/me', params: { name: '' }, headers: auth_header, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body.dig('error', 'code')).to eq('validation_failed')
    end
  end
end
```

- [ ] **Step 2: Write users spec**

Create `apps/sheipe_api/spec/requests/api/v1/users_spec.rb`:
```ruby
require 'rails_helper'

RSpec.describe 'GET /api/v1/users/:id', type: :request do
  let(:requester) { create(:user) }
  let!(:requester_session) { requester.sessions.create! }
  let(:auth_header) { { 'Authorization' => "Bearer #{requester_session.access_token}" } }
  let(:target_user) { create(:user, name: 'Bob', email: 'bob@example.com') }

  it 'returns public profile without email' do
    get "/api/v1/users/#{target_user.id}", headers: auth_header

    expect(response).to have_http_status(:ok)
    expect(json_body['name']).to eq('Bob')
    expect(json_body['id']).to eq(target_user.id)
    expect(json_body.keys).not_to include('email')
    expect(json_body.keys).not_to include('password_digest')
  end

  it 'returns 404 for unknown user' do
    get '/api/v1/users/00000000-0000-0000-0000-000000000000', headers: auth_header

    expect(response).to have_http_status(:not_found)
    expect(json_body.dig('error', 'code')).to eq('not_found')
  end

  it 'returns 401 without token' do
    get "/api/v1/users/#{target_user.id}"
    expect(response).to have_http_status(:unauthorized)
  end
end
```

- [ ] **Step 3: Run specs — verify they fail**

```bash
cd apps/sheipe_api && bundle exec rspec spec/requests/api/v1/me_spec.rb spec/requests/api/v1/users_spec.rb
```
Expected: `FAILED — various errors` (stub me_controller returns wrong format)

- [ ] **Step 4: Replace MeController stub with full implementation**

Replace full content of `apps/sheipe_api/app/controllers/api/v1/me_controller.rb`:
```ruby
module Api
  module V1
    class MeController < BaseController
      def show
        render json: UserSerializer.new(Current.user).as_json
      end

      def update
        Current.user.update!(me_params)
        render json: UserSerializer.new(Current.user).as_json
      end

      private

      def me_params
        params.permit(:name)
      end
    end
  end
end
```

- [ ] **Step 5: Create UsersController**

Create `apps/sheipe_api/app/controllers/api/v1/users_controller.rb`:
```ruby
module Api
  module V1
    class UsersController < BaseController
      def show
        user = User.find(params[:id])
        render json: PublicUserSerializer.new(user).as_json
      end
    end
  end
end
```

- [ ] **Step 6: Run specs — verify they pass**

```bash
cd apps/sheipe_api && bundle exec rspec spec/requests/api/v1/me_spec.rb spec/requests/api/v1/users_spec.rb
```
Expected: `7 examples, 0 failures`

- [ ] **Step 7: Run full API test suite**

```bash
cd apps/sheipe_api && bundle exec rspec
```
Expected: All examples passing, 0 failures

- [ ] **Step 8: Commit**

```bash
git add apps/sheipe_api/
git commit -m "feat(api): add GET/PATCH /me and GET /users/:id endpoints"
```

---

## Task 9: Flutter — AuthEvent + User entity

**Files:**
- Create: `apps/sheipe_app/lib/core/network/auth_event.dart`
- Create: `apps/sheipe_app/lib/features/auth/domain/entities/user.dart`

- [ ] **Step 1: Create AuthEvent**

Create `apps/sheipe_app/lib/core/network/auth_event.dart`:
```dart
sealed class AuthEvent {
  const AuthEvent();
}

final class AuthUnauthorized extends AuthEvent {
  const AuthUnauthorized();
}
```

- [ ] **Step 2: Create User entity**

Create `apps/sheipe_app/lib/features/auth/domain/entities/user.dart`:
```dart
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'created_at': createdAt.toIso8601String(),
      };

  User copyWith({String? name}) => User(
        id: id,
        name: name ?? this.name,
        email: email,
        role: role,
        createdAt: createdAt,
      );
}
```

- [ ] **Step 3: Analyze — no errors**

```bash
cd apps/sheipe_app && flutter analyze lib/core/network/auth_event.dart lib/features/auth/domain/entities/user.dart
```
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add apps/sheipe_app/lib/core/network/auth_event.dart apps/sheipe_app/lib/features/auth/domain/entities/user.dart
git commit -m "feat(app): add AuthEvent sealed class and User entity"
```

---

## Task 10: Flutter — AuthLocalDataSource

**Files:**
- Create: `apps/sheipe_app/lib/features/auth/data/local/auth_local_data_source.dart`

- [ ] **Step 1: Write the failing test**

Create `apps/sheipe_app/test/features/auth/data/local/auth_local_data_source_test.dart`:
```dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/features/auth/data/local/auth_local_data_source.dart';
import 'package:sheipe_app/features/auth/domain/entities/user.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late AuthLocalDataSource sut;

  final fakeUser = User(
    id: '123',
    name: 'Alice',
    email: 'alice@example.com',
    role: 'athlete',
    createdAt: DateTime(2026),
  );

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    sut = AuthLocalDataSource(storage: mockStorage);
  });

  group('saveTokens', () {
    test('writes both tokens to storage', () async {
      when(() => mockStorage.write(key: 'auth_access_token', value: 'access123'))
          .thenAnswer((_) async {});
      when(() => mockStorage.write(key: 'auth_refresh_token', value: 'refresh123'))
          .thenAnswer((_) async {});

      await sut.saveTokens(accessToken: 'access123', refreshToken: 'refresh123');

      verify(() => mockStorage.write(key: 'auth_access_token', value: 'access123')).called(1);
      verify(() => mockStorage.write(key: 'auth_refresh_token', value: 'refresh123')).called(1);
    });
  });

  group('clearTokens', () {
    test('deletes access token, refresh token, and user json', () async {
      when(() => mockStorage.delete(key: 'auth_access_token')).thenAnswer((_) async {});
      when(() => mockStorage.delete(key: 'auth_refresh_token')).thenAnswer((_) async {});
      when(() => mockStorage.delete(key: 'auth_user_json')).thenAnswer((_) async {});

      await sut.clearTokens();

      verify(() => mockStorage.delete(key: 'auth_access_token')).called(1);
      verify(() => mockStorage.delete(key: 'auth_refresh_token')).called(1);
      verify(() => mockStorage.delete(key: 'auth_user_json')).called(1);
    });
  });

  group('saveUser / getUser', () {
    test('saves user as JSON and retrieves it', () async {
      final jsonStr = jsonEncode(fakeUser.toJson());
      when(() => mockStorage.write(key: 'auth_user_json', value: jsonStr))
          .thenAnswer((_) async {});
      when(() => mockStorage.read(key: 'auth_user_json'))
          .thenAnswer((_) async => jsonStr);

      await sut.saveUser(fakeUser);
      final result = await sut.getUser();

      expect(result?.id, equals('123'));
      expect(result?.name, equals('Alice'));
    });

    test('returns null when no user stored', () async {
      when(() => mockStorage.read(key: 'auth_user_json')).thenAnswer((_) async => null);
      final result = await sut.getUser();
      expect(result, isNull);
    });
  });

  group('onboarding', () {
    test('isOnboardingSeen returns false when not set', () async {
      when(() => mockStorage.read(key: 'onboarding_seen')).thenAnswer((_) async => null);
      expect(await sut.isOnboardingSeen(), isFalse);
    });

    test('isOnboardingSeen returns true after saveOnboardingSeen', () async {
      when(() => mockStorage.write(key: 'onboarding_seen', value: 'true'))
          .thenAnswer((_) async {});
      when(() => mockStorage.read(key: 'onboarding_seen')).thenAnswer((_) async => 'true');

      await sut.saveOnboardingSeen();
      expect(await sut.isOnboardingSeen(), isTrue);
    });
  });
}
```

- [ ] **Step 2: Run test — verify it fails**

```bash
cd apps/sheipe_app && flutter test test/features/auth/data/local/auth_local_data_source_test.dart
```
Expected: `FAILED — Target file not found`

- [ ] **Step 3: Create AuthLocalDataSource**

Create `apps/sheipe_app/lib/features/auth/data/local/auth_local_data_source.dart`:
```dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource({required FlutterSecureStorage storage})
      : _storage = storage;

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _userJsonKey = 'auth_user_json';
  static const _onboardingSeenKey = 'onboarding_seen';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> saveUser(User user) =>
      _storage.write(key: _userJsonKey, value: jsonEncode(user.toJson()));

  Future<User?> getUser() async {
    final json = await _storage.read(key: _userJsonKey);
    if (json == null) return null;
    return User.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userJsonKey),
    ]);
  }

  Future<void> saveOnboardingSeen() =>
      _storage.write(key: _onboardingSeenKey, value: 'true');

  Future<bool> isOnboardingSeen() async {
    final value = await _storage.read(key: _onboardingSeenKey);
    return value == 'true';
  }
}
```

- [ ] **Step 4: Run test — verify it passes**

```bash
cd apps/sheipe_app && flutter test test/features/auth/data/local/auth_local_data_source_test.dart
```
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add apps/sheipe_app/lib/features/auth/data/local/ apps/sheipe_app/test/features/auth/data/local/
git commit -m "feat(app): add AuthLocalDataSource with SecureStorage"
```

---

## Task 11: Flutter — AuthRemoteDataSource

**Files:**
- Create: `apps/sheipe_app/lib/features/auth/data/remote/auth_remote_data_source.dart`

- [ ] **Step 1: Create AuthRemoteDataSource**

Create `apps/sheipe_app/lib/features/auth/data/remote/auth_remote_data_source.dart`:
```dart
import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';
import '../../../../core/network/api_client.dart';

typedef AuthTokens = ({String accessToken, String refreshToken});
typedef AuthResult = ({AuthTokens tokens, User user});

class AuthRemoteDataSource {
  const AuthRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _apiClient.dio.post(
      '/api/v1/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'role': role,
      },
    );
    return _parseResult(response.data as Map<String, dynamic>);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.dio.post(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
    );
    return _parseResult(response.data as Map<String, dynamic>);
  }

  Future<String> refresh({required String refreshToken}) async {
    final response = await _apiClient.dio.post(
      '/api/v1/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return (response.data as Map<String, dynamic>)['access_token'] as String;
  }

  Future<void> logout() async {
    await _apiClient.dio.delete('/api/v1/auth/logout');
  }

  Future<User> getMe() async {
    final response = await _apiClient.dio.get('/api/v1/me');
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<User> updateMe({required String name}) async {
    final response = await _apiClient.dio.patch(
      '/api/v1/me',
      data: {'name': name},
    );
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  AuthResult _parseResult(Map<String, dynamic> data) {
    final tokens = (
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
    final user = User.fromJson(data['user'] as Map<String, dynamic>);
    return (tokens: tokens, user: user);
  }
}
```

- [ ] **Step 2: Analyze**

```bash
cd apps/sheipe_app && flutter analyze lib/features/auth/data/remote/auth_remote_data_source.dart
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/features/auth/data/remote/
git commit -m "feat(app): add AuthRemoteDataSource"
```

---

## Task 12: Flutter — AuthRepository

**Files:**
- Create: `apps/sheipe_app/lib/features/auth/data/repositories/auth_repository.dart`

- [ ] **Step 1: Write the failing test**

Create `apps/sheipe_app/test/features/auth/data/repositories/auth_repository_test.dart`:
```dart
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/network/auth_event.dart';
import 'package:sheipe_app/features/auth/data/local/auth_local_data_source.dart';
import 'package:sheipe_app/features/auth/data/remote/auth_remote_data_source.dart';
import 'package:sheipe_app/features/auth/data/repositories/auth_repository.dart';
import 'package:sheipe_app/features/auth/domain/entities/user.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;
  late StreamController<AuthEvent> controller;
  late AuthRepository sut;

  final fakeUser = User(
    id: '1', name: 'Alice', email: 'a@b.com', role: 'athlete',
    createdAt: DateTime(2026),
  );
  final fakeTokens = (accessToken: 'acc', refreshToken: 'ref');
  final fakeResult = (tokens: fakeTokens, user: fakeUser);

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    controller = StreamController<AuthEvent>.broadcast();
    sut = AuthRepository(remote: mockRemote, local: mockLocal, authEvents: controller.stream);
  });

  tearDown(() => controller.close());

  group('login', () {
    test('saves tokens and user, returns user', () async {
      when(() => mockRemote.login(email: 'a@b.com', password: 'pass'))
          .thenAnswer((_) async => fakeResult);
      when(() => mockLocal.saveTokens(accessToken: 'acc', refreshToken: 'ref'))
          .thenAnswer((_) async {});
      when(() => mockLocal.saveUser(fakeUser)).thenAnswer((_) async {});

      final result = await sut.login(email: 'a@b.com', password: 'pass');

      expect(result, equals(fakeUser));
      verify(() => mockLocal.saveTokens(accessToken: 'acc', refreshToken: 'ref')).called(1);
      verify(() => mockLocal.saveUser(fakeUser)).called(1);
    });
  });

  group('logout', () {
    test('clears tokens even if remote call throws', () async {
      when(() => mockRemote.logout()).thenThrow(Exception('network error'));
      when(() => mockLocal.clearTokens()).thenAnswer((_) async {});

      await sut.logout();

      verify(() => mockLocal.clearTokens()).called(1);
    });
  });

  group('checkAuth', () {
    test('returns user when token and user exist in storage', () async {
      when(() => mockLocal.getAccessToken()).thenAnswer((_) async => 'token');
      when(() => mockLocal.getUser()).thenAnswer((_) async => fakeUser);

      final result = await sut.checkAuth();

      expect(result, equals(fakeUser));
    });

    test('returns null when no token in storage', () async {
      when(() => mockLocal.getAccessToken()).thenAnswer((_) async => null);

      final result = await sut.checkAuth();

      expect(result, isNull);
    });
  });
}
```

- [ ] **Step 2: Run test — verify it fails**

```bash
cd apps/sheipe_app && flutter test test/features/auth/data/repositories/auth_repository_test.dart
```
Expected: `FAILED — Target file not found`

- [ ] **Step 3: Create AuthRepository**

Create `apps/sheipe_app/lib/features/auth/data/repositories/auth_repository.dart`:
```dart
import '../../../core/network/auth_event.dart';
import '../local/auth_local_data_source.dart';
import '../remote/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';

class AuthRepository {
  const AuthRepository({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required Stream<AuthEvent> authEvents,
  })  : _remote = remote,
        _local = local,
        authEvents = authEvents;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final Stream<AuthEvent> authEvents;

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final result = await _remote.register(
        name: name, email: email, password: password, role: role);
    await _local.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken);
    await _local.saveUser(result.user);
    return result.user;
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    final result = await _remote.login(email: email, password: password);
    await _local.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken);
    await _local.saveUser(result.user);
    return result.user;
  }

  Future<void> logout() async {
    try {
      await _remote.logout();
    } catch (_) {}
    await _local.clearTokens();
  }

  Future<User?> checkAuth() async {
    final token = await _local.getAccessToken();
    if (token == null) return null;
    return _local.getUser();
  }

  Future<User> updateMe({required String name}) async {
    final user = await _remote.updateMe(name: name);
    await _local.saveUser(user);
    return user;
  }

  Future<void> markOnboardingSeen() => _local.saveOnboardingSeen();
  Future<bool> isOnboardingSeen() => _local.isOnboardingSeen();
}
```

- [ ] **Step 4: Run test — verify it passes**

```bash
cd apps/sheipe_app && flutter test test/features/auth/data/repositories/auth_repository_test.dart
```
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add apps/sheipe_app/lib/features/auth/data/repositories/ apps/sheipe_app/test/features/auth/data/repositories/
git commit -m "feat(app): add AuthRepository"
```

---

## Task 13: Flutter — Rewrite AuthInterceptor

**Files:**
- Modify: `apps/sheipe_app/lib/core/network/interceptors/auth_interceptor.dart`

- [ ] **Step 1: Rewrite AuthInterceptor**

Replace full content of `apps/sheipe_app/lib/core/network/interceptors/auth_interceptor.dart`:
```dart
import 'dart:async';
import 'package:dio/dio.dart';
import '../auth_event.dart';
import '../../features/auth/data/local/auth_local_data_source.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  AuthInterceptor({
    required AuthLocalDataSource localDataSource,
    required Dio refreshDio,
    required Sink<AuthEvent> authEventSink,
  })  : _local = localDataSource,
        _refreshDio = refreshDio,
        _authEventSink = authEventSink;

  final AuthLocalDataSource _local;
  final Dio _refreshDio;
  final Sink<AuthEvent> _authEventSink;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _local.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final refreshToken = await _local.getRefreshToken();
    if (refreshToken == null) {
      _authEventSink.add(const AuthUnauthorized());
      handler.next(err);
      return;
    }

    try {
      final response = await _refreshDio.post(
        '/api/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final newAccessToken =
          (response.data as Map<String, dynamic>)['access_token'] as String;

      await _local.saveTokens(
          accessToken: newAccessToken, refreshToken: refreshToken);

      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _refreshDio.fetch(retryOptions);
      handler.resolve(retryResponse);
    } catch (_) {
      await _local.clearTokens();
      _authEventSink.add(const AuthUnauthorized());
      handler.next(err);
    }
  }
}
```

- [ ] **Step 2: Analyze**

```bash
cd apps/sheipe_app && flutter analyze lib/core/network/interceptors/auth_interceptor.dart
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/core/network/interceptors/auth_interceptor.dart
git commit -m "feat(app): rewrite AuthInterceptor with QueuedInterceptorsWrapper and refresh token support"
```

---

## Task 14: Flutter — Rewrite AuthState + AuthViewModel

**Files:**
- Modify: `apps/sheipe_app/lib/features/auth/presentation/viewmodels/auth_state.dart`
- Modify: `apps/sheipe_app/lib/features/auth/presentation/viewmodels/auth_view_model.dart`

- [ ] **Step 1: Write AuthViewModel tests**

Create `apps/sheipe_app/test/features/auth/presentation/viewmodels/auth_view_model_test.dart`:
```dart
import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:sheipe_app/core/network/auth_event.dart';
import 'package:sheipe_app/features/auth/data/repositories/auth_repository.dart';
import 'package:sheipe_app/features/auth/domain/entities/user.dart';
import 'package:sheipe_app/features/auth/presentation/viewmodels/auth_view_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late StreamController<AuthEvent> authEventController;

  final fakeUser = User(
    id: '1', name: 'Alice', email: 'a@b.com', role: 'athlete',
    createdAt: DateTime(2026),
  );

  setUp(() {
    mockRepo = MockAuthRepository();
    authEventController = StreamController<AuthEvent>.broadcast();
    when(() => mockRepo.authEvents).thenAnswer((_) => authEventController.stream);
  });

  tearDown(() => authEventController.close());

  AuthViewModel buildViewModel() => AuthViewModel(repository: mockRepo);

  group('checkAuthStatus', () {
    blocTest<AuthViewModel, AuthState>(
      'emits Authenticated when token and user exist',
      build: () {
        when(() => mockRepo.checkAuth()).thenAnswer((_) async => fakeUser);
        return buildViewModel();
      },
      act: (vm) => vm.checkAuthStatus(),
      expect: () => [AuthAuthenticated(fakeUser)],
    );

    blocTest<AuthViewModel, AuthState>(
      'emits Unauthenticated when no token',
      build: () {
        when(() => mockRepo.checkAuth()).thenAnswer((_) async => null);
        return buildViewModel();
      },
      act: (vm) => vm.checkAuthStatus(),
      expect: () => [const AuthUnauthenticated()],
    );
  });

  group('login', () {
    blocTest<AuthViewModel, AuthState>(
      'emits Loading then Authenticated on success',
      build: () {
        when(() => mockRepo.login(email: 'a@b.com', password: 'pass'))
            .thenAnswer((_) async => fakeUser);
        return buildViewModel();
      },
      act: (vm) => vm.login(email: 'a@b.com', password: 'pass'),
      expect: () => [const AuthLoading(), AuthAuthenticated(fakeUser)],
    );

    blocTest<AuthViewModel, AuthState>(
      'emits Loading then AuthError on DioException',
      build: () {
        when(() => mockRepo.login(email: 'a@b.com', password: 'wrong'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(),
              response: Response(
                requestOptions: RequestOptions(),
                statusCode: 401,
                data: {'error': {'message': 'Invalid email or password'}},
              ),
            ));
        return buildViewModel();
      },
      act: (vm) => vm.login(email: 'a@b.com', password: 'wrong'),
      expect: () => [
        const AuthLoading(),
        const AuthError('Invalid email or password'),
      ],
    );
  });

  group('register', () {
    blocTest<AuthViewModel, AuthState>(
      'emits Loading then Authenticated on success',
      build: () {
        when(() => mockRepo.register(
              name: 'Alice', email: 'a@b.com',
              password: 'pass', role: 'athlete',
            )).thenAnswer((_) async => fakeUser);
        return buildViewModel();
      },
      act: (vm) => vm.register(
        name: 'Alice', email: 'a@b.com', password: 'pass', role: 'athlete',
      ),
      expect: () => [const AuthLoading(), AuthAuthenticated(fakeUser)],
    );
  });

  group('logout', () {
    blocTest<AuthViewModel, AuthState>(
      'emits Unauthenticated',
      build: () {
        when(() => mockRepo.logout()).thenAnswer((_) async {});
        return buildViewModel();
      },
      act: (vm) => vm.logout(),
      expect: () => [const AuthUnauthenticated()],
    );
  });

  group('auth event stream', () {
    blocTest<AuthViewModel, AuthState>(
      'emits Unauthenticated when unauthorized event received',
      build: () {
        when(() => mockRepo.logout()).thenAnswer((_) async {});
        return buildViewModel();
      },
      act: (vm) => authEventController.add(const AuthUnauthorized()),
      wait: const Duration(milliseconds: 50),
      expect: () => [const AuthUnauthenticated()],
    );
  });
}
```

- [ ] **Step 2: Run tests — verify they fail**

```bash
cd apps/sheipe_app && flutter test test/features/auth/presentation/viewmodels/auth_view_model_test.dart
```
Expected: `FAILED — type errors or missing classes`

- [ ] **Step 3: Rewrite AuthState**

Replace full content of `apps/sheipe_app/lib/features/auth/presentation/viewmodels/auth_state.dart`:
```dart
part of 'auth_view_model.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final User user;

  @override
  bool operator ==(Object other) =>
      other is AuthAuthenticated && other.user.id == user.id;

  @override
  int get hashCode => user.id.hashCode;
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      other is AuthError && other.message == message;

  @override
  int get hashCode => message.hashCode;
}
```

- [ ] **Step 4: Rewrite AuthViewModel**

Replace full content of `apps/sheipe_app/lib/features/auth/presentation/viewmodels/auth_view_model.dart`:
```dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/auth_event.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

part 'auth_state.dart';

class AuthViewModel extends Cubit<AuthState> {
  AuthViewModel({required AuthRepository repository})
      : _repository = repository,
        super(const AuthInitial()) {
    _authEventSub = repository.authEvents.listen((_) => logout());
  }

  final AuthRepository _repository;
  late final StreamSubscription<AuthEvent> _authEventSub;

  @override
  Future<void> close() {
    _authEventSub.cancel();
    return super.close();
  }

  Future<void> checkAuthStatus() async {
    final user = await _repository.checkAuth();
    emit(user != null ? AuthAuthenticated(user) : const AuthUnauthenticated());
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(email: email, password: password);
      emit(AuthAuthenticated(user));
    } on DioException catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.register(
          name: name, email: email, password: password, role: role);
      emit(AuthAuthenticated(user));
    } on DioException catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> updateProfile({required String name}) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.updateMe(name: name);
      emit(AuthAuthenticated(user));
    } on DioException catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  String _extractMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      return (data['error']?['message'] as String?) ?? 'An error occurred';
    }
    return 'An error occurred';
  }
}
```

- [ ] **Step 5: Run tests — verify they pass**

```bash
cd apps/sheipe_app && flutter test test/features/auth/presentation/viewmodels/auth_view_model_test.dart
```
Expected: `All tests passed!`

- [ ] **Step 6: Commit**

```bash
git add apps/sheipe_app/lib/features/auth/presentation/viewmodels/ apps/sheipe_app/test/features/auth/presentation/viewmodels/
git commit -m "feat(app): rewrite AuthState and AuthViewModel with full auth flows"
```

---

## Task 15: Flutter — Update ServiceLocator

**Files:**
- Modify: `apps/sheipe_app/lib/core/di/service_locator.dart`

- [ ] **Step 1: Rewrite ServiceLocator**

Replace full content of `apps/sheipe_app/lib/core/di/service_locator.dart`:
```dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/auth_event.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../storage/app_database.dart';
import '../../app_router.dart';
import '../../features/auth/data/local/auth_local_data_source.dart';
import '../../features/auth/data/remote/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/viewmodels/auth_view_model.dart';

final sl = GetIt.instance;

class ServiceLocator {
  ServiceLocator._(); // coverage:ignore-line

  static Future<void> init() async {
    const storage = FlutterSecureStorage();
    final authEventController = StreamController<AuthEvent>.broadcast();

    sl.registerLazySingleton<AppDatabase>(
      () => AppDatabase(), // coverage:ignore-line
      dispose: (db) => db.close(), // coverage:ignore-line
    );

    final local = AuthLocalDataSource(storage: storage);
    sl.registerSingleton<AuthLocalDataSource>(local);

    final baseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:3000',
    );

    final refreshDio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    ));

    sl.registerLazySingleton<AuthInterceptor>(
      () => AuthInterceptor(
        localDataSource: local,
        refreshDio: refreshDio,
        authEventSink: authEventController.sink,
      ),
    );

    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(
        baseUrl: baseUrl,
        authInterceptor: sl<AuthInterceptor>(),
      ),
    );

    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(apiClient: sl<ApiClient>()),
    );

    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        remote: sl<AuthRemoteDataSource>(),
        local: local,
        authEvents: authEventController.stream,
      ),
    );

    sl.registerLazySingleton<AuthViewModel>(
      () => AuthViewModel(repository: sl<AuthRepository>()),
    );

    sl.registerLazySingleton<AppRouter>(
      () => AppRouter(authViewModel: sl<AuthViewModel>()),
    );
  }
}
```

- [ ] **Step 2: Analyze**

```bash
cd apps/sheipe_app && flutter analyze lib/core/di/service_locator.dart
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/core/di/service_locator.dart
git commit -m "feat(app): rewire ServiceLocator with AuthRepository + StreamController"
```

---

## Task 16: Flutter — Auth screens (Splash + Onboarding)

**Files:**
- Create: `apps/sheipe_app/lib/features/auth/presentation/screens/splash_screen.dart`
- Create: `apps/sheipe_app/lib/features/auth/presentation/screens/onboarding_screen.dart`

- [ ] **Step 1: Create SplashScreen**

Create `apps/sheipe_app/lib/features/auth/presentation/screens/splash_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart';
import '../../data/local/auth_local_data_source.dart';
import '../viewmodels/auth_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await context.read<AuthViewModel>().checkAuthStatus();
    if (!mounted) return;

    final state = context.read<AuthViewModel>().state;
    if (state is AuthAuthenticated) return; // GoRouter redirect handles navigation

    final onboardingSeen = await sl<AuthLocalDataSource>().isOnboardingSeen();
    if (!mounted) return;

    context.go(onboardingSeen ? '/auth/login' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

- [ ] **Step 2: Create OnboardingScreen**

Create `apps/sheipe_app/lib/features/auth/presentation/screens/onboarding_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart';
import '../../data/local/auth_local_data_source.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _proceed(BuildContext context, String route) async {
    await sl<AuthLocalDataSource>().saveOnboardingSeen();
    if (context.mounted) context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Welcome to Sheipe',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Track your workouts, connect with trainers,\nand achieve your goals.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => _proceed(context, '/auth/register'),
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _proceed(context, '/auth/login'),
                child: const Text('I already have an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Analyze**

```bash
cd apps/sheipe_app && flutter analyze lib/features/auth/presentation/screens/splash_screen.dart lib/features/auth/presentation/screens/onboarding_screen.dart
```
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add apps/sheipe_app/lib/features/auth/presentation/screens/splash_screen.dart apps/sheipe_app/lib/features/auth/presentation/screens/onboarding_screen.dart
git commit -m "feat(app): add SplashScreen and OnboardingScreen"
```

---

## Task 17: Flutter — LoginScreen

**Files:**
- Create: `apps/sheipe_app/lib/features/auth/presentation/screens/login_screen.dart`

- [ ] **Step 1: Create LoginScreen**

Create `apps/sheipe_app/lib/features/auth/presentation/screens/login_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthViewModel>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocBuilder<AuthViewModel, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is AuthError) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.message,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v?.isEmpty ?? true) ? 'Email is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (v) =>
                        (v?.isEmpty ?? true) ? 'Password is required' : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: state is AuthLoading ? null : _submit,
                    child: state is AuthLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () => context.go('/auth/register'),
                    child: const Text("Don't have an account? Register"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 2: Analyze**

```bash
cd apps/sheipe_app && flutter analyze lib/features/auth/presentation/screens/login_screen.dart
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/features/auth/presentation/screens/login_screen.dart
git commit -m "feat(app): add LoginScreen"
```

---

## Task 18: Flutter — RegisterScreen (2-step)

**Files:**
- Create: `apps/sheipe_app/lib/features/auth/presentation/screens/register_screen.dart`

- [ ] **Step 1: Create RegisterScreen**

Create `apps/sheipe_app/lib/features/auth/presentation/screens/register_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _pageController = PageController();
  final _step1Key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'athlete';

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToStep2() {
    if (_step1Key.currentState?.validate() ?? false) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submit() {
    context.read<AuthViewModel>().register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: BackButton(onPressed: () {
          if (_pageController.page == 1) {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            context.go('/auth/login');
          }
        }),
      ),
      body: BlocBuilder<AuthViewModel, AuthState>(
        builder: (context, state) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _Step1(
                formKey: _step1Key,
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                onNext: _goToStep2,
              ),
              _Step2(
                selectedRole: _selectedRole,
                onRoleChanged: (role) => setState(() => _selectedRole = role),
                onSubmit: state is AuthLoading ? null : _submit,
                error: state is AuthError ? state.message : null,
                isLoading: state is AuthLoading,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Step1 extends StatelessWidget {
  const _Step1({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onNext,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Your details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full name'),
              textInputAction: TextInputAction.next,
              validator: (v) => (v?.isEmpty ?? true) ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (v) => (v?.isEmpty ?? true) ? 'Email is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => onNext(),
              validator: (v) =>
                  (v?.isEmpty ?? true) ? 'Password is required' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onNext, child: const Text('Next')),
          ],
        ),
      ),
    );
  }
}

class _Step2 extends StatelessWidget {
  const _Step2({
    required this.selectedRole,
    required this.onRoleChanged,
    required this.onSubmit,
    required this.isLoading,
    this.error,
  });

  final String selectedRole;
  final ValueChanged<String> onRoleChanged;
  final VoidCallback? onSubmit;
  final bool isLoading;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('I am a...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          _RoleTile(
            label: 'Athlete',
            subtitle: 'I want to track and log my workouts',
            value: 'athlete',
            selected: selectedRole == 'athlete',
            onTap: () => onRoleChanged('athlete'),
          ),
          const SizedBox(height: 12),
          _RoleTile(
            label: 'Trainer',
            subtitle: 'I manage athletes and assign training plans',
            value: 'trainer',
            selected: selectedRole == 'trainer',
            onTap: () => onRoleChanged('trainer'),
          ),
          const Spacer(),
          if (error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(error!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer)),
            ),
            const SizedBox(height: 16),
          ],
          FilledButton(
            onPressed: onSubmit,
            child: isLoading
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Create Account'),
          ),
        ],
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Analyze**

```bash
cd apps/sheipe_app && flutter analyze lib/features/auth/presentation/screens/register_screen.dart
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/features/auth/presentation/screens/register_screen.dart
git commit -m "feat(app): add RegisterScreen with 2-step PageView"
```

---

## Task 19: Flutter — ProfileScreen + EditProfileScreen

**Files:**
- Create: `apps/sheipe_app/lib/features/auth/presentation/screens/profile_screen.dart`
- Create: `apps/sheipe_app/lib/features/auth/presentation/screens/edit_profile_screen.dart`

- [ ] **Step 1: Create ProfileScreen**

Create `apps/sheipe_app/lib/features/auth/presentation/screens/profile_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthViewModel, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = state.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.go('/profile/edit'),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 48),
              _InitialsAvatar(name: user.name),
              const SizedBox(height: 16),
              Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              _RoleBadge(role: user.role),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: OutlinedButton(
                  onPressed: () => context.read<AuthViewModel>().logout(),
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 48,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        initial,
        style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        role.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}
```

- [ ] **Step 2: Create EditProfileScreen**

Create `apps/sheipe_app/lib/features/auth/presentation/screens/edit_profile_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final user = switch (context.read<AuthViewModel>().state) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await context.read<AuthViewModel>().updateProfile(
          name: _nameController.text.trim(),
        );
    if (mounted && context.read<AuthViewModel>().state is! AuthError) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocBuilder<AuthViewModel, AuthState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is AuthError) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.message,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (v) =>
                        (v?.isEmpty ?? true) ? "Name can't be blank" : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: state is AuthLoading ? null : _submit,
                    child: state is AuthLoading
                        ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 3: Analyze**

```bash
cd apps/sheipe_app && flutter analyze lib/features/auth/presentation/screens/profile_screen.dart lib/features/auth/presentation/screens/edit_profile_screen.dart
```
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add apps/sheipe_app/lib/features/auth/presentation/screens/profile_screen.dart apps/sheipe_app/lib/features/auth/presentation/screens/edit_profile_screen.dart
git commit -m "feat(app): add ProfileScreen and EditProfileScreen"
```

---

## Task 20: Flutter — Update AppRouter

**Files:**
- Modify: `apps/sheipe_app/lib/app_router.dart`

- [ ] **Step 1: Rewrite AppRouter with all routes**

Replace full content of `apps/sheipe_app/lib/app_router.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/onboarding_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/auth/presentation/screens/edit_profile_screen.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'shared/widgets/main_shell.dart';

class AppRouter {
  AppRouter({required AuthViewModel authViewModel})
      : _authViewModel = authViewModel {
    _router = GoRouter(
      initialLocation: '/',
      refreshListenable: _AuthListenable(authViewModel),
      redirect: _redirect,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider.value(
            value: _authViewModel,
            child: const SplashScreen(),
          ),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/auth/login',
          builder: (context, state) => BlocProvider.value(
            value: _authViewModel,
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: '/auth/register',
          builder: (context, state) => BlocProvider.value(
            value: _authViewModel,
            child: const RegisterScreen(),
          ),
        ),
        ShellRoute(
          builder: (context, state, child) => BlocProvider.value(
            value: _authViewModel,
            child: MainShell(child: child),
          ),
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: '/profile/edit',
              builder: (context, state) => const EditProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }

  final AuthViewModel _authViewModel;
  late final GoRouter _router;

  GoRouter get router => _router;

  String? _redirect(BuildContext context, GoRouterState state) {
    final isAuthenticated = _authViewModel.state is AuthAuthenticated;
    final location = state.matchedLocation;

    const authRoutes = ['/auth/login', '/auth/register'];
    const publicRoutes = ['/', '/onboarding'];

    if (!isAuthenticated && !authRoutes.contains(location) && !publicRoutes.contains(location)) {
      return '/auth/login';
    }
    if (isAuthenticated && authRoutes.contains(location)) {
      return '/profile';
    }
    return null;
  }
}

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(AuthViewModel viewModel) {
    _subscription = viewModel.stream.listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

- [ ] **Step 2: Analyze**

```bash
cd apps/sheipe_app && flutter analyze lib/app_router.dart
```
Expected: `No issues found!`

- [ ] **Step 3: Run full Flutter analyze**

```bash
cd apps/sheipe_app && flutter analyze
```
Expected: `No issues found!` (or only style warnings, no errors)

- [ ] **Step 4: Run all Flutter tests**

```bash
cd apps/sheipe_app && flutter test
```
Expected: All tests pass

- [ ] **Step 5: Commit**

```bash
git add apps/sheipe_app/lib/app_router.dart
git commit -m "feat(app): update AppRouter with all Phase 1 routes"
```

---

## Task 21: Update OpenSpec artifacts

**Files:**
- Modify: `openspec/changes/phase-1-auth-profile/design.md`
- Modify: `openspec/changes/phase-1-auth-profile/specs/user-auth/spec.md`
- Modify: `openspec/changes/phase-1-auth-profile/tasks.md`

- [ ] **Step 1: Update design.md to reflect access+refresh tokens**

In `openspec/changes/phase-1-auth-profile/design.md`, update Decision 2 to replace the single-token section with:

```markdown
### 2 — Dual tokens: access_token (24h) + refresh_token (30d)

`Session` stores two UUIDs: `access_token` (expires 24h, used in every Bearer request) and `refresh_token` (expires 30d, used only to rotate access_token).

`POST /auth/refresh` accepts `refresh_token` in body → generates new `access_token` → returns `{ access_token }`. Flutter `AuthInterceptor` handles this automatically via `QueuedInterceptorsWrapper` on 401.

**Alternative considered**: Single opaque token — simpler, but access_token rotates silently in background without re-login, improving security on long-lived mobile sessions.
```

And add Decision 6:
```markdown
### 6 — AuthInterceptor decoupled from AuthViewModel via Stream

`AuthInterceptor` receives `Sink<AuthEvent>` from `ServiceLocator`. On unrecoverable 401 (refresh also fails), pushes `AuthUnauthorized` event. `AuthViewModel` subscribes to the stream in its constructor. Removes the circular dependency present in the scaffold (interceptor imported viewmodel).
```

- [ ] **Step 2: Update specs to include refresh token scenario**

In `openspec/changes/phase-1-auth-profile/specs/user-auth/spec.md`, add under the `Bearer token authentication` requirement:

```markdown
#### Scenario: Expired access_token with valid refresh_token
- **WHEN** an API call returns 401 and a valid refresh_token exists in storage
- **THEN** `AuthInterceptor` calls `POST /auth/refresh`, saves new access_token, retries original request transparently

#### Scenario: Both tokens expired
- **WHEN** an API call returns 401 and refresh also fails with 401
- **THEN** `AuthInterceptor` clears all tokens, pushes `AuthUnauthorized` to stream, `AuthViewModel` emits `AuthUnauthenticated`
```

- [ ] **Step 3: Replace tasks.md with updated version**

Replace full content of `openspec/changes/phase-1-auth-profile/tasks.md` to match this plan's task list (mark completed tasks as `[x]` as you go). At minimum, update session model tasks to reflect dual-token schema and add the `POST /auth/refresh` task.

- [ ] **Step 4: Commit OpenSpec updates**

```bash
git add openspec/changes/phase-1-auth-profile/
git commit -m "docs(openspec): update phase-1-auth-profile artifacts to reflect refined design"
```

---

## Self-Review

**Spec coverage check:**

| Spec requirement | Covered in plan |
|---|---|
| User registration (API) | Task 6 |
| User login (API) | Task 6 |
| User logout (API) | Task 7 |
| Bearer token auth (API) | Task 4 |
| Refresh token rotation | Task 7 |
| GET/PATCH /me | Task 8 |
| GET /users/:id | Task 8 |
| User entity (Flutter) | Task 9 |
| AuthLocalDataSource | Task 10 |
| AuthRemoteDataSource | Task 11 |
| AuthRepository (token lifecycle) | Task 12 |
| AuthInterceptor (refresh + stream) | Task 13 |
| AuthState 5 states | Task 14 |
| AuthViewModel (register/login/logout/updateProfile) | Task 14 |
| ServiceLocator rewire | Task 15 |
| SplashScreen (optimistic, onboarding gate) | Task 16 |
| OnboardingScreen (sets flag) | Task 16 |
| LoginScreen (inline error) | Task 17 |
| RegisterScreen (2-step, single call) | Task 18 |
| ProfileScreen (initials avatar, role badge) | Task 19 |
| EditProfileScreen (name only, client validation) | Task 19 |
| AppRouter (all routes, auth redirect) | Task 20 |
| OpenSpec artifact updates | Task 21 |
| AuthViewModel unit tests | Task 14 |
| AuthRepository unit tests | Task 12 |
| AuthLocalDataSource unit tests | Task 10 |
| API request specs (register/login/refresh/logout/me/users) | Tasks 6, 7, 8 |

All requirements covered. No gaps found.

**Type consistency check:**
- `AuthAuthenticated(user)` — defined Task 14, used in Task 20 redirect ✓
- `AuthUnauthorized` (AuthEvent) — defined Task 9, used in Task 13 + Task 14 ✓
- `AuthTokens` record type — defined Task 11, used in Task 11 only ✓
- `AuthLocalDataSource.saveTokens(accessToken:, refreshToken:)` — defined Task 10, called in Tasks 12 + 13 ✓
- `AuthRepository.authEvents` (Stream) — defined Task 12, consumed Task 14 ✓
