# Model Pricing

## Purpose

This file stores pricing assumptions used for BC Data Agent AI cost estimation.

Important:

- Pricing changes over time. Verify this file against the official rate card before budget reviews, invoices, or external reporting.
- Dollar amounts calculated from this file are estimates unless reconciled with an actual provider invoice or billing export.
- Prices are in USD per 1,000,000 tokens unless noted otherwise.
- Tool fees are not included in token-only estimates unless explicitly logged in `cost/ai-usage-log.csv`.

## Pricing Metadata

- Currency: USD
- Pricing unit: per 1,000,000 tokens
- Last updated: 2026-05-07
- Pricing source type: official public rate card
- Pricing source: OpenAI API pricing, https://openai.com/api/pricing/
- Default calculation basis for BC Data Agent Codex sessions: Standard processing, context under 270K tokens

## Cost Formula

```text
uncached_input_tokens = max(input_tokens - cached_input_tokens, 0)
input_cost = (uncached_input_tokens / 1000000) * input_price_per_1m
cached_input_cost = (cached_input_tokens / 1000000) * cached_input_price_per_1m
output_cost = (output_tokens / 1000000) * output_price_per_1m
estimated_cost_usd = input_cost + cached_input_cost + output_cost
```

`reasoning_output_tokens` are tracked separately for visibility. Do not add them again when they are already included in `output_tokens`.

## Approved Project Model Tiers

| Tier | Intended BC Data Agent Use | Default Expectation |
|---|---|---|
| Low | Formatting, extraction, document cleanup, simple summaries, table maintenance | Use when risk is low and the answer can be verified cheaply. |
| Standard | SDD maintenance, test design, implementation planning, focused code review, documentation updates | Preferred default for most project work. |
| Premium | Security-critical design, SUPER-only enforcement review, posted-data rollback design, final readiness decisions | Use when the task is high-risk or materially ambiguous. |

## Model Pricing Table

| Model | Tier | Processing | Context | Input Price / 1M Tokens | Cached Input Price / 1M Tokens | Output Price / 1M Tokens | Project Guidance | Source Confidence |
|---|---|---|---|---:|---:|---:|---|---|
| gpt-5.5 | premium | Standard | Under 270K | 5.00 | 0.50 | 30.00 | Use for final architecture/security synthesis and high-risk BC behavior decisions. | official |
| gpt-5.4 | standard | Standard | Under 270K | 2.50 | 0.25 | 15.00 | Use for most SDD, review, implementation planning, and verification work. | official |
| gpt-5.4-mini | low | Standard | Under 270K | 0.75 | 0.075 | 4.50 | Use for structured edits, extraction, checklist updates, and low-risk documentation. | official |

## Tool Pricing Notes

| Tool | Price | Notes |
|---|---:|---|
| Web search | 10.00 / 1,000 calls | Search content tokens may be handled according to provider rules. Log material usage only when the tool cost is known. |
| Containers / hosted shell | varies | Do not estimate container cost unless a billing source or approved internal rate is available. |
| File search storage | varies | Not included in token-only rows unless explicitly logged. |

## BC Data Agent Cost Tags

Use these phase names in cost rows so cost can be compared with SDD progress:

| Phase | Use For |
|---|---|
| Documentation | SDD documents, README, guides, prompts, and skills. |
| PlatformValidation | BC 28 platform capability confirmation. |
| Architecture | architecture, ADRs, risk analysis, domain/data model decisions. |
| UX | page flow, confirmations, rollback usability, admin experience. |
| Security | SUPER-only access, sensitive data handling, audit integrity. |
| ImplementationPlanning | implementation sequence, object planning, readiness review. |
| Implementation | AL code generation and changes after the code readiness gate allows them. |
| Testing | test plans, test code, manual verification, acceptance evidence. |
| Release | deployment, upgrade, release notes, support handoff. |

## Version History

### 2026-05-07

- Adapted pricing assumptions to BC Data Agent.
- Removed prior-project references.
- Reduced the default pricing table to project-relevant models.
- Kept strict separation between token estimates and actual invoice cost.
