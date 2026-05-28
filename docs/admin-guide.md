# Admin Guide

## Status

Phase 9 local hardening is complete for the current Phase 8 build. Setup, policy, request, audit, rollback operation, retention-log, Role Center/profile navigation, SUPER-gated shell pages, limited RecordId target selection, selected-field current value refresh, request staged-line preview, policy preview, read-only preview matrix behavior, `Allow Data Policies`, supported grouped update execution, supported update rollback, filtered audit metadata export, governed retention cleanup, and local hardening evidence are available for sandbox validation. Validate-trigger dry-run, non-update execution, non-update rollback, unfiltered export, unredacted export, snapshot payload export, and external APIs are still gated.

Administrators can support the next gates by deploying the current package to sandbox and validating the required access, RecordId, field type, rollback snapshot, grouped update write, rollback success, rollback conflict, rollback-unavailable, audit redaction, filtered export, cleanup, active-record protection, and upgrade-readability behavior without using production data.

## Intended Administrator Responsibilities

- Install the extension in sandbox first.
- Confirm named users already have the Business Central `SUPER` permission set.
- Do not create or assign BCDA-specific permission sets.
- Configure setup and retention.
- Configure whether approval is required and, when it is required, whether approval must be performed by a different `SUPER` user.
- Configure rollback snapshot logging default.
- Configure allowed and blocked tables/fields.
- Configure posted data approval rules.
- Review audit export policy for `SUPER` users.
- Validate foundation pages and access behavior in sandbox before opening the next readiness gate.

## Initial Setup Outline

1. Optionally switch to the `BC Data Agent` profile from My Settings to use the BCDA Role Center as the navigation hub.
2. Open BCDA Setup.
3. Set environment label.
4. Confirm default policy mode is deny-first.
5. Choose rollback snapshot logging default.
6. Choose approval defaults, including whether approval is required and whether a separate approver is required when approval is on.
7. Set audit metadata, rollback snapshot, and technical log retention periods.
8. Configure data policies for safe sandbox targets, including rollback snapshot mode overrides. Confirm BCDA app-owned tables cannot be selected as policy targets.
9. Confirm `Allow Data Policies` is enabled by default. Turn it off only when the business accepts bypassing policy records while preserving BCDA app-owned table, field validation, `SUPER`, metadata, audit, and rollback controls.
10. Confirm requester, approver, and reviewer responsibilities among `SUPER` users when approval policy requires separation. For one-person companies, document why no-approval or self-approval is accepted.
11. Create a foundation request and use lookup suggestions to select a table and an enabled normal non-primary-key field on the correction line.
12. Confirm correction line `Type` supports `Update`, `Rename`, `Delete`, and `Insert`.
13. Confirm `Record ID` is read-only, the `Select Record` line action opens target record lookup for existing-record operation types, selecting a row fills the canonical identity, and `Insert` keeps `Record ID` empty.
14. Enter supported scalar `Proposed New Value` examples and confirm incompatible values are blocked without writing target data or echoing the proposed value in errors.
15. Open `Preview Data Matrix` from the correction lines part and confirm it shows staged line data for the request without changing target data.
16. Do not use `Batch Add Lines` in the foundation build; it is paused until batch RecordId selection or target matrix entry can populate canonical target identities.
17. Use `Preview Request` and review line statuses/sanitized messages.
18. Run `Execute` only on artificial sandbox data for supported grouped `Update` lines and confirm unsupported operation types are audited as blocked.
19. From `BCDA Audit Entries`, run `Rollback` only for a successful `Update` execution audit entry with retained snapshots and confirm conflict checks, policy checks, rollback operation records, and rollback audit entries.
20. Enable `Export Enabled` only for artificial sandbox data, filter audit entries by request, company, occurred-at date/time, operation, or result, and export filtered metadata.
21. Run retention cleanup only against artificial sandbox BCDA operation records and confirm active requests and retained rollback dependencies are protected.
22. Review foundation audit entries, rollback operations, and retention logs.
23. Do not run production correction, rollback, export, or cleanup tests until sandbox validation is complete and production readiness is approved.

## Policy Guidance

- Prefer normal Business Central correction flows when available.
- Allow-list only the tables and fields needed for a documented support scenario, even though users have `SUPER`.
- BCDA app-owned setup, policy, request, audit, snapshot, rollback, retention, and staging tables must remain blocked as correction targets.
- Treat posted tables as high-risk.
- Block fields that identify records, control posting integrity, or contain secrets unless a reviewed exception exists.
- Require rollback snapshots for posted/high-risk policies unless setup explicitly records rollback-unavailable execution as accepted for that workflow.
- Require a different approver for posted/high-risk policies when the company has more than one appropriate `SUPER` user. Disable approval or allow self-approval only when that is the documented business reality.
- Keep `Allow Data Policies` enabled unless the company intentionally accepts bypassing policy records. When it is off, verify permanent blocks for BCDA app-owned, system-managed, unsupported, unaudited, and non-`SUPER` mutation paths.
- Keep retention periods long enough for support and compliance review.
- Keep audit export disabled unless filtered, redacted export is explicitly being tested or used by an approved `SUPER` reviewer.
- Review policies after every major BC upgrade.

## Production Guidance

- Production is blocked until sandbox validation and the next readiness gates pass.
- Start future production use with dry-run only.
- Require the first production correction by a `SUPER` user to follow the validated production readiness procedure.
- Keep environment backup or restore plan outside the extension.
- Export or archive audit evidence according to company policy.
- Review rollback snapshot expiration before executing corrections where rollback is expected.
