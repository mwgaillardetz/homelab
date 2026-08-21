[CmdletBinding()]
param(
    [string]$OutputPath = (Join-Path $PSScriptRoot '..\docs\status.svg'),
    [string]$DarkOutputPath = (Join-Path $PSScriptRoot '..\docs\status-dark.svg')
)

$ErrorActionPreference = 'Stop'
$ignored = @('stash')
$items = docker ps -a -q | ForEach-Object { docker inspect $_ | ConvertFrom-Json } | Where-Object {
    $_.Config.Labels.'com.docker.compose.project' -notin $ignored
}

$projects = @($items | ForEach-Object {
    $name = $_.Config.Labels.'com.docker.compose.project'
    if ($name) { $name } else { 'standalone' }
} | Sort-Object -Unique)
$running = @($items | Where-Object { $_.State.Status -eq 'running' }).Count
$healthy = @($items | Where-Object { $_.State.Health -and $_.State.Health.Status -eq 'healthy' }).Count
$unhealthy = @($items | Where-Object { $_.State.Health -and $_.State.Health.Status -eq 'unhealthy' }).Count
$images = @($items.Config.Image | Sort-Object -Unique).Count
$engine = docker info --format '{{json .}}' | ConvertFrom-Json
$generated = Get-Date -Format 'yyyy-MM-dd HH:mm K'

function Escape([string]$Value) { [System.Security.SecurityElement]::Escape($Value) }
function Render([hashtable]$Theme, [string]$Path) {
    $tiles = @(
        @('containers', "$running/$($items.Count)", 'running'),
        @('compose projects', "$($projects.Count)", 'declared'),
        @('healthy', "$healthy", "$unhealthy unhealthy"),
        @('images', "$images", 'distinct')
    )
    $tileSvg = for ($i = 0; $i -lt $tiles.Count; $i++) {
        $x = 42 + ($i * 198)
        "<text x='$x' y='105' class='value'>$($tiles[$i][1])</text><text x='$x' y='128' class='label'>$($tiles[$i][0].ToUpper())</text><text x='$x' y='148' class='sub'>$($tiles[$i][2])</text>"
    }

    $pills = [System.Collections.Generic.List[string]]::new()
    $x = 42; $y = 220
    foreach ($project in $projects) {
        $width = [Math]::Max(72, 22 + ($project.Length * 7))
        if ($x + $width -gt 798) { $x = 42; $y += 38 }
        $pills.Add("<rect x='$x' y='$y' width='$width' height='27' rx='13.5' class='pill'/><text x='$($x + $width/2)' y='$($y + 18)' class='pilltext' text-anchor='middle'>$(Escape $project)</text>")
        $x += $width + 9
    }
    $height = $y + 88
    $healthColor = if ($unhealthy -eq 0) { $Theme.accent } else { '#d97706' }
    $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" width="840" height="$height" viewBox="0 0 840 $height" role="img" aria-label="Docker homelab status">
<style>
text{font-family:'Ubuntu Sans','Ubuntu',system-ui,sans-serif}.value{font-family:'Ubuntu Mono',ui-monospace,monospace;font-size:25px;font-weight:700;fill:$($Theme.accent)}.label{font-family:'Ubuntu Mono',ui-monospace,monospace;font-size:11px;font-weight:600;fill:$($Theme.faint)}.sub{font-family:'Ubuntu Mono',ui-monospace,monospace;font-size:12px;font-weight:500;fill:$($Theme.muted)}.pill{fill:$($Theme.accent);fill-opacity:.12;stroke:$($Theme.accent)}.pilltext{font-family:'Ubuntu Sans','Ubuntu',system-ui,sans-serif;font-size:11px;font-weight:600;fill:$($Theme.accent)}.pulse{animation:p 2.2s ease-in-out infinite}@keyframes p{50%{opacity:.3}}
</style>
<rect x=".5" y=".5" width="839" height="$($height - 1)" rx="14" fill="$($Theme.bg)" stroke="$($Theme.line)"/>
<rect width="840" height="2" rx="1" fill="$($Theme.accent)"/>
<circle class="pulse" cx="47" cy="38" r="5" fill="$healthColor"/><text x="61" y="42" class="label">DOCKER · LIVE</text>
<text x="798" y="42" class="sub" text-anchor="end">$(Escape $engine.Name) · Docker $(Escape $engine.ServerVersion)</text>
$($tileSvg -join "`n")
<line x1="42" y1="174" x2="798" y2="174" stroke="$($Theme.line)"/>
<text x="42" y="202" class="label">COMPOSE PROJECTS</text>
$($pills -join "`n")
<text x="42" y="$($height - 25)" class="sub">source · local Docker API · generated $(Escape $generated)</text>
</svg>
"@
    $svg | Set-Content -LiteralPath $Path -Encoding utf8
}

$light = @{bg='#f8fafc';line='#dbe4df';muted='#475b55';faint='#647d75';accent='#0f8f78'}
$dark = @{bg='#0b1412';line='#263d37';muted='#a9c2ba';faint='#738f86';accent='#35c9a5'}
Render $light $OutputPath
Render $dark $DarkOutputPath
Write-Host "Wrote Docker status cards to $OutputPath and $DarkOutputPath"
