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
- Make approval requirement and approval separation configurable so the app supports both dual-control companies and one-person companies.
- Make rollback snapshot logging configurable, but never silent.
- Make retention visible on setup, request preview, audit entries, and rollback pages.
- Warn clearly when rollback snapshots are disabled or expired.
- Avoid showing raw sensitive values unless policy and channel allow it.
- Use Business Central-native pages, actions, FastTabs, FactBoxes, confirmation dialogs, and wizards.

## Planned Pages

| Page | Page Type | Purpose |
| --- | --- | --- |
| BCDA Role Center | RoleCenter | Home/profile entry point that groups the available BCDA foundation tools for SUPER users. |
| BCDA Setup | Card | Global safety, rollback logging, retention, export, and environment settings. |
| BCDA Data Policies | List | Search and maintain table/field allow/block policies. |
| BCDA Data Policy Card | Card | Configure one table/field policy, risk, validation, approval, rollback logging, and retention overrides. |
| BCDA Correction Requests | List | Work queue with status, risk, target table, requester, approval state, rollback availability, and retention state. |
| BCDA Correction Request Card | Card with ListPart and FactBoxes | Main request workspace for target, reason, lines, preview, approval, execution, and audit summary. |
| BCDA Correction Lines | ListPart | Field-level proposed changes for a request, showing target table, read-only formatted target record identity, selected field, and proposed value. |
| BCDA Batch Line Builder | Worksheet | Paused same-table batch entry page that will collect RecordId-backed target identities, fields, and proposed values, then create standard correction lines after batch RecordId selection or target matrix entry is implemented. |
| BCDA Target Record Lookup | List | Foundation line-action lookup that displays primary-key values for the selected table and returns the selected canonical `RecordId`. |
| BCDA Target Record Matrix | Worksheet or StandardDialog | Dimension Matrix-style selector/editor that opens from target record selection, resolves a target `RecordId`, and shows available field correction lines for that selected record. |
| BCDA Table Lookup | List | Helper lookup for selecting a target Business Central table from metadata. |
| BCDA Field Lookup | List | Helper lookup for selecting an enabled normal field for the selected table. |
| BCDA Correction Assistant | NavigatePage | Guided creation path for users who prefer a wizard: target, values, preview, approval state, execute. |
| BCDA Preview Result | StandardDialog or Card dialog | Read-only dry-run result before execution. |
| BCDA Execution Confirmation | ConfirmationDialog | Final confirmation for high-risk or rollback-disabled execution. |
| BCDA Audit Entries | List | Searchable read-only operation history. |
| BCDA Rollback Wizard | NavigatePage | Select operation, preview conflicts, confirm restore, show result. |
| BCDA Retention Status | List or CardPart | Shows configured retention, expired snapshots, and cleanup status. |

## Request Card Layout

FastTabs:

- General: status, company, reason, ticket/reference, requested by, approval state.
- Target: table, record identity, field summary, risk.
- Lines: proposed field-level changes.
- Line target fields: table ID lookup should suggest Business Central tables; target record identity is a read-only `RecordId` value populated through the `Select Record` primary-key lookup; future field selection should be managed through a matrix-style selector filtered to enabled normal fields and policy-visible fields for the selected table and record.
- Batch line builder: paused until batch RecordId selection or target matrix entry can populate canonical target identities for same-table batch entries.
- Target record matrix: for a selected table and record, show available field lines in a matrix similar to the standard Dimension Matrix pattern, with existing correction lines, proposed values, validation mode, rollback snapshot mode, and policy/risk hints.
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
- Batch Add Lines, paused until batch RecordId selection or target matrix entry is implemented.
- Preview.
- Submit For Approval or Approve only when approval is required; require a different approver only when setup says separate approval is required.
- Execute.
- Rollback.

Secondary actions:

- Copy Request.
- Export Audit.
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
| Enabled | Store before-image values for rollback according to policy. | Rollback can be offered while snapshots exist and conflict checks pass. |
| Disabled | Store mandatory audit metadata only; do not store before-image payloads. | Rollback is unavailable and the user sees this before execution. |
| Policy Controlled | Global setup chooses default; table/field policy can require, allow, or block rollback snapshots. | Request preview resolves the final mode and explains it. |

Posted or high-risk data defaults to rollback logging required. A policy may allow disabling rollback snapshots only after explicit confirmation and documented reason.

## Retention Design

Users control how long app-owned operation records remain in the database through setup and, where appropriate, Business Central retention policies.

Retention categories:

- Audit metadata retention: operation header, target metadata, user, date/time, result, reason, ticket/reference.
- Rollback snapshot retention: serialized before/after values used for rollback.
- Technical log retention: sanitized diagnostics and cleanup results.

Design rules:

- Audit metadata and rollback snapshots have separate retention settings.
- Snapshot expiration immediately makes rollback unavailable for the affected operation.
- The UI must show retention period and expiration date before execution.
- Cleanup must be auditable through retention status/log entries.
- Retention defaults should be conservative until business owners choose otherwise.

## Empty, Warning, And Failure States

- Empty setup: guide the `SUPER` user to configure environment label, policies, rollback logging, and retention.
- No rollback snapshots: show "Rollback unavailable because rollback logging is disabled for this request."
- Expired snapshots: show "Rollback unavailable because rollback snapshot retention has expired."
- Policy blocked: show the exact policy reason and the next safe action.
- Platform blocked: show sanitized platform behavior and link to escalation package fields.
