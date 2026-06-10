---
name: bcda-test-validation
description: Test planning and validation for BC Data Agent. Use when creating or reviewing tests, manual validation scripts, acceptance coverage, sandbox validation, SUPER access checks, policy checks, correction scenarios, rollback scenarios, audit behavior, export redaction, upgrade validation, or release evidence.
---

# BCDA Test Validation

## Purpose

Prove the governed correction workflow works and that unsafe paths are blocked. Tests must map back to requirements and acceptance criteria.

## Required Reading

Read:

- `docs/test-plan.md`
- `docs/acceptance-criteria.md`
- `docs/requirements.md`
- `docs/traceability-matrix.md` when reference coverage is useful
- `docs/security-review.md`
- `docs/deployment.md`

## Coverage Rules

- Every requirement needs acceptance coverage.
- Every acceptance criterion needs at least one test or manual validation scenario.
- Every mutation behavior needs success, failure, `SUPER` access, audit, and rollback coverage.
- Posted data scenarios must run in sandbox first.
- Upgrade tests must protect audit and snapshot readability.

## Scenario Categories

Create or review tests for:

- Unauthorized access denied.
- Policy allow/block decisions.
- Dry-run preview without mutation.
- Required reason and setup- or policy-required ticket/reference.
- Approval required before high-risk execution.
- Successful normal correction.
- Successful allow-listed posted correction when platform permits.
- Failed execution with sanitized audit.
- Rollback success.
- Rollback conflict stop.
- Audit export redaction.
- Rollback snapshot logging enabled and disabled.
- Snapshot expiration and retention cleanup.
- Business Central-native page/action usability.
- Required AL analyzer baseline.
- Upgrade compatibility.

## Validation Evidence

Record:

- Environment and BC version.
- App version.
- Test data used.
- Requirement and acceptance IDs.
- Result.
- Screenshots or logs only when they do not expose sensitive values.
- Known gaps.

## Release Gate

Block release if:

- `SUPER` access gate tests fail.
- Audit can be skipped.
- Rollback overwrites conflicts without approved policy.
- Rollback-disabled execution is possible without visible warning.
- Retention cleanup deletes active requests.
- Sensitive values leak through logs or exports.
- Posted table behavior is not validated in sandbox.

## Output Standard

Report the scenario matrix, coverage gaps, commands or manual steps used, and whether the build is releasable.
