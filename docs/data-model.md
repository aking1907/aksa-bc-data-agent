# Data Model

This document describes app-owned data. Phase 2 foundation storage now exists in AL, while execution, preview, rollback execution, export, and cleanup behavior remain gated.

## App-Owned Entities

| Entity | Purpose | Key Fields |
| --- | --- | --- |
| BCDA Setup | Global configuration and safety defaults. | Environment label, default policy mode, approval required, require separate approver, rollback snapshot default, audit retention period, snapshot retention period, technical log retention period, export enabled. |
| BCDA Data Policy | Allow/block rules for targets. | Table id, table name, field id, field name, operation, risk level, allow modify, rollback snapshot mode, requires approval, validation mode, retention override. |
| BCDA Correction Request | Header for a correction workflow. | Request id, status, requested by, requested at, company, reason, ticket/reference, risk, approval required, require separate approver, approved by, approved at. |
| BCDA Correction Line | One field-level proposed mutation. | Request id, line no., table id, record key, field id, proposed new value, optional old/new value refs, rollback snapshot mode, snapshot expiration date, validation mode, line status, sanitized error. |
| BCDA Value Snapshot | Protected serialized values. | Snapshot id, value type, serialized value, display value, value hash, redaction level, retention category, expires at, purged. |
| BCDA Audit Entry | Append-only evidence. | Entry no., operation, request id, line no., user id, timestamp, company, table id, record key, field id, result, rollback availability, optional value refs, error code. |
| BCDA Rollback Operation | Governed rollback record. | Rollback id, source request id, source audit entry, requested by, status, conflict policy, completed at. |
| BCDA Retention Log | Cleanup and retention evidence. | Entry no., retention category, table id, cutoff date, expired count, deleted count, result, sanitized error. |

## Sensitivity And Classification

| Data | Sensitivity | Handling |
| --- | --- | --- |
| User id, approver id, timestamps | End-user identifiable information | Visible to authorized `SUPER` users. |
| Table, field, record key | Business metadata | Visible to authorized `SUPER` users. |
| Old/new target values | Potential customer, financial, or personal data | Available only through `SUPER`-gated features; redacted from generic logs and telemetry. |
| Reason and ticket/reference | Business content | Visible to authorized `SUPER` users. |
| Error messages | Operational data | Sanitized before storage or display. |

## Secret Storage Rules

- The project should not store environment credentials.
- Secrets must never be committed to the repository.
- Sensitive correction values are not credentials, but must still be protected.
- Any future external API credentials must use Business Central-supported secret storage and require a new ADR.

## Ownership And Lifecycle

- App setup, policy, request, audit, snapshot, and rollback records are owned by BC Data Agent.
- Target records are owned by Business Central and the business process owner.
- Audit metadata is mandatory and retained according to customer-selected audit retention.
- Rollback snapshots are optional by setup/policy and retained according to snapshot retention.
- Technical logs are retained according to technical log retention.
- Retention should use Business Central native retention policy support for BCDA-owned tables when feasible.
- Snapshot expiration or purge makes rollback unavailable for the affected operation.

## Migration Notes

- Value snapshots need a serialization version before implementation.
- Retention categories need stable enum values before implementation.
- Schema changes to audit or snapshot tables need upgrade routines and compatibility tests.
- Audit history must remain readable after extension upgrades.
- Retention cleanup must be upgrade-safe and must not delete active requests.
- Object ID allocation must be finalized before AL files are created.
