---
name: cost-calculation
description: Calculate and maintain compact BC Data Agent AI usage cost reports from token telemetry, approved pricing assumptions, and project-local rollups. Use when preparing project cost summaries, AI governance evidence, budget reviews, or cost optimization notes.
---

# Cost Calculation

Act as the BC Data Agent AI cost accountant. Keep the report compact, auditable, and aligned with the SDD approach.

## Goal

The project needs ongoing AI usage measurements without storing raw prompts, customer data, tool output, or full session transcripts in the repository.

The desired pattern is:

- use local Codex/session telemetry as the raw source when available and attributable to this workspace,
- store only compact project rollups in `cost/ai-usage-log.csv`,
- summarize trend and quality-of-spend signals in `cost/ai-cost-report.md`,
- use `cost/model-pricing.md` for dated pricing assumptions,
- clearly separate exact token measurements from estimated or actual dollar values.

## Source Files

Use these files in this order:

1. `cost/ai-usage-log.csv`
2. `cost/ai-cost-report.md`
3. `cost/update-ai-usage-from-codex.ps1`
4. `cost/update-ai-cost-report.ps1`
5. `cost/model-pricing.md`
6. `cost/ai-cost-policy.md`
7. `docs/ai-governance.md`
8. `docs/readiness-audit.md`

If the CSV is empty, do not invent historic project costs. Use available Codex session telemetry only when the user asks for project usage and the telemetry can be tied to this workspace path.

## Automation Command

For BC Data Agent, update telemetry rollups and regenerate the compact report with:

```powershell
powershell -ExecutionPolicy Bypass -File cost\update-ai-usage-from-codex.ps1
```

Then run:

```powershell
powershell -ExecutionPolicy Bypass -File cost\update-ai-cost-report.ps1
```

The telemetry importer must:

- read local Codex session logs from the configured Codex home,
- filter sessions to the current project workspace,
- sum unique `last_token_usage` token events without storing raw prompts or transcripts,
- apply rates from `cost/model-pricing.md`,
- update `cost/ai-usage-log.csv`.

The report script must:

- read `cost/ai-usage-log.csv`,
- ignore `TOTAL` rows,
- sum compact checkpoint rows,
- regenerate `cost/ai-cost-report.md`,
- keep raw prompts, tool outputs, customer data, Business Central data values, and full telemetry out of the repository.

Do not manually invent token counts or dollar values when telemetry can be imported.

## SDD Alignment

Cost reporting supports SDD by making AI effort visible by phase. Use these phase names unless a more specific documented phase is approved:

| Phase | Use For |
|---|---|
| Documentation | SDD documents, README, guides, prompts, and skills. |
| SymbolDiscovery | Business Central 28 symbol discovery and capability verification. |
| Architecture | architecture, ADRs, domain/data model, risk decisions. |
| UX | usability, page design, confirmations, rollback workflows. |
| Security | SUPER-only checks, audit integrity, sensitive data handling. |
| ImplementationPlanning | readiness, sequencing, object contracts, work breakdown. |
| Implementation | AL implementation after code readiness approval. |
| Testing | acceptance evidence, automated/manual tests, regression review. |
| Release | deployment, upgrade, release notes, operations handoff. |

## Cadence

Do not update cost files after every tool call. That creates noise and a large log.

Use this cadence instead:

| Trigger | Required action |
|---|---|
| End of a meaningful coding, SDD, research, review, or reporting request | Run the Codex telemetry importer and report script when telemetry is available. If telemetry is unavailable, add a `blocked` precision checkpoint rather than inventing cost. |
| Long-running work over 30 minutes | Review whether a checkpoint is warranted. |
| Long-running work over 60 minutes | Add a checkpoint if telemetry is available and the work materially changed project artifacts. |
| Estimated request cost over USD 5.00 | Add a checkpoint and mention the threshold in final notes when cost is in scope. |
| User explicitly asks for cost | Run the report script and summarize the current report. |

Codex cannot write files after sending the final answer. If exact end-of-request telemetry appears only after the final response, update it at the start of the next meaningful request.

## Agent Contract

When this skill is relevant, Codex must treat cost reporting as part of done criteria:

- Before substantial work, check whether the report clearly belongs to BC Data Agent.
- During substantial work, avoid repeatedly sending unnecessary large context.
- Before final response, run the report script when project artifacts changed materially or cost reporting is in scope.
- In final notes, mention whether the cost report was updated when cost reporting was in scope.

## Precision Labels

Use these labels exactly:

| Label | Meaning |
|---|---|
| `actual-invoice` | Actual billed amount from a provider invoice or billing export. |
| `token-telemetry-estimate` | Exact token counts from telemetry multiplied by a dated pricing assumption. |
| `manual-estimate` | Human-entered or approximated token counts multiplied by pricing assumptions. |
| `blocked` | Missing token counts, pricing, or both. |

Do not call a dollar amount actual unless it comes from an invoice or billing export. Token totals can be exact while dollar totals remain estimates.

## Compact Storage Rules

Keep `ai-usage-log.csv` small:

- one row per meaningful session, request, or milestone checkpoint,
- no raw prompts,
- no tool output,
- no secrets,
- no customer data,
- no posted table values,
- no Business Central credentials or endpoint details,
- no per-message transcript,
- no repeated cumulative telemetry events.

If detailed evidence is needed, reference the local telemetry source in notes, but do not copy raw session content into the repo.

## Required Usage Columns

`ai-usage-log.csv` must use this header:

```csv
session_id,session_name,project,phase,task,agent_role,model,effort,started_utc,ended_utc,events,input_tokens,cached_input_tokens,uncached_input_tokens,output_tokens,reasoning_output_tokens,total_tokens,input_price_per_1m,cached_input_price_per_1m,output_price_per_1m,estimated_cost_usd,actual_cost_usd,pricing_source,precision,notes
```

Column rules:

- `input_tokens` is the telemetry input token total.
- `cached_input_tokens` is the telemetry cached input token total.
- `uncached_input_tokens` equals `max(input_tokens - cached_input_tokens, 0)`.
- `output_tokens` is the telemetry output token total.
- `reasoning_output_tokens` is recorded for measurement only and must not be added again if it is already included in `output_tokens`.
- `actual_cost_usd` stays blank unless billing evidence exists.

## Cost Formula

Use prices from `model-pricing.md`.

```text
uncached_input_tokens = max(input_tokens - cached_input_tokens, 0)
input_cost = (uncached_input_tokens / 1000000) * input_price_per_1m
cached_input_cost = (cached_input_tokens / 1000000) * cached_input_price_per_1m
output_cost = (output_tokens / 1000000) * output_price_per_1m
estimated_cost_usd = input_cost + cached_input_cost + output_cost
```

Round row-level cost to 6 decimal places. Round human-facing report totals to 2 to 6 decimals depending on audience.

## Measurements To Report

The report must include measurements, not only final cost:

- total sessions or request checkpoints,
- a short executive summary in plain language,
- total input, cached input, uncached input, output, reasoning output, and total tokens,
- cache ratio,
- output ratio,
- cost composition for uncached input, cached input, and output,
- estimated cache savings when cached-token pricing is available,
- average estimated cost per session,
- average estimated cost per telemetry event,
- highest-cost session/task,
- model mix,
- phase mix,
- pricing source and precision label,
- known gaps such as missing invoices or missing tool-call fees,
- optimization notes.

Useful derived formulas:

```text
cache_ratio = cached_input_tokens / input_tokens
output_ratio = output_tokens / total_tokens
reasoning_ratio = reasoning_output_tokens / output_tokens
average_cost_per_session = estimated_cost_usd / session_count
average_cost_per_event = estimated_cost_usd / events
tokens_per_estimated_usd = total_tokens / estimated_cost_usd
```

## Reporting Template

`ai-cost-report.md` should stay short and use this shape:

```markdown
# AI Cost Report

## Executive Summary

## At A Glance

## Measurement Dashboard

## What Drove The Cost

## Cost Health Signals

## Cost By Session

## Cost By Phase

## Cost By Model

## Optimization Notes

## Known Gaps

## Source Files
```

## Blockers

Cost calculation is blocked when:

- no token telemetry exists,
- model pricing is missing or outdated,
- the model used is not present in the pricing table,
- the user requests actual billed cost but no invoice or billing export is available.

When blocked, state exactly which input is missing and what file or source would unblock it.
