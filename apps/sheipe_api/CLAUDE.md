# CLAUDE.md — sheipe_api

Rails API-only backend for Sheipe. PostgreSQL database with UUID primary keys.

## Commands

```bash
bundle install                                    # Install dependencies
rails db:create db:migrate db:seed                # Set up database
rails server                                      # Start dev server (localhost:3000)
bundle exec rspec                                 # Run all tests
bundle exec rspec spec/path/to/file_spec.rb       # Run a single test file
bundle exec rubocop                               # Lint
bundle exec rubocop -a                            # Lint and autocorrect
```

## Dev Container

A dev container is configured at `.devcontainer/` — it provides Ruby 3.3 + PostgreSQL 16 with zero local setup required. Open `apps/sheipe_api/` in VS Code and choose **Reopen in Container**.

## Conventions

- All models use UUID primary keys — `id: :uuid, default: "gen_random_uuid()"` on every `create_table`; `pgcrypto` extension enabled in the initial migration
- Never use integer auto-increment PKs — required for offline-first client-side record creation
- All endpoints live under `/api/v1/` and inherit from `Api::V1::BaseController`
- All error responses follow the shape `{ "error": { "code": string, "message": string, "details": object|null } }`
- Authorization via `action_policy` — every resource must have a policy; policies are tested independently from controllers
- Tests use RSpec (`spec/`); request specs use rswag for OpenAPI documentation

## Key Gems

| Gem | Purpose |
|---|---|
| `action_policy` | Authorization |
| `pagy` | Pagination (offset for lists, keyset for feed) |
| `alba` | JSON serialization |
| `rack-attack` | Rate limiting |
| `ar_lazy_preload` | Automatic N+1 prevention |
| `rswag-api` / `rswag-specs` | OpenAPI docs from RSpec request specs |
| `rack-cors` | CORS — localhost origins in dev; `CORS_ORIGINS` env var in production |
