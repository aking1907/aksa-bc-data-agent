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
| `update-ai-cost-report.ps1` | Report generator that reads the compact CSV and rewrites `ai-cost-report.md`. |

## Workflow

1. Add one compact row to `ai-usage-log.csv` for meaningful AI-assisted work when telemetry is available.
2. Use only non-sensitive notes. Do not record customer data, Business Central posted values, hidden field values, credentials, raw prompts, or tool output.
3. Keep `actual_cost_usd` blank unless it comes from a provider invoice or billing export.
4. Run the report generator from the project root:

```powershell
powershell -ExecutionPolicy Bypass -File cost\update-ai-cost-report.ps1
```

## Current Status

The cost pack is initialized for BC Data Agent. No BC Data Agent usage checkpoints are recorded yet.
