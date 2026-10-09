#requires -Version 7.2
[CmdletBinding()]
param([string]$SourceDirectory, [string]$BuildToolsPath, [int]$Jobs = 8)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content (Join-Path $projectRoot 'zed-version.json') -Raw | ConvertFrom-Json
if (-not $SourceDirectory) { $SourceDirectory = Join-Path $projectRoot 'source/zed' }
$SourceDirectory = [IO.Path]::GetFullPath($SourceDirectory)
& (Join-Path $PSScriptRoot 'Prepare-Source.ps1') -SourceDirectory $SourceDirectory
if (-not $BuildToolsPath) {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
    if (-not (Test-Path -LiteralPath $vswhere)) { throw 'Install Visual Studio Build Tools with the C++ workload first, or supply -BuildToolsPath.' }
    $BuildToolsPath = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    if (-not $BuildToolsPath) { throw 'Visual C++ Build Tools were not found.' }
}
$developerShell = Join-Path $BuildToolsPath 'Common7/Tools/Launch-VsDevShell.ps1'
if (-not (Test-Path -LiteralPath $developerShell)) { throw "Developer shell not found: $developerShell" }
& $developerShell -Arch amd64 -HostArch amd64 -SkipAutomaticLocation
$cargoDirectory = if ($env:CARGO_HOME) { Join-Path $env:CARGO_HOME 'bin' } else { Join-Path $env:USERPROFILE '.cargo/bin' }
$env:PATH = "$cargoDirectory;$env:PATH"
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) { throw 'Install Rust using rustup first.' }
foreach ($tool in @('cl.exe', 'link.exe', 'cmake.exe', 'rc.exe')) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) { throw "Missing build tool: $tool" }
}
$env:CARGO_BUILD_JOBS = [string]$Jobs
$env:CARGO_PROFILE_RELEASE_FAST_DEBUG = [string]$manifest.debugSymbols
$env:CARGO_PROFILE_RELEASE_FAST_OPT_LEVEL = [string]$manifest.optimizationLevel
$logDirectory = Join-Path $projectRoot 'build-logs'
New-Item -ItemType Directory -Force $logDirectory | Out-Null
Push-Location $SourceDirectory
try {
    & cargo "+$($manifest.rustToolchain)" build --locked -p zed -p cli --bin zed --bin cli --profile $manifest.profile 2>&1 |
        Tee-Object -FilePath (Join-Path $logDirectory 'build-windows.log')
    if ($LASTEXITCODE -ne 0) { throw "Cargo build failed: $LASTEXITCODE" }
} finally { Pop-Location }
$buildDirectory = Join-Path $SourceDirectory "target/$($manifest.profile)"
& (Join-Path $PSScriptRoot 'Get-ConPty.ps1') -Destination $buildDirectory
Push-Location $SourceDirectory
try {
    & (Join-Path $SourceDirectory 'script/generate-licenses.ps1') (Join-Path $projectRoot 'licenses/DEPENDENCIES.md')
} finally { Pop-Location }
Write-Host "Build ready: $buildDirectory"
