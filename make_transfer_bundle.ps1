param(
  [string]$OutputDir = "transfer_bundles"
)

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$outPath = Join-Path $root $OutputDir
if (-not (Test-Path $outPath)) {
  New-Item -ItemType Directory -Path $outPath | Out-Null
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipPath = Join-Path $outPath "MNLFA_STRESS_code_notes_$stamp.zip"
$stage = Join-Path $outPath "_stage_$stamp"

if (Test-Path $stage) {
  Remove-Item -LiteralPath $stage -Recurse -Force
}
New-Item -ItemType Directory -Path $stage | Out-Null

$includeFiles = @(
  ".gitignore",
  "NEXT_COMPUTER_HANDOFF.md"
)

$includePatterns = @(
  "*.R",
  "*.ps1",
  "*.py",
  "*.md"
)

foreach ($file in $includeFiles) {
  $src = Join-Path $root $file
  if (Test-Path $src) {
    Copy-Item -LiteralPath $src -Destination (Join-Path $stage $file) -Force
  }
}

foreach ($pattern in $includePatterns) {
  Get-ChildItem -Path $root -File -Filter $pattern | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $stage $_.Name) -Force
  }
}

$researchSrc = Join-Path $root "RESEARCH"
if (Test-Path $researchSrc) {
  Copy-Item -LiteralPath $researchSrc -Destination (Join-Path $stage "RESEARCH") -Recurse -Force
}

Compress-Archive -Path (Join-Path $stage "*") -DestinationPath $zipPath -Force
Remove-Item -LiteralPath $stage -Recurse -Force

Write-Host "Created: $zipPath"
Write-Host ""
Write-Host "Not included: MAPS raw data, llm_dif_output, model outputs, API keys."
Write-Host "Move those separately only when needed."
