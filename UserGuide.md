# BC Data Agent User Guide

## Document Status

This guide explains how to use BC Data Agent from a user and administrator point of view.

Current implementation status: Phase 9 local hardening is complete for the current Phase 8 build. The SDD now allows continuous local implementation without per-phase paper confirmation, while production/runtime use still requires controls and validation evidence. The `BC Data Agent` profile and BCDA Role Center provide navigation, and setup, policy, correction request, correction line, audit entry, rollback operation, retention log, and other shell pages are `SUPER`-gated. Limited RecordId target selection, selected-field current value refresh, request-level staged-line preview, policy preview, read-only preview matrix behavior, `Allow Data Policies`, supported grouped `Update` execution, request-level rollback staging for completed `Update` requests, filtered audit metadata export, governed retention cleanup, and local hardening evidence are open for sandbox validation. Validate-trigger dry-run, non-update execution, non-update rollback, conflict override, unfiltered export, unredacted export, snapshot payload export, and external APIs are not enabled at runtime.

Sandbox validation was skipped by request for the Phase 8 implementation pass. Phase 9 completed local hardening only; do not use execution, rollback, export, or cleanup in production until sandbox validation and export-handling rules are complete.

Use this guide in two ways:

- For the current build, follow the sandbox validation and administration steps that are marked as available now.
- For the planned full workflow, use the future sections as the operating model that later implementation work can build and validate before runtime or production use.

## Product Purpose

BC Data Agent is a Business Central extension for exceptional data correction work. It is intended for controlled support scenarios where standard Business Central correction tools are not enough.

The app is not a casual table editor. It is a break-glass workflow for authorized `SUPER` users who need to prepare, approve, audit, and later roll back carefully governed changes to Business Central data, including hidden or posted data when policy explicitly allows it.

## Most Important Safety Rules

1. Use normal Business Central correction flows first, such as reversals, credit memos, journals, or assisted setup.
2. Use BC Data Agent only for exceptional support or recovery cases.
3. All users must already have the standard Business Central `SUPER` permission set.
4. Do not create, assign, or expect BCDA-specific permission sets.
5. Every request must have a business reason before preview, approval, or execution. A ticket/reference is required only when the request says `Ticket Reference Required`.
6. Posted data and high-risk data must be treated as break-glass work.
7. Approval is configurable. Use a separate approver for higher-risk companies, disable approval only for accepted standard-request workflows, and allow self-approval only when the business accepts that control model.
8. Audit metadata is mandatory.
9. Rollback snapshot logging is configurable, but if snapshots are disabled, rollback will be unavailable.
10. Retention settings control how long app-owned operation records remain available.
11. In the current build, only grouped `Update` execution and request-level rollback staging for completed `Update` requests are enabled; `Rename`, `Delete`, and `Insert` execution and rollback are audited or blocked.
12. Audit export is filtered metadata only. It omits target values, target record identity text, and rollback snapshot payloads.
13. Retention cleanup must be run only after reviewing retention settings because expired eligible BCDA-owned operation records can be purged or deleted.

## Who Should Use This Guide

| User | Typical Responsibility |
| --- | --- |
| `SUPER` Administrator | Configure setup, retention, rollback defaults, and policies. |
| `SUPER` Support User | Create correction requests and add correction lines. |
| `SUPER` Approver | Review and approve high-risk or approval-required requests when the setup requires approval. |
| `SUPER` Reviewer | Review audit entries, retention logs, and support evidence. |
| Technical Lead | Validate sandbox behavior before runtime or production enablement. |

## Current Capability Map

| Area | Available Now | What You Can Do | Current Boundary |
| --- | --- | --- | --- |
| Profile and Role Center | Yes | Select the `BC Data Agent` role/profile and open available foundation tools from one hub. | The profile is navigation only; linked BCDA pages still require the existing `SUPER` permission set. |
| Access control | Yes | Open BCDA pages only as a `SUPER` user. | Non-`SUPER` access must be denied by runtime checks. |
| Setup | Yes | Configure default policy, preview, rollback, retention, export flag, retention registration, and cleanup. | Run cleanup only after reviewing retention settings. |
| Data policies | Yes | Maintain table and field policy records and configure whether policy records participate through `Allow Data Policies`. | When `Allow Data Policies` is off, policy records are bypassed, but BCDA app-owned tables, unsupported fields, non-`SUPER` access, metadata, audit, and rollback controls still apply. |
| Correction requests | Yes | Create request headers, apply setup defaults, preview staged lines, execute supported grouped updates, and manage request state. | Preview is non-mutating; execution is limited to supported grouped `Update` lines. |
| Correction lines | Partial | Stage a correction type, use lookup suggestions for target table and field, use `Select Record` to select a target record ID when applicable, review the selected field's current value, enter proposed value text, and open `Preview Data Matrix` to review staged line data. | Current value preview and the matrix use stored correction-line data only; `Insert` keeps `Record ID` empty; `Rename`, `Delete`, and `Insert` execution are still blocked. |
| Batch line builder | Yes | Create same-table correction lines from selected target records, fields, proposed values, and rollback/validation settings. | No target data is changed by batch creation; unsupported runtime operation types still follow the normal execution gates. |
| Approval | Yes | Submit and approve requests only when approval is required, with configurable separate-approver or self-approval behavior. | Full policy-driven approval workflow is still future hardening. |
| Execution | Yes, limited | Execute supported grouped `Update` corrections after metadata, preview, approval/policy, and rollback snapshot checks pass. | The request is applied as one transaction; unsupported operation types are blocked before mutation. |
| Audit entries | Yes | Review append-only audit evidence and export filtered metadata when export is enabled and filters are applied. | Export omits target values, target record identity text, and rollback snapshot payloads. |
| Retention logs | Yes | Review retention log records and cleanup evidence. | Cleanup touches only expired eligible BCDA-owned operation records, not target Business Central business data. |
| Rollback | Yes, limited | Create a new rollback correction request from a completed `Update` request when retained before-image snapshots exist for every executed supported line. | The rollback action itself does not change target data; the generated request must be previewed, approved if required, and executed. |

## Opening BC Data Agent

For the most convenient entry point, switch to the `BC Data Agent` role/profile from My Settings. This opens the BCDA Role Center with links to the currently available foundation tools.

You can also use Business Central search, often called Tell Me, to find these pages:

| Search For | Page | Use |
| --- | --- | --- |
| `BCDA Setup` | BCDA Setup | Global configuration, rollback defaults, retention, and retention registration. |
| `BCDA Data Policies` | BCDA Data Policies | Maintain allowed, blocked, or approval-required targets. |
| `BCDA Correction Requests` | BCDA Correction Requests | Create and manage correction request work. |
| `BCDA Audit Entries` | BCDA Audit Entries | Review operation evidence. |
| `BCDA Rollback Operations` | BCDA Rollback Operations | Review rollback operation evidence. |
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
15. Run `Execute` only on artificial sandbox data for supported grouped `Update` lines.
16. Enable audit export only for artificial sandbox data, apply a required audit filter, and verify the CSV omits protected value content.
17. Run retention cleanup only on artificial sandbox BCDA operation records and verify active requests and retained rollback dependencies are protected.

## Setup Page Guide

### General FastTab

| Field | Meaning | Recommended Starting Value |
| --- | --- | --- |
| Environment Label | Text shown to help users recognize where they are working. | Use a plain label such as `Sandbox`, `UAT`, or `Production - Restricted`. |
| Default Policy Decision | Decision used when no matching table or field policy exists. | `Block`. |
| Allow Data Policies | Whether BCDA data policy records participate in preview and execution decisions. | Enabled. Turn off only when the business accepts bypassing policy records while preserving permanent runtime controls. |
| Require Ticket Reference | Whether new requests require a ticket/reference before preview, approval, or execution. | Disabled for paperless standard updates; enabled when company policy requires an external case, ticket, or approval reference. |
| Approval Required Default | Whether requests require approval by default. | Enabled for dual control; disabled for owner-operated companies that accept a documented reason-only standard workflow. |
| Require Separate Approver | Whether approval must be performed by a different `SUPER` user when approval is required. | Enabled for safer default; disabled only when one `SUPER` user must perform the whole workflow. |
| Require Preview | Whether a request must be previewed before execution. | Enabled. |

When `Allow Data Policies` is off, BCDA does not require a matching data policy record. This does not bypass `SUPER`, request metadata, audit, rollback snapshot, field eligibility, or BCDA app-owned table blocks.

### Rollback FastTab

| Field | Meaning | Recommended Starting Value |
| --- | --- | --- |
| Rollback Snapshot Default | Default behavior for rollback before-image snapshots. | `Required` for posted or high-risk work, `Enabled` for normal governed work. |

Rollback snapshot modes:

| Mode | Meaning | User Impact |
| --- | --- | --- |
| Policy Controlled | Resolve behavior from setup and data policy. | Best when policy rules are mature. |
| Enabled | Store rollback snapshots for supported execution. | Request-level rollback staging can be available later while snapshots are retained. |
| Disabled | Do not store rollback snapshots. | Rollback will be unavailable. Audit metadata still remains mandatory. |
| Required | Execution should require rollback snapshot capture. | Safer default for posted and high-risk targets. |

### Retention FastTab

| Field | Meaning | Default In Foundation Tables |
| --- | --- | --- |
| Audit Retention Days | How long audit metadata should remain. | `3650` days. |
| Snapshot Retention Days | How long rollback snapshots should remain. | `90` days. |
| Technical Log Retention Days | How long technical logs should remain. | `30` days. |
| Export Enabled | Allows filtered audit metadata export from `BCDA Audit Entries`. | Disabled unless export policy is approved. |

Retention guidance:

- Keep audit retention long enough for support, compliance, and internal review.
- Keep snapshot retention long enough for the expected correction review window.
- Do not set retention to `0` unless your business has explicitly accepted immediate or near-immediate cleanup semantics in the implemented cleanup process.
- Remember that expired or purged rollback snapshots make rollback unavailable.
- Use `Run Retention Cleanup` only after reviewing the retention periods. Cleanup purges expired snapshot payloads and deletes expired eligible BCDA-owned operation records.

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
- rollback operations,
- retention logs.

The action is safe to run during setup validation. It does not modify target Business Central business data.

## Data Policy Guide

Data policies define which target tables and fields are blocked, allowed, or require approval.

Policy records can be maintained, non-mutating request preview evaluates policy for staged lines, and supported grouped update execution re-checks policy immediately before mutation unless `Allow Data Policies` is off.

BC Data Agent app-owned tables are permanently blocked as correction targets and data policy targets. This prevents the tool from editing its own setup, policy, audit, snapshot, rollback, retention, or request records through the correction workflow.

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
| Table ID | Target Business Central table ID. Use lookup to select a table from metadata. |
| Table Name | Human-readable target table name, filled from metadata. |
| Field ID | Target field ID, or `0` for a table-level policy. Use lookup after selecting `Table ID`. |
| Field Name | Human-readable target field name, filled from metadata. |
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

- `Table ID`: Business Central table number, selected from metadata.
- `Table Name`: table caption or name, filled automatically.
- `Field ID`: Business Central field number selected from enabled normal fields for the table, or `0` for table-level policy.
- `Field Name`: field caption or name, filled automatically.
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
| Low | Low operational impact. | Still audit and require a reason; require a ticket/reference only when configured. |
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

In the current build, you can create and move requests through workflow states, preview staged target values without mutation, and execute supported grouped `Update` corrections after required controls pass.

### Request List

Open `BCDA Correction Requests` to see existing requests.

Important columns:

| Column | Meaning |
| --- | --- |
| Request ID | Unique request identifier. |
| Status | Current workflow state. |
| Ticket Reference | External support ticket, incident, case, or approval reference when one exists or is required. |
| Ticket Reference Required | Whether this request requires a ticket/reference before preview, approval, or execution. |
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
- `Ticket Reference`: external reference when one exists or is required.
- `Ticket Reference Required`: setup-derived flag that shows whether the reference is required for this request.
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
- `Last Preview At`: non-mutating request preview timestamp.
- `Rollback Availability`: current rollback message.
- `Retention Impact`: current retention summary.

### Correction Lines

Each correction line represents one staged correction operation or operation field value.

Set `Type` to `Update`, `Rename`, `Delete`, or `Insert`. `Update`, `Rename`, and `Delete` use a canonical existing `Record ID`. `Insert` keeps `Record ID` empty by design, and the target record lookup is blocked for insert lines because there is no existing target record yet.

Current builds expose `Record ID` as read-only app-owned storage when an existing target record is applicable. It is not typed manually. After selecting `Table ID`, use either the `Record ID` assist edit button or the line action `Select Record` to open `BCDA Target Record Lookup`, choose a record by its primary-key display values, and populate the canonical `RecordId`.

The foundation lookup reads the selected table's primary-key fields for selection. After both `Record ID` and `Field ID` are selected on an existing-record line, the app reads that selected field and fills `Current Value Preview`. When you enter `Proposed New Value`, the app checks that the field is an enabled normal stored field, is not system-managed or removed, uses a supported foundation scalar type, and that the text can be parsed for that field type. Primary-key values are blocked for `Update`, but may be staged for future `Rename` and `Insert` execution. Execution changes Business Central data only for supported grouped `Update` lines. The richer matrix-style selector, similar to Business Central's Dimension Matrix pattern, is still planned for staging multiple field changes for the selected record.

Use `Preview Data Matrix` on the correction lines part to open a read-only temporary matrix of the staged lines for the current request. For each correction type and table, the matrix shows a heading row with the unique fields staged for that table, then one `Current` row and one `New` row for each target record. It does not read additional target data and does not execute a full dry-run.

| Field | Meaning |
| --- | --- |
| Line No. | Line identifier, automatically assigned in increments. |
| Type | Staged operation type: `Update`, `Rename`, `Delete`, or `Insert`. Phase 6 executes grouped `Update` lines and audits other operation types as blocked. |
| Table ID | Target table number. Use lookup to select a Business Central table from metadata. |
| Table Name | Target table name or caption. Filled from the selected table metadata. |
| Record ID | Canonical target record identity for existing-record operations. Read-only; use the field assist edit button or the `Select Record` line action to select a record from the current table. This remains empty for `Insert`. |
| Field ID | Target field number. Use lookup after selecting `Table ID`; the list is filtered to enabled normal fields for that table. |
| Field Name | Target field name or caption. Filled from the selected field metadata. |
| Proposed New Value | New value text to apply for supported `Update` execution or to stage for a future operation type. The current build validates required record/field selection, field staging eligibility, text/code length, and supported scalar type compatibility before saving the line value. |
| Current Value Preview | Current value for the selected `Record ID` and `Field ID`. Filled automatically when both are selected. |
| Rollback Snapshot Mode | Line-level rollback snapshot mode. |
| Validation Mode | Line-level validation behavior. |
| Line Status | Current line state. |
| Sanitized Error | Non-sensitive error details. |

### Batch Add Lines

`Batch Add Lines` opens a same-table worksheet that creates normal correction lines from selected target records and fields.

Use it when several lines belong to the same target table:

1. Select one `Table ID` for the batch.
2. Add one batch entry per requested field change or record-level delete staging row.
3. For `Update`, `Rename`, or `Delete`, use `Select Record` to populate the target `Record ID`.
4. For `Update`, `Rename`, or `Insert`, use field lookup and enter the proposed value.
5. Choose rollback snapshot mode and validation mode when needed.
6. Choose `Create Request Lines`.

The app creates normal `BCDA Correction Line` records. The batch builder does not introduce a separate execution path.

### Required Request Metadata

Before preview, approval, or execution actions, enter:

- `Reason`,
- `Ticket Reference` only when `Ticket Reference Required` is on.

If required metadata is missing, the app stops the action with this error:

```text
Reason is required before this action. Ticket/reference is required only when the request requires it.
```

### Foundation Request Actions

| Action | Available Now | What It Does |
| --- | --- | --- |
| Initialize | Yes | Applies setup defaults, saves the request, and writes request-created audit evidence. |
| Batch Add Lines | Yes for open or previewed requests | Opens same-table batch entry and creates normal correction lines from selected records and fields. |
| Preview Data Matrix | Yes from correction lines | Opens a read-only temporary matrix with field columns and `Current`/`New` rows for each staged target record in the current request. |
| Preview Request | Yes while the request is open or previewed | Runs non-mutating preview, refreshes selected current values, validates staged line shape and proposed values, evaluates policy, updates line statuses/sanitized messages, updates rollback/retention text, and writes preview audit evidence. |
| Submit For Approval | Yes when approval is required and the request is not already pending or approved | Sets status to `Pending Approval` after required metadata exists and required preview lines are previewed. |
| Approve | Yes when approval is required and the request is pending approval | Approves the request after required preview lines are still previewed. The requester can approve only when separate approver is not required. |
| Execute | Yes for supported states | Executes grouped `Update` lines as one request transaction after metadata, preview, approval/policy, `SUPER`, audit, and rollback snapshot checks pass. Unsupported operation types are blocked before mutation. |
| Rollback | Yes from completed requests | Creates a new rollback correction request with suggested inverse `Update` lines from retained before-images. No target data changes until the generated request is previewed, approved if required, and executed. |

### Request Statuses

| Status | Meaning |
| --- | --- |
| Open | Request is being prepared. |
| Pending Approval | Request was submitted for approval. |
| Approved | Request was approved by a `SUPER` user according to the request approval settings. |
| Rejected | Planned rejected state. |
| Previewed | Non-mutating request preview completed. |
| Executing | Execution in progress. |
| Completed | Execution completed successfully. |
| Failed | Request validation failed before mutation, or execution did not complete. Target data is not partially updated by a failed request. |
| Cancelled | Planned cancelled state. |

### Line Statuses

| Status | Meaning |
| --- | --- |
| Open | Line is being prepared. |
| Previewed | Non-mutating line preview completed. |
| Approved | Future line approval completed. |
| Executed | Line execution completed. |
| Failed | Line preview or execution failed. |
| Rollback Pending | Rollback requested but not completed. |
| Rolled Back | Rollback completed. |

## Current Foundation Workflow

Use this workflow to validate the current build in a sandbox.

1. If desired, switch to the `BC Data Agent` role/profile and use the BCDA Role Center links for the foundation pages.
2. Open `BCDA Setup`.
3. Confirm setup defaults and retention values.
4. Run `Register Retention Tables`.
5. Open `BCDA Data Policies`.
6. Create a safe sandbox policy.
7. Open `BCDA Correction Requests`.
8. Create a new request.
9. Enter `Reason`, `Company Name`, and `Risk Level`; enter `Ticket Reference` when the request requires it or when you want that evidence retained.
10. Use `Initialize`.
11. Add one correction line, choose `Type`, select the target table, use `Record ID` assist edit or `Select Record` on the line to choose the target record when the type is not `Insert`, and use field lookup to select field metadata when applicable.
12. Use `Preview Data Matrix` on the lines part to review the staged line data for the request.
13. Optionally use `Batch Add Lines` to create multiple same-table correction lines from selected records and fields.
14. Use `Preview Request`.
15. Use `Submit For Approval` if approval is required.
16. If `Require Separate Approver` is enabled, sign in or switch to a different `SUPER` user.
17. If approval is required, open the request and use `Approve`.
18. Use `Execute` for supported grouped `Update` lines only.
19. Open `BCDA Audit Entries`.
20. Confirm audit entries exist for request creation, preview, approval where applicable, and execution.
21. If the completed request needs reversal and rollback snapshots are retained, use `Rollback` from the completed correction request only on artificial sandbox data.
22. Review the generated rollback correction request, run `Preview Request`, and execute it only through the same governed workflow when appropriate.
23. Open `BCDA Rollback Operations` and confirm the generated rollback request is linked to the completed source request.
24. Open `BCDA Retention Logs` if retention registration or cleanup validation produced log entries.

If any line uses `Rename`, `Delete`, or `Insert`, execution is blocked before mutation and target Business Central data remains unchanged for the request.

## Planned Full Correction Workflow

This section describes the intended user experience after future implementation and validation enable richer target-matrix preview and non-update operation behavior at runtime. Execution is currently available only for grouped `Update` requests, rollback currently creates a new correction request from a completed supported `Update` request, and export is filtered audit metadata only.

1. A `SUPER` support user creates a correction request.
2. The user enters reason, any setup- or policy-required ticket/reference, company, and target table.
3. The user selects the target record, then uses the planned matrix selector to stage field changes for the resolved `RecordId`.
4. The app evaluates setup and data policy.
5. The user runs preview.
6. Preview shows current value, proposed value, validation mode, rollback snapshot mode, retention period, warnings, and rollback availability.
7. A `SUPER` user approves if policy requires approval. The approver must be a different user only when the request requires separate approval.
8. The user executes the approved request.
9. The app re-checks policy and access before mutation.
10. The app captures before-image snapshots when rollback snapshot logging is enabled or required.
11. The app writes target field changes as one request transaction only if Business Central platform behavior allows the whole request.
12. The app writes audit evidence for success, failure, or blocked result.
13. A reviewer validates audit evidence.
14. If the correction was wrong, a `SUPER` user starts rollback from the completed correction request while snapshots are retained.
15. The app creates a new rollback correction request with suggested inverse values for review.
16. The generated request is previewed, approved if required, and executed through the normal all-or-nothing workflow.

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
- ticket/reference when provided or required,
- operation,
- result,
- sanitized error.

### Rollback Snapshots

Rollback snapshots are before-image and value records that supported rollback uses to stage prior values in a generated rollback correction request.

If rollback snapshots are disabled:

- audit metadata still exists,
- rollback is unavailable,
- the user must understand the consequence before execution.

If rollback snapshots expire or are purged:

- audit metadata may still exist,
- rollback material is gone,
- rollback must be blocked or escalated outside BCDA.

### Creating A Rollback Request

Supported rollback starts from a completed correction request.

1. Open the completed source request in `BCDA Correction Request Card`.
2. Confirm all source lines are supported `Update` lines with retained rollback snapshots.
3. Choose `Rollback`.
4. Confirm the prompt.
5. Review the generated rollback correction request.
6. Run `Preview Request` on the generated request before approval or execution.
7. Review the resulting rollback audit entry and `BCDA Rollback Operations` record.

Rollback request creation succeeds only when:

- the source request is completed,
- every source line is a supported executed `Update` line,
- old value snapshots still exist, are not purged, and are not expired,
- the user is `SUPER`,
- no active or completed rollback request already exists for the source request.

The rollback action itself never changes target data. The generated request must pass preview, policy, approval when required, execution, audit, and all-or-nothing transaction controls before any target data changes.

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
| Operation | Request Created, Preview, Approval, Execution, Rollback, Retention Cleanup, Policy Change, Setup Change, or Audit Export. |
| Result | Success, Failed, Blocked, or Warning. |
| Request ID | Related correction request. |
| Line No. | Related correction line when available. |
| User ID | User who caused the audit entry. |
| Occurred At | Date and time of the audit event. |
| Company Name | Company context. |
| Target Table ID | Target table number. |
| Target Field ID | Target field number. |
| Rollback Available | Whether rollback material is linked for request-level rollback staging. |
| Sanitized Error | Non-sensitive error or status detail. |

Audit entries are append-only during operations. Request-level rollback creation and generated rollback request execution create new audit entries rather than erasing original evidence. Governed retention may later remove expired app-owned operation records according to configured retention policy.

The audit page does not provide rollback actions. Use `Rollback` from the completed correction request.

### Exporting Filtered Audit Metadata

Use `Export Filtered Metadata` on `BCDA Audit Entries` only after `Export Enabled` is turned on in `BCDA Setup`.

The export requires at least one filter:

- Request ID,
- Company Name,
- Occurred At,
- Operation,
- Result.

The CSV includes audit metadata such as entry number, operation, result, request, line, user, timestamp, company, table/field IDs, reason, ticket, rollback availability, snapshot references, error code, and sanitized error. It does not include target values, target record identity text, or rollback snapshot payload values.

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
| Deleted Count | Number of records removed or snapshot payloads purged. |
| Result | Success, Failed, Blocked, or Warning. |
| Sanitized Error | Non-sensitive details. |
| Created By | User who created the retention log entry. |
| Created At | Date and time the log entry was created. |

### Running Retention Cleanup

Run retention cleanup from `BCDA Setup` with the `Run Retention Cleanup` action.

Cleanup:

- purges expired rollback snapshot payloads,
- deletes expired eligible audit metadata,
- deletes expired eligible rollback operation records only after linked active requests and retained dependencies are protected,
- deletes expired retention logs without deleting cleanup evidence created in the same run,
- protects active requests, pending approvals, incomplete execution, and retained rollback dependencies,
- never changes target Business Central business records.

Review `BCDA Retention Logs` after every cleanup run.

## Approval Rules For Users

Approval is configurable so the same app can support both larger companies with dual control and small owner-operated companies where one `SUPER` user must perform the whole workflow.

| Setup | Result |
| --- | --- |
| `Approval Required Default` off | New requests do not require approval by default. The user can continue after preview and policy checks when executing supported updates. |
| `Approval Required Default` on and `Require Separate Approver` on | Approval is required and the approving user must be different from the requester. This is the safest default for high-risk work. |
| `Approval Required Default` on and `Require Separate Approver` off | Approval is required, but the requester can self-approve. Use this for one-person companies only when the business accepts the risk. |

The request stores `Approval Required` and `Require Separate Approver` when setup defaults are applied, so reviewers can see which approval model was used. When approval is disabled, separate approval is cleared on the request and the approval actions are not needed.

If separate approval is required and the requester tries to approve their own request, the app shows:

```text
A different SUPER user must approve this BC Data Agent request because separate approval is required.
```

Approval can be recorded only after `Submit For Approval` has moved the request to `Pending Approval`. If an approval is attempted too early, the app shows:

```text
Submit the request for approval before approving it.
```

Recommended approval practice:

- The requester documents the issue and proposed correction.
- The approver confirms the posted or high-risk scenario is covered by the company control process.
- The approver checks rollback snapshot mode and retention impact.
- The approver confirms the request is in the correct company and environment.
- The approver confirms the target is covered by policy.
- If approval is disabled or self-approval is enabled, the same `SUPER` user must still document the reason, any required or provided ticket/reference, rollback impact, and policy decision clearly enough for later review.

## Working With Posted Or Hidden Data

Posted and hidden data can affect financial reporting, inventory, audit trails, customer history, and legal records.

Before allowing posted or hidden data:

1. Confirm standard Business Central correction flows are not sufficient.
2. Confirm the scenario is documented in a support ticket or change request.
3. Confirm the company control process covers the posted or hidden data scenario.
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
- delete or rewrite audit history outside governed retention cleanup,
- store credentials or secrets in request text,
- paste sensitive customer data into external chats or generic logs,
- export target values, target record identity text, or rollback snapshot payloads,
- execute production corrections before sandbox validation and runtime readiness approval.

## Troubleshooting

| Symptom | Likely Cause | What To Check |
| --- | --- | --- |
| User cannot open BCDA pages | User is not recognized as `SUPER`. | Confirm the standard Business Central `SUPER` permission set is assigned. |
| Setup page opens but values are blank | Setup was not initialized or page did not refresh. | Reopen `BCDA Setup`; setup should be created automatically. |
| Preview, approval, or execution action fails for missing metadata | Reason is blank, or `Ticket Reference Required` is on and the ticket/reference is blank. | Enter the reason and, when required, the ticket/reference on the request card. |
| Preview Request is blocked | The request is no longer open or previewed, required metadata is missing, or staged lines are invalid. | Preview must be completed before approval workflow advances the request when preview is required. Review line statuses and sanitized errors. |
| Requester cannot approve their own request | `Require Separate Approver` is enabled for the request. | Use a different `SUPER` user, or change setup for future requests if the company accepts self-approval. |
| Approval actions are unavailable | `Approval Required` is off, the request is already pending approval, or the request is already approved. | Continue with the next allowed workflow step, or change setup/future request defaults if approval should be required. |
| Execute action is disabled | The request is not in an executable state, required preview is missing, approval is missing, or execution already completed/failed. | Review request status, preview requirement, approval settings, and line statuses. |
| Field ID lookup is empty | No table is selected, or the selected table has no enabled normal fields available through metadata. | Select `Table ID` first and confirm the target field is an enabled normal stored field. |
| Table ID is rejected | The table is owned by BC Data Agent or is otherwise outside the current foundation target rules. | Choose a Business Central business table that is not part of the BCDA app-owned operation data. |
| Batch line creation fails | A batch table is missing, no batch entries exist, a non-insert entry has no target record, or a non-delete entry has no field. | Select a batch table, use `Select Record` for existing-record line types, select field metadata where applicable, and then create request lines. |
| Record ID is blank | No target record has been selected, or the selected table has no records available in the foundation lookup. | Select `Table ID`, then use `Record ID` assist edit or the `Select Record` line action. |
| Record ID lookup is blocked | The line type is `Insert`. | Leave `Record ID` empty for insert staging. Future insert execution must create the record without using an input target `RecordId`. |
| Current Value Preview is blank | `Record ID` or `Field ID` is blank, the selected record no longer exists, or the selected field cannot be formatted for preview. | Use `Record ID` assist edit or `Select Record`, choose `Field ID` again, then review any error shown by the line. |
| Proposed New Value is rejected | The target record or field is missing, the field is disabled, non-normal, primary-key, system-managed, removed, unsupported for staging/execution, too long for the field, or the text cannot be parsed as the field type. | Select a valid target record and enabled normal non-primary-key field, then enter a value formatted for that field type. |
| Rollback action is unavailable | The request is not completed, rollback snapshots are unavailable, or a rollback request already exists for the completed source request. | Open the completed correction request and review rollback availability, line statuses, and existing rollback operations. |
| Rollback request creation is blocked | Snapshot logging is disabled, expired, purged, a source line is not an executed `Update`, or retained before-images are missing for part of the request. | Review rollback operation evidence, snapshot retention, and whether the completed request is fully eligible for request-level rollback staging. |
| Audit export is blocked | Export is disabled or no required filter is applied. | Turn on `Export Enabled` only when approved, then filter by request, company, occurred-at date/time, operation, or result. |
| Audit export omits target values | Phase 8 export is metadata-only by design. | Review audit metadata and use authorized BCDA pages for privileged value review. Do not expect snapshot payloads in CSV export. |
| Policy blocks the request | No matching allow policy exists, policy is disabled, or decision is Block. | Review table-level and field-level policies. |
| Need to modify without policy records | `Allow Data Policies` is enabled. | Turn `Allow Data Policies` off only when the business accepts bypassing policy records while preserving permanent runtime controls. |
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

Use this checklist before enabling any later runtime behavior.

| Check | Expected Result |
| --- | --- |
| `SUPER` user selects `BC Data Agent` profile | BCDA Role Center opens and links to available foundation tools. |
| `SUPER` user opens BCDA pages | Pages open. |
| Non-`SUPER` user opens BCDA pages | Access is denied. |
| Setup opens first time | Setup record exists with defaults. |
| Retention registration action runs | Success message appears. |
| Data policy can be created | Table/field lookup fills metadata names and review stamps are populated. |
| Request can be created and initialized | Request has defaults and audit entry exists. |
| Correction line table lookup is used | `Table Name` is filled from metadata. |
| Record ID assist edit or Select Record is used | Target record lookup opens, primary-key display values are shown, selecting a row fills `Record ID`, selecting `Field ID` fills `Current Value Preview`, and no target data is changed. |
| Planned RecordId matrix selector is evaluated in sandbox | Simple and composite primary keys resolve to a canonical target record identity without hand-entered key parsing, and target value reads stay limited to the approved non-mutating preview scope. |
| Correction line field lookup is used after table selection | The field list is filtered by table and `Field Name` is filled from metadata. |
| Proposed New Value is entered | Supported scalar values are accepted, unsupported field types and non-modifiable foundation fields are blocked, type mismatch errors do not echo the proposed value, and no target data is changed. |
| Preview Data Matrix is opened | A read-only temporary matrix opens for the current request, shows one table section at a time with unique field columns and `Current`/`New` rows per record, and no target data is changed. |
| Batch Add Lines is checked | Same-table batch entries select canonical target RecordIds, create standard correction lines, and do not mutate target data. |
| Request without a reason, or without a configured-required ticket/reference, is submitted | Action is blocked. |
| Request preview is run | Status changes to `Previewed`, correction lines are marked `Previewed` or `Failed`, and preview audit entry exists. |
| Request is submitted for approval | Status becomes `Pending Approval`. |
| Approval is attempted before submit | Action is unavailable or blocked with a submit-first message. |
| Request with approval disabled is submitted or approved | Approval action is unavailable or blocked because approval is not required. |
| Same user tries to approve while separate approver is required | Approval is blocked. |
| Same user tries to approve while separate approver is not required | Status becomes `Approved`. |
| Different `SUPER` approves | Status becomes `Approved`. |
| Execute action is checked | Action is enabled only for supported executable request states; grouped `Update` execution writes audit evidence, updates line statuses, and applies the request as one transaction. |
| Audit entries page opens read-only | Entries are visible and not editable. |
| Supported rollback is created from a completed request | A completed `Update` request creates a new rollback correction request only when retained before-image snapshots exist for every executed supported line; rollback audit evidence and a rollback operation record are written. |
| Generated rollback request is previewed | The generated rollback correction request shows current target values and proposed retained before-images before any target mutation. |
| Filtered audit metadata export is tested | Export is blocked until `Export Enabled` is on and at least one required filter is applied; exported CSV omits target values, target record identity text, and snapshot payloads. |
| Retention cleanup is run | Expired rollback snapshot payloads are purged, expired eligible operation records are deleted, active requests and retained rollback dependencies are protected, and retention log evidence is written. |
| Retention logs page opens read-only | Logs are visible and not editable. |

## Quick Reference

| Task | Page | Action Or Field |
| --- | --- | --- |
| Open BCDA hub | BCDA Role Center | Select `BC Data Agent` profile |
| Configure defaults | BCDA Setup | General, Rollback, Retention FastTabs |
| Register retention support | BCDA Setup | Register Retention Tables |
| Run retention cleanup | BCDA Setup | Run Retention Cleanup |
| Add policy | BCDA Data Policies | New policy or policy card |
| Create request | BCDA Correction Requests | New |
| Apply request defaults | BCDA Correction Request Card | Initialize |
| Add target field change | BCDA Correction Request Card | Lines part, using Table ID and Field ID lookup suggestions |
| Add multiple same-table changes | BCDA Correction Request Card | Use `Batch Add Lines` for same-table entries; use future matrix editing for richer field staging. |
| Run request preview | BCDA Correction Request Card | Preview Request |
| Submit approval request | BCDA Correction Request Card | Submit For Approval |
| Approve request | BCDA Correction Request Card | Approve |
| Execute supported update | BCDA Correction Request Card | Execute |
| Review evidence | BCDA Audit Entries | Read-only list |
| Export filtered audit metadata | BCDA Audit Entries | Export Filtered Metadata |
| Create rollback request | BCDA Correction Request Card | Rollback |
| Review rollback operations | BCDA Rollback Operations | Read-only list |
| Review retention evidence | BCDA Retention Logs | Read-only list |

## Glossary

| Term | Meaning |
| --- | --- |
| Audit metadata | Required operation evidence such as user, time, request, target, result, reason, and any provided or required ticket. |
| Break-glass operation | Exceptional, high-risk action used only when normal business processes are insufficient. |
| Correction line | One proposed field-level data change in a correction request. |
| Correction request | Header record that groups reason, optional ticket/reference, approval, rollback, retention, and correction lines. |
| Data policy | Rule that blocks, allows, or requires approval for a table or field. |
| Foundation build | Earlier implementation stage that supported app-owned records and pages before grouped update execution and supported update rollback. |
| Posted data | Business Central data related to posted documents or posting outcomes. Treat as high-risk. |
| Record ID | Canonical target record identity. In the current build it is populated from field assist edit or the `Select Record` lookup; future matrix selection will build richer field staging around it. |
| Retention | Rules controlling how long app-owned audit, snapshot, and technical records are kept. |
| Rollback | Governed action that creates a new correction request with suggested inverse values from retained snapshots for a completed supported `Update` request. |
| Rollback snapshot | Stored before-image or value data used to stage rollback correction lines. |
| `SUPER` | Standard Business Central permission set required for all BCDA functionality. |

## Final User Rule

If a correction feels routine, use standard Business Central functionality. If a correction affects posted, hidden, financial, or sensitive data, slow down, confirm policy, confirm approval, confirm rollback availability, and make sure the audit trail tells the full story.
