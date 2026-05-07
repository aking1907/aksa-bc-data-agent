# AI Cost Report

> Compact generated report. It stores measurements and cost rollups only; raw prompts, tool output, Business Central data, and full telemetry stay out of the repository.

## At A Glance

| Item | Value |
|---|---:|
| Project | BC Data Agent |
| Report period | All logged project checkpoints |
| Last checkpoint | n/a |
| Precision | blocked |
| Estimated cost | USD 0.000000 |
| Actual invoice cost | n/a |
| Total tokens | 0 |
| Sessions/request checkpoints | 0 |
| Telemetry events | 0 |
| Cost health | Baseline |

## Measurement Dashboard

| Measurement | Value | Why it matters |
|---|---:|---|
| Input tokens | 0 | Main context volume sent to models |
| Cached input tokens | 0 | Reused context billed at cached rate |
| Uncached input tokens | 0 | Fresh context billed at full input rate |
| Output tokens | 0 | Generated response volume |
| Reasoning output tokens | 0 | Reasoning effort visibility |
| Cache ratio | n/a | Higher is usually better for repeated project context |
| Output ratio | n/a | Shows whether cost is driven by context or generation |
| Reasoning share of output | n/a | Helps spot heavy reasoning work |
| Average cost per session | n/a | Request-level budget signal |
| Average cost per telemetry event | n/a | Checkpoint-level budget signal |
| Tokens per estimated USD | n/a | Efficiency view across current pricing |

## Cost Health Signals

| Signal | Status | Measurement | Note |
|---|---|---:|---|
| Baseline reset | Complete | n/a | Prior-project rows were removed; no BC Data Agent usage checkpoints are recorded yet when session count is zero. |
| Invoice reconciliation | Open | n/a | Actual billed cost needs provider billing export or invoice. |
| Tool-call fees | Open | n/a | Tool-call and hosted execution costs are excluded unless explicitly logged. |

## Cost By Session

No BC Data Agent usage checkpoints are recorded yet.

## Cost By Phase

No phase cost has been recorded yet.

## Cost By Model

No model cost has been recorded yet.

## Optimization Notes

- Keep cost checkpoints at meaningful SDD, implementation, testing, or release boundaries.
- Use premium models for high-risk security, posted-data, rollback, and readiness decisions.
- Use lower-cost models for formatting, extraction, checklist maintenance, and simple documentation updates when available.

## Known Gaps

- Dollar amounts are pricing-based estimates until reconciled with a billing export or invoice.
- Tool-call fees, hosted shell/container fees, web search call fees, subscription discounts, and enterprise terms are not included unless explicitly logged.
- This report depends on compact rows in `cost/ai-usage-log.csv`; raw telemetry is intentionally not stored here.

## Source Files

- Usage rollup: `cost/ai-usage-log.csv`.
- Pricing assumptions: `cost/model-pricing.md`.
- Cost policy: `cost/ai-cost-policy.md`.
- Automation script: `cost/update-ai-cost-report.ps1`.
