# ADR-001: Governed Correction Workflow With Append-Only Audit

## Status

Accepted

## Context

The core product idea is intentionally powerful: authorized users may need to modify hidden or posted Business Central data. This can solve urgent support problems, but it can also corrupt financial history, break application invariants, or create audit exposure if implemented as a generic table editor.

## Decision

All data mutation must go through a governed correction workflow:

- Correction request first.
- Existing `SUPER` access and policy evaluation before mutation.
- Dry-run preview before execution.
- Approval for posted or high-risk data by default.
- Before-image capture before mutation.
- Append-only audit for preview, approval, execution, failure, and rollback.
- Rollback through a governed operation, not audit deletion.

## Consequences

- Implementation will be slower than a simple record editor.
- The app can provide support value without normalizing untraceable data edits.
- Audit history remains available even when rollback occurs.
- Some requested changes will be blocked until policy explicitly allows them.

## Alternatives Considered

| Alternative | Reason Rejected |
| --- | --- |
| Generic unrestricted table editor | Too risky for posted data and impossible to audit safely. |
| Direct SQL correction | Out of scope for Business Central SaaS and bypasses platform governance. |
| Only support standard BC reversal flows | Safer, but does not solve hidden data and exceptional support scenarios. |

## Follow-Up

- Define default blocked tables and fields.
- Verify platform behavior for target record access.
- Design value serialization and redaction before code generation.
- Link tests to rollback and audit invariants.
