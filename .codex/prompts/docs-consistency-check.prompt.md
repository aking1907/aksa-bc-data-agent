# BCDA Docs Consistency Check Prompt

Use this prompt after substantial documentation changes.

```text
Use $bcda-sdd-steward.

Perform a consistency check across the BC Data Agent documentation.

Read:
- docs/sdd-index.md
- docs/project.md
- docs/requirements.md
- docs/acceptance-criteria.md
- docs/architecture.md
- docs/app-design.md
- docs/al-development-standards.md
- docs/data-model.md
- docs/implementation-contracts.md
- docs/test-plan.md
- docs/traceability-matrix.md when reference coverage is useful
- docs/risk-register.md
- docs/code-generation-readiness.md
- docs/readiness-audit.md
- UserGuide.md

Verify:
- No contradictions with higher-order docs.
- AL code has standing local implementation authorization under `docs/code-generation-readiness.md`, while runtime and production enablement remain controlled.
- No BCDA-specific permission sets are planned.
- Mandatory audit metadata cannot be disabled.
- Rollback snapshots are configurable and retention-aware.
- Every requirement has acceptance/test coverage.
- Open decisions are named.
- Release/deployment/operations docs reflect user/admin behavior.
- UserGuide.md reflects the current foundation behavior and readiness boundaries.

Fix documentation drift directly when safe. End with changed files, unresolved questions, and readiness status.
```
