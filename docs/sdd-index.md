# SDD Index

BC Data Agent uses the SDD to protect high-risk Business Central data correction work. The process should help development move safely, not make every code change feel like a release audit.

Local AL implementation is authorized by default when the change preserves the core controls below. Runtime or production use still requires sandbox evidence for the behavior being relied on.

## Lean Development Loop

Use this loop for ordinary implementation work:

1. Identify the requested behavior and the affected requirement or acceptance criterion.
2. Implement the smallest safe change in the owning AL object or doc.
3. Run local compile and analyzers when AL changes.
4. Update only the docs that changed behavior, controls, or user/admin workflow.
5. Record sandbox validation only when the behavior is intended for runtime or production reliance.

Do not require broad SDD rewrites, traceability updates, release notes, or runbook edits for every local code change. Use them when they add real evidence or prevent drift.

## Core Controls

Every implementation path must preserve these controls:

- Existing Business Central `SUPER` access is required.
- No BCDA-specific permission set objects.
- No target data mutation without a correction request.
- Policy and required metadata are checked before mutation.
- Audit metadata is append-only and mandatory.
- Rollback creates a governed inverse correction request from retained before-images.
- Sensitive values stay out of logs, exports, telemetry, screenshots, and generic docs.
- Unsupported or unvalidated runtime behavior remains blocked or visibly gated.
- Production use waits for sandbox validation evidence.

## Working Doc Set

For most code changes, start with:

| Doc | Use |
| --- | --- |
| `docs/requirements.md` | Requirement intent and IDs. |
| `docs/acceptance-criteria.md` | Observable behavior to satisfy. |
| `docs/code-generation-readiness.md` | Current implementation authorization and runtime blocks. |
| `docs/implementation-contracts.md` | Object and service ownership when boundaries matter. |
| `docs/test-plan.md` | Validation scenario to add or update when behavior changes. |

Open these only when the change touches the area:

| Area | Docs |
| --- | --- |
| Architecture or object boundaries | `docs/architecture.md`, `docs/adr/` |
| Security, audit, rollback, redaction, posted data | `docs/security-review.md`, `docs/risk-register.md` |
| Setup, pages, actions, user/admin workflow | `UserGuide.md`, `docs/admin-guide.md`, `docs/app-design.md` |
| Deployment, support, release, upgrade | `docs/deployment.md`, `docs/operations-runbook.md`, `docs/upgrade-release-strategy.md`, `docs/release-notes.md` |
| Historical readiness evidence | `docs/readiness-audit.md`, `docs/*-readiness-kickoff.md` |
| Reference coverage | `docs/traceability-matrix.md` |

## Documentation Update Rule

Update docs by impact, not by checklist:

| Change Type | Usually Update |
| --- | --- |
| Behavior or runtime control changes | Requirements or acceptance criteria, plus test plan. |
| Object responsibility or service boundary changes | Implementation contracts, architecture only if the boundary changed. |
| Security, audit, rollback, redaction, or posted-data risk changes | Security review or risk register. |
| Page/action/setup/user workflow changes | User guide or admin guide. |
| Release or production-readiness changes | Deployment, operations, release notes, readiness evidence. |
| Internal refactor with no behavior change | No SDD doc update required beyond comments in code if helpful. |

`docs/traceability-matrix.md` is optional reference material. It is useful before release or when coverage is unclear, but it is not a local implementation gate.

## Readiness Gates

| Gate | Meaning |
| --- | --- |
| Local implementation | Allowed when the core controls remain intact and the behavior aligns with requirements/acceptance criteria. |
| Local validation | AL compile and analyzers pass for AL changes; docs are consistent for behavior changes. |
| Runtime enablement | Feature is not merely present in code; it is available through guarded pages/actions/setup only when controls exist. |
| Production reliance | Sandbox validation covers the representative target data, access, audit, rollback, export, retention, and upgrade scenarios involved. |

## Source Map

The repository still keeps detailed reference docs under `docs/`, but the lean process above determines which ones matter for a given task. When docs conflict, prefer:

1. Requirements and acceptance criteria for what must happen.
2. ADRs for accepted architectural decisions.
3. Code-generation readiness for what may be implemented locally and what remains runtime-gated.
4. User/admin guides for current user-facing behavior.
