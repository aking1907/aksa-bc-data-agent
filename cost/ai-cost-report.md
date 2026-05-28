# AI Cost Report

> Compact generated report. It stores measurements and cost rollups only; raw prompts, tool output, Business Central data, and full telemetry stay out of the repository.

## Executive Summary

- Current token-priced cost is about USD 202.76, calculated from 247,063,678 measured tokens across 1,904 telemetry events.
- Cost health is Review. Spend needs review before repeating similar premium-model work.
- The main cost driver is input/context: input/context cost is USD 168.13, while model output cost is USD 34.62.
- Cached context is helping materially: it avoided about USD 1061.41 compared with billing cached input at the full input rate.
- Actual billed cost remains open until an invoice or billing export is available.

## At A Glance

| Item | Value |
|---|---:|
| Project | BC Data Agent |
| Report period | All logged project checkpoints |
| Last checkpoint | 2026-05-28T21:31:40.993Z |
| Precision | token-telemetry-estimate |
| Token-priced cost | USD 202.756283 |
| Actual billed cost | n/a |
| Pricing source | OpenAI API pricing 2026-05-07 from cost/model-pricing.md; Standard Under 270K |
| Total tokens | 247,063,678 |
| Sessions/request checkpoints | 5 |
| Telemetry events | 1,904 |
| Cost health | Review |

## Measurement Dashboard

| Measurement | Value | Why it matters |
|---|---:|---|
| Input tokens | 245,909,617 | Main context volume sent to models |
| Cached input tokens | 235,869,696 | Reused context billed at cached rate |
| Uncached input tokens | 10,039,921 | Fresh context billed at full input rate |
| Output tokens | 1,154,061 | Generated response volume |
| Reasoning output tokens | 383,275 | Reasoning effort visibility |
| Cache ratio | 95.92% | Higher is usually better for repeated project context |
| Output ratio | 0.47% | Shows whether cost is driven by context or generation |
| Reasoning share of output | 33.21% | Helps spot heavy reasoning work |
| Average cost per session | USD 40.551257 | Request-level budget signal |
| Average cost per telemetry event | USD 0.106490 | Checkpoint-level budget signal |
| Tokens per estimated USD | 1,218,525 | Efficiency view across current pricing |

## What Drove The Cost

| Component | Token Volume | Cost | Share | What It Tells Us |
|---|---:|---:|---:|---|
| Uncached input context | 10,039,921 | USD 50.199605 | 24.76% | Fresh context billed at the full input rate. |
| Cached input context | 235,869,696 | USD 117.934848 | 58.17% | Reused project context billed at the cached-input rate. |
| Model output | 1,154,061 | USD 34.621830 | 17.08% | Generated answer volume, including reasoning output where counted by telemetry. |
| Estimated cache savings | 235,869,696 | USD 1061.413632 | n/a | Approximate avoided cost from cached-input pricing. |

## Cost Health Signals

| Signal | Status | Measurement | Note |
|---|---|---:|---|
| Token telemetry coverage | Complete | 5 | Compact rows have usable token telemetry or invoice precision. |
| Invoice reconciliation | Open | n/a | Actual billed cost needs provider billing export or invoice. |
| Tool-call fees | Open | n/a | Tool-call and hosted execution costs are excluded unless explicitly logged. |

## Cost By Session

| Session | Phase | Model | Events | Total Tokens | Token-Priced Cost USD |
|---|---|---|---:|---:|---:|
| BC Data Agent Codex session 2026-05-27 | Implementation | gpt-5.5 | 928 | 129,674,913 | 98.751104 |
| BC Data Agent Codex session 2026-05-07 | Implementation | gpt-5.5 | 366 | 45,053,783 | 38.229021 |
| BC Data Agent Codex session 2026-05-08 | Implementation | gpt-5.5 | 231 | 28,135,217 | 24.591581 |
| BC Data Agent Codex session 2026-05-20 | Implementation | gpt-5.5 | 197 | 21,679,295 | 21.789193 |
| BC Data Agent Codex session 2026-05-07 | Implementation | gpt-5.5 | 182 | 22,520,470 | 19.395384 |

## Cost By Phase

| Phase | Sessions | Total Tokens | Token-Priced Cost USD |
|---|---:|---:|---:|
| Implementation | 5 | 247,063,678 | 202.756283 |

## Cost By Model

| Model | Sessions | Total Tokens | Token-Priced Cost USD |
|---|---:|---:|---:|
| gpt-5.5 | 5 | 247,063,678 | 202.756283 |

## Optimization Notes

- This is above the watch threshold in `cost/ai-cost-policy.md`; repeat similar premium-model loops only when the risk justifies it.
- The cache ratio is 95.92%; keep prompts tied to existing files and avoid resending broad context unnecessarily.
- Use lower-cost models for mechanical document cleanup and reserve premium models for security, rollback, posted-data, and readiness decisions.
- Reconcile with billing export later if the project needs finance-grade actual billed cost.

## Known Gaps

- Token-priced dollar amounts are calculated from measured tokens and dated pricing assumptions until reconciled with a billing export or invoice.
- Tool-call fees, hosted shell/container fees, web search call fees, subscription discounts, and enterprise terms are not included unless explicitly logged.
- This report depends on compact rows in `cost/ai-usage-log.csv`; raw telemetry is intentionally not stored here.

## Source Files

- Usage rollup: `cost/ai-usage-log.csv`.
- Pricing assumptions: `cost/model-pricing.md`.
- Cost policy: `cost/ai-cost-policy.md`.
- Telemetry importer: `cost/update-ai-usage-from-codex.ps1`.
- Automation script: `cost/update-ai-cost-report.ps1`.
