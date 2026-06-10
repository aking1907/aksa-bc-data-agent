# ADR-002: Documentation-First Code Generation Gate

## Status

Superseded by ADR-006

## Context

The project touches high-risk Business Central data. Implementation details must stay aligned with scope, risk, and safety requirements so future agents and humans can continue without rediscovering intent.

## Decision

The original decision was that no AL code would be generated outside the scope that `docs/code-generation-readiness.md` marked Ready and the user explicitly requested.

This decision is superseded by ADR-006. The documentation-first intent remains, but local implementation now has standing authorization under the SDD and runtime/production enablement remains gated by controls and validation evidence.

The readiness gate had to confirm:

- Required SDD docs exist.
- Blocking open decisions are closed or accepted as assumptions.
- Symbol-dependent BC behavior is verified.
- Security, audit, rollback, and test expectations are documented.

## Consequences

- The initial repository contains documentation and config only.
- Code generation can be reviewed against stable requirements and validation evidence.
- Future AI-assisted work has an explicit rule to avoid premature implementation.

## Alternatives Considered

| Alternative | Reason Rejected |
| --- | --- |
| Start coding immediately | Too easy to create unsafe mutation paths. |
| Document after implementation | Risks making code the only source of project intent. |

## Follow-Up

- Update readiness status after sandbox validation and security review.
- Keep requirements, acceptance criteria, and validation evidence aligned with every behavior change.
