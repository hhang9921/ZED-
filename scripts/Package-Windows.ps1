#requires -Version 7.2
[CmdletBinding()]
param([string]$BuildDirectory, [string]$SourceDirectory)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content (Join-Path $projectRoot 'zed-version.json') -Raw | ConvertFrom-Json
if (-not $SourceDirectory) { $SourceDirectory = Join-Path $projectRoot 'source/zed' }
if (-not $BuildDirectory) { $BuildDirectory = Join-Path $SourceDirectory "target/$($manifest.profile)" }
$distDirectory = Join-Path $projectRoot 'dist'
if (-not (Test-Path (Join-Path $projectRoot 'licenses/DEPENDENCIES.md')) -or (Get-Item (Join-Path $projectRoot 'licenses/DEPENDENCIES.md')).Length -lt 1000) { throw 'Generate dependency licenses using Build-Windows.ps1 before packaging.' }
if ((Get-Content (Join-Path $projectRoot 'licenses/DEPENDENCIES.md') -Raw) -notmatch 'rust-i18n') { throw 'Generated dependency licenses must include rust-i18n.' }
$packageName = "zed-zh-CN-$($manifest.releaseTag)-windows-x64"
$stageDirectory = Join-Path $distDirectory $packageName
$binDirectory = Join-Path $stageDirectory 'bin'
New-Item -ItemType Directory -Force $binDirectory | Out-Null
foreach ($file in @('zed.exe', 'cli.exe', 'conpty.dll', 'OpenConsole.exe')) {
    $inputPath = Join-Path $BuildDirectory $file
    if (-not (Test-Path -LiteralPath $inputPath)) { throw "Missing required package file: $inputPath" }
    Copy-Item -LiteralPath $inputPath -Destination $binDirectory -Force
}
Copy-Item -LiteralPath (Join-Path $projectRoot 'portable/Launch.cmd') -Destination $stageDirectory
Copy-Item -LiteralPath (Join-Path $projectRoot 'docs/PORTABLE.md') -Destination (Join-Path $stageDirectory 'README.md')
Copy-Item -LiteralPath (Join-Path $projectRoot 'LICENSE') -Destination $stageDirectory
Copy-Item -LiteralPath (Join-Path $projectRoot 'NOTICE.md') -Destination $stageDirectory
Copy-Item -LiteralPath (Join-Path $projectRoot 'zed-version.json') -Destination $stageDirectory
Copy-Item -LiteralPath (Join-Path $projectRoot 'licenses') -Destination $stageDirectory -Recurse -Force
$zipPath = Join-Path $distDirectory "$packageName.zip"
Compress-Archive -Path $stageDirectory -DestinationPath $zipPath -CompressionLevel Optimal -Force
$sourceArchive = Join-Path $distDirectory "zed-zh-CN-$($manifest.releaseTag)-source.tar.gz"
if (-not (Test-Path -LiteralPath (Join-Path $SourceDirectory 'Cargo.toml'))) { throw 'Corresponding source directory is required for sharing the binary.' }
& tar -czf $sourceArchive --exclude=.git --exclude=target -C (Split-Path -Parent $SourceDirectory) (Split-Path -Leaf $SourceDirectory)
if ($LASTEXITCODE -ne 0) { throw 'Failed to package corresponding source.' }
$checksumLines = foreach ($path in @($zipPath, $sourceArchive)) {
    $hash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
    "$hash  $([IO.Path]::GetFileName($path))"
}
Set-Content -LiteralPath (Join-Path $distDirectory 'SHA256SUMS.txt') -Value $checksumLines -Encoding utf8NoBOM
Write-Host "Portable package: $zipPath"
Write-Host "Corresponding source: $sourceArchive"
