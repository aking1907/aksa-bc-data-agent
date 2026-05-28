# BCDA Readiness Review Prompt

Use this prompt to decide whether implementation can start.

```text
Use $bcda-sdd-steward, $bcda-architecture-guardian, $bcda-security-audit, and $bcda-test-validation.

Perform a code-generation readiness review for BC Data Agent.

Read:
- docs/code-generation-readiness.md
- docs/readiness-audit.md
- docs/sdd-index.md
- docs/open-decisions.md
- docs/security-review.md
- docs/app-design.md
- docs/al-development-standards.md
- docs/requirements.md
- docs/acceptance-criteria.md
- docs/test-plan.md
- docs/traceability-matrix.md when reference coverage is useful

Check whether every readiness blocker is closed:
- BC runtime behavior and sandbox validation.
- Object ID allocation.
- Posted table policy.
- SUPER access enforcement.
- Rollback snapshot logging defaults.
- Retention implementation and minimum periods.
- Sensitive value display/export.
- Analyzer baseline.

If ready, propose the exact update to docs/code-generation-readiness.md.
If not ready, list blockers and the docs that need updates.
Do not generate AL code during the review.
```
