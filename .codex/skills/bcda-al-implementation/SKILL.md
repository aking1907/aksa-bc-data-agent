---
name: bcda-al-implementation
description: Business Central AL implementation guardrails for BC Data Agent. Use when Codex is explicitly asked to generate, modify, or review AL source under the standing SDD implementation authorization; implement tables, pages, codeunits, reports, tests, setup, SUPER-only access checks, policy, audit, rollback, metadata discovery, or data-correction workflows.
---

# BCDA AL Implementation

## Purpose

Implement AL changes under the standing SDD authorization. Build testable Business Central objects that align with requirements and preserve policy, audit, rollback, and redaction invariants.

## Gate

Before writing AL files:

1. Read `docs/code-generation-readiness.md`.
2. Confirm standing local implementation authorization covers the request.
3. Confirm the user explicitly requested implementation.
4. Confirm open decisions that materially affect runtime behavior are closed, accepted, or documented as assumptions.
5. Confirm sandbox validation, security review, and test evidence cover production reliance, or keep the behavior guarded and document pending validation.

Do not create AL code only when the request would bypass mandatory `SUPER`, policy, audit, rollback, redaction, or production-validation controls. Otherwise implement behind the guardrails and update docs.

## Required Reading

Read:

- `docs/implementation-contracts.md`
- `docs/app-design.md`
- `docs/al-development-standards.md`
- `docs/requirements.md`
- `docs/acceptance-criteria.md`
- `docs/traceability-matrix.md` when reference coverage is useful
- `docs/architecture.md`
- `docs/security-review.md`
- `docs/test-plan.md`
- `UserGuide.md` when the change affects setup, pages, actions, validation, release guidance, or user-visible behavior

## Implementation Rules

- Use the `BCDA` prefix unless the user changes the naming contract.
- Keep object IDs within the confirmed range.
- Implement app-owned governance data before mutation features.
- Do not create BCDA-specific permission set AL objects; access must be limited to users with the existing Business Central `SUPER` permission set.
- Enforce policy immediately before execution and rollback.
- Do not rely on UI-only checks for security.
- Never add silent edit paths.
- Never delete audit entries outside governed retention.
- Never log full sensitive values to generic telemetry or test output.
- Always write mandatory audit metadata, even when rollback snapshots are disabled.
- Make rollback-disabled and snapshot-expired states visible and safe.
- Prefer Business Central native retention policies for BCDA-owned operation tables when sandbox validation confirms support.
- Prefer small, focused objects that match `docs/implementation-contracts.md`.
- Use `bcda-user-guide-steward` and update or review `UserGuide.md` for user-visible AL behavior changes.

## Build Order

1. Setup and policy storage.
2. Request, line, audit, snapshot, and rollback storage.
3. `SUPER` access checks and no custom permission sets.
4. Policy guard, rollback logging policy, and redaction primitives.
5. Retention manager and setup/status UX.
6. Metadata discovery and preview.
7. Execution workflow.
8. Rollback workflow.
9. Audit review/export.
10. Tests, analyzers, performance checks, and upgrade handling.

## Done Criteria

For every AL change:

- Align with requirements, acceptance criteria, and validation evidence or documented pending sandbox validation.
- Compile in the target BC environment.
- Pass required analyzers or document approved exceptions.
- Add or update tests or manual validation steps.
- Update docs and `UserGuide.md` when behavior changes.
- Preserve posted-data safeguards, audit, rollback, and redaction.

## Output Standard

Report changed files, requirement IDs, tests run, tests not run, whether `UserGuide.md` was updated or reviewed, and any residual risk.
