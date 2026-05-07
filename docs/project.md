# Project

## Overview

BC Data Agent is a Business Central AL extension intended to provide a controlled way for authorized administrators to correct data that is normally hidden, difficult to reach, or locked behind posted document workflows.

The product goal is not casual data editing. It is a governed recovery and support tool for exceptional cases where a data issue cannot be fixed safely through standard Business Central pages, journals, reversals, or assisted setup.

## Business Goal

Enable trusted support users to make targeted corrections to Business Central data, including posted tables when explicitly allowed, while preserving mandatory audit metadata, offering configurable rollback snapshots, and letting users control retention of app-owned operation records.

## Current Implementation Mode

Documentation-only preparation.

No AL code should be generated until:

- `docs/code-generation-readiness.md` changes from Not Ready to Ready.
- Blocking open decisions are resolved.
- The user explicitly asks to start implementation.

## Personas

All personas require the existing Business Central `SUPER` permission set. The extension must not create BCDA-specific permission sets. Persona names below describe workflow responsibilities only, not custom access roles.

| Persona | Goal |
| --- | --- |
| SUPER Administrator | Configure policy and safety defaults. |
| SUPER Support User | Request and execute approved data corrections. |
| SUPER Finance or Process Owner | Approve high-risk changes to posted data when approval policy requires it. |
| SUPER Reviewer | Review who changed what, when, why, and whether rollback occurred. |
| Developer | Maintain the extension and validate compatibility with BC versions. |

## Phase 1 Scope

- Discover accessible BC tables, records, fields, and metadata needed for correction workflows.
- Create a correction request with reason, ticket/reference, target table, target record, field, old value, and new value.
- Support dry-run preview before changing data.
- Enforce policy before modifying normal, hidden, or posted table data.
- Require existing `SUPER` access and approval for posted or high-risk data.
- Capture mandatory audit metadata for every operation.
- Let users configure whether rollback before-image snapshots are stored, with safe defaults and visible warnings.
- Let users control retention time for audit metadata, rollback snapshots, and technical logs.
- Provide rollback from captured before-images with conflict checks when rollback snapshots are enabled and retained.
- Provide audit review and export for authorized `SUPER` users, subject to redaction/export policy.

## Non-Goals

- Bypassing Business Central licensing, tenant boundaries, or platform security.
- Direct SQL modification.
- Silent or untraceable edits.
- Deleting or rewriting audit history.
- Replacing normal correction flows such as credit memos, reversals, or journals.
- Bulk data migration tooling.
- External API access in Phase 1.
- Automatic correction recommendations.

## Main Workflows

1. SUPER user configures policy, approval rules, retention, and blocked tables/fields.
2. SUPER user creates a correction request with target data and business justification.
3. System previews old/new values, risk level, validations, rollback logging mode, retention period, and rollback availability.
4. SUPER approver approves or rejects high-risk requests when approval policy requires it.
5. SUPER user executes the approved request.
6. System writes mandatory audit metadata and, when enabled by setup/policy, rollback snapshots.
7. SUPER reviewer reviews or exports the correction history.
8. SUPER user performs rollback if the result is wrong and policy allows rollback.

## Success Definition

Phase 1 succeeds when an authorized user can correct one allowed field on one target record in a sandbox, including a posted table scenario, and then prove:

- The change required existing Business Central `SUPER` access and policy approval.
- Old and new values were displayed during preview and retained according to rollback logging policy.
- The user, company, table, record key, date/time, reason, and ticket were recorded.
- Rollback can restore the previous value or safely report unavailable/expired/conflicted rollback state.
- Audit history remains intact after rollback.
- Retention settings are visible and can be changed by `SUPER` users.

## Known Constraints

- Business Central SaaS and on-premises environments may differ in available behavior.
- Business Central platform and table behavior may prevent modification of some data even for `SUPER` users.
- Posted accounting data has legal, audit, and operational risk.
- Sensitive values may be present in target records and rollback snapshots.
- Rollback snapshot retention and audit retention can affect rollback availability and operation history visibility.
- Symbol verification has not yet been performed in this repository.
- Current `app.json` targets Business Central 2026 release wave 1 / version 28 with application/platform `28.0.0.0` and runtime `17.0`.

## Phases

| Phase | Name | Outcome |
| --- | --- | --- |
| 0 | Documentation baseline | SDD package prepared, code blocked. |
| 1 | Symbol discovery | Verify BC symbols, `SUPER` access behavior, and record access behavior. |
| 2 | App-owned data model | Implement setup, policy, request, audit, and rollback storage. |
| 3 | Metadata and policy UI | Let administrators inspect targets and configure rules. |
| 4 | Correction workflow | Preview, approval, execution, and audit. |
| 5 | Rollback workflow | Restore before-images with conflict detection. |
| 6 | Hardening | Security, performance, upgrade, and release validation. |
