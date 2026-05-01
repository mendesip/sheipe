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
│   ├── sheipe_app/    # Flutter app — see apps/sheipe_app/CLAUDE.md
│   └── sheipe_api/    # Rails API backend — see apps/sheipe_api/CLAUDE.md
└── docs/
    └── architecture/  # Data model, API spec, screen map
```

## Recent Changes
- 001-monorepo-scaffold: Rails 8 API + Flutter app scaffold; pgcrypto UUID PKs; Drift DB bootstrap; GoRouter auth guard; Repository contracts
