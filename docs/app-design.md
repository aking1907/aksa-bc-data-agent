# App Design

## Design Position

BC Data Agent should feel like a careful Business Central operations tool, not a developer utility. The user experience must make correction work efficient for `SUPER` users while continuously reminding them whether a change is safe, approved, rollback-capable, and retained.

## Microsoft Design Alignment

The design follows current Microsoft Business Central guidance:

- Pages should be chosen by the task they support and should work across web, tablet, and phone clients.
- Actions should be placed by scope and importance; task-starting and task-finishing actions get prominence, while exceptional actions are less prominent.
- Pages should simplify what users see by default, use FastTabs for structure, and use a small number of FactBoxes for supporting context.
- Error handling should be deliberate and self-explanatory, not only dependent on runtime errors.

References:

- https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-pages-overview
- https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-page-types-and-layouts
- https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-actions-user-interface
- https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-robust-coding-practices

## UX Principles

- Keep the first screen operational: request list, status, risk, rollback availability, and recent activity.
- Make dangerous actions require preview first.
- Show rollback availability before execution and after execution.
- Keep audit metadata mandatory.
- Make approval requirement, approval separation, and ticket/reference requirement configurable so the app supports both dual-control companies and paperless standard workflows.
- Make rollback snapshot logging configurable, but never silent.
- Make retention visible on setup, request preview, audit entries, and rollback pages.
- Warn clearly when rollback snapshots are disabled or expired.
- Avoid showing raw sensitive values unless policy and channel allow it.
- Let users select existing target records by primary-key display values instead of typing serialized `RecordId` or composite-key text.
- Make `Rename` visibly different from `Update`: it must show as an existing-record primary-key operation and accept only primary-key field values.
- Use Business Central-native pages, actions, FastTabs, FactBoxes, confirmation dialogs, and wizards.

## Planned Pages

| Page | Page Type | Purpose |
| --- | --- | --- |
| BCDA Role Center | RoleCenter | Home/profile entry point that groups the available BCDA foundation tools for SUPER users. |
| BCDA Setup | Card | Global safety, approval/reference evidence, rollback logging, retention, export, and environment settings. |
| BCDA Data Policies | List | Search and maintain table/field allow/block policies. |
| BCDA Data Policy Card | Card | Configure one table/field policy, risk, validation, approval, rollback logging, and retention overrides. |
| BCDA Correction Requests | List | Work queue with status, risk, target table, requester, approval state, rollback availability, and retention state. |
| BCDA Correction Request Card | Card with ListPart and FactBoxes | Main request workspace for target, reason, lines, preview, approval, execution, and audit summary. |
| BCDA Correction Lines | ListPart | Staged correction lines for a request, showing operation type, target table, read-only formatted target record identity when applicable, selected field when applicable, and proposed value when applicable. |
| BCDA Preview Data Matrix | List | Read-only temporary matrix opened from correction lines to review staged correction-line data as correction-type/table sections with unique field columns and `Current`/`New` rows per target record. It uses stored BCDA line data only and does not run full dry-run validation. |
| BCDA Batch Line Builder | Worksheet | Same-table batch entry page that collects existing target identities through simple/composite primary-key lookup, grouped insert field rows through `Insert Group No.`, fields, proposed values, and line controls, then creates standard correction lines. |
| BCDA Target Record Lookup | List | Foundation line-action lookup that displays primary-key values for the selected table, including every key part for composite keys, and returns the selected canonical `RecordId`. |
| BCDA Target Record Matrix | Worksheet or StandardDialog | Dimension Matrix-style selector/editor that opens from target record selection, resolves a target `RecordId`, and shows available field correction lines for that selected record. |
| BCDA Table Lookup | List | Helper lookup for selecting a target Business Central table from metadata. |
| BCDA Field Lookup | List | Helper lookup for selecting an enabled normal field for the selected table. |
| BCDA Correction Assistant | NavigatePage | Guided creation path for users who prefer a wizard: target, values, preview, approval state, execute. |
| BCDA Preview Result | StandardDialog or Card dialog | Read-only dry-run result before execution. |
| BCDA Execution Confirmation | ConfirmationDialog | Final confirmation for high-risk or rollback-disabled execution. |
| BCDA Audit Entries | List | Searchable read-only operation history with filtered metadata export. |
| BCDA Rollback Wizard | NavigatePage | Review a completed source request, create a rollback correction request, preview conflicts through normal request preview, and show result. |
| BCDA Retention Status | List or CardPart | Shows configured retention, expired snapshots, and cleanup status. |

## Request Card Layout

FastTabs:

- General: status, company, reason, optional or required ticket/reference, requested by, approval state.
- Target: table, record identity, field summary, risk.
- Lines: proposed operation-typed changes.
- Line target fields: table ID lookup should suggest Business Central tables; target record identity is a read-only `RecordId` value populated through the `Select Existing Record` primary-key lookup; future field selection should be managed through a matrix-style selector filtered to enabled normal fields and policy-visible fields for the selected table and record.
- Batch line builder: uses RecordId-backed target lookup to populate canonical target identities for same-table existing-record entries, shows whether each row targets an existing record or insert group, and keeps `Rename` focused on primary-key fields.
- Target record matrix: for a selected table and record, show available field lines in a matrix similar to the standard Dimension Matrix pattern, with existing correction lines, proposed values, validation mode, rollback snapshot mode, and policy/risk hints.
- Preview data matrix: from the lines part, show a temporary read-only matrix grouped into correction type and table sections, field columns, and `Current`/`New` rows per target record without changing target records.
- Preview: old/new display values, warnings, validation mode.
- Rollback And Retention: rollback logging mode, snapshot retention period, snapshot expiration date, rollback availability.
- Audit: latest audit entries and operation result.

FactBoxes:

- Target Summary.
- Policy And Risk.
- Rollback Availability.

## Action Model

Primary actions:

- New Correction.
- Batch Add Lines, enabled for open or previewed requests to create same-table correction lines from batch entries.
- Preview Data Matrix.
- Preview.
- Submit For Approval or Approve only when approval is required; require a different approver only when setup says separate approval is required.
- Execute.
- Rollback from a completed correction request.
- Export to Excel from a correction request, enabled only through setup export controls.
- Import from Excel from a correction request, enabled only while the request is `Open` and confirmation-gated because it replaces all existing request lines.
- Export Filtered Metadata.
- Run Retention Cleanup.

Secondary actions:

- Copy Request.
- Export Audit, limited to filtered metadata.
- Open Retention Status.
- Show Technical Details.

Role Center navigation:

- Setup.
- Data Policies.
- Correction Requests.
- Audit Entries.
- Retention Logs.

Dangerous actions:

- Execute without rollback snapshots.
- Execute posted data changes.
- Rollback with conflict override.

Dangerous actions must require confirmation and must state the consequence in plain language.

## Rollback Logging Design

Audit metadata is always mandatory. Rollback snapshot logging is configurable.

| Mode | Behavior | Rollback Result |
| --- | --- | --- |
| Enabled | Store before-image values for rollback according to policy. | Request-level rollback staging can be offered while snapshots exist. |
| Disabled | Store mandatory audit metadata only; do not store before-image payloads. | Rollback is unavailable and the user sees this before execution. |
| Policy Controlled | Global setup chooses default; table/field policy can require, allow, or block rollback snapshots. | Request preview resolves the final mode and explains it. |

Posted or high-risk data defaults to rollback logging required. A policy may allow disabling rollback snapshots only after explicit confirmation and documented reason.

## Retention Design

Users control how long app-owned operation records remain in the database through setup and, where appropriate, Business Central retention policies.

Retention categories:

- Audit metadata retention: operation header, target metadata, user, date/time, result, reason, and any provided or required ticket/reference.
- Rollback snapshot retention: serialized before/after values used for rollback.
- Technical log retention: sanitized diagnostics and cleanup results.

Design rules:

- Audit metadata and rollback snapshots have separate retention settings.
- Snapshot expiration immediately makes rollback unavailable for the affected operation.
- The UI must show retention period and expiration date before execution.
- Cleanup must be auditable through retention status/log entries.
- Cleanup must protect active requests and retained rollback dependencies.
- Retention defaults should be conservative until setup policy chooses otherwise.

## Empty, Warning, And Failure States

- Empty setup: guide the `SUPER` user to configure environment label, policies, rollback logging, and retention.
- No rollback snapshots: show "Rollback unavailable because rollback logging is disabled for this request."
- Expired snapshots: show "Rollback request cannot be created because rollback snapshot retention has expired."
- Policy blocked: show the exact policy reason and the next safe action.
- Platform blocked: show sanitized platform behavior and link to escalation package fields.
