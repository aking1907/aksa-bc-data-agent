# Acceptance Criteria

## Current Behavior

| ID | Given | When | Then |
| --- | --- | --- | --- |
| AC-013 | The project is in a gated implementation mode | An AI agent or developer prepares or changes the repo | AL source files are generated only within the scope explicitly allowed by `docs/code-generation-readiness.md`. |
| AC-017 | A future code object is proposed | The implementation plan is updated | The object has a traceability row linking requirement, acceptance, and test. |
| AC-018 | Implementation depends on BC platform behavior | Work begins | `symbol-discovery.md` contains evidence for that behavior. |

## Future Phase 1 Behavior

| ID | Given | When | Then |
| --- | --- | --- | --- |
| AC-001 | A user has the Business Central `SUPER` permission set | They search for a target table or field | The app shows allowed metadata and hides or blocks restricted targets. |
| AC-002 | A user does not have the Business Central `SUPER` permission set | They try to open correction features | Access is denied. |
| AC-003 | A `SUPER` user creates a request | They provide target, value, reason, and ticket | The request is saved without changing target data. |
| AC-004 | A request is ready for preview | A `SUPER` user runs dry-run | The app shows old value, new value, warnings, validation mode, rollback logging mode, retention period, and rollback eligibility. |
| AC-005 | A posted or high-risk change needs approval | A `SUPER` user tries to execute it before approval | Execution is blocked and audit evidence is written. |
| AC-006 | A normal allowed field change is approved by policy | A `SUPER` user executes it | The target field changes, mandatory audit metadata is written, and retained value refs are linked when rollback snapshots are enabled. |
| AC-007 | A posted table field is allow-listed and approved | A `SUPER` user executes it | The target field changes only if platform access and validation pass. |
| AC-008 | Any execution attempt occurs | The operation succeeds or fails | Append-only audit evidence records user, time, company, target, result, reason, and ticket. |
| AC-009 | A rollback is allowed and no conflict exists | A `SUPER` user runs rollback | The previous value is restored and a new audit entry records rollback. |
| AC-010 | A target record changed after the original correction | A `SUPER` user runs rollback | Rollback stops with a conflict unless policy-approved override exists. |
| AC-011 | A `SUPER` user exports history | The export is generated | Only policy-allowed fields and values are included according to redaction rules. |
| AC-012 | A target table or field is blocked | A user tries to preview or execute a change | The operation is blocked before mutation. |
| AC-014 | The extension is upgraded | Audit records already exist | Historical audit records remain readable. |
| AC-015 | A runtime error occurs during execution | The request line fails | The app stores sanitized error details and does not expose sensitive values. |
| AC-016 | Logs, telemetry, exports, or tests are produced | Sensitive values are present in target data | Values are redacted unless the user and channel are explicitly authorized. |
| AC-019 | A Phase 1 release candidate is built | Pre-release validation runs in sandbox | Correction, rollback, `SUPER` access gating, audit, export, and upgrade scenarios pass. |
| AC-020 | A `SUPER` user opens BCDA pages | They work through setup, request, preview, execution, audit, or rollback | Pages use Business Central-native task-focused layouts, action placement, captions, tooltips, and clear status fields. |
| AC-021 | Rollback snapshot logging is disabled by setup or policy | A `SUPER` user previews or executes a correction | Mandatory audit metadata is still written and the UI clearly states rollback will be unavailable. |
| AC-022 | Rollback snapshot logging is enabled by setup or policy | A `SUPER` user executes a correction | Before-image snapshots are stored with retention category and expiration date. |
| AC-023 | Rollback snapshots are expired or purged | A `SUPER` user attempts rollback | Rollback is blocked before mutation and the reason is shown. |
| AC-024 | A `SUPER` user configures retention | They set audit, rollback snapshot, or technical log retention | The setting is saved, visible in preview/status pages, and used by cleanup logic. |
| AC-025 | Retention cleanup runs | Expired app-owned operation records exist | Expired records are removed according to category and cleanup evidence is visible without deleting active requests. |
| AC-026 | AL code is generated after readiness | Build validation runs | Code analysis with required analyzers is enabled and blocking diagnostics are resolved or documented. |
| AC-027 | A `SUPER` administrator configures approval requirement and separation | A request is initialized or approval actions are used | Requests without required approval do not enter the approval workflow; requester approval is blocked when separate approval is required and allowed when self-approval is configured; the selected approval model remains visible on the request. |
