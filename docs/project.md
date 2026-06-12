# Project

## Overview

BC Data Agent is a Business Central AL extension intended to provide a controlled way for authorized administrators to correct data that is normally hidden, difficult to reach, or locked behind posted document workflows.

The product goal is not casual data editing. It is a governed recovery and support tool for exceptional cases where a data issue cannot be fixed safely through standard Business Central pages, journals, reversals, or assisted setup.

## Business Goal

Enable trusted support users to make targeted corrections to Business Central data, including posted tables when explicitly allowed, while preserving mandatory audit metadata, offering configurable rollback snapshots, and letting users control retention of app-owned operation records.

## Current Implementation Mode

Phase 9 local hardening is complete for the current Phase 8 build. Phase 8 Audit, Retention, And Export local implementation is complete for grouped `Update` corrections, supported primary-key `Rename` execution, supported record-level `Delete` execution, supported grouped `Insert` execution, request-level rollback staging, filtered audit metadata export, and governed retention cleanup. Local implementation now has standing authorization under the SDD, so code development does not require per-phase paper confirmation. Sandbox validation was skipped by request for Phase 8 implementation and remains required before production use.

AL code is allowed for local implementation work that follows the SDD and preserves user review, policies, `SUPER` access, audit, redaction, rollback, tests, and production validation controls. This includes app-owned foundation objects, security/policy hardening, setup/retention/UX shell work, target selection and preview workflow, supported grouped update execution, supported and future operation-specific rollback/execution work, filtered audit metadata export, retention cleanup, and controlled prototypes for broader export/API behavior.

Selected-line current value preview is available after a target record and field are selected. Request-level staged-line preview is available without mutation. Supported grouped update, primary-key rename, record-level delete, and grouped insert execution is available after required request metadata, preview when configured, approval/policy when configured, and `SUPER` checks pass. Rename execution stores the renamed identity after success. Insert execution creates one new record per request/table insert group and stores the created identity after success. Supported rollback is available from completed `Update` requests when retained before-image snapshots exist for every executed supported line; rollback creates a new correction request and does not mutate target data directly. Filtered audit export and retention cleanup are implemented locally. Rename/delete/insert rollback, broader non-update rollback, conflict override, unfiltered export, unredacted export, snapshot payload export, external APIs, and production enablement may be developed locally only with controls and remain blocked at runtime until validation evidence supports use.

## Personas

All personas require the existing Business Central `SUPER` permission set. The extension must not create BCDA-specific permission sets. Persona names below describe workflow responsibilities only, not custom access roles.

| Persona | Goal |
| --- | --- |
| SUPER Administrator | Configure policy and safety defaults. |
| SUPER Support User | Request and execute approved data corrections. |
| SUPER Finance or Process Owner | Approve high-risk changes to posted data when approval policy requires it and the company uses separate approval. |
| SUPER Reviewer | Review who changed what, when, why, and whether rollback occurred. |
| Developer | Maintain the extension and validate compatibility with BC versions. |

## Phase 1 Scope

- Discover accessible BC tables, records, fields, and metadata needed for correction workflows.
- Create a correction request with reason, setup- or policy-required ticket/reference, target table, canonical target record identity, field, old value, and new value.
- Support dry-run preview before changing data.
- Enforce policy before modifying normal, hidden, or posted table data.
- Require existing `SUPER` access and approval for posted or high-risk data.
- Capture mandatory audit metadata for every operation.
- Let users configure whether rollback before-image snapshots are stored, with safe defaults and visible warnings.
- Let users control retention time for audit metadata, rollback snapshots, and technical logs.
- Provide request-level rollback staging from captured before-images when rollback snapshots are enabled and retained.
- Provide audit review and export for authorized `SUPER` users, subject to redaction/export policy.

## Non-Goals

- Bypassing Business Central licensing, tenant boundaries, or platform security.
- Direct SQL modification.
- Silent or untraceable edits.
- Deleting or rewriting audit history outside governed retention.
- Replacing normal correction flows such as credit memos, reversals, or journals.
- Bulk data migration tooling.
- External API access in Phase 1.
- Automatic correction recommendations.

## Main Workflows

1. SUPER user configures policy, approval requirement, approval separation, retention, and blocked tables/fields.
2. SUPER user creates a correction request with target data and business justification.
3. System previews old/new values, risk level, validations, rollback logging mode, retention period, and rollback availability.
4. SUPER approver approves or rejects high-risk requests when approval policy requires it. The approver may be the requester only when setup allows self-approval.
5. SUPER user executes the approved request.
6. System writes mandatory audit metadata and, when enabled by setup/policy, rollback snapshots.
7. SUPER reviewer reviews or exports the correction history.
8. SUPER user creates and reviews a rollback correction request if the result is wrong and snapshots are retained.

## Success Definition

Phase 1 succeeds when an authorized user can correct one allowed field on one target record in a sandbox, including a posted table scenario, and then prove:

- The change required existing Business Central `SUPER` access and the configured policy/approval path.
- Old and new values were displayed during preview and retained according to rollback logging policy.
- The user, company, table, target record identity, date/time, reason, and any required or provided ticket/reference were recorded.
- Rollback can create a governed inverse correction request or safely report unavailable/expired rollback state.
- Audit history remains intact after rollback.
- Retention settings are visible and can be changed by `SUPER` users.
- Approval can be required with separate approval for dual-control companies, disabled for accepted standard-request workflows, or configured for self-approval by one-person companies that accept the risk.

## Known Constraints

- Business Central SaaS and on-premises environments may differ in available behavior.
- Business Central platform and table behavior may prevent modification of some data even for `SUPER` users.
- Posted accounting data has legal, audit, and operational risk.
- Sensitive values may be present in target records and rollback snapshots.
- Rollback snapshot retention and audit retention can affect rollback availability and operation history visibility.
- Foundation compile verification has been performed for `SUPER` detection, retention allowed-table registration, grouped update execution, request-level rollback staging, filtered audit export, and retention cleanup. Target mutation, rollback request execution, export, and cleanup behavior still require sandbox validation before production use.
- Current `app.json` targets Business Central 2026 release wave 1 / version 28 with application/platform `28.0.0.0` and runtime `17.0`.

## Phases

| Phase | Name | Outcome |
| --- | --- | --- |
| 0 | Documentation baseline | SDD package prepared. |
| 1 | Platform validation | Verify foundation APIs and runtime assumptions. |
| 2 | Foundation Data | Implement setup, policy, request, line, audit, snapshot, rollback-state, and retention storage. Complete for the current foundation slice. |
| 3 | Security And Policy | Enforce `SUPER` access, policy evaluation, redaction rules, and permanent table blocks. Complete for the current non-mutating slice. |
| 4 | Setup, Retention, And UX Shell | Provide setup pages, policy pages, retention settings, and request shell pages. Complete for the current non-mutating slice. |
| 5 | Target Selection And Preview Workflow | Support RecordId target selection, matrix line entry, metadata discovery, and dry-run preview without mutation. Local implementation complete; sandbox validation pending. |
| 6 | Execution Workflow | Execute workflow-eligible grouped `Update` field corrections, record-level `Delete` corrections, and grouped `Insert` corrections with mandatory audit and rollback visibility controls. Local implementation complete; sandbox validation still required before production use. |
| 7 | Rollback Workflow | Create governed rollback correction requests from completed `Update` requests with retained before-images. Local implementation complete; sandbox validation still required before production use. |
| 8 | Audit, Retention, And Export | Provide setup-enabled filtered audit metadata export and governed cleanup of expired eligible BCDA-owned operation records. Local implementation complete; sandbox validation still required before production use. |
| 9 | Hardening | Local compile, analyzer, config, object-range, access-model, and documentation hardening complete. Sandbox release validation still required before production use. |
