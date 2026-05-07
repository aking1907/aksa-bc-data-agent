---
name: bcda-user-guide-steward
description: UserGuide.md maintenance for BC Data Agent. Use when Codex changes or reviews user-facing behavior, Business Central pages/actions, setup defaults, approval, rollback, retention, audit, deployment/admin guidance, release notes, or any docs/code change that should keep the user guide current.
---

# BCDA User Guide Steward

## Purpose

Keep `UserGuide.md` aligned with the SDD package, foundation AL behavior, admin guidance, release notes, and current readiness gates.

## Required Reading

Read:

- `UserGuide.md`
- `docs/sdd-index.md`
- `docs/project.md`
- `docs/requirements.md`
- `docs/acceptance-criteria.md`
- `docs/app-design.md`
- `docs/admin-guide.md`
- `docs/operations-runbook.md`
- `docs/deployment.md`
- `docs/release-notes.md`
- `docs/code-generation-readiness.md`

Read AL source when user-facing behavior changed:

- `src/Pages/`
- `src/Tables/`
- `src/Codeunits/`
- `src/Enums/`

## Update Triggers

Update or review `UserGuide.md` whenever work changes:

- Setup fields, defaults, warnings, or retention controls.
- Data policy fields, decisions, blocked reasons, validation mode, or rollback snapshot mode.
- Correction request fields, statuses, actions, approval behavior, preview markers, or execution blocking.
- Audit entries, retention logs, rollback availability, or release/sandbox validation steps.
- Readiness scope, blocked behavior, known limitations, or next actions.
- Admin guide, operations runbook, deployment steps, release notes, requirements, acceptance criteria, or app design.

## Workflow

1. Identify the user-visible behavior or documentation change.
2. Check the readiness boundary in `docs/code-generation-readiness.md`.
3. Update `UserGuide.md` in the sections users would naturally consult:
   - status and scope,
   - setup,
   - policies,
   - correction requests and lines,
   - approval rules,
   - preview/execution/rollback behavior,
   - audit and retention,
   - troubleshooting,
   - sandbox validation checklist.
4. Keep examples artificial and non-sensitive.
5. Keep blocked behavior explicit; do not imply mutation, rollback execution, export, or arbitrary target preview is available before readiness allows it.
6. Cross-check `docs/admin-guide.md`, `docs/operations-runbook.md`, `docs/deployment.md`, and `docs/release-notes.md` for drift.
7. Update prompt or SDD indexes when adding new user-guide maintenance workflow files.

## Safety Rules

- Never document a target data write path that is still blocked by readiness.
- Never include credentials, customer data, posted values, hidden values, rollback before-images, or screenshots with sensitive data.
- Do not weaken `SUPER`-only access language.
- Keep no-approval or self-approval guidance explicit about accepted business risk.
- State rollback-unavailable and retention-expired states plainly.

## Output Standard

Report:

- `UserGuide.md` sections updated or reviewed.
- Related docs updated.
- Readiness status.
- Any user-guide gaps that still need sandbox evidence.
