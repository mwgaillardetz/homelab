[CmdletBinding()]
param(
    [string]$OutputPath = (Join-Path $PSScriptRoot '..\docs\inventory.md'),
    [string]$IgnorePath = (Join-Path $PSScriptRoot '..\.inventoryignore')
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker CLI was not found.'
}

$ids = @(docker ps -a -q)
$containers = foreach ($id in $ids) {
    $item = docker inspect $id | ConvertFrom-Json
    $labels = $item.Config.Labels
    $project = $labels.'com.docker.compose.project'
    $service = $labels.'com.docker.compose.service'
    $ports = @(
        $item.NetworkSettings.Ports.PSObject.Properties | ForEach-Object {
            $containerPort = $_.Name
            if ($_.Value) {
                $_.Value | ForEach-Object { "$($_.HostPort) -> $containerPort" }
            }
        }
    ) | Sort-Object -Unique
    $ports = $ports -join '<br>'

    [pscustomobject]@{
        Project = if ($project) { $project } else { 'standalone' }
        Service = if ($service) { $service } else { $item.Name.TrimStart('/') }
        Image   = $item.Config.Image
        State   = $item.State.Status
        Health  = if ($item.State.Health) { $item.State.Health.Status } else { '-' }
        Ports   = if ($ports) { $ports } else { '-' }
    }
}

$ignoredProjects = if (Test-Path -LiteralPath $IgnorePath) {
    @(Get-Content -LiteralPath $IgnorePath |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and -not $_.StartsWith('#') })
} else {
    @()
}

$containers = @($containers |
    Where-Object Project -notin $ignoredProjects |
    Sort-Object Project, Service)
$projectCount = @($containers.Project | Sort-Object -Unique).Count
$runningCount = @($containers | Where-Object State -eq 'running').Count
$generated = Get-Date -Format 'yyyy-MM-dd HH:mm:ss K'

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('# Service inventory')
$lines.Add('')
$lines.Add("Generated from Docker metadata on $generated. This file excludes environment values, mounts, labels, logs, and secrets.")
$lines.Add('')
$lines.Add("- Containers: $($containers.Count)")
$lines.Add("- Running: $runningCount")
$lines.Add("- Projects: $projectCount")
$lines.Add('')
$lines.Add('| Project | Service | Image | State | Health | Published ports |')
$lines.Add('|---|---|---|---|---|---|')
foreach ($container in $containers) {
    $values = @($container.Project, $container.Service, $container.Image, $container.State, $container.Health, $container.Ports)
    $safe = $values | ForEach-Object { ([string]$_).Replace('|', '\|') }
    $lines.Add('| ' + ($safe -join ' | ') + ' |')
}

$resolved = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
$lines | Set-Content -LiteralPath $resolved -Encoding utf8
Write-Host "Wrote sanitized inventory to $resolved"
