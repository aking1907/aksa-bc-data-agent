# ADR-004: Configurable Rollback Logging And Retention

## Status

Accepted

## Context

The app must track corrections, but users also need control over whether rollback payloads are stored and how long operation records remain in the database. Rollback payloads can contain sensitive business, financial, or personal values, so storing them forever is not always desirable. At the same time, disabling rollback payloads must not create silent, untraceable changes.

## Decision

Audit metadata is mandatory for every material operation. Rollback snapshot logging is configurable by setup and policy.

The app will support:

- Global rollback snapshot default.
- Per-policy rollback snapshot mode: required, allowed, or disabled.
- Request preview that resolves and displays rollback availability before execution.
- Separate retention settings for audit metadata, rollback snapshots, and technical logs.
- Preference for Business Central native retention policy support for app-owned operation tables after sandbox validation confirms the required APIs.

## Consequences

- Users can control database growth and sensitive rollback payload retention.
- Rollback request creation is available only while required snapshots exist; generated rollback requests handle current-value review through normal preview and execution controls.
- Audit metadata remains available according to configured audit retention.
- UI must clearly warn when rollback snapshots are disabled or expired.
- Implementation must distinguish audit evidence from rollback payloads.

## Alternatives Considered

| Alternative | Reason Rejected |
| --- | --- |
| Always store rollback snapshots forever | Strong rollback capability, but too much sensitive data retention and database growth. |
| Make all logging optional | Unsafe because changes could become untraceable. |
| Custom cleanup only | Less aligned with Business Central retention policy capabilities. |

## Follow-Up

- Verify retention policy APIs and allowed table registration for BCDA-owned tables.
- Decide default and minimum retention periods.
- Add setup and policy fields for rollback snapshot mode and retention.
- Add tests for rollback-disabled and snapshot-expired behavior.
