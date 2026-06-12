# Execution Readiness Kickoff

## Purpose

Track Phase 6 correction workflow execution implementation and final sandbox validation.

Phase 2-5 foundation and non-mutating objects exist for app-owned setup, policy, request, line, audit, snapshot, rollback-state, retention-log, SUPER-gated shell pages, target selection, and request preview. Phase 6 local implementation adds grouped `Update` execution, supported record-level `Delete` execution, `Allow Data Policies`, execution audit evidence, rollback snapshot capture for supported update lines when enabled or required, and rollback-unavailable status for delete lines.

## Current Start Decision

Execution readiness work is complete for local implementation and has moved to sandbox validation.

AL mutation code is implemented for supported grouped `Update` lines and supported record-level `Delete` lines. The current execution gate still blocks `Rename` and `Insert`; Phase 8 export and retention cleanup are tracked separately.

OD-018 insert grouping remains deferred until insert execution behavior is needed. OD-019 setup-controlled data policy enforcement is implemented as `Allow Data Policies`.

Phase 7 rollback readiness is tracked separately in `docs/rollback-readiness-kickoff.md`. Supported update rollback is implemented locally and remains subject to sandbox validation before production use.

## Local Readiness Package

The repository-side Phase 6 implementation package is complete. The remaining validation items require a Business Central sandbox run.

Do not use Phase 6 execution in production until:

- Sandbox validation is completed for grouped update execution.
- Release readiness records the target table/field behavior and any unsupported platform results.

## ASAP Track

| Order | Work Item | Evidence Required | Unlocks |
| --- | --- | --- | --- |
| 1 | Deploy the current package to a Business Central sandbox | Extension version, environment, company, user ids redacted, and deployment result | Sandbox proof can begin |
| 2 | Verify `SUPER` and non-`SUPER` access | `SUPER` user can open BCDA pages; non-`SUPER` user is denied | Access gate evidence |
| 3 | Verify RecordId/RecordRef read behavior | Simple-key and composite-key target selection results, selected-field preview results, and sanitized failures | Matrix selector and richer preview planning |
| 4 | Verify representative scalar field behavior | Text, Code, Decimal, Date, DateTime, Boolean, GUID, Option/Enum read and parse behavior; unsupported field failures | Serializer and execution type support |
| 5 | Verify target write behavior in sandbox | Normal table update success/failure, hidden/protected table result, posted table result, sanitized platform errors | Release readiness evidence |
| 6 | Verify `Allow Data Policies` behavior | Policy records bypassed only when setup is off; BCDA app-owned, unsupported, unaudited, metadata-incomplete, and non-`SUPER` paths stay blocked | Policy-bypass evidence |
| 7 | Run execution validation scenarios | Sandbox validation records execution, failure, audit, rollback snapshot, access, and blocked-behavior results | Phase 6 completion evidence |

## Readiness Exit Criteria

Before Phase 6 is production-ready, all of these must be true:

- Sandbox validation covers RecordRef/FieldRef write behavior.
- Sandbox validation covers supported and unsupported field types.
- Sandbox validation covers `Allow Data Policies` on and off.
- `docs/code-generation-readiness.md` records Phase 6 local implementation as complete.

## Sandbox Validation Rule

Use only artificial sandbox data. Do not record customer data, posted values, hidden values, credentials, or full sensitive values in readiness, security, test, or support notes.
