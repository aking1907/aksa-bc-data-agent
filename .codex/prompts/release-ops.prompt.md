# BCDA Release Ops Prompt

Use this prompt for deployment, operations, release notes, or upgrade readiness.

```text
Use $bcda-release-ops and $bcda-security-audit.

Prepare release or operations guidance for:
<describe release/deployment/upgrade/support task>

Read:
- docs/deployment.md
- docs/operations-runbook.md
- docs/upgrade-release-strategy.md
- docs/release-notes.md
- UserGuide.md
- docs/risk-register.md
- docs/security-review.md
- docs/test-plan.md

Check:
- Sandbox-first flow.
- SUPER-only access.
- No BCDA-specific permission sets.
- Setup, policy, rollback logging, retention, and export configuration.
- Audit, rollback, retention cleanup, and upgrade validation.
- Release notes and support escalation package.
- User guide updates for setup, validation, known limitations, and release status.

Return release status, missing gates, deployment steps, rollback/mitigation notes, and docs to update.
```
