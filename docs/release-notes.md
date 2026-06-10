# Release Notes

## Unreleased

Status: Phase 9 local hardening complete for the current Phase 8 build; local implementation has standing authorization under the SDD; sandbox validation remains required before production use.

### Added

- Business Central AL project manifest.
- Business Central-oriented `.gitignore`.
- SDD documentation package under `docs/`.
- Security review for high-risk hidden and posted data correction behavior.
- Continuous implementation authorization that allows local AL source generation under SDD controls while keeping runtime/production use gated.
- Project-local implementation skills under `.codex/skills/`.
- ADR-003 defining `SUPER`-only access and blocking BCDA-specific permission sets.
- ADR-004 defining configurable rollback snapshot logging and operation retention.
- ADR-006 superseding the original per-phase code gate with standing implementation authorization and runtime gates.
- App design and AL development standards documents.
- Project-local prompt library under `.codex/prompts/`.
- Business Central target updated to version 28.0 with AL runtime 17.0.
- Readiness audit document.
- Phase 6 grouped update execution path with access, metadata, approval/policy, audit, rollback snapshot, and sanitized failure handling.
- `Allow Data Policies` setup field, enabled by default, allowing policy records to be bypassed while preserving permanent runtime controls.
- `Require Ticket Reference` setup field and request-level `Ticket Reference Required` snapshot so standard paperless updates can proceed without external reference evidence when configured.
- Phase 7 rollback service, completed-request rollback action, rollback operation list page, and Role Center links for supported update rollback staging.
- Rollback readiness kickoff document updated for the implemented Phase 7 local scope and sandbox validation queue.
- Phase 8 filtered audit metadata export through `BCDA Audit Export Mgt.` and `BCDA Audit Entries`.
- `Audit Export` audit operation for successful, blocked, and empty export attempts.
- Phase 8 governed retention cleanup through `BCDA Retention Manager` and the `BCDA Setup` cleanup action.
- Audit, retention, and export readiness kickoff document plus operations/deployment handling for Phase 8 sandbox validation.
- Phase 9 local hardening evidence for compile, analyzers, configuration, object range, no-permission-set source scan, and documentation consistency.
- Phase 2 foundation AL objects under `src/`.
- Phase 3 non-mutating security and policy hardening foundation.
- Phase 4 setup, retention, and UX shell foundation.
- Phase 5 target selection and request preview workflow foundation.
- Phase 5 local implementation is complete for non-mutating target selection and request preview; sandbox validation is still pending.
- SUPER runtime access gate using `User Permissions`.IsSuper(UserSecurityId()).
- App-owned setup, policy, request, line, audit, snapshot, rollback operation, and retention log tables.
- Foundation setup, policy, request, line, audit, and retention pages.
- BC Data Agent profile and BCDA Role Center page for convenient access to available foundation tools.
- Correction line table and field lookup pages backed by Business Central metadata.
- Foundation target record lookup that opens from the correction-line `Select Record` action, displays primary-key values, and stores the selected canonical `RecordId`.
- Selected-line current value preview that fills after both `Record ID` and `Field ID` are selected.
- Correction line operation type staging with `Update`, `Rename`, `Delete`, and `Insert`; `Insert` keeps `Record ID` empty and remains staging-only.
- Correction-line proposed-value staging validation for field eligibility, supported scalar field types, text/code length, and type-compatible value text without target mutation.
- Read-only Preview Data Matrix action and temporary matrix page for reviewing staged correction-line data by request, correction type, table, record, and field.
- Same-table batch line builder with RecordId-backed target selection and correction-line creation.
- Foundation service codeunits for setup, access, policy, audit, serialization, orchestration, retention registration, and metadata gating.
- `ruleset.json` with documented `PTE0004` exception for the no-BCDA-permission-set decision.
- Detailed `UserGuide.md` covering foundation behavior, safe setup, policies, correction requests, audit review, retention, troubleshooting, and planned full workflows.
- Configurable approval requirement and separation so the safer default can require a different `SUPER` approver while one-person companies can explicitly disable approval for standard requests or allow self-approval.

### Changed

- Security model now requires the existing Business Central `SUPER` permission set for all functionality.
- BCDA-specific permission set objects are explicitly out of scope and blocked.
- Design now separates mandatory audit metadata from configurable rollback snapshots.
- Operation retention is now user-controlled by category.
- Object planning docs now align to the current `app.json` range 88100-88149.
- `app.json` now references the project logo in `media/BCDataAgent-logo.png`.
- Local launch configuration now starts on the BCDA Role Center page object 88118.
- `app.json` publisher changed from an email address to `AKSA` to satisfy analyzer guidance.
- Code-generation readiness now allows continuous local implementation for future slices while keeping delete, rename, insert execution, non-update rollback, conflict override, unfiltered export, unredacted export, snapshot payload export, and external APIs runtime-gated until controls and validation evidence exist.
- Preview Request now validates staged line shape, refreshes selected current values, evaluates policy, updates line statuses/sanitized messages, updates preview rollback/retention text, and writes preview audit evidence without changing target data.
- Correction line edits now reset preview state to `Open`, delete-line preview confirms the target record can be read, and preview-required approval is blocked until every line is previewed.
- Approval flow changed from hard-coded second-`SUPER` approval to setup-driven separate-approver behavior.
- Request metadata validation now requires a reason for every request and requires a ticket/reference only when the request-level setting requires it.
- Target record selection architecture changed from long-term free-text key entry to a `RecordId`-backed selector with a planned matrix-style correction line editor for complex primary keys.
- Foundation correction, batch buffer, and audit tables now use app-owned `RecordId` storage instead of manually entered record key text.
- Batch Add Lines now opens a same-table RecordId-backed worksheet instead of the old manual record-key path.
- Data policy table and field entry now uses the same metadata-backed lookup/name resolution as correction lines.
- BCDA app-owned tables are now blocked from table lookup, correction line targets, data policy targets, and policy evaluation.
- Approval actions now enforce the submit-before-approve sequence, and the request card enables Execute only for supported executable request states.
- Correction lines now calculate `Current Value Preview` from the selected record and field; Phase 6 grouped update execution refreshes the displayed current value after success.
- Execution groups correction lines by correction type, table, and canonical target identity; insert execution remains blocked until an app-owned insert grouping identity is decided.
- Setup-controlled data policy enforcement bypass is now implemented as `Allow Data Policies`.
- Execution and rollback target writes no longer run inside AL `[TryFunction]` wrappers; validation remains guarded before the write.
- `Export Enabled` now controls filtered audit metadata export instead of acting only as a future flag.
- Hardening readiness now records Phase 9 local completion while keeping production release blocked until sandbox validation.

### Current Boundaries

- Foundation AL code exists and compiles.
- Grouped `Update` target correction behavior exists and compiles.
- Supported rollback staging for completed `Update` correction requests exists and compiles.
- Filtered audit metadata export exists and compiles.
- Governed retention cleanup exists and compiles.
- Phase 9 local hardening passed build, analyzer, config, object-range, access-model, and docs consistency checks.
- `Rename`, `Delete`, and `Insert` execution are not enabled at runtime without operation-specific controls and validation evidence; non-update rollback, conflict override, and rollback without retained snapshots remain runtime-gated.
- Unfiltered export, unredacted export, snapshot payload export, and external APIs remain runtime-gated.
- `Allow Data Policies` can bypass policy records when disabled; permanent runtime blocks remain.
- No external API exists.
- No BCDA-specific permission sets exist or should be generated.
- Rollback snapshot logging and retention setup/storage exists; grouped update execution can capture before/new value snapshots, supported update rollback can create a governed inverse correction request from retained snapshots, and retention cleanup can purge expired snapshot payloads.
- Rich `RecordId`-backed matrix line editing is planned but not implemented; local implementation can proceed, while production reliance requires RecordId/RecordRef sandbox validation.

### Next Release Goals

- Deploy current package to sandbox.
- Verify SUPER/non-SUPER page access behavior.
- Verify target table/field behavior for preview and grouped update execution before production/runtime enablement.
- Verify foundation RecordId lookup behavior for simple and composite keys in sandbox before production use, and before implementing the richer target record matrix selector.
- Validate supported update rollback request creation, generated rollback request preview/execution, snapshot-unavailable, policy-blocked, and non-`SUPER` behavior in sandbox.
- Validate filtered audit export redaction, required filters, setup enablement, and non-`SUPER` blocking in sandbox.
- Validate retention cleanup safety, active request protection, retained rollback dependency protection, and upgrade readability in sandbox.
- Complete sandbox release validation before production use.
