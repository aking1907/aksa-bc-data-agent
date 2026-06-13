# Domain Model

## Bounded Domain

The bounded domain is controlled Business Central data correction. The app owns correction governance, audit, policy, and rollback metadata. Business Central owns the business records being corrected.

## Core Terms

| Term | Meaning | Owner |
| --- | --- | --- |
| Correction Request | A governed request to change one or more fields on one or more target records. | BC Data Agent |
| Change Line | One proposed field-level mutation inside a correction request. | BC Data Agent |
| Target Record | The Business Central record being inspected or changed. | Business Central |
| Hidden Data | Data not normally available through user-facing pages, personalization, or standard workflows. | Business Central |
| Posted Data | Data in posted document, ledger, register, or historical tables where edits are high-risk. | Business Central |
| Before-Image | Captured value and context before mutation, used for audit and rollback. | BC Data Agent |
| Audit Metadata | Mandatory operation evidence such as user, company, target, result, reason, ticket, and timestamps. | BC Data Agent |
| Rollback Snapshot | Optional protected value payload used to stage prior values when rollback is enabled and retained. | BC Data Agent |
| Rollback Operation | Governed evidence that a completed request generated a rollback correction request. | BC Data Agent |
| Retention Policy | User-controlled rule for how long BCDA-owned operation records remain in the database. | BC Data Agent and Business Central |
| Data Policy | Configuration that allows, blocks, or restricts correction behavior by table, field, risk, and workflow policy. | BC Data Agent |
| Policy Enforcement Bypass | Setup-controlled behavior through `Allow Data Policies`. When disabled, non-BCDA target data can proceed without matching policy records only if permanent safety blocks still pass. | BC Data Agent |
| Approval Separation | Setup rule deciding whether approval must be performed by a different `SUPER` user or may be self-approved. | BC Data Agent |
| Break-Glass Change | High-risk correction allowed only under existing `SUPER` access, reason, approval, and audit requirements. | BC Data Agent |

## Entities

| Entity | Description |
| --- | --- |
| Setup | Global configuration for correction behavior, retention, and default safety policy. |
| Data Policy | Allow/block rules for tables and fields. |
| Correction Request | Request header, status, reason, ticket, requestor, approval requirement, approval separation, approver, and risk. |
| Correction Line | Table, key, field, value, validation mode, status, and error information. |
| Audit Entry | Append-only record of preview, approval, execution, failure, and rollback activity. |
| Value Snapshot | Protected before-image and after-image data needed for audit or rollback. |
| Rollback Operation | Links rollback activity to the completed source request and generated rollback correction request. |
| Retention Status | Operational view of configured retention, expired snapshots, and cleanup activity. |

## Value Objects

| Value Object | Fields |
| --- | --- |
| Record Identity | Company, table id/name, canonical `RecordId`, formatted record id, and display key. |
| Field Identity | Field id/name, data type, caption, sensitivity classification. |
| Correction Value | Serialized value, display value, hash, redaction state. |
| Insert Group | App-owned group number that ties staged `Insert` fields together as one created target record. |
| Approval Decision | Approver, date/time, outcome, comment. |
| Risk Classification | Normal, hidden, posted, financial, sensitive, blocked. |
| Rollback Logging Mode | Enabled, disabled, or policy controlled. |
| Retention Category | Audit metadata, rollback snapshot, or technical log. |

## Invariants And Business Rules

- A target data change cannot occur without a correction request.
- A correction request cannot execute unless policy allows it or `Allow Data Policies` is disabled while permanent safety blocks still pass.
- Posted data changes require existing Business Central `SUPER` access and approval by default; approval requirement and approval separation are configurable for standard request workflows.
- Every executed change writes mandatory audit metadata first.
- Every executed change captures a before-image when rollback snapshot logging is enabled.
- Every attempted execution writes audit evidence, including failure.
- Audit entries are append-only during operations; governed retention may remove expired operation records.
- Audit metadata is mandatory even when rollback snapshots are disabled.
- Rollback snapshots are stored only when setup and policy enable them.
- Rollback creates a new correction request and new audit entries; it does not erase original activity.
- Rollback must check that the current target value still matches the expected post-change value unless a policy-approved override exists.
- Rollback is unavailable when snapshots were disabled, purged, or expired.
- Retention cleanup must not delete active in-progress requests.
- Blocked tables and fields cannot be changed.
- BCDA app-owned, system, protected, unsupported, unaudited, rollback-unready, and non-`SUPER` mutation paths remain blocked even if a future setup setting disables data policy record enforcement.
- Sensitive values cannot be exposed to users without `SUPER` access or through unauthorized logs, exports, or support channels.
- Correction lines identify target records by a canonical platform `RecordId` plus company context. In the foundation build the value is read-only app-owned storage populated by the `Select Existing Record` primary-key lookup, which shows all simple or composite key values before selection; hand-entered serialized keys are not part of the workflow.
- Insert correction lines keep `RecordId` empty while staged, use `Insert Group No.` to tie fields together for one created record, execute as one new record per request/table/insert-group, require staged nonblank primary-key fields for each group, and store the created `RecordId` after successful execution for audit/review.

## Domain Events

| Event | Trigger |
| --- | --- |
| CorrectionRequestCreated | A request is saved. |
| CorrectionPreviewGenerated | A dry run is completed. |
| CorrectionApproved | A SUPER approver approves a request when approval is required, according to the configured approval separation rule. |
| CorrectionRejected | A SUPER approver rejects a request. |
| CorrectionExecutionStarted | Execution begins. |
| CorrectionLineSucceeded | One change line succeeds. |
| CorrectionLineFailed | One change line fails. |
| CorrectionExecutionCompleted | Request execution ends. |
| RollbackRequested | Rollback is initiated. |
| RollbackCompleted | Generated rollback correction request completes through the normal request execution workflow. |
| RollbackSnapshotExpired | Retention cleanup removes rollback payloads for an operation. |
| RetentionPolicyApplied | App-owned operation data cleanup completes. |

## Data Ownership

BC Data Agent owns only its setup, policy, request, snapshot, audit, and rollback records. It does not own the target business records. Target record ownership remains with Business Central and the business process owner.

## Open Modeling Decisions

- How to serialize all supported field types safely.
- Default and minimum retention periods for audit metadata and rollback snapshots.
- External approval workflow integration, if ever needed beyond configurable one-person or separate-approver approval.
- Which posted tables are blocked by default.
- Operation-aware rollback behavior for `Rename`, `Delete`, and `Insert`.
