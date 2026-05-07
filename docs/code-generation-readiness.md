# Code Generation Readiness

## Current Status

Ready for Phase 2 Foundation Data only.

The user explicitly approved implementation. AL generation is allowed only for the foundation objects that store setup, policy, requests, lines, audit metadata, value snapshots, rollback operation state, retention log state, and SUPER-gated shell pages/services.

Mutation behavior remains blocked. Do not implement target record writes, posted/protected table correction, rollback execution, export, or value preview behavior until the relevant platform behavior is verified and this file is updated again.

## Required Docs To Read Before Generation

1. `docs/sdd-index.md`
2. `docs/project.md`
3. `docs/requirements.md`
4. `docs/domain-model.md`
5. `docs/architecture.md`
6. `docs/app-design.md`
7. `docs/al-development-standards.md`
8. `docs/adr/README.md`
9. `docs/open-decisions.md`
10. `docs/data-model.md`
11. `docs/symbol-discovery.md`
12. `docs/acceptance-criteria.md`
13. `docs/implementation-contracts.md`
14. `docs/security-review.md`
15. `docs/test-plan.md`
16. `docs/traceability-matrix.md`
17. `docs/readiness-audit.md`

## Allowed Now

- Documentation updates.
- Project configuration review.
- Symbol discovery planning.
- Security review refinement.
- App design refinement.
- Requirement and acceptance refinement.
- Phase 2 Foundation Data AL objects in the object range 88100-88149.
- SUPER runtime gate using the verified public `User Permissions`.IsSuper(UserSecurityId()) API.
- Business Central retention policy allowed-table registration shell for BCDA-owned operation tables.

## Blocked Now

- Creating BCDA-specific permission set AL objects is permanently blocked by ADR-003.
- Implementing record modification.
- Implementing rollback.
- Implementing dry-run target value preview against arbitrary business data.
- Implementing posted/protected table mutation.
- Implementing audit export.
- Adding external API endpoints.
- Adding sample data that resembles real customer data.

## Required Runtime Behavior Before Code

- Confirm BC 28.0 symbols are inspected for the specific APIs, objects, and platform behaviors used by generated code.
- Confirm no object ID conflicts for range 88100-88149.
- Confirm default policy for posted tables.
- Confirm field type support for Phase 1.
- Confirm approval model among `SUPER` users.
- Confirm rollback snapshot retention.
- Confirm sensitive value display and export rules.
- Confirm rollback snapshot logging defaults and policy overrides.
- Confirm operation retention implementation and minimum retention periods.
- Confirm analyzer baseline and deployment target cop.

## Decisions Closed For Foundation Code

- OD-003 Default posted table policy: deny until explicitly allow-listed.
- OD-004 Approval model among `SUPER` users: approval with a separate `SUPER` approver is the safer default, but setup can disable approval for standard requests or allow self-approval for one-person companies that accept the control tradeoff.
- OD-005 Validation mode: per-policy with validate-trigger default.
- OD-006 Field type support: scalar fields first; BLOB/media deferred.
- OD-007 Rollback conflict policy: stop on conflict by default.
- OD-008 Audit retention: configurable with conservative default.
- OD-011 Sensitive value display: SUPER-only UI with export/log redaction.
- OD-013 `SUPER` access enforcement: runtime `User Permissions`.IsSuper(UserSecurityId()) plus no BCDA permission sets.
- OD-014 Default rollback snapshot logging: policy controlled, required for posted/high-risk defaults.
- OD-015 Operation retention implementation: prefer BC native retention policies for BCDA-owned tables.
- OD-016 Minimum retention periods: foundation defaults captured in setup; release minimums require final business review.

## Remaining Blockers For Mutation Code

- Representative normal, hidden, posted, and protected table write behavior must be verified in sandbox.
- Field type serialization must be verified against target field classes and unsupported types.
- Rollback execution must be verified with conflict cases.
- Human security/business review must approve production policy.

## Definition Of Done For Generated Code

Generated code is done only when:

- It implements traceable requirements.
- It compiles.
- It has tests or a documented manual validation scenario.
- It preserves audit and rollback invariants.
- It does not expose sensitive values through logs, telemetry, or unauthorized pages.
- It follows `docs/al-development-standards.md` and passes required analyzers.
- It preserves mandatory audit metadata even when rollback snapshots are disabled.
- It updates docs when behavior changes.

## Foundation Validation Evidence

- Foundation AL compile passed with AL compiler 17.0.34.45391 against downloaded BC 28 symbols.
- Analyzer pass passed with CodeCop, UICop, and PerTenantExtensionCop using `ruleset.json`.
- Current foundation compile includes the BCDA Role Center page and `BC Data Agent` profile navigation.
- `PTE0004` is intentionally suppressed because ADR-003 forbids BCDA-specific permission set objects.
- Local symbol scan found no Microsoft symbol objects in object range 88100..88149.
