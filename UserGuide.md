# BC Data Agent User Guide

## Document Status

This guide explains how to use BC Data Agent from a user and administrator point of view.

Current implementation status: Phase 2 foundation. The `BC Data Agent` profile, BCDA Role Center, setup, policy, correction request, correction line, audit entry, retention log, and `SUPER`-gated shell pages exist. Target record preview, target record execution, rollback execution, and audit export are not enabled yet.

Use this guide in two ways:

- For the current foundation build, follow the sandbox validation and administration steps that are marked as available now.
- For the planned full workflow, use the future sections as the operating model that later readiness gates must implement and validate.

## Product Purpose

BC Data Agent is a Business Central extension for exceptional data correction work. It is intended for controlled support scenarios where standard Business Central correction tools are not enough.

The app is not a casual table editor. It is a break-glass workflow for authorized `SUPER` users who need to prepare, approve, audit, and later roll back carefully governed changes to Business Central data, including hidden or posted data when policy explicitly allows it.

## Most Important Safety Rules

1. Use normal Business Central correction flows first, such as reversals, credit memos, journals, or assisted setup.
2. Use BC Data Agent only for exceptional support or recovery cases.
3. All users must already have the standard Business Central `SUPER` permission set.
4. Do not create, assign, or expect BCDA-specific permission sets.
5. Every request must have a business reason and a ticket/reference before preview, approval, or execution actions.
6. Posted data and high-risk data must be treated as break-glass work.
7. Approval is configurable. Use a separate approver for higher-risk companies, disable approval only for accepted standard-request workflows, and allow self-approval only when the business accepts that control model.
8. Audit metadata is mandatory.
9. Rollback snapshot logging is configurable, but if snapshots are disabled, rollback will be unavailable.
10. Retention settings control how long app-owned operation records remain available.
11. In the current foundation build, target data execution is intentionally blocked.

## Who Should Use This Guide

| User | Typical Responsibility |
| --- | --- |
| `SUPER` Administrator | Configure setup, retention, rollback defaults, and policies. |
| `SUPER` Support User | Create correction requests and add correction lines. |
| `SUPER` Approver | Review and approve high-risk or approval-required requests when the setup requires approval. |
| `SUPER` Reviewer | Review audit entries, retention logs, and support evidence. |
| Technical Lead | Validate sandbox behavior before opening the next readiness gate. |

## Current Capability Map

| Area | Available Now | What You Can Do | Current Boundary |
| --- | --- | --- | --- |
| Profile and Role Center | Yes | Select the `BC Data Agent` role/profile and open available foundation tools from one hub. | The profile is navigation only; linked BCDA pages still require the existing `SUPER` permission set. |
| Access control | Yes | Open BCDA pages only as a `SUPER` user. | Non-`SUPER` access must be denied by runtime checks. |
| Setup | Yes | Configure default policy, preview, rollback, retention, and export flag. | Export generation is not implemented. |
| Data policies | Yes | Maintain table and field policy records. | Policy evaluation exists as foundation logic only. |
| Correction requests | Yes | Create request headers, apply setup defaults, manage request state. | Real target data preview and mutation are blocked. |
| Correction lines | Yes | Enter target table, field, record key, and proposed value text. | Current value preview is not populated by target record reads yet. |
| Approval | Yes | Submit and approve requests only when approval is required, with configurable separate-approver or self-approval behavior. | Full policy-driven approval workflow is still future hardening. |
| Execution | Blocked by design | Attempting execution writes blocked audit evidence and stops. | No target Business Central data is changed. |
| Audit entries | Yes | Review append-only audit evidence for foundation actions. | Audit export is not implemented. |
| Retention logs | Yes | Review retention log records. | Retention cleanup behavior is still future implementation. |
| Rollback | Stored state only | Review rollback-related setup and request fields. | Rollback execution is not implemented. |

## Opening BC Data Agent

For the most convenient entry point, switch to the `BC Data Agent` role/profile from My Settings. This opens the BCDA Role Center with links to the currently available foundation tools.

You can also use Business Central search, often called Tell Me, to find these pages:

| Search For | Page | Use |
| --- | --- | --- |
| `BCDA Setup` | BCDA Setup | Global configuration, rollback defaults, retention, and retention registration. |
| `BCDA Data Policies` | BCDA Data Policies | Maintain allowed, blocked, or approval-required targets. |
| `BCDA Correction Requests` | BCDA Correction Requests | Create and manage correction request work. |
| `BCDA Audit Entries` | BCDA Audit Entries | Review operation evidence. |
| `BCDA Retention Logs` | BCDA Retention Logs | Review retention and cleanup evidence. |

If you cannot open a BCDA page, confirm that your Business Central user has the existing `SUPER` permission set. This extension does not provide its own permission set.

## First-Time Sandbox Setup

Perform first-time setup in a sandbox environment only.

1. Sign in as a user with the Business Central `SUPER` permission set.
2. Optionally switch to the `BC Data Agent` role/profile from My Settings.
3. Open `BCDA Setup` from the Role Center or Tell Me.
4. Confirm that the setup record is created automatically.
5. Set a clear `Environment Label`, such as `Sandbox - BCDA Validation`.
6. Keep `Default Policy Decision` set to `Block` until explicit policies are reviewed.
7. Set `Approval Required Default` according to the company control model.
8. Keep `Require Separate Approver` enabled for dual-control validation, or turn approval off or separate approval off only for a one-person company that accepts that control model.
9. Keep `Require Preview` enabled.
10. Set `Rollback Snapshot Default` to `Required` for high-risk validation.
11. Review retention days for audit metadata, rollback snapshots, and technical logs.
12. Select `Register Retention Tables` to register BCDA operation tables with Business Central retention policy support.
13. Open `BCDA Data Policies` and create only safe sandbox policies.
14. Create a foundation correction request and verify that audit entries are written.
15. Attempt execution only to confirm that the foundation readiness gate blocks target data mutation.

## Setup Page Guide

### General FastTab

| Field | Meaning | Recommended Starting Value |
| --- | --- | --- |
| Environment Label | Text shown to help users recognize where they are working. | Use a plain label such as `Sandbox`, `UAT`, or `Production - Restricted`. |
| Default Policy Decision | Decision used when no matching table or field policy exists. | `Block`. |
| Approval Required Default | Whether requests require approval by default. | Enabled for dual control; disabled for owner-operated companies that approve through ticket discipline instead. |
| Require Separate Approver | Whether approval must be performed by a different `SUPER` user when approval is required. | Enabled for safer default; disabled only when one `SUPER` user must perform the whole workflow. |
| Require Preview | Whether a request must be previewed before execution. | Enabled. |

### Rollback FastTab

| Field | Meaning | Recommended Starting Value |
| --- | --- | --- |
| Rollback Snapshot Default | Default behavior for rollback before-image snapshots. | `Required` for posted or high-risk work, `Enabled` for normal governed work. |

Rollback snapshot modes:

| Mode | Meaning | User Impact |
| --- | --- | --- |
| Policy Controlled | Resolve behavior from setup and data policy. | Best when policy rules are mature. |
| Enabled | Store rollback snapshots when execution is later enabled. | Rollback can be available while snapshots are retained and conflict checks pass. |
| Disabled | Do not store rollback snapshots. | Rollback will be unavailable. Audit metadata still remains mandatory. |
| Required | Execution should require rollback snapshot capture. | Safer default for posted and high-risk targets. |

### Retention FastTab

| Field | Meaning | Default In Foundation Tables |
| --- | --- | --- |
| Audit Retention Days | How long audit metadata should remain. | `3650` days. |
| Snapshot Retention Days | How long rollback snapshots should remain. | `90` days. |
| Technical Log Retention Days | How long technical logs should remain. | `30` days. |
| Export Enabled | Future flag for audit export. | Disabled unless export policy is approved. |

Retention guidance:

- Keep audit retention long enough for support, compliance, and internal review.
- Keep snapshot retention long enough for the expected correction review window.
- Do not set retention to `0` unless your business has explicitly accepted immediate or near-immediate cleanup semantics in the implemented cleanup process.
- Remember that expired or purged rollback snapshots make rollback unavailable.

### System FastTab

| Field | Meaning |
| --- | --- |
| Foundation Version | Internal foundation schema marker. |
| Last Initialized At | Date and time when setup defaults were initialized. |

Users should not edit system fields.

## Registering Retention Tables

On the `BCDA Setup` page, use the `Register Retention Tables` action after installation or upgrade.

This action registers BCDA-owned operation tables with Business Central retention policy allowed-table support:

- audit entries,
- value snapshots,
- retention logs.

The action is safe to run during setup validation. It does not modify target Business Central business data.

## Data Policy Guide

Data policies define which target tables and fields are blocked, allowed, or require approval.

In the current foundation build, policy records can be maintained and foundation policy evaluation exists. Full target preview and execution are still gated.

### Policy Matching

BCDA policies can be table-level or field-level.

| Policy Type | How To Configure | Meaning |
| --- | --- | --- |
| Table-level policy | Set `Table ID`; set `Field ID` to `0`. | Applies to the table when no more specific field policy exists. |
| Field-level policy | Set both `Table ID` and `Field ID`. | Applies to one field and takes precedence over table-level policy. |

The foundation policy guard checks for a matching field-level `MODIFY` policy first. If none exists, it checks for a table-level `MODIFY` policy. If neither exists, the setup `Default Policy Decision` applies.

### Policy List Fields

| Field | Meaning |
| --- | --- |
| Policy ID | Unique policy identifier. Created automatically when blank. |
| Description | Plain-language description for reviewers. |
| Enabled | Whether the policy participates in evaluation. |
| Table ID | Target Business Central table ID. |
| Table Name | Human-readable target table name. |
| Field ID | Target field ID, or `0` for a table-level policy. |
| Field Name | Human-readable target field name. |
| Risk Level | Risk classification for the target. |
| Decision | Block, Allow, or Approval Required. |
| Rollback Snapshot Mode | Snapshot behavior for this target. |

### Policy Card Fields

Use the policy card when creating or reviewing a policy.

General:

- `Policy ID`: unique identifier.
- `Description`: why the policy exists.
- `Enabled`: whether the policy is active.

Target:

- `Table ID`: Business Central table number.
- `Table Name`: table caption or name.
- `Field ID`: Business Central field number, or `0` for table-level policy.
- `Field Name`: field caption or name.
- `Operation`: currently shaped for `MODIFY`.

Policy:

- `Risk Level`: `Low`, `Normal`, `High`, or `Posted`.
- `Decision`: `Block`, `Allow`, or `Approval Required`.
- `Requires Approval`: extra approval signal for the target.
- `Validation Mode`: how field validation should be performed once execution is enabled.
- `Rollback Snapshot Mode`: target-specific snapshot rule.
- `Retention Override Days`: optional retention override.
- `Blocked Reason`: user-facing reason when a request is blocked.

Review:

- `Last Reviewed At`: automatically stamped when policy changes.
- `Last Reviewed By`: automatically stamped with the user who changed the policy.

### Policy Decisions

| Decision | Meaning | When To Use |
| --- | --- | --- |
| Block | Requests for this target should not proceed. | Default for unknown, dangerous, unsupported, or legally sensitive targets. |
| Allow | Requests can proceed when other requirements are satisfied. | Low or normal risk targets in sandbox or reviewed support scenarios. |
| Approval Required | A `SUPER` user must approve before execution; setup decides whether that user must be different from the requester. | Posted, financial, high-risk, or business-critical targets. |

### Risk Levels

| Risk Level | Meaning | Typical Handling |
| --- | --- | --- |
| Low | Low operational impact. | Still audit and require reason/ticket. |
| Normal | Standard governed correction. | Preview, policy check, audit, and rollback awareness required. |
| High | Business-critical or sensitive target. | Approval and rollback snapshots recommended. |
| Posted | Posted data or posting-related data. | Treat as break-glass, require approval, and require rollback snapshot logging unless explicitly accepted otherwise. |

### Policy Examples

Safe sandbox table-level policy:

| Field | Example |
| --- | --- |
| Description | Sandbox customer non-posted notes correction |
| Table ID | A safe sandbox table selected for validation |
| Field ID | `0` |
| Risk Level | `Normal` |
| Decision | `Approval Required` |
| Rollback Snapshot Mode | `Required` |
| Validation Mode | `Validate Trigger` |

Blocked sensitive field policy:

| Field | Example |
| --- | --- |
| Description | Block primary key or posting integrity field |
| Table ID | Target table ID |
| Field ID | Target field ID |
| Risk Level | `High` or `Posted` |
| Decision | `Block` |
| Blocked Reason | Primary keys, posting integrity fields, and protected controls require a reviewed exception. |

## Correction Request Guide

Correction requests are the main work container. A request describes why a correction is needed, who requested it, whether approval is required, and which correction lines are included.

In the current foundation build, you can create and move requests through foundation states. The app does not yet read target record values or modify target records.

### Request List

Open `BCDA Correction Requests` to see existing requests.

Important columns:

| Column | Meaning |
| --- | --- |
| Request ID | Unique request identifier. |
| Status | Current workflow state. |
| Ticket Reference | External support ticket, incident, case, or approval reference. |
| Reason | Business reason for the correction. |
| Risk Level | Request-level risk classification. |
| Requested By | User who created the request. |
| Requested At | Request creation time. |
| Approved By | `SUPER` user who approved the request. This is blank when approval is not required and may be the requester when separate approval is not required. |
| Rollback Availability | Current rollback message from setup or future preview. |

### Request Card

Open a request to manage the details.

General:

- `Request ID`: created automatically when blank.
- `Status`: workflow state.
- `Company Name`: company context.
- `Reason`: required business reason.
- `Ticket Reference`: required external reference.
- `Risk Level`: request risk classification.

Approval:

- `Requested By`: user who created the request.
- `Requested At`: request creation time.
- `Approval Required`: defaulted from setup.
- `Approved By`: `SUPER` user who approved. This stays blank when approval is not required and can be the requester only when `Require Separate Approver` is off.
- `Approved At`: approval time.

Lines:

- Field-level proposed changes for this request.

Rollback And Retention:

- `Preview Required`: defaulted from setup.
- `Last Preview At`: foundation preview marker timestamp.
- `Rollback Availability`: current rollback message.
- `Retention Impact`: current retention summary.

### Correction Lines

Each correction line represents one proposed field-level change.

| Field | Meaning |
| --- | --- |
| Line No. | Line identifier, automatically assigned in increments. |
| Table ID | Target table number. |
| Table Name | Target table name or caption. |
| Record Key | Text representation of the target record key. |
| Field ID | Target field number. |
| Field Name | Target field name or caption. |
| Proposed New Value | New value text to apply in a future execution phase. |
| Current Value Preview | Future preview field. Not populated by real target reads in the foundation build. |
| Rollback Snapshot Mode | Line-level rollback snapshot mode. |
| Validation Mode | Line-level validation behavior. |
| Line Status | Current line state. |
| Sanitized Error | Non-sensitive error details. |

### Required Request Metadata

Before preview, approval, or execution actions, enter:

- `Reason`,
- `Ticket Reference`.

If either value is missing, the app stops the action with this foundation error:

```text
Reason and ticket/reference are required before this action.
```

### Foundation Request Actions

| Action | Available Now | What It Does |
| --- | --- | --- |
| Initialize | Yes | Applies setup defaults, saves the request, and writes request-created audit evidence. |
| Mark Previewed | Yes | Records a foundation preview marker. It does not read target data yet. |
| Submit For Approval | Yes | Sets status to `Pending Approval` after required metadata exists. |
| Approve | Yes when approval is required | Approves the request. The requester can approve only when separate approver is not required. |
| Execute | Blocked by design | Writes blocked audit evidence and stops with the readiness-gate error. |

### Request Statuses

| Status | Meaning |
| --- | --- |
| Open | Request is being prepared. |
| Pending Approval | Request was submitted for approval. |
| Approved | Request was approved by a `SUPER` user according to the request approval settings. |
| Rejected | Planned rejected state. |
| Previewed | Foundation preview marker was recorded. |
| Executing | Future execution in progress. |
| Completed | Future execution completed. |
| Failed | Future execution failed. |
| Cancelled | Planned cancelled state. |

### Line Statuses

| Status | Meaning |
| --- | --- |
| Open | Line is being prepared. |
| Previewed | Future line preview completed. |
| Approved | Future line approval completed. |
| Executed | Future line execution completed. |
| Failed | Future line execution failed. |
| Rollback Pending | Future rollback requested. |
| Rolled Back | Future rollback completed. |

## Current Foundation Workflow

Use this workflow to validate the current foundation build in a sandbox.

1. If desired, switch to the `BC Data Agent` role/profile and use the BCDA Role Center links for the foundation pages.
2. Open `BCDA Setup`.
3. Confirm setup defaults and retention values.
4. Run `Register Retention Tables`.
5. Open `BCDA Data Policies`.
6. Create a safe sandbox policy.
7. Open `BCDA Correction Requests`.
8. Create a new request.
9. Enter `Reason`, `Ticket Reference`, `Company Name`, and `Risk Level`.
10. Use `Initialize`.
11. Add one correction line with safe sandbox target metadata.
12. Use `Mark Previewed`.
13. Use `Submit For Approval` if approval is required.
14. If `Require Separate Approver` is enabled, sign in or switch to a different `SUPER` user.
15. If approval is required, open the request and use `Approve`.
16. Use `Execute` only to confirm that execution is blocked by design.
17. Open `BCDA Audit Entries`.
18. Confirm audit entries exist for request creation, preview, approval, and blocked execution where applicable.
19. Open `BCDA Retention Logs` if retention registration or cleanup validation produced log entries.

Expected execution-blocked message:

```text
Target data execution is blocked until mutation readiness is approved.
```

If this message appears during foundation validation, the app is behaving correctly. No target Business Central business data should be changed.

## Planned Full Correction Workflow

This section describes the intended user experience after future readiness gates enable target preview, execution, rollback, and export. It is not fully available in the current foundation build.

1. A `SUPER` support user creates a correction request.
2. The user enters reason, ticket/reference, company, target table, record key, field, and proposed new value.
3. The app evaluates setup and data policy.
4. The user runs preview.
5. Preview shows current value, proposed value, validation mode, rollback snapshot mode, retention period, warnings, and rollback availability.
6. A `SUPER` user approves if policy requires approval. The approver must be a different user only when the request requires separate approval.
7. The user executes the approved request.
8. The app re-checks policy and access before mutation.
9. The app captures before-image snapshots when rollback snapshot logging is enabled or required.
10. The app writes the target field change only if Business Central platform behavior allows it.
11. The app writes audit evidence for success, failure, or blocked result.
12. A reviewer validates audit evidence.
13. If the correction was wrong, a `SUPER` user starts rollback while snapshots are retained.
14. The app checks for conflicts before rollback.
15. Rollback restores the previous value when allowed and writes new audit evidence.

## Rollback And Retention Concepts

### Mandatory Audit Metadata

Audit metadata is always required. It records who did what, when, where, and why.

Examples:

- request ID,
- line number,
- user ID,
- timestamp,
- company,
- table and field IDs,
- reason,
- ticket/reference,
- operation,
- result,
- sanitized error.

### Rollback Snapshots

Rollback snapshots are before-image and value records that future rollback uses to restore prior values.

If rollback snapshots are disabled:

- audit metadata still exists,
- rollback is unavailable,
- the user must understand the consequence before execution.

If rollback snapshots expire or are purged:

- audit metadata may still exist,
- rollback material is gone,
- rollback must be blocked or escalated outside BCDA.

### Retention Categories

| Category | Meaning |
| --- | --- |
| Audit Metadata | Operation evidence such as request, user, time, result, and reason. |
| Rollback Snapshot | Stored values needed to support rollback. |
| Technical Log | Sanitized diagnostics and retention cleanup details. |

## Audit Entries Guide

Open `BCDA Audit Entries` to review operation history.

The audit page is read-only. Users cannot insert, edit, or delete audit entries through the page.

Important columns:

| Column | Meaning |
| --- | --- |
| Entry No. | Audit entry identifier. |
| Operation | Request Created, Preview, Approval, Execution, Rollback, Retention Cleanup, Policy Change, or Setup Change. |
| Result | Success, Failed, Blocked, or Warning. |
| Request ID | Related correction request. |
| Line No. | Related correction line when available. |
| User ID | User who caused the audit entry. |
| Occurred At | Date and time of the audit event. |
| Company Name | Company context. |
| Target Table ID | Target table number. |
| Target Field ID | Target field number. |
| Rollback Available | Whether rollback material is linked. |
| Sanitized Error | Non-sensitive error or status detail. |

Audit entries are append-only during operations. Rollback must create new audit entries rather than erasing original evidence. Governed retention may later remove expired app-owned operation records according to configured retention policy.

## Retention Logs Guide

Open `BCDA Retention Logs` to review retention and cleanup evidence.

The retention log page is read-only.

Important columns:

| Column | Meaning |
| --- | --- |
| Entry No. | Retention log identifier. |
| Retention Category | Audit Metadata, Rollback Snapshot, or Technical Log. |
| Table ID | App-owned table affected by retention behavior. |
| Cutoff Date | Date used for retention cutoff. |
| Expired Count | Number of records identified as expired. |
| Deleted Count | Number of records removed. |
| Result | Success, Failed, Blocked, or Warning. |
| Sanitized Error | Non-sensitive details. |
| Created By | User who created the retention log entry. |
| Created At | Date and time the log entry was created. |

## Approval Rules For Users

Approval is configurable so the same app can support both larger companies with dual control and small owner-operated companies where one `SUPER` user must perform the whole workflow.

| Setup | Result |
| --- | --- |
| `Approval Required Default` off | New requests do not require approval by default. The user can continue after preview and policy checks once future execution is enabled. |
| `Approval Required Default` on and `Require Separate Approver` on | Approval is required and the approving user must be different from the requester. This is the safest default for high-risk work. |
| `Approval Required Default` on and `Require Separate Approver` off | Approval is required, but the requester can self-approve. Use this for one-person companies only when the business accepts the risk. |

The request stores `Approval Required` and `Require Separate Approver` when setup defaults are applied, so reviewers can see which approval model was used. When approval is disabled, separate approval is cleared on the request and the approval actions are not needed.

If separate approval is required and the requester tries to approve their own request, the app shows:

```text
A different SUPER user must approve this BC Data Agent request because separate approval is required.
```

Recommended approval practice:

- The requester documents the issue and proposed correction.
- The approver confirms business owner approval when posted or high-risk data is involved.
- The approver checks rollback snapshot mode and retention impact.
- The approver confirms the request is in the correct company and environment.
- The approver confirms the target is covered by policy.
- If approval is disabled or self-approval is enabled, the same `SUPER` user must still document the reason, ticket/reference, rollback impact, and policy decision clearly enough for later review.

## Working With Posted Or Hidden Data

Posted and hidden data can affect financial reporting, inventory, audit trails, customer history, and legal records.

Before allowing posted or hidden data:

1. Confirm standard Business Central correction flows are not sufficient.
2. Confirm the scenario is documented in a support ticket or change request.
3. Confirm business owner approval.
4. Confirm the exact table and field are allow-listed or approval-required by policy.
5. Confirm rollback snapshot logging is enabled or required.
6. Confirm retention is long enough for review and rollback.
7. Confirm the change is tested in sandbox first.
8. Confirm the target platform behavior has been validated for the specific Business Central version.

## What Not To Do

Do not use BC Data Agent to:

- bypass Business Central licensing, tenant boundaries, or platform security,
- edit target data silently,
- perform direct SQL updates,
- replace normal posted document correction workflows,
- perform bulk migration work,
- rename primary keys,
- delete target records,
- delete or rewrite audit history outside governed retention,
- store credentials or secrets in request text,
- paste sensitive customer data into external chats or generic logs,
- execute production corrections before sandbox validation and readiness approval.

## Troubleshooting

| Symptom | Likely Cause | What To Check |
| --- | --- | --- |
| User cannot open BCDA pages | User is not recognized as `SUPER`. | Confirm the standard Business Central `SUPER` permission set is assigned. |
| Setup page opens but values are blank | Setup was not initialized or page did not refresh. | Reopen `BCDA Setup`; setup should be created automatically. |
| Preview, approval, or execution action fails for missing metadata | Reason or ticket/reference is blank. | Enter both fields on the request card. |
| Requester cannot approve their own request | `Require Separate Approver` is enabled for the request. | Use a different `SUPER` user, or change setup for future requests if the company accepts self-approval. |
| Approval actions are unavailable | `Approval Required` is off for the request. | Continue with the next allowed workflow step, or change setup/future request defaults if approval should be required. |
| Execute action stops with readiness-gate error | Current foundation build blocks target mutation. | Treat as expected behavior until the next readiness gate. |
| Current Value Preview is blank | Real target preview is not implemented yet. | Use foundation validation only; do not assume target values were read. |
| Rollback is unavailable | Snapshot logging is disabled, expired, purged, or not implemented for execution yet. | Review rollback snapshot mode and retention settings. |
| Policy blocks the request | No matching allow policy exists, policy is disabled, or decision is Block. | Review table-level and field-level policies. |
| Retention log shows a failure | Retention registration or cleanup had an issue. | Review sanitized error and validate retention policy setup. |

## Safe Support Evidence

When escalating an issue, share only non-sensitive information unless policy explicitly allows more.

Safe evidence usually includes:

- environment label,
- company name when allowed,
- extension version,
- request ID,
- line number,
- table ID,
- field ID,
- operation,
- result,
- sanitized error,
- policy decision,
- rollback snapshot mode,
- retention category,
- timestamp.

Do not share:

- credentials,
- secrets,
- full customer values,
- full posted document values,
- hidden sensitive field values,
- rollback before-images,
- unredacted screenshots containing sensitive business data.

## Sandbox Validation Checklist

Use this checklist before opening any later readiness gate.

| Check | Expected Result |
| --- | --- |
| `SUPER` user selects `BC Data Agent` profile | BCDA Role Center opens and links to available foundation tools. |
| `SUPER` user opens BCDA pages | Pages open. |
| Non-`SUPER` user opens BCDA pages | Access is denied. |
| Setup opens first time | Setup record exists with defaults. |
| Retention registration action runs | Success message appears. |
| Data policy can be created | Review stamps are populated. |
| Request can be created and initialized | Request has defaults and audit entry exists. |
| Request without reason or ticket is submitted | Action is blocked. |
| Request is marked previewed | Status changes and warning audit entry exists. |
| Request is submitted for approval | Status becomes `Pending Approval`. |
| Request with approval disabled is submitted or approved | Approval action is unavailable or blocked because approval is not required. |
| Same user tries to approve while separate approver is required | Approval is blocked. |
| Same user tries to approve while separate approver is not required | Status becomes `Approved`. |
| Different `SUPER` approves | Status becomes `Approved`. |
| Execute is attempted | Blocked audit entry is written and target data is not changed. |
| Audit entries page opens read-only | Entries are visible and not editable. |
| Retention logs page opens read-only | Logs are visible and not editable. |

## Quick Reference

| Task | Page | Action Or Field |
| --- | --- | --- |
| Open BCDA hub | BCDA Role Center | Select `BC Data Agent` profile |
| Configure defaults | BCDA Setup | General, Rollback, Retention FastTabs |
| Register retention support | BCDA Setup | Register Retention Tables |
| Add policy | BCDA Data Policies | New policy or policy card |
| Create request | BCDA Correction Requests | New |
| Apply request defaults | BCDA Correction Request Card | Initialize |
| Add target field change | BCDA Correction Request Card | Lines part |
| Record foundation preview | BCDA Correction Request Card | Mark Previewed |
| Submit approval request | BCDA Correction Request Card | Submit For Approval |
| Approve request | BCDA Correction Request Card | Approve |
| Verify mutation gate | BCDA Correction Request Card | Execute |
| Review evidence | BCDA Audit Entries | Read-only list |
| Review retention evidence | BCDA Retention Logs | Read-only list |

## Glossary

| Term | Meaning |
| --- | --- |
| Audit metadata | Required operation evidence such as user, time, request, target, result, reason, and ticket. |
| Break-glass operation | Exceptional, high-risk action used only when normal business processes are insufficient. |
| Correction line | One proposed field-level data change in a correction request. |
| Correction request | Header record that groups reason, ticket, approval, rollback, retention, and correction lines. |
| Data policy | Rule that blocks, allows, or requires approval for a table or field. |
| Foundation build | Current implementation stage that supports app-owned records and pages but blocks target mutation. |
| Posted data | Business Central data related to posted documents or posting outcomes. Treat as high-risk. |
| Record key | Text representation of the target record identity. |
| Retention | Rules controlling how long app-owned audit, snapshot, and technical records are kept. |
| Rollback | Future governed action that restores a prior value from retained snapshots. |
| Rollback snapshot | Stored before-image or value data used for rollback. |
| `SUPER` | Standard Business Central permission set required for all BCDA functionality. |

## Final User Rule

If a correction feels routine, use standard Business Central functionality. If a correction affects posted, hidden, financial, or sensitive data, slow down, confirm policy, confirm approval, confirm rollback availability, and make sure the audit trail tells the full story.
