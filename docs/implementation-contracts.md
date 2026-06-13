# Implementation Contracts

This file records implementation-level commitments. Phase 2-8 foundation, preview, grouped update execution, supported primary-key rename execution, supported record-level delete execution, supported grouped insert execution, supported update rollback, filtered audit metadata export, and governed retention cleanup objects now exist in AL. Local code development is open under standing authorization; non-update rollback, conflict override, unredacted export, snapshot payload export, and external APIs must stay runtime-gated until their operation-specific controls and validation evidence exist.

## Object Naming Contracts

Use the `BCDA` prefix for app-owned objects and captions unless the user chooses a different product prefix.

| Area | Objects | Responsibility |
| --- | --- | --- |
| Setup | BCDA Setup | Store global defaults and safety controls. |
| Policy | BCDA Data Policy | Store allow/block and approval rules. |
| Request | BCDA Correction Request, BCDA Correction Line | Store correction workflow state. |
| Batch Entry | BCDA Batch Line Buffer, BCDA Batch Line Builder, BCDA Batch Line Mgt. | Hold same-table batch entries and transform them into standard correction lines using RecordId-backed target selection where an existing target record is applicable and Insert Group No. where new records are staged. |
| Target Record Selection | BCDA Target Record Buffer, BCDA Target Record Lookup; planned BCDA Target Record Matrix, planned BCDA Record Identity Mgt., planned BCDA Target Matrix Mgt. | Resolve a canonical target `RecordId`, display a read-only formatted identity, and later create/update correction lines for selected fields without hand-entered composite keys. |
| Audit | BCDA Audit Entry, BCDA Value Snapshot | Store append-only evidence and protected values. |
| Rollback | BCDA Rollback Operation, BCDA Rollback Operations, BCDA Rollback Service | Store rollback staging evidence and create governed rollback correction requests from completed source requests. |
| Services | BCDA Correction Orchestrator, BCDA Policy Guard, BCDA Audit Writer, BCDA Current Value Mgt., BCDA Rollback Service, BCDA Audit Export Mgt., BCDA Value Serializer, BCDA Metadata Explorer, BCDA Validation Runner | Coordinate behavior without putting business logic in pages. |
| Retention | BCDA Retention Manager, BCDA Retention Log | Register app-owned retention tables, clean up expired eligible operation records, expose retention status, and protect active records. |
| Profile Navigation | BCDA Role Center, BC Data Agent profile | Provide a Business Central-native entry point to available foundation tools without granting permissions. |
| Access Control | Existing Business Central `SUPER` permission set only | Do not create BCDA-specific permission set objects; enforce `SUPER`-only access. |

## Planned Object ID Allocation

OD-001 is decided for Phase 1. Current planning range follows `app.json`:

| Range | Intended Use |
| --- | --- |
| 88100-88109 | Tables |
| 88110-88120 | Pages |
| 88120-88132 | Codeunits |
| 88130-88134 | Supporting temporary matrix/buffer tables, reports, or exports if needed |
| 88140-88149 | Supporting objects such as metadata lookup pages if needed; no permission set AL objects are planned |

## Implemented Foundation Objects

| Range | Implemented Objects |
| --- | --- |
| Tables | `BCDA Setup`, `BCDA Data Policy`, `BCDA Correction Request`, `BCDA Correction Line`, `BCDA Batch Line Buffer`, `BCDA Target Record Buffer`, `BCDA Preview Data Matrix`, `BCDA Audit Entry`, `BCDA Value Snapshot`, `BCDA Rollback Operation`, `BCDA Retention Log` |
| Pages | `BCDA Role Center`, `BCDA Setup`, `BCDA Data Policies`, `BCDA Data Policy Card`, `BCDA Correction Requests`, `BCDA Correction Request Card`, `BCDA Correction Lines`, `BCDA Preview Data Matrix`, `BCDA Batch Line Builder`, `BCDA Audit Entries`, `BCDA Rollback Operations`, `BCDA Retention Logs`, `BCDA Table Lookup`, `BCDA Field Lookup`, `BCDA Target Record Lookup` |
| Profiles | `BC Data Agent` |
| Codeunits | `BCDA Access Mgt.`, `BCDA Setup Mgt.`, `BCDA Policy Guard`, `BCDA Audit Writer`, `BCDA Current Value Mgt.`, `BCDA Value Serializer`, `BCDA Correction Orchestrator`, `BCDA Batch Line Mgt.`, `BCDA Retention Manager`, `BCDA Metadata Explorer`, `BCDA Rollback Service`, `BCDA Audit Export Mgt.` |
| Enums | `BCDA Request Status`, `BCDA Line Status`, `BCDA Risk Level`, `BCDA Validation Mode`, `BCDA Rollback Snapshot Mode`, `BCDA Retention Category`, `BCDA Correction Type`, `BCDA Audit Operation`, `BCDA Audit Result`, `BCDA Conflict Policy`, `BCDA Policy Decision` |

## Planned Objects

| Area | Planned Objects |
| --- | --- |
| Target Record Selection | `BCDA Target Record Matrix`, `BCDA Record Identity Mgt.`, `BCDA Target Matrix Mgt.` |

## Procedure Responsibility Contracts

| Contract | Required Behavior |
| --- | --- |
| EvaluatePolicy | Return allow/block, reason, approval requirement, validation mode, and redaction level. If `Allow Data Policies` is off, policy records are bypassed while permanent blocks for BCDA app-owned, unsupported, unaudited, metadata-incomplete, rollback-controlled, and non-`SUPER` mutation paths remain enforced. |
| ResolveTableCaption / ResolveFieldCaption | Resolve table and field captions from verified Business Central metadata for request entry without reading target records. |
| ResolveRecordIdentity | Foundation lookup resolves and validates target `RecordId` identity from primary-key display values only; richer filtering, display-key policy, and matrix behavior still require sandbox validation. |
| UpdateCurrentValuePreview | Read only the selected target record identity and `Field ID`, format the current field value onto the correction line, and avoid target mutation or request-level dry-run behavior. |
| ValidateDataValue | Validate correction-line proposed value staging by correction type. `Update` requires a selected target record identity, non-primary-key field, and existing target record; `Rename` requires the existing target record identity and may stage only primary-key field values; `Insert` validates table/field metadata and scalar compatibility without requiring or reading a target record identity; `Delete` is record-level and does not use proposed field values. All modes avoid target mutation and avoid full validate-trigger dry-run behavior. |
| SetData | Populate the temporary preview matrix page for one request from stored correction-line data grouped by request, correction type, table, record or insert group, and field; avoid target mutation and avoid full request dry-run behavior. |
| BuildTargetRecordMatrix | Populate a temporary matrix buffer for one selected target record, showing available field correction lines and existing staged lines without mutating target data. |
| CreateCorrectionLinesFromBatch | Convert same-table RecordId-backed or insert-group-backed batch entries into standard correction line records without target mutation. |
| BuildPreview | Run request-level staged-line preview without mutation: validate staged line shape, refresh selected current values, evaluate policy, update app-owned line statuses/sanitized messages, and write preview audit evidence. Do not invoke target validate triggers, create rollback snapshots, or write target records. |
| ExecuteRequest | Re-check policy, group staged lines by correction type and canonical target `RecordId` when applicable, validate the whole request before any target mutation, capture before-images for rollback-capable updates, write supported changes in one all-or-nothing request transaction, and audit outcome. `Rename` uses the selected existing `RecordId`, applies staged primary-key fields in primary-key order while preserving unstaged key fields, and records the renamed `RecordId` after successful execution. `Insert` must not use `RecordId` as an input identity; the current implementation groups empty-`RecordId` insert lines by request/table/`Insert Group No.`, creates one record per insert group, requires staged nonblank primary-key fields per group, and records the created `RecordId` after successful execution. |
| WriteAudit | Append a new audit entry; never update prior entries except platform-managed fields. |
| SerializeValue | Preserve typed value, display value, hash, and serialization version. |
| ResolveRollbackLoggingPolicy | Resolve global setup, data policy, request state, and risk into enabled/disabled/required rollback snapshot behavior. |
| RequestRollback | From a completed correction request, verify every executed supported source line has retained before-image material and create a new correction request with suggested inverse `Update` lines. Do not expose rollback from individual audit entries. |
| ExecuteRollback | Direct target-data rollback is not a separate mutation path. The generated rollback correction request must pass the normal preview, policy, approval, execution, audit, rollback snapshot, and all-or-nothing transaction controls before it changes target data. `Rename`, `Delete`, and `Insert` execution are supported with rollback unavailable; rename/delete/insert rollback, conflict override, and missing-snapshot rollback may be implemented only with operation-specific contracts, audit, rollback/unavailable-state behavior, and runtime controls. |
| RegisterRetentionTables | Register BCDA-owned operation tables with Business Central retention policy support when sandbox validation confirms APIs. |
| PreviewRetentionStatus | Report retention periods, expiration dates, expired counts when available, and rollback impact. |
| ExportFilteredAuditMetadata | Require `SUPER`, require setup `Export Enabled`, require at least one audit filter, export CSV audit metadata only, omit target record identity text and snapshot payloads, and never write target records. |
| RunRetentionCleanup | Require `SUPER`, purge expired rollback snapshot payloads, delete expired eligible audit metadata, rollback operations, and retention logs, preserve active requests and retained rollback dependencies, and write retention log evidence. |

## Field And Configuration Contracts

- Every request requires a reason before execution. Ticket/reference is required only when setup or policy requires it, and any provided value must be retained in audit metadata.
- Every change line requires a correction type, target table, rollback logging mode, validation mode, and value references only when retained. `Update` and `Rename` lines require a canonical target `RecordId`; `Rename` lines may stage only primary-key fields, execute through the governed request transaction, and store the renamed `RecordId` after successful execution for audit/review. `Insert` lines must keep `RecordId` empty while staged, use `Insert Group No.` to group all fields for one created record, execute as one new record per request/table/insert-group after required primary-key fields and policy checks pass, and store the created `RecordId` after successful execution for audit/review. `Delete` is record-level, must not require proposed field values, executes through the governed request transaction, and remains rollback-unavailable until operation-aware restore controls exist. Foundation proposed-value staging validates field eligibility and scalar type compatibility, but full Business Central validate-trigger dry-run behavior remains gated.
- The foundation schema stores `RecordId` as read-only app-owned identity metadata. The foundation `Select Existing Record` action can populate it through simple or composite primary-key lookup; users must not hand-type serialized record keys.
- Batch line entry must create the same correction line records a user could enter manually; it must not introduce a separate execution path.
- Every audit entry requires operation, user, timestamp, target, result, and request reference when applicable.
- Posted data policy defaults to blocked until configured otherwise.
- Setup-controlled data policy enforcement bypass is implemented as `Allow Data Policies`, enabled by default. Disabling it bypasses policy records only; permanent runtime controls still apply.
- Approval defaults to required with separate approval, but setup can disable approval for standard requests or allow self-approval for one-person companies that accept that control model.
- Rollback defaults to request-level staging through a new governed correction request.
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

## Runtime-Blocked Behavior

- No direct SQL.
- No silent edits.
- No deleting audit entries outside governed retention.
- No rollback that erases original evidence.
- No record deletion or insertion runtime behavior outside the supported governed `Delete` and grouped `Insert` workflows.
- No primary key rename runtime behavior outside the supported governed `Rename` workflow.
- No external mutation API runtime behavior without `SUPER`, policy, audit, tenant, redaction, throttling, and validation controls.
- No optional rollback snapshot setting may disable mandatory audit metadata.
- No setup-controlled data policy enforcement bypass may permit BCDA app-owned table edits, system/protected table edits, unsupported field writes, unaudited mutation, or non-`SUPER` execution.
- No retention cleanup may delete active in-progress requests.
- No export may include rollback snapshot payloads or target values by default.

## Validation Boundaries

Implementation must validate:

- User has existing Business Central `SUPER` access.
- Table and field policy.
- Request status.
- Required reason and setup- or policy-required ticket/reference.
- Approval state.
- Approval separation state.
- Target record existence.
- Field type support.
- Rollback snapshot logging mode and retention expiration.
- Current value preview for generated rollback correction requests.
