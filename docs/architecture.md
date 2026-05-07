# Architecture

## Architecture Goals

- Make exceptional data correction possible without making it casual.
- Keep all mutation paths governed by `SUPER` access, policy, preview, audit, and rollback.
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
| Data Policy Manager | Configure allow/block rules and approval requirements. |
| Correction Orchestrator | Own request state transitions and execution order. |
| Validation Runner | Dry-run changes and report warnings before execution. |
| Audit Writer | Write append-only audit entries for every material action. |
| Snapshot Store | Store before/after values needed for audit and rollback. |
| Retention Manager | Manage operation retention settings and integrate with Business Central retention policies where feasible. |
| Rollback Service | Restore before-images with conflict detection. |
| Audit Viewer | Search, filter, and export correction history. |

## Planned Object And Module Map

The following names are planning contracts only. They are not implemented yet.

| Object Area | Planned Names |
| --- | --- |
| Tables | BCDA Setup, BCDA Data Policy, BCDA Correction Request, BCDA Correction Line, BCDA Audit Entry, BCDA Value Snapshot, BCDA Rollback Operation, BCDA Retention Log |
| Pages | BCDA Setup, BCDA Data Policies, BCDA Data Policy Card, BCDA Correction Requests, BCDA Correction Request Card, BCDA Correction Lines, BCDA Correction Assistant, BCDA Preview Result, BCDA Audit Entries, BCDA Rollback Wizard, BCDA Retention Status |
| Codeunits | BCDA Correction Orchestrator, BCDA Metadata Explorer, BCDA Policy Guard, BCDA Validation Runner, BCDA Audit Writer, BCDA Value Serializer, BCDA Rollback Service, BCDA Retention Manager |
| Access Control | Existing Business Central `SUPER` permission set only; no BCDA-specific permission sets |

## Runtime Flow

1. User opens correction request page.
2. User selects target company, table, record, field, and new value.
3. Metadata Explorer resolves captions, keys, field type, and risk hints.
4. Policy Guard evaluates `SUPER` access, table policy, field policy, and approval need.
5. Validation Runner performs dry-run preview and reports warnings, rollback logging mode, retention period, and rollback availability.
6. SUPER approver approves when required by policy.
7. Correction Orchestrator executes line changes.
8. Audit Writer records mandatory attempt, outcome, target, user, reason, and ticket metadata.
9. Snapshot Store keeps rollback material only when rollback snapshot logging is enabled by setup and policy.
10. Rollback Service can later restore before-images if conflict checks pass.

## Error Flow

- Policy failures stop execution before mutation.
- Validation failures stop execution unless policy explicitly allows override.
- Runtime write failures mark the line failed and record sanitized error details.
- Partial request failures leave successful lines auditable and failed lines visible.
- Rollback conflicts stop rollback for the affected line unless override policy allows it.
- Rollback-disabled and rollback-expired states stop rollback before mutation and explain the reason.
- Retention cleanup failures are visible in retention status and do not affect active correction execution.

## Security Model

- Users need the existing Business Central `SUPER` permission set.
- The extension must not create BCDA-specific permission sets.
- Posted or hidden data changes require `SUPER` access and break-glass policy approval.
- Policy defaults should be deny-first until configured.
- Audit and snapshot tables are available only through `SUPER`-gated features and redacted export/support channels.
- Sensitive values are redacted outside privileged pages and exports.
- The app never stores environment credentials in repository files.
- Direct SQL is out of scope.

## Observability Model

- App-owned audit entries are the primary observability record.
- Support logs and telemetry must not include full sensitive values.
- Every execution includes request id, operation id, company, table, key, field, user, timestamp, result, and sanitized error.
- Retention cleanup status includes table/category, cutoff date, expired record count when available, result, and sanitized error.

## Upgrade And Extension Points

- App-owned tables require upgrade code when schema changes.
- Policy rules should be data-driven to avoid code changes for every table.
- Value serialization must be versioned so old snapshots can be read after upgrades.
- Retention integration should use Business Central retention policy APIs for app-owned tables when symbol discovery confirms availability.
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
