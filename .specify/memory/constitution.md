<!--
SYNC IMPACT REPORT
==================
Version change: template → 1.0.0
Ratified: 2026-04-19

Principles added (all new — first ratification):
  - I.   Offline-First (NON-NEGOTIABLE)
  - II.  API-First
  - III. Test-First / TDD (NON-NEGOTIABLE) — 95% minimum coverage
  - IV.  Role-Based Authorization
  - V.   Privacy by Default

Templates updated:
  ✅ .specify/templates/tasks-template.md
       — Tests changed from OPTIONAL to MANDATORY (TDD principle)
       — Test section headers updated to reflect NON-NEGOTIABLE status
  ✅ .specify/memory/constitution.md
       — This file (first ratification)
  ⚠️  .specify/templates/plan-template.md
       — Constitution Check section is a dynamic placeholder [Gates determined
         based on constitution file] — no update needed; /speckit.plan will
         fill it against the 5 principles at plan-creation time.
  ⚠️  .specify/templates/spec-template.md
       — No structural changes required; offline-first and privacy constraints
         will surface naturally in Assumptions and Requirements sections.

Deferred TODOs: none
-->

# Sheipe Constitution

## Core Principles

### I. Offline-First (NON-NEGOTIABLE)

The core workout tracking flow — create routine, start workout, log sets —
MUST work without internet connectivity. Rules:

- Drift is the primary data source on the client; the Rails API is synced in
  background after connectivity is restored
- All records MUST use UUID as primary key so the Flutter client can create
  records locally before they reach the server
- Conflicts MUST be resolved by `updated_at` (last-write-wins)
- No feature in the workout tracking domain may depend on a live API connection
  to function; any such dependency MUST be justified and approved as a
  complexity exception

### II. API-First

Every feature MUST ship its Rails API contract before or alongside the Flutter
implementation. Rules:

- No screen is built without a corresponding API endpoint, unless the feature
  is explicitly designated offline-only in its spec
- API contracts MUST follow the conventions in `docs/architecture/api.md`:
  REST, versioned under `/api/v1/`, consistent JSON error format
- Offline-only exceptions MUST be documented in the spec's Assumptions section

### III. Test-First / TDD (NON-NEGOTIABLE)

Tests MUST be written before implementation. The cycle is strictly:
write failing test → get approval → implement → green. Minimum coverage is
**95%** across both apps. Rules:

- **sheipe_api**: RSpec request specs (via `rswag`) for all endpoints; model
  and policy unit specs; integration tests for trainer-athlete data access and
  offline sync contract
- **sheipe_app**: Unit tests for all ViewModels (Cubits); widget tests for
  critical flows (active workout, set logger, auth); integration tests for
  offline sync logic
- No feature is mergeable if coverage drops below 95%
- The tasks template MUST reflect tests as mandatory, never optional

### IV. Role-Based Authorization

Every API resource MUST be protected with `action_policy`. Rules:

- Trainer access to athlete data requires an active record in `TrainerAthlete`
- Gym creation and equipment management are restricted to the `owner` role
- Athletes can only read/write their own data unless a trainer bond is active
- Authorization policies MUST be tested independently from controllers

### V. Privacy by Default

User data MUST be private unless explicitly shared. Rules:

- `WorkoutPost.visibility` MUST default to `private`
- `trainer_notes` on `Workout` is visible only to the assigned trainer and
  their direct athlete — never to third parties
- Social features (post, like, comment, follow) are always opt-in
- No user data may be exposed to other users without an explicit access grant
  modelled in the data schema

## Governance

This constitution supersedes all other practices and conventions in this
repository. Amendments require:

1. A documented justification for why the principle must change
2. An assessment of which existing specs and plans are affected
3. A migration plan for features already implemented under the old principle

All specs (`spec.md`), plans (`plan.md`), and task lists (`tasks.md`) MUST
include a **Constitution Check** section verifying compliance with all five
principles before work begins. For runtime implementation conventions (UUID
PKs, ViewModel pattern, dependency list), refer to `CLAUDE.md`.

**Version**: 1.0.0 | **Ratified**: 2026-04-19 | **Last Amended**: 2026-04-19
