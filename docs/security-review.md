# Security Review

## Review Status

Draft. Phase 8 filtered audit metadata export, governed retention cleanup, Phase 7 request-level rollback staging, Phase 6 grouped update execution, supported primary-key rename execution, supported record-level delete execution, supported grouped insert execution, and `Allow Data Policies` are implemented locally. Local code development is under standing authorization, while rename/delete/insert rollback, other non-update rollback, conflict override, unfiltered export, unredacted export, snapshot payload export, external APIs, and production enablement remain runtime-gated by controls, sandbox validation, and readiness evidence.

## Security Objectives

- Prevent unauthorized data correction.
- Prevent untraceable changes.
- Prevent sensitive value exposure.
- Prevent casual edits to posted or financial data.
- Preserve rollback capability without deleting audit evidence.

## Protected Assets

| Asset | Protection Need |
| --- | --- |
| Business Central target records | Integrity and business process ownership. |
| Posted financial data | Compliance, auditability, and approval. |
| Audit entries | Immutability and retention. |
| Rollback snapshots | Confidentiality and integrity. |
| Retention settings | Integrity and operational control. |
| User identities and approval history | Accountability and privacy. |
| Export files | Redaction and access control. |

## Threat Scenarios

| ID | Threat | Control |
| --- | --- | --- |
| THR-001 | Unauthorized user edits data | Existing Business Central `SUPER` access gate and policy guard. |
| THR-002 | Authorized user edits posted data without approval | Posted data approval requirement. |
| THR-003 | User hides a bad correction | Append-only audit during operations; governed retention is the only allowed removal path for expired operation records. |
| THR-004 | Sensitive values leak through logs or exports | Redaction rules and sanitized errors. |
| THR-005 | Rollback overwrites a legitimate later change | Conflict detection before rollback. |
| THR-006 | Broad policy enables accidental mass damage | Deny-first policy and field-level scope. |
| THR-007 | AI-generated code bypasses safeguards | Standing implementation authorization still requires SDD alignment, user review, data policies, `SUPER`, audit, redaction, rollback controls, tests, and sandbox validation before production reliance. |
| THR-008 | Rollback snapshots are disabled without user awareness | Preview and execution confirmation must show rollback-unavailable state. |
| THR-009 | Retention deletes data needed for support or compliance | Separate retention categories, conservative defaults, visible expiration, active request protection, retained rollback dependency protection, and cleanup evidence. |
| THR-010 | One-person self-approval or no-approval mode weakens dual control | Approval with a separate approver is the safer default; no-approval and self-approval modes must be explicit setup choices and remain visible on the request/audit trail. |
| THR-011 | Batch entry makes it easier to stage many risky changes at once | Batch entry creates only standard correction lines; preview, policy, approval when configured, execution, audit, rollback, and runtime validation controls still apply before any mutation. |
| THR-012 | A user mistypes or ambiguously serializes a composite record key | Planned target selection uses canonical `RecordId` plus company context and a matrix-style selector instead of hand-entered composite keys. |
| THR-013 | Current value preview exposes sensitive selected-field values | Preview is available only through `SUPER`-gated pages, is limited to the selected record and field, and remains excluded from export/generic telemetry. Sandbox validation must confirm sensitive-value handling before production use. |
| THR-014 | Operation type labels imply rename, delete, or insert is safer than its operation-specific contracts allow | Current runtime behavior supports governed `Rename`, `Delete`, and grouped `Insert` execution with rollback unavailable; request-level rollback for those non-update operations remains unavailable until operation-specific rollback controls exist. |
| THR-015 | A setup switch that disables data policy enforcement turns BCDA into a broad table editor | `Allow Data Policies` is enabled by default. When disabled, execution still blocks BCDA app-owned tables, unsupported fields, and any operation lacking `SUPER`, required request metadata, audit, rollback snapshot controls, and sandbox validation. |
| THR-016 | BCDA app-owned operation tables are selected as correction targets | Foundation metadata validation, table lookup, and policy evaluation permanently block BCDA app-owned tables in the object range 88100..88149 from correction and policy targets. |
| THR-017 | Standing implementation authorization is mistaken for approval to enable unsafe runtime behavior | Local code development is separated from runtime/production enablement; runtime behavior still requires user review, policies, `SUPER`, audit, redaction, rollback controls, tests, and sandbox validation evidence. |

## Access Model

The extension must not create BCDA-specific permission sets. All functionality is available only to users who already have the Business Central `SUPER` permission set.

Workflow responsibilities below are audit and process responsibilities, not custom permission roles.

| Responsibility | Intended Access |
| --- | --- |
| SUPER Administrator | Configure setup and policy; cannot bypass audit. |
| SUPER Requester/Executor | Create requests, run previews, execute approved requests. |
| SUPER Approver | Approve or reject high-risk requests when approval policy requires approval. This may require a different user or allow self-approval depending on setup. |
| SUPER Reviewer | Review and export audit according to redaction policy. |

## Required Controls Before Production Use

- Confirm `SUPER` access detection/enforcement design.
- Confirm no BCDA-specific permission sets will be generated.
- Confirm default posted table deny policy.
- Confirm approval model.
- Confirm sensitive value redaction levels.
- Confirm audit retention.
- Confirm rollback snapshot logging defaults and retention periods.
- Confirm generated rollback request preview and execution behavior.
- Confirm retention cleanup protects active requests.
- Confirm filtered audit export omits target values, target record identity text, and rollback snapshot payloads.
- Confirm unsupported table/field block list.
- Confirm target record `RecordId` selection and matrix entry do not expose sensitive target values before preview authorization.
- Confirm `Allow Data Policies` behavior and which table and field classes remain permanently blocked.

## Prohibited Behavior

- Silent modification.
- Direct SQL modification.
- Editing without a request id.
- Deleting audit entries outside governed retention cleanup.
- Rollback that removes original evidence.
- Disabling rollback snapshots without visible preview and confirmation.
- Retention cleanup of active in-progress requests.
- Logging full sensitive values in generic telemetry.
- Exporting target values, target record identity text, or rollback snapshot payloads through the Phase 8 CSV export.
- Production enablement before sandbox validation.
- Rename rollback, delete rollback, or insert rollback before operation-specific execution contracts, user review, policy, audit, rollback/unavailable-state handling, and sandbox validation explicitly allow those operations.
- Disabling data policies in a way that permits unguarded target writes, BCDA app-owned table edits, system/protected table edits, unsupported field writes, or unaudited mutation.
- Creating policies or correction lines that target BC Data Agent app-owned tables.

## Go/No-Go Checklist

| Check | Status |
| --- | --- |
| `SUPER`-only access model defined and validated | Open |
| Posted data policy defined and validated | Open |
| Redaction model defined and validated | Open |
| Rollback behavior defined and validated | Open |
| Rollback logging and retention defined and validated | Open |
| Platform validation complete | Open |
| Sandbox validation complete | Open |
| Production readiness validated | Open |
