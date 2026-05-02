# Phase 2A — Exercise Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** End-to-end Exercise feature for Sheipe — Rails API (CRUD + filters + system seed + ActionPolicy) and Flutter app (offline-first Drift cache, repository + sync foundation, library/detail/form screens) — validating the full offline-first stack with the simplest training entity before Routine and Workout.

**Architecture:** API exposes `/api/v1/exercises` returning system + creator-owned exercises with `muscle_group`/`category`/`query` filters and pagy pagination; ActionPolicy enforces ownership. Flutter writes through Drift first (UI from streams), enqueues sync ops in `SyncOperationsTable`, and a `SyncService` drains the queue against the API. The same sync foundation is reused by Routine and Workout slices.

**Tech Stack:** Rails 8, PostgreSQL (pgcrypto UUIDs), Alba serializers, action_policy, pagy, RSpec + FactoryBot | Flutter, drift, dio, flutter_bloc (Cubit), get_it, uuid, connectivity_plus, mocktail, bloc_test

**Spec sources:**
- `openspec/changes/fase-2-core-treino/specs/exercise-management/spec.md`
- `openspec/changes/fase-2-core-treino/specs/offline-sync/spec.md`
- `openspec/changes/fase-2-core-treino/design.md` (decisions 1, 3, 4, 5)

---

## File Map

### Rails API — New files
```
apps/sheipe_api/
├── db/migrate/
│   └── YYYYMMDDXXXXXX_create_exercises.rb
├── db/seeds/
│   └── exercises.rb
├── app/models/
│   └── exercise.rb
├── app/controllers/api/v1/
│   └── exercises_controller.rb
├── app/policies/
│   ├── application_policy.rb
│   └── exercise_policy.rb
├── app/serializers/
│   └── exercise_serializer.rb
├── config/initializers/
│   └── pagy.rb
├── spec/factories/
│   └── exercises.rb
├── spec/models/
│   └── exercise_spec.rb
├── spec/policies/
│   └── exercise_policy_spec.rb
└── spec/requests/api/v1/
    └── exercises_spec.rb
```

### Rails API — Modified files
```
apps/sheipe_api/
├── db/seeds.rb                                   (require seeds/exercises)
├── config/routes.rb                              (add resources :exercises)
└── app/controllers/api/v1/base_controller.rb    (include Pagy::Backend)
```

### Flutter — New files
```
apps/sheipe_app/
├── lib/core/sync/
│   ├── sync_operation.dart
│   ├── sync_handler.dart
│   └── sync_service.dart
├── lib/features/exercise/
│   ├── domain/entities/
│   │   └── exercise.dart
│   ├── data/
│   │   ├── filters/exercise_filters.dart
│   │   ├── local/exercise_local_data_source.dart
│   │   ├── remote/exercise_remote_data_source.dart
│   │   └── repositories/exercise_repository.dart
│   └── presentation/
│       ├── viewmodels/
│       │   ├── exercise_state.dart
│       │   └── exercise_view_model.dart
│       └── screens/
│           ├── exercise_library_screen.dart
│           ├── exercise_detail_screen.dart
│           └── exercise_form_screen.dart
└── test/
    ├── core/sync/sync_service_test.dart
    └── features/exercise/
        ├── data/repositories/exercise_repository_test.dart
        └── presentation/viewmodels/exercise_view_model_test.dart
```

### Flutter — Modified files
```
apps/sheipe_app/
├── pubspec.yaml                                  (add uuid, connectivity_plus)
├── lib/core/storage/app_database.dart            (add ExercisesTable + SyncOperationsTable, schemaVersion bump, MigrationStrategy)
├── lib/core/di/service_locator.dart              (register exercise + sync deps)
├── lib/app_router.dart                           (add /exercises routes)
└── lib/main.dart                                 (start SyncService after auth init)
```

---

## Prerequisites

Before starting Phase A, run from `apps/sheipe_api/`:
```bash
bundle install
```

Before starting Phase B, run from `apps/sheipe_app/`:
```bash
flutter pub get
```

---

# Phase A — Rails API: Exercise

---

### Task A1: Pagy initializer + BaseController include

**Files:**
- Create: `apps/sheipe_api/config/initializers/pagy.rb`
- Modify: `apps/sheipe_api/app/controllers/api/v1/base_controller.rb`

- [ ] **Step 1: Create pagy initializer**

Create `apps/sheipe_api/config/initializers/pagy.rb`:

```ruby
require "pagy"

Pagy::DEFAULT[:limit] = 25
Pagy::DEFAULT[:max_limit] = 100
Pagy::DEFAULT[:page_param] = :page
Pagy::DEFAULT[:limit_param] = :per_page
```

- [ ] **Step 2: Include Pagy::Backend + add current_user helper to BaseController**

Modify `apps/sheipe_api/app/controllers/api/v1/base_controller.rb` — add `include Pagy::Backend` directly under `class BaseController < ApplicationController`, and add `current_user` (so `action_policy` can resolve the authorization context):

```ruby
module Api
  module V1
    class BaseController < ApplicationController
      include Pagy::Backend

      before_action :authenticate
      skip_before_action :authenticate, only: [ :not_found ]
      # ... rest unchanged
```

Also add two private helpers — `current_user` (used by `action_policy` automatically) and `pagy_meta` (for serialized list responses). Append both before the final `def render_error`:

```ruby
      def current_user
        Current.user
      end

      def pagy_meta(pagy)
        {
          page: pagy.page,
          per_page: pagy.limit,
          total_pages: pagy.pages,
          total_count: pagy.count
        }
      end
```

- [ ] **Step 3: Verify boot still works**

Run from `apps/sheipe_api/`:
```bash
bundle exec rails runner 'puts Api::V1::BaseController.ancestors.include?(Pagy::Backend)'
```
Expected output: `true`

- [ ] **Step 4: Commit**

```bash
git add apps/sheipe_api/config/initializers/pagy.rb apps/sheipe_api/app/controllers/api/v1/base_controller.rb
git commit -m "chore(api): add pagy initializer and BaseController integration"
```

---

### Task A2: Exercise migration

**Files:**
- Create: `apps/sheipe_api/db/migrate/<timestamp>_create_exercises.rb`

- [ ] **Step 1: Generate migration**

Run from `apps/sheipe_api/`:
```bash
bin/rails generate migration CreateExercises
```

This creates a file at `db/migrate/<timestamp>_create_exercises.rb`. Note the timestamp prefix.

- [ ] **Step 2: Replace migration body**

Open the generated file and replace its contents with:

```ruby
class CreateExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :exercises, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :name, null: false
      t.text :description
      t.string :muscle_group, null: false
      t.string :category, null: false
      t.boolean :is_system, null: false, default: false
      t.references :creator, type: :uuid, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end

    add_index :exercises, :muscle_group
    add_index :exercises, :category
    add_index :exercises, :is_system
    add_index :exercises, "lower(name)", name: "index_exercises_on_lower_name"
  end
end
```

- [ ] **Step 3: Run migration**

```bash
bin/rails db:migrate
```
Expected output ends with `== CreateExercises: migrated`. Verify `db/schema.rb` now has an `exercises` table with the columns above.

- [ ] **Step 4: Commit**

```bash
git add apps/sheipe_api/db/migrate apps/sheipe_api/db/schema.rb
git commit -m "feat(api): add exercises migration with UUID PK and indexes"
```

---

### Task A3: Exercise model + factory + model spec

**Files:**
- Create: `apps/sheipe_api/spec/models/exercise_spec.rb`
- Create: `apps/sheipe_api/app/models/exercise.rb`
- Create: `apps/sheipe_api/spec/factories/exercises.rb`

- [ ] **Step 1: Write failing model spec**

Create `apps/sheipe_api/spec/models/exercise_spec.rb`:

```ruby
require 'rails_helper'

RSpec.describe Exercise, type: :model do
  subject(:exercise) { build(:exercise) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(exercise).to be_valid
    end

    it 'is invalid with blank name' do
      exercise.name = ''
      expect(exercise).not_to be_valid
      expect(exercise.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with unknown muscle_group' do
      expect { exercise.muscle_group = 'fingers' }
        .to raise_error(ArgumentError, /'fingers' is not a valid muscle_group/)
    end

    it 'is invalid with unknown category' do
      expect { exercise.category = 'plyometric' }
        .to raise_error(ArgumentError, /'plyometric' is not a valid category/)
    end

    it 'accepts every defined muscle_group value' do
      Exercise.muscle_groups.each_key do |value|
        exercise.muscle_group = value
        expect(exercise).to be_valid, "expected #{value} to be valid"
      end
    end

    it 'accepts every defined category value' do
      Exercise.categories.each_key do |value|
        exercise.category = value
        expect(exercise).to be_valid, "expected #{value} to be valid"
      end
    end
  end

  describe 'defaults' do
    it 'defaults is_system to false' do
      expect(Exercise.new.is_system).to be(false)
    end
  end

  describe 'associations' do
    it 'allows nil creator (system exercises)' do
      system_exercise = build(:exercise, :system)
      expect(system_exercise).to be_valid
      expect(system_exercise.creator).to be_nil
    end

    it 'belongs to a creator when present' do
      user = create(:user)
      ex = create(:exercise, creator: user)
      expect(ex.creator).to eq(user)
    end
  end

  describe 'scopes' do
    let!(:system_ex) { create(:exercise, :system) }
    let!(:user_a) { create(:user) }
    let!(:user_b) { create(:user) }
    let!(:custom_a) { create(:exercise, creator: user_a) }
    let!(:custom_b) { create(:exercise, creator: user_b) }

    it 'visible_to returns system + the user own exercises' do
      result = Exercise.visible_to(user_a)
      expect(result).to contain_exactly(system_ex, custom_a)
    end
  end
end
```

- [ ] **Step 2: Run spec — verify it fails**

```bash
bundle exec rspec spec/models/exercise_spec.rb
```
Expected: failure with `uninitialized constant Exercise` or `Factory not registered: exercise`.

- [ ] **Step 3: Create factory**

Create `apps/sheipe_api/spec/factories/exercises.rb`:

```ruby
FactoryBot.define do
  factory :exercise do
    sequence(:name) { |n| "Exercise #{n}" }
    description { "A useful description" }
    muscle_group { :chest }
    category { :strength }
    is_system { false }
    association :creator, factory: :user

    trait :system do
      is_system { true }
      creator { nil }
    end
  end
end
```

- [ ] **Step 4: Create model**

Create `apps/sheipe_api/app/models/exercise.rb`:

```ruby
class Exercise < ApplicationRecord
  MUSCLE_GROUPS = {
    chest: "chest",
    back: "back",
    shoulders: "shoulders",
    biceps: "biceps",
    triceps: "triceps",
    legs: "legs",
    glutes: "glutes",
    core: "core",
    full_body: "full_body"
  }.freeze

  CATEGORIES = {
    strength: "strength",
    cardio: "cardio",
    mobility: "mobility"
  }.freeze

  belongs_to :creator, class_name: "User", optional: true

  enum :muscle_group, MUSCLE_GROUPS, validate: true
  enum :category, CATEGORIES, validate: true

  validates :name, presence: true

  scope :visible_to, ->(user) {
    where(is_system: true).or(where(creator_id: user.id))
  }

  scope :system, -> { where(is_system: true) }
end
```

- [ ] **Step 5: Run spec — verify it passes**

```bash
bundle exec rspec spec/models/exercise_spec.rb
```
Expected: all examples pass (10 examples, 0 failures).

- [ ] **Step 6: Commit**

```bash
git add apps/sheipe_api/app/models/exercise.rb apps/sheipe_api/spec/factories/exercises.rb apps/sheipe_api/spec/models/exercise_spec.rb
git commit -m "feat(api): add Exercise model with muscle_group/category enums and visible_to scope"
```

---

### Task A4: ApplicationPolicy + ExercisePolicy + spec

**Files:**
- Create: `apps/sheipe_api/app/policies/application_policy.rb`
- Create: `apps/sheipe_api/app/policies/exercise_policy.rb`
- Create: `apps/sheipe_api/spec/policies/exercise_policy_spec.rb`

- [ ] **Step 1: Write failing policy spec**

Create `apps/sheipe_api/spec/policies/exercise_policy_spec.rb`:

```ruby
require 'rails_helper'

RSpec.describe ExercisePolicy do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user).tap { |u| u.update_column(:role, User.roles[:admin]) } }
  let(:custom_exercise) { create(:exercise, creator: owner) }
  let(:system_exercise) { create(:exercise, :system) }

  describe '#index?' do
    it 'allows any authenticated user' do
      expect(described_class.new(custom_exercise, user: owner).apply(:index?)).to be(true)
      expect(described_class.new(custom_exercise, user: other_user).apply(:index?)).to be(true)
    end
  end

  describe '#show?' do
    it 'allows owner to see own custom exercise' do
      expect(described_class.new(custom_exercise, user: owner).apply(:show?)).to be(true)
    end

    it 'denies non-owner to see other user custom exercise' do
      expect(described_class.new(custom_exercise, user: other_user).apply(:show?)).to be(false)
    end

    it 'allows any user to see a system exercise' do
      expect(described_class.new(system_exercise, user: other_user).apply(:show?)).to be(true)
    end
  end

  describe '#create?' do
    it 'allows any authenticated user' do
      expect(described_class.new(Exercise.new, user: owner).apply(:create?)).to be(true)
    end
  end

  describe '#update?' do
    it 'allows owner of custom exercise' do
      expect(described_class.new(custom_exercise, user: owner).apply(:update?)).to be(true)
    end

    it 'denies non-owner of custom exercise' do
      expect(described_class.new(custom_exercise, user: other_user).apply(:update?)).to be(false)
    end

    it 'denies non-admin on system exercise' do
      expect(described_class.new(system_exercise, user: owner).apply(:update?)).to be(false)
    end

    it 'allows admin on system exercise' do
      expect(described_class.new(system_exercise, user: admin).apply(:update?)).to be(true)
    end
  end

  describe '#destroy?' do
    it 'allows owner of custom exercise' do
      expect(described_class.new(custom_exercise, user: owner).apply(:destroy?)).to be(true)
    end

    it 'denies non-owner of custom exercise' do
      expect(described_class.new(custom_exercise, user: other_user).apply(:destroy?)).to be(false)
    end

    it 'denies non-admin on system exercise' do
      expect(described_class.new(system_exercise, user: owner).apply(:destroy?)).to be(false)
    end

    it 'allows admin on system exercise' do
      expect(described_class.new(system_exercise, user: admin).apply(:destroy?)).to be(true)
    end
  end
end
```

- [ ] **Step 2: Run spec — verify it fails**

```bash
bundle exec rspec spec/policies/exercise_policy_spec.rb
```
Expected: failure with `uninitialized constant ApplicationPolicy` or `ExercisePolicy`.

- [ ] **Step 3: Create ApplicationPolicy base**

Create `apps/sheipe_api/app/policies/application_policy.rb`:

```ruby
class ApplicationPolicy < ActionPolicy::Base
  authorize :user, allow_nil: false

  private

  def admin?
    user&.admin?
  end

  def owner?
    record.respond_to?(:creator_id) && record.creator_id == user.id
  end
end
```

- [ ] **Step 4: Create ExercisePolicy**

Create `apps/sheipe_api/app/policies/exercise_policy.rb`:

```ruby
class ExercisePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.is_system? || owner? || admin?
  end

  def create?
    true
  end

  def update?
    return admin? if record.is_system?

    owner? || admin?
  end

  def destroy?
    update?
  end
end
```

- [ ] **Step 5: Run spec — verify it passes**

```bash
bundle exec rspec spec/policies/exercise_policy_spec.rb
```
Expected: 12 examples, 0 failures.

- [ ] **Step 6: Commit**

```bash
git add apps/sheipe_api/app/policies apps/sheipe_api/spec/policies
git commit -m "feat(api): add ApplicationPolicy base and ExercisePolicy with system-exercise rules"
```

---

### Task A5: ExerciseSerializer

**Files:**
- Create: `apps/sheipe_api/app/serializers/exercise_serializer.rb`

- [ ] **Step 1: Create serializer**

Create `apps/sheipe_api/app/serializers/exercise_serializer.rb`:

```ruby
class ExerciseSerializer
  include Alba::Resource

  attributes :id,
             :name,
             :description,
             :muscle_group,
             :category,
             :is_system,
             :creator_id,
             :created_at,
             :updated_at
end
```

- [ ] **Step 2: Verify it loads**

```bash
bundle exec rails runner 'puts ExerciseSerializer.ancestors.include?(Alba::Resource)'
```
Expected output: `true`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_api/app/serializers/exercise_serializer.rb
git commit -m "feat(api): add ExerciseSerializer"
```

---

### Task A6: System exercise seed

**Files:**
- Create: `apps/sheipe_api/db/seeds/exercises.rb`
- Modify: `apps/sheipe_api/db/seeds.rb`

- [ ] **Step 1: Create seeds directory + file**

Create `apps/sheipe_api/db/seeds/exercises.rb`:

```ruby
SYSTEM_EXERCISES = [
  # Chest
  { name: "Bench Press", muscle_group: "chest", category: "strength", description: "Barbell flat bench press." },
  { name: "Incline Dumbbell Press", muscle_group: "chest", category: "strength", description: "Press dumbbells on a 30–45° incline bench." },
  { name: "Push-Up", muscle_group: "chest", category: "strength", description: "Body-weight pressing movement." },
  { name: "Cable Fly", muscle_group: "chest", category: "strength", description: "Cable crossover fly for chest isolation." },

  # Back
  { name: "Deadlift", muscle_group: "back", category: "strength", description: "Conventional barbell deadlift." },
  { name: "Pull-Up", muscle_group: "back", category: "strength", description: "Body-weight overhand pull-up." },
  { name: "Barbell Row", muscle_group: "back", category: "strength", description: "Bent-over barbell row." },
  { name: "Lat Pulldown", muscle_group: "back", category: "strength", description: "Cable lat pulldown." },

  # Shoulders
  { name: "Overhead Press", muscle_group: "shoulders", category: "strength", description: "Standing barbell overhead press." },
  { name: "Lateral Raise", muscle_group: "shoulders", category: "strength", description: "Dumbbell side lateral raise." },
  { name: "Face Pull", muscle_group: "shoulders", category: "strength", description: "Cable face pull for rear delts." },

  # Biceps
  { name: "Barbell Curl", muscle_group: "biceps", category: "strength", description: "Standing barbell curl." },
  { name: "Hammer Curl", muscle_group: "biceps", category: "strength", description: "Neutral-grip dumbbell curl." },

  # Triceps
  { name: "Tricep Pushdown", muscle_group: "triceps", category: "strength", description: "Cable tricep pushdown." },
  { name: "Skullcrusher", muscle_group: "triceps", category: "strength", description: "Lying EZ-bar tricep extension." },
  { name: "Dip", muscle_group: "triceps", category: "strength", description: "Body-weight parallel-bar dip." },

  # Legs
  { name: "Back Squat", muscle_group: "legs", category: "strength", description: "Barbell back squat." },
  { name: "Front Squat", muscle_group: "legs", category: "strength", description: "Barbell front squat." },
  { name: "Romanian Deadlift", muscle_group: "legs", category: "strength", description: "Hip-hinge with barbell." },
  { name: "Leg Press", muscle_group: "legs", category: "strength", description: "45° machine leg press." },
  { name: "Walking Lunge", muscle_group: "legs", category: "strength", description: "Dumbbell walking lunge." },
  { name: "Leg Extension", muscle_group: "legs", category: "strength", description: "Machine quad extension." },
  { name: "Leg Curl", muscle_group: "legs", category: "strength", description: "Lying or seated hamstring curl." },
  { name: "Calf Raise", muscle_group: "legs", category: "strength", description: "Standing calf raise." },

  # Glutes
  { name: "Hip Thrust", muscle_group: "glutes", category: "strength", description: "Barbell hip thrust." },
  { name: "Glute Bridge", muscle_group: "glutes", category: "strength", description: "Body-weight or barbell glute bridge." },

  # Core
  { name: "Plank", muscle_group: "core", category: "strength", description: "Front plank hold." },
  { name: "Hanging Leg Raise", muscle_group: "core", category: "strength", description: "Hanging straight-leg raise." },
  { name: "Cable Crunch", muscle_group: "core", category: "strength", description: "Kneeling cable crunch." },

  # Full body / cardio / mobility
  { name: "Burpee", muscle_group: "full_body", category: "cardio", description: "Full-body conditioning movement." },
  { name: "Treadmill Run", muscle_group: "full_body", category: "cardio", description: "Steady-state or interval running." },
  { name: "Rowing Machine", muscle_group: "full_body", category: "cardio", description: "Concept2-style ergometer rowing." },
  { name: "World's Greatest Stretch", muscle_group: "full_body", category: "mobility", description: "Lunge + thoracic rotation mobility flow." }
].freeze

SYSTEM_EXERCISES.each do |attrs|
  Exercise.find_or_create_by!(name: attrs[:name], is_system: true) do |ex|
    ex.description   = attrs[:description]
    ex.muscle_group  = attrs[:muscle_group]
    ex.category      = attrs[:category]
    ex.creator_id    = nil
  end
end

puts "Seeded #{Exercise.where(is_system: true).count} system exercises"
```

- [ ] **Step 2: Wire seeds.rb to load it**

Replace the contents of `apps/sheipe_api/db/seeds.rb` with:

```ruby
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

load Rails.root.join("db/seeds/exercises.rb")
```

- [ ] **Step 3: Run seeds**

```bash
bin/rails db:seed
```
Expected output ends with `Seeded 34 system exercises` (or similar count).

- [ ] **Step 4: Verify in console**

```bash
bin/rails runner 'puts Exercise.where(is_system: true).count'
```
Expected output: `34`

- [ ] **Step 5: Commit**

```bash
git add apps/sheipe_api/db/seeds.rb apps/sheipe_api/db/seeds/exercises.rb
git commit -m "feat(api): seed system exercises across all muscle groups"
```

---

### Task A7: ExercisesController + routes + request spec

**Files:**
- Create: `apps/sheipe_api/spec/requests/api/v1/exercises_spec.rb`
- Create: `apps/sheipe_api/app/controllers/api/v1/exercises_controller.rb`
- Modify: `apps/sheipe_api/config/routes.rb`

- [ ] **Step 1: Write failing request spec**

Create `apps/sheipe_api/spec/requests/api/v1/exercises_spec.rb`:

```ruby
require 'rails_helper'

RSpec.describe "/api/v1/exercises", type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.access_token}" } }

  let(:other_user) { create(:user) }
  let(:other_session) { create(:session, user: other_user) }
  let(:other_auth_headers) { { "Authorization" => "Bearer #{other_session.access_token}" } }

  describe "GET /api/v1/exercises" do
    let!(:system_chest) { create(:exercise, :system, name: "Bench Press", muscle_group: :chest, category: :strength) }
    let!(:system_back)  { create(:exercise, :system, name: "Pull-Up",     muscle_group: :back,  category: :strength) }
    let!(:system_cardio){ create(:exercise, :system, name: "Treadmill",   muscle_group: :full_body, category: :cardio) }
    let!(:user_custom)  { create(:exercise, name: "Custom Move",          muscle_group: :core,  category: :strength, creator: user) }
    let!(:foreign_custom) { create(:exercise, name: "Foreign Move",       muscle_group: :legs,  category: :strength, creator: other_user) }

    it "returns 200 with system + own exercises only" do
      get "/api/v1/exercises", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_body).to have_key("data")
      expect(json_body).to have_key("meta")
      ids = json_body["data"].map { |e| e["id"] }
      expect(ids).to contain_exactly(system_chest.id, system_back.id, system_cardio.id, user_custom.id)
      expect(ids).not_to include(foreign_custom.id)
    end

    it "filters by muscle_group" do
      get "/api/v1/exercises", params: { muscle_group: "chest" }, headers: auth_headers
      ids = json_body["data"].map { |e| e["id"] }
      expect(ids).to contain_exactly(system_chest.id)
    end

    it "filters by category" do
      get "/api/v1/exercises", params: { category: "cardio" }, headers: auth_headers
      ids = json_body["data"].map { |e| e["id"] }
      expect(ids).to contain_exactly(system_cardio.id)
    end

    it "filters by text query (case-insensitive name match)" do
      get "/api/v1/exercises", params: { query: "BENCH" }, headers: auth_headers
      ids = json_body["data"].map { |e| e["id"] }
      expect(ids).to contain_exactly(system_chest.id)
    end

    it "paginates results" do
      get "/api/v1/exercises", params: { per_page: 2, page: 1 }, headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"].length).to eq(2)
      expect(json_body["meta"]).to include("page" => 1, "per_page" => 2, "total_count" => 4)
      expect(json_body["meta"]["total_pages"]).to eq(2)
    end

    it "returns 401 without token" do
      get "/api/v1/exercises"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/exercises/:id" do
    let(:system_exercise) { create(:exercise, :system) }
    let(:own_exercise) { create(:exercise, creator: user) }
    let(:foreign_exercise) { create(:exercise, creator: other_user) }

    it "returns 200 for a system exercise" do
      get "/api/v1/exercises/#{system_exercise.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_body).to include("id", "name", "description", "muscle_group", "category", "is_system", "creator_id")
      expect(json_body["is_system"]).to be(true)
    end

    it "returns 200 for own exercise" do
      get "/api/v1/exercises/#{own_exercise.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_body["creator_id"]).to eq(user.id)
    end

    it "returns 404 for another user custom exercise" do
      get "/api/v1/exercises/#{foreign_exercise.id}", headers: auth_headers
      expect(response).to have_http_status(:not_found)
      expect(json_body.dig("error", "code")).to eq("not_found")
    end

    it "returns 404 for unknown id" do
      get "/api/v1/exercises/#{SecureRandom.uuid}", headers: auth_headers
      expect(response).to have_http_status(:not_found)
    end

    it "returns 401 without token" do
      get "/api/v1/exercises/#{system_exercise.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /api/v1/exercises" do
    it "returns 201 and persists with creator + is_system=false" do
      post "/api/v1/exercises",
           params: { name: "My Squat", muscle_group: "legs", category: "strength", description: "notes" },
           headers: auth_headers,
           as: :json

      expect(response).to have_http_status(:created)
      expect(json_body).to include("id", "name" => "My Squat", "is_system" => false, "creator_id" => user.id)

      created = Exercise.find(json_body["id"])
      expect(created.creator).to eq(user)
      expect(created.is_system).to be(false)
    end

    it "returns 422 for blank name" do
      post "/api/v1/exercises",
           params: { name: "", muscle_group: "legs", category: "strength" },
           headers: auth_headers,
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body.dig("error", "code")).to eq("validation_failed")
      expect(json_body.dig("error", "details", "name")).to include("can't be blank")
    end

    it "returns 422 for invalid muscle_group" do
      post "/api/v1/exercises",
           params: { name: "Bad", muscle_group: "fingers", category: "strength" },
           headers: auth_headers,
           as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns 401 without token" do
      post "/api/v1/exercises",
           params: { name: "X", muscle_group: "chest", category: "strength" },
           as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /api/v1/exercises/:id" do
    let!(:own_exercise) { create(:exercise, creator: user, name: "Old") }
    let!(:foreign_exercise) { create(:exercise, creator: other_user, name: "Foreign") }
    let!(:system_exercise) { create(:exercise, :system, name: "System") }

    it "returns 200 when owner updates" do
      patch "/api/v1/exercises/#{own_exercise.id}",
            params: { name: "New" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_body["name"]).to eq("New")
      expect(own_exercise.reload.name).to eq("New")
    end

    it "returns 403 when non-owner updates a custom exercise" do
      patch "/api/v1/exercises/#{foreign_exercise.id}",
            params: { name: "Hijack" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
      expect(json_body.dig("error", "code")).to eq("forbidden")
    end

    it "returns 403 when non-admin updates a system exercise" do
      patch "/api/v1/exercises/#{system_exercise.id}",
            params: { name: "Change" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /api/v1/exercises/:id" do
    let!(:own_exercise) { create(:exercise, creator: user) }
    let!(:foreign_exercise) { create(:exercise, creator: other_user) }
    let!(:system_exercise) { create(:exercise, :system) }

    it "returns 204 when owner deletes" do
      delete "/api/v1/exercises/#{own_exercise.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
      expect(Exercise.exists?(own_exercise.id)).to be(false)
    end

    it "returns 403 when non-owner deletes" do
      delete "/api/v1/exercises/#{foreign_exercise.id}", headers: auth_headers
      expect(response).to have_http_status(:forbidden)
      expect(Exercise.exists?(foreign_exercise.id)).to be(true)
    end

    it "returns 403 when non-admin deletes a system exercise" do
      delete "/api/v1/exercises/#{system_exercise.id}", headers: auth_headers
      expect(response).to have_http_status(:forbidden)
    end
  end
end
```

- [ ] **Step 2: Run spec — verify it fails**

```bash
bundle exec rspec spec/requests/api/v1/exercises_spec.rb
```
Expected: failures with `No route matches [GET] "/api/v1/exercises"`.

- [ ] **Step 3: Add route**

Modify `apps/sheipe_api/config/routes.rb`. Add `resources :exercises` inside the `namespace :v1` block (after `resources :users, only: [ :show ]`):

```ruby
Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :register, to: "registrations#create"
        post :login, to: "sessions#create"
        post :refresh, to: "refreshes#create"
        delete :logout, to: "sessions#destroy"
      end

      resource :me, only: [ :show, :update ], controller: "me"
      resources :users, only: [ :show ]
      resources :exercises, only: [ :index, :show, :create, :update, :destroy ]
    end
  end

  match "*path", to: "api/v1/base#not_found", via: :all
end
```

- [ ] **Step 4: Create controller**

Create `apps/sheipe_api/app/controllers/api/v1/exercises_controller.rb`:

```ruby
module Api
  module V1
    class ExercisesController < BaseController
      before_action :load_exercise, only: [ :show, :update, :destroy ]
      before_action :hide_foreign_custom_on_show, only: [ :show ]

      def index
        scope = Exercise.visible_to(Current.user)
        scope = scope.where(muscle_group: params[:muscle_group]) if params[:muscle_group].present?
        scope = scope.where(category: params[:category]) if params[:category].present?
        if params[:query].present?
          like = "%#{params[:query].downcase}%"
          scope = scope.where("lower(name) LIKE ?", like)
        end
        scope = scope.order(:name)

        pagy_obj, exercises = pagy(scope)

        render json: {
          data: ExerciseSerializer.new(exercises).serializable_hash,
          meta: pagy_meta(pagy_obj)
        }, status: :ok
      end

      def show
        authorize! @exercise
        render json: ExerciseSerializer.new(@exercise).serializable_hash, status: :ok
      end

      def create
        authorize! Exercise
        exercise = Exercise.new(exercise_params)
        exercise.creator = Current.user
        exercise.is_system = false
        exercise.save!
        render json: ExerciseSerializer.new(exercise).serializable_hash, status: :created
      end

      def update
        authorize! @exercise
        @exercise.update!(exercise_params)
        render json: ExerciseSerializer.new(@exercise).serializable_hash, status: :ok
      end

      def destroy
        authorize! @exercise
        @exercise.destroy!
        head :no_content
      end

      private

      def load_exercise
        @exercise = Exercise.find_by(id: params[:id])
        render_error("not_found", "Record not found", nil, :not_found) if @exercise.nil?
      end

      # Show hides the existence of foreign custom exercises (404 instead of 403).
      # Update/destroy intentionally return 403 via ActionPolicy to communicate the
      # policy decision to clients that already hold the ID.
      def hide_foreign_custom_on_show
        return if @exercise.nil?
        return if @exercise.is_system?
        return if @exercise.creator_id == Current.user.id
        return if Current.user.admin?

        render_error("not_found", "Record not found", nil, :not_found)
      end

      def exercise_params
        params.permit(:name, :description, :muscle_group, :category)
      end
    end
  end
end
```

- [ ] **Step 5: Run spec — verify it passes**

```bash
bundle exec rspec spec/requests/api/v1/exercises_spec.rb
```
Expected: ~17 examples, 0 failures.

- [ ] **Step 6: Run full suite**

```bash
bundle exec rspec
```
Expected: 0 failures.

- [ ] **Step 7: Commit**

```bash
git add apps/sheipe_api/config/routes.rb \
        apps/sheipe_api/app/controllers/api/v1/exercises_controller.rb \
        apps/sheipe_api/spec/requests/api/v1/exercises_spec.rb
git commit -m "feat(api): add Exercise CRUD endpoints with filters, pagination, and ActionPolicy"
```

---

# Phase B — Flutter sync foundation

---

### Task B1: Add packages

**Files:**
- Modify: `apps/sheipe_app/pubspec.yaml`

- [ ] **Step 1: Add dependencies**

Open `apps/sheipe_app/pubspec.yaml` and under `dependencies:` (between `path_provider` and the `dev_dependencies` line) add:

```yaml
  uuid: ^4.5.1
  connectivity_plus: ^6.1.0
```

The full `dependencies:` block becomes:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_bloc: ^9.1.1
  go_router: ^15.1.2
  dio: ^5.8.0+1
  drift: ^2.23.1
  sqlite3_flutter_libs: ^0.5.32
  flutter_secure_storage: ^9.2.4
  get_it: ^8.0.3
  path: ^1.9.1
  path_provider: ^2.1.5
  uuid: ^4.5.1
  connectivity_plus: ^6.1.0
```

- [ ] **Step 2: Install**

From `apps/sheipe_app/`:
```bash
flutter pub get
```
Expected: `Got dependencies!` with no errors.

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/pubspec.yaml apps/sheipe_app/pubspec.lock
git commit -m "chore(app): add uuid and connectivity_plus dependencies"
```

---

### Task B2: Drift tables (Exercise + SyncOperations) + migration

**Files:**
- Modify: `apps/sheipe_app/lib/core/storage/app_database.dart`

- [ ] **Step 1: Replace AppDatabase with v2 schema**

Replace the entire contents of `apps/sheipe_app/lib/core/storage/app_database.dart` with:

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class ExercisesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get muscleGroup => text().named('muscle_group')();
  TextColumn get category => text()();
  BoolColumn get isSystem => boolean().named('is_system').withDefault(const Constant(false))();
  TextColumn get creatorId => text().named('creator_id').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'exercises';
}

class SyncOperationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text().named('entity_type')();
  TextColumn get entityId => text().named('entity_id')();
  TextColumn get operation => text()(); // 'create' | 'update' | 'delete'
  TextColumn get payload => text().nullable()(); // JSON string
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().named('last_error').nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'sync_operations';
}

@DriftDatabase(tables: [ExercisesTable, SyncOperationsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()); // coverage:ignore-line

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(exercisesTable);
            await m.createTable(syncOperationsTable);
          }
        },
      );
}

// coverage:ignore-start
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'sheipe.db'));
    return NativeDatabase.createInBackground(file);
  });
}
// coverage:ignore-end
```

- [ ] **Step 2: Regenerate Drift**

From `apps/sheipe_app/`:
```bash
dart run build_runner build --delete-conflicting-outputs
```
Expected: ends with `Succeeded after ...`. The file `lib/core/storage/app_database.g.dart` should now contain `ExercisesTable` and `SyncOperationsTable` data classes.

- [ ] **Step 3: Verify analyze**

```bash
flutter analyze lib/core/storage/
```
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add apps/sheipe_app/lib/core/storage/app_database.dart apps/sheipe_app/lib/core/storage/app_database.g.dart
git commit -m "feat(app): add ExercisesTable and SyncOperationsTable to Drift schema (v2)"
```

---

### Task B3: SyncService + tests

**Files:**
- Create: `apps/sheipe_app/lib/core/sync/sync_operation.dart`
- Create: `apps/sheipe_app/lib/core/sync/sync_handler.dart`
- Create: `apps/sheipe_app/lib/core/sync/sync_service.dart`
- Create: `apps/sheipe_app/test/core/sync/sync_service_test.dart`

- [ ] **Step 1: Define SyncOperation value object**

Create `apps/sheipe_app/lib/core/sync/sync_operation.dart`:

```dart
enum SyncOp { create, update, delete }

class SyncOperation {
  const SyncOperation({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    this.payload,
    required this.createdAt,
    this.syncedAt,
    this.attempts = 0,
    this.lastError,
  });

  final String id;
  final String entityType;
  final String entityId;
  final SyncOp operation;
  final String? payload;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final int attempts;
  final String? lastError;
}
```

- [ ] **Step 2: Define SyncHandler contract**

Create `apps/sheipe_app/lib/core/sync/sync_handler.dart`:

```dart
import 'sync_operation.dart';

abstract class SyncHandler {
  String get entityType;

  Future<void> handle(SyncOperation operation);
}
```

- [ ] **Step 3: Write failing SyncService test**

Create `apps/sheipe_app/test/core/sync/sync_service_test.dart`:

```dart
import 'dart:async';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/storage/app_database.dart';
import 'package:sheipe_app/core/sync/sync_handler.dart';
import 'package:sheipe_app/core/sync/sync_operation.dart';
import 'package:sheipe_app/core/sync/sync_service.dart';

class MockSyncHandler extends Mock implements SyncHandler {}

void main() {
  late AppDatabase db;
  late SyncService service;
  late MockSyncHandler exerciseHandler;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = SyncService(database: db);
    exerciseHandler = MockSyncHandler();
    when(() => exerciseHandler.entityType).thenReturn('exercise');
    when(() => exerciseHandler.handle(any())).thenAnswer((_) async {});
    service.registerHandler(exerciseHandler);
    registerFallbackValue(SyncOperation(
      id: '0',
      entityType: 'exercise',
      entityId: '0',
      operation: SyncOp.create,
      createdAt: DateTime(2026),
    ));
  });

  tearDown(() => db.close());

  group('enqueue', () {
    test('persists a sync_operations row with attempts=0 and synced_at=null', () async {
      await service.enqueue(
        entityType: 'exercise',
        entityId: 'exercise-1',
        operation: SyncOp.create,
        payload: '{"name":"X"}',
      );

      final rows = await db.select(db.syncOperationsTable).get();
      expect(rows.length, 1);
      expect(rows.first.entityType, 'exercise');
      expect(rows.first.entityId, 'exercise-1');
      expect(rows.first.operation, 'create');
      expect(rows.first.payload, '{"name":"X"}');
      expect(rows.first.syncedAt, isNull);
      expect(rows.first.attempts, 0);
    });
  });

  group('drainPending', () {
    test('processes pending operations in FIFO order and marks them synced', () async {
      await service.enqueue(entityType: 'exercise', entityId: 'a', operation: SyncOp.create);
      await service.enqueue(entityType: 'exercise', entityId: 'b', operation: SyncOp.update);

      await service.drainPending();

      final captured = verify(() => exerciseHandler.handle(captureAny())).captured.cast<SyncOperation>();
      expect(captured.map((o) => o.entityId), ['a', 'b']);

      final remaining = await (db.select(db.syncOperationsTable)
            ..where((t) => t.syncedAt.isNull()))
          .get();
      expect(remaining, isEmpty);
    });

    test('skips already-synced operations', () async {
      await service.enqueue(entityType: 'exercise', entityId: 'a', operation: SyncOp.create);
      await service.drainPending();
      clearInteractions(exerciseHandler);

      await service.drainPending();
      verifyNever(() => exerciseHandler.handle(any()));
    });

    test('records error and increments attempts when handler throws', () async {
      when(() => exerciseHandler.handle(any())).thenThrow(Exception('boom'));
      await service.enqueue(entityType: 'exercise', entityId: 'a', operation: SyncOp.create);

      await service.drainPending();

      final row = (await db.select(db.syncOperationsTable).get()).single;
      expect(row.syncedAt, isNull);
      expect(row.attempts, 1);
      expect(row.lastError, contains('boom'));
    });

    test('skips unknown entity types without crashing', () async {
      await service.enqueue(entityType: 'unknown', entityId: 'x', operation: SyncOp.create);
      await service.drainPending();

      final row = (await db.select(db.syncOperationsTable).get()).single;
      expect(row.syncedAt, isNull);
      expect(row.attempts, 1);
      expect(row.lastError, contains('No handler registered'));
    });
  });

  group('connectivity stream', () {
    test('drainPending is invoked when connectivity stream emits an online event', () async {
      final controller = StreamController<bool>.broadcast();
      service.start(connectivityStream: controller.stream);

      await service.enqueue(entityType: 'exercise', entityId: 'a', operation: SyncOp.create);
      controller.add(true);
      // Allow the microtask queue to run.
      await Future<void>.delayed(const Duration(milliseconds: 10));

      verify(() => exerciseHandler.handle(any())).called(1);
      await controller.close();
    });

    test('does not drain on offline event', () async {
      final controller = StreamController<bool>.broadcast();
      service.start(connectivityStream: controller.stream);

      await service.enqueue(entityType: 'exercise', entityId: 'a', operation: SyncOp.create);
      controller.add(false);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      verifyNever(() => exerciseHandler.handle(any()));
      await controller.close();
    });
  });
}
```

- [ ] **Step 4: Run test — verify it fails**

```bash
flutter test test/core/sync/sync_service_test.dart
```
Expected: failure with `Target of URI doesn't exist: 'package:sheipe_app/core/sync/sync_service.dart'`.

- [ ] **Step 5: Implement SyncService**

Create `apps/sheipe_app/lib/core/sync/sync_service.dart`:

```dart
import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../storage/app_database.dart';
import 'sync_handler.dart';
import 'sync_operation.dart';

class SyncService {
  SyncService({required AppDatabase database, Uuid? uuid})
      : _db = database,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;
  final Map<String, SyncHandler> _handlers = {};
  StreamSubscription<bool>? _connectivitySub;
  bool _draining = false;

  void registerHandler(SyncHandler handler) {
    _handlers[handler.entityType] = handler;
  }

  void start({required Stream<bool> connectivityStream}) {
    _connectivitySub?.cancel();
    _connectivitySub = connectivityStream.listen((online) {
      if (online) {
        // Fire-and-forget; errors are recorded on each row.
        unawaited(drainPending());
      }
    });
  }

  Future<void> stop() async {
    await _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  Future<void> enqueue({
    required String entityType,
    required String entityId,
    required SyncOp operation,
    String? payload,
  }) async {
    await _db.into(_db.syncOperationsTable).insert(
          SyncOperationsTableCompanion.insert(
            id: _uuid.v4(),
            entityType: entityType,
            entityId: entityId,
            operation: operation.name,
            payload: Value(payload),
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<void> drainPending() async {
    if (_draining) return;
    _draining = true;
    try {
      final pending = await (_db.select(_db.syncOperationsTable)
            ..where((t) => t.syncedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

      for (final row in pending) {
        await _process(row);
      }
    } finally {
      _draining = false;
    }
  }

  Future<void> _process(SyncOperationsTableData row) async {
    final handler = _handlers[row.entityType];

    if (handler == null) {
      await _markFailed(row, 'No handler registered for ${row.entityType}');
      return;
    }

    try {
      await handler.handle(_toDomain(row));
      await _markSynced(row);
    } catch (e) {
      await _markFailed(row, e.toString());
    }
  }

  SyncOperation _toDomain(SyncOperationsTableData row) => SyncOperation(
        id: row.id,
        entityType: row.entityType,
        entityId: row.entityId,
        operation: SyncOp.values.firstWhere((o) => o.name == row.operation),
        payload: row.payload,
        createdAt: row.createdAt,
        syncedAt: row.syncedAt,
        attempts: row.attempts,
        lastError: row.lastError,
      );

  Future<void> _markSynced(SyncOperationsTableData row) async {
    await (_db.update(_db.syncOperationsTable)..where((t) => t.id.equals(row.id)))
        .write(SyncOperationsTableCompanion(
      syncedAt: Value(DateTime.now().toUtc()),
    ));
  }

  Future<void> _markFailed(SyncOperationsTableData row, String error) async {
    await (_db.update(_db.syncOperationsTable)..where((t) => t.id.equals(row.id)))
        .write(SyncOperationsTableCompanion(
      attempts: Value(row.attempts + 1),
      lastError: Value(error),
    ));
  }
}
```

- [ ] **Step 6: Run test — verify it passes**

```bash
flutter test test/core/sync/sync_service_test.dart
```
Expected: 7 tests, all pass.

- [ ] **Step 7: Commit**

```bash
git add apps/sheipe_app/lib/core/sync apps/sheipe_app/test/core/sync
git commit -m "feat(app): add SyncService with handler registry and connectivity drain"
```

---

# Phase C — Flutter Exercise feature (data + state)

---

### Task C1: Exercise entity + enums

**Files:**
- Create: `apps/sheipe_app/lib/features/exercise/domain/entities/exercise.dart`

- [ ] **Step 1: Create entity**

Create `apps/sheipe_app/lib/features/exercise/domain/entities/exercise.dart`:

```dart
enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  legs,
  glutes,
  core,
  fullBody;

  String get apiValue => switch (this) {
        MuscleGroup.fullBody => 'full_body',
        _ => name,
      };

  static MuscleGroup fromApi(String value) => switch (value) {
        'full_body' => MuscleGroup.fullBody,
        _ => MuscleGroup.values.firstWhere((m) => m.name == value),
      };
}

enum ExerciseCategory {
  strength,
  cardio,
  mobility;

  String get apiValue => name;

  static ExerciseCategory fromApi(String value) =>
      ExerciseCategory.values.firstWhere((c) => c.name == value);
}

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    this.description,
    required this.muscleGroup,
    required this.category,
    required this.isSystem,
    this.creatorId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final MuscleGroup muscleGroup;
  final ExerciseCategory category;
  final bool isSystem;
  final String? creatorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool ownedBy(String userId) => creatorId == userId;
  bool get isCustom => !isSystem;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        muscleGroup: MuscleGroup.fromApi(json['muscle_group'] as String),
        category: ExerciseCategory.fromApi(json['category'] as String),
        isSystem: json['is_system'] as bool,
        creatorId: json['creator_id'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'muscle_group': muscleGroup.apiValue,
        'category': category.apiValue,
        'is_system': isSystem,
        'creator_id': creatorId,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    MuscleGroup? muscleGroup,
    ExerciseCategory? category,
    bool? isSystem,
    String? creatorId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        muscleGroup: muscleGroup ?? this.muscleGroup,
        category: category ?? this.category,
        isSystem: isSystem ?? this.isSystem,
        creatorId: creatorId ?? this.creatorId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
```

- [ ] **Step 2: Verify analyze**

From `apps/sheipe_app/`:
```bash
flutter analyze lib/features/exercise
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/features/exercise/domain
git commit -m "feat(app): add Exercise entity with MuscleGroup and ExerciseCategory enums"
```

---

### Task C2: ExerciseFilters + ExerciseLocalDataSource

**Files:**
- Create: `apps/sheipe_app/lib/features/exercise/data/filters/exercise_filters.dart`
- Create: `apps/sheipe_app/lib/features/exercise/data/local/exercise_local_data_source.dart`

- [ ] **Step 1: Create filters value object**

Create `apps/sheipe_app/lib/features/exercise/data/filters/exercise_filters.dart`:

```dart
import '../../domain/entities/exercise.dart';

class ExerciseFilters {
  const ExerciseFilters({
    this.muscleGroup,
    this.category,
    this.query,
  });

  final MuscleGroup? muscleGroup;
  final ExerciseCategory? category;
  final String? query;

  static const empty = ExerciseFilters();

  bool get isEmpty =>
      muscleGroup == null &&
      category == null &&
      (query == null || query!.trim().isEmpty);

  ExerciseFilters copyWith({
    MuscleGroup? muscleGroup,
    bool clearMuscleGroup = false,
    ExerciseCategory? category,
    bool clearCategory = false,
    String? query,
    bool clearQuery = false,
  }) =>
      ExerciseFilters(
        muscleGroup: clearMuscleGroup ? null : muscleGroup ?? this.muscleGroup,
        category: clearCategory ? null : category ?? this.category,
        query: clearQuery ? null : query ?? this.query,
      );

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (muscleGroup != null) params['muscle_group'] = muscleGroup!.apiValue;
    if (category != null) params['category'] = category!.apiValue;
    final q = query?.trim();
    if (q != null && q.isNotEmpty) params['query'] = q;
    return params;
  }
}
```

- [ ] **Step 2: Create local data source**

Create `apps/sheipe_app/lib/features/exercise/data/local/exercise_local_data_source.dart`:

```dart
import 'package:drift/drift.dart';
import '../../../../core/storage/app_database.dart';
import '../../domain/entities/exercise.dart';
import '../filters/exercise_filters.dart';

class ExerciseLocalDataSource {
  ExerciseLocalDataSource({required AppDatabase database}) : _db = database;

  final AppDatabase _db;

  Stream<List<Exercise>> watchAll(ExerciseFilters filters) {
    final select = _db.select(_db.exercisesTable)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);

    if (filters.muscleGroup != null) {
      select.where((t) => t.muscleGroup.equals(filters.muscleGroup!.apiValue));
    }
    if (filters.category != null) {
      select.where((t) => t.category.equals(filters.category!.apiValue));
    }
    final q = filters.query?.trim().toLowerCase();
    if (q != null && q.isNotEmpty) {
      select.where((t) => t.name.lower().like('%$q%'));
    }

    return select.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<Exercise?> findById(String id) async {
    final row = await (_db.select(_db.exercisesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<void> upsert(Exercise exercise) async {
    await _db.into(_db.exercisesTable).insertOnConflictUpdate(_toCompanion(exercise));
  }

  Future<void> upsertAll(Iterable<Exercise> exercises) async {
    await _db.batch((batch) {
      for (final ex in exercises) {
        batch.insert(_db.exercisesTable, _toCompanion(ex), mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> deleteById(String id) async {
    await (_db.delete(_db.exercisesTable)..where((t) => t.id.equals(id))).go();
  }

  Exercise _toDomain(ExercisesTableData row) => Exercise(
        id: row.id,
        name: row.name,
        description: row.description,
        muscleGroup: MuscleGroup.fromApi(row.muscleGroup),
        category: ExerciseCategory.fromApi(row.category),
        isSystem: row.isSystem,
        creatorId: row.creatorId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  ExercisesTableCompanion _toCompanion(Exercise ex) => ExercisesTableCompanion.insert(
        id: ex.id,
        name: ex.name,
        description: Value(ex.description),
        muscleGroup: ex.muscleGroup.apiValue,
        category: ex.category.apiValue,
        isSystem: Value(ex.isSystem),
        creatorId: Value(ex.creatorId),
        createdAt: ex.createdAt,
        updatedAt: ex.updatedAt,
      );
}
```

- [ ] **Step 3: Verify analyze**

```bash
flutter analyze lib/features/exercise
```
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add apps/sheipe_app/lib/features/exercise/data/filters apps/sheipe_app/lib/features/exercise/data/local
git commit -m "feat(app): add ExerciseFilters and ExerciseLocalDataSource (Drift-backed)"
```

---

### Task C3: ExerciseRemoteDataSource

**Files:**
- Create: `apps/sheipe_app/lib/features/exercise/data/remote/exercise_remote_data_source.dart`

- [ ] **Step 1: Create remote data source**

Create `apps/sheipe_app/lib/features/exercise/data/remote/exercise_remote_data_source.dart`:

```dart
import 'package:dio/dio.dart';
import '../../domain/entities/exercise.dart';
import '../filters/exercise_filters.dart';

class ExerciseRemoteDataSource {
  const ExerciseRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<Exercise>> fetchAll(ExerciseFilters filters) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/exercises',
      queryParameters: {
        ...filters.toQueryParams(),
        'per_page': 100,
      },
    );
    final data = (response.data!['data'] as List).cast<Map<String, dynamic>>();
    return data.map(Exercise.fromJson).toList();
  }

  Future<Exercise> fetchById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/exercises/$id');
    return Exercise.fromJson(response.data!);
  }

  Future<Exercise> create(Exercise exercise) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/exercises',
      data: {
        'name': exercise.name,
        'description': exercise.description,
        'muscle_group': exercise.muscleGroup.apiValue,
        'category': exercise.category.apiValue,
      },
    );
    return Exercise.fromJson(response.data!);
  }

  Future<Exercise> update(Exercise exercise) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/v1/exercises/${exercise.id}',
      data: {
        'name': exercise.name,
        'description': exercise.description,
        'muscle_group': exercise.muscleGroup.apiValue,
        'category': exercise.category.apiValue,
      },
    );
    return Exercise.fromJson(response.data!);
  }

  Future<void> delete(String id) async {
    await _dio.delete<void>('/api/v1/exercises/$id');
  }
}
```

- [ ] **Step 2: Verify analyze**

```bash
flutter analyze lib/features/exercise
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/features/exercise/data/remote
git commit -m "feat(app): add ExerciseRemoteDataSource (Dio)"
```

---

### Task C4: ExerciseRepository (offline-first) + tests

**Files:**
- Create: `apps/sheipe_app/test/features/exercise/data/repositories/exercise_repository_test.dart`
- Create: `apps/sheipe_app/lib/features/exercise/data/repositories/exercise_repository.dart`

- [ ] **Step 1: Write failing repository test**

Create `apps/sheipe_app/test/features/exercise/data/repositories/exercise_repository_test.dart`:

```dart
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/core/sync/sync_handler.dart';
import 'package:sheipe_app/core/sync/sync_operation.dart';
import 'package:sheipe_app/core/sync/sync_service.dart';
import 'package:sheipe_app/features/exercise/data/filters/exercise_filters.dart';
import 'package:sheipe_app/features/exercise/data/local/exercise_local_data_source.dart';
import 'package:sheipe_app/features/exercise/data/remote/exercise_remote_data_source.dart';
import 'package:sheipe_app/features/exercise/data/repositories/exercise_repository.dart';
import 'package:sheipe_app/features/exercise/domain/entities/exercise.dart';

class MockExerciseLocalDataSource extends Mock implements ExerciseLocalDataSource {}
class MockExerciseRemoteDataSource extends Mock implements ExerciseRemoteDataSource {}
class MockSyncService extends Mock implements SyncService {}

Exercise _ex({String id = 'ex-1', String name = 'Bench'}) => Exercise(
      id: id,
      name: name,
      muscleGroup: MuscleGroup.chest,
      category: ExerciseCategory.strength,
      isSystem: false,
      creatorId: 'user-1',
      createdAt: DateTime(2026, 5, 1),
      updatedAt: DateTime(2026, 5, 1),
    );

void main() {
  late MockExerciseLocalDataSource local;
  late MockExerciseRemoteDataSource remote;
  late MockSyncService sync;
  late ExerciseRepository repo;

  setUpAll(() {
    registerFallbackValue(_ex());
    registerFallbackValue(<Exercise>[]);
    registerFallbackValue(SyncOp.create);
  });

  setUp(() {
    local = MockExerciseLocalDataSource();
    remote = MockExerciseRemoteDataSource();
    sync = MockSyncService();
    repo = ExerciseRepository(local: local, remote: remote, syncService: sync);
  });

  group('SyncHandler conformance', () {
    test('declares entityType "exercise"', () {
      expect(repo.entityType, 'exercise');
    });
  });

  group('watchAll', () {
    test('forwards filters to local data source', () {
      final controller = StreamController<List<Exercise>>();
      when(() => local.watchAll(any())).thenAnswer((_) => controller.stream);

      repo.watchAll(const ExerciseFilters(muscleGroup: MuscleGroup.chest));

      verify(() => local.watchAll(any(that: predicate<ExerciseFilters>(
            (f) => f.muscleGroup == MuscleGroup.chest,
          )))).called(1);
      controller.close();
    });
  });

  group('refreshFromRemote', () {
    test('fetches and upserts into local', () async {
      final exercises = [_ex(id: 'a'), _ex(id: 'b')];
      when(() => remote.fetchAll(any())).thenAnswer((_) async => exercises);
      when(() => local.upsertAll(any())).thenAnswer((_) async {});

      await repo.refreshFromRemote(ExerciseFilters.empty);

      verify(() => remote.fetchAll(ExerciseFilters.empty)).called(1);
      verify(() => local.upsertAll(exercises)).called(1);
    });
  });

  group('create', () {
    test('writes to local first then enqueues a create sync op', () async {
      when(() => local.upsert(any())).thenAnswer((_) async {});
      when(() => sync.enqueue(
            entityType: any(named: 'entityType'),
            entityId: any(named: 'entityId'),
            operation: any(named: 'operation'),
            payload: any(named: 'payload'),
          )).thenAnswer((_) async {});
      when(() => sync.drainPending()).thenAnswer((_) async {});

      final created = await repo.create(
        name: 'Bench',
        description: null,
        muscleGroup: MuscleGroup.chest,
        category: ExerciseCategory.strength,
        creatorId: 'user-1',
      );

      expect(created.id, isNotEmpty);
      expect(created.isSystem, false);
      expect(created.creatorId, 'user-1');

      verifyInOrder([
        () => local.upsert(any(that: predicate<Exercise>((e) => e.name == 'Bench'))),
        () => sync.enqueue(
              entityType: 'exercise',
              entityId: created.id,
              operation: SyncOp.create,
              payload: any(named: 'payload'),
            ),
      ]);
    });
  });

  group('update', () {
    test('writes to local first then enqueues an update sync op', () async {
      when(() => local.upsert(any())).thenAnswer((_) async {});
      when(() => sync.enqueue(
            entityType: any(named: 'entityType'),
            entityId: any(named: 'entityId'),
            operation: any(named: 'operation'),
            payload: any(named: 'payload'),
          )).thenAnswer((_) async {});
      when(() => sync.drainPending()).thenAnswer((_) async {});

      final original = _ex();
      final updated = original.copyWith(name: 'New Name');

      await repo.update(updated);

      verifyInOrder([
        () => local.upsert(updated),
        () => sync.enqueue(
              entityType: 'exercise',
              entityId: updated.id,
              operation: SyncOp.update,
              payload: any(named: 'payload'),
            ),
      ]);
    });
  });

  group('delete', () {
    test('deletes locally and enqueues a delete sync op', () async {
      when(() => local.deleteById(any())).thenAnswer((_) async {});
      when(() => sync.enqueue(
            entityType: any(named: 'entityType'),
            entityId: any(named: 'entityId'),
            operation: any(named: 'operation'),
            payload: any(named: 'payload'),
          )).thenAnswer((_) async {});
      when(() => sync.drainPending()).thenAnswer((_) async {});

      await repo.delete('ex-1');

      verifyInOrder([
        () => local.deleteById('ex-1'),
        () => sync.enqueue(
              entityType: 'exercise',
              entityId: 'ex-1',
              operation: SyncOp.delete,
              payload: null,
            ),
      ]);
    });
  });

  group('handle (SyncHandler)', () {
    test('on create op, calls remote.create with payload-rebuilt exercise and upserts result', () async {
      final exercise = _ex(id: 'local-id');
      final serverEx = exercise.copyWith(id: 'server-id-same'); // server keeps client UUID

      when(() => remote.create(any())).thenAnswer((_) async => serverEx);
      when(() => local.upsert(any())).thenAnswer((_) async {});

      final op = SyncOperation(
        id: 'op-1',
        entityType: 'exercise',
        entityId: exercise.id,
        operation: SyncOp.create,
        payload: '{"id":"local-id","name":"Bench","description":null,"muscle_group":"chest","category":"strength","is_system":false,"creator_id":"user-1","created_at":"2026-05-01T00:00:00.000","updated_at":"2026-05-01T00:00:00.000"}',
        createdAt: DateTime(2026),
      );

      await repo.handle(op);

      verify(() => remote.create(any())).called(1);
      verify(() => local.upsert(serverEx)).called(1);
    });

    test('on update op, calls remote.update and upserts', () async {
      final exercise = _ex();
      when(() => remote.update(any())).thenAnswer((_) async => exercise);
      when(() => local.upsert(any())).thenAnswer((_) async {});

      final op = SyncOperation(
        id: 'op-1',
        entityType: 'exercise',
        entityId: exercise.id,
        operation: SyncOp.update,
        payload: '{"id":"ex-1","name":"Bench","description":null,"muscle_group":"chest","category":"strength","is_system":false,"creator_id":"user-1","created_at":"2026-05-01T00:00:00.000","updated_at":"2026-05-01T00:00:00.000"}',
        createdAt: DateTime(2026),
      );

      await repo.handle(op);

      verify(() => remote.update(any())).called(1);
      verify(() => local.upsert(exercise)).called(1);
    });

    test('on delete op, calls remote.delete only', () async {
      when(() => remote.delete(any())).thenAnswer((_) async {});

      final op = SyncOperation(
        id: 'op-1',
        entityType: 'exercise',
        entityId: 'ex-1',
        operation: SyncOp.delete,
        createdAt: DateTime(2026),
      );

      await repo.handle(op);

      verify(() => remote.delete('ex-1')).called(1);
      verifyNever(() => local.upsert(any()));
    });
  });
}
```

- [ ] **Step 2: Run test — verify it fails**

```bash
flutter test test/features/exercise/data/repositories/exercise_repository_test.dart
```
Expected: failure with `Target of URI doesn't exist: 'package:sheipe_app/features/exercise/data/repositories/exercise_repository.dart'`.

- [ ] **Step 3: Implement repository**

Create `apps/sheipe_app/lib/features/exercise/data/repositories/exercise_repository.dart`:

```dart
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../../../core/sync/sync_handler.dart';
import '../../../../core/sync/sync_operation.dart';
import '../../../../core/sync/sync_service.dart';
import '../../domain/entities/exercise.dart';
import '../filters/exercise_filters.dart';
import '../local/exercise_local_data_source.dart';
import '../remote/exercise_remote_data_source.dart';

class ExerciseRepository implements SyncHandler {
  ExerciseRepository({
    required ExerciseLocalDataSource local,
    required ExerciseRemoteDataSource remote,
    required SyncService syncService,
    Uuid? uuid,
  })  : _local = local,
        _remote = remote,
        _sync = syncService,
        _uuid = uuid ?? const Uuid();

  final ExerciseLocalDataSource _local;
  final ExerciseRemoteDataSource _remote;
  final SyncService _sync;
  final Uuid _uuid;

  @override
  String get entityType => 'exercise';

  Stream<List<Exercise>> watchAll(ExerciseFilters filters) =>
      _local.watchAll(filters);

  Future<Exercise?> findById(String id) => _local.findById(id);

  Future<void> refreshFromRemote(ExerciseFilters filters) async {
    final list = await _remote.fetchAll(filters);
    await _local.upsertAll(list);
  }

  Future<Exercise> create({
    required String name,
    required String? description,
    required MuscleGroup muscleGroup,
    required ExerciseCategory category,
    required String creatorId,
  }) async {
    final now = DateTime.now().toUtc();
    final exercise = Exercise(
      id: _uuid.v4(),
      name: name,
      description: description,
      muscleGroup: muscleGroup,
      category: category,
      isSystem: false,
      creatorId: creatorId,
      createdAt: now,
      updatedAt: now,
    );

    await _local.upsert(exercise);
    await _sync.enqueue(
      entityType: entityType,
      entityId: exercise.id,
      operation: SyncOp.create,
      payload: jsonEncode(exercise.toJson()),
    );
    unawaited(_sync.drainPending());

    return exercise;
  }

  Future<void> update(Exercise exercise) async {
    final updated = exercise.copyWith(updatedAt: DateTime.now().toUtc());
    await _local.upsert(updated);
    await _sync.enqueue(
      entityType: entityType,
      entityId: updated.id,
      operation: SyncOp.update,
      payload: jsonEncode(updated.toJson()),
    );
    unawaited(_sync.drainPending());
  }

  Future<void> delete(String id) async {
    await _local.deleteById(id);
    await _sync.enqueue(
      entityType: entityType,
      entityId: id,
      operation: SyncOp.delete,
      payload: null,
    );
    unawaited(_sync.drainPending());
  }

  @override
  Future<void> handle(SyncOperation op) async {
    switch (op.operation) {
      case SyncOp.create:
        final exercise = Exercise.fromJson(jsonDecode(op.payload!) as Map<String, dynamic>);
        final result = await _remote.create(exercise);
        await _local.upsert(result);
      case SyncOp.update:
        final exercise = Exercise.fromJson(jsonDecode(op.payload!) as Map<String, dynamic>);
        final result = await _remote.update(exercise);
        await _local.upsert(result);
      case SyncOp.delete:
        await _remote.delete(op.entityId);
    }
  }
}
```

- [ ] **Step 4: Run test — verify it passes**

```bash
flutter test test/features/exercise/data/repositories/exercise_repository_test.dart
```
Expected: 9 tests, all pass.

- [ ] **Step 5: Commit**

```bash
git add apps/sheipe_app/lib/features/exercise/data/repositories apps/sheipe_app/test/features/exercise/data
git commit -m "feat(app): add ExerciseRepository with offline-first writes and SyncHandler"
```

---

### Task C5: ExerciseViewModel + state + tests

**Files:**
- Create: `apps/sheipe_app/lib/features/exercise/presentation/viewmodels/exercise_state.dart`
- Create: `apps/sheipe_app/test/features/exercise/presentation/viewmodels/exercise_view_model_test.dart`
- Create: `apps/sheipe_app/lib/features/exercise/presentation/viewmodels/exercise_view_model.dart`

- [ ] **Step 1: Define ExerciseState**

Create `apps/sheipe_app/lib/features/exercise/presentation/viewmodels/exercise_state.dart`:

```dart
import '../../data/filters/exercise_filters.dart';
import '../../domain/entities/exercise.dart';

sealed class ExerciseState {
  const ExerciseState({required this.filters});

  final ExerciseFilters filters;
}

final class ExerciseInitial extends ExerciseState {
  const ExerciseInitial() : super(filters: ExerciseFilters.empty);
}

final class ExerciseLoading extends ExerciseState {
  const ExerciseLoading({required super.filters});
}

final class ExerciseLoaded extends ExerciseState {
  const ExerciseLoaded({
    required super.filters,
    required this.exercises,
    this.refreshing = false,
  });

  final List<Exercise> exercises;
  final bool refreshing;

  ExerciseLoaded copyWith({
    ExerciseFilters? filters,
    List<Exercise>? exercises,
    bool? refreshing,
  }) =>
      ExerciseLoaded(
        filters: filters ?? this.filters,
        exercises: exercises ?? this.exercises,
        refreshing: refreshing ?? this.refreshing,
      );
}

final class ExerciseError extends ExerciseState {
  const ExerciseError({required super.filters, required this.message});

  final String message;
}
```

- [ ] **Step 2: Write failing ViewModel test**

Create `apps/sheipe_app/test/features/exercise/presentation/viewmodels/exercise_view_model_test.dart`:

```dart
import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sheipe_app/features/exercise/data/filters/exercise_filters.dart';
import 'package:sheipe_app/features/exercise/data/repositories/exercise_repository.dart';
import 'package:sheipe_app/features/exercise/domain/entities/exercise.dart';
import 'package:sheipe_app/features/exercise/presentation/viewmodels/exercise_state.dart';
import 'package:sheipe_app/features/exercise/presentation/viewmodels/exercise_view_model.dart';

class MockExerciseRepository extends Mock implements ExerciseRepository {}

Exercise _ex({String id = 'a', String name = 'Bench'}) => Exercise(
      id: id,
      name: name,
      muscleGroup: MuscleGroup.chest,
      category: ExerciseCategory.strength,
      isSystem: true,
      creatorId: null,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

void main() {
  late MockExerciseRepository repo;

  setUpAll(() {
    registerFallbackValue(ExerciseFilters.empty);
  });

  setUp(() {
    repo = MockExerciseRepository();
  });

  group('load', () {
    blocTest<ExerciseViewModel, ExerciseState>(
      'emits Loading then Loaded with stream items',
      build: () {
        when(() => repo.watchAll(any())).thenAnswer(
          (_) => Stream.value([_ex(id: 'a'), _ex(id: 'b')]),
        );
        when(() => repo.refreshFromRemote(any())).thenAnswer((_) async {});
        return ExerciseViewModel(repository: repo, currentUserId: 'u');
      },
      act: (vm) => vm.load(),
      expect: () => [
        isA<ExerciseLoading>(),
        predicate<ExerciseLoaded>((s) => s.exercises.length == 2 && s.refreshing == true),
        predicate<ExerciseLoaded>((s) => s.exercises.length == 2 && s.refreshing == false),
      ],
      verify: (_) => verify(() => repo.refreshFromRemote(any())).called(1),
    );
  });

  group('applyFilters', () {
    blocTest<ExerciseViewModel, ExerciseState>(
      're-subscribes with new filters and refreshes from remote',
      build: () {
        when(() => repo.watchAll(any())).thenAnswer((_) => Stream.value([_ex()]));
        when(() => repo.refreshFromRemote(any())).thenAnswer((_) async {});
        return ExerciseViewModel(repository: repo, currentUserId: 'u');
      },
      seed: () => const ExerciseInitial(),
      act: (vm) => vm.applyFilters(const ExerciseFilters(muscleGroup: MuscleGroup.chest)),
      expect: () => [
        predicate<ExerciseLoading>((s) => s.filters.muscleGroup == MuscleGroup.chest),
        predicate<ExerciseLoaded>(
          (s) => s.filters.muscleGroup == MuscleGroup.chest && s.refreshing == true,
        ),
        predicate<ExerciseLoaded>((s) => s.refreshing == false),
      ],
    );
  });

  group('createExercise', () {
    blocTest<ExerciseViewModel, ExerciseState>(
      'delegates to repository.create',
      build: () {
        when(() => repo.create(
              name: any(named: 'name'),
              description: any(named: 'description'),
              muscleGroup: any(named: 'muscleGroup'),
              category: any(named: 'category'),
              creatorId: any(named: 'creatorId'),
            )).thenAnswer((_) async => _ex(id: 'new'));
        return ExerciseViewModel(repository: repo, currentUserId: 'u');
      },
      act: (vm) => vm.createExercise(
        name: 'Squat',
        description: null,
        muscleGroup: MuscleGroup.legs,
        category: ExerciseCategory.strength,
      ),
      verify: (_) => verify(() => repo.create(
            name: 'Squat',
            description: null,
            muscleGroup: MuscleGroup.legs,
            category: ExerciseCategory.strength,
            creatorId: 'u',
          )).called(1),
    );
  });

  group('deleteExercise', () {
    blocTest<ExerciseViewModel, ExerciseState>(
      'delegates to repository.delete',
      build: () {
        when(() => repo.delete(any())).thenAnswer((_) async {});
        return ExerciseViewModel(repository: repo, currentUserId: 'u');
      },
      act: (vm) => vm.deleteExercise('id-1'),
      verify: (_) => verify(() => repo.delete('id-1')).called(1),
    );
  });

  group('error path', () {
    blocTest<ExerciseViewModel, ExerciseState>(
      'emits ExerciseError when refreshFromRemote throws',
      build: () {
        when(() => repo.watchAll(any())).thenAnswer((_) => Stream.value([_ex()]));
        when(() => repo.refreshFromRemote(any())).thenThrow(Exception('network down'));
        return ExerciseViewModel(repository: repo, currentUserId: 'u');
      },
      act: (vm) => vm.load(),
      expect: () => [
        isA<ExerciseLoading>(),
        predicate<ExerciseLoaded>((s) => s.refreshing == true),
        predicate<ExerciseError>((s) => s.message.contains('network down')),
      ],
    );
  });
}
```

- [ ] **Step 3: Run test — verify it fails**

```bash
flutter test test/features/exercise/presentation/viewmodels/exercise_view_model_test.dart
```
Expected: failure with `Target of URI doesn't exist: 'package:sheipe_app/features/exercise/presentation/viewmodels/exercise_view_model.dart'`.

- [ ] **Step 4: Implement ViewModel**

Create `apps/sheipe_app/lib/features/exercise/presentation/viewmodels/exercise_view_model.dart`:

```dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/filters/exercise_filters.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../domain/entities/exercise.dart';
import 'exercise_state.dart';

class ExerciseViewModel extends Cubit<ExerciseState> {
  ExerciseViewModel({
    required ExerciseRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId,
        super(const ExerciseInitial());

  final ExerciseRepository _repository;
  final String _currentUserId;
  StreamSubscription<List<Exercise>>? _subscription;

  String get currentUserId => _currentUserId;

  Future<void> load() => _subscribe(state.filters);

  Future<void> applyFilters(ExerciseFilters filters) => _subscribe(filters);

  Future<void> _subscribe(ExerciseFilters filters) async {
    emit(ExerciseLoading(filters: filters));
    await _subscription?.cancel();
    _subscription = _repository.watchAll(filters).listen((exercises) {
      final current = state;
      final refreshing = current is ExerciseLoaded ? current.refreshing : true;
      emit(ExerciseLoaded(filters: filters, exercises: exercises, refreshing: refreshing));
    });

    try {
      await _repository.refreshFromRemote(filters);
      final current = state;
      if (current is ExerciseLoaded) {
        emit(current.copyWith(refreshing: false));
      }
    } catch (e) {
      emit(ExerciseError(filters: filters, message: e.toString()));
    }
  }

  Future<Exercise> createExercise({
    required String name,
    required String? description,
    required MuscleGroup muscleGroup,
    required ExerciseCategory category,
  }) {
    return _repository.create(
      name: name,
      description: description,
      muscleGroup: muscleGroup,
      category: category,
      creatorId: _currentUserId,
    );
  }

  Future<void> updateExercise(Exercise exercise) => _repository.update(exercise);

  Future<void> deleteExercise(String id) => _repository.delete(id);

  Future<Exercise?> findById(String id) => _repository.findById(id);

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
```

- [ ] **Step 5: Run test — verify it passes**

```bash
flutter test test/features/exercise/presentation/viewmodels/exercise_view_model_test.dart
```
Expected: 5 tests, all pass.

- [ ] **Step 6: Commit**

```bash
git add apps/sheipe_app/lib/features/exercise/presentation/viewmodels apps/sheipe_app/test/features/exercise/presentation
git commit -m "feat(app): add ExerciseViewModel and ExerciseState"
```

---

# Phase D — Flutter UI + wiring

---

### Task D1: ExerciseLibraryScreen

**Files:**
- Create: `apps/sheipe_app/lib/features/exercise/presentation/screens/exercise_library_screen.dart`

- [ ] **Step 1: Create screen**

Create `apps/sheipe_app/lib/features/exercise/presentation/screens/exercise_library_screen.dart`:

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/filters/exercise_filters.dart';
import '../../domain/entities/exercise.dart';
import '../viewmodels/exercise_state.dart';
import '../viewmodels/exercise_view_model.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseViewModel>().load();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final vm = context.read<ExerciseViewModel>();
      vm.applyFilters(vm.state.filters.copyWith(query: value, clearQuery: value.isEmpty));
    });
  }

  void _selectMuscleGroup(MuscleGroup? group) {
    final vm = context.read<ExerciseViewModel>();
    vm.applyFilters(vm.state.filters.copyWith(
      muscleGroup: group,
      clearMuscleGroup: group == null,
    ));
  }

  void _selectCategory(ExerciseCategory? category) {
    final vm = context.read<ExerciseViewModel>();
    vm.applyFilters(vm.state.filters.copyWith(
      category: category,
      clearCategory: category == null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercises')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/exercises/new'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search exercises',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: _onQueryChanged,
            ),
          ),
          BlocBuilder<ExerciseViewModel, ExerciseState>(
            buildWhen: (a, b) => a.filters != b.filters,
            builder: (context, state) => _FilterChips(
              filters: state.filters,
              onMuscleGroup: _selectMuscleGroup,
              onCategory: _selectCategory,
            ),
          ),
          Expanded(
            child: BlocBuilder<ExerciseViewModel, ExerciseState>(
              builder: (context, state) {
                return switch (state) {
                  ExerciseInitial() ||
                  ExerciseLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  ExerciseError(message: final m) => _ErrorView(
                      message: m,
                      onRetry: () => context.read<ExerciseViewModel>().load(),
                    ),
                  ExerciseLoaded(:final exercises) when exercises.isEmpty =>
                    const _EmptyView(),
                  ExerciseLoaded(:final exercises) => RefreshIndicator(
                      onRefresh: () => context.read<ExerciseViewModel>().load(),
                      child: ListView.separated(
                        itemCount: exercises.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final ex = exercises[i];
                          return ListTile(
                            title: Text(ex.name),
                            subtitle: Text('${ex.muscleGroup.apiValue} • ${ex.category.apiValue}'),
                            trailing: ex.isSystem
                                ? const Icon(Icons.lock_outline, size: 16)
                                : const Icon(Icons.chevron_right),
                            onTap: () => context.go('/exercises/${ex.id}'),
                          );
                        },
                      ),
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.onMuscleGroup,
    required this.onCategory,
  });

  final ExerciseFilters filters;
  final ValueChanged<MuscleGroup?> onMuscleGroup;
  final ValueChanged<ExerciseCategory?> onCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (final group in MuscleGroup.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(group.apiValue),
                selected: filters.muscleGroup == group,
                onSelected: (selected) => onMuscleGroup(selected ? group : null),
              ),
            ),
          const VerticalDivider(),
          for (final category in ExerciseCategory.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category.apiValue),
                selected: filters.category == category,
                onSelected: (selected) => onCategory(selected ? category : null),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No exercises match the current filters.',
            textAlign: TextAlign.center,
          ),
        ),
      );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(message, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
}
```

- [ ] **Step 2: Verify analyze**

```bash
flutter analyze lib/features/exercise/presentation/screens/exercise_library_screen.dart
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/features/exercise/presentation/screens/exercise_library_screen.dart
git commit -m "feat(app): add ExerciseLibraryScreen with search, filter chips, and refresh"
```

---

### Task D2: ExerciseDetailScreen

**Files:**
- Create: `apps/sheipe_app/lib/features/exercise/presentation/screens/exercise_detail_screen.dart`

- [ ] **Step 1: Create screen**

Create `apps/sheipe_app/lib/features/exercise/presentation/screens/exercise_detail_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/exercise.dart';
import '../viewmodels/exercise_view_model.dart';

class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late Future<Exercise?> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<ExerciseViewModel>().findById(widget.exerciseId);
  }

  Future<void> _confirmDelete(Exercise exercise) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete exercise?'),
        content: Text('Permanently remove "${exercise.name}".'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    await context.read<ExerciseViewModel>().deleteExercise(exercise.id);
    if (!mounted) return;
    context.go('/exercises');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise')),
      body: FutureBuilder<Exercise?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final exercise = snapshot.data;
          if (exercise == null) {
            return const Center(child: Text('Not found'));
          }

          final vm = context.read<ExerciseViewModel>();
          final canEdit = !exercise.isSystem && exercise.ownedBy(vm.currentUserId);

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(exercise.muscleGroup.apiValue)),
                    Chip(label: Text(exercise.category.apiValue)),
                    if (exercise.isSystem) const Chip(label: Text('System')),
                  ],
                ),
                const SizedBox(height: 16),
                if (exercise.description != null && exercise.description!.isNotEmpty)
                  Text(exercise.description!, style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                if (canEdit) ...[
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.go('/exercises/${exercise.id}/edit'),
                      child: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _confirmDelete(exercise),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyze**

```bash
flutter analyze lib/features/exercise/presentation/screens/exercise_detail_screen.dart
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/features/exercise/presentation/screens/exercise_detail_screen.dart
git commit -m "feat(app): add ExerciseDetailScreen with edit/delete for owned exercises"
```

---

### Task D3: ExerciseFormScreen (create/edit)

**Files:**
- Create: `apps/sheipe_app/lib/features/exercise/presentation/screens/exercise_form_screen.dart`

- [ ] **Step 1: Create screen**

Create `apps/sheipe_app/lib/features/exercise/presentation/screens/exercise_form_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/exercise.dart';
import '../viewmodels/exercise_view_model.dart';

class ExerciseFormScreen extends StatefulWidget {
  const ExerciseFormScreen({super.key, this.exerciseId});

  final String? exerciseId; // null = create

  @override
  State<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  MuscleGroup _muscleGroup = MuscleGroup.chest;
  ExerciseCategory _category = ExerciseCategory.strength;
  Exercise? _existing;
  bool _loading = false;
  bool _submitting = false;

  bool get _isEdit => widget.exerciseId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _loadExisting();
    }
  }

  Future<void> _loadExisting() async {
    setState(() => _loading = true);
    final ex = await context.read<ExerciseViewModel>().findById(widget.exerciseId!);
    if (!mounted) return;
    if (ex != null) {
      _existing = ex;
      _nameController.text = ex.name;
      _descriptionController.text = ex.description ?? '';
      _muscleGroup = ex.muscleGroup;
      _category = ex.category;
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    final vm = context.read<ExerciseViewModel>();
    try {
      if (_isEdit && _existing != null) {
        final updated = _existing!.copyWith(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          muscleGroup: _muscleGroup,
          category: _category,
        );
        await vm.updateExercise(updated);
      } else {
        await vm.createExercise(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          muscleGroup: _muscleGroup,
          category: _category,
        );
      }
      if (!mounted) return;
      context.go('/exercises');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit exercise' : 'New exercise')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<MuscleGroup>(
                      initialValue: _muscleGroup,
                      decoration: const InputDecoration(labelText: 'Muscle group'),
                      items: [
                        for (final g in MuscleGroup.values)
                          DropdownMenuItem(value: g, child: Text(g.apiValue)),
                      ],
                      onChanged: (v) => setState(() => _muscleGroup = v ?? _muscleGroup),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ExerciseCategory>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: [
                        for (final c in ExerciseCategory.values)
                          DropdownMenuItem(value: c, child: Text(c.apiValue)),
                      ],
                      onChanged: (v) => setState(() => _category = v ?? _category),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description (optional)'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(_isEdit ? 'Save' : 'Create'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
```

- [ ] **Step 2: Verify analyze**

```bash
flutter analyze lib/features/exercise/presentation/screens/exercise_form_screen.dart
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/features/exercise/presentation/screens/exercise_form_screen.dart
git commit -m "feat(app): add ExerciseFormScreen for create and edit"
```

---

### Task D4: DI registration

**Files:**
- Modify: `apps/sheipe_app/lib/core/di/service_locator.dart`

- [ ] **Step 1: Wire exercise + sync deps**

Replace the entire contents of `apps/sheipe_app/lib/core/di/service_locator.dart` with:

```dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../network/auth_event.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../storage/app_database.dart';
import '../sync/sync_service.dart';
import '../../app_router.dart';
import '../../features/auth/data/local/auth_local_data_source.dart';
import '../../features/auth/data/remote/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/viewmodels/auth_state.dart';
import '../../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../../features/exercise/data/local/exercise_local_data_source.dart';
import '../../features/exercise/data/remote/exercise_remote_data_source.dart';
import '../../features/exercise/data/repositories/exercise_repository.dart';
import '../../features/exercise/presentation/viewmodels/exercise_view_model.dart';

final sl = GetIt.instance;

class ServiceLocator {
  ServiceLocator._(); // coverage:ignore-line

  static Future<void> init() async {
    const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');

    sl.registerLazySingleton<AppDatabase>(
      () => AppDatabase(), // coverage:ignore-line
      dispose: (db) => db.close(), // coverage:ignore-line
    );

    final authEventController = StreamController<AuthEvent>.broadcast();
    sl.registerSingleton<StreamController<AuthEvent>>(authEventController);

    const storage = FlutterSecureStorage();
    final localDataSource = AuthLocalDataSource(storage: storage);
    sl.registerSingleton<AuthLocalDataSource>(localDataSource);

    sl.registerLazySingleton<AuthInterceptor>(
      () => AuthInterceptor(
        localDataSource: localDataSource,
        authEventSink: authEventController.sink,
        baseUrl: baseUrl,
      ),
    );

    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(
        baseUrl: baseUrl,
        authInterceptor: sl<AuthInterceptor>(),
      ),
    );

    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(dio: sl<ApiClient>().dio),
    );

    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        local: localDataSource,
        remote: sl<AuthRemoteDataSource>(),
        authEventController: authEventController,
      ),
    );

    sl.registerLazySingleton<AuthViewModel>(
      () => AuthViewModel(repository: sl<AuthRepository>()),
      dispose: (vm) => vm.close(),
    );

    sl.registerLazySingleton<AppRouter>(
      () => AppRouter(authViewModel: sl<AuthViewModel>()),
    );

    // Sync foundation
    sl.registerLazySingleton<SyncService>(
      () => SyncService(database: sl<AppDatabase>()),
    );

    // Exercise feature
    sl.registerLazySingleton<ExerciseLocalDataSource>(
      () => ExerciseLocalDataSource(database: sl<AppDatabase>()),
    );
    sl.registerLazySingleton<ExerciseRemoteDataSource>(
      () => ExerciseRemoteDataSource(dio: sl<ApiClient>().dio),
    );
    sl.registerLazySingleton<ExerciseRepository>(
      () => ExerciseRepository(
        local: sl<ExerciseLocalDataSource>(),
        remote: sl<ExerciseRemoteDataSource>(),
        syncService: sl<SyncService>(),
      ),
    );
    sl.registerFactory<ExerciseViewModel>(() {
      final state = sl<AuthViewModel>().state;
      final userId = state is AuthAuthenticated ? state.user.id : '';
      return ExerciseViewModel(
        repository: sl<ExerciseRepository>(),
        currentUserId: userId,
      );
    });

    // Register repository as a SyncHandler.
    sl<SyncService>().registerHandler(sl<ExerciseRepository>());
  }

  /// Called from main.dart after auth is ready to start the connectivity loop.
  static void startSyncService() {
    final connectivityStream = Connectivity()
        .onConnectivityChanged
        .map((results) => results.any((r) => r != ConnectivityResult.none));
    sl<SyncService>().start(connectivityStream: connectivityStream);
    // Try once at boot regardless of connectivity events.
    sl<SyncService>().drainPending();
  }
}
```

- [ ] **Step 2: Verify analyze**

```bash
flutter analyze lib/core/di
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add apps/sheipe_app/lib/core/di/service_locator.dart
git commit -m "feat(app): wire exercise feature and SyncService into ServiceLocator"
```

---

### Task D5: Routes + start SyncService at boot

**Files:**
- Modify: `apps/sheipe_app/lib/app_router.dart`
- Modify: `apps/sheipe_app/lib/main.dart`

- [ ] **Step 1: Add exercise routes**

Modify `apps/sheipe_app/lib/app_router.dart`. Add the imports near the top (after the auth view model import):

```dart
import 'core/di/service_locator.dart';
import 'features/exercise/presentation/screens/exercise_library_screen.dart';
import 'features/exercise/presentation/screens/exercise_detail_screen.dart';
import 'features/exercise/presentation/screens/exercise_form_screen.dart';
import 'features/exercise/presentation/viewmodels/exercise_view_model.dart';
```

Inside the `routes:` list (after the `/profile/edit` GoRoute, before the closing `]`), add:

```dart
        GoRoute(
          path: '/exercises',
          builder: (context, state) => BlocProvider(
            create: (_) => sl<ExerciseViewModel>(),
            child: const ExerciseLibraryScreen(),
          ),
        ),
        GoRoute(
          path: '/exercises/new',
          builder: (context, state) => BlocProvider(
            create: (_) => sl<ExerciseViewModel>(),
            child: const ExerciseFormScreen(),
          ),
        ),
        GoRoute(
          path: '/exercises/:id',
          builder: (context, state) => BlocProvider(
            create: (_) => sl<ExerciseViewModel>(),
            child: ExerciseDetailScreen(exerciseId: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/exercises/:id/edit',
          builder: (context, state) => BlocProvider(
            create: (_) => sl<ExerciseViewModel>(),
            child: ExerciseFormScreen(exerciseId: state.pathParameters['id']!),
          ),
        ),
```

Also update `_redirect` so authenticated users on `/exercises*` are not bounced. Inspect the function — the existing logic already permits any non-auth path when authenticated, so no change is needed. Verify by reading `_redirect` end-to-end.

- [ ] **Step 2: Start SyncService on app boot**

Modify `apps/sheipe_app/lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  ServiceLocator.startSyncService();
  runApp(const MyApp());
}
```

- [ ] **Step 3: Verify analyze**

```bash
flutter analyze lib/
```
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add apps/sheipe_app/lib/app_router.dart apps/sheipe_app/lib/main.dart
git commit -m "feat(app): wire /exercises routes and start SyncService on boot"
```

---

### Task D6: Final verification + commit

**Files:** none (verification only)

- [ ] **Step 1: Full Rails test suite**

From `apps/sheipe_api/`:
```bash
bundle exec rspec
```
Expected: 0 failures.

- [ ] **Step 2: Full Flutter test suite**

From `apps/sheipe_app/`:
```bash
flutter test
```
Expected: 0 failures across all suites.

- [ ] **Step 3: Flutter analyze**

```bash
flutter analyze
```
Expected: `No issues found!`

- [ ] **Step 4: Manual smoke test (golden path)**

In two terminals:

```bash
# Terminal 1 — API
cd apps/sheipe_api && bin/rails server
```

```bash
# Terminal 2 — Flutter
cd apps/sheipe_app && flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

Walk through:
1. Register a new user (existing auth flow)
2. From profile, navigate manually to `/exercises` (push the route via deep link or temporarily add a "Exercises" button on `_HomePlaceholder` for the smoke test only)
3. List loads with ~34 system exercises
4. Search "bench" → only Bench Press visible
5. Filter by `legs` → only leg exercises
6. Tap `+` → create "Smoke Test Squat", muscle_group=legs
7. Verify it appears in the list and remote (`bin/rails runner 'puts Exercise.where(name: "Smoke Test Squat").count'` → `1`)
8. Tap the new exercise → Detail screen shows Edit/Delete
9. Edit → change name → Save → list reflects new name
10. Delete → confirms → list no longer shows it

If any step fails, file the bug as a blocker.

- [ ] **Step 5: openspec validate (no code change)**

From `/workspace`:
```bash
ls openspec/changes/fase-2-core-treino/
```
Verify the change folder still has `proposal.md`, `design.md`, `tasks.md`, and `specs/` — no archive yet (the change is not complete; only the Exercise slice is).

- [ ] **Step 6: Final summary commit (only if anything is uncommitted)**

```bash
git status
```
If anything is uncommitted from the smoke test, address it. Otherwise, the slice is complete.

---

## Spec coverage

Each spec requirement maps to at least one task:

| Requirement (exercise-management/spec.md) | Task |
|---|---|
| List and filter exercises | A7 (request spec covers all 6 scenarios) |
| Get exercise details | A7 (4 show-related scenarios) |
| Create custom exercise | A7 (3 create-related scenarios) |
| Update custom exercise | A7 (3 update-related scenarios) |
| Delete custom exercise | A7 (3 delete-related scenarios) |

| Requirement (offline-sync/spec.md) | Task |
|---|---|
| Write-first local persistence | C4 (`create`/`update`/`delete` write to local then enqueue), test asserts ordering |
| Background sync | B3 (drainPending iterates queue and marks synced), C4 (handle method runs remote calls) |
| Initial data load | C5 (`load` → watch + refreshFromRemote), D5 (drainPending at boot) |
| Conflict resolution (server-newer / local-newer) | C2 + C4 (`upsertAll` overwrites by PK; payload contains snapshot at write time so push wins on push) — full updated_at LWW will be exercised across slices when Routine/Workout add multi-write contention |

> **Note on conflict resolution:** The Exercise slice ships the foundation but does not implement explicit `updated_at` comparison. The slice satisfies the offline-sync scenarios for write-first, drain, and initial load. The `Routine` slice (fase-2b) MUST add explicit `updated_at` comparison in `upsertAll` to fulfill the LWW conflict scenarios end-to-end; this is documented in fase-2b plan as a foundational task that also retroactively applies to Exercise.

---

## Definition of Done

The Exercise slice is complete when:
- Rails: `bundle exec rspec` passes with the 17+ new exercise specs and the existing Phase 1 specs.
- Flutter: `flutter analyze` shows no issues; `flutter test` passes including the new sync, repository, and view model suites.
- The smoke test in D6 step 4 succeeds end-to-end.
- All commits in the slice are pushed (or staged for PR).
- The plan file (`docs/superpowers/plans/2026-05-02-fase-2a-exercise.md`) and this todo list are updated to reflect completion.
