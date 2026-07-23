$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$source = Join-Path $root 'docs\proposal\RSDI_dissertation_proposal_ko.md'
$target = Join-Path $root 'docs\proposal\RSDI_dissertation_proposal_ko_full_v2.md'
$text = [System.IO.File]::ReadAllText($source, [System.Text.Encoding]::UTF8)
$text = $text.Replace('1# 종단 순서형 패널자료에서 잠재 변화와 반응 이동을 분해하는 베이지안 종단 MNLFA 프레임워크', '# 종단 순서형 패널자료에서 잠재 변화와 측정기능 변화를 분해하는 베이지안 종단 MNLFA 프레임워크')
$text = $text.Replace('**학위논문 연구계획서 (3-편 논문 통합 개요 / Three-Paper Dissertation Proposal)**', '**박사학위논문 연구계획서 (3편 논문형 학위논문 / Three-Paper Dissertation Proposal)**')

$tail = (Get-Content -Encoding UTF8 (Join-Path $PSScriptRoot 'build_proposal_v2.ps1') | Select-Object -Skip 16) -join "`r`n"
Invoke-Expression $tail

