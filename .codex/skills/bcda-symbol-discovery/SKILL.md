---
name: bcda-symbol-discovery
description: Business Central symbol and runtime evidence collection for BC Data Agent. Use before implementing AL behavior that depends on BC symbols, RecordRef or FieldRef behavior, SUPER access checks, table access behavior, posted table modification, field type support, export mechanisms, upgrade behavior, or any platform-dependent implementation detail.
---

# BCDA Symbol Discovery

## Purpose

Record platform facts before implementation depends on them. This prevents guessing about what Business Central AL can read, write, validate, export, or upgrade.

## Required Reading

Read:

- `docs/symbol-discovery.md`
- `app.json`
- `.vscode/launch.json`
- `docs/open-decisions.md`
- `docs/architecture.md`
- `docs/implementation-contracts.md`

## Discovery Workflow

1. Confirm target BC version from `app.json` and launch settings.
2. Download or inspect symbols for the target environment.
3. Record exact package versions and relevant symbols in `docs/symbol-discovery.md`.
4. Verify object name and ID conflicts before implementation.
5. Probe representative normal, hidden, and posted tables in sandbox.
6. Verify supported field types and unsupported field types.
7. Verify `SUPER` and non-`SUPER` behavior for read, modify, export, and audit pages.
8. Update open decisions when platform evidence changes the design.

## Evidence To Capture

For each fact, record:

- Environment.
- BC version.
- Symbol package/version.
- Table or field tested.
- Operation tested.
- Result.
- Error message if sanitized and relevant.
- Implementation implication.

## Must-Verify Topics

- RecordRef and FieldRef read/write behavior.
- Validation behavior and trigger expectations.
- Posted table modification limits.
- FlowField, BLOB, Media, Enum, Option, DateTime, GUID, Decimal, Code, and Text behavior.
- `SUPER` access behavior and any available AL detection/enforcement mechanism.
- Audit/export mechanisms.
- Upgrade behavior for app-owned tables.

## Blocking Rule

If a behavior is not recorded in `docs/symbol-discovery.md`, do not implement code that depends on it.

## Output Standard

Update `docs/symbol-discovery.md`, list verified facts, list unresolved platform risks, and identify any decisions that must change.
