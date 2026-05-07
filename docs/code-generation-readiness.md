# Code Generation Readiness

## Current Status

Not Ready.

The repository is prepared for project planning only. Do not generate AL code yet.

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

## Blocked Now

- Creating AL source files.
- Creating tables, pages, codeunits, reports, or any AL source objects.
- Creating BCDA-specific permission set AL objects is permanently blocked by ADR-003.
- Implementing record modification.
- Implementing rollback.
- Adding external API endpoints.
- Adding sample data that resembles real customer data.

## Required Runtime Behavior Before Code

- Confirm BC 28.0 symbols are downloaded and documented.
- Confirm no object ID conflicts for range 88100-88149.
- Confirm default policy for posted tables.
- Confirm field type support for Phase 1.
- Confirm approval model among `SUPER` users.
- Confirm rollback snapshot retention.
- Confirm sensitive value display and export rules.
- Confirm rollback snapshot logging defaults and policy overrides.
- Confirm operation retention implementation and minimum retention periods.
- Confirm analyzer baseline and deployment target cop.

## Open Decisions That Block Future Work

- OD-003 Default posted table policy.
- OD-004 Approval model among `SUPER` users.
- OD-005 Validation mode.
- OD-006 Field type support.
- OD-007 Rollback conflict policy.
- OD-008 Audit retention.
- OD-011 Sensitive value display.
- OD-013 `SUPER` access enforcement.
- OD-014 Default rollback snapshot logging.
- OD-015 Operation retention implementation.
- OD-016 Minimum retention periods.

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
