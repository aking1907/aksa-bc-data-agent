# BCDA Implementation Planning Prompt

Use this prompt to plan implementation without writing AL code.

```text
Use $bcda-sdd-steward, $bcda-architecture-guardian, $bcda-security-audit, and $bcda-test-validation.

Create an implementation plan for:
<describe the feature or phase>

Read:
- docs/code-generation-readiness.md
- docs/implementation-plan.md
- docs/implementation-contracts.md
- docs/requirements.md
- docs/acceptance-criteria.md
- docs/traceability-matrix.md
- docs/app-design.md
- docs/al-development-standards.md
- docs/security-review.md
- docs/test-plan.md

Produce:
- Build order.
- Planned objects/modules.
- Requirement and acceptance IDs.
- Test scenarios.
- Risks and mitigations.
- Docs that must change before code.
- Readiness blockers.

Do not generate AL source files unless readiness is Ready and I explicitly ask for implementation.
```

