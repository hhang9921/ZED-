#requires -Version 7.2
[CmdletBinding()]
param([string]$SourceDirectory)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content (Join-Path $projectRoot 'zed-version.json') -Raw | ConvertFrom-Json
if (-not $SourceDirectory) { $SourceDirectory = Join-Path $projectRoot 'source/zed' }
$SourceDirectory = [IO.Path]::GetFullPath($SourceDirectory)
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Install Git for Windows first.' }
if (-not (Test-Path -LiteralPath $SourceDirectory)) {
    New-Item -ItemType Directory -Force (Split-Path -Parent $SourceDirectory) | Out-Null
    & git clone --depth 1 --branch $manifest.upstreamTag $manifest.upstreamRepository $SourceDirectory
    if ($LASTEXITCODE -ne 0) { throw 'Failed to download Zed source.' }
}
$commit = & git -C $SourceDirectory rev-parse HEAD
if ($LASTEXITCODE -ne 0 -or $commit.Trim() -ne $manifest.upstreamCommit) {
    throw "Source must be at $($manifest.upstreamCommit). Existing source was not reset."
}
$patch = Join-Path $projectRoot 'patches/zed-zh-CN.patch'
& git -C $SourceDirectory apply --exclude=crates/title_bar/locales/zh-CN.yml --check $patch 2>$null
if ($LASTEXITCODE -eq 0) {
    & git -C $SourceDirectory apply --exclude=crates/title_bar/locales/zh-CN.yml $patch
    if ($LASTEXITCODE -ne 0) { throw 'Failed to apply Chinese patch.' }
} else {
    & git -C $SourceDirectory apply --exclude=crates/title_bar/locales/zh-CN.yml --reverse --check $patch 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Source differs from both the clean and patched versions. Review local changes first.' }
    Write-Host 'Chinese patch is already applied.'
}
$locale = Join-Path $SourceDirectory 'crates/title_bar/locales/zh-CN.yml'
New-Item -ItemType Directory -Force (Split-Path -Parent $locale) | Out-Null
Copy-Item -LiteralPath (Join-Path $projectRoot 'locales/zh-CN.yml') -Destination $locale
Write-Host "Source ready: $SourceDirectory"
