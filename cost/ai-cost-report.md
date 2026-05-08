# AI Cost Report

> Compact generated report. It stores measurements and cost rollups only; raw prompts, tool output, Business Central data, and full telemetry stay out of the repository.

## Executive Summary

- Current token-priced cost is about USD 81.46, calculated from 94,656,730 measured tokens across 771 telemetry events.
- Cost health is Review. Spend needs review before repeating similar premium-model work.
- The main cost driver is input/context: input/context cost is USD 66.22, while model output cost is USD 15.24.
- Cached context is helping materially: it avoided about USD 404.53 compared with billing cached input at the full input rate.
- Actual billed cost remains open until an invoice or billing export is available.

## At A Glance

| Item | Value |
|---|---:|
| Project | BC Data Agent |
| Report period | All logged project checkpoints |
| Last checkpoint | 2026-05-08T21:39:35.292Z |
| Precision | token-telemetry-estimate |
| Token-priced cost | USD 81.462124 |
| Actual billed cost | n/a |
| Pricing source | OpenAI API pricing 2026-05-07 from cost/model-pricing.md; Standard Under 270K |
| Total tokens | 94,656,730 |
| Sessions/request checkpoints | 3 |
| Telemetry events | 771 |
| Cost health | Review |

## Measurement Dashboard

| Measurement | Value | Why it matters |
|---|---:|---|
| Input tokens | 94,148,576 | Main context volume sent to models |
| Cached input tokens | 89,894,528 | Reused context billed at cached rate |
| Uncached input tokens | 4,254,048 | Fresh context billed at full input rate |
| Output tokens | 508,154 | Generated response volume |
| Reasoning output tokens | 171,849 | Reasoning effort visibility |
| Cache ratio | 95.48% | Higher is usually better for repeated project context |
| Output ratio | 0.54% | Shows whether cost is driven by context or generation |
| Reasoning share of output | 33.82% | Helps spot heavy reasoning work |
| Average cost per session | USD 27.154041 | Request-level budget signal |
| Average cost per telemetry event | USD 0.105658 | Checkpoint-level budget signal |
| Tokens per estimated USD | 1,161,972 | Efficiency view across current pricing |

## What Drove The Cost

| Component | Token Volume | Cost | Share | What It Tells Us |
|---|---:|---:|---:|---|
| Uncached input context | 4,254,048 | USD 21.270240 | 26.11% | Fresh context billed at the full input rate. |
| Cached input context | 89,894,528 | USD 44.947264 | 55.18% | Reused project context billed at the cached-input rate. |
| Model output | 508,154 | USD 15.244620 | 18.71% | Generated answer volume, including reasoning output where counted by telemetry. |
| Estimated cache savings | 89,894,528 | USD 404.525376 | n/a | Approximate avoided cost from cached-input pricing. |

## Cost Health Signals

| Signal | Status | Measurement | Note |
|---|---|---:|---|
| Token telemetry coverage | Complete | 3 | Compact rows have usable token telemetry or invoice precision. |
| Invoice reconciliation | Open | n/a | Actual billed cost needs provider billing export or invoice. |
| Tool-call fees | Open | n/a | Tool-call and hosted execution costs are excluded unless explicitly logged. |

## Cost By Session

| Session | Phase | Model | Events | Total Tokens | Token-Priced Cost USD |
|---|---|---|---:|---:|---:|
| BC Data Agent Codex session 2026-05-07 | Implementation | gpt-5.5 | 366 | 45,053,783 | 38.229021 |
| BC Data Agent Codex session 2026-05-08 | Implementation | gpt-5.5 | 223 | 27,082,477 | 23.837719 |
| BC Data Agent Codex session 2026-05-07 | Implementation | gpt-5.5 | 182 | 22,520,470 | 19.395384 |

## Cost By Phase

| Phase | Sessions | Total Tokens | Token-Priced Cost USD |
|---|---:|---:|---:|
| Implementation | 3 | 94,656,730 | 81.462124 |

## Cost By Model

| Model | Sessions | Total Tokens | Token-Priced Cost USD |
|---|---:|---:|---:|
| gpt-5.5 | 3 | 94,656,730 | 81.462124 |

## Optimization Notes

- This is above the watch threshold in `cost/ai-cost-policy.md`; repeat similar premium-model loops only when the risk justifies it.
- The cache ratio is 95.48%; keep prompts tied to existing files and avoid resending broad context unnecessarily.
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
