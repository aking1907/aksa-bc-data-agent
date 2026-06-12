# Architecture

## Architecture Goals

- Make exceptional data correction possible without making it casual.
- Keep all mutation paths governed by `SUPER` access, policy or a reviewed policy-enforcement exception, preview, audit, and rollback.
- Separate app-owned governance data from Business Central-owned business data.
- Prefer explicit allow rules for posted or high-risk data.
- Preserve enough context for support, audit, and rollback.
- Let users control rollback snapshot logging and retention without making changes untraceable.
- Align with Microsoft Business Central page, analyzer, retention, robust coding, and performance guidance.

## Layers And Responsibilities

| Layer | Responsibility |
| --- | --- |
| User Experience | Request entry, preview, approval, audit review, and rollback screens. |
| Application Services | Coordinate request lifecycle, execution, rollback, and status transitions. |
| Policy Engine | Decide whether a user, table, field, and operation are allowed. |
| Record Access Layer | Read and write target records using verified BC platform APIs. |
| Value Serialization | Convert typed field values to protected stored form and display form. |
| Audit And Snapshot | Append-only evidence and rollback before-images. |
| Retention | Register app-owned operation tables for retention, expose retention status, and protect active records. |
| Security | Existing `SUPER` access checks, policy checks, redaction, and blocked operations. |

## Component Map

| Component | Purpose |
| --- | --- |
| Setup Management | Global defaults, retention, and environment safety settings. |
| Metadata Explorer | Discover tables, fields, keys, captions, and risk hints. |
| Record Identity Manager | Planned service to centralize target `RecordId` identity formatting, validation, and display-key policy after sandbox validation passes. |
| Target Record Lookup | Foundation line-action lookup that lets SUPER users select a target record by primary-key display values and populate correction-line `Record ID`. |
| Current Value Manager | Foundation selected-line reader that fills `Current Value Preview` only for the selected `Record ID` and `Field ID`. |
| Preview Data Matrix | Foundation read-only matrix page that displays stored correction-line data for one request grouped by request, correction type, table, record, and field without target mutation or full dry-run validation. |
| Target Record Matrix | Planned richer selector/editor to maintain field correction lines for a selected record without hand-entering composite keys. |
| Batch Line Builder | Same-table helper that uses target record lookup to populate canonical `RecordId` identities and create standard correction lines without target mutation. |
| Data Policy Manager | Configure allow/block rules and approval requirements. |
| Correction Orchestrator | Own request state transitions and execution order. |
| Validation Runner | Dry-run changes and report warnings before execution. |
| Audit Writer | Write append-only audit entries for every material action. |
| Snapshot Store | Store before/after values needed for audit and rollback. |
| Retention Manager | Manage operation retention settings and integrate with Business Central retention policies where feasible. |
| Rollback Service | Create governed rollback correction requests from retained before-images. |
| Audit Viewer | Search, filter, and export redacted correction metadata. |

## Object And Module Map

Foundation objects are implemented for setup, policy, request, audit, snapshot, rollback-state, retention-log, SUPER-gated shells, supporting services, grouped update execution, supported record-level delete execution, supported grouped insert execution, supported update rollback, filtered audit metadata export, and retention cleanup. Objects marked future remain gated by readiness.

| Object Area | Names |
| --- | --- |
| Tables | BCDA Setup, BCDA Data Policy, BCDA Correction Request, BCDA Correction Line, BCDA Batch Line Buffer, BCDA Target Record Buffer, BCDA Preview Data Matrix, BCDA Audit Entry, BCDA Value Snapshot, BCDA Rollback Operation, BCDA Retention Log |
| Pages | BCDA Role Center, BCDA Setup, BCDA Data Policies, BCDA Data Policy Card, BCDA Correction Requests, BCDA Correction Request Card, BCDA Correction Lines, BCDA Preview Data Matrix, BCDA Batch Line Builder, BCDA Audit Entries, BCDA Rollback Operations, BCDA Retention Logs, BCDA Table Lookup, BCDA Field Lookup, BCDA Target Record Lookup. Future: BCDA Target Record Matrix, BCDA Correction Assistant, BCDA Preview Result, BCDA Rollback Wizard, BCDA Retention Status. |
| Profiles | BC Data Agent profile mapped to BCDA Role Center. |
| Codeunits | BCDA Access Mgt., BCDA Setup Mgt., BCDA Correction Orchestrator, BCDA Metadata Explorer, BCDA Batch Line Mgt., BCDA Current Value Mgt., BCDA Policy Guard, BCDA Audit Writer, BCDA Value Serializer, BCDA Retention Manager, BCDA Rollback Service, BCDA Audit Export Mgt. Future: BCDA Record Identity Mgt., BCDA Target Matrix Mgt., BCDA Validation Runner. |
| Access Control | Existing Business Central `SUPER` permission set only; no BCDA-specific permission sets |

## Runtime Flow

1. User opens correction request page.
2. User selects target company and table.
3. User runs `Select Record`. The foundation lookup resolves the target `RecordId` from primary-key display values; the future matrix-style selector will add available fields and existing correction lines for the selected record.
4. Metadata Explorer resolves captions, keys, field type, and risk hints. When both `Record ID` and `Field ID` are selected, Current Value Manager reads the selected field value for line preview.
5. Policy Guard evaluates `SUPER` access, table policy, field policy, approval need, and any future reviewed policy-enforcement exception.
6. Correction Orchestrator performs the current non-mutating staged-line preview and reports warnings, rollback logging mode, retention period, and rollback availability. Full validate-trigger dry-run remains gated.
7. SUPER approver approves when required by policy.
8. Correction Orchestrator executes line changes by grouping staged lines by correction type and canonical target identity when applicable. `Insert` execution must not use an input `RecordId`; the current implementation groups insert lines by request/table, creates one record per group, and stores the created `RecordId` after success.
9. Audit Writer records mandatory attempt, outcome, target, user, reason, and ticket metadata.
10. Snapshot Store keeps rollback material only when rollback snapshot logging is enabled by setup and policy.
11. Rollback Service can create a new governed correction request from a completed supported `Update` request when retained before-images exist for the whole request.
12. Audit Export Manager exports filtered audit metadata only when `SUPER` access, setup export enablement, and required filters are present.
13. Retention Manager purges expired rollback snapshot payloads and deletes expired eligible BCDA-owned operation records while preserving active requests and retained rollback dependencies.

## Error Flow

- Policy failures stop execution before mutation.
- Validation failures stop execution unless policy explicitly allows override.
- Runtime write failures roll back the request transaction so supported target writes are not partially applied.
- Request validation failures before mutation mark the request failed and record sanitized audit evidence without changing target data.
- Partial request target updates are not allowed.
- Rollback creates a new correction request for the entire completed source request; it does not restore values directly from audit entries.
- Rollback-disabled and rollback-expired states stop rollback request creation before mutation and explain the reason.
- Retention cleanup failures are visible in retention logs and do not affect active correction execution.

## Security Model

- Users need the existing Business Central `SUPER` permission set.
- The extension must not create BCDA-specific permission sets.
- Approval requirement and approval separation are workflow settings, not permission sets. Setup can require a different `SUPER` approver, allow self-approval, or disable approval for standard requests when one-person companies explicitly accept that control model.
- Posted or hidden data changes require `SUPER` access and break-glass policy approval.
- Policy defaults should be deny-first until configured.
- `Allow Data Policies` can bypass policy records when disabled. It must not bypass `SUPER`, required request metadata, audit, rollback snapshot controls, sandbox validation, or permanent blocks for BCDA app-owned, system-managed, and unsupported targets.
- Audit and snapshot tables are available only through `SUPER`-gated features and redacted export/support channels.
- Sensitive values are redacted outside privileged pages; Phase 8 export omits target value and snapshot payload content.
- The app never stores environment credentials in repository files.
- Direct SQL is out of scope.

## Observability Model

- App-owned audit entries are the primary observability record.
- Support logs and telemetry must not include full sensitive values.
- Every execution includes request id, operation id, company, table, key, field, user, timestamp, result, and sanitized error.
- Retention cleanup status includes table/category, cutoff date, expired record count, deleted or purged count, result, and sanitized error.

## Upgrade And Extension Points

- App-owned tables require upgrade code when schema changes.
- Policy rules should be data-driven to avoid code changes for every table.
- Value serialization must be versioned so old snapshots can be read after upgrades.
- Retention integration should use Business Central retention policy APIs for app-owned tables when sandbox validation confirms availability.
- Future external API access should be added only after API contracts and security review are updated.

## UI Design Model

See `docs/app-design.md` for page-level design. Implementation must use Business Central-native page types and action placement:

- `Card` pages for setup, policy, and request details.
- `List` pages for work queues and audit history.
- `ListPart` for correction lines.
- `NavigatePage` for guided correction creation and rollback.
- `ConfirmationDialog` for posted, rollback-disabled, or conflict-override execution.
- FactBoxes for target summary, policy/risk, and rollback availability.

## Development Standards

See `docs/al-development-standards.md`. Generated AL must use CodeCop and UICop, follow robust coding practices, keep page triggers thin, avoid broad analyzer suppression, and design data access for performance and low locking.
