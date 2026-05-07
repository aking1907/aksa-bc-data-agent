[CmdletBinding()]
param(
    [string]$UsageLog = "cost\ai-usage-log.csv",
    [string]$ReportPath = "cost\ai-cost-report.md",
    [string]$Project = "BC Data Agent"
)

$ErrorActionPreference = "Stop"

function To-DecimalValue {
    param([object]$Value)

    if ($null -eq $Value) {
        return [decimal]0
    }

    $text = [string]$Value
    if ([string]::IsNullOrWhiteSpace($text)) {
        return [decimal]0
    }

    return [decimal]::Parse($text, [System.Globalization.CultureInfo]::InvariantCulture)
}

function Format-Number {
    param([decimal]$Value)

    return $Value.ToString("N0", [System.Globalization.CultureInfo]::InvariantCulture)
}

function Format-Usd {
    param([decimal]$Value)

    return "USD " + $Value.ToString("0.000000", [System.Globalization.CultureInfo]::InvariantCulture)
}

function Format-Ratio {
    param(
        [decimal]$Part,
        [decimal]$Whole
    )

    if ($Whole -eq 0) {
        return "n/a"
    }

    return (($Part / $Whole) * 100).ToString("0.00", [System.Globalization.CultureInfo]::InvariantCulture) + "%"
}

function Markdown-Escape {
    param([object]$Value)

    if ($null -eq $Value) {
        return ""
    }

    return ([string]$Value).Replace("|", "\|")
}

if (-not (Test-Path -LiteralPath $UsageLog)) {
    throw "Usage log not found: $UsageLog"
}

$rows = @(Import-Csv -LiteralPath $UsageLog | Where-Object {
    $_.session_id -and $_.session_id -ne "TOTAL"
})

$sessionCount = $rows.Count
$events = [decimal]0
$inputTokens = [decimal]0
$cachedInputTokens = [decimal]0
$uncachedInputTokens = [decimal]0
$outputTokens = [decimal]0
$reasoningOutputTokens = [decimal]0
$totalTokens = [decimal]0
$estimatedCost = [decimal]0
$actualCost = [decimal]0
$hasActualCost = $false

foreach ($row in $rows) {
    $events += To-DecimalValue $row.events
    $inputTokens += To-DecimalValue $row.input_tokens
    $cachedInputTokens += To-DecimalValue $row.cached_input_tokens
    $uncachedInputTokens += To-DecimalValue $row.uncached_input_tokens
    $outputTokens += To-DecimalValue $row.output_tokens
    $reasoningOutputTokens += To-DecimalValue $row.reasoning_output_tokens
    $totalTokens += To-DecimalValue $row.total_tokens
    $estimatedCost += To-DecimalValue $row.estimated_cost_usd

    if (-not [string]::IsNullOrWhiteSpace($row.actual_cost_usd)) {
        $hasActualCost = $true
        $actualCost += To-DecimalValue $row.actual_cost_usd
    }
}

$lastCheckpoint = "n/a"
if ($rows.Count -gt 0) {
    $lastCheckpoint = ($rows | Where-Object { $_.ended_utc } | Sort-Object ended_utc -Descending | Select-Object -First 1).ended_utc
    if ([string]::IsNullOrWhiteSpace($lastCheckpoint)) {
        $lastCheckpoint = "n/a"
    }
}

$precision = "blocked"
if ($rows.Count -gt 0) {
    $precisionValues = @($rows | ForEach-Object { $_.precision } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)
    if ($precisionValues.Count -eq 1) {
        $precision = $precisionValues[0]
    }
    elseif ($precisionValues.Count -gt 1) {
        $precision = "mixed"
    }
}

$costHealth = "Baseline"
if ($estimatedCost -gt 50) {
    $costHealth = "Review"
}
elseif ($estimatedCost -gt 10) {
    $costHealth = "Watch"
}
elseif ($rows.Count -gt 0) {
    $costHealth = "Normal"
}

$cacheRatio = Format-Ratio $cachedInputTokens $inputTokens
$outputRatio = Format-Ratio $outputTokens $totalTokens
$reasoningRatio = Format-Ratio $reasoningOutputTokens $outputTokens
$averageCostPerSession = if ($sessionCount -gt 0) { Format-Usd ($estimatedCost / $sessionCount) } else { "n/a" }
$averageCostPerEvent = if ($events -gt 0) { Format-Usd ($estimatedCost / $events) } else { "n/a" }
$tokensPerUsd = if ($estimatedCost -gt 0) { Format-Number ($totalTokens / $estimatedCost) } else { "n/a" }
$actualCostText = if ($hasActualCost) { Format-Usd $actualCost } else { "n/a" }

$sessionLines = New-Object System.Collections.Generic.List[string]
if ($rows.Count -eq 0) {
    $sessionLines.Add("No BC Data Agent usage checkpoints are recorded yet.")
}
else {
    $sessionLines.Add("| Session | Phase | Model | Events | Total Tokens | Estimated Cost USD |")
    $sessionLines.Add("|---|---|---|---:|---:|---:|")
    foreach ($row in ($rows | Sort-Object {[decimal](To-DecimalValue $_.estimated_cost_usd)} -Descending)) {
        $sessionLines.Add("| $(Markdown-Escape $row.session_name) | $(Markdown-Escape $row.phase) | $(Markdown-Escape $row.model) | $(Format-Number (To-DecimalValue $row.events)) | $(Format-Number (To-DecimalValue $row.total_tokens)) | $((To-DecimalValue $row.estimated_cost_usd).ToString("0.000000", [System.Globalization.CultureInfo]::InvariantCulture)) |")
    }
}

$phaseLines = New-Object System.Collections.Generic.List[string]
if ($rows.Count -eq 0) {
    $phaseLines.Add("No phase cost has been recorded yet.")
}
else {
    $phaseLines.Add("| Phase | Sessions | Total Tokens | Estimated Cost USD |")
    $phaseLines.Add("|---|---:|---:|---:|")
    foreach ($group in ($rows | Group-Object phase | Sort-Object Name)) {
        $phaseTokens = [decimal]0
        $phaseCost = [decimal]0
        foreach ($row in $group.Group) {
            $phaseTokens += To-DecimalValue $row.total_tokens
            $phaseCost += To-DecimalValue $row.estimated_cost_usd
        }
        $phaseLines.Add("| $(Markdown-Escape $group.Name) | $($group.Count) | $(Format-Number $phaseTokens) | $($phaseCost.ToString("0.000000", [System.Globalization.CultureInfo]::InvariantCulture)) |")
    }
}

$modelLines = New-Object System.Collections.Generic.List[string]
if ($rows.Count -eq 0) {
    $modelLines.Add("No model cost has been recorded yet.")
}
else {
    $modelLines.Add("| Model | Sessions | Total Tokens | Estimated Cost USD |")
    $modelLines.Add("|---|---:|---:|---:|")
    foreach ($group in ($rows | Group-Object model | Sort-Object Name)) {
        $modelTokens = [decimal]0
        $modelCost = [decimal]0
        foreach ($row in $group.Group) {
            $modelTokens += To-DecimalValue $row.total_tokens
            $modelCost += To-DecimalValue $row.estimated_cost_usd
        }
        $modelLines.Add("| $(Markdown-Escape $group.Name) | $($group.Count) | $(Format-Number $modelTokens) | $($modelCost.ToString("0.000000", [System.Globalization.CultureInfo]::InvariantCulture)) |")
    }
}

$lines = @(
    "# AI Cost Report",
    "",
    "> Compact generated report. It stores measurements and cost rollups only; raw prompts, tool output, Business Central data, and full telemetry stay out of the repository.",
    "",
    "## At A Glance",
    "",
    "| Item | Value |",
    "|---|---:|",
    "| Project | $Project |",
    "| Report period | All logged project checkpoints |",
    "| Last checkpoint | $lastCheckpoint |",
    "| Precision | $precision |",
    "| Estimated cost | $(Format-Usd $estimatedCost) |",
    "| Actual invoice cost | $actualCostText |",
    "| Total tokens | $(Format-Number $totalTokens) |",
    "| Sessions/request checkpoints | $sessionCount |",
    "| Telemetry events | $(Format-Number $events) |",
    "| Cost health | $costHealth |",
    "",
    "## Measurement Dashboard",
    "",
    "| Measurement | Value | Why it matters |",
    "|---|---:|---|",
    "| Input tokens | $(Format-Number $inputTokens) | Main context volume sent to models |",
    "| Cached input tokens | $(Format-Number $cachedInputTokens) | Reused context billed at cached rate |",
    "| Uncached input tokens | $(Format-Number $uncachedInputTokens) | Fresh context billed at full input rate |",
    "| Output tokens | $(Format-Number $outputTokens) | Generated response volume |",
    "| Reasoning output tokens | $(Format-Number $reasoningOutputTokens) | Reasoning effort visibility |",
    "| Cache ratio | $cacheRatio | Higher is usually better for repeated project context |",
    "| Output ratio | $outputRatio | Shows whether cost is driven by context or generation |",
    "| Reasoning share of output | $reasoningRatio | Helps spot heavy reasoning work |",
    "| Average cost per session | $averageCostPerSession | Request-level budget signal |",
    "| Average cost per telemetry event | $averageCostPerEvent | Checkpoint-level budget signal |",
    "| Tokens per estimated USD | $tokensPerUsd | Efficiency view across current pricing |",
    "",
    "## Cost Health Signals",
    "",
    "| Signal | Status | Measurement | Note |",
    "|---|---|---:|---|",
    "| Baseline reset | Complete | n/a | Prior-project rows were removed; no BC Data Agent usage checkpoints are recorded yet when session count is zero. |",
    "| Invoice reconciliation | Open | n/a | Actual billed cost needs provider billing export or invoice. |",
    "| Tool-call fees | Open | n/a | Tool-call and hosted execution costs are excluded unless explicitly logged. |",
    "",
    "## Cost By Session",
    "",
    $sessionLines,
    "",
    "## Cost By Phase",
    "",
    $phaseLines,
    "",
    "## Cost By Model",
    "",
    $modelLines,
    "",
    "## Optimization Notes",
    "",
    "- Keep cost checkpoints at meaningful SDD, implementation, testing, or release boundaries.",
    "- Use premium models for high-risk security, posted-data, rollback, and readiness decisions.",
    "- Use lower-cost models for formatting, extraction, checklist maintenance, and simple documentation updates when available.",
    "",
    "## Known Gaps",
    "",
    "- Dollar amounts are pricing-based estimates until reconciled with a billing export or invoice.",
    "- Tool-call fees, hosted shell/container fees, web search call fees, subscription discounts, and enterprise terms are not included unless explicitly logged.",
    '- This report depends on compact rows in `cost/ai-usage-log.csv`; raw telemetry is intentionally not stored here.',
    "",
    "## Source Files",
    "",
    '- Usage rollup: `cost/ai-usage-log.csv`.',
    '- Pricing assumptions: `cost/model-pricing.md`.',
    '- Cost policy: `cost/ai-cost-policy.md`.',
    '- Automation script: `cost/update-ai-cost-report.ps1`.'
)

$flattenedLines = New-Object System.Collections.Generic.List[string]
foreach ($line in $lines) {
    if (($line -is [System.Collections.IEnumerable]) -and -not ($line -is [string])) {
        foreach ($nestedLine in $line) {
            $flattenedLines.Add([string]$nestedLine)
        }
    }
    else {
        $flattenedLines.Add([string]$line)
    }
}

Set-Content -LiteralPath $ReportPath -Value $flattenedLines -Encoding ascii
Write-Host "Updated $ReportPath from $UsageLog"
