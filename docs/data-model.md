# Data Model

This document describes app-owned data. Phase 2-8 foundation storage, non-mutating preview behavior, grouped update execution, supported update rollback, filtered audit metadata export, and governed retention cleanup now exist in AL, while non-update operation execution, non-update rollback, conflict override, unredacted export, snapshot payload export, and external APIs remain gated.

## App-Owned Entities

| Entity | Purpose | Key Fields |
| --- | --- | --- |
| BCDA Setup | Global configuration and safety defaults. | Environment label, default policy mode, allow data policies, approval required, require separate approver, require ticket reference, rollback snapshot default, audit retention period, snapshot retention period, technical log retention period, export enabled. |
| BCDA Data Policy | Allow/block rules for targets. | Table id, table name, field id, field name, operation, risk level, allow modify, rollback snapshot mode, requires approval, validation mode, retention override. |
| BCDA Correction Request | Header for a correction workflow. | Request id, status, requested by, requested at, company, reason, ticket/reference, ticket reference required, risk, approval required, require separate approver, approved by, approved at. |
| BCDA Correction Line | One staged correction operation or operation field value. | Request id, line no., correction type, table id, target RecordId when applicable, display key, field id when applicable, proposed new value when applicable, optional old/new value refs, rollback snapshot mode, snapshot expiration date, validation mode, line status, sanitized error. |
| BCDA Value Snapshot | Protected serialized values. | Snapshot id, value type, serialized value, display value, value hash, redaction level, retention category, expires at, purged. |
| BCDA Audit Entry | Append-only evidence. | Entry no., operation, request id, line no., user id, timestamp, company, table id, target RecordId/display key, field id, result, rollback availability, optional value refs, error code. |
| BCDA Rollback Operation | Governed rollback staging record. | Rollback id, source request id, generated request id, optional legacy source audit entry, requested by, status, conflict policy, completed at. |
| BCDA Retention Log | Cleanup and retention evidence. | Entry no., retention category, table id, cutoff date, expired count, deleted count, result, sanitized error. |

## Sensitivity And Classification

| Data | Sensitivity | Handling |
| --- | --- | --- |
| User id, approver id, timestamps | End-user identifiable information | Visible to authorized `SUPER` users. |
| Table, field, target RecordId, display key | Business metadata | Visible to authorized `SUPER` users. |
| Old/new target values | Potential customer, financial, or personal data | Available only through `SUPER`-gated features; redacted from generic logs and telemetry. |
| Reason and ticket/reference when provided or required | Business content | Visible to authorized `SUPER` users. |
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
- Filtered audit export uses app-owned audit metadata only. It omits target record identity text and rollback snapshot payloads.
- Retention cleanup purges expired rollback snapshot payloads and deletes expired eligible BCDA-owned audit, rollback operation, and retention log records while preserving active requests and retained rollback dependencies.
- Data policy enforcement bypass, if accepted later, must remain setup-controlled and must not allow mutation of BCDA app-owned, system, protected, unsupported, unaudited, rollback-unready, or non-`SUPER` paths.
- Retention should use Business Central native retention policy support for BCDA-owned tables when feasible.
- Snapshot expiration or purge makes rollback unavailable for the affected operation.

## Migration Notes

- Value snapshots use the current serialized text shape; future format changes need versioning and upgrade tests.
- Correction line, batch buffer, and audit schema now use canonical `RecordId` storage where an existing target record is applicable. `Insert` correction lines deliberately keep `RecordId` empty, so insert execution must use an app-owned grouping/created-record identity before mutation readiness can open. The foundation lookup uses a temporary display key; persistent display-key storage can be added before richer target matrix preview or mutation is released.
- Retention category enum values must remain stable for upgrade compatibility.
- Schema changes to audit or snapshot tables need upgrade routines and compatibility tests.
- Audit history must remain readable after extension upgrades.
- Retention cleanup must be upgrade-safe and must not delete active requests.
- Object ID allocation currently uses 88100-88149; future expansion must preserve upgrade compatibility.
