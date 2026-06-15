# Audit, Retention, And Export Readiness Kickoff

## Purpose

Record the Phase 8 audit, retention, and export implementation and the validation still required before production use.

Phase 8 is not just reporting. It can expose sensitive values through request workbook export and can delete app-owned operation records through retention cleanup. The local implementation therefore keeps filtered audit export redacted, treats request workbook export as sensitive staged-request output, protects active/incomplete records during cleanup, and still requires sandbox validation before release.

## Current Start Decision

Audit, retention, and export local implementation is complete for the controlled Phase 8 slice.

Implemented code includes `BCDA Request Excel Export Mgt.`, request workbook export/import from `BCDA Correction Request Card`, `BCDA Audit Export Mgt.`, filtered export from `BCDA Audit Entries`, and retention cleanup from `BCDA Setup`.

Sandbox validation was skipped by explicit user instruction for this implementation pass. The remaining validation items cannot be completed from source files alone because they require Business Central sandbox validation, redaction validation, upgrade-readability proof, and operational export-handling evidence.

Do not use Phase 8 in production until:

- Phase 8 sandbox validation is completed with artificial data.
- `docs/deployment.md` and `docs/operations-runbook.md` are validated in sandbox.
- Export handling and cleanup retention settings are accepted by the business owner.

## Phase 8 Prerequisites

| Order | Prerequisite | Evidence Required | Unlocks |
| --- | --- | --- | --- |
| 1 | Phase 6 execution audit evidence exists | Successful and failed execution attempts append audit entries with request, user, company, target, result, reason, ticket, and sanitized errors | Meaningful export/search data |
| 2 | Phase 7 rollback audit evidence exists | Rollback attempts, successes, conflicts, and failures append audit entries for supported update rollback | Rollback export and review scope |
| 3 | Redaction and handling rules are implemented | Filtered audit export omits target record identity text and rollback snapshot payloads; request workbook export is setup-enabled, audited, and handled as sensitive staged-request output | Local export implemented |
| 4 | Export format is confirmed | Request workbook layout, CSV layout, file naming, required filters, and value redaction rules are documented | Local export implemented |
| 5 | Retention cleanup policy is implemented | Snapshot payload purge, active request protection, retained rollback dependency protection, and category-specific cleanup rules exist | Local cleanup implemented |
| 6 | Sandbox retention behavior is proven | BC native retention policy registration/status and custom cleanup are validated against BCDA-owned tables only | Release readiness |
| 7 | Upgrade compatibility is proven | Existing audit, snapshot, rollback, and retention records remain readable after package upgrade | Release readiness |
| 8 | Support evidence rules are documented | Safe escalation package includes IDs, timestamps, table/field IDs, sanitized errors, and redacted values only | Operations readiness |
| 9 | Code-generation readiness is updated | `docs/code-generation-readiness.md` allows Phase 8 export and cleanup implementation | Complete |

## Minimum Phase 8 Behavior

Phase 8 behavior should:

- Keep audit review `SUPER`-gated.
- Export request workbooks only from saved artificial correction requests, and export audit metadata only from app-owned audit records.
- Redact or omit target values and rollback snapshot payloads from filtered audit export by default.
- Require explicit audit filters for request, date range, company, operation, or result.
- Write no target Business Central records.
- Import request workbooks only into saved `Open` correction requests after confirmation, validate workbook rows into temporary lines first, and replace stored correction lines only after validation succeeds.
- Delete only expired BCDA-owned operation records and protect active requests, pending approvals, incomplete executions, retained rollback dependencies, and cleanup evidence created in the same run.
- Append retention cleanup evidence without deleting the cleanup evidence itself in the same run.
- Keep external APIs, unredacted export, posted/protected value export, snapshot payload export, and retention cleanup of active records blocked unless explicitly implemented with controls.

## Release Exit Criteria

Before Phase 8 can be used in production, all of these must be true:

- Sandbox validation covers any BC export/report/Excel buffer APIs and retention cleanup APIs used.
- `docs/test-plan.md` includes request workbook export handling, audit export redaction, filter coverage, non-`SUPER` blocking, retention cleanup success, active-request protection, cleanup failure, and upgrade readability scenarios.
- `docs/operations-runbook.md` defines safe export handling, storage, sharing, and deletion practices.
- `docs/deployment.md` defines sandbox-first export and cleanup validation before production.
- The implementation plan keeps export and cleanup procedures aligned with requirements, acceptance criteria, and validation evidence.

## Local Implementation Evidence

| Date | Scope | Result | Evidence |
| --- | --- | --- | --- |
| 2026-05-28 | Phase 8 local AL implementation | Complete | `BCDA Audit Export Mgt.`, `BCDA Audit Entries` export action, `BCDA Retention Manager.RunRetentionCleanup`, and `BCDA Setup` cleanup action added. |
| 2026-06-15 | Request workbook export local AL implementation | Complete | `BCDA Request Excel Export Mgt.`, request-card `Export to Excel`, and `Request Export` audit operation added. |
| 2026-06-15 | Request workbook import local AL implementation | Complete | `BCDA Request Excel Export Mgt.`, request-card `Import from Excel`, and `Request Import` audit operation added with Open-status gating and delete-and-recreate confirmation. |
| 2026-05-28 | Local compile and analyzers | Pass | AL compiler 17.0.34.45391 compiled 51 files; CodeCop, UICop, and PerTenantExtensionCop passed with `ruleset.json`. |

## Sandbox Validation Rule

Use only artificial sandbox data. Do not record customer data, posted values, hidden values, credentials, exported files with sensitive values, or full rollback before-images in readiness, security, test, or support notes.
