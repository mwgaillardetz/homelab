[CmdletBinding()]
param(
    [string]$AppsPath = (Join-Path $PSScriptRoot '..\apps')
)

$ErrorActionPreference = 'Stop'
$neverPublish = @('stash')
$sensitiveKey = '(?i)(password|passwd|secret|token|api[_-]?key|apikey|private[_-]?key|access[_-]?key|client[_-]?secret|credential|encryption[_-]?key)'

$containers = docker ps -a -q | ForEach-Object { docker inspect $_ | ConvertFrom-Json }
$projects = $containers | ForEach-Object {
    $labels = $_.Config.Labels
    [pscustomobject]@{
        Project = $labels.'com.docker.compose.project'
        ConfigFiles = $labels.'com.docker.compose.project.config_files'
    }
} | Where-Object {
    $_.Project -and $_.ConfigFiles -and $_.Project -notin $neverPublish
} | Sort-Object Project -Unique

foreach ($project in $projects) {
    $destination = Join-Path $AppsPath $project.Project
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    $exampleKeys = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    $files = @($project.ConfigFiles -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })

    foreach ($source in $files) {
        if (-not (Test-Path -LiteralPath $source)) {
            Write-Warning "Skipping missing Compose file for $($project.Project): $source"
            continue
        }

        $targetName = if ($files.Count -eq 1) { 'compose.yaml' } else { [IO.Path]::GetFileName($source) }
        $target = Join-Path $destination $targetName
        $sanitized = foreach ($line in Get-Content -LiteralPath $source) {
            $result = $line
            if ($line -match '^(\s*(?:#\s*)?(?:-\s*)?["'']?)([A-Za-z_][A-Za-z0-9_.-]*)(\s*[:=]\s*)(.*?)(["'']?\s*)$') {
                $prefix, $key, $separator, $value, $suffix = $Matches[1], $Matches[2], $Matches[3], $Matches[4], $Matches[5]
                if ($key -match $sensitiveKey -and $value -notmatch '^\s*["'']?\$\{') {
                    [void]$exampleKeys.Add($key)
                    $result = "$prefix$key$separator`${$key}$suffix"
                }
            }

            foreach ($match in [regex]::Matches($result, '\$\{([A-Za-z_][A-Za-z0-9_]*)([^}]*)\}')) {
                $variable, $tail = $match.Groups[1].Value, $match.Groups[2].Value
                if ($variable -match $sensitiveKey) {
                    [void]$exampleKeys.Add($variable)
                    $result = $result.Replace($match.Value, "`${$variable}")
                } elseif ($tail -notmatch '^:-') {
                    [void]$exampleKeys.Add($variable)
                }
            }
            $result.TrimEnd()
        }
        while ($sanitized.Count -gt 0 -and [string]::IsNullOrWhiteSpace($sanitized[-1])) {
            $sanitized = $sanitized[0..($sanitized.Count - 2)]
        }
        $sanitized | Set-Content -LiteralPath $target -Encoding utf8
    }

    if ($exampleKeys.Count -gt 0) {
        @('# Copy to .env and replace every placeholder locally.') +
            @($exampleKeys | Sort-Object | ForEach-Object {
                $example = if ($_ -match '(?i)(location|path|directory|_dir)$') { './CHANGE_ME' }
                    elseif ($_ -match '(?i)(vol|volume)') { 'change-me-data' }
                    elseif ($_ -match '(?i)port$') { '9999' }
                    else { 'CHANGE_ME' }
                "$_=$example"
            }) |
            Set-Content -LiteralPath (Join-Path $destination '.env.example') -Encoding utf8
    }
}

Write-Host "Imported $($projects.Count) Compose projects. Permanently excluded: $($neverPublish -join ', ')."
