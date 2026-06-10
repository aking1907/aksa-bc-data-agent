# Test Plan

## Test Types

| Type | Purpose |
| --- | --- |
| Compile validation | Ensure AL package builds for target BC version. |
| SUPER access tests | Confirm only users with the existing Business Central `SUPER` permission set can access functionality. |
| Policy tests | Confirm allow/block/approval decisions. |
| Preview tests | Confirm dry-run does not mutate data. |
| Execution tests | Confirm approved changes succeed as an all-or-nothing request transaction and failed changes audit safely before mutation. |
| Rollback tests | Confirm request-level rollback staging creates a governed inverse correction request from retained before-images. |
| Audit tests | Confirm append-only evidence and redaction. |
| Retention tests | Confirm rollback snapshot logging, expiration, cleanup, and retention status. |
| Analyzer tests | Confirm required AL analyzers run after implementation begins. |
| Upgrade tests | Confirm app-owned data remains readable after upgrade. |
| Manual sandbox tests | Validate representative normal, hidden, and posted data scenarios. |

## Scenario Matrix

| Test ID | Scenario | Acceptance |
| --- | --- | --- |
| TST-001 | Non-`SUPER` user cannot open correction pages | AC-002 |
| TST-002 | Foundation metadata lookup pages suggest tables and enabled normal fields, block BCDA app-owned tables from table lookup/correction lines/data policies/policy evaluation, and later metadata search shows allowed targets and blocks restricted targets | AC-001, AC-012 |
| TST-003 | Request creation stores required reason and setup- or policy-required ticket/reference without mutation | AC-003 |
| TST-004 | Preview shows old/new values and warnings without mutation, updates line statuses, and blocks preview-required approval until all lines are previewed | AC-004 |
| TST-005 | Posted table execution is blocked before approval | AC-005 |
| TST-006 | Policy-allowed normal field correction succeeds with or without approval according to setup | AC-006 |
| TST-007 | Approved posted field correction succeeds in sandbox when platform allows | AC-007 |
| TST-008 | Failed execution writes sanitized audit evidence | AC-008, AC-015 |
| TST-009 | Rollback from a completed request creates a new inverse correction request when retained snapshots exist for all executed supported lines | AC-009 |
| TST-010 | Generated rollback correction request preview exposes current target values for review and executes only through normal policy, approval, audit, and transaction controls | AC-010 |
| TST-011 | Audit export redacts values according to export policy | AC-011, AC-016 |
| TST-012 | Extension upgrade preserves audit readability | AC-014 |
| TST-013 | Future generated behavior is validated against the requested requirements and acceptance criteria | AC-017 |
| TST-014 | Platform-dependent behavior has readiness, security, or sandbox validation coverage before production reliance; guarded local implementation can proceed while validation is pending | AC-018 |
| TST-015 | Release candidate passes sandbox correction, rollback, `SUPER` access, audit, export, and upgrade validation | AC-019 |
| TST-016 | Pages, profile navigation, and actions match Business Central-native app design expectations | AC-020 |
| TST-017 | Rollback snapshot logging disabled still writes mandatory audit metadata | AC-021 |
| TST-018 | Rollback snapshot logging enabled stores before-images with expiration dates | AC-022 |
| TST-019 | Expired or purged rollback snapshots block rollback request creation before mutation | AC-023 |
| TST-020 | Retention settings are saved and shown in setup, preview, and retention status | AC-024 |
| TST-021 | Retention cleanup removes expired operation records and preserves active requests | AC-025 |
| TST-022 | Required AL analyzers run and blocking diagnostics are resolved or documented | AC-026 |
| TST-027 | Approval configuration skips approval when disabled, blocks approval before submission, blocks requester approval when separate approval is required, and allows self-approval when configured | AC-027 |
| TST-028 | Same-table batch entry selects canonical target record IDs and creates standard correction lines without target preview or mutation | AC-028 |
| TST-029 | Foundation RecordId line-action lookup and later matrix entry support simple and composite primary keys without hand-entered key parsing | AC-029 |
| TST-030 | Selected-line current value preview fills only after `Record ID` and `Field ID` are selected and does not mutate target data | AC-004, AC-016 |
| TST-031 | Correction line proposed-value validation accepts supported scalar values and blocks disabled, non-normal, primary-key, system-managed, removed, unsupported-type, length-invalid, or scalar type-incompatible values without mutating target data | AC-003, AC-012, AC-016 |
| TST-032 | Preview Data Matrix opens from correction lines, shows staged request line data grouped by request, correction type, table, record, and field, and does not mutate target data or run full dry-run validation | AC-003, AC-004, AC-016, AC-020 |
| TST-033 | Correction line type staging stores `Update`, `Rename`, `Delete`, and `Insert`; `Insert` keeps `Record ID` empty and target record selection blocked; Phase 6 executes `Update` groups and audits other operation types as blocked | AC-030 |
| TST-034 | When `Allow Data Policies` is disabled, execution bypasses policy records for non-BCDA supported targets and still blocks non-`SUPER`, unaudited, rollback-unready, request-metadata-incomplete, app-owned, and unsupported execution paths | AC-031 |
| TST-035 | `Require Ticket Reference` setup snapshots to new requests; reason-only requests can proceed when off, and blank ticket/reference is blocked when on | AC-032 |

## Local Build Validation

Foundation local build validation is available for the Phase 2 AL source under `src/`.

Current foundation validation evidence as of 2026-05-08:

- Symbols are downloaded in `.alpackages/` for the configured Business Central 28 target.
- `alc.exe` package compilation passes against the downloaded symbols.
- CodeCop, UICop, and PerTenantExtensionCop pass with `ruleset.json`; `PTE0004` is intentionally suppressed because ADR-003 forbids BCDA-specific permission set objects.
- Automated AL test codeunits have not been added yet.

Ongoing local validation should include:

- Rebuild/package the extension after each AL change.
- Run CodeCop, UICop, and PerTenantExtensionCop with `ruleset.json`.
- Add automated test codeunits when the relevant behavior is available.
- Validate foundation RecordId lookup in sandbox for representative simple and composite primary keys; add richer matrix selector validation before runtime or production enablement.
- Validate selected-line current value preview in sandbox for representative scalar field types and confirm sensitive values are not exposed outside `SUPER`-gated pages.
- Validate proposed-value staging for Text, Code, Decimal, Date, DateTime, Boolean, GUID, Option, and unsupported types, confirming errors do not echo the proposed value.
- Validate Preview Data Matrix opens only for `SUPER` users and displays stored correction-line values for one request without changing target data.
- Validate `Preview Request` updates line statuses/sanitized messages, confirms delete target records exist, resets line status to `Open` after line edits, and blocks preview-required submit/approve until every line is previewed.
- Validate correction line type staging for Update, Rename, Delete, and Insert, including Insert's empty RecordId rule and non-insert RecordId validation.
- Validate `Allow Data Policies` in sandbox, including permanent blocks for BCDA app-owned, system-managed, unsupported, unaudited, and non-`SUPER` mutation paths.
- Deploy only to sandbox until release gates pass; local code development can continue while sandbox validation evidence is being collected.

## Integration Validation

Phase 1 integration validation must run against a Business Central sandbox using representative data. Production validation should use a controlled dry-run first and follow the validated production readiness procedure.

## Execution Readiness Validation

The ASAP execution-readiness track is defined in `docs/execution-readiness-kickoff.md`. As the final Phase 6 validation step, sandbox validation must record:

- `SUPER` and non-`SUPER` access results.
- RecordId/RecordRef target selection and selected-field preview behavior for simple and composite keys.
- Scalar field read/parse/write behavior for supported types.
- Blocked behavior for unsupported field types and system-managed fields.
- Normal, hidden, posted, and protected table write results with sanitized errors.
- Audit, rollback snapshot, and all-or-nothing transaction expectations for execution.
- Standard-update behavior when approval and ticket/reference evidence are not required by setup or policy.
- OD-018 status if insert execution is requested, and `Allow Data Policies` behavior when policy records are bypassed.

### Phase 6 Final Execution Validation Scenarios

These scenarios are the final Phase 6 validation set after `ExecuteRequest` is implemented or opened for sandbox validation.

| Scenario ID | Scenario | Acceptance/Test Links | Evidence Source |
| --- | --- | --- | --- |
| P6-TST-001 | Non-SUPER user cannot open execution-capable pages or invoke execution services | AC-002, AC-005 / TST-001, TST-005 | Sandbox access validation |
| P6-TST-002 | Allowed update of one scalar non-primary-key field succeeds on an artificial normal table, with approval required only when setup or policy requires it | AC-006, AC-008, AC-027 / TST-006, TST-008, TST-027 | Sandbox execution validation |
| P6-TST-003 | Data policy is re-checked immediately before execution and blocks disallowed targets before mutation | AC-012 / TST-002, TST-031 | Sandbox policy validation |
| P6-TST-004 | Unsupported, primary-key, system-managed, FlowField, BLOB, and Media fields are blocked before mutation | AC-012, AC-016 / TST-031 | Sandbox field-boundary validation |
| P6-TST-005 | BCDA app-owned tables cannot be selected, policy-allowed, previewed as targets, or executed | AC-012 / TST-002 | Sandbox app-owned target validation |
| P6-TST-006 | Posted/protected targets remain blocked unless sandbox validation and explicit allow-list policy are added later | AC-005, AC-007, AC-012 / TST-005, TST-007 | Sandbox posted/protected validation |
| P6-TST-007 | Required or enabled rollback snapshot mode captures a retained before-image with expiration metadata | AC-008, AC-022 / TST-008, TST-018 | Sandbox snapshot validation |
| P6-TST-008 | Request-wide validation failure leaves target data unchanged and writes sanitized audit evidence before mutation; runtime mutation failure rolls back the request transaction | AC-006, AC-008, AC-015, AC-016 / TST-006, TST-008 | Sandbox failure validation |
| P6-TST-009 | `Rename`, `Delete`, and `Insert` execution remain blocked or disabled at runtime until their operation-specific controls are implemented; `Allow Data Policies` bypasses policy records only while preserving permanent runtime controls | AC-012, AC-030, AC-031 / TST-033, TST-034 | Final validation |

## Rollback Readiness Validation

The rollback-readiness track is defined in `docs/rollback-readiness-kickoff.md`. Phase 7 local implementation creates rollback correction requests from completed supported `Update` requests. As the final Phase 7 production-readiness validation step, sandbox validation must record:

- Successful Phase 6 execution with retained before-image snapshots.
- Rollback request creation for a scalar non-primary-key update with retained snapshots.
- Generated rollback request preview shows the current target value and proposed old value for review.
- Rollback request creation is blocked when the snapshot is expired, purged, disabled, or missing.
- Rollback blocked for non-`SUPER` users and policy-blocked targets.
- Append-only rollback audit evidence for rollback request creation and generated rollback request execution.
- Sanitized rollback request creation errors that do not echo sensitive target values.

### Phase 7 Rollback Validation Scenarios

These scenarios define the final validation set for supported request-level `Update` rollback staging.

| Scenario ID | Scenario | Acceptance/Test Links | Evidence Source |
| --- | --- | --- | --- |
| P7-TST-001 | Rollback from a successful completed Phase 6 scalar update request creates a new correction request with the retained before-image as proposed value | AC-009, AC-022 / TST-009, TST-018 | Sandbox rollback request validation |
| P7-TST-002 | Generated rollback correction request preview shows current target values and proposed retained before-images before any mutation | AC-010 / TST-010 | Sandbox rollback preview validation |
| P7-TST-003 | Expired rollback snapshots block rollback request creation before mutation | AC-023 / TST-019 | Sandbox expired-snapshot validation |
| P7-TST-004 | Purged or missing rollback snapshots block rollback request creation before mutation | AC-023 / TST-019 | Sandbox missing-snapshot validation |
| P7-TST-005 | Rollback-disabled source operations make rollback unavailable and visible | AC-021, AC-023 / TST-017, TST-019 | Sandbox rollback-unavailable validation |
| P7-TST-006 | Non-SUPER users cannot invoke rollback services or rollback-capable pages | AC-002, AC-009 / TST-001, TST-009 | Sandbox rollback access validation |
| P7-TST-007 | Data policy is re-checked when the generated rollback correction request is previewed and executed | AC-012 / TST-002 | Sandbox rollback policy validation |
| P7-TST-008 | Generated rollback correction request execution follows the all-or-nothing request transaction model | AC-006, AC-008, AC-015, AC-016 / TST-006, TST-008 | Sandbox rollback failure validation |
| P7-TST-009 | Rename, Delete, and Insert rollback are either implemented with explicit operation-aware controls or remain runtime-blocked until those controls exist | AC-012, AC-030 / TST-033 | Sandbox rollback gate validation |
| P7-TST-010 | Rollback request creation appends audit evidence and does not modify the original execution audit entries | AC-008, AC-009 / TST-009 | Sandbox append-only audit validation |

## Audit, Retention, And Export Readiness Validation

The Phase 8 readiness track is defined in `docs/audit-retention-export-readiness-kickoff.md`. Phase 8 local implementation and Phase 9 local hardening are complete for the current build, and sandbox validation was skipped by request for the implementation pass. As the final release-validation step for the Phase 8 scope, sandbox validation must record:

- Audit export blocked for non-`SUPER` users.
- Audit metadata export succeeds for a filtered artificial dataset.
- Export omits or redacts target values, snapshot payloads, hidden values, posted values, and full sensitive errors by default.
- Export filters limit by request, company, date range, operation, and result before broad export is considered.
- Retention cleanup identifies and purges/deletes only expired eligible BCDA-owned operation records.
- Retention cleanup preserves active requests, pending approvals, incomplete executions, retained rollback dependencies, and cleanup evidence created in the same run.
- Upgrade validation confirms existing audit, snapshot, rollback, and retention records remain readable before and after export/cleanup implementation.

### Phase 8 Audit, Retention, And Export Validation Scenarios

These scenarios define the final validation set for audit export and retention cleanup behavior.

| Scenario ID | Scenario | Acceptance/Test Links | Evidence Source |
| --- | --- | --- | --- |
| P8-TST-001 | SUPER user can review artificial audit metadata with request, company, date range, operation, and result filters | AC-008, AC-011 / TST-011 | Sandbox audit review validation |
| P8-TST-002 | Non-SUPER user cannot open audit export or cleanup-capable features | AC-002, AC-011 / TST-001, TST-011 | Sandbox export/cleanup access validation |
| P8-TST-003 | Filtered audit metadata export succeeds with target values, hidden values, posted values, snapshot payloads, and full errors omitted or redacted | AC-011, AC-016 / TST-011 | Sandbox export redaction validation |
| P8-TST-004 | Broad or unfiltered export is blocked or requires explicit filters | AC-011, AC-016 / TST-011 | Sandbox export filter validation |
| P8-TST-005 | Snapshot references in export omit rollback snapshot payloads by default | AC-011, AC-016, AC-022 / TST-011, TST-018 | Sandbox snapshot redaction validation |
| P8-TST-006 | Retention cleanup purges expired snapshot payloads and deletes only expired eligible BCDA-owned operation records | AC-024, AC-025 / TST-020, TST-021 | Sandbox cleanup validation |
| P8-TST-007 | Active requests, pending approvals, incomplete executions, retained rollback dependencies, and cleanup evidence from the same run are protected from cleanup eligibility | AC-025 / TST-021 | Sandbox active-record protection validation |
| P8-TST-008 | Retention cleanup writes retention log evidence with cutoff, expired count, deleted or purged count, result, and sanitized errors | AC-025 / TST-021 | Sandbox cleanup evidence validation |
| P8-TST-009 | Cleanup or export failures write sanitized evidence and do not expose sensitive values | AC-015, AC-016, AC-025 / TST-008, TST-021 | Sandbox cleanup/export failure validation |
| P8-TST-010 | Upgrade validation confirms artificial audit, snapshot, rollback, and retention records remain readable | AC-014 / TST-012 | Sandbox upgrade validation |
| P8-TST-011 | Support evidence package contains only allowed IDs, timestamps, metadata, result, and sanitized errors | AC-011, AC-016 / TST-011 | Sandbox support package validation |
| P8-TST-012 | External APIs remain unavailable at runtime unless access, policy, audit, redaction, tenant, and validation controls explicitly enable them | AC-012, AC-016 / TST-013 | Sandbox external API gate validation |

## Minimum Pre-Release Validation

- `SUPER` access gate passes for `SUPER` and non-`SUPER` users.
- Policy matrix passes.
- Configurable approval requirement and separation passes for no-approval, separate-approver, and self-approval modes.
- One normal table correction passes.
- One posted table correction passes only when explicitly allow-listed.
- Rollback request creation and generated rollback request execution scenarios pass.
- Audit export redaction passes.
- Rollback logging disabled/enabled behavior passes.
- Retention cleanup and retention status pass.
- Required analyzer baseline continues to pass.
- Upgrade from prior package preserves audit data.
