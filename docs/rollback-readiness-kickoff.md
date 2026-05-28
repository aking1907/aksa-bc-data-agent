# Rollback Readiness Kickoff

## Purpose

Record the Phase 7 rollback workflow implementation scope and the validation required before rollback is production-ready.

Phase 7 is implemented as a governed rollback mutation path, not a simple undo button. The local implementation supports rollback only for successful Phase 6 `Update` execution audit entries with retained before-image snapshots.

## Current Start Decision

Rollback local implementation is complete for the supported `Update` rollback slice.

AL rollback execution code exists in `BCDA Rollback Service`. The current rollback gate still blocks conflict override and operation-aware rollback for `Rename`, `Delete`, or `Insert`; Phase 8 export and cleanup are tracked separately.

The repository-side Phase 7 package tracks implementation and sandbox validation. The remaining production-readiness items cannot be completed from source files alone because they require Business Central sandbox rollback/conflict validation.

Do not use rollback in production until:

- Rollback sandbox validation is completed.
- Representative target table and field behavior is recorded.
- Release readiness records any unsupported platform results.

## Phase 7 Prerequisites

| Order | Prerequisite | Evidence Required | Unlocks |
| --- | --- | --- | --- |
| 1 | Phase 6 execution is implemented and validated | Validated execution writes mandatory audit metadata, line outcome, target identity, field identity, and sanitized errors | A real source operation exists to roll back |
| 2 | Before-image snapshot capture exists | Value snapshot records contain typed before-images, display values, hashes, retention category, expiration date, and redaction metadata | Rollback can restore from retained data |
| 3 | Snapshot retention and expiration are enforced visibly | Preview/execution/audit pages show rollback available, disabled, expired, or purged states | Rollback can stop before mutation when unavailable |
| 4 | Conflict policy is proven | Sandbox tests show no-conflict restore succeeds and changed-current-value restore stops by default | Safe conflict detection |
| 5 | Policy is re-checked immediately before rollback | Same target table/field policy and `SUPER` checks run at rollback time | No stale approval bypass |
| 6 | Rollback audit model is complete | Rollback attempts, successes, conflicts, and failures append new audit entries without changing original audit evidence | Audit integrity |
| 7 | Operation-specific rollback behavior is defined | `Update` restore is supported first; `Rename`, `Delete`, and `Insert` rollback stay separately gated until complete before/after identity behavior is proven | Clear rollback implementation boundary |
| 8 | Code-generation readiness is updated | `docs/code-generation-readiness.md` explicitly allows rollback implementation after sandbox validation evidence is recorded | AL rollback implementation may begin |

Status: items 1, 2, 5, 6, 7, and 8 are implemented locally for supported `Update` rollback. Items 3 and 4 remain sandbox validation evidence before production readiness.

## Minimum Phase 7 Rollback Behavior

Rollback behavior should:

- Roll back only Phase 6 `Update` operations.
- Restore only scalar non-primary-key fields.
- Require existing retained before-image snapshots.
- Stop on conflict by default.
- Re-check `SUPER` access and policy immediately before mutation.
- Append audit evidence for every rollback attempt, success, conflict, and failure.
- Never delete or modify the original execution audit entry.
- Store only sanitized errors outside protected value storage.
- Keep `Rename`, `Delete`, `Insert`, conflict override, posted/protected rollback, and policy bypass blocked unless explicitly implemented with operation-aware controls.

The local implementation exposes rollback from successful execution audit entries. It writes a `BCDA Rollback Operation`, restores the old value when the current target value still matches the executed value, marks the source correction line as `Rolled Back`, and appends rollback audit evidence. Validation or conflict failures leave the target unchanged and write sanitized rollback failure evidence.

## Readiness Exit Criteria

Before rollback is production-ready, all of these must be true:

- Sandbox validation covers reading, writing, and validating rollback target fields.
- Phase 6 execution has passed sandbox validation and captures rollback snapshots for the same target shape.
- Phase 7 rollback has passed success, conflict, expired snapshot, purged snapshot, policy-blocked, non-`SUPER`, and sanitized-failure scenarios.
- `docs/open-decisions.md` keeps OD-007 as stop-on-conflict or records an accepted override policy.
- `docs/code-generation-readiness.md` says Phase 7 local implementation is complete.
- The implementation plan keeps rollback procedures aligned with requirements, acceptance criteria, and validation evidence.

## Sandbox Validation Rule

Use only artificial sandbox data. Do not record customer data, posted values, hidden values, credentials, or full sensitive values in readiness, security, test, or support notes.
