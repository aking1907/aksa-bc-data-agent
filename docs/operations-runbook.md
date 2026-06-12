# Operations Runbook

## Current Support Boundary

The project currently has Phase 2-8 AL objects, including grouped update execution, supported record-level delete execution, supported grouped insert execution, supported update rollback, filtered audit metadata export, and governed retention cleanup. Phase 8 sandbox validation was skipped by request for implementation and remains required before production use.

## Setup Checks

- Confirm extension is installed in sandbox.
- Confirm only authorized users with the Business Central `SUPER` permission set can access the extension.
- Confirm no BCDA-specific permission sets are created or assigned.
- Confirm setup record exists.
- Confirm the `BC Data Agent` profile opens the BCDA Role Center for convenient navigation.
- Confirm posted table default policy is deny-first or explicitly approved.
- Confirm approval requirement and separate-approver settings match the company control model.
- Confirm `Require Ticket Reference` matches the company evidence model.
- Confirm rollback snapshot logging default is configured.
- Confirm audit metadata, rollback snapshot, and technical log retention are configured.
- Confirm `Allow Data Policies` is enabled by default, or explicitly accepted before policy records are bypassed.
- Confirm `Export Enabled` is intentionally configured before using filtered audit metadata export.
- Confirm retention cleanup settings are intentionally configured before running cleanup.

## Health Checks

- Open setup page.
- Switch to the `BC Data Agent` profile and verify the Role Center links open setup, policies, requests, audit entries, rollback operations, and retention logs for a `SUPER` user.
- Create a foundation request in sandbox.
- Confirm data policy `Table ID` and `Field ID` lookup fills metadata names.
- Confirm BCDA app-owned table IDs are blocked in table lookup, correction line table validation, data policy table validation, and policy evaluation.
- Confirm correction line `Table ID` lookup shows Business Central tables and `Field ID` lookup is filtered by the selected table.
- Confirm correction line `Type` supports `Update`, `Rename`, `Delete`, and `Insert`, that `Rename` accepts primary-key fields only and stores the renamed identity after execution, and that `Insert` keeps `Record ID` empty while staged.
- Confirm `Record ID` is read-only app-owned storage, the `Select Record` line action opens target record lookup, and selecting a row fills the canonical identity.
- Confirm selecting `Field ID` after `Record ID` fills `Current Value Preview` for that selected field only.
- Confirm entering `Proposed New Value` accepts supported scalar field values, blocks disabled, non-normal, primary-key-for-update, non-primary-key-for-rename, system-managed, removed, unsupported-type, length-invalid, and scalar type-incompatible values, and does not echo sensitive proposed values in errors.
- Confirm `Preview Data Matrix` opens from the correction lines part, shows staged correction-line data for the current request, and remains read-only.
- Confirm `Batch Add Lines` opens same-table batch entry, can select target records, and creates normal correction lines without target mutation.
- Confirm `Preview Request` does not mutate target data; target value reads stay limited to the selected staged lines and update app-owned line status, rollback/retention text, and audit evidence only.
- Confirm setup defaults show rollback logging mode, retention period, and rollback availability text.
- Confirm audit entry is written for preview or blocked attempt when expected.
- Confirm rollback-disabled preview clearly states rollback will be unavailable.
- Confirm supported rollback from a completed update correction request creates a new rollback correction request from retained before-images and that the generated request previews current target values before execution.
- Confirm generated rollback request review, expired/purged snapshot, policy-blocked rollback request execution, and non-`SUPER` rollback attempts are blocked with sanitized audit evidence.
- Confirm filtered audit metadata export is blocked until `Export Enabled` is on and at least one required audit filter is applied.
- Confirm retention cleanup purges/deletes only expired eligible BCDA-owned operation records and protects active requests and retained rollback dependencies.
- Confirm unauthorized test user cannot access correction or rollback pages.

## Main Workflow

1. SUPER user creates correction request.
2. SUPER user enters reason and ticket/reference when required or available.
3. SUPER user selects correction type, target table, target record identity when applicable, and field metadata when applicable, reviews the selected field's current value for existing-record lines, then stages the proposed value. Mutation remains limited to supported grouped `Update`, primary-key `Rename`, record-level `Delete`, and grouped `Insert` execution after all controls pass.
4. SUPER user runs preview.
5. SUPER user approves if approval is required. Use a different SUPER user only when approval policy requires separation; skip approval only when setup or policy explicitly says approval is not required.
6. SUPER user executes supported grouped `Update`, primary-key `Rename`, record-level `Delete`, or grouped `Insert` corrections after metadata, preview, approval/policy, audit, and rollback-availability checks pass.
7. SUPER reviewer reviews evidence.
8. SUPER user requests supported rollback from the completed correction request if needed and while snapshots are retained, then reviews the generated rollback correction request.
9. SUPER reviewer exports filtered audit metadata only when export is enabled and required filters are applied.
10. SUPER administrator runs retention cleanup only after reviewing retention settings.

## Troubleshooting

| Category | Checks |
| --- | --- |
| Access denied | Confirm the user has the Business Central `SUPER` permission set and the extension's runtime access check passes. |
| Policy blocked | Review table and field policy, risk classification, and approval state. |
| Need to modify without policy records | Use `Allow Data Policies` off only when the business accepts bypassing policy records. BCDA app-owned tables, unsupported fields, non-`SUPER` users, missing request metadata, unaudited mutation, and rollback controls still apply. |
| Preview failed | Confirm target record exists and field type is supported. |
| Preview Data Matrix is empty or blocked | Confirm the request is saved, has correction lines, and the user has `SUPER` access. |
| Proposed value rejected | Confirm the line type rules: `Update` needs an existing target record and non-primary-key field, `Rename` needs an existing target record and primary-key fields only, `Insert` must keep Record ID empty while staged and must include all primary-key fields before execution, and all value-staging fields must be enabled, normal, not system-managed, not removed, supported for foundation staging, and type/length compatible. |
| Execution unavailable | The request is not in an executable state, metadata is missing, required preview is not complete, approval is missing, policy blocks the line, or the line type is not enabled for runtime execution. |
| Rollback review difference | The generated rollback correction request preview shows a current target value that differs from the original executed value. Review the generated request and decide whether a separate correction is required. |
| Rollback unavailable | Confirm the source request is completed, all source lines are executed supported `Update` lines, rollback snapshot logging was enabled, snapshots have not expired or been purged, and no rollback request already exists. |
| Retention cleanup issue | Review retention status, retention policy setup, and sanitized retention log entries. |
| Export blocked | Confirm `SUPER` access, `Export Enabled`, and a filter on request, company, occurred-at date/time, operation, or result. |
| Export missing target values | This is expected. Phase 8 export omits target values, target record identity text, and rollback snapshot payloads by design. |
| Upgrade issue | Check extension version, upgrade notes, and audit table compatibility. |

## Phase 8 Safe Export And Cleanup Handling

Use these rules when validating Phase 8 in sandbox:

- Use only artificial BCDA operation records.
- Require request, company, date range, operation, or result filters before export.
- Start export with app-owned audit metadata only.
- Omit or redact target values, hidden values, posted values, snapshot payloads, and full platform errors.
- Do not share export files through chat, tickets, email, or screenshots unless the destination is allowed by the export-handling policy.
- Store export files only in the approved support location and delete temporary copies after the support window.
- Review retention cleanup impact before running cleanup.
- Treat active requests, pending approvals, incomplete executions, retained rollback dependencies, and cleanup evidence from the same run as protected.
- Retention cleanup must touch only BCDA-owned operation tables, never target Business Central business data.

## Safe Logging Guidance

- Share request id, line id, table id, field id, timestamp, and sanitized error.
- For future RecordId-backed target selection, share formatted target record identity and display key, not sensitive target values.
- Do not share full sensitive values in chat, tickets, logs, or screenshots unless allowed by policy.
- Use hashes or redacted display values where possible.

## Escalation Package

Provide:

- Environment and company.
- Extension version.
- Request id and line ids.
- Operation type.
- Sanitized error.
- Policy decision shown to user.
- Whether target data is normal, hidden, or posted.
- Rollback logging mode and snapshot expiration date.
- Whether rollback was attempted.
- Retention category and cleanup status when relevant.
- Export filters used and whether values were redacted or omitted.
- Cleanup preview id or run timestamp when relevant.
