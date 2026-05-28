# Code Generation Readiness

## Current Status

Ready through Phase 9 local hardening for the current Phase 8 build. Phase 5 target selection and preview workflow is complete, Phase 6 includes grouped `Update` execution with policy/access re-checks, mandatory audit evidence, rollback snapshot capture when enabled or required, sanitized failures, and the `Allow Data Policies` setup switch, Phase 7 includes rollback for successful Phase 6 `Update` execution audit entries, Phase 8 includes filtered audit metadata export plus governed cleanup for expired BCDA-owned operation records, and Phase 9 local build/config/security/docs hardening is complete.

The project has moved to the next allowed phase. AL generation is allowed for Phase 2 foundation objects, Phase 3 security and policy hardening, Phase 4 setup/retention/UX shell work, Phase 5 target selection and preview workflow, Phase 6 grouped update execution, Phase 7 supported update rollback, and Phase 8 filtered audit metadata export and retention cleanup.

Mutation behavior is implemented only for supported grouped `Update` correction lines, rollback of successful supported `Update` execution audit entries, and cleanup of expired BCDA-owned operation records. `Rename`, `Delete`, `Insert`, operation-aware rollback for non-update corrections, conflict override, unfiltered export, unredacted export, snapshot payload export, external APIs, and validate-trigger dry-run behavior remain blocked until their operation-specific contracts are implemented and validated.

The ASAP execution-readiness track in `docs/execution-readiness-kickoff.md` is complete for local implementation and now feeds final sandbox validation.

OD-018 insert grouping remains deferred until insert execution behavior is implemented. OD-019 is implemented as the `Allow Data Policies` setup field: when off, policy records are bypassed, but BCDA app-owned tables, unsupported fields, non-`SUPER` access, missing request metadata, unaudited mutation, and rollback snapshot controls remain blocked or enforced.

The repository-side Phase 6 documentation now tracks final sandbox validation. Test scenarios are final validation evidence after implementation.

The Phase 7 rollback implementation is recorded in `docs/rollback-readiness-kickoff.md`. It opens only the supported `Update` rollback slice and still requires sandbox validation before production use.

The Phase 8 audit, retention, and export implementation is recorded in `docs/audit-retention-export-readiness-kickoff.md`. Sandbox validation was skipped by explicit user instruction for this implementation pass, so it remains production-release evidence rather than a code-generation blocker.

The Phase 9 hardening request is recorded in `docs/hardening-release-readiness-kickoff.md`. Local hardening is complete for the currently implemented Phase 8 build.

## Required Docs To Read Before Generation

1. `docs/sdd-index.md`
2. `docs/project.md`
3. `docs/requirements.md`
4. `docs/domain-model.md`
5. `docs/architecture.md`
6. `docs/app-design.md`
7. `docs/al-development-standards.md`
8. `docs/adr/README.md`
9. `docs/open-decisions.md`
10. `docs/data-model.md`
11. `docs/acceptance-criteria.md`
12. `docs/implementation-contracts.md`
13. `docs/security-review.md`
14. `docs/test-plan.md`
15. `docs/readiness-audit.md`
16. `docs/execution-readiness-kickoff.md`
17. `docs/rollback-readiness-kickoff.md`
18. `docs/audit-retention-export-readiness-kickoff.md`
19. `docs/hardening-release-readiness-kickoff.md`

## Allowed Now

- Documentation updates.
- Project configuration review.
- Sandbox validation planning.
- Security review refinement.
- App design refinement.
- Requirement and acceptance refinement.
- Phase 2 Foundation Data AL objects in the object range 88100-88149.
- Phase 3 Security And Policy AL hardening in the object range 88100-88149 when it is non-mutating and preserves current readiness boundaries.
- Phase 4 Setup, Retention, And UX Shell AL hardening in the object range 88100-88149 when it is non-mutating and preserves current readiness boundaries.
- Phase 5 Target Selection And Preview Workflow AL in the object range 88100-88149 when it reads only selected target identities/fields, stores results only in BCDA-owned records, and preserves current mutation boundaries.
- Phase 6 grouped `Update` execution in the object range 88100-88149 when it re-checks `SUPER`, request metadata, approval, data policy settings, field eligibility, and target record identity immediately before mutation.
- `Allow Data Policies` setup behavior. When it is off, policy records do not participate in execution decisions, but BCDA app-owned tables, unsupported fields, non-`SUPER` access, missing request metadata, audit, and rollback snapshot rules remain enforced.
- SUPER runtime gate using the verified public `User Permissions`.IsSuper(UserSecurityId()) API.
- Business Central retention policy allowed-table registration shell for BCDA-owned operation tables.
- Setup page, policy page, request list/card, correction line, retention log, Role Center, and profile UX refinement that improves discoverability, validation guidance, action availability, and safe status visibility without enabling target writes.
- Retention setup/status behavior for BCDA-owned operation tables, including visible retention periods, registration/status guidance, and governed cleanup of expired eligible operation records.
- Phase 7 supported `Update` rollback from successful execution audit entries. Rollback requires retained old/new snapshots, matching current target value, `SUPER`, policy re-check, and append-only rollback audit evidence.
- Phase 8 filtered audit metadata export. Export requires `SUPER`, the `Export Enabled` setup flag, and at least one filter by request, company, occurred-at date/time, operation, or result. The CSV omits target record identity text and rollback snapshot payload values.
- Phase 8 retention cleanup for BCDA-owned operation records. Cleanup purges expired rollback snapshot payloads, deletes eligible expired audit metadata, rollback operation, and retention log records, preserves active requests and retained rollback dependencies, and writes retention log evidence.
- App-owned `RecordId` storage fields for correction, batch buffer, and audit metadata.
- Foundation table and field metadata lookup for request entry using verified virtual metadata tables. This may suggest table IDs and enabled normal field IDs.
- Foundation target-table safety guard that blocks BC Data Agent app-owned tables in correction lines, batch staging, data policies, table lookup, and policy evaluation. This must not implement target record writes.
- Policy evaluation hardening for deny-first behavior, approval-required signaling, user-facing block reasons, BCDA app-owned table permanent blocks, and setup-controlled policy-record bypass.
- Redaction and sanitized-error hardening for app-owned audit/status data. This must not expose full sensitive target values in telemetry, generic logs, exports, or unauthorized channels.
- SUPER access guard strengthening on BCDA pages and services using the verified public API. This must not create BCDA-specific permission set objects.
- Foundation `RecordId` line-action lookup that reads primary-key fields only through `RecordRef`, lists a limited set of records for the selected table, and stores the selected canonical `RecordId`. It must not mutate target records.
- Foundation selected-line current value preview that reads only the selected `Record ID` and `Field ID` through `RecordRef`/`FieldRef` and stores a formatted display value on the app-owned correction line. It must not mutate target records or perform full request dry-run validation.
- Request-level non-mutating preview that validates staged line shape, refreshes selected current values, evaluates policy, updates line statuses/sanitized messages, and writes preview audit evidence. It must not write target records, invoke target validate triggers, create rollback snapshots, or execute changes.
- Foundation correction operation type staging on app-owned correction lines and batch buffers using `Update`, `Rename`, `Delete`, and `Insert`. `Insert` keeps `Record ID` empty and does not open target record lookup. Phase 6 executes grouped `Update` lines only; other operation types are audited as blocked during execution. Phase 7 rolls back only successful `Update` execution audit entries.
- Foundation proposed-value staging validation that uses verified `Field` metadata and AL `Evaluate` parsing to block disabled, non-normal, primary-key, system-managed, removed, unsupported-type, length-invalid, or scalar type-incompatible correction line values. It must not write target records or run full validate-trigger dry-run behavior.
- Foundation read-only correction-line matrix preview that uses BCDA-owned request line data to group staged data by request, table, record, and field. It must not read arbitrary target data, write target records, or perform full request dry-run validation.
- Foundation same-table batch scaffolding as app-owned buffer/page/service code. Request-card access to the builder may exist, but builder line creation must remain blocked until batch `RecordId` selection or target matrix entry supplies canonical target identities.

## Blocked Now

- Creating BCDA-specific permission set AL objects is permanently blocked by ADR-003.
- Implementing rollback for `Rename`, `Delete`, `Insert`, conflict override, or source operations without retained snapshots.
- Implementing operation-aware execution or rollback for `Rename`, `Delete`, or `Insert`.
- Implementing validate-trigger dry-run behavior, target write rehearsal, or execution confirmation preview.
- Implementing the full target record matrix selector, arbitrary target filtering/search, or batch RecordId selection beyond the existing limited selector until `RecordId`/`RecordRef` sandbox behavior is validated.
- Implementing unfiltered audit export, unredacted export, snapshot payload export, or export through external APIs.
- Implementing cleanup of active requests, pending approvals, incomplete executions, retained rollback dependencies, or target Business Central business data.
- Adding external API endpoints.
- Adding sample data that resembles real customer data.

## Required Runtime Validation

- Confirm BC 28.0 symbols are inspected for the specific APIs, objects, and platform behaviors used by generated code.
- Confirm no object ID conflicts for range 88100-88149.
- Confirm default policy for posted tables.
- Confirm field type support for Phase 1.
- Confirm approval model among `SUPER` users.
- Confirm rollback snapshot retention.
- Confirm sensitive value display and export rules.
- Confirm rollback snapshot logging defaults and policy overrides.
- Confirm `Allow Data Policies` behavior in sandbox and verify BCDA app-owned, system-managed, unsupported, unaudited, and non-`SUPER` mutation paths remain blocked when policy records are bypassed.
- Confirm operation retention implementation and minimum retention periods.
- Confirm analyzer baseline and deployment target cop.

## Decisions Closed For Current Phase Code

- OD-003 Default posted table policy: deny until explicitly allow-listed.
- OD-004 Approval model among `SUPER` users: approval with a separate `SUPER` approver is the safer default, but setup can disable approval for standard requests or allow self-approval for one-person companies that accept the control tradeoff.
- OD-005 Validation mode: per-policy with validate-trigger default.
- OD-006 Field type support: scalar fields first; BLOB/media deferred.
- OD-007 Rollback conflict policy: stop on conflict by default.
- OD-008 Audit retention: configurable with conservative default.
- OD-011 Sensitive value display: SUPER-only UI with export/log redaction.
- OD-013 `SUPER` access enforcement: runtime `User Permissions`.IsSuper(UserSecurityId()) plus no BCDA permission sets.
- OD-014 Default rollback snapshot logging: policy controlled, required for posted/high-risk defaults.
- OD-015 Operation retention implementation: prefer BC native retention policies for BCDA-owned tables.
- OD-016 Minimum retention periods: foundation defaults captured in setup; release minimums require explicit setup guidance and sandbox validation.

## Decisions Deferred Outside Phase 6 Start

- OD-018 Insert grouping identity: deferred until insert execution behavior is needed.

## Remaining Validation And Next-Phase Blockers

- Representative normal, hidden, posted, and protected table write behavior must be verified in sandbox before production use.
- Foundation RecordId lookup, composite key display, selected-field preview, request-level staged-line preview, and later matrix selector behavior must be verified in sandbox.
- Field type serialization must be verified against target field classes and unsupported types.
- Phase 6 sandbox validation must be completed for release evidence.
- Phase 7 rollback sandbox validation must be completed before production use.
- Export redaction policy, retention cleanup safety, active-record protection, and upgrade readability must be verified in sandbox before production use of Phase 8.
- Phase 8 audit/retention/export sandbox validation was skipped for implementation by request and remains required before release.
- Phase 9 local hardening is complete for the current Phase 8 build.
- Production policy must be backed by sandbox release validation and an updated readiness gate.

## Fast Track To Execution Code

Use `docs/execution-readiness-kickoff.md` as the final sandbox validation queue. Phase 6 execution code keeps `SUPER`, request metadata, policy behavior or configured policy-record bypass, mandatory audit metadata, rollback snapshot behavior, and sanitized failure handling intact. Test scenarios are final validation evidence.

Use `docs/rollback-readiness-kickoff.md` for the Phase 7 local implementation and sandbox validation queue. Rollback implementation requires retained before-image snapshots, stops on conflict by default, re-checks policy immediately before rollback, appends rollback audit evidence, and sanitizes failure handling. Rename, delete, insert rollback, conflict override, posted/protected rollback, and policy bypass remain separately gated unless explicitly implemented with controls.

Use `docs/audit-retention-export-readiness-kickoff.md` for the Phase 8 local implementation and sandbox validation queue. Phase 8 includes `SUPER`-gated, setup-enabled, filtered audit metadata export and governed cleanup for expired BCDA-owned operation records. Unredacted export, snapshot payload export, external APIs, and cleanup of active records remain blocked.

Use `docs/hardening-release-readiness-kickoff.md` for Phase 9 local hardening evidence and the remaining sandbox release queue.

## Definition Of Done For Generated Code

Generated code is done only when:

- It implements the requested behavior.
- It compiles.
- It has tests or a documented manual validation scenario after implementation.
- It preserves audit and rollback invariants.
- It does not expose sensitive values through logs, telemetry, or unauthorized pages.
- It follows `docs/al-development-standards.md` and passes required analyzers.
- It preserves mandatory audit metadata even when rollback snapshots are disabled.
- It updates docs when behavior changes.

## Foundation Validation Evidence

- Foundation AL compile passed with AL compiler 17.0.34.45391 against downloaded BC 28 symbols.
- Analyzer pass passed with CodeCop, UICop, and PerTenantExtensionCop using `ruleset.json`.
- Current foundation compile includes the BCDA Role Center page and `BC Data Agent` profile navigation.
- Current foundation compile includes correction line table/field lookup pages backed by `AllObjWithCaption` and `Field` metadata.
- Current foundation compile includes a metadata and policy guard that blocks BC Data Agent app-owned tables from correction targets and data policy targets.
- Current foundation compile includes a SUPER-gated target record lookup that opens from `Select Record` and uses `RecordRef`, primary-key `KeyRef`/`FieldRef` display, `RecordId`, and `RecordId.TableNo()` validation to populate correction-line `Record ID`.
- Current foundation compile includes selected-line current value preview using `RecordRef.Get(RecordId)`, `RecordRef.Field(FieldId)`, and `FieldRef.Value()` for the selected record and field.
- Current foundation compile includes request-level non-mutating preview that validates staged line shape, refreshes selected current values, evaluates policy, updates line statuses/sanitized messages, and writes preview audit evidence.
- Current foundation compile includes preview-state reset after correction line edits, delete-line target-existence preview, and preview-required submit/approve gating that requires every line to be previewed.
- Current foundation compile includes correction operation type staging on correction lines and batch buffers, including the rule that `Insert` lines keep `Record ID` empty.
- Current foundation compile includes proposed-value staging validation using `Field` metadata, primary-key and obsolete-state checks, supported scalar field-type checks, text/code length checks, and AL `Evaluate` parsing.
- Current foundation compile includes a read-only temporary preview data matrix page opened from correction lines and populated from stored correction-line data for the current request.
- Current foundation compile includes same-table batch storage/page/service scaffolding, with builder line creation paused until batch RecordId selection or target matrix entry is implemented.
- Current foundation compile includes Phase 8 filtered audit metadata export and retention cleanup code.
- `PTE0004` is intentionally suppressed because ADR-003 forbids BCDA-specific permission set objects.
- Local symbol scan found no Microsoft symbol objects in object range 88100..88149.
- 2026-05-28 local compile validation passed after Phase 6 execution implementation with AL compiler 17.0.34.45391 against 48 project files.
- 2026-05-28 local compile and analyzer validation passed after Phase 8 implementation with AL compiler 17.0.34.45391 against 51 project files.
- 2026-05-28 Phase 9 local hardening passed compile, analyzers, app manifest/config review, object-range review, no-permission-set source scan, and documentation consistency scan for the current Phase 8 build.
