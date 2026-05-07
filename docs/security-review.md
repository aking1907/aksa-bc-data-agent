# Security Review

## Review Status

Draft. Requires human security and business owner review before implementation.

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
| THR-003 | User hides a bad correction | Append-only audit and no audit deletion. |
| THR-004 | Sensitive values leak through logs or exports | Redaction rules and sanitized errors. |
| THR-005 | Rollback overwrites a legitimate later change | Conflict detection before rollback. |
| THR-006 | Broad policy enables accidental mass damage | Deny-first policy and field-level scope. |
| THR-007 | AI-generated code bypasses safeguards | Code-generation readiness gate and traceability review. |
| THR-008 | Rollback snapshots are disabled without user awareness | Preview and execution confirmation must show rollback-unavailable state. |
| THR-009 | Retention deletes data needed for support or compliance | Separate retention categories, conservative defaults, visible expiration, and cleanup evidence. |

## Access Model

The extension must not create BCDA-specific permission sets. All functionality is available only to users who already have the Business Central `SUPER` permission set.

Workflow responsibilities below are audit and process responsibilities, not custom permission roles.

| Responsibility | Intended Access |
| --- | --- |
| SUPER Administrator | Configure setup and policy; cannot bypass audit. |
| SUPER Requester/Executor | Create requests, run previews, execute approved requests. |
| SUPER Approver | Approve or reject high-risk requests when approval policy requires separation. |
| SUPER Reviewer | Review and export audit according to redaction policy. |

## Required Controls Before Code

- Confirm `SUPER` access detection/enforcement design.
- Confirm no BCDA-specific permission sets will be generated.
- Confirm default posted table deny policy.
- Confirm approval model.
- Confirm sensitive value redaction levels.
- Confirm audit retention.
- Confirm rollback snapshot logging defaults and retention periods.
- Confirm rollback conflict behavior.
- Confirm retention cleanup protects active requests.
- Confirm unsupported table/field block list.

## Prohibited Behavior

- Silent modification.
- Direct SQL modification.
- Editing without a request id.
- Deleting audit entries.
- Rollback that removes original evidence.
- Disabling rollback snapshots without visible preview and confirmation.
- Retention cleanup of active in-progress requests.
- Logging full sensitive values in generic telemetry.
- Production enablement before sandbox validation.

## Go/No-Go Checklist

| Check | Status |
| --- | --- |
| `SUPER`-only access model reviewed | Open |
| Posted data policy reviewed | Open |
| Redaction model reviewed | Open |
| Rollback behavior reviewed | Open |
| Rollback logging and retention reviewed | Open |
| Symbol discovery complete | Open |
| Sandbox validation complete | Open |
| Business owner approval for production | Open |
