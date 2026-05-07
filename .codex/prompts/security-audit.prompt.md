# BCDA Security Audit Prompt

Use this prompt for any high-risk behavior, posted data change, retention decision, or rollback design.

```text
Use $bcda-security-audit.

Review this BC Data Agent change for security and audit risk:
<describe the change>

Read:
- docs/security-review.md
- docs/risk-register.md
- docs/requirements.md
- docs/acceptance-criteria.md
- docs/architecture.md
- docs/data-model.md
- docs/app-design.md
- docs/operations-runbook.md

Check:
- SUPER-only access.
- No BCDA-specific permission sets.
- Mandatory audit metadata.
- Rollback snapshot logging visibility and safety.
- Retention periods and cleanup safety.
- Posted/hidden data risk.
- Redaction in UI, exports, logs, telemetry, tests, and errors.
- Rollback conflict behavior.

Lead with findings by severity. Include required mitigations, affected requirements, and whether work is safe to continue.
```

