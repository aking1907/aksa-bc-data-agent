# BC Data Agent

BC Data Agent is a Business Central AL project for a governed data correction extension. The main idea is to let authorized users correct normally hidden or posted Business Central data when standard correction workflows are not enough, while tracking every change and supporting rollback if something goes wrong.

The project has entered Phase 2 foundation implementation. AL generation is currently allowed only for app-owned setup, policy, request, audit, snapshot, rollback-state, retention-log, SUPER-gated shell pages, and supporting services.

## Why It Matters

Changing hidden or posted data is powerful and risky. This project treats those changes as break-glass operations available only to existing Business Central `SUPER` users, with policy, approval, audit, and rollback requirements.

## Current Capabilities

- AL project manifest exists in `app.json`.
- `app.json` targets Business Central 2026 release wave 1 / version 28.0 with AL runtime 17.0.
- Business Central-oriented `.gitignore` exists.
- SDD documentation baseline exists under `docs/`.
- AI cost tracking baseline exists under `cost/`.
- Foundation AL code exists under `src/` and compiles against Business Central 28.0 symbols.
- A `BC Data Agent` Business Central profile and Role Center provide convenient access to the available foundation tools.
- Target data mutation remains blocked by `docs/code-generation-readiness.md`.

## Current Boundaries

- No target data modification behavior has been implemented.
- No arbitrary target value preview, rollback execution, or audit export behavior has been implemented.
- No BCDA-specific permission sets should be created; access is for existing Business Central `SUPER` users only.
- Approval is configurable: dual-control companies can require a different `SUPER` approver, while one-person companies can explicitly disable approval for standard requests or allow self-approval.
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
| `.codex/skills/` | Project-local skills for SDD, architecture, AL implementation, UX, security, tests, release, symbol discovery, and user-guide upkeep. |
| `.codex/prompts/` | Reusable project prompts for kickoff, SDD, architecture, UX, security, testing, release, and gated implementation workflows. |
| `cost/` | Compact AI cost policy, pricing assumptions, usage rollup, and generated cost report. |
| `src/` | Phase 2 foundation AL objects. |
| `ruleset.json` | Analyzer rules, including the documented no-permission-set exception for ADR-003. |
| `docs/sdd-index.md` | Source-of-truth documentation map. |
| `docs/code-generation-readiness.md` | Gate for implementation scope. |
| `docs/security-review.md` | Security and risk review for high-risk data correction behavior. |

## Key Documentation

- `docs/project.md`
- `docs/requirements.md`
- `docs/architecture.md`
- `docs/app-design.md`
- `UserGuide.md`
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
- `bcda-user-guide-steward`

## Project Prompts

Reusable prompts live in `.codex/prompts/`. Start with `session-kickoff.prompt.md` for a new session, use `readiness-review.prompt.md` before implementation, and use `al-implementation-ready.prompt.md` only after the readiness gate is Ready.

## Build Or Run Validation

Compile with the AL compiler and downloaded symbols:

```powershell
& "$env:USERPROFILE\.vscode\extensions\ms-dynamics-smb.al-17.0.2273547\bin\win32\alc.exe" /project:"." /packagecachepath:".alpackages" /out:"$env:TEMP\BCDataAgent.app" /generatecode
```

Run analyzers with `ruleset.json` before release validation.

## Demo Story

A `SUPER` user creates a correction request for a sandbox record, previews the old and new values, sees rollback logging and retention impact, receives approval for high-risk data when policy requires it, executes the correction, reviews the audit trail, and rolls the change back while retained snapshots are available.

## Status And Next Steps

Status: Phase 2 foundation AL implementation started and compile validated.

Next steps:

1. Deploy to sandbox and verify SUPER/non-SUPER access behavior.
2. Verify target record preview and mutation behavior against representative normal, hidden, posted, and protected tables.
3. Verify scalar field serialization boundaries.
4. Open the next readiness gate only for preview/execution after sandbox evidence is recorded.
