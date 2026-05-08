# Test Plan

## Test Types

| Type | Purpose |
| --- | --- |
| Compile validation | Ensure AL package builds for target BC version. |
| SUPER access tests | Confirm only users with the existing Business Central `SUPER` permission set can access functionality. |
| Policy tests | Confirm allow/block/approval decisions. |
| Preview tests | Confirm dry-run does not mutate data. |
| Execution tests | Confirm approved changes succeed and failed changes audit safely. |
| Rollback tests | Confirm before-image restore and conflict detection. |
| Audit tests | Confirm append-only evidence and redaction. |
| Retention tests | Confirm rollback snapshot logging, expiration, cleanup, and retention status. |
| Analyzer tests | Confirm required AL analyzers run after implementation begins. |
| Upgrade tests | Confirm app-owned data remains readable after upgrade. |
| Manual sandbox tests | Validate representative normal, hidden, and posted data scenarios. |

## Scenario Matrix

| Test ID | Scenario | Acceptance |
| --- | --- | --- |
| TST-001 | Non-`SUPER` user cannot open correction pages | AC-002 |
| TST-002 | Foundation metadata lookup pages suggest tables and enabled normal fields; later metadata search shows allowed targets and blocks restricted targets | AC-001, AC-012 |
| TST-003 | Request creation stores required reason and ticket without mutation | AC-003 |
| TST-004 | Preview shows old/new values and warnings without mutation | AC-004 |
| TST-005 | Posted table execution is blocked before approval | AC-005 |
| TST-006 | Approved normal field correction succeeds | AC-006 |
| TST-007 | Approved posted field correction succeeds in sandbox when platform allows | AC-007 |
| TST-008 | Failed execution writes sanitized audit evidence | AC-008, AC-015 |
| TST-009 | Rollback restores previous value when no conflict exists | AC-009 |
| TST-010 | Rollback detects current value conflict and stops | AC-010 |
| TST-011 | Audit export redacts values according to export policy | AC-011, AC-016 |
| TST-012 | Extension upgrade preserves audit readability | AC-014 |
| TST-013 | Future generated objects have traceability coverage | AC-017 |
| TST-014 | Symbol-dependent behavior is documented before use | AC-018 |
| TST-015 | Release candidate passes sandbox correction, rollback, `SUPER` access, audit, export, and upgrade validation | AC-019 |
| TST-016 | Pages, profile navigation, and actions match Business Central-native app design expectations | AC-020 |
| TST-017 | Rollback snapshot logging disabled still writes mandatory audit metadata | AC-021 |
| TST-018 | Rollback snapshot logging enabled stores before-images with expiration dates | AC-022 |
| TST-019 | Expired or purged rollback snapshots block rollback before mutation | AC-023 |
| TST-020 | Retention settings are saved and shown in setup, preview, and retention status | AC-024 |
| TST-021 | Retention cleanup removes expired operation records and preserves active requests | AC-025 |
| TST-022 | Required AL analyzers run and blocking diagnostics are resolved or documented | AC-026 |
| TST-027 | Approval configuration skips approval when disabled, blocks approval before submission, blocks requester approval when separate approval is required, and allows self-approval when configured | AC-027 |
| TST-028 | After RecordId target selection is available, same-table batch entry creates standard correction lines from canonical target record IDs without target preview or mutation | AC-028 |
| TST-029 | Foundation RecordId line-action lookup and later matrix entry support simple and composite primary keys without hand-entered key parsing | AC-029 |
| TST-030 | Selected-line current value preview fills only after `Record ID` and `Field ID` are selected and does not mutate target data | AC-004, AC-016 |

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
- Add automated test codeunits when the test scope is approved and available.
- Validate foundation RecordId lookup in sandbox for representative simple and composite primary keys; add richer matrix selector validation when that readiness gate opens.
- Validate selected-line current value preview in sandbox for representative scalar field types and confirm sensitive values are not exposed outside `SUPER`-gated pages.
- Deploy only to sandbox until release gates pass.

## Integration Validation

Phase 1 integration validation must run against a Business Central sandbox using representative data. Production validation should use a controlled dry-run first and require approval from the business owner.

## Minimum Pre-Release Validation

- `SUPER` access gate passes for `SUPER` and non-`SUPER` users.
- Policy matrix passes.
- Configurable approval requirement and separation passes for no-approval, separate-approver, and self-approval modes.
- One normal table correction passes.
- One posted table correction passes only when explicitly allow-listed.
- Rollback success and rollback conflict scenarios pass.
- Audit export redaction passes.
- Rollback logging disabled/enabled behavior passes.
- Retention cleanup and retention status pass.
- Required analyzer baseline continues to pass.
- Upgrade from prior package preserves audit data.
