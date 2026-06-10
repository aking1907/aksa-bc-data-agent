# Acceptance Criteria

Acceptance criteria define observable behavior. They should stay stable and concise; do not add criteria for every internal refactor or implementation detail. Update this file when user-visible behavior, runtime controls, or release validation expectations change.

## Current Behavior

| ID | Given | When | Then |
| --- | --- | --- | --- |
| AC-013 | The project is in continuous implementation mode | An AI agent or developer prepares or changes the repo | AL source files may be generated without per-phase paper confirmation when the work stays inside the SDD, preserves user review, policies, `SUPER` access, audit, redaction, and rollback controls, and keeps production/runtime enablement subject to validation. |
| AC-017 | A future code object is proposed | The implementation plan is updated | The requested behavior is aligned with requirements, acceptance criteria, and validation evidence; traceability rows remain optional reference material. |
| AC-018 | Implementation depends on BC platform behavior | Work begins | The relevant readiness, security, or test documents identify the required sandbox/manual validation for that behavior, but missing validation blocks production reliance rather than local code development when guarded behavior is implemented safely. |
| AC-030 | A `SUPER` user stages correction lines in the foundation request UI | They choose `Update`, `Rename`, `Delete`, or `Insert` as the line type | The selected type is stored on the app-owned line; `Insert` keeps `Record ID` empty and blocks target record selection; non-insert value staging still requires a canonical target identity before current-value lookup or existing-record validation. |

## Future Phase 1 Behavior

| ID | Given | When | Then |
| --- | --- | --- | --- |
| AC-001 | A user has the Business Central `SUPER` permission set | They search for a target table or field | The app shows allowed metadata and hides or blocks restricted targets. |
| AC-002 | A user does not have the Business Central `SUPER` permission set | They try to open correction features | Access is denied. |
| AC-003 | A `SUPER` user creates a request | They provide the required target, value, reason, and any setup- or policy-required ticket/reference | The request is saved without changing target data. |
| AC-004 | A request is ready for preview | A `SUPER` user runs dry-run | The app shows old value, new value, warnings, validation mode, rollback logging mode, retention period, and rollback eligibility. |
| AC-005 | A posted or high-risk change needs approval | A `SUPER` user tries to execute it before approval | Execution is blocked and audit evidence is written. |
| AC-006 | A normal field change is allowed by policy and the configured workflow does not require separate approval or paper confirmation | A `SUPER` user executes it after required runtime controls pass | The request's supported target field changes are applied as one transaction, mandatory audit metadata is written, and retained value refs are linked when rollback snapshots are enabled. |
| AC-007 | A posted table field is allow-listed and approved | A `SUPER` user executes it | The target field changes only if platform access and validation pass. |
| AC-008 | Any execution attempt occurs | The operation succeeds or fails | Append-only audit evidence records user, time, company, target, result, reason, and any provided or required ticket/reference. |
| AC-009 | A completed request has retained rollback snapshots for all executed supported lines | A `SUPER` user runs rollback from the completed correction request | A new correction request is created with suggested inverse `Update` lines, no target data is changed by the rollback action itself, and new audit evidence records the rollback request creation. |
| AC-010 | A target record changed after the original correction | A `SUPER` user previews or executes the generated rollback correction request | The generated request shows the current target value for review and proceeds only through the normal preview, policy, approval, execution, audit, and transaction controls. |
| AC-011 | A `SUPER` user exports history | The export is generated | Only policy-allowed fields and values are included according to redaction rules. |
| AC-012 | A target table or field is blocked | A user tries to preview or execute a change | The operation is blocked before mutation. |
| AC-014 | The extension is upgraded | Audit records already exist | Historical audit records remain readable. |
| AC-015 | A runtime error occurs during execution | The request line fails | The app stores sanitized error details and does not expose sensitive values. |
| AC-016 | Logs, telemetry, exports, or tests are produced | Sensitive values are present in target data | Values are redacted unless the user and channel are explicitly authorized. |
| AC-019 | A Phase 1 release candidate is built | Pre-release validation runs in sandbox | Correction, rollback, `SUPER` access gating, audit, export, and upgrade scenarios pass. |
| AC-020 | A `SUPER` user opens BCDA pages | They work through setup, request, preview, execution, audit, or rollback | Pages use Business Central-native task-focused layouts, action placement, captions, tooltips, and clear status fields. |
| AC-021 | Rollback snapshot logging is disabled by setup or policy | A `SUPER` user previews or executes a correction | Mandatory audit metadata is still written and the UI clearly states rollback will be unavailable. |
| AC-022 | Rollback snapshot logging is enabled by setup or policy | A `SUPER` user executes a correction | Before-image snapshots are stored with retention category and expiration date. |
| AC-023 | Rollback snapshots are expired or purged | A `SUPER` user attempts request-level rollback staging | Rollback request creation is blocked before mutation and the reason is shown. |
| AC-024 | A `SUPER` user configures retention | They set audit, rollback snapshot, or technical log retention | The setting is saved, visible in preview/status pages, and used by cleanup logic. |
| AC-025 | Retention cleanup runs | Expired app-owned operation records exist | Expired records are removed according to category and cleanup evidence is visible without deleting active requests. |
| AC-026 | AL code is generated under standing SDD authorization | Build validation runs | Code analysis with required analyzers is enabled and blocking diagnostics are resolved or documented. |
| AC-027 | A `SUPER` administrator configures approval requirement and separation | A request is initialized or approval actions are used | Requests without required approval do not enter the approval workflow or require separate paper confirmation; approval can be recorded only after submission; requester approval is blocked when separate approval is required and allowed when self-approval is configured; the selected approval model remains visible on the request. |
| AC-028 | A `SUPER` user opens a saved open or previewed correction request | They use same-table batch entry | The app creates standard correction request lines from canonical target record IDs, field metadata, and proposed values without previewing or changing target Business Central data. |
| AC-029 | A `SUPER` user selects a target table with a simple or complex primary key | They use target record selection and the future matrix-style selector | The app stores the canonical target `RecordId` with a display key, shows the formatted record identity as read-only request metadata, and creates or updates correction lines for selected fields without requiring users to hand-type a serialized primary key. |
| AC-031 | A `SUPER` administrator disables `Allow Data Policies` | A supported execution attempt is made | Non-BCDA target data may proceed only when all other execution controls pass; BCDA app-owned tables, system-managed fields, unsupported fields, unaudited mutation, missing required request metadata, and non-`SUPER` access remain blocked. |
| AC-032 | A `SUPER` administrator configures ticket/reference evidence | New requests are initialized and preview, approval, or execution is attempted | The request snapshots whether ticket/reference is required; actions allow reason-only requests when the flag is off and block blank ticket/reference only when the flag is on. |
