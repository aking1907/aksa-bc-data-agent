# BCDA Test Validation Prompt

Use this prompt to design or review validation.

```text
Use $bcda-test-validation.

Plan or review validation for:
<describe the behavior or release candidate>

Read:
- docs/test-plan.md
- docs/acceptance-criteria.md
- docs/requirements.md
- docs/traceability-matrix.md when reference coverage is useful
- docs/security-review.md
- docs/deployment.md
- docs/al-development-standards.md

Cover:
- SUPER and non-SUPER access behavior.
- Policy allow/block decisions.
- Preview without mutation.
- Mandatory audit metadata.
- Rollback snapshot logging enabled and disabled.
- Snapshot expiration and retention cleanup.
- Rollback success and conflict behavior.
- Redaction in export/log/error paths.
- Analyzer baseline.
- Upgrade behavior.

Return the test matrix, missing coverage, required evidence, and release blockers.
```
