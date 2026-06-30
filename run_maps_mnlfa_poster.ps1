param(
  [ValidateSet("quick", "full", "nuts_check", "full_nuts_light", "full_nuts")]
  [string]$Mode = "quick"
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$tmp = Join-Path $root "rstan_tmp"
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

$env:TMPDIR = $tmp
$env:TMP = $tmp
$env:TEMP = $tmp

& "C:\Program Files\R\R-4.4.2\bin\x64\Rscript.exe" (Join-Path $root "maps_mnlfa_poster_run.R") $Mode
