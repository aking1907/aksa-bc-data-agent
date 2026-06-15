# Deployment

## Target Environment

Initial target: Business Central 2026 release wave 1 / version 28 sandbox matching `app.json` platform/application `28.0.0.0` and runtime `17.0`.

Production deployment is blocked until sandbox release validation passes and runtime readiness evidence is updated.

Phase 8 correction request Excel export/import, filtered audit metadata export, and governed retention cleanup are implemented locally. Supported grouped update, primary-key rename, record-level delete, and grouped insert execution are implemented locally. Sandbox validation was skipped by request for implementation and remains required before production use.

## Pre-Deployment Checklist

- Confirm BC version and symbols.
- Confirm object ID allocation.
- Confirm company and tenant target.
- Confirm `SUPER`-only access plan.
- Confirm approval requirement and separate-approver policy for the target company.
- Confirm no BCDA-specific permission sets will be created or assigned.
- Confirm default posted table policy.
- Confirm rollback snapshot logging default.
- Confirm audit metadata, rollback snapshot, and technical log retention.
- Confirm `Allow Data Policies` is enabled by default, or explicitly accepted before policy records are bypassed.
- Confirm Business Central retention policy integration approach for BCDA-owned tables.
- Confirm correction request workbook export/import plus filtered audit export handling and storage rules.
- Confirm retention cleanup settings and support owner acceptance.
- Confirm RecordId/RecordRef target selection behavior before enabling the planned target record matrix.
- Confirm backup or environment restore strategy outside the extension.
- Confirm support owner and escalation path.

## Install Or Deployment Steps

Local implementation is standing-authorized under the SDD. Package deployment is allowed only to sandbox for setup, policy, request, audit, retention, and SUPER access validation until release gates pass.

1. Build AL package.
2. Publish to sandbox.
3. Run installation and setup checks.
4. Confirm authorized users already have the Business Central `SUPER` permission set.
5. Optionally assign or select the `BC Data Agent` profile for authorized `SUPER` users who should use the BCDA Role Center.
6. Confirm non-`SUPER` users cannot open BCDA pages.
7. Configure setup, rollback logging, retention, and data policies.
8. Create a foundation request and verify audit evidence for foundation actions.
9. Use RecordId target selection for sandbox request-line staging, proposed-value validation, preview, supported grouped update execution, supported primary-key rename execution, supported record-level delete execution, supported grouped insert execution, and supported update rollback.
10. For Phase 8 sandbox readiness, use only artificial BCDA operation records and artificial correction requests to validate request workbook export/import, audit redaction, export filters, cleanup behavior, active-record protection, and upgrade readability. Do not generate production exports, import production workbooks, or delete production operation records until release validation is complete.

## Configuration Steps

- Set environment label.
- Configure default policy mode.
- Configure posted table allow/block rules.
- Keep `Allow Data Policies` enabled unless policy-record bypass is explicitly accepted for sandbox validation. Permanent blocks must still be verified.
- Configure approval policy among `SUPER` users.
- Configure whether approval is required and whether required approval needs a different `SUPER` user or allows self-approval for one-person companies.
- Configure redaction and export policy.
- Keep export disabled until the company is ready to test request workbook export and filtered, redacted audit export with artificial sandbox data. Test request workbook import only on saved artificial requests in `Open` status.
- Configure rollback snapshot logging mode.
- Configure audit metadata, rollback snapshot, and technical log retention.
- Configure or verify Business Central retention policies for BCDA-owned operation tables using the foundation retention registration action.

## Upgrade Steps

- Review release notes and data migration notes.
- Test upgrade in sandbox with existing audit and snapshot records.
- Confirm historical audit entries remain readable.
- Confirm rollback behavior for pre-upgrade snapshots.
- Confirm retention cleanup still respects configured retention categories.
- Confirm audit export redaction and cleanup records remain compatible after upgrade.
- Promote only after release gates pass.

## Production Notes

- Production use should start with dry-run only.
- First production correction should be supervised by a `SUPER` administrator, a `SUPER` approver when approval policy requires separation, and the support owner.
- Posted data correction must follow the validated posted-data policy and company control procedure.
- Keep external environment backup or restore plan available.

## Rollback Or Mitigation

There are two rollback meanings:

- Data rollback: BCDA creates a governed rollback correction request from retained before-images, then that generated request is previewed, approved if required, and executed through the normal workflow.
- Extension rollback: uninstall or downgrade package only after confirming app-owned data and dependency impact.

Extension rollback must not be treated as a substitute for data rollback or audit review.
