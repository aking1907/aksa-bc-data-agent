# Implementation Plan

## Guiding Rules

- Start with safety infrastructure before mutation features.
- Keep all logic out of pages when a service object should own it.
- Add tests alongside each behavior phase.
- Update traceability when adding any object or workflow.
- Do not implement direct table editing without request, policy, audit, and rollback context.
- Use the relevant project skill from `.codex/skills/` before changing architecture, AL code, UX, security, tests, release, or symbol discovery docs.

## Phases

| Phase | Build Order | Exit Criteria |
| --- | --- | --- |
| 0 Documentation | Complete SDD package and readiness gate | Docs exist; implementation scope is gated. |
| 1 Symbol Discovery | Download symbols and verify BC runtime assumptions | `symbol-discovery.md` updated with evidence. |
| 2 Foundation Data | Setup, policy, request, line, audit, snapshot, rollback storage | App compiles; table upgrade strategy drafted. |
| 3 Security And Policy | `SUPER` access checks, policy evaluation, redaction rules | Non-`SUPER` users blocked; policy tests pass. |
| 4 Setup, Retention, And UX Shell | Setup pages, policy pages, retention settings, request list/card shell | Users can configure rollback logging and retention; pages match `app-design.md`. |
| 5 Preview Workflow | Metadata discovery and dry-run preview | Preview reads targets without mutation and shows rollback/retention impact. |
| 6 Execution Workflow | Approved field-level correction with mandatory audit and optional rollback snapshots | Sandbox correction succeeds and failures are audited. |
| 7 Rollback Workflow | Rollback from retained before-images with conflict checks | Rollback succeeds, reports conflict, or reports unavailable snapshots safely. |
| 8 Audit, Retention, And Export | SUPER-gated audit pages, retention status, cleanup, and export | Retention cleanup and export work with redaction policy. |
| 9 Hardening | Analyzers, performance, upgrade, deployment, operations | Release validation passes in sandbox. |

## Project Skill Support

| Skill | Phase Support |
| --- | --- |
| `bcda-sdd-steward` | All phases; keeps docs, readiness, and traceability aligned. |
| `bcda-symbol-discovery` | Phase 1; records BC platform evidence. |
| `bcda-architecture-guardian` | Phases 1-9; protects object and service boundaries. |
| `bcda-al-implementation` | Phases 2-9; guides AL code after readiness approval. |
| `bcda-security-audit` | Phases 2-9; reviews high-risk mutation, audit, rollback, retention, and redaction. |
| `bcda-ux-design` | Phases 3-8; shapes safe BC pages and workflows. |
| `bcda-test-validation` | Phases 2-9; maps tests to acceptance and release gates. |
| `bcda-release-ops` | Phases 6-9; prepares deployment, operations, upgrade, and release evidence. |

## Definition Of Ready For Code

- User confirms implementation should begin.
- `code-generation-readiness.md` status is Ready for the requested scope.
- BC symbols are downloaded and documented.
- Object ID allocation is confirmed.
- Posted table default policy is confirmed.
- Field type support boundary is confirmed.
- Approval model among `SUPER` users is configurable: approval with a separate approver by default, no-approval or self-approval allowed when setup permits it.
- Rollback snapshot logging default is confirmed.
- Audit/snapshot/technical log retention periods and implementation approach are confirmed.
- Required analyzer baseline is confirmed.

Foundation data code may start when the requested scope is limited to setup, policy, request, audit, snapshot, rollback-state, retention-log, SUPER-gated shell pages, and supporting services. Execution, rollback execution, export, and arbitrary target record preview require a later readiness review.

## Definition Of Done

- Code compiles in target BC environment.
- Requirements have acceptance and tests.
- Unauthorized access is blocked.
- Audit entries are append-only during operations; governed retention handles expired operation records.
- Rollback does not erase audit history.
- Rollback-disabled and rollback-expired states are visible and safe.
- Retention cleanup respects configured periods and protects active records.
- Required AL analyzers pass or have documented exceptions.
- Sensitive values are redacted in logs and exports.
- Sandbox deployment, upgrade, correction, rollback, and export scenarios pass.

## Deferred Work

- External APIs.
- Bulk correction import.
- External approval workflow integration.
- AI-assisted correction suggestions.
- BLOB/media modification.
- Automated table risk classification beyond initial heuristics.
