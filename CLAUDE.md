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
├── docs/
│   └── architecture/  # Data model, API spec, screen map
└── openspec/          # OpenSpec SDD artifacts
    ├── specs/         # Living behavioral contracts — current system truth
    ├── changes/       # In-flight changes (one folder per feature)
    │   └── archive/   # Completed changes — auditable history
    └── config.yaml    # OpenSpec configuration
```

## Development Workflow (SDD)

This project uses **OpenSpec + Superpowers** for spec-driven development.

### Artifacts per change (`changes/<name>/`)
| File | Required | Purpose |
|---|---|---|
| `proposal.md` | Yes | Why (problem/opportunity), what changes, impact |
| `specs/` | Yes | Behavioral requirements + Given/When/Then scenarios |
| `design.md` | Conditional | Architecture decisions — only for cross-cutting/security/ambiguous changes |
| `tasks.md` | Yes | `- [ ] X.Y task` dependency-ordered checklist |

### Lifecycle
```
/opsx:propose "feature"   → generates change folder artifacts
                          → brainstorming skill refines proposal
                          → writing-plans skill enriches tasks.md
/opsx:apply               → executing-plans skill drives tasks.md checkboxes
                          → test-driven-development skill consumes Scenarios as test cases
                          → verification-before-completion validates against Requirements
/opsx:archive             → merges delta specs into specs/, timestamps change folder
                          → finishing-a-development-branch skill
```

### Spec format
- `specs/**/spec.md` use RFC 2119 language (SHALL/MUST/SHOULD/MAY)
- `### Requirement: <name>` — system behavior contract
- `#### Scenario:` — Given/When/Then testable example (exactly 4 `#`)
- Delta specs in `openspec/changes/<name>/specs/` use ADDED / MODIFIED / REMOVED sections
