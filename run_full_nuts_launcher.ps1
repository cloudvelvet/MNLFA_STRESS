param(
  [ValidateSet("full_nuts_light", "full_nuts")]
  [string]$Mode = "full_nuts_light",
  [string]$Stamp = (Get-Date -Format "yyyyMMdd_HHmmss")
)

$ErrorActionPreference = "Stop"

$root = "C:\chen_bauer_2024"
$outDir = Join-Path $root "poster_model_output\$Mode"
$tmp = Join-Path $root "rstan_tmp"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

$env:TMPDIR = $tmp
$env:TMP = $tmp
$env:TEMP = $tmp

$log = Join-Path $outDir "${Mode}_launcher_$Stamp.log"
$status = Join-Path $outDir "${Mode}_launcher_$Stamp.status.txt"

"START $(Get-Date -Format o)" | Out-File -FilePath $status -Encoding utf8
"Log: $log" | Add-Content -Path $status -Encoding utf8

try {
  Set-Location $root
  $stdout = Join-Path $outDir "${Mode}_launcher_$Stamp.stdout.log"
  $stderr = Join-Path $outDir "${Mode}_launcher_$Stamp.stderr.log"
  $rscript = "C:\Program Files\R\R-4.4.2\bin\x64\Rscript.exe"
  $script = Join-Path $root "maps_mnlfa_poster_run.R"
  $proc = Start-Process -FilePath $rscript `
    -ArgumentList @($script, $Mode) `
    -WorkingDirectory $root `
    -RedirectStandardOutput $stdout `
    -RedirectStandardError $stderr `
    -WindowStyle Hidden `
    -Wait `
    -PassThru
  "STDOUT $stdout" | Add-Content -Path $status -Encoding utf8
  "STDERR $stderr" | Add-Content -Path $status -Encoding utf8
  "EXIT_CODE $($proc.ExitCode)" | Add-Content -Path $status -Encoding utf8
  "END $(Get-Date -Format o)" | Add-Content -Path $status -Encoding utf8
  exit $proc.ExitCode
} catch {
  "ERROR $($_.Exception.Message)" | Add-Content -Path $status -Encoding utf8
  $_ | Out-String | Add-Content -Path $status -Encoding utf8
  throw
}
