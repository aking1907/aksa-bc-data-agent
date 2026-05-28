# BC Data Agent

BC Data Agent is a Business Central AL project for a governed data correction extension. The main idea is to let authorized users correct normally hidden or posted Business Central data when standard correction workflows are not enough, while tracking every change and supporting rollback if something goes wrong.

Phase 9 local hardening is complete for the current Phase 8 build. The project includes supported grouped `Update` corrections, rollback of successful `Update` execution audit entries, filtered audit metadata export, governed retention cleanup, and local build/analyzer/config/security/docs hardening evidence. Sandbox validation remains required before production use.

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
- Supported grouped `Update` execution is implemented with `SUPER`, request metadata, approval/policy, audit, and rollback snapshot controls.
- Supported `Update` rollback is implemented from successful execution audit entries with retained snapshots, conflict checks, policy re-checks, rollback operation records, and append-only rollback audit evidence.
- Filtered audit metadata export is implemented with `SUPER`, `Export Enabled`, required filters, and omission of target values, target record identity text, and snapshot payloads.
- Retention cleanup is implemented for expired eligible BCDA-owned operation records with active request and retained rollback dependency protection.
- Phase 9 local hardening has passed compile, analyzers, app manifest/config review, object-range review, no-permission-set source scan, and documentation consistency checks.

## Current Boundaries

- `Rename`, `Delete`, and `Insert` execution remain blocked and audited until their operation-specific contracts are implemented.
- `Rename`, `Delete`, `Insert`, conflict override, and snapshot-missing rollback remain blocked until their operation-specific contracts are implemented.
- No arbitrary target value preview, unfiltered export, unredacted export, snapshot payload export, external API, or target business-data cleanup behavior has been implemented.
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
| `.codex/skills/` | Project-local skills for SDD, architecture, AL implementation, UX, security, tests, release, and user-guide upkeep. |
| `.codex/prompts/` | Reusable project prompts for kickoff, SDD, architecture, UX, security, testing, release, and gated implementation workflows. |
| `cost/` | Compact AI cost policy, pricing assumptions, usage rollup, and generated cost report. |
| `src/` | Phase 2-8 AL objects covering foundation data, security, policy, setup, retention, UX shell, target selection, preview, grouped update execution, supported update rollback, filtered audit export, and retention cleanup. |
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

Status: Phase 9 local hardening is complete. Sandbox validation for execution, rollback, export, cleanup, and upgrade remains required before production use.

Next steps:

1. Deploy to sandbox and verify SUPER/non-SUPER access behavior.
2. Verify target selection, request preview, grouped update execution, audit, rollback snapshot behavior, and supported update rollback against representative normal, hidden, posted, and protected tables.
3. Verify rollback success, conflict stop, expired/purged snapshot blocking, policy-blocked rollback, and sanitized failure behavior.
4. Verify filtered audit export redaction, required filters, and non-`SUPER` blocking.
5. Verify retention cleanup purges/deletes only expired eligible BCDA-owned operation records and protects active requests and retained rollback dependencies.
6. Verify scalar field serialization boundaries and unsupported field blocking.
