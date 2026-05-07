---
name: start-project-template
description: Reusable project-start SDD template. Use when beginning a new app, integration, prototype, Code Games idea, or software product and Codex should create the initial documentation set before implementation so future agents can understand the idea, scope, decisions, architecture, tests, and delivery plan without rediscovery.
---

# Start Project Template

Act as a project-start SDD facilitator. Before implementation, create a compact documentation baseline that captures the idea, constraints, decisions, and validation plan clearly enough that a later AI agent can continue without asking the same discovery questions.

## Core Rule

Do not start coding from a raw idea. First create the minimum complete SDD package, then gate implementation through `docs/code-generation-readiness.md`.

If the user asks for a fast prototype, still create a lean version of each required document. Prefer concise but complete documents over long documents.

## Kickoff Intake

Capture or infer these facts before creating the docs:

1. Product idea and business problem.
2. Target users and their primary workflow.
3. Platform, language, framework, hosting, and repository constraints.
4. Phase 1 scope and explicit non-goals.
5. External systems, APIs, data sources, credentials, and security concerns.
6. Demo or release deadline, if any.
7. Compliance, event, company, or customer rules.
8. What must be validated before implementation starts.

Ask only for blockers. If a detail can be safely marked as an assumption or open decision, document it and continue.

## Document Creation Order

Create the initial files in this order. Each file must be short enough to read quickly, but specific enough to drive implementation.

### 1. `docs/sdd-index.md`

Purpose: source-of-truth map for the whole project.

Include:

- Source order for all documents.
- Artifact coverage matrix.
- SDD rules.
- Readiness gates from discovery to release.
- Rule that lower-order docs cannot contradict higher-order intent.

### 2. `docs/project.md`

Purpose: main project specification and project memory.

Include:

- Project overview.
- Business goal.
- Current implementation mode.
- Personas.
- Scope and non-goals.
- Main workflows.
- Success definition.
- Known constraints.
- Documented phases.

### 3. `docs/requirements.md`

Purpose: stable requirement IDs.

Include:

- Functional requirements with IDs such as `REQ-001`.
- Data/security requirements.
- SDD/validation requirements.
- Requirement-to-acceptance references.
- Current phase boundary.

### 4. `docs/domain-model.md`

Purpose: shared business vocabulary.

Include:

- Bounded domain.
- Core terms and owners.
- Entities and value objects.
- Invariants and business rules.
- Domain events.
- Data ownership.
- Open modeling decisions.

### 5. `docs/architecture.md`

Purpose: high-level technical design.

Include:

- Architecture goals.
- Layers and responsibilities.
- Component map.
- Object/module map.
- Runtime flow.
- Error flow.
- Security model.
- Observability model.
- Upgrade and extension points.

### 6. `docs/adr/README.md`

Purpose: index of accepted or proposed architecture decisions.

Include:

- ADR table with ID, title, status, and summary.
- Rules for adding or changing ADRs.
- Link decisions to requirements and risks.

### 7. `docs/adr/ADR-001-*.md`

Purpose: first explicit architecture decision.

Create one ADR per material decision. Start with the biggest early decision, such as framework choice, integration pattern, data ownership, fail-open/fail-closed behavior, or project rule adoption.

Use:

```markdown
# ADR-001: <Decision Title>

## Status
## Context
## Decision
## Consequences
## Alternatives Considered
## Follow-Up
```

### 8. `docs/open-decisions.md`

Purpose: prevent hidden assumptions.

Include a table with:

- ID.
- Decision.
- Options.
- Current lean.
- Needed by.
- Status.

Use open decisions for unknown runtime behavior, security policy, API shape, data ownership, or platform capability.

### 9. `docs/data-model.md`

Purpose: data structures and ownership.

Include:

- App-owned tables/entities.
- Field list or schema outline.
- Data classification or sensitivity.
- Secret storage rules.
- Ownership and lifecycle.
- Retention rules.
- Migration notes.

### 10. `docs/api-contract.md`

Purpose: external and internal API contract.

Include when APIs exist or are expected:

- Endpoints.
- Authentication.
- Headers.
- Request shape.
- Response shape.
- Error shape.
- Redaction rules.
- Contract assumptions.
- Versioning and test data.

If there is no API, state that clearly and document why this file is intentionally minimal.

### 11. `docs/symbol-discovery.md`

Purpose: evidence for framework or platform-dependent behavior.

Include:

- SDK, library, platform, or symbol facts that implementation depends on.
- Event hooks, interfaces, extension points, commands, routes, or schemas discovered.
- What was verified locally.
- What remains unverified.

Do not implement behavior that depends on platform internals until this file records the evidence.

### 12. `docs/acceptance-criteria.md`

Purpose: externally observable done conditions.

Include:

- Given/When/Then criteria.
- Success, failure, permission, security, and upgrade scenarios.
- Separate current behavior from future behavior.
- Stable IDs such as `AC-001`.

### 13. `docs/implementation-contracts.md`

Purpose: implementation-level commitments.

Include:

- Object/module names.
- Procedure/function contracts.
- Field/configuration contracts.
- Error message contracts.
- Logging contracts.
- Blocked behavior.
- Validation boundaries.

This file lets implementation continue without guessing names or responsibilities.

### 14. `docs/implementation-plan.md`

Purpose: build sequence.

Include:

- Guiding rules.
- Phases.
- Build order.
- Exit criteria per phase.
- Definition of ready.
- Definition of done.
- Deferred work.

### 15. `docs/code-generation-readiness.md`

Purpose: final gate before code.

Include:

- Current readiness status.
- Required docs to read before generation.
- Allowed now.
- Required runtime behavior.
- Blocked for current generation.
- Open decisions that still block future work.
- Definition of done for generated code.

### 16. `docs/test-plan.md`

Purpose: validation map.

Include:

- Test types.
- Scenario matrix mapping tests to acceptance criteria.
- Local build validation.
- API or integration validation.
- Minimum pre-release validation.

### 17. `docs/traceability-matrix.md`

Purpose: prove every implementation task is justified.

Include a table with:

- Requirement.
- Source.
- Architecture component.
- Code object or module.
- Acceptance/test reference.
- Status.

Every new code object should have a row or be covered by one.

### 18. `docs/risk-register.md`

Purpose: active risk management.

Include:

- Risk ID.
- Risk.
- Impact.
- Probability.
- Severity.
- Mitigation.
- Status.

Capture technical, product, compliance, security, schedule, and integration risks.

### 19. `docs/deployment.md`

Purpose: environment and release steps.

Include:

- Target environment.
- Pre-deployment checklist.
- Install or deployment steps.
- Configuration steps.
- Upgrade steps.
- Production notes.
- Rollback or mitigation.

### 20. `docs/operations-runbook.md`

Purpose: support guide after deployment.

Include:

- Current support boundary.
- Setup checks.
- How to test connection or health.
- How to run the main workflow.
- Troubleshooting steps.
- Common failure categories.
- Safe logging guidance.
- Escalation package.

### 21. `docs/upgrade-release-strategy.md`

Purpose: lifecycle governance.

Include:

- Release principles.
- Versioning strategy.
- Branching strategy.
- Release gates.
- Environment flow.
- Upgrade strategy.
- Rollback and hotfix rules.
- Release notes minimum content.

### 22. `docs/ai-governance.md`

Purpose: rules for AI-assisted work.

Include:

- Required context before AI changes.
- What AI may and may not implement.
- Human review requirements.
- Evidence required from AI-assisted changes.
- Prohibited outputs, especially secrets or untraceable behavior.

### 23. `README.md`

Purpose: human-facing project entry point.

Include:

- What the project is.
- Why it matters.
- Current capabilities.
- Current boundaries.
- Project structure.
- Key documentation links.
- Build or run validation command.
- Demo story.
- Status and next steps.

## Optional Project Assets

Create these only when they add real value:

- `.codex/prompts/` for repeatable AI workflows.
- `.codex/skills/` for project-specific skills.
- `docs/admin-guide.md` for user-facing setup.
- `docs/release-notes.md` for deployable package history.
- `docs/demo-script.md` for event demos.
- `docs/security-review.md` for high-risk integrations.

## Quality Bar

Before implementation starts:

- Every requirement has acceptance coverage.
- Every acceptance criterion has a test scenario.
- Every material decision is in an ADR or open decision.
- Every risky unknown has a named owner or closing condition.
- Current behavior and future behavior are separated.
- Secrets, credentials, and sensitive data handling are documented.
- The README points to the SDD source of truth.
- `docs/code-generation-readiness.md` says exactly what can be generated now.

## Maintenance Rule

When behavior changes, update these together:

1. Requirements.
2. Acceptance criteria.
3. Architecture or ADRs.
4. Implementation contracts.
5. Test plan.
6. Traceability matrix.
7. Risk register.
8. Deployment and operations docs when user/admin behavior changes.

Do not let code become the only place where project intent exists.
