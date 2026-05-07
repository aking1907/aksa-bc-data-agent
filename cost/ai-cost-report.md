# AI Cost Report

> Compact generated report. It stores measurements and cost rollups only; raw prompts, tool output, Business Central data, and full telemetry stay out of the repository.

## Executive Summary

- Current token-priced cost is about USD 43.63, calculated from 50,805,628 measured tokens across 415 telemetry events.
- Cost health is Watch. Spend is in watch range. Review model choice and context size before repeating similar long-running work.
- The main cost driver is input/context: input/context cost is USD 35.03, while model output cost is USD 8.61.
- Cached context is helping materially: it avoided about USD 217.57 compared with billing cached input at the full input rate.
- Actual billed cost remains open until an invoice or billing export is available.

## At A Glance

| Item | Value |
|---|---:|
| Project | BC Data Agent |
| Report period | All logged project checkpoints |
| Last checkpoint | 2026-05-07T18:18:52.657Z |
| Precision | token-telemetry-estimate |
| Token-priced cost | USD 43.632069 |
| Actual billed cost | n/a |
| Pricing source | OpenAI API pricing 2026-05-07 from cost/model-pricing.md; Standard Under 270K |
| Total tokens | 50,805,628 |
| Sessions/request checkpoints | 2 |
| Telemetry events | 415 |
| Cost health | Watch |

## Measurement Dashboard

| Measurement | Value | Why it matters |
|---|---:|---|
| Input tokens | 50,518,779 | Main context volume sent to models |
| Cached input tokens | 48,348,288 | Reused context billed at cached rate |
| Uncached input tokens | 2,170,491 | Fresh context billed at full input rate |
| Output tokens | 286,849 | Generated response volume |
| Reasoning output tokens | 79,830 | Reasoning effort visibility |
| Cache ratio | 95.70% | Higher is usually better for repeated project context |
| Output ratio | 0.56% | Shows whether cost is driven by context or generation |
| Reasoning share of output | 27.83% | Helps spot heavy reasoning work |
| Average cost per session | USD 21.816035 | Request-level budget signal |
| Average cost per telemetry event | USD 0.105138 | Checkpoint-level budget signal |
| Tokens per estimated USD | 1,164,410 | Efficiency view across current pricing |

## What Drove The Cost

| Component | Token Volume | Cost | Share | What It Tells Us |
|---|---:|---:|---:|---|
| Uncached input context | 2,170,491 | USD 10.852455 | 24.87% | Fresh context billed at the full input rate. |
| Cached input context | 48,348,288 | USD 24.174144 | 55.40% | Reused project context billed at the cached-input rate. |
| Model output | 286,849 | USD 8.605470 | 19.72% | Generated answer volume, including reasoning output where counted by telemetry. |
| Estimated cache savings | 48,348,288 | USD 217.567296 | n/a | Approximate avoided cost from cached-input pricing. |

## Cost Health Signals

| Signal | Status | Measurement | Note |
|---|---|---:|---|
| Token telemetry coverage | Complete | 2 | Compact rows have usable token telemetry or invoice precision. |
| Invoice reconciliation | Open | n/a | Actual billed cost needs provider billing export or invoice. |
| Tool-call fees | Open | n/a | Tool-call and hosted execution costs are excluded unless explicitly logged. |

## Cost By Session

| Session | Phase | Model | Events | Total Tokens | Token-Priced Cost USD |
|---|---|---|---:|---:|---:|
| BC Data Agent Codex session 2026-05-07 | Implementation | gpt-5.5 | 366 | 45,053,783 | 38.229021 |
| BC Data Agent Codex session 2026-05-07 | Implementation | gpt-5.5 | 49 | 5,751,845 | 5.403048 |

## Cost By Phase

| Phase | Sessions | Total Tokens | Token-Priced Cost USD |
|---|---:|---:|---:|
| Implementation | 2 | 50,805,628 | 43.632069 |

## Cost By Model

| Model | Sessions | Total Tokens | Token-Priced Cost USD |
|---|---:|---:|---:|
| gpt-5.5 | 2 | 50,805,628 | 43.632069 |

## Optimization Notes

- This is above the watch threshold in `cost/ai-cost-policy.md`; repeat similar premium-model loops only when the risk justifies it.
- The cache ratio is 95.70%; keep prompts tied to existing files and avoid resending broad context unnecessarily.
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
