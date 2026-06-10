# ADR-006: Continuous Implementation Authorization With Runtime Gates

## Status

Accepted

## Context

BC Data Agent started with a documentation-first code generation gate so high-risk data correction code would not be generated before the project had requirements, acceptance criteria, security review, and readiness evidence.

The project now has an SDD baseline, local Phase 2-8 implementation, Phase 9 hardening evidence, and explicit user direction to stop using per-phase paper confirmation as a blocker for code development. The project still handles sensitive and posted Business Central data, so implementation freedom must not become runtime freedom.

## Decision

Local AL implementation has standing authorization when the work:

- follows the SDD source of truth,
- preserves user review and data policies,
- preserves existing Business Central `SUPER` access checks,
- writes mandatory append-only audit evidence,
- keeps rollback or rollback-unavailable states explicit,
- protects sensitive values through redaction and channel controls,
- keeps analyzers, tests, and validation evidence current,
- keeps production/runtime enablement gated until sandbox validation and release evidence exist.

Per-phase paper confirmation is no longer required before code development. Missing sandbox validation blocks production reliance and runtime enablement, not local implementation work that remains guarded, testable, and documented.

## Consequences

- Future implementation work can proceed without waiting for a new readiness phase approval.
- Runtime behavior can still block or disable features whose controls are incomplete.
- Production deployment remains blocked until sandbox validation and release evidence pass.
- ADR-002 is superseded for code-generation gating, but its documentation-first intent remains active.

## Alternatives Considered

| Alternative | Reason Rejected |
| --- | --- |
| Keep per-phase code gates | Slows implementation after the SDD and local hardening baseline already exist. |
| Fully ungated implementation and runtime enablement | Too risky for hidden, posted, financial, and sensitive Business Central data. |
| Remove policies and review entirely | Conflicts with the product purpose and mandatory security invariants. |

## Follow-Up

- Keep `docs/code-generation-readiness.md` focused on standing implementation authorization and runtime/production safety boundaries.
- Keep `docs/test-plan.md`, `docs/security-review.md`, and release validation docs current as new operation types or APIs are implemented.
