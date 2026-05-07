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
- `docs/traceability-matrix.md`

It must also use the relevant project-local skill from `.codex/skills/`:

- `bcda-sdd-steward` for planning, readiness, and documentation alignment.
- `bcda-architecture-guardian` for architecture or ADR changes.
- `bcda-al-implementation` for AL code after readiness is approved.
- `bcda-security-audit` for `SUPER` access, audit, rollback, redaction, posted data, or production risk.
- `bcda-ux-design` for pages, actions, captions, and workflow design.
- `bcda-test-validation` for tests and validation evidence.
- `bcda-release-ops` for deployment, upgrade, operations, and release work.
- `bcda-symbol-discovery` for BC platform evidence.

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
- Prepare symbol discovery checklists.
- Create or improve project-local skills that reinforce the SDD approach.
- Create or improve project-local prompts that reinforce the SDD approach.

## What AI May Not Do Now

- Generate AL source files.
- Implement record modification.
- Implement rollback.
- Add hidden bypasses.
- Store secrets or real customer data.
- Remove audit, policy, approval, or rollback requirements.
- Ignore relevant project-local skills when changing governed behavior.

## Human Review Requirements

Human review is required for:

- Posted table policy.
- `SUPER`-only access model.
- Sensitive value redaction.
- Rollback conflict behavior.
- Production deployment.
- Any generated AL code once readiness allows code.

## Evidence Required From AI-Assisted Changes

- Files changed.
- Requirement and acceptance links.
- Test or validation evidence.
- Risk updates when behavior changes.
- Clear statement if tests were not run.

## Prohibited Outputs

- Secrets, credentials, connection strings, or real customer data.
- Untraceable mutation paths.
- Audit deletion behavior.
- Direct SQL correction instructions.
- Production deployment advice without sandbox validation.
