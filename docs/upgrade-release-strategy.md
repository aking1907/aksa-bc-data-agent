# Upgrade And Release Strategy

## Release Principles

- Safety beats feature speed.
- Sandbox proof is required before production.
- Audit compatibility is a release blocker.
- Posted data behavior requires explicit release notes.
- Rollback behavior must be validated for every release.
- Rollback snapshot logging and retention behavior must be validated for every release.

## Versioning Strategy

Use Business Central app version format from `app.json`.

Suggested pattern:

- Patch: documentation, UI text, safe bug fixes.
- Minor: new supported field types, new reports, non-breaking workflow features.
- Major: data model changes, contract changes, or changed rollback behavior.

## Branching Strategy

- Main branch should represent releasable or documentation-ready state.
- Feature branches should be used for implementation work.
- High-risk workflow changes should include doc and test updates in the same branch.

## Release Gates

- Requirements, acceptance criteria, traceability, and test plan updated.
- AL package compiles.
- `SUPER` access gate tests pass.
- Audit append-only behavior verified.
- Rollback success and conflict behavior verified.
- Rollback-disabled and snapshot-expired behavior verified.
- Retention cleanup behavior verified.
- Upgrade test passes.
- Security review updated for changed behavior.
- Release notes describe risks and operational steps.

## Environment Flow

1. Local development.
2. Developer sandbox.
3. Shared sandbox.
4. User acceptance sandbox.
5. Production, only after approval.

## Upgrade Strategy

- Preserve app-owned audit history.
- Version serialized values.
- Preserve or migrate retention categories and expiration dates.
- Add upgrade routines for changed tables.
- Never drop audit or snapshot data without documented migration and approval.

## Rollback And Hotfix Rules

- Hotfixes that touch mutation, audit, rollback, or security require full targeted retest.
- Extension rollback must be planned separately from data rollback.
- Emergency production fixes require post-incident review.

## Release Notes Minimum Content

- Version.
- Date.
- Added/changed behavior.
- Security or `SUPER` access policy changes.
- Data model or upgrade notes.
- Rollback logging and retention changes.
- Known risks.
- Validation evidence.
- Rollback guidance.
