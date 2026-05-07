# ADR-003: SUPER-Only Access Without BCDA Permission Sets

## Status

Accepted

## Context

BC Data Agent can change hidden and posted Business Central data. Earlier planning assumed BCDA-specific administrator, operator, approver, and auditor permission sets. The product direction is now stricter: do not create any specific app permission sets. Only users who already have the standard Business Central `SUPER` permission set may access the functionality.

## Decision

The extension must not define BCDA-specific permission set objects.

Access control must be based on existing Business Central `SUPER` access. Workflow responsibilities such as requester, approver, and reviewer may still be recorded for audit and approval policy, but they are not separate BCDA permission roles.

## Consequences

- The app has a smaller custom security surface.
- Non-`SUPER` users must not be able to use correction, audit, export, setup, or rollback features.
- Approval policy can still require a different `SUPER` user, but that is a configurable workflow control rather than a permission-set design. One-person companies can disable approval for standard requests or allow self-approval when they explicitly accept that control model.
- Sandbox validation must explicitly prove non-`SUPER` users cannot access the functionality.

## Alternatives Considered

| Alternative | Reason Rejected |
| --- | --- |
| BCDA-specific permission sets | Rejected by project direction; functionality should be limited to existing `SUPER` users. |
| Broad user access with policy controls | Too risky for hidden and posted data correction. |
| External identity or API authorization | Out of scope for Phase 1. |

## Follow-Up

- Verify how to reliably detect or enforce `SUPER` access in AL for the target BC version.
- Update tests to use `SUPER` and non-`SUPER` users.
- Keep all documentation and skills aligned with the no-custom-permission-set rule.
