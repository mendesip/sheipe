# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Sheipe is a workout tracking and monitoring app — athletes log and track strength training sessions, trainers manage athletes and assign plans, and users can share workouts socially. It is a monorepo with:
- **`apps/sheipe_app`**: Flutter (Dart) mobile app — single app with role-based navigation (athlete / trainer)
- **`apps/sheipe_api`**: Ruby on Rails API-only backend with PostgreSQL

## Architecture Docs

| Document | Description |
|---|---|
| [`docs/architecture/data-model.md`](docs/architecture/data-model.md) | ER diagram with all entities and relationships |
| [`docs/architecture/api.md`](docs/architecture/api.md) | REST API endpoints, auth strategy, pagination and error conventions |
| [`docs/architecture/screens.md`](docs/architecture/screens.md) | Screen map organized by role and navigation flow |

## Repository Structure

```
sheipe/
├── apps/
│   ├── sheipe_app/    # Flutter app
│   └── sheipe_api/    # Rails API backend
└── docs/
    └── architecture/  # Data model, API spec, screen map
```

## Conventions

### sheipe_api
- All models use UUID as primary key — enable `uuid-ossp` in the initial migration and set `id: :uuid, default: "gen_random_uuid()"` on every `create_table`
- Never use integer auto-increment PKs — required for offline-first client-side record creation

### sheipe_app
- State management via Cubit only, named `*ViewModel` (e.g. `WorkoutViewModel`) — no business logic in widgets
- Repository pattern: every feature has an `abstract *Repository` implemented by `*RepositoryImpl` which composes a `*LocalDataSource` (Drift) and a `*RemoteDataSource` (Dio)
- Drift is the source of truth on the client — write locally first, sync with API in background

## sheipe_app (Flutter)

```bash
cd apps/sheipe_app
flutter pub get                                   # Install dependencies
flutter run                                       # Run on connected device/emulator
flutter build apk                                 # Build Android APK
flutter build ios                                 # Build iOS
flutter test                                      # Run all tests
flutter test test/path/to/file_test.dart          # Run a single test
flutter analyze                                   # Lint / static analysis
```

## sheipe_api (Rails)

Rails API-only app (`rails new --api --database=postgresql`). Auth uses the Rails 8 generator adapted for Bearer tokens. All models use UUID as primary key (`uuid-ossp`). See [`docs/architecture/api.md`](docs/architecture/api.md) for endpoint reference.

```bash
cd apps/sheipe_api
bundle install                                    # Install dependencies
rails db:create db:migrate db:seed                # Set up database
rails server                                      # Start dev server (localhost:3000)
rails test                                        # Run all tests
rails test test/path/to/test_file.rb              # Run a single test file
rubocop                                           # Lint
```

### Key gems
| Gem | Purpose |
|---|---|
| `action_policy` | Authorization |
| `pagy` | Pagination (offset for lists, keyset for feed) |
| `alba` | JSON serialization |
| `rack-attack` | Rate limiting |
| `ar_lazy_preload` | Automatic N+1 prevention |
| `rswag` | OpenAPI docs from RSpec request specs |
