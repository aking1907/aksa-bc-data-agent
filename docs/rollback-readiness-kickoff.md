# Rollback Readiness Kickoff

## Purpose

Record the Phase 7 rollback workflow implementation scope and the validation required before rollback is production-ready.

Phase 7 is implemented as governed rollback request staging, not a simple undo button. The local implementation supports rollback only from completed Phase 6 `Update` correction requests whose executed lines have retained before-image snapshots.

## Current Start Decision

Rollback local implementation is complete for the supported request-level `Update` rollback staging slice.

AL rollback request staging code exists in `BCDA Rollback Service`. The current rollback gate still blocks direct audit-entry rollback, conflict override, and operation-aware rollback for `Rename`, `Delete`, or `Insert`; Phase 8 export and cleanup are tracked separately.

The repository-side Phase 7 package tracks implementation and sandbox validation. The remaining production-readiness items cannot be completed from source files alone because they require Business Central sandbox rollback/conflict validation.

Do not use rollback in production until:

- Rollback sandbox validation is completed.
- Representative target table and field behavior is recorded.
- Release readiness records any unsupported platform results.

## Phase 7 Prerequisites

| Order | Prerequisite | Evidence Required | Unlocks |
| --- | --- | --- | --- |
| 1 | Phase 6 execution is implemented and validated | Validated execution writes mandatory audit metadata, line outcome, target identity, field identity, and sanitized errors | A real completed source request exists to stage rollback from |
| 2 | Before-image snapshot capture exists | Value snapshot records contain typed before-images, display values, hashes, retention category, expiration date, and redaction metadata | Rollback can propose retained prior values |
| 3 | Snapshot retention and expiration are enforced visibly | Preview/execution/request pages show rollback available, disabled, expired, or purged states | Rollback request creation can stop before mutation when unavailable |
| 4 | Generated rollback request review is proven | Sandbox tests show generated rollback requests preview current values and proposed before-images before execution | Safe conflict review through normal workflow |
| 5 | Policy is re-checked before generated rollback request execution | Same target table/field policy and `SUPER` checks run through the generated correction request | No stale approval bypass |
| 6 | Rollback audit model is complete | Rollback request creation and generated request execution append new audit entries without changing original audit evidence | Audit integrity |
| 7 | Operation-specific rollback behavior is defined | `Update` rollback staging is supported first; `Rename`, `Delete`, and `Insert` rollback stay separately gated until complete before/after identity behavior is proven | Clear rollback implementation boundary |
| 8 | Code-generation readiness is updated | `docs/code-generation-readiness.md` explicitly allows rollback implementation after sandbox validation evidence is recorded | AL rollback implementation may begin |

Status: items 1, 2, 5, 6, 7, and 8 are implemented locally for supported request-level `Update` rollback staging. Items 3 and 4 remain sandbox validation evidence before production readiness.

## Minimum Phase 7 Rollback Behavior

Rollback behavior should:

- Stage rollback only for completed Phase 6 `Update` requests.
- Suggest only scalar non-primary-key field updates using retained before-image snapshots.
- Require retained before-image snapshots for every executed supported source line.
- Create a new correction request rather than mutating target data directly.
- Re-check `SUPER` access and policy through the generated correction request before mutation.
- Append audit evidence for rollback request creation and generated request execution.
- Never delete or modify the original execution audit entry.
- Store only sanitized errors outside protected value storage.
- Keep `Rename`, `Insert`, delete rollback, conflict override, posted/protected rollback, and policy bypass blocked unless explicitly implemented with operation-aware controls.

The local implementation exposes rollback from completed correction requests. It writes a `BCDA Rollback Operation`, creates a new correction request with inverse `Update` lines, opens that request for review, and appends rollback audit evidence. Snapshot validation failures block rollback request creation before any target data changes.

## Readiness Exit Criteria

Before rollback is production-ready, all of these must be true:

- Sandbox validation covers reading, writing, and validating rollback target fields.
- Phase 6 execution has passed sandbox validation and captures rollback snapshots for the same target shape.
- Phase 7 rollback staging has passed request creation, generated request preview/execution, expired snapshot, purged snapshot, policy-blocked, non-`SUPER`, and sanitized-failure scenarios.
- `docs/open-decisions.md` keeps OD-007 as stop-on-conflict or records an accepted override policy.
- `docs/code-generation-readiness.md` says Phase 7 local implementation is complete.
- The implementation plan keeps rollback procedures aligned with requirements, acceptance criteria, and validation evidence.

## Sandbox Validation Rule

Use only artificial sandbox data. Do not record customer data, posted values, hidden values, credentials, or full sensitive values in readiness, security, test, or support notes.
