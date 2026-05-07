---
name: bcda-sdd-steward
description: SDD governance for the BC Data Agent project. Use when Codex is asked to plan, refine, review, or prepare implementation work; update requirements, acceptance criteria, traceability, readiness, ADRs, risks, or any project documentation; decide whether AL code generation is allowed; or keep Business Central data-correction work aligned with the documentation-first process.
---

# BCDA SDD Steward

## Purpose

Keep BC Data Agent implementation work governed by the SDD package. Treat the docs as the source of truth and block code generation when readiness says Not Ready.

## Required Reading

Read these first for any implementation-adjacent task:

1. `docs/sdd-index.md`
2. `docs/project.md`
3. `docs/requirements.md`
4. `docs/acceptance-criteria.md`
5. `docs/code-generation-readiness.md`
6. `docs/traceability-matrix.md`

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
3. If status is Not Ready and the request would create AL code, stop implementation and update readiness/open-decision docs instead.
4. Map every requested behavior to a requirement ID and acceptance criterion.
5. Add or update traceability rows before or alongside implementation planning.
6. Update related docs together when behavior changes.

## Maintenance Set

When project behavior changes, update these together:

- `docs/requirements.md`
- `docs/acceptance-criteria.md`
- `docs/architecture.md` or `docs/adr/`
- `docs/implementation-contracts.md`
- `docs/test-plan.md`
- `docs/traceability-matrix.md`
- `docs/risk-register.md`
- `docs/deployment.md` and `docs/operations-runbook.md` when admin/user behavior changes

## Readiness Rules

- Never treat a user request for speed as permission to skip SDD.
- Never generate AL code while readiness is Not Ready.
- Mark assumptions explicitly in `docs/open-decisions.md`.
- Close or accept blocking decisions before moving readiness to Ready.
- Record Business Central symbol evidence in `docs/symbol-discovery.md` before relying on platform internals.

## Output Standard

End with:

- Files updated.
- Readiness status.
- Blocking decisions, if any.
- Whether AL code generation remains blocked.

