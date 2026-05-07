# API Contract

## External APIs

No external API is planned for Phase 1.

Reason: the first release should prove controlled correction, audit, `SUPER` access gating, and rollback inside Business Central before exposing remote mutation capability.

## Internal Contracts

The implementation will use internal service contracts between planned AL objects. Names below are planning contracts only.

| Contract | Caller | Responsibility |
| --- | --- | --- |
| Metadata Discovery | UI and Correction Orchestrator | Resolve table, field, key, type, caption, and risk metadata. |
| Policy Evaluation | Preview, Execution, Rollback | Return allow/block decision, required approval, validation mode, redaction level, and reason. |
| Preview | SUPER-gated UI and approval workflow | Report old value, proposed new value, warnings, rollback logging mode, retention period, and rollback eligibility without mutation. |
| Execution | SUPER-gated workflow | Apply approved field-level changes and record audit evidence. |
| Audit Write | All material workflows | Write append-only audit entries with sanitized values. |
| Rollback | Rollback workflow | Restore before-images when policy and conflict checks allow. |
| Retention | Setup and retention workflow | Register app-owned tables, show retention state, and apply or delegate cleanup policy. |

## Authentication And Authorization

Internal calls rely on Business Central user identity and the existing `SUPER` permission set. No BCDA-specific permission sets or separate API tokens are planned for Phase 1.

## Error Shape

Errors should be represented with:

- Request id.
- Line no. when available.
- Error category.
- Sanitized message.
- Whether retry is allowed.
- Whether support escalation is required.
- Rollback availability when relevant.
- Retention impact when relevant.

## Redaction Rules

- Do not include sensitive field values in generic errors.
- Audit exports must apply the caller's `SUPER` access plus export redaction policy.
- Test data must avoid real customer values.

## Versioning

No external contract version exists in Phase 1. Internal contracts should be treated as stable once AL implementation begins and should change only with matching docs and tests.
