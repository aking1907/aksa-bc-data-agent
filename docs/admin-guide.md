# Admin Guide

## Status

Phase 9 local hardening is complete for the current Phase 8 build. Local implementation has standing authorization under the SDD, while runtime and production use remain governed by controls and validation evidence. Setup, policy, request, audit, rollback operation, retention-log, Role Center/profile navigation, SUPER-gated shell pages, limited RecordId target selection, selected-field current value refresh, request staged-line preview, policy preview, read-only preview matrix behavior, `Allow Data Policies`, supported grouped update execution, supported primary-key rename execution, supported record-level delete execution, supported grouped insert execution, request-level rollback staging, filtered audit metadata export, governed retention cleanup, and local hardening evidence are available for sandbox validation. Validate-trigger dry-run, non-update rollback, unfiltered export, unredacted export, snapshot payload export, and external APIs are not enabled at runtime.

Administrators can support runtime readiness by deploying the current package to sandbox and validating the required access, RecordId, field type, rollback snapshot, grouped update write, primary-key rename, record delete, grouped insert, rollback request creation, generated rollback request preview/execution, rollback-unavailable, audit redaction, filtered export, cleanup, active-record protection, and upgrade-readability behavior without using production data.

## Intended Administrator Responsibilities

- Install the extension in sandbox first.
- Confirm named users already have the Business Central `SUPER` permission set.
- Do not create or assign BCDA-specific permission sets.
- Configure setup and retention.
- Configure whether approval is required and, when it is required, whether approval must be performed by a different `SUPER` user.
- Configure whether ticket/reference evidence is required for new requests.
- Configure rollback snapshot logging default.
- Configure allowed and blocked tables/fields.
- Configure posted data approval rules.
- Review audit export policy for `SUPER` users.
- Validate foundation pages and access behavior in sandbox before runtime or production enablement.

## Initial Setup Outline

1. Optionally switch to the `BC Data Agent` profile from My Settings to use the BCDA Role Center as the navigation hub.
2. Open BCDA Setup.
3. Set environment label.
4. Confirm default policy mode is deny-first.
5. Choose rollback snapshot logging default.
6. Choose approval defaults, including whether approval is required and whether a separate approver is required when approval is on.
7. Choose whether new requests require a ticket/reference.
8. Set audit metadata, rollback snapshot, and technical log retention periods.
9. Configure data policies for safe sandbox targets, including rollback snapshot mode overrides. Confirm BCDA app-owned tables cannot be selected as policy targets.
10. Confirm `Allow Data Policies` is enabled by default. Turn it off only when the business accepts bypassing policy records while preserving BCDA app-owned table, field validation, `SUPER`, metadata, audit, and rollback controls.
11. Confirm requester, approver, and reviewer responsibilities among `SUPER` users when approval policy requires separation. For one-person companies, document why no-approval or self-approval is accepted.
12. Create a foundation request and use lookup suggestions to select a table and an enabled normal non-primary-key field on the correction line.
13. Confirm correction line `Type` supports `Update`, `Rename`, `Delete`, and `Insert`.
14. Confirm target record identity is read-only, the `Select Existing Record` line action opens target record lookup for existing-record operation types, simple and composite primary-key values are visible before selection, selecting a row fills the canonical identity, and `Insert` keeps target record identity empty while staged.
15. Enter supported scalar `Proposed New Value` examples and confirm incompatible values are blocked without writing target data or echoing the proposed value in errors.
16. Open `Preview Data Matrix` from the correction lines part and confirm it shows staged line data for the request without changing target data.
17. Use `Batch Add Lines` only on artificial sandbox data to confirm same-table batch entries can select target records and create normal correction lines without mutation.
18. Use `Preview Request` and review line statuses/sanitized messages.
19. Run `Execute` only on artificial sandbox data for supported grouped `Update`, primary-key `Rename`, record-level `Delete`, and grouped `Insert` lines. Confirm rename stores the renamed `RecordId`, insert requires staged primary-key fields, and rename/delete/insert rollback are unavailable.
20. From a completed correction request, run `Rollback` only when retained snapshots exist for every executed supported line, then confirm a new rollback correction request, rollback operation record, and rollback audit entries are created. Preview and execute the generated request only through the normal governed workflow.
21. Enable `Export Enabled` only for artificial sandbox data, filter audit entries by request, company, occurred-at date/time, operation, or result, and export filtered metadata.
22. Run retention cleanup only against artificial sandbox BCDA operation records and confirm active requests and retained rollback dependencies are protected.
23. Review foundation audit entries, rollback operations, and retention logs.
24. Do not run production correction, rollback, export, or cleanup tests until sandbox validation is complete and production readiness is approved.

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

- Production is blocked until sandbox validation and runtime readiness evidence pass.
- Start future production use with dry-run only.
- Require the first production correction by a `SUPER` user to follow the validated production readiness procedure.
- Keep environment backup or restore plan outside the extension.
- Export or archive audit evidence according to company policy.
- Review rollback snapshot expiration before executing corrections where rollback is expected.
