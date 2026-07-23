$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$path = Join-Path $root 'docs\proposal\RSDI_dissertation_proposal_ko_full_v2.md'
$text = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

$text = $text.Replace('A Bayesian Longitudinal MNLFA Framework for Decomposing Latent Change and Response Shift in Ordinal Panel Data', 'A Bayesian Longitudinal MNLFA Framework for Decomposing Latent Change and Measurement-Function Change in Ordinal Panel Data')
$text = $text.Replace('(Widaman, Ferrer, & Conger, 2010)', '(Widaman et al., 2010)')
$text = $text.Replace('(Bauer, Belzak, & Cole, 2020)', '(Bauer et al., 2020)')
$text = $text.Replace('(Oort, 2005; King-Kallimanis, Oort, & Garst, 2010)', '(Oort, 2005; King-Kallimanis et al., 2010)')

$text = $text.Replace(
  '예비 mean-field VI 결과에서는 차별경험 관련 평행 역치 DIF가 반복 실행에서 안정적으로 관찰되었고, W1–W5의 8문항 RSDI는 0.360, 차별 내용과 직접 맞닿은 문항 1·2·6을 제외한 민감도 모형에서는 0.260으로 추정되었다.',
  '예비 mean-field VI의 네 최적화 실행에서는 차별경험 관련 평행 역치 DIF가 같은 방향의 variational solution으로 나타났다. 모든 모형화된 공변량의 변화가 결합된 W1–W5 RSDI_all-Z 문항평균은 8문항 모형에서 0.360, 차별 내용과 직접 맞닿은 문항 1·2·6을 제외한 민감도 모형에서 0.260으로 추정되었다. 이 값들은 차별경험만의 기여율이 아니다.'
)
$text = $text.Replace(
  'Preliminary mean-field variational inference suggests stable discrimination-related parallel threshold DIF. The preliminary W1–W5 RSDI was 0.360 for the eight-item model and 0.260 after excluding Items 1, 2, and 6, which were most proximal to discrimination content.',
  'Across four mean-field variational optimizations, discrimination-related parallel threshold DIF had the same direction. The preliminary W1–W5 all-covariate RSDI item mean was 0.360 for the eight-item model and 0.260 after excluding Items 1, 2, and 6, which were most proximal to discrimination content. These indices combine changes in all modeled covariates and are not discrimination-specific proportions.'
)

$primary_id = @'
최종 주모형의 **1차 식별전략**은 기준시점의 잠재평균을 0, 잠재분산을 1로 고정하고, 외부 단일시점 검증과 문항내용을 이용해 공변량별로 최소 두 개의 후보 앵커 문항을 분석 전에 지정하는 것이다. 후보 앵커에서는 해당 공변량의 loading-DIF와 threshold-DIF를 0으로 고정한다. 앵커 선택은 종단 결과나 RSDI 크기를 보고 바꾸지 않는다.

공통 DIF를 식별할 외부 앵커가 충분하지 않은 공변량에는 effects-coded 제약을 사용하되, 이 경우 DIF와 RSDI를 “평균 문항 대비 상대적 측정기능 이동”으로 제한해 해석한다. 대체 앵커 세트와 iterative purification은 민감도 분석으로 두고, 앵커를 바꾸었을 때 RSDI의 방향·문항순위 또는 신용구간이 실질적으로 달라지면 해당 RSDI의 실질적 해석을 중단한다.

추가 검증 조건은 다음과 같다.

- 같은 잠재수준 근방에서 공변량이 변하는 충분한 지지영역과 positivity
- 측정경로와 잠재상태 경로에 같은 공변량이 들어갈 때의 구조적 분리조건
- 문항범주 코딩, 빈 범주, 평행 역치 DIF 가정, hard clipping에 대한 민감도
- 기준 앵커, 대체 앵커, effects-coded 모형에서 잠재기울기·DIF 순위·RSDI의 안정성
'@
$text = [regex]::Replace(
  $text,
  '(?s)최종 모형은 다음 조건을 사전에 고정하고 검증한다\..*?(?=\r?\n\r?\n이 조건은 분석 전에)',
  $primary_id.TrimEnd(),
  1
)

$aggregation = @'

문항 `j`와 posterior draw `s`의 표본집계량은 다음과 같이 사전 고정한다.

```text
RSDI_j^(s) = sum_i w_i ||M_ij^(s)||_TV
             / sum_i w_i (||L_ij^(s)||_TV + ||M_ij^(s)||_TV + ||I_ij^(s)||_TV)
```

기본 가중치 `w_i`는 시점쌍에 모두 관찰된 개인의 동일가중치이며, 중도탈락 역확률가중치 결과를 민감도로 보고한다. 척도수준 RSDI_all-Z는 문항별 분자와 분모를 각각 합한 뒤 비율을 계산하는 값을 주 estimand로 하고, 문항별 RSDI의 산술평균은 기존 예비 산출물과의 비교용으로만 제시한다. 분모 임계값과 임계 미달 비율을 함께 보고한다. RSDI는 총변화의 가법적 설명률이 아니라 성분벡터 크기의 상대지표다.
'@
$text = $text.Replace(
  '현재 예비 산출물의 W1–W5 RSDI는 전체 `Z` 변화에 대한 item-level RSDI의 문항 평균이다. 차별경험 0/1 고정-잠재 대비는 별도 결과이며 RSDI와 동일한 양으로 부르지 않는다.',
  '현재 예비 산출물의 W1–W5 RSDI는 전체 `Z` 변화에 대한 item-level RSDI의 문항 평균이다. 차별경험 0/1 고정-잠재 대비는 별도 결과이며 RSDI와 동일한 양으로 부르지 않는다.' + $aggregation
)

$priors = @'

### 3.5.6 사전분포와 DIF 보고 규칙

예비모형은 base log-loading에 `Normal(0, 0.35)`, loading-DIF에 `Normal(0, 0.20)`, 평행 threshold-DIF와 latent-state effect에 `Normal(0, 0.35)`, 평균기울기에 `Normal(0, 0.50)`, 성장 표준편차에 `half-Normal(0, 0.75)`, 성장 상관에 `LKJ(2)`, occasion 표준편차에 `half-Normal(0, 0.50)`을 사용한다. 최종 hyperparameter는 prior predictive check에서 범주확률과 잠재궤적이 비현실적으로 포화되지 않는 범위로 조정하고, 최소 두 개의 prior scale을 민감도 분석한다.

DIF는 단순히 근사구간이 0을 제외하는지로 판정하지 않는다. 문항별 범주확률에서 사전 정의한 실질적 변화량을 초과할 posterior probability, 효과의 문항순위, 앵커·prior·추정법에 대한 방향 안정성을 함께 보고한다. 현재 90% 구간은 “mean-field variational posterior의 5–95% 분위수”로 부르며 실제 posterior coverage를 뜻하지 않는다.
'@
$text = $text.Replace('## 3.6 예상되는 반론: RSDI는 DIF 계수의 재포장인가', $priors.TrimEnd() + "`r`n`r`n## 3.6 예상되는 반론: RSDI는 DIF 계수의 재포장인가")

$text = $text.Replace('90% CrI [0.324, 0.396]', 'mean-field variational 5–95% 분위수 [0.324, 0.396]')
$text = $text.Replace('90% CrI [0.231, 0.334]', 'mean-field variational 5–95% 분위수 [0.231, 0.334]')
$text = $text.Replace('차별경험 관련 평행 역치 DIF는 8개 문항 모두 음의 방향이었고 각 실행의 90% 신용구간이 0을 제외하였다.', '차별경험 관련 평행 역치 DIF의 variational solution은 8개 문항 모두 음의 방향이었고 각 실행의 5–95% 분위수가 0을 제외하였다.')

$paper3 = @'
## 6.2 비교 대상 추정전략

| 전략 | 설명 | 역할 |
|---|---|---|
| **Matched full NUTS** | 동일 자료·동일 모형을 장기 NUTS로 적합 | 소·중규모 셀의 기준 posterior |
| **Matched subset NUTS** | 같은 부분표본에 NUTS와 각 근사법을 모두 적용 | 표본을 고정한 알고리즘 비교 |
| **Mean-field VI (ADVI)** | 평균장 변분추론 | 빠른 스크리닝, 구간 과소 가능성 |
| **Full-rank VI** | posterior 상관을 포함한 변분추론 | 정확도-비용 중간 대안 |
| **Pathfinder** | 다중 준뉴턴 경로 기반 근사 | 초기화 및 저비용 근사 |

기존 measurement-only subset NUTS 결과는 표본과 모형이 모두 달라 full-data structural-state VI의 기준 posterior로 사용하지 않는다. 이는 Paper 1의 제한적 방향 민감도 자료로만 유지한다.

## 6.3 검증 설계 (calibration 프로토콜)

알고리즘 비교에서는 자료와 모형을 반드시 일치시킨다(Blei et al., 2017; Vehtari et al., 2021).

1. **시뮬레이션 기준:** 식별된 동일 DGM과 동일 표본을 mean-field VI, full-rank VI, Pathfinder, 장기 NUTS로 적합한다. 소·중규모 셀의 장기 NUTS를 기준 posterior로 둔다.
2. **MAPS matched-subset 기준:** 동일하게 추출한 부분표본과 동일 structural-state 모형에 각 알고리즘을 모두 적용한다. subset이 달라지는 비교는 알고리즘 오차가 아니라 표본변동으로 분류한다.
3. **대규모 외삽:** full-data VI의 계산성능은 보고하되, matched full-model NUTS가 없으면 posterior 정확도가 교정되었다고 표현하지 않는다. 대신 simulation coverage와 matched-subset 오차를 근거로 사용 범위를 제시한다.
4. **2단계 워크플로:** VI 또는 Pathfinder의 스크리닝 결과를 이용해 사전 규칙에 따라 모형을 선택하고, 선택 이후 불확실성을 장기 NUTS로 재추정한다. 선택 편향을 줄이기 위해 선택규칙을 별도 simulation에서 평가한다.
'@
$text = [regex]::Replace($text, '(?s)## 6\.2 비교 대상 추정전략.*?(?=\r?\n## 6\.4)', $paper3.TrimEnd() + "`r`n`r`n", 1)
$text = $text.Replace('| 진단 | divergence 수, R-hat, ESS, Pareto-k(VI) |', '| 진단 | divergence 수, R-hat, ESS, treedepth, E-BFMI; PSIS를 실제 적용할 때만 Pareto-k |')

$boundary = @'

Paper 2는 고정된 한 가지 추정법을 사용하여 estimand·앵커·공선성·결측 조건의 통계적 성질을 DGM 진값과 비교한다. Paper 3은 Paper 2에서 선정한 6–12개 benchmark regime만 사용하여 동일 posterior target에 대한 알고리즘 오차와 계산비용을 비교한다. 따라서 Paper 2의 질문은 “RSDI가 언제 회복되는가”, Paper 3의 질문은 “어떤 계산법이 같은 posterior functional을 얼마나 재현하는가”로 분리된다.
'@
$text = $text.Replace('## 6.5 핵심 주장', $boundary.TrimEnd() + "`r`n`r`n## 6.5 핵심 주장")

$missing = @'

**결측·중도탈락 계획.** 결과문항 결측은 관측된 응답의 MAR likelihood로 처리한다. 시간가변 공변량 결측은 multilevel multiple imputation 또는 공동 베이지안 모형 중 prior predictive pilot이 안정적인 방식을 주분석으로 사전 지정한다. 중도탈락은 response-probability weighting과 pattern-mixture delta sensitivity로 점검하며, 완전사례 결과는 민감도 분석으로만 유지한다. 모든 연속 공변량은 pooled scale과 개인평균/개인내 편차 분해를 비교하고, response-shift 해석은 주로 within-person 성분에 한정한다.
'@
$text = $text.Replace('## 7.4 실행가능성 선결과제 (Feasibility Prerequisites)', $missing.TrimEnd() + "`r`n`r`n## 7.4 실행가능성 선결과제 (Feasibility Prerequisites)")

$text = $text.Replace('144셀', '단계적 후보 셀')
$text = $text.Replace('정 빠듯하면', '일정이 빠듯하면')
$text = $text.Replace('`§4.3.1`', '`§4.4`')
$text = $text.Replace('§3.5.4 연결', '§3.5.5 연결')

$text = [regex]::Replace($text, '(?m)^Padgett, R\. N\..*\r?\n\r?\n', '')
$text = [regex]::Replace($text, '(?m)^Wallin, G\., & Huang, Q\..*\r?\n\r?\n', '')

$ref_anchor = 'Chen, S. M., & Bauer, D. J. (2026). Improving the evaluation of construct change over time: Advantages of longitudinal moderated nonlinear factor analysis over conventional first-order growth models. *Multivariate Behavioral Research*. Advance online publication. https://doi.org/10.1080/00273171.2026.2640576'
$extra_refs = @'

Blei, D. M., Kucukelbir, A., & McAuliffe, J. D. (2017). Variational inference: A review for statisticians. *Journal of the American Statistical Association, 112*(518), 859–877. https://doi.org/10.1080/01621459.2017.1285773

Vehtari, A., Gelman, A., Simpson, D., Carpenter, B., & Bürkner, P.-C. (2021). Rank-normalization, folding, and localization: An improved R-hat for assessing convergence of MCMC. *Bayesian Analysis, 16*(2), 667–718. https://doi.org/10.1214/20-BA1221
'@
if (-not $text.Contains('Variational inference: A review for statisticians. *Journal')) {
  $text = $text.Replace($ref_anchor, $ref_anchor + $extra_refs)
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
Write-Output $path

