---
name: bcda-security-audit
description: Security, audit, SUPER access, redaction, and rollback risk review for BC Data Agent. Use when a task touches hidden data, posted data, SUPER-only access, approval, sensitive values, audit entries, rollback snapshots, exports, telemetry, logs, production deployment, or any Business Central data mutation path.
---

# BCDA Security Audit

## Purpose

Treat BC Data Agent as a break-glass correction tool. Prevent unauthorized, unapproved, untraceable, or irreversible changes to Business Central data.

## Required Reading

Read:

- `docs/security-review.md`
- `docs/risk-register.md`
- `docs/requirements.md`
- `docs/acceptance-criteria.md`
- `docs/architecture.md`
- `docs/data-model.md`
- `docs/operations-runbook.md`

## Security Invariants

- No target data change without a correction request.
- No execution without policy approval.
- No posted data change without existing Business Central `SUPER` access and approval by default; approval separation is configurable and self-approval must be explicit.
- No mutation path that bypasses audit.
- No configuration may disable mandatory audit metadata.
- No rollback that deletes or rewrites original audit evidence.
- No rollback snapshot disabling without preview visibility and confirmation.
- No sensitive value leakage through logs, telemetry, exports, screenshots, or tests.
- No production enablement before sandbox validation.

## Review Areas

Check:

- `SUPER`-only access boundaries.
- Absence of BCDA-specific permission set objects.
- Table and field allow/block policy.
- Approval workflow for high-risk changes.
- Sensitive value storage, display, export, and retention.
- Rollback snapshot logging mode and expiration.
- Operation retention categories and cleanup safety.
- Audit immutability and completeness.
- Rollback conflict behavior.
- Sanitized error handling.
- Upgrade impact on audit and snapshots.

## Risk Response

When a risk is found:

1. Name the requirement or acceptance criterion affected.
2. Add or update a risk in `docs/risk-register.md`.
3. Add a mitigation in architecture, implementation contracts, or test plan.
4. Block implementation if the issue could allow untraceable or unauthorized mutation.

## Redaction Guidance

- Show full values only through `SUPER`-gated features and policy-approved channels.
- Use display values carefully; captions and keys can still be sensitive.
- Prefer hashes or value references for correlation.
- Keep test fixtures artificial.

## Output Standard

Lead with findings ordered by severity. Include file references, affected requirements, required mitigations, and whether the change is safe to continue.
