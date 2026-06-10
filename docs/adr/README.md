# ADR Index

Architecture Decision Records capture choices that shape implementation. Add a new ADR for material changes to security posture, data ownership, rollback behavior, platform integration, or implementation gating.

## Decisions

| ID | Title | Status | Summary |
| --- | --- | --- | --- |
| ADR-001 | Governed Correction Workflow With Append-Only Audit | Accepted | All data mutations must pass through policy, request, preview, execution, audit, and rollback services. |
| ADR-002 | Documentation-First Code Generation Gate | Superseded by ADR-006 | Original gate requiring code generation to wait for readiness approval. |
| ADR-003 | SUPER-Only Access Without BCDA Permission Sets | Accepted | The extension must not create custom permission sets; functionality is available only to existing Business Central SUPER users. |
| ADR-004 | Configurable Rollback Logging And Retention | Accepted | Audit metadata is mandatory, rollback snapshots are configurable, and operation retention is user-controlled. |
| ADR-005 | RecordId-Based Target Selection With Matrix Editing | Accepted | Correction lines use canonical target record identity instead of user-entered composite keys, with a matrix-style selector/editor planned after sandbox validation. |
| ADR-006 | Continuous Implementation Authorization With Runtime Gates | Accepted | Local AL implementation has standing authorization under the SDD; production/runtime enablement remains gated by controls and validation evidence. |

## Rules

- ADRs are append-only records of decisions.
- Supersede an ADR with a new ADR instead of rewriting history after implementation starts.
- Link each ADR to affected requirements, acceptance criteria, and risks.
- Proposed ADRs may be added before implementation; accepted ADRs must be followed by code.
