# Admin Guide

## Status

Planned. The extension has not been implemented yet.

## Intended Administrator Responsibilities

- Install the extension in sandbox first.
- Confirm named users already have the Business Central `SUPER` permission set.
- Do not create or assign BCDA-specific permission sets.
- Configure setup and retention.
- Configure rollback snapshot logging default.
- Configure allowed and blocked tables/fields.
- Configure posted data approval rules.
- Review audit export policy for `SUPER` users.
- Validate rollback behavior before production use.

## Initial Setup Outline

1. Open BCDA Setup.
2. Set environment label.
3. Confirm default policy mode is deny-first.
4. Choose rollback snapshot logging default.
5. Set audit metadata, rollback snapshot, and technical log retention periods.
6. Configure data policies for safe sandbox targets, including rollback snapshot mode overrides.
7. Confirm requester, approver, and reviewer responsibilities among `SUPER` users when approval policy requires separation.
8. Run preview-only smoke test.
9. Run approved sandbox correction.
10. Run rollback-enabled and rollback-disabled tests.
11. Review audit entries and retention status.

## Policy Guidance

- Prefer normal Business Central correction flows when available.
- Allow-list only the tables and fields needed for a documented support scenario, even though users have `SUPER`.
- Treat posted tables as high-risk.
- Block fields that identify records, control posting integrity, or contain secrets unless a reviewed exception exists.
- Require rollback snapshots for posted/high-risk policies unless business owners explicitly accept rollback-unavailable execution.
- Keep retention periods long enough for support and compliance review.
- Review policies after every major BC upgrade.

## Production Guidance

- Start with dry-run only.
- Require business owner approval for first production correction by a `SUPER` user.
- Keep environment backup or restore plan outside the extension.
- Export or archive audit evidence according to company policy.
- Review rollback snapshot expiration before executing corrections where rollback is expected.
