param(
  [ValidateSet("quick", "full", "nuts_check")]
  [string]$Mode = "quick"
)

$ErrorActionPreference = "Stop"

$rscript = "C:\Program Files\R\R-4.4.2\bin\x64\Rscript.exe"
if (-not (Test-Path $rscript)) {
  $rscript = "C:\Program Files\R\R-4.4.1\bin\Rscript.exe"
}
if (-not (Test-Path $rscript)) {
  throw "Could not find Rscript.exe in known local R install paths."
}

& $rscript ".\maps_empirical_comparators_run.R" $Mode
