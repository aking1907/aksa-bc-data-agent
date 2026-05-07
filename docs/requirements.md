# Requirements

## Current Phase Boundary

Current phase: Phase 2 Foundation Data implementation. AL code is approved only for setup, policy, request, audit, snapshot, rollback-state, retention-log, SUPER-gated shell pages, and supporting services. Target record mutation remains blocked.

## Functional Requirements

| ID | Requirement | Acceptance | Phase |
| --- | --- | --- | --- |
| REQ-001 | The app must let authorized users discover tables, fields, records, and key metadata needed for correction workflows. | AC-001 | 1-3 |
| REQ-002 | The app must create a correction request before any data is changed. | AC-003 | 2-4 |
| REQ-003 | A correction request must include reason, ticket/reference, company, target table, target record key, target field, proposed new value, current value preview, rollback logging mode, retention impact, and risk classification. | AC-003, AC-004 | 2-4 |
| REQ-004 | The app must support a dry-run preview that reports intended changes, old/new values, validation mode, rollback logging mode, retention period, rollback availability, and warnings. | AC-004 | 4 |
| REQ-005 | The app must enforce configurable policy before modifying normal, hidden, or posted table data. | AC-005, AC-012 | 3-4 |
| REQ-006 | Posted table changes must require existing Business Central `SUPER` access and approval unless a documented policy exception exists. Approval separation must follow setup so one-person companies can allow self-approval while larger companies can require a different `SUPER` approver. | AC-005, AC-007, AC-027 | 4 |
| REQ-007 | The app must execute only approved and policy-allowed field-level data changes. | AC-006, AC-007 | 4 |
| REQ-008 | Every successful or failed attempted change must create append-only audit evidence. | AC-008, AC-015 | 4 |
| REQ-009 | The app must support rollback from captured before-images when rollback snapshot logging is enabled, snapshots are retained, and conflict checks allow it. | AC-009, AC-010, AC-021, AC-022, AC-023 | 5 |
| REQ-010 | Rollback must create new audit entries and must not delete or mutate original audit entries. | AC-009, AC-008 | 5 |
| REQ-011 | `SUPER` users must be able to review and export correction history subject to redaction rules and export policy. | AC-011 | 5 |
| REQ-012 | The app must block destructive operations that are outside Phase 1, including deleting records, renaming primary keys, and editing blocked fields. | AC-012 | 4 |
| REQ-023 | The app must provide a Business Central-native, task-focused user experience with setup, policy, request, preview, audit, retention, and rollback pages designed around Microsoft page/action guidance. | AC-020 | 3-6 |
| REQ-024 | The app must let `SUPER` users configure rollback snapshot logging globally and by data policy. | AC-021, AC-022 | 2-5 |
| REQ-025 | The app must make rollback-unavailable states visible before execution when rollback snapshots are disabled or expired. | AC-021, AC-023 | 4-5 |

## Data And Security Requirements

| ID | Requirement | Acceptance | Phase |
| --- | --- | --- | --- |
| REQ-013 | The app must not create BCDA-specific permission sets; correction functionality must be available only to users with the existing Business Central `SUPER` permission set. | AC-002, AC-005 | 2-4 |
| REQ-014 | Sensitive before/new values must be protected from unauthorized pages, exports, logs, telemetry, and test output. | AC-011, AC-016 | 2-6 |
| REQ-015 | Audit and rollback data must include tenant/company context where the platform exposes it. | AC-008 | 2-4 |
| REQ-016 | No credentials, secrets, or personal export files may be committed to the repository. | AC-016 | 0-6 |
| REQ-017 | Retention policy must distinguish audit metadata, rollback snapshot, and technical log retention. | AC-014, AC-024 | 2-6 |
| REQ-018 | Errors must be visible enough for support while avoiding sensitive value leakage. | AC-015, AC-016 | 4-6 |
| REQ-026 | The app must let `SUPER` users control how long operation records are kept in the database, preferably through Business Central native retention policy support for app-owned tables. | AC-024, AC-025 | 2-6 |
| REQ-027 | Mandatory audit metadata must always be written even when rollback snapshot logging is disabled. | AC-008, AC-021 | 4 |
| REQ-029 | The app must let `SUPER` administrators configure whether approval is required by default and, when approval is required, whether it requires a different `SUPER` user or allows the requester to self-approve. | AC-027 | 2-4 |

## SDD And Validation Requirements

| ID | Requirement | Acceptance | Phase |
| --- | --- | --- | --- |
| REQ-019 | No AL code may be generated until the readiness gate allows it and the user asks for implementation. | AC-013 | 0 |
| REQ-020 | Every implementation object must trace to a requirement, acceptance criterion, and test scenario. | AC-017 | 0-6 |
| REQ-021 | BC symbol-dependent behavior must be recorded in `docs/symbol-discovery.md` before implementation depends on it. | AC-018 | 1 |
| REQ-022 | Phase 1 release requires sandbox validation of correction, rollback, `SUPER` access gating, audit, and upgrade behavior. | AC-019 | 6 |
| REQ-028 | Generated AL must follow Microsoft-aligned standards documented in `docs/al-development-standards.md`, including CodeCop, UICop, robust error handling, and performance-aware data access. | AC-026 | 2-6 |
