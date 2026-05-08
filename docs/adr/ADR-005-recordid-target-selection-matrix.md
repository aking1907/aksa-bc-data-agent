# ADR-005: RecordId-Based Target Selection With Matrix Editing

## Status

Accepted. App-owned `RecordId` storage, foundation primary-key line-action lookup, and selected-line current value preview are allowed for foundation records; the full matrix implementation and production use remain gated until `RecordId`/`RecordRef` sandbox evidence is recorded.

## Context

The original foundation correction line design stored a free-text `Record Key`. That is not strong enough for Business Central tables with complex primary keys, and it pushes serialization responsibility onto the user. A hand-entered key also makes later preview, audit, rollback conflict checks, and support diagnostics more fragile.

Business Central already has platform record identity concepts. BCDA should use those concepts instead of inventing a key grammar for every target table.

## Decision

BCDA will model target record identity with:

- company context from the correction request,
- target table id and table caption,
- canonical platform `RecordId`,
- a formatted read-only record identity for display,
- a display key for support and audit review.

The correction request experience should not ask users to hand-type composite keys. The target record field should be read-only. In the foundation build, users populate it through a `Select Record` line action. A future matrix-style selector/editor, similar in spirit to the standard Dimension Matrix pattern, will expand this into multi-field staging for the selected record.

The planned target record matrix will:

- resolve or accept a selected target record identity,
- list enabled normal fields and policy-visible correction candidates for that record,
- show existing correction lines for the same request and record,
- let the user create or update proposed field changes,
- write only BCDA-owned correction line records before execution readiness,
- avoid target mutation and keep current-value display limited to the approved selected-line preview until full request preview readiness is approved.

## Consequences

Free-text record key entry is removed from the foundation UI and storage path. App-owned `RecordId` fields remain read-only and are populated only through governed selector actions.

Before full matrix AL implementation or production use, symbol discovery must verify the target BC version's `RecordId`, `RecordRef`, key formatting, record lookup, and `SUPER`/non-`SUPER` behavior for representative normal, hidden, and posted tables. Sandbox validation must also prove that the matrix does not expose sensitive values outside approved preview behavior.

This decision adds planned objects and tests:

- `BCDA Target Record Matrix`,
- `BCDA Record Identity Mgt.`,
- `BCDA Target Matrix Mgt.`,
- acceptance coverage `AC-029`,
- validation scenario `TST-029`.

## Links

- Requirements: `REQ-001`, `REQ-003`, `REQ-031`
- Acceptance: `AC-001`, `AC-003`, `AC-029`
- Risks: `RSK-006`, `RSK-016`, `RSK-019`
