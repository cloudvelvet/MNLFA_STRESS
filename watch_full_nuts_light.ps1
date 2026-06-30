param(
  [string]$TaskName = "MNLFA_FULL_NUTS_LIGHT_20260520",
  [string]$OutDir = "C:\chen_bauer_2024\poster_model_output\full_nuts_light",
  [int]$PollSeconds = 300,
  [int]$MaxHours = 72
)

$ErrorActionPreference = "Continue"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$watchLog = Join-Path $OutDir "watch_${TaskName}_$stamp.log"
$doneFile = Join-Path $OutDir "FULL_NUTS_LIGHT_DONE.txt"

function Write-WatchLog {
  param([string]$Message)
  "$(Get-Date -Format o) $Message" | Add-Content -Path $watchLog -Encoding utf8
}

Write-WatchLog "START watcher task=$TaskName poll=${PollSeconds}s max=${MaxHours}h"

$deadline = (Get-Date).AddHours($MaxHours)
while ((Get-Date) -lt $deadline) {
  $query = & schtasks.exe /Query /TN $TaskName /V /FO LIST 2>&1
  $statusLine = ($query | Where-Object { $_ -match "^Status:" } | Select-Object -First 1)
  $lastResultLine = ($query | Where-Object { $_ -match "^Last Result:" } | Select-Object -First 1)
  Write-WatchLog "$statusLine; $lastResultLine"

  if ($statusLine -notmatch "Running") {
    $csvs = Get-ChildItem -Path $OutDir -File -Filter "maps_mnlfa_poster-*.csv" |
      Sort-Object LastWriteTime -Descending |
      Select-Object -First 8 Name, Length, LastWriteTime

    $summaryFiles = Get-ChildItem -Path $OutDir -File -Include `
      "latent_trajectory_summary.csv", "item_dif_summary.csv", "top_dif_effects.csv", `
      "poster_model_summary_all.csv" -ErrorAction SilentlyContinue |
      Select-Object Name, Length, LastWriteTime

    $report = @(
      "MNLFA full_nuts_light finished or stopped.",
      "Time: $(Get-Date -Format o)",
      "Task: $TaskName",
      $statusLine,
      $lastResultLine,
      "",
      "Recent Stan CSV files:",
      ($csvs | Format-Table -AutoSize | Out-String),
      "",
      "Summary files:",
      ($summaryFiles | Format-Table -AutoSize | Out-String)
    )
    $report | Set-Content -Path $doneFile -Encoding utf8
    Write-WatchLog "DONE wrote=$doneFile"

    try {
      & msg.exe $env:USERNAME "MNLFA full_nuts_light finished. Check $doneFile"
    } catch {
      Write-WatchLog "msg.exe failed: $($_.Exception.Message)"
    }
    exit 0
  }

  Start-Sleep -Seconds $PollSeconds
}

"Watcher timed out at $(Get-Date -Format o)" | Set-Content -Path $doneFile -Encoding utf8
Write-WatchLog "TIMEOUT wrote=$doneFile"
exit 1
