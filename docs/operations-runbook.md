# Operations Runbook

## Current Support Boundary

The project is documentation-only. Operational steps below describe intended support behavior after implementation.

## Setup Checks

- Confirm extension is installed in sandbox.
- Confirm only approved users with the Business Central `SUPER` permission set can access the extension.
- Confirm no BCDA-specific permission sets are created or assigned.
- Confirm setup record exists.
- Confirm posted table default policy is deny-first or explicitly approved.
- Confirm rollback snapshot logging default is configured.
- Confirm audit metadata, rollback snapshot, and technical log retention are configured.
- Confirm audit export policy is limited to approved `SUPER` users.

## Health Checks

- Open setup page.
- Create a dry-run request against a safe sandbox record.
- Confirm preview does not mutate data.
- Confirm preview shows rollback logging mode, retention period, and rollback availability.
- Confirm audit entry is written for preview or blocked attempt when expected.
- Confirm rollback-disabled preview clearly states rollback will be unavailable.
- Confirm unauthorized test user cannot access correction pages.

## Main Workflow

1. SUPER user creates correction request.
2. SUPER user enters reason and ticket/reference.
3. SUPER user selects target table, record, field, and new value.
4. SUPER user runs preview.
5. Second SUPER user approves if approval policy requires separation.
6. SUPER user executes.
7. SUPER reviewer reviews evidence.
8. SUPER user requests rollback if needed.

## Troubleshooting

| Category | Checks |
| --- | --- |
| Access denied | Confirm the user has the Business Central `SUPER` permission set and the extension's runtime access check passes. |
| Policy blocked | Review table and field policy, risk classification, and approval state. |
| Preview failed | Confirm target record exists and field type is supported. |
| Execution failed | Review sanitized line error and BC platform/table behavior. |
| Rollback conflict | Compare current target value with expected post-change value. |
| Rollback unavailable | Confirm rollback snapshot logging was enabled and snapshots have not expired or been purged. |
| Retention cleanup issue | Review retention status, retention policy setup, and sanitized retention log entries. |
| Export missing values | Confirm `SUPER` access and export redaction policy. |
| Upgrade issue | Check extension version, upgrade notes, and audit table compatibility. |

## Safe Logging Guidance

- Share request id, line id, table id, field id, timestamp, and sanitized error.
- Do not share full sensitive values in chat, tickets, logs, or screenshots unless approved by policy.
- Use hashes or redacted display values where possible.

## Escalation Package

Provide:

- Environment and company.
- Extension version.
- Request id and line ids.
- Operation type.
- Sanitized error.
- Policy decision shown to user.
- Whether target data is normal, hidden, or posted.
- Rollback logging mode and snapshot expiration date.
- Whether rollback was attempted.
- Retention category and cleanup status when relevant.
