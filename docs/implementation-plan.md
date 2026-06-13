# Implementation Plan

## Development Rules

- Build the requested behavior in the owning service/page/table, not in process paperwork.
- Preserve the BCDA core controls: `SUPER`, request workflow, policy, audit, rollback, redaction, and validation boundaries.
- Keep pages thin; put workflow and mutation logic in codeunits.
- Compile and run analyzers for AL changes.
- Update docs only when behavior, risk, user workflow, or release readiness changes.

## Daily Development Flow

1. Read the requirement or acceptance criterion that matches the request.
2. Inspect the existing AL objects and local patterns.
3. Make the smallest safe implementation change.
4. Run compile/analyzers.
5. Update targeted docs only if the behavior changed.
6. Leave sandbox validation as a release-readiness item unless the task is specifically validation work.

## When To Update Which Doc

| Situation | Update |
| --- | --- |
| Requirement or observable behavior changes | `docs/requirements.md` or `docs/acceptance-criteria.md` |
| Procedure ownership or object boundary changes | `docs/implementation-contracts.md`; `docs/architecture.md` only when the design changed |
| Security, posted data, audit, rollback, redaction, export, retention risk changes | `docs/security-review.md` or `docs/risk-register.md` |
| Page/action/setup/admin workflow changes | `UserGuide.md` or `docs/admin-guide.md` |
| Test or sandbox expectation changes | `docs/test-plan.md` |
| Release/deployment/support changes | `docs/deployment.md`, `docs/operations-runbook.md`, or `docs/release-notes.md` |
| Internal refactor only | No process doc update required |

`docs/traceability-matrix.md` can be updated before release or when coverage is unclear. It is not required for every local change.

## Current Runtime Slices

| Slice | Local Status | Production Status |
| --- | --- | --- |
| Target selection and preview | Implemented | Sandbox validation pending before reliance |
| Grouped `Update` execution | Implemented | Sandbox validation pending before reliance |
| Primary-key `Rename` execution | Implemented | Sandbox validation pending before reliance; rollback unavailable |
| Record-level `Delete` execution | Implemented | Sandbox validation pending before reliance; rollback unavailable |
| Grouped `Insert` execution | Implemented | Sandbox validation pending before reliance; rollback unavailable; one new record per request/table/Insert Group No. |
| Request-level rollback staging | Implemented | Sandbox validation pending before reliance |
| Filtered audit metadata export | Implemented | Sandbox validation pending before reliance |
| Retention cleanup | Implemented | Sandbox validation pending before reliance |
| Rename/delete/insert rollback, broader non-update rollback, conflict override, APIs, unredacted export | Runtime-gated | Not production-ready |

## Local Done

- Code compiles.
- Required analyzers pass or documented exceptions exist.
- Access, policy, audit, rollback, and redaction controls are preserved.
- Changed behavior has focused validation coverage or a manual validation note.
- Only relevant docs were updated.

## Production Ready

Production readiness is a separate release decision. It requires sandbox evidence for the affected access, policy, execution, rollback, audit, export, retention, and upgrade paths.
