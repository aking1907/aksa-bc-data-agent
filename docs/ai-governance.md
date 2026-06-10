# AI Governance

## Context Before AI Changes

AI-assisted changes should use the lean process in `docs/sdd-index.md`: read the smallest set of docs needed to understand the requested behavior, the owning code, and the safety controls involved.

For ordinary AL work, start with:

- `docs/sdd-index.md`
- `docs/requirements.md`
- `docs/acceptance-criteria.md`
- `docs/code-generation-readiness.md`
- the relevant AL source files

Open deeper docs only when the change touches that area:

- `docs/architecture.md`, `docs/adr/`, or `docs/implementation-contracts.md` for object boundaries and service ownership.
- `docs/security-review.md` or `docs/risk-register.md` for `SUPER` access, audit, rollback, redaction, export, retention, posted data, or production risk.
- `docs/app-design.md`, `UserGuide.md`, or `docs/admin-guide.md` for page, action, setup, or workflow changes.
- `docs/test-plan.md` for changed behavior or validation coverage.
- Deployment, operations, release, upgrade, readiness, or traceability docs only when those areas are affected.

Use the relevant project-local skill from `.codex/skills/` when the task needs that guardrail:

- `bcda-sdd-steward` for SDD alignment and documentation changes.
- `bcda-architecture-guardian` for architecture or ADR changes.
- `bcda-al-implementation` for AL code under the standing implementation authorization.
- `bcda-security-audit` for `SUPER` access, audit, rollback, redaction, posted data, or production risk.
- `bcda-ux-design` for pages, actions, captions, and workflow design.
- `bcda-test-validation` for tests and validation evidence.
- `bcda-release-ops` for deployment, upgrade, operations, and release work.

Project prompts in `.codex/prompts/` are optional helpers for repeatable workflows, not required gates.

## Cost Governance

AI usage cost is managed through the compact project artifacts in `cost/`.

- Use `cost/ai-cost-policy.md` for model tier rules, thresholds, logging expectations, and escalation rules.
- Use `cost/model-pricing.md` for dated pricing assumptions. Verify current provider pricing before formal budget reporting.
- Store only compact non-sensitive rollups in `cost/ai-usage-log.csv`.
- Regenerate the summary with `cost/update-ai-cost-report.ps1`.
- Do not store raw prompts, full transcripts, tool output, secrets, customer data, Business Central posted values, hidden values, or rollback before-images in cost files.

## What AI May Do Now

- Improve documentation.
- Identify inconsistencies.
- Draft tests or implementation plans.
- Prepare sandbox validation checklists.
- Create or improve project-local skills that reinforce the SDD approach.
- Create or improve optional project-local prompts.
- Generate or modify AL source under the standing authorization in `docs/code-generation-readiness.md` when the work preserves user review, data policies, `SUPER`, audit, redaction, rollback, tests, and runtime/production validation boundaries.

## What AI May Not Do Now

- Enable runtime behavior outside the safety boundaries in `docs/code-generation-readiness.md`.
- Implement record modification without request, policy, audit, `SUPER`, and rollback or rollback-unavailable context.
- Enable non-update rollback, conflict override, export, cleanup, or APIs in production before their controls and validation evidence exist.
- Add hidden bypasses.
- Store secrets or real customer data.
- Remove audit, policy, approval, or rollback requirements.
- Ignore relevant project-local skills when changing governed behavior.

## Validation Requirements

Before implementation depends on them, record validation evidence for:

- Posted table policy.
- `SUPER`-only access model.
- Sensitive value redaction.
- Rollback conflict behavior.
- Production deployment.
- Any generated AL code that depends on platform-specific behavior before production reliance.

## Evidence Required From AI-Assisted Changes

- Files changed.
- Requirement and acceptance alignment.
- Test or validation evidence.
- Risk updates when behavior changes.
- Clear statement if tests were not run.

## Prohibited Outputs

- Secrets, credentials, connection strings, or real customer data.
- Untraceable mutation paths.
- Audit deletion behavior.
- Direct SQL correction instructions.
- Production deployment advice without sandbox validation.
