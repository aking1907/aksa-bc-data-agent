---
name: bcda-release-ops
description: Deployment, operations, upgrade, and release governance for BC Data Agent. Use when preparing Business Central sandbox or production deployment, install steps, setup checks, release notes, rollback planning, hotfixes, support runbooks, admin guidance, upgrade validation, or operational readiness.
---

# BCDA Release Ops

## Purpose

Move BC Data Agent through sandbox-first release gates with clear operational evidence. Production enablement must be deliberate because the extension can change hidden and posted data.

## Required Reading

Read:

- `docs/deployment.md`
- `docs/operations-runbook.md`
- `docs/upgrade-release-strategy.md`
- `docs/release-notes.md`
- `UserGuide.md`
- `docs/risk-register.md`
- `docs/security-review.md`
- `docs/test-plan.md`

## Release Principles

- Sandbox first.
- Dry-run before production correction.
- Human approval for posted data policy.
- Audit and rollback validation before release.
- Rollback logging and retention validation before release.
- Extension rollback is not a substitute for data rollback.
- Release notes and `UserGuide.md` must describe security, `SUPER` access, data model, and known risk changes.

## Deployment Checklist

Verify:

- Target BC version and symbols.
- Package version.
- `SUPER`-only access plan.
- Confirmation that no BCDA-specific permission sets are created or assigned.
- Setup and policy configuration.
- Rollback snapshot logging configuration.
- Audit, snapshot, and technical log retention configuration.
- Audit and snapshot retention.
- External backup or environment restore plan.
- Sandbox test evidence.
- Business owner approval for production.

## Operations Checklist

Prepare:

- Setup checks.
- Health check workflow.
- Support escalation package.
- Troubleshooting categories.
- Safe logging guidance.
- First-production-correction supervision plan.

## Upgrade Checklist

Verify:

- Existing audit entries remain readable.
- Existing snapshots remain readable or are migrated.
- `SUPER` access policy changes are documented.
- New policies default to safe values.
- Rollback behavior remains compatible.
- Retention categories and expiration dates remain compatible.

## Output Standard

Produce release status, missing gates, deployment steps, rollback or mitigation notes, and release-note/user-guide updates.
