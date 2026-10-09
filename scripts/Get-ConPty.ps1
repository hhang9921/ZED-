#requires -Version 7.2
[CmdletBinding()]
param([Parameter(Mandatory)][string]$Destination, [string]$PackagePath)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content (Join-Path $projectRoot 'zed-version.json') -Raw | ConvertFrom-Json
New-Item -ItemType Directory -Force $Destination | Out-Null
$cacheDirectory = Join-Path $projectRoot 'dist/conpty-cache'
New-Item -ItemType Directory -Force $cacheDirectory | Out-Null
if (-not $PackagePath) {
    $PackagePath = Join-Path $cacheDirectory 'conpty.nupkg.zip'
    Invoke-WebRequest -Uri $manifest.conptyUrl -OutFile $PackagePath
}
$extractDirectory = Join-Path $cacheDirectory 'extracted'
Expand-Archive -LiteralPath $PackagePath -DestinationPath $extractDirectory -Force
$dll = Join-Path $extractDirectory 'runtimes/win-x64/native/conpty.dll'
$console = Join-Path $extractDirectory 'build/native/runtimes/x64/OpenConsole.exe'
foreach ($path in @($dll, $console)) {
    if (-not (Test-Path -LiteralPath $path)) { throw "ConPTY package is missing $path" }
    Copy-Item -LiteralPath $path -Destination $Destination -Force
}
Get-FileHash -LiteralPath $PackagePath -Algorithm SHA256 | Format-List Hash
