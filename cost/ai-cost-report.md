# AI Cost Report

> Compact generated report. It stores measurements and cost rollups only; raw prompts, tool output, Business Central data, and full telemetry stay out of the repository.

## Executive Summary

- Current token-priced cost is about USD 231.62, calculated from 283,267,085 measured tokens across 2,177 telemetry events.
- Cost health is Review. Spend needs review before repeating similar premium-model work.
- The main cost driver is input/context: input/context cost is USD 192.21, while model output cost is USD 39.41.
- Cached context is helping materially: it avoided about USD 1217.55 compared with billing cached input at the full input rate.
- Actual billed cost remains open until an invoice or billing export is available.

## At A Glance

| Item | Value |
|---|---:|
| Project | BC Data Agent |
| Report period | All logged project checkpoints |
| Last checkpoint | 2026-06-10T21:49:28.864Z |
| Precision | token-telemetry-estimate |
| Token-priced cost | USD 231.621193 |
| Actual billed cost | n/a |
| Pricing source | OpenAI API pricing 2026-05-07 from cost/model-pricing.md; Standard Under 270K |
| Total tokens | 283,267,085 |
| Sessions/request checkpoints | 8 |
| Telemetry events | 2,177 |
| Cost health | Review |

## Measurement Dashboard

| Measurement | Value | Why it matters |
|---|---:|---|
| Input tokens | 281,953,541 | Main context volume sent to models |
| Cached input tokens | 270,567,296 | Reused context billed at cached rate |
| Uncached input tokens | 11,386,245 | Fresh context billed at full input rate |
| Output tokens | 1,313,544 | Generated response volume |
| Reasoning output tokens | 433,419 | Reasoning effort visibility |
| Cache ratio | 95.96% | Higher is usually better for repeated project context |
| Output ratio | 0.46% | Shows whether cost is driven by context or generation |
| Reasoning share of output | 33.00% | Helps spot heavy reasoning work |
| Average cost per session | USD 28.952649 | Request-level budget signal |
| Average cost per telemetry event | USD 0.106395 | Checkpoint-level budget signal |
| Tokens per estimated USD | 1,222,976 | Efficiency view across current pricing |

## What Drove The Cost

| Component | Token Volume | Cost | Share | What It Tells Us |
|---|---:|---:|---:|---|
| Uncached input context | 11,386,245 | USD 56.931225 | 24.58% | Fresh context billed at the full input rate. |
| Cached input context | 270,567,296 | USD 135.283648 | 58.41% | Reused project context billed at the cached-input rate. |
| Model output | 1,313,544 | USD 39.406320 | 17.01% | Generated answer volume, including reasoning output where counted by telemetry. |
| Estimated cache savings | 270,567,296 | USD 1217.552832 | n/a | Approximate avoided cost from cached-input pricing. |

## Cost Health Signals

| Signal | Status | Measurement | Note |
|---|---|---:|---|
| Token telemetry coverage | Complete | 8 | Compact rows have usable token telemetry or invoice precision. |
| Invoice reconciliation | Open | n/a | Actual billed cost needs provider billing export or invoice. |
| Tool-call fees | Open | n/a | Tool-call and hosted execution costs are excluded unless explicitly logged. |

## Cost By Session

| Session | Phase | Model | Events | Total Tokens | Token-Priced Cost USD |
|---|---|---|---:|---:|---:|
| BC Data Agent Codex session 2026-05-27 | Implementation | gpt-5.5 | 940 | 130,585,290 | 99.417146 |
| BC Data Agent Codex session 2026-05-07 | Implementation | gpt-5.5 | 366 | 45,053,783 | 38.229021 |
| BC Data Agent Codex session 2026-05-08 | Implementation | gpt-5.5 | 231 | 28,135,217 | 24.591581 |
| BC Data Agent Codex session 2026-05-20 | Implementation | gpt-5.5 | 197 | 21,679,295 | 21.789193 |
| BC Data Agent Codex session 2026-05-07 | Implementation | gpt-5.5 | 182 | 22,520,470 | 19.395384 |
| BC Data Agent Codex session 2026-06-10 | Implementation | gpt-5.5 | 116 | 15,267,567 | 12.967422 |
| BC Data Agent Codex session 2026-06-10 | Implementation | gpt-5.5 | 116 | 17,416,789 | 12.840018 |
| BC Data Agent Codex session 2026-05-28 | Implementation | gpt-5.5 | 29 | 2,608,674 | 2.391428 |

## Cost By Phase

| Phase | Sessions | Total Tokens | Token-Priced Cost USD |
|---|---:|---:|---:|
| Implementation | 8 | 283,267,085 | 231.621193 |

## Cost By Model

| Model | Sessions | Total Tokens | Token-Priced Cost USD |
|---|---:|---:|---:|
| gpt-5.5 | 8 | 283,267,085 | 231.621193 |

## Optimization Notes

- This is above the watch threshold in `cost/ai-cost-policy.md`; repeat similar premium-model loops only when the risk justifies it.
- The cache ratio is 95.96%; keep prompts tied to existing files and avoid resending broad context unnecessarily.
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
