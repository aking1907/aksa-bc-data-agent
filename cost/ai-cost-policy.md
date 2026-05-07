# AI Cost Policy

## Purpose

This document defines how AI usage cost is controlled for BC Data Agent.

The project is security-sensitive because it is intended to support controlled modification of hidden and posted Business Central data, with auditability and rollback. AI cost management must therefore balance economy with enough reasoning depth for safe SDD, architecture, security, and implementation decisions.

## Policy Goals

The project will manage AI cost to ensure:

1. AI spend is visible.
2. High-cost usage is intentional.
3. Premium models are used for high-risk reasoning, not routine formatting.
4. Repeated rework is reduced through SDD discipline.
5. Cost can be reviewed by task, phase, and agent role.
6. Cost records do not expose prompts, secrets, customer data, or Business Central data values.

## Scope

This policy applies to AI-assisted:

- SDD document creation and maintenance,
- architecture and ADR review,
- Business Central symbol discovery support,
- security and permissions review,
- UX and usability design,
- AL implementation planning,
- code generation after readiness approval,
- test design and verification,
- release and operations documentation.

It applies to all AI-assisted project work unless explicitly excluded.

## Approved Model Usage Tiers

### Tier 1 - Low

Use for:

- formatting,
- extraction,
- small documentation updates,
- checklist maintenance,
- simple summaries,
- table generation.

### Tier 2 - Standard

Use for:

- SDD refinement,
- architecture expansion,
- test design,
- implementation planning,
- code review support,
- issue breakdown.

### Tier 3 - Premium

Use for:

- SUPER-only security design,
- posted-data modification and rollback decisions,
- audit integrity review,
- final readiness decisions,
- difficult Microsoft AL or Business Central behavior interpretation,
- final synthesis of high-impact documents.

Premium models must not become the default for routine project maintenance.

## Cost Control Requirements

### 1. Cheapest Sufficient Model

Every workflow should use the least expensive model that can produce safe, verifiable output for the task risk.

### 2. Premium Model Justification

If a premium model is used, at least one of these should be true:

- the task is high-risk,
- the task is high-value,
- lower-tier models failed materially,
- the output is a final synthesis or readiness decision,
- BC platform behavior is ambiguous and mistakes would be expensive.

### 3. Retry Discipline

If a task exceeds three retries for the same objective, pause and improve the prompt, SDD input, or acceptance criteria before continuing.

### 4. Context Discipline

Teams must avoid repeatedly sending the same long context unless necessary.

Preferred methods:

- reference existing artifacts,
- summarize long prior discussions,
- use specific file paths and line references,
- chunk large reviews by document family,
- keep prompt libraries focused and reusable.

### 5. No Sensitive Cost Logs

Cost files must never store:

- raw prompts containing sensitive detail,
- full tool output,
- full Codex transcripts,
- Business Central credentials,
- endpoint secrets,
- customer names or customer data,
- posted document values,
- hidden table values,
- rollback before-images.

## Budget Thresholds

These thresholds are starting governance values for BC Data Agent. Adjust them after the first implementation milestone if actual cost patterns justify it.

### Per-Run Thresholds

| Threshold | Amount | Action |
|---|---:|---|
| Low concern | under USD 1.00 | No special action. |
| Review suggested | USD 1.00 to USD 10.00 | Confirm the model and context were appropriate. |
| Review required | over USD 10.00 | Add an optimization note to the report. |

### Per-Task Thresholds

| Threshold | Amount | Action |
|---|---:|---|
| Low concern | under USD 10.00 | No special action. |
| Review suggested | USD 10.00 to USD 50.00 | Review model choice and retry count. |
| Review required | over USD 50.00 | Project owner or technical lead should review before repeating similar work. |

### Phase Targets

| Phase | Soft Target | Notes |
|---|---:|---|
| Documentation / SDD | USD 75.00 | Includes skills, prompts, readiness documents, and consistency checks. |
| Symbol discovery | USD 25.00 | Should be focused and evidence-driven. |
| Architecture / security | USD 75.00 | Premium use is acceptable for high-risk decisions. |
| Implementation planning | USD 40.00 | Should be bounded by readiness contracts. |
| Implementation | USD 100.00 per milestone | Track by milestone once AL generation begins. |
| Testing / release | USD 50.00 | Includes acceptance evidence and release documentation. |

### Project Thresholds

| Threshold | Amount | Action |
|---|---:|---|
| Monthly review threshold | USD 150.00 | Review cost report and model mix. |
| Project review threshold | USD 300.00 | Reassess prompt strategy and automation. |
| Hard review threshold | USD 500.00 | Pause non-critical AI work until reviewed. |

## Escalation Rules

Escalate for review when:

- a single run exceeds the per-run review threshold,
- a single task exceeds the per-task review threshold,
- total project spend exceeds 80 percent of the project review threshold,
- premium model use becomes routine,
- telemetry is missing for major workflows,
- retries suggest unclear requirements or unstable prompting,
- AI output proposes AL implementation before `docs/code-generation-readiness.md` is ready.

## Logging Requirements

All meaningful AI-assisted project work should be logged with at least:

- datetime,
- project,
- SDD phase,
- task,
- agent or role,
- model,
- effort level,
- input tokens,
- cached input tokens,
- output tokens,
- total tokens,
- estimated cost,
- actual cost if available,
- precision label,
- short non-sensitive notes.

If exact token telemetry is unavailable, use the best available estimate and mark it as `manual-estimate` or `blocked`.

Token telemetry cost is the real project usage cost calculated from measured tokens and the dated pricing table. Keep invoice or billing-export values separate as actual billed cost, because subscription credits, enterprise terms, hosted tool fees, taxes, or discounts can change the final amount charged.

## Reporting Cadence

### Automation

- use `cost/update-ai-cost-report.ps1` as the standard project report command,
- use `cost/update-ai-usage-from-codex.ps1` to import local Codex token telemetry before regenerating the report,
- store compact rollups in `cost/ai-usage-log.csv`,
- show readable measurements in `cost/ai-cost-report.md`,
- keep raw prompts, tool output, transcripts, secrets, and BC data out of project cost files.

### Per Request

- update compact token telemetry when a meaningful coding, SDD, research, review, or reporting request completes and telemetry is available,
- when telemetry is unavailable, record a `blocked` precision checkpoint for major milestones instead of inventing token or dollar values,
- if final telemetry is only available after the final response, update it at the start of the next meaningful request,
- do not append raw prompts, tool output, or per-message transcript data to the project repository.

### Long-Running Agent Work

- review cost every 30 minutes,
- update the compact CSV/report every 60 minutes or when the estimated request cost exceeds USD 5.00,
- mention material threshold crossings in final notes when cost is in scope.

### Weekly Or Per Milestone

- summarize total tokens,
- summarize estimated and actual cost,
- identify expensive tasks,
- identify expensive models,
- identify expensive phases,
- update `cost/ai-cost-report.md`,
- compare cost to delivered SDD or implementation value.

## Optimization Expectations

Teams are expected to:

- use low-cost models for drafts and table maintenance,
- reserve premium models for high-risk or final decisions,
- reuse prior SDD outputs,
- structure work by documented phases,
- reduce repeated broad context loading,
- pause expensive loops and improve the specification before retrying,
- keep implementation prompts tied to acceptance criteria and object contracts.

## Human Approval Checkpoints

Human review is recommended before:

- running long premium-model loops,
- processing very large contexts repeatedly,
- re-running architecture/security synthesis multiple times,
- entering a high-cost implementation cycle without approved readiness,
- using AI to reason over sensitive customer or posted-data examples.

## Non-Compliance Examples

Examples of poor cost control:

- using premium models for formatting only,
- regenerating the same artifact repeatedly without changing the prompt strategy,
- sending full project context to every small task,
- failing to log meaningful usage,
- mixing actual and estimated cost without labeling,
- storing sensitive prompts, credentials, or BC data in cost files,
- using AI broadly without budget awareness,
- generating AL code before SDD readiness is approved.

## Roles And Responsibilities

### Project Owner

Responsible for:

- approving budget thresholds,
- reviewing cost summaries,
- approving threshold changes.

### Technical Lead

Responsible for:

- ensuring logs are maintained,
- using cost-efficient workflows,
- reviewing abnormal usage,
- keeping cost practice aligned with SDD readiness.

### Contributors

Responsible for:

- following model tier rules,
- minimizing avoidable retries,
- recording or preserving usage metadata,
- keeping sensitive data out of cost artifacts.

## Final Rule

AI cost should be visible, reviewed, optimized, and tied to delivered project value without compromising Business Central data safety or audit integrity.
