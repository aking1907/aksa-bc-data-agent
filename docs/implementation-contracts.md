# Implementation Contracts

This file records implementation-level commitments. Phase 2 foundation objects now exist in AL; later mutation, rollback execution, export, and cleanup behavior remains gated.

## Object Naming Contracts

Use the `BCDA` prefix for app-owned objects and captions unless the user chooses a different product prefix.

| Area | Objects | Responsibility |
| --- | --- | --- |
| Setup | BCDA Setup | Store global defaults and safety controls. |
| Policy | BCDA Data Policy | Store allow/block and approval rules. |
| Request | BCDA Correction Request, BCDA Correction Line | Store correction workflow state. |
| Audit | BCDA Audit Entry, BCDA Value Snapshot | Store append-only evidence and protected values. |
| Rollback | BCDA Rollback Operation | Store rollback state and outcome. |
| Services | BCDA Correction Orchestrator, BCDA Policy Guard, BCDA Audit Writer, BCDA Rollback Service, BCDA Value Serializer, BCDA Metadata Explorer, BCDA Validation Runner | Coordinate behavior without putting business logic in pages. |
| Retention | BCDA Retention Manager, BCDA Retention Log | Register app-owned retention tables, expose retention status, and protect active records. |
| Profile Navigation | BCDA Role Center, BC Data Agent profile | Provide a Business Central-native entry point to available foundation tools without granting permissions. |
| Access Control | Existing Business Central `SUPER` permission set only | Do not create BCDA-specific permission set objects; enforce `SUPER`-only access. |

## Planned Object ID Allocation

OD-001 is decided for Phase 1. Current planning range follows `app.json`:

| Range | Intended Use |
| --- | --- |
| 88100-88109 | Tables |
| 88110-88119 | Pages |
| 88120-88129 | Codeunits |
| 88130-88134 | Reports or exports if needed |
| 88140-88149 | Supporting objects if needed; no permission set AL objects are planned |

## Implemented Foundation Objects

| Range | Implemented Objects |
| --- | --- |
| Tables | `BCDA Setup`, `BCDA Data Policy`, `BCDA Correction Request`, `BCDA Correction Line`, `BCDA Audit Entry`, `BCDA Value Snapshot`, `BCDA Rollback Operation`, `BCDA Retention Log` |
| Pages | `BCDA Role Center`, `BCDA Setup`, `BCDA Data Policies`, `BCDA Data Policy Card`, `BCDA Correction Requests`, `BCDA Correction Request Card`, `BCDA Correction Lines`, `BCDA Audit Entries`, `BCDA Retention Logs` |
| Profiles | `BC Data Agent` |
| Codeunits | `BCDA Access Mgt.`, `BCDA Setup Mgt.`, `BCDA Policy Guard`, `BCDA Audit Writer`, `BCDA Value Serializer`, `BCDA Correction Orchestrator`, `BCDA Retention Manager`, `BCDA Metadata Explorer` |
| Enums | `BCDA Request Status`, `BCDA Line Status`, `BCDA Risk Level`, `BCDA Validation Mode`, `BCDA Rollback Snapshot Mode`, `BCDA Retention Category`, `BCDA Audit Operation`, `BCDA Audit Result`, `BCDA Conflict Policy`, `BCDA Policy Decision` |

## Procedure Responsibility Contracts

| Contract | Required Behavior |
| --- | --- |
| EvaluatePolicy | Return allow/block, reason, approval requirement, validation mode, and redaction level. |
| BuildPreview | Read target record and create preview output without mutation. |
| ExecuteRequest | Re-check policy, capture before-image, write change, and audit outcome. |
| WriteAudit | Append a new audit entry; never update prior entries except platform-managed fields. |
| SerializeValue | Preserve typed value, display value, hash, and serialization version. |
| ResolveRollbackLoggingPolicy | Resolve global setup, data policy, request state, and risk into enabled/disabled/required rollback snapshot behavior. |
| RequestRollback | Build rollback operation from original before-image. |
| ExecuteRollback | Re-check policy, detect conflicts, write rollback value, and audit outcome. |
| RegisterRetentionTables | Register BCDA-owned operation tables with Business Central retention policy support when symbol discovery confirms APIs. |
| PreviewRetentionStatus | Report retention periods, expiration dates, expired counts when available, and rollback impact. |

## Field And Configuration Contracts

- Every request requires reason and ticket/reference before execution.
- Every change line requires target table, record key, field, proposed new value, rollback logging mode, and value references only when retained.
- Every audit entry requires operation, user, timestamp, target, result, and request reference when applicable.
- Posted data policy defaults to blocked until configured otherwise.
- Approval defaults to required with separate approval, but setup can disable approval for standard requests or allow self-approval for one-person companies that accept that control model.
- Rollback defaults to conflict-stop behavior.
- Rollback snapshot logging defaults to enabled for posted/high-risk changes unless setup/policy explicitly changes it.
- When rollback snapshot logging is disabled, execution requires visible confirmation and audit metadata still writes.
- Retention categories are audit metadata, rollback snapshot, and technical log.

## Error Message Contracts

- Policy errors should name the policy reason without exposing restricted values.
- Validation errors should identify request and line.
- Runtime errors should be sanitized before storage and display.
- Errors should guide the user to review `SUPER` access, policy, target record state, or escalation package.

## Logging Contracts

- Audit entries are the primary durable log.
- Rollback snapshots are rollback payloads, not the only audit evidence.
- Generic telemetry must not include sensitive values.
- Hashes or value references may be logged for correlation when safe.

## Blocked Behavior

- No direct SQL.
- No silent edits.
- No deleting audit entries outside governed retention.
- No rollback that erases original evidence.
- No record deletion in Phase 1.
- No primary key rename in Phase 1.
- No external mutation API in Phase 1.
- No AL code generation outside the scope currently allowed by readiness.
- No optional rollback snapshot setting may disable mandatory audit metadata.
- No retention cleanup may delete active in-progress requests.

## Validation Boundaries

Implementation must validate:

- User has existing Business Central `SUPER` access.
- Table and field policy.
- Request status.
- Required reason and ticket.
- Approval state.
- Approval separation state.
- Target record existence.
- Field type support.
- Rollback snapshot logging mode and retention expiration.
- Current value for rollback conflict checks.
