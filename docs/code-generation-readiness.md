# Code Generation Readiness

## Current Status

Ready for continuous local implementation.

Local AL code may be generated or changed without per-phase paper confirmation when it preserves the BCDA safety controls: `SUPER` access, correction request workflow, policy checks, mandatory append-only audit metadata, rollback snapshot visibility, redaction, and production validation boundaries.

Implemented local runtime slices include:

- non-mutating target selection and request preview,
- supported grouped `Update` execution with request-wide validation and all-or-nothing transaction behavior,
- supported primary-key `Rename` execution with request-wide validation, renamed-record identity capture, and rollback-unavailable status,
- supported record-level `Delete` execution with rollback-unavailable status,
- supported grouped `Insert` execution with one new record per request/table/insert-group and rollback-unavailable status,
- request-level rollback staging from completed supported `Update` requests,
- filtered audit metadata export,
- governed retention cleanup for expired BCDA-owned operation records.

Runtime and production reliance still require sandbox validation for representative Business Central target data and platform behavior.

## Minimal Pre-Read

Before ordinary AL implementation, read only:

1. `docs/requirements.md`
2. `docs/acceptance-criteria.md`
3. this file
4. the AL files and nearby service/page/table contracts you are changing

Add other docs only when relevant:

- Architecture or ADRs for object boundary changes.
- Security review or risk register for `SUPER`, posted data, audit, rollback, redaction, export, or retention risk.
- Test plan for new behavior or changed validation expectations.
- User/admin docs for page, action, setup, or workflow changes.

`docs/traceability-matrix.md` is optional reference material, not an implementation gate.

## Allowed Local Implementation

Local implementation is allowed for:

- app-owned setup, policy, request, line, audit, snapshot, rollback, retention, and UX objects,
- security and policy hardening,
- target selection, preview, batch entry, and matrix-style staging,
- supported `Update` execution and generated rollback correction requests,
- operation-specific local work for rename/delete/insert rollback, richer rollback, validate-trigger dry-run, export, retention, and APIs when guarded or blocked at runtime until controls and validation exist,
- tests, analyzers, documentation, and release evidence.

## Permanent Blocks

Do not implement or enable:

- BCDA-specific permission set AL objects.
- Direct SQL mutation.
- Silent target data edits.
- Target mutation without a correction request.
- Audit deletion outside governed retention.
- Export of target values, target record identity text, or rollback snapshot payloads by default.
- Production enablement without sandbox validation evidence.

## Runtime-Gated Work

The following may be developed locally, but must remain disabled, blocked, or guarded until operation-specific controls and sandbox validation exist:

- Rename rollback, delete rollback, insert rollback, broader non-update rollback, and conflict override.
- Validate-trigger dry-run or target write rehearsal.
- Full target record matrix selector or arbitrary target filtering/search.
- Unfiltered, unredacted, snapshot-payload, or external API export.
- Cleanup of active requests, pending approvals, incomplete execution, retained rollback dependencies, or target Business Central business data.

## Validation Expectations

For AL changes:

- Compile the extension.
- Run CodeCop, UICop, and PerTenantExtensionCop with `ruleset.json`.
- Add or update test-plan/manual validation scenarios when behavior changes.
- Keep sandbox validation pending unless the user is explicitly collecting release evidence.

For production reliance, sandbox validation must cover the affected:

- `SUPER` and non-`SUPER` access paths,
- policy and approval paths,
- target record identity and field type behavior,
- execution and rollback request behavior,
- audit and redaction behavior,
- export and retention behavior,
- upgrade readability when app-owned operation records are involved.

## Done For Local Code

A local implementation slice is done when:

- requested behavior is implemented,
- compile/analyzers pass or exceptions are documented,
- core controls remain intact,
- docs are updated only where behavior, risk, or user workflow changed,
- remaining sandbox or production validation gaps are explicit.

## Current Evidence

- AL compiler 17.0.34.45391 has compiled the project against Business Central 28 symbols.
- CodeCop, UICop, and PerTenantExtensionCop have passed with `ruleset.json`; `PTE0004` is intentionally suppressed because ADR-003 forbids BCDA-specific permission set objects.
- Object range 88100..88149 has been used for BCDA objects.
- Runtime behavior beyond the implemented supported slices remains blocked or sandbox-validation pending as described above.
