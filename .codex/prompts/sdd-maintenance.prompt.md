# BCDA SDD Maintenance Prompt

Use this prompt when changing requirements, decisions, scope, or behavior.

```text
Use $bcda-sdd-steward.

I need to update the BC Data Agent SDD for this change:
<describe the requested change>

Read the SDD source order in docs/sdd-index.md, then update all affected documents together:
- docs/project.md
- docs/requirements.md
- docs/domain-model.md
- docs/app-design.md
- docs/architecture.md
- docs/adr/ when a material decision changes
- docs/open-decisions.md
- docs/data-model.md
- docs/acceptance-criteria.md
- docs/implementation-contracts.md
- docs/implementation-plan.md
- docs/code-generation-readiness.md
- docs/test-plan.md
- docs/traceability-matrix.md
- docs/risk-register.md
- docs/deployment.md and docs/operations-runbook.md if admin/user behavior changes
- UserGuide.md when user-facing behavior, setup, page actions, validation steps, release guidance, or readiness scope changes

Keep the current boundary: AL code is allowed only within the exact scope approved by `docs/code-generation-readiness.md`.

End with changed files, readiness status, and remaining blockers.
```
