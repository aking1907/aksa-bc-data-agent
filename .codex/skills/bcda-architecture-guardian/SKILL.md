---
name: bcda-architecture-guardian
description: Architecture guardrails for BC Data Agent. Use when designing or reviewing Business Central AL components, ADRs, object boundaries, data ownership, service layering, policy flow, rollback flow, audit architecture, extension points, or any implementation approach that could affect hidden or posted data correction.
---

# BCDA Architecture Guardian

## Purpose

Protect the architecture from becoming a generic table editor. Preserve the governed correction workflow: request, policy, preview, approval, execution, audit, and rollback.

## Required Reading

Read:

- `docs/architecture.md`
- `docs/app-design.md`
- `docs/al-development-standards.md`
- `docs/domain-model.md`
- `docs/implementation-contracts.md`
- `docs/adr/README.md`
- Relevant ADRs in `docs/adr/`
- `docs/open-decisions.md`
- `docs/security-review.md`

## Architecture Rules

- Keep mutation orchestration out of pages.
- Route all changes through planned service objects.
- Keep policy checks close to execution, not only in UI.
- Capture before-images before mutation.
- Write append-only audit for attempts, successes, failures, approvals, and rollback.
- Treat rollback as a new governed operation.
- Keep mandatory audit metadata separate from configurable rollback snapshots.
- Use user-controlled retention for app-owned operation records, preferably through Business Central retention policy support.
- Keep BC Data Agent data separate from Business Central-owned target records.
- Prefer deny-first policies for posted and hidden data.

## Review Checklist

For each proposed component, verify:

- Which requirement and acceptance criterion justify it.
- Which layer owns the behavior.
- Whether it can mutate target data.
- Whether policy, approval, audit, and rollback are enforced.
- Whether rollback snapshot logging and retention state are visible before execution.
- Whether it exposes sensitive values.
- Whether it needs symbol evidence before implementation.
- Whether an ADR is needed or must be updated.

## Object Boundary Guidance

- Pages collect intent and display state.
- Orchestrator codeunits coordinate workflow.
- Policy codeunits decide allow/block and required approvals.
- Metadata codeunits discover BC table and field facts.
- Serializer codeunits own typed value conversion.
- Audit codeunits own append-only writes.
- Rollback codeunits own conflict checks and restore flow.
- Retention codeunits own retention registration/status and cleanup delegation.

## ADR Triggers

Create or update an ADR when deciding:

- Validation mode.
- Posted table default behavior.
- Rollback conflict policy.
- Sensitive value storage or display model.
- External API exposure.
- Major object model or data ownership changes.

## Output Standard

Report:

- Architecture fit.
- Required docs or ADR updates.
- Risks introduced or reduced.
- Any implementation blockers.
