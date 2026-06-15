# Readiness Audit

## Audit Status

Current result: Phase 9 local hardening is complete for the current Phase 8 build, and the SDD now allows continuous local implementation without per-phase paper confirmation. Local compile/analyzer/config/security/docs evidence exists for foundation RecordId lookup, selected-line current value preview, request-level staged-line preview, correction operation type staging, preview-required approval gating, BCDA app-owned target blocking, `Allow Data Policies` setup behavior, grouped update mutation, primary-key rename mutation, record-level delete mutation, grouped insert mutation, audit evidence, rollback snapshot capture, request-level rollback staging, generated rollback request current-value review, rollback operation records, append-only rollback audit evidence, correction request Excel export/import, filtered audit metadata export, audit export evidence, governed retention cleanup, object-range alignment, and the no-BCDA-permission-set rule.

OD-018 insert grouping is implemented with app-owned `Insert Group No.`: staged `Insert` lines keep `RecordId` empty, each request/table/insert-group requires staged primary-key fields, rollback remains unavailable, and each created-record identity is captured after successful execution. OD-019 setup-controlled data policy enforcement is implemented through `Allow Data Policies`.

The ASAP execution-readiness track in `docs/execution-readiness-kickoff.md` now tracks final sandbox validation for Phase 6 execution.

The Phase 6 repository-side readiness packet has moved to final sandbox validation evidence. Test scenarios are final validation evidence, not a pre-code gate.

The Phase 7 rollback implementation is recorded in `docs/rollback-readiness-kickoff.md`. Sandbox validation is still required before production use.

The Phase 8 audit, retention, and export implementation is recorded in `docs/audit-retention-export-readiness-kickoff.md`. Sandbox validation was skipped by request for implementation and remains required before production use.

The SDD package is structurally complete. The project moved from Phase 4 setup, retention, and UX shell work through Phase 5 target selection into Phase 6 supported grouped update, primary-key rename, record-level delete, and grouped insert execution, Phase 7 supported update rollback, Phase 8 export/cleanup, and Phase 9 local hardening. Additional code development may proceed under the standing authorization, while mutation, rollback, export, and cleanup sandbox validation still need to be completed before production use.

## What Is Ready

| Area | Result |
| --- | --- |
| SDD source map | Complete in `docs/sdd-index.md`. |
| Business scope | Documented in `docs/project.md`. |
| Requirements | `REQ-001` through `REQ-036` exist. |
| Acceptance criteria | `AC-001` through `AC-037` exist. |
| Test plan | `TST-001` through `TST-041` exist. |
| Traceability matrix | Available as optional reference material; it is not a readiness blocker. |
| ADRs | Five accepted ADRs cover workflow, SDD gate, SUPER-only access, rollback/retention, and RecordId target selection. |
| App design | Business Central-native UX direction documented. |
| AL standards | Microsoft-aligned analyzers, coding, retention, and performance standards documented. |
| Skills and prompts | Project-local guardrails exist under `.codex/skills/` and `.codex/prompts/`. |
| Manifest target | `app.json` targets Business Central 28.0 / AL runtime 17.0. |
| Object range | `app.json` and planning docs align to 88100-88149. |
| Object ID conflict check | Local symbol scan found no Microsoft symbol objects in object range 88100..88149. |
| App logo | `app.json` references `media/BCDataAgent-logo.png`. |
| BC 28 symbol packages | `.alpackages/` contains target Business Central 28 package files. |
| SUPER API evidence | Public `User Permissions`.IsSuper(UserSecurityId()) availability is reflected in implemented access checks and local compile validation. |
| Retention API evidence | Public `Reten. Pol. Allowed Tables` availability is reflected in retention manager compile validation. |
| Phase 5 local implementation | Complete for non-mutating target selection, selected-field current value refresh, request staged-line preview, policy preview, preview audit, and read-only preview matrix behavior. Sandbox validation pending. |
| Phase 6 local implementation | Complete for grouped `Update` execution, supported record-level `Delete` execution, supported grouped `Insert` execution, policy/access re-checks, `Allow Data Policies`, audit evidence, rollback snapshots for supported updates when enabled or required, rollback-unavailable status for delete/insert, and sanitized failure handling. Sandbox validation pending. |
| Phase 7 local implementation | Complete for request-level rollback staging from completed `Update` requests with retained snapshots, generated rollback correction requests, rollback operation records, and append-only audit evidence. Sandbox validation pending. |
| Phase 8 local implementation | Complete for correction request Excel export/import, filtered audit metadata export, and governed cleanup of expired eligible BCDA-owned operation records. Sandbox validation pending. |
| Phase 9 local hardening | Complete for compile, analyzers, configuration, object range, permission-set source scan, and documentation consistency. Sandbox validation pending. |

## What Is Not Ready

| Blocker | Why It Blocks Code |
| --- | --- |
| Posted/protected table behavior not verified | Execution depends on what BC allows safely through AL. |
| RecordId/RecordRef target record selection and selected-field read behavior not verified in sandbox | Foundation target record line-action lookup and selected-line current value preview compile locally, but representative simple/composite key behavior, field type behavior, sensitive-value handling, and non-`SUPER` behavior still need sandbox validation before production use and before matrix line entry. |
| Field type support not verified | Value serialization and rollback execution depend on type behavior. |

## Consistency Checks Performed

| Check | Result |
| --- | --- |
| `app.json` parses as valid JSON | Passed. |
| Previous target/runtime references | None found in docs or config. |
| Previous object range references | None found in docs or config. |
| AL source files | Foundation AL source exists under `src/`; local compile and analyzer validation passed. Sandbox deployment validation is still pending. |
| Symbol packages | BC 28 package files found in `.alpackages/`. |
| Foundation AL compile | Passed with AL compiler 17.0.34.45391 against BC 28 symbols. |
| Foundation analyzer pass | Passed with CodeCop, UICop, and PerTenantExtensionCop using `ruleset.json`. |
| Requirement and acceptance alignment | Passed for current documentation. |
| Acceptance-to-test coverage | Passed for current documentation. |
| Execution readiness kickoff | Complete for local implementation; final sandbox validation remains. |
| Phase 6 implementation | Passed local compile for grouped update, primary-key rename, record-level delete, and grouped insert execution. |
| OD-018/OD-019 decision blocker | Passed; app-owned insert grouping and policy-bypass behavior are implemented locally. |
| Phase 7 implementation | Passed local compile/analyzer validation for supported update rollback. |
| Rollback readiness kickoff | Complete locally in `docs/rollback-readiness-kickoff.md`; production use remains blocked until sandbox rollback success, conflict, snapshot, access, and policy validation are complete. |
| Phase 8 implementation | Passed local compile/analyzer validation for correction request Excel export/import, filtered audit export, and retention cleanup. |
| Audit, retention, and export readiness kickoff | Complete locally in `docs/audit-retention-export-readiness-kickoff.md`; production use remains blocked until redaction, cleanup safety, upgrade, and sandbox release validation are complete. |
| Phase 9 local hardening | Passed local build, analyzer, app manifest, object range, no-permission-set, and documentation consistency checks. |
| Project skill structure | Manual validation passed. |
| Placeholder markers | None found in project docs/prompts/skills. |

## Required Next Actions

1. Deploy the current package to sandbox and verify setup/policy/request/audit pages.
2. Verify SUPER and non-SUPER access behavior in sandbox.
3. Verify RecordId/RecordRef target record selection, formatting, display-key behavior, and selected-field current value preview for simple and composite primary keys.
4. Verify representative normal, hidden, posted, and protected table behavior in sandbox before production use.
5. Verify Phase 1 scalar field type support and blocked field types for execution.
6. Complete sandbox-backed readiness updates before production export, production cleanup, non-update rollback, conflict override, policy-bypass production use, or production release.
7. Complete Phase 6 sandbox validation before production use.
8. Complete Phase 7 rollback sandbox validation before production use.
9. Complete Phase 8 audit/retention/export sandbox validation before production support-export or cleanup use.
10. Update runtime readiness evidence before opening production target selection/current value preview, matrix entry, execution, rollback, export, cleanup, or production gates.

## Recommendation

Continue with sandbox validation for Phase 6 grouped update execution, supported primary-key rename execution, supported record-level delete execution, supported grouped insert execution, Phase 7 supported update rollback, and Phase 8 request workbook export, filtered audit export, and cleanup. Rename/delete/insert rollback, broader non-update rollback, conflict override, unfiltered export, unredacted export, snapshot payload export, validate-trigger dry-run, external APIs, and broader target matrix editing may be implemented locally, but runtime/production use remains blocked until their applicable implementation contracts, controls, sandbox validation, and runtime readiness evidence are complete.
