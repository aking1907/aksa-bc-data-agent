---
name: bcda-sdd-steward
description: SDD governance for the BC Data Agent project. Use when Codex is asked to plan, refine, review, or prepare implementation work; update requirements, acceptance criteria, readiness, ADRs, risks, or any project documentation; decide runtime or production enablement boundaries; or keep Business Central data-correction work aligned with the documentation-first process.
---

# BCDA SDD Steward

## Purpose

Keep BC Data Agent implementation work governed by the SDD package. Treat the docs as the source of truth, allow local implementation under the standing authorization, and keep runtime or production enablement behind the documented controls.

## Required Reading

Read these first for any implementation-adjacent task:

1. `docs/sdd-index.md`
2. `docs/project.md`
3. `docs/requirements.md`
4. `docs/acceptance-criteria.md`
5. `docs/code-generation-readiness.md`
6. `docs/traceability-matrix.md` when reference coverage is useful

Read these when the task touches architecture, security, tests, release, or operations:

- `docs/architecture.md`
- `docs/adr/README.md`
- `docs/open-decisions.md`
- `docs/security-review.md`
- `docs/test-plan.md`
- `docs/risk-register.md`
- `docs/deployment.md`
- `docs/operations-runbook.md`

## Workflow

1. Classify the request as documentation, discovery, implementation, review, or release.
2. Check `docs/code-generation-readiness.md`.
3. If the request would enable runtime or production behavior without required controls, keep that behavior disabled or documented as pending while implementation proceeds behind the guardrails.
4. Align every requested behavior with requirements, acceptance criteria, and validation evidence.
5. Treat traceability rows as optional reference material, not required for readiness.
6. Update related docs together when behavior changes.

## Maintenance Set

When project behavior changes, update these together:

- `docs/requirements.md`
- `docs/acceptance-criteria.md`
- `docs/architecture.md` or `docs/adr/`
- `docs/implementation-contracts.md`
- `docs/test-plan.md`
- `docs/traceability-matrix.md` when reference coverage is useful
- `docs/risk-register.md`
- `docs/deployment.md` and `docs/operations-runbook.md` when admin/user behavior changes
- `UserGuide.md` when user-facing behavior, setup, page actions, validation steps, release guidance, or readiness scope changes

## Readiness Rules

- Never treat a user request for speed as permission to skip SDD.
- Treat `docs/code-generation-readiness.md` as standing authorization for local AL implementation unless a request would remove mandatory safety controls.
- Mark assumptions explicitly in `docs/open-decisions.md`.
- Close or accept decisions that materially affect runtime or production enablement.
- Record sandbox validation, security review, and test evidence in the relevant readiness documents before relying on platform-dependent Business Central behavior in production.

## Output Standard

End with:

- Files updated.
- Readiness status.
- Blocking decisions, if any.
- Whether AL code generation is authorized for local implementation.
