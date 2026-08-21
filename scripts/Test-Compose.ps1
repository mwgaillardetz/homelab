[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Join-Path $PSScriptRoot '..\apps'
$files = @(Get-ChildItem -LiteralPath $root -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object Name -in @('compose.yaml', 'compose.yml', 'docker-compose.yaml', 'docker-compose.yml'))

if ($files.Count -eq 0) {
    Write-Host 'No migrated Compose files found.'
    exit 0
}

$failed = $false
foreach ($file in $files) {
    Write-Host "Validating $($file.FullName)"
    & docker compose --file $file.FullName config --quiet
    if ($LASTEXITCODE -ne 0) { $failed = $true }
}

if ($failed) { throw 'One or more Compose files failed validation.' }
