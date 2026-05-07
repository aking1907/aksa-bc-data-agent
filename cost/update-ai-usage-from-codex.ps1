[CmdletBinding()]
param(
    [string]$ProjectRoot = ".",
    [string]$CodexHome = "$env:USERPROFILE\.codex",
    [string]$UsageLog = "cost\ai-usage-log.csv",
    [string]$PricingFile = "cost\model-pricing.md",
    [string]$Project = "BC Data Agent",
    [string]$Phase = "Implementation"
)

$ErrorActionPreference = "Stop"

function To-InvariantDecimal {
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

function Get-UsageValue {
    param(
        [object]$Object,
        [string]$Name
    )

    if ($null -eq $Object) {
        return [decimal]0
    }

    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property) {
        return [decimal]0
    }

    return To-InvariantDecimal $property.Value
}

function Get-PathKey {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return ""
    }

    try {
        return ([System.IO.Path]::GetFullPath($Path)).TrimEnd('\', '/').ToLowerInvariant()
    }
    catch {
        return $Path.TrimEnd('\', '/').ToLowerInvariant()
    }
}

function Get-SessionId {
    param([string]$Path)

    $name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    if ($name -match '(019[0-9a-fA-F-]+)$') {
        return $Matches[1]
    }

    return $name
}

function Get-SessionName {
    param([string]$Path)

    $datePart = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    if ($datePart -match 'rollout-(\d{4}-\d{2}-\d{2})') {
        return "BC Data Agent Codex session $($Matches[1])"
    }

    return "BC Data Agent Codex session"
}

function Read-PriceTable {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Pricing file not found: $Path"
    }

    $prices = @{}
    foreach ($line in Get-Content -LiteralPath $Path) {
        if ($line -match '^\|\s*(gpt-[^|]+?)\s*\|[^|]*\|\s*Standard\s*\|\s*Under 270K\s*\|\s*([0-9.]+)\s*\|\s*([0-9.]+)\s*\|\s*([0-9.]+)\s*\|') {
            $prices[$Matches[1].Trim()] = [pscustomobject]@{
                Input = To-InvariantDecimal $Matches[2]
                CachedInput = To-InvariantDecimal $Matches[3]
                Output = To-InvariantDecimal $Matches[4]
            }
        }
    }

    return $prices
}

function New-EmptyAggregate {
    param(
        [string]$SessionId,
        [string]$SessionName,
        [string]$Model,
        [string]$Effort
    )

    return [pscustomobject]@{
        SessionId = $SessionId
        SessionName = $SessionName
        Model = $Model
        Effort = $Effort
        StartedUtc = ""
        EndedUtc = ""
        Events = [decimal]0
        InputTokens = [decimal]0
        CachedInputTokens = [decimal]0
        OutputTokens = [decimal]0
        ReasoningOutputTokens = [decimal]0
        TotalTokens = [decimal]0
    }
}

$projectPathKey = Get-PathKey ((Resolve-Path -LiteralPath $ProjectRoot).Path)
$sessionsPath = Join-Path $CodexHome "sessions"
if (-not (Test-Path -LiteralPath $sessionsPath)) {
    throw "Codex sessions folder not found: $sessionsPath"
}

$prices = Read-PriceTable $PricingFile
$aggregates = @{}

foreach ($sessionFile in Get-ChildItem -LiteralPath $sessionsPath -Recurse -File -Filter "*.jsonl") {
    $currentCwdKey = ""
    $currentModel = "unknown"
    $currentEffort = "unknown"
    $lastTotalSignature = ""
    $sessionId = Get-SessionId $sessionFile.FullName
    $sessionName = Get-SessionName $sessionFile.FullName

    foreach ($line in Get-Content -LiteralPath $sessionFile.FullName) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        try {
            $entry = $line | ConvertFrom-Json -ErrorAction Stop
        }
        catch {
            continue
        }

        if ($entry.type -eq "turn_context") {
            $currentCwdKey = Get-PathKey $entry.payload.cwd
            if ($entry.payload.model) {
                $currentModel = [string]$entry.payload.model
            }
            if ($entry.payload.effort) {
                $currentEffort = [string]$entry.payload.effort
            }
            elseif ($entry.payload.collaboration_mode.settings.reasoning_effort) {
                $currentEffort = [string]$entry.payload.collaboration_mode.settings.reasoning_effort
            }
            continue
        }

        if ($entry.type -ne "event_msg") {
            continue
        }

        if ($entry.payload.type -ne "token_count") {
            continue
        }

        if ($currentCwdKey -ne $projectPathKey) {
            continue
        }

        if ($null -eq $entry.payload.info.last_token_usage) {
            continue
        }

        $totalUsage = $entry.payload.info.total_token_usage
        $totalSignature = "$((Get-UsageValue $totalUsage 'input_tokens'))|$((Get-UsageValue $totalUsage 'cached_input_tokens'))|$((Get-UsageValue $totalUsage 'output_tokens'))|$((Get-UsageValue $totalUsage 'reasoning_output_tokens'))|$((Get-UsageValue $totalUsage 'total_tokens'))"
        if ($totalSignature -eq $lastTotalSignature) {
            continue
        }
        $lastTotalSignature = $totalSignature

        $key = "$sessionId|$currentModel|$currentEffort"
        if (-not $aggregates.ContainsKey($key)) {
            $aggregates[$key] = New-EmptyAggregate $sessionId $sessionName $currentModel $currentEffort
        }

        $aggregate = $aggregates[$key]
        $usage = $entry.payload.info.last_token_usage
        $aggregate.Events += 1
        $aggregate.InputTokens += Get-UsageValue $usage 'input_tokens'
        $aggregate.CachedInputTokens += Get-UsageValue $usage 'cached_input_tokens'
        $aggregate.OutputTokens += Get-UsageValue $usage 'output_tokens'
        $aggregate.ReasoningOutputTokens += Get-UsageValue $usage 'reasoning_output_tokens'
        $aggregate.TotalTokens += Get-UsageValue $usage 'total_tokens'

        if ([string]::IsNullOrWhiteSpace($aggregate.StartedUtc)) {
            $aggregate.StartedUtc = [string]$entry.timestamp
        }
        $aggregate.EndedUtc = [string]$entry.timestamp
    }
}

$existingRows = @()
if (Test-Path -LiteralPath $UsageLog) {
    $existingRows = @(Import-Csv -LiteralPath $UsageLog | Where-Object {
        ($_.project -ne $Project) -or ($_.precision -eq "actual-invoice")
    })
}

$newRows = New-Object System.Collections.Generic.List[object]
foreach ($aggregate in ($aggregates.Values | Sort-Object SessionId, Model)) {
    $uncachedInputTokens = [Math]::Max([decimal]0, $aggregate.InputTokens - $aggregate.CachedInputTokens)
    $estimatedCost = [decimal]0
    $inputPrice = ""
    $cachedInputPrice = ""
    $outputPrice = ""
    $precision = "blocked"
    $pricingSource = "OpenAI API pricing not applied because model pricing is missing"

    if ($prices.ContainsKey($aggregate.Model)) {
        $price = $prices[$aggregate.Model]
        $inputPrice = $price.Input.ToString("0.######", [System.Globalization.CultureInfo]::InvariantCulture)
        $cachedInputPrice = $price.CachedInput.ToString("0.######", [System.Globalization.CultureInfo]::InvariantCulture)
        $outputPrice = $price.Output.ToString("0.######", [System.Globalization.CultureInfo]::InvariantCulture)
        $estimatedCost = (($uncachedInputTokens / 1000000) * $price.Input) + (($aggregate.CachedInputTokens / 1000000) * $price.CachedInput) + (($aggregate.OutputTokens / 1000000) * $price.Output)
        $precision = "token-telemetry-estimate"
        $pricingSource = "OpenAI API pricing 2026-05-07 from cost/model-pricing.md; Standard Under 270K"
    }

    $newRows.Add([pscustomobject]@{
        session_id = "codex-$($aggregate.SessionId)-$($aggregate.Model)"
        session_name = $aggregate.SessionName
        project = $Project
        phase = $Phase
        task = "Project AI work from local Codex telemetry"
        agent_role = "Codex"
        model = $aggregate.Model
        effort = $aggregate.Effort
        started_utc = $aggregate.StartedUtc
        ended_utc = $aggregate.EndedUtc
        events = [int]$aggregate.Events
        input_tokens = [int64]$aggregate.InputTokens
        cached_input_tokens = [int64]$aggregate.CachedInputTokens
        uncached_input_tokens = [int64]$uncachedInputTokens
        output_tokens = [int64]$aggregate.OutputTokens
        reasoning_output_tokens = [int64]$aggregate.ReasoningOutputTokens
        total_tokens = [int64]$aggregate.TotalTokens
        input_price_per_1m = $inputPrice
        cached_input_price_per_1m = $cachedInputPrice
        output_price_per_1m = $outputPrice
        estimated_cost_usd = $estimatedCost.ToString("0.000000", [System.Globalization.CultureInfo]::InvariantCulture)
        actual_cost_usd = ""
        pricing_source = $pricingSource
        precision = $precision
        notes = "Exact Codex token telemetry filtered by cwd '$projectPathKey'. Raw prompts, transcripts, tool output, and Business Central data are not stored in this rollup."
    })
}

$rowsToWrite = New-Object System.Collections.Generic.List[object]
foreach ($row in $existingRows) {
    $rowsToWrite.Add($row)
}
foreach ($row in $newRows) {
    $rowsToWrite.Add($row)
}

if ($rowsToWrite.Count -eq 0) {
    $header = '"session_id","session_name","project","phase","task","agent_role","model","effort","started_utc","ended_utc","events","input_tokens","cached_input_tokens","uncached_input_tokens","output_tokens","reasoning_output_tokens","total_tokens","input_price_per_1m","cached_input_price_per_1m","output_price_per_1m","estimated_cost_usd","actual_cost_usd","pricing_source","precision","notes"'
    Set-Content -LiteralPath $UsageLog -Value $header -Encoding ascii
}
else {
    $rowsToWrite | Export-Csv -LiteralPath $UsageLog -NoTypeInformation -Encoding ascii
}

Write-Host "Updated $UsageLog with $($newRows.Count) Codex telemetry row(s)."
