# AI Governance

## Required Context Before AI Changes

An AI agent must read:

- `docs/sdd-index.md`
- `docs/project.md`
- `docs/requirements.md`
- `docs/architecture.md`
- `docs/app-design.md`
- `docs/al-development-standards.md`
- `docs/code-generation-readiness.md`
- `docs/readiness-audit.md`
- `docs/security-review.md`
- `docs/traceability-matrix.md` when reference coverage is useful

It must also use the relevant project-local skill from `.codex/skills/`:

- `bcda-sdd-steward` for planning, readiness, and documentation alignment.
- `bcda-architecture-guardian` for architecture or ADR changes.
- `bcda-al-implementation` for AL code after the readiness gate allows it.
- `bcda-security-audit` for `SUPER` access, audit, rollback, redaction, posted data, or production risk.
- `bcda-ux-design` for pages, actions, captions, and workflow design.
- `bcda-test-validation` for tests and validation evidence.
- `bcda-release-ops` for deployment, upgrade, operations, and release work.

For repeatable workflows, start from the matching project prompt in `.codex/prompts/`. Use `session-kickoff.prompt.md` at the beginning of a new session and `docs-consistency-check.prompt.md` after substantial documentation changes.

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
- Create or improve project-local prompts that reinforce the SDD approach.
- Generate or modify AL source only inside the exact scope allowed by `docs/code-generation-readiness.md`.

## What AI May Not Do Now

- Generate AL source outside the exact scope allowed by `docs/code-generation-readiness.md`.
- Implement record modification outside the currently allowed execution and rollback scopes.
- Implement non-update rollback, conflict override, export, or cleanup outside the currently allowed scope.
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
- Any generated AL code once the readiness gate allows code.

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
