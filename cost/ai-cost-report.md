# AI Cost Report

> Compact generated report. It stores measurements and cost rollups only; raw prompts, tool output, Business Central data, and full telemetry stay out of the repository.

## Executive Summary

- Current token-priced cost is about USD 252.58, calculated from 308,519,681 measured tokens across 2,387 telemetry events.
- Cost health is Review. Spend needs review before repeating similar premium-model work.
- The main cost driver is input/context: input/context cost is USD 209.65, while model output cost is USD 42.94.
- Cached context is helping materially: it avoided about USD 1325.80 compared with billing cached input at the full input rate.
- Actual billed cost remains open until an invoice or billing export is available.

## At A Glance

| Item | Value |
|---|---:|
| Project | BC Data Agent |
| Report period | All logged project checkpoints |
| Last checkpoint | 2026-06-12T22:20:31.010Z |
| Precision | token-telemetry-estimate |
| Token-priced cost | USD 252.581876 |
| Actual billed cost | n/a |
| Pricing source | OpenAI API pricing 2026-05-07 from cost/model-pricing.md; Standard Under 270K |
| Total tokens | 308,519,681 |
| Sessions/request checkpoints | 9 |
| Telemetry events | 2,387 |
| Cost health | Review |

## Measurement Dashboard

| Measurement | Value | Why it matters |
|---|---:|---|
| Input tokens | 307,088,506 | Main context volume sent to models |
| Cached input tokens | 294,621,312 | Reused context billed at cached rate |
| Uncached input tokens | 12,467,194 | Fresh context billed at full input rate |
| Output tokens | 1,431,175 | Generated response volume |
| Reasoning output tokens | 465,853 | Reasoning effort visibility |
| Cache ratio | 95.94% | Higher is usually better for repeated project context |
| Output ratio | 0.46% | Shows whether cost is driven by context or generation |
| Reasoning share of output | 32.55% | Helps spot heavy reasoning work |
| Average cost per session | USD 28.064653 | Request-level budget signal |
| Average cost per telemetry event | USD 0.105816 | Checkpoint-level budget signal |
| Tokens per estimated USD | 1,221,464 | Efficiency view across current pricing |

## What Drove The Cost

| Component | Token Volume | Cost | Share | What It Tells Us |
|---|---:|---:|---:|---|
| Uncached input context | 12,467,194 | USD 62.335970 | 24.68% | Fresh context billed at the full input rate. |
| Cached input context | 294,621,312 | USD 147.310656 | 58.32% | Reused project context billed at the cached-input rate. |
| Model output | 1,431,175 | USD 42.935250 | 17.00% | Generated answer volume, including reasoning output where counted by telemetry. |
| Estimated cache savings | 294,621,312 | USD 1325.795904 | n/a | Approximate avoided cost from cached-input pricing. |

## Cost Health Signals

| Signal | Status | Measurement | Note |
|---|---|---:|---|
| Token telemetry coverage | Complete | 9 | Compact rows have usable token telemetry or invoice precision. |
| Invoice reconciliation | Open | n/a | Actual billed cost needs provider billing export or invoice. |
| Tool-call fees | Open | n/a | Tool-call and hosted execution costs are excluded unless explicitly logged. |

## Cost By Session

| Session | Phase | Model | Events | Total Tokens | Token-Priced Cost USD |
|---|---|---|---:|---:|---:|
| BC Data Agent Codex session 2026-05-27 | Implementation | gpt-5.5 | 940 | 130,585,290 | 99.417146 |
| BC Data Agent Codex session 2026-05-07 | Implementation | gpt-5.5 | 366 | 45,053,783 | 38.229021 |
| BC Data Agent Codex session 2026-05-08 | Implementation | gpt-5.5 | 231 | 28,135,217 | 24.591581 |
| BC Data Agent Codex session 2026-05-20 | Implementation | gpt-5.5 | 197 | 21,679,295 | 21.789193 |
| BC Data Agent Codex session 2026-06-10 | Implementation | gpt-5.5 | 189 | 26,133,826 | 19.496767 |
| BC Data Agent Codex session 2026-05-07 | Implementation | gpt-5.5 | 182 | 22,520,470 | 19.395384 |
| BC Data Agent Codex session 2026-06-12 | Implementation | gpt-5.5 | 137 | 16,535,559 | 14.303934 |
| BC Data Agent Codex session 2026-06-10 | Implementation | gpt-5.5 | 116 | 15,267,567 | 12.967422 |
| BC Data Agent Codex session 2026-05-28 | Implementation | gpt-5.5 | 29 | 2,608,674 | 2.391428 |

## Cost By Phase

| Phase | Sessions | Total Tokens | Token-Priced Cost USD |
|---|---:|---:|---:|
| Implementation | 9 | 308,519,681 | 252.581876 |

## Cost By Model

| Model | Sessions | Total Tokens | Token-Priced Cost USD |
|---|---:|---:|---:|
| gpt-5.5 | 9 | 308,519,681 | 252.581876 |

## Optimization Notes

- This is above the watch threshold in `cost/ai-cost-policy.md`; repeat similar premium-model loops only when the risk justifies it.
- The cache ratio is 95.94%; keep prompts tied to existing files and avoid resending broad context unnecessarily.
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
