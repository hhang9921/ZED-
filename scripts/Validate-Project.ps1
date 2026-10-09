#requires -Version 7.2
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content (Join-Path $projectRoot 'zed-version.json') -Raw | ConvertFrom-Json
if ($manifest.upstreamCommit -notmatch '^[a-f0-9]{40}$') { throw 'Invalid upstream commit.' }
foreach ($script in Get-ChildItem (Join-Path $projectRoot 'scripts') -Filter '*.ps1') {
    $parseTokens = $null
    $parseErrors = $null
    [Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$parseTokens, [ref]$parseErrors) | Out-Null
    if ($parseErrors.Count) { throw "$($script.Name): $parseErrors" }
}
foreach ($document in Get-ChildItem $projectRoot -Recurse -File -Filter '*.md' | Where-Object { $_.FullName -notmatch '[\\/](source|dist|original-files|\.git)[\\/]' }) {
    $content = Get-Content $document.FullName -Raw
    foreach ($link in [regex]::Matches($content, '\]\(([^)]+)\)')) {
        $target = $link.Groups[1].Value.Trim().Split('#')[0]
        if (-not $target -or $target -match '^([a-z]+:|/)') { continue }
        if (-not (Test-Path -LiteralPath (Join-Path $document.DirectoryName $target))) { throw "Broken link in $($document.Name): $target" }
    }
}
if (-not (Test-Path (Join-Path $projectRoot 'locales/zh-CN.yml'))) { throw 'Missing locale.' }
if (-not (Test-Path (Join-Path $projectRoot 'patches/zed-zh-CN.patch'))) { throw 'Missing source patch.' }
Write-Host 'Manifest, PowerShell syntax, documentation links, and required files passed.'
