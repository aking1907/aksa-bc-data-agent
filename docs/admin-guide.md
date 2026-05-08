# Admin Guide

## Status

Foundation implementation exists. Setup, policy, request, audit, retention-log, Role Center/profile navigation, and SUPER-gated shell pages are available for sandbox validation. Target data preview, execution, rollback execution, and export are still gated.

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
8. Configure data policies for safe sandbox targets, including rollback snapshot mode overrides.
9. Confirm requester, approver, and reviewer responsibilities among `SUPER` users when approval policy requires separation. For one-person companies, document why no-approval or self-approval is accepted.
10. Create a foundation request and use lookup suggestions to select a table and an enabled normal field on the correction line.
11. Confirm `Record ID` is read-only, the `Select Record` line action opens target record lookup, and selecting a row fills the canonical identity.
12. Do not use `Batch Add Lines` in the foundation build; it is paused until batch RecordId selection or target matrix entry can populate canonical target identities.
13. Use the preview marker action.
14. Confirm target execution is blocked by the foundation readiness gate.
15. Review foundation audit entries and retention logs.
16. Do not run RecordId target selection, approved sandbox correction, or rollback tests until the next readiness gate opens those behaviors.

## Policy Guidance

- Prefer normal Business Central correction flows when available.
- Allow-list only the tables and fields needed for a documented support scenario, even though users have `SUPER`.
- Treat posted tables as high-risk.
- Block fields that identify records, control posting integrity, or contain secrets unless a reviewed exception exists.
- Require rollback snapshots for posted/high-risk policies unless business owners explicitly accept rollback-unavailable execution.
- Require a different approver for posted/high-risk policies when the company has more than one appropriate `SUPER` user. Disable approval or allow self-approval only when that is the documented business reality.
- Keep retention periods long enough for support and compliance review.
- Review policies after every major BC upgrade.

## Production Guidance

- Production is blocked until sandbox validation and the next readiness gates pass.
- Start future production use with dry-run only.
- Require business owner approval for first production correction by a `SUPER` user.
- Keep environment backup or restore plan outside the extension.
- Export or archive audit evidence according to company policy.
- Review rollback snapshot expiration before executing corrections where rollback is expected.
