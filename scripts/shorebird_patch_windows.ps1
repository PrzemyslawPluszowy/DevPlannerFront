[CmdletBinding()]
param(
  [string]$ReleaseVersion = '',
  [string]$Track = 'stable',
  [switch]$DryRun,
  [switch]$VerboseMode
)

$ErrorActionPreference = 'Stop'

$shorebirdBin = Join-Path $HOME '.shorebird\bin'
$shorebirdBat = Join-Path $shorebirdBin 'shorebird.bat'
$patchDir = Join-Path $shorebirdBin 'cache\artifacts\patch'
$patchExe = Join-Path $patchDir 'patch.exe'
$patchNoExt = Join-Path $patchDir 'patch'

if (-not (Test-Path $shorebirdBat)) {
  throw "Nie znaleziono Shorebird CLI pod sciezka: $shorebirdBat"
}

if (-not (($env:Path -split ';') -contains $shorebirdBin)) {
  $env:Path = "$shorebirdBin;$env:Path"
}

# Shorebird uruchamia helper jako plik bez rozszerzenia, wiec dopilnuj obu wariantow.
if ((Test-Path $patchExe) -and -not (Test-Path $patchNoExt)) {
  Copy-Item $patchExe $patchNoExt -Force
}

$layers = 'HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers'
if (Test-Path $patchExe) {
  & reg add $layers /v $patchExe /d '~ RUNASINVOKER' /f | Out-Null
}
if (Test-Path $patchNoExt) {
  & reg add $layers /v $patchNoExt /d '~ RUNASINVOKER' /f | Out-Null
}

$args = @('patch', 'windows', '--track', $Track)
if ($ReleaseVersion.Trim().Length -gt 0) {
  $args += @('--release-version', $ReleaseVersion)
}
if ($DryRun) {
  $args += '-n'
}
if ($VerboseMode) {
  $args += '--verbose'
}

Write-Host "Uruchamiam: $shorebirdBat $($args -join ' ')"
& $shorebirdBat @args
