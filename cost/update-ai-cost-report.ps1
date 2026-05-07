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

function Format-UsdBrief {
    param([decimal]$Value)

    return "USD " + $Value.ToString("0.00", [System.Globalization.CultureInfo]::InvariantCulture)
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
$uncachedInputCost = [decimal]0
$cachedInputCost = [decimal]0
$outputTokenCost = [decimal]0
$cacheSavings = [decimal]0
$hasActualCost = $false

foreach ($row in $rows) {
    $rowEvents = To-DecimalValue $row.events
    $rowInputTokens = To-DecimalValue $row.input_tokens
    $rowCachedInputTokens = To-DecimalValue $row.cached_input_tokens
    $rowUncachedInputTokens = To-DecimalValue $row.uncached_input_tokens
    $rowOutputTokens = To-DecimalValue $row.output_tokens
    $rowReasoningOutputTokens = To-DecimalValue $row.reasoning_output_tokens
    $rowTotalTokens = To-DecimalValue $row.total_tokens
    $rowEstimatedCost = To-DecimalValue $row.estimated_cost_usd
    $rowInputPrice = To-DecimalValue $row.input_price_per_1m
    $rowCachedInputPrice = To-DecimalValue $row.cached_input_price_per_1m
    $rowOutputPrice = To-DecimalValue $row.output_price_per_1m

    $events += $rowEvents
    $inputTokens += $rowInputTokens
    $cachedInputTokens += $rowCachedInputTokens
    $uncachedInputTokens += $rowUncachedInputTokens
    $outputTokens += $rowOutputTokens
    $reasoningOutputTokens += $rowReasoningOutputTokens
    $totalTokens += $rowTotalTokens
    $estimatedCost += $rowEstimatedCost
    $uncachedInputCost += ($rowUncachedInputTokens / 1000000) * $rowInputPrice
    $cachedInputCost += ($rowCachedInputTokens / 1000000) * $rowCachedInputPrice
    $outputTokenCost += ($rowOutputTokens / 1000000) * $rowOutputPrice

    if ($rowInputPrice -gt $rowCachedInputPrice) {
        $cacheSavings += ($rowCachedInputTokens / 1000000) * ($rowInputPrice - $rowCachedInputPrice)
    }

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

$blockedRows = @($rows | Where-Object { $_.precision -eq "blocked" }).Count
$pricingSources = @($rows | ForEach-Object { $_.pricing_source } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)
$pricingSourceText = "n/a"
if ($pricingSources.Count -eq 1) {
    $pricingSourceText = $pricingSources[0]
}
elseif ($pricingSources.Count -gt 1) {
    $pricingSourceText = "mixed"
}

$costHealth = "Baseline"
if (($rows.Count -gt 0) -and ($precision -eq "blocked")) {
    $costHealth = "Telemetry Missing"
}
elseif ($estimatedCost -gt 50) {
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
$inputSideCost = $uncachedInputCost + $cachedInputCost
$dominantDriver = if ($inputSideCost -ge $outputTokenCost) { "input/context" } else { "model output" }

$costHealthNarrative = switch ($costHealth) {
    "Baseline" { "No BC Data Agent AI usage has been logged yet." }
    "Telemetry Missing" { "Some work is logged, but cost is blocked until token telemetry or pricing is available." }
    "Normal" { "Spend is currently in the normal band for logged project work." }
    "Watch" { "Spend is in watch range. Review model choice and context size before repeating similar long-running work." }
    "Review" { "Spend needs review before repeating similar premium-model work." }
    default { "Cost health is $costHealth." }
}

$checkpointSignalLine = "| Baseline reset | Complete | n/a | Prior-project rows were removed; no BC Data Agent usage checkpoints are recorded yet when session count is zero. |"
if ($rows.Count -gt 0) {
    if ($blockedRows -gt 0) {
        $checkpointSignalLine = "| Token telemetry coverage | Partial | $blockedRows | Some compact rows still need token telemetry before cost can be calculated. |"
    }
    else {
        $checkpointSignalLine = "| Token telemetry coverage | Complete | $sessionCount | Compact rows have usable token telemetry or invoice precision. |"
    }
}

$executiveLines = New-Object System.Collections.Generic.List[string]
if ($rows.Count -eq 0) {
    $executiveLines.Add("- No BC Data Agent AI usage has been logged yet, so this report is a clean baseline.")
    $executiveLines.Add("- Run the telemetry importer after meaningful SDD, implementation, testing, or release work.")
}
else {
    $executiveLines.Add("- Current token-priced cost is about $(Format-UsdBrief $estimatedCost), calculated from $(Format-Number $totalTokens) measured tokens across $(Format-Number $events) telemetry events.")
    $executiveLines.Add("- Cost health is $costHealth. $costHealthNarrative")
    $executiveLines.Add("- The main cost driver is ${dominantDriver}: input/context cost is $(Format-UsdBrief $inputSideCost), while model output cost is $(Format-UsdBrief $outputTokenCost).")
    if ($cacheSavings -gt 0) {
        $executiveLines.Add("- Cached context is helping materially: it avoided about $(Format-UsdBrief $cacheSavings) compared with billing cached input at the full input rate.")
    }
    if ($hasActualCost) {
        $executiveLines.Add("- Actual billed cost is logged separately at $actualCostText.")
    }
    else {
        $executiveLines.Add("- Actual billed cost remains open until an invoice or billing export is available.")
    }
}

$costCompositionLines = New-Object System.Collections.Generic.List[string]
if ($rows.Count -eq 0) {
    $costCompositionLines.Add("No cost composition is available yet.")
}
else {
    $costCompositionLines.Add("| Component | Token Volume | Cost | Share | What It Tells Us |")
    $costCompositionLines.Add("|---|---:|---:|---:|---|")
    $costCompositionLines.Add("| Uncached input context | $(Format-Number $uncachedInputTokens) | $(Format-Usd $uncachedInputCost) | $(Format-Ratio $uncachedInputCost $estimatedCost) | Fresh context billed at the full input rate. |")
    $costCompositionLines.Add("| Cached input context | $(Format-Number $cachedInputTokens) | $(Format-Usd $cachedInputCost) | $(Format-Ratio $cachedInputCost $estimatedCost) | Reused project context billed at the cached-input rate. |")
    $costCompositionLines.Add("| Model output | $(Format-Number $outputTokens) | $(Format-Usd $outputTokenCost) | $(Format-Ratio $outputTokenCost $estimatedCost) | Generated answer volume, including reasoning output where counted by telemetry. |")
    $costCompositionLines.Add("| Estimated cache savings | $(Format-Number $cachedInputTokens) | $(Format-Usd $cacheSavings) | n/a | Approximate avoided cost from cached-input pricing. |")
}

$watchLines = New-Object System.Collections.Generic.List[string]
if ($rows.Count -eq 0) {
    $watchLines.Add("- Keep the first checkpoint small and attributable to one SDD or implementation milestone.")
}
else {
    if (($costHealth -eq "Watch") -or ($costHealth -eq "Review")) {
        $watchLines.Add('- This is above the watch threshold in `cost/ai-cost-policy.md`; repeat similar premium-model loops only when the risk justifies it.')
    }
    else {
        $watchLines.Add("- Current cost health does not require special review, but keep logging meaningful milestones.")
    }
    $watchLines.Add("- The cache ratio is $cacheRatio; keep prompts tied to existing files and avoid resending broad context unnecessarily.")
    $watchLines.Add("- Use lower-cost models for mechanical document cleanup and reserve premium models for security, rollback, posted-data, and readiness decisions.")
    $watchLines.Add("- Reconcile with billing export later if the project needs finance-grade actual billed cost.")
}

$sessionLines = New-Object System.Collections.Generic.List[string]
if ($rows.Count -eq 0) {
    $sessionLines.Add("No BC Data Agent usage checkpoints are recorded yet.")
}
else {
    $sessionLines.Add("| Session | Phase | Model | Events | Total Tokens | Token-Priced Cost USD |")
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
    $phaseLines.Add("| Phase | Sessions | Total Tokens | Token-Priced Cost USD |")
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
    $modelLines.Add("| Model | Sessions | Total Tokens | Token-Priced Cost USD |")
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
    "## Executive Summary",
    "",
    $executiveLines,
    "",
    "## At A Glance",
    "",
    "| Item | Value |",
    "|---|---:|",
    "| Project | $Project |",
    "| Report period | All logged project checkpoints |",
    "| Last checkpoint | $lastCheckpoint |",
    "| Precision | $precision |",
    "| Token-priced cost | $(Format-Usd $estimatedCost) |",
    "| Actual billed cost | $actualCostText |",
    "| Pricing source | $(Markdown-Escape $pricingSourceText) |",
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
    "## What Drove The Cost",
    "",
    $costCompositionLines,
    "",
    "## Cost Health Signals",
    "",
    "| Signal | Status | Measurement | Note |",
    "|---|---|---:|---|",
    $checkpointSignalLine,
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
    $watchLines,
    "",
    "## Known Gaps",
    "",
    "- Token-priced dollar amounts are calculated from measured tokens and dated pricing assumptions until reconciled with a billing export or invoice.",
    "- Tool-call fees, hosted shell/container fees, web search call fees, subscription discounts, and enterprise terms are not included unless explicitly logged.",
    '- This report depends on compact rows in `cost/ai-usage-log.csv`; raw telemetry is intentionally not stored here.',
    "",
    "## Source Files",
    "",
    '- Usage rollup: `cost/ai-usage-log.csv`.',
    '- Pricing assumptions: `cost/model-pricing.md`.',
    '- Cost policy: `cost/ai-cost-policy.md`.',
    '- Telemetry importer: `cost/update-ai-usage-from-codex.ps1`.',
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
