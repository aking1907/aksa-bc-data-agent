# BCDA Architecture Review Prompt

Use this prompt when designing or reviewing a component or workflow.

```text
Use $bcda-architecture-guardian and $bcda-sdd-steward.

Review this BC Data Agent design or implementation idea:
<describe the idea>

Read:
- docs/architecture.md
- docs/app-design.md
- docs/al-development-standards.md
- docs/domain-model.md
- docs/implementation-contracts.md
- docs/adr/README.md
- docs/open-decisions.md
- docs/security-review.md

Evaluate:
- Fit with request/policy/preview/approval/execution/audit/rollback flow.
- Mandatory audit metadata.
- Configurable rollback snapshot logging.
- User-controlled operation retention.
- SUPER-only access.
- Business Central-native page/action design.
- Need for a new ADR or open decision.

Return findings, required doc updates, and implementation blockers.
```

