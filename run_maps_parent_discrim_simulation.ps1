$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$tmp = Join-Path $root "rstan_tmp"
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

$env:TMPDIR = $tmp
$env:TMP = $tmp
$env:TEMP = $tmp
$env:LANG = "en_US.UTF-8"
$env:LC_ALL = "en_US.UTF-8"

& "C:\Program Files\R\R-4.4.2\bin\x64\Rscript.exe" (Join-Path $root "maps_parent_discrim_simulation_run.R")
