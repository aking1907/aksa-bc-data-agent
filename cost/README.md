# AI Cost Tracking

This folder keeps BC Data Agent AI usage reporting compact, auditable, and safe for the repository.

## Files

| File | Purpose |
|---|---|
| `ai-usage-log.csv` | Compact per-session or per-checkpoint rollups. No raw prompts, transcripts, tool output, secrets, or BC data values. |
| `ai-cost-report.md` | Generated summary for project review, SDD governance, and budget awareness. |
| `ai-cost-policy.md` | Project rules for model choice, thresholds, logging, and escalation. |
| `model-pricing.md` | Dated pricing assumptions used for estimates. Verify against the official rate card before formal reporting. |
| `cost-calculation.skills.md` | Local skill instructions for maintaining the cost pack. |
| `update-ai-usage-from-codex.ps1` | Imports local Codex token telemetry for this workspace into the compact CSV. |
| `update-ai-cost-report.ps1` | Report generator that reads the compact CSV and rewrites `ai-cost-report.md`. |

## Workflow

1. Import local Codex token telemetry when available:

```powershell
powershell -ExecutionPolicy Bypass -File cost\update-ai-usage-from-codex.ps1
```

2. Use only non-sensitive notes. Do not record customer data, Business Central posted values, hidden field values, credentials, raw prompts, or tool output.
3. Keep `actual_cost_usd` blank unless it comes from a provider invoice or billing export.
4. Run the report generator from the project root:

```powershell
powershell -ExecutionPolicy Bypass -File cost\update-ai-cost-report.ps1
```

## Regular Task

Treat cost refresh as part of the normal done criteria for meaningful project work:

- after SDD, coding, review, testing, release, or cost changes, add or update one compact checkpoint row when telemetry is available;
- if local Codex telemetry is available, run `cost\update-ai-usage-from-codex.ps1` before regenerating the report;
- if telemetry is not available, add a non-sensitive checkpoint with `precision` set to `blocked` instead of inventing token or dollar values;
- run `cost\update-ai-cost-report.ps1` before the final response when cost reporting is in scope or project artifacts changed materially;
- never store raw prompts, transcripts, tool output, credentials, customer data, posted values, hidden values, or rollback before-images in cost files.

## Current Status

The cost pack is initialized for BC Data Agent. Use token telemetry estimates for real project usage cost, and reserve `actual-invoice` for billing exports or invoices.
