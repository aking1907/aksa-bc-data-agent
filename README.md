# BC Data Agent

BC Data Agent is a Business Central AL project for a governed data correction extension. The main idea is to let authorized users correct normally hidden or posted Business Central data when standard correction workflows are not enough, while tracking every change and supporting rollback if something goes wrong.

The project is currently documentation-only. No AL code should be generated until the readiness gate allows it.

## Why It Matters

Changing hidden or posted data is powerful and risky. This project treats those changes as break-glass operations available only to existing Business Central `SUPER` users, with policy, approval, audit, and rollback requirements.

## Current Capabilities

- AL project manifest exists in `app.json`.
- `app.json` targets Business Central 2026 release wave 1 / version 28.0 with AL runtime 17.0.
- Business Central-oriented `.gitignore` exists.
- SDD documentation baseline exists under `docs/`.
- Code generation is currently blocked by `docs/code-generation-readiness.md`.

## Current Boundaries

- No AL source objects have been created.
- No data modification behavior has been implemented.
- No BCDA-specific permission sets should be created; access is for existing Business Central `SUPER` users only.
- Rollback snapshot logging is configurable; mandatory audit metadata remains required.
- Retention for app-owned operation records is user-controlled by category.
- External APIs are out of scope for Phase 1.
- Posted data changes must be explicitly allowed, approved, audited, and rollback-aware.

## Project Structure

| Path | Purpose |
| --- | --- |
| `app.json` | Business Central AL app manifest. |
| `.vscode/launch.json` | Local AL launch configuration. |
| `.gitignore` | Ignores AL packages, snapshots, cache, and generated packages. |
| `.codex/skills/` | Project-local skills for SDD, architecture, AL implementation, UX, security, tests, release, and symbol discovery. |
| `.codex/prompts/` | Reusable project prompts for kickoff, SDD, architecture, UX, security, testing, release, and gated implementation workflows. |
| `docs/sdd-index.md` | Source-of-truth documentation map. |
| `docs/code-generation-readiness.md` | Gate before any AL code generation. |
| `docs/security-review.md` | Security and risk review for high-risk data correction behavior. |

## Key Documentation

- `docs/project.md`
- `docs/requirements.md`
- `docs/architecture.md`
- `docs/app-design.md`
- `docs/al-development-standards.md`
- `docs/readiness-audit.md`
- `docs/acceptance-criteria.md`
- `docs/implementation-plan.md`
- `docs/test-plan.md`
- `docs/risk-register.md`
- `docs/release-notes.md`

## Project Skills

The `.codex/skills/` folder contains implementation guardrail skills:

- `bcda-sdd-steward`
- `bcda-architecture-guardian`
- `bcda-al-implementation`
- `bcda-security-audit`
- `bcda-ux-design`
- `bcda-test-validation`
- `bcda-release-ops`
- `bcda-symbol-discovery`

## Project Prompts

Reusable prompts live in `.codex/prompts/`. Start with `session-kickoff.prompt.md` for a new session, use `readiness-review.prompt.md` before implementation, and use `al-implementation-ready.prompt.md` only after the readiness gate is Ready.

## Build Or Run Validation

No build command is available yet because implementation has not started. Before generating AL code, complete symbol discovery and update `docs/code-generation-readiness.md`.

## Demo Story

A `SUPER` user creates a correction request for a sandbox record, previews the old and new values, sees rollback logging and retention impact, receives approval for high-risk data when policy requires it, executes the correction, reviews the audit trail, and rolls the change back while retained snapshots are available.

## Status And Next Steps

Status: SDD documentation baseline prepared.

Next steps:

1. Confirm open decisions in `docs/open-decisions.md`.
2. Download and verify Business Central symbols.
3. Update `docs/symbol-discovery.md`.
4. Change `docs/code-generation-readiness.md` only when implementation is approved.
