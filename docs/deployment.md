# Deployment

## Target Environment

Initial target: Business Central 2026 release wave 1 / version 28 sandbox matching `app.json` platform/application `28.0.0.0` and runtime `17.0`.

Production deployment is blocked until sandbox release validation passes and business approval is recorded.

## Pre-Deployment Checklist

- Confirm BC version and symbols.
- Confirm object ID allocation.
- Confirm company and tenant target.
- Confirm `SUPER`-only access plan.
- Confirm no BCDA-specific permission sets will be created or assigned.
- Confirm default posted table policy.
- Confirm rollback snapshot logging default.
- Confirm audit metadata, rollback snapshot, and technical log retention.
- Confirm Business Central retention policy integration approach for BCDA-owned tables.
- Confirm backup or environment restore strategy outside the extension.
- Confirm support owner and escalation path.

## Install Or Deployment Steps

Implementation has not started, so package deployment steps are not executable yet.

Expected future flow:

1. Build AL package.
2. Publish to sandbox.
3. Run installation and setup checks.
4. Confirm approved users already have the Business Central `SUPER` permission set.
5. Configure setup, rollback logging, retention, and data policies.
6. Run dry-run validation.
7. Execute approved sandbox correction scenarios.
8. Validate audit and rollback.

## Configuration Steps

- Set environment label.
- Configure default policy mode.
- Configure posted table allow/block rules.
- Configure approval policy among `SUPER` users.
- Configure redaction and export policy.
- Configure rollback snapshot logging mode.
- Configure audit metadata, rollback snapshot, and technical log retention.
- Configure or verify Business Central retention policies for BCDA-owned operation tables when available.

## Upgrade Steps

- Review release notes and data migration notes.
- Test upgrade in sandbox with existing audit and snapshot records.
- Confirm historical audit entries remain readable.
- Confirm rollback behavior for pre-upgrade snapshots.
- Confirm retention cleanup still respects configured retention categories.
- Promote only after release gates pass.

## Production Notes

- Production use should start with dry-run only.
- First production correction should be supervised by a `SUPER` administrator, a `SUPER` approver when approval policy requires separation, and the support owner.
- Posted data correction requires business owner approval.
- Keep external environment backup or restore plan available.

## Rollback Or Mitigation

There are two rollback meanings:

- Data rollback: BCDA restores before-images through the governed rollback workflow.
- Extension rollback: uninstall or downgrade package only after confirming app-owned data and dependency impact.

Extension rollback must not be treated as a substitute for data rollback or audit review.
