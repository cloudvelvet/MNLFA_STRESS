$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$path = Join-Path $root 'docs\proposal\RSDI_dissertation_proposal_ko_full_v2.md'
$text = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

$text = $text.Replace('(Bauer, Belzak, & Cole, 2019)', '(Bauer, Belzak, & Cole, 2020)')
$text = $text.Replace('(Lee & Choi, 2026)', '(이창현 & 최윤영, 2026)')
$text = $text.Replace(
  '종단 MNLFA는 construct change와 measurement change를 동시에 모형화하는 방향으로 발전했으며, 본 연구의 가장 직접적인 방법론적 anchor이다(Chen & Bauer, 2024). 이 연구는 합산/평균 점수를 반복측정 지표로 사용할 때 측정 항상성을 암묵적으로 가정하게 되어 construct change와 DIF가 혼입될 수 있음을 명시적으로 다루며, "왜 종단 MNLFA가 필요한가"를 뒷받침한다.',
  '종단 MNLFA는 construct change와 measurement change를 동시에 모형화하는 방향으로 발전했으며, 본 연구의 가장 직접적인 방법론적 anchor이다(Chen & Bauer, 2024). 후속 시뮬레이션은 측정기능 변화를 무시한 1차 성장모형의 변화 추정이 편향될 수 있음을 보이고, 종단 MNLFA의 DIF 탐지 성능을 평가하였다(Chen & Bauer, 2026). 두 연구는 종단 MNLFA의 필요성과 성장편향 가능성을 뒷받침하지만, 본 연구에서 제안하는 RSDI나 MAPS 순서형 구현을 검증한 근거는 아니다.'
)

$text = $text.Replace(
  'a_j(Z)    = a_j0 + a_j'' Z          (적재 이동: loading moderation)',
  'a_j(Z)    = exp(ell_j0 + ell_j'' Z)  (양의 적재량을 위한 log-linear moderation)'
)

$identification = @'
### 3.5.4 전체 측정이동과 공변량별 귀속

기본 RSDI는 `Z` 벡터 전체를 `t0`에서 `t1`로 바꾸어 계산한다. 따라서 기본값은 차별경험만의 RSDI가 아니라, 모형에 포함된 연령·한국어 능력·소득·차별경험 변화가 함께 반영된 **전체 측정기능 이동 지표**다. 차별경험의 역할은 다음과 같이 별도로 보고한다.

1. 잠재값과 다른 공변량을 고정하고 차별경험만 0에서 1로 바꾸는 문항별 범주확률 및 기대응답 대비
2. 실제 시점 간 분해에서 차별경험만 교체한 단일공변량 measurement component
3. 여러 공변량의 순서에 따른 귀속 차이가 클 때 공변량별 Shapley 평균

현재 예비 산출물의 W1–W5 RSDI는 전체 `Z` 변화에 대한 item-level RSDI의 문항 평균이다. 차별경험 0/1 고정-잠재 대비는 별도 결과이며 RSDI와 동일한 양으로 부르지 않는다.

### 3.5.5 식별은 검증할 조건이다

posterior draw가 계산되었다는 사실만으로 잠재척도와 측정기능 분해가 식별되었다고 결론내릴 수는 없다. 현재 Stan 구현은 적재량의 부호를 양수로 고정하고 역치 순서를 보장하지만, 기준문항 적재량이나 잠재분산을 고정하지 않았고 모든 문항에 공변량 관련 DIF를 허용한다. 따라서 적재량과 잠재척도의 역비례 변환, 잠재상태 효과와 공통 DIF의 분리에서 약한 식별이 남을 수 있다. 현재 VI 결과는 사전분포에 의해 정규화된 탐색적 추정으로 간주한다.

최종 모형은 다음 조건을 사전에 고정하고 검증한다.

- 기준문항의 적재량과 DIF를 고정하거나, 잠재분산을 고정하는 척도설정 전략
- 최소한 일부 문항 또는 문항모수에 대한 종단·공변량 불변 앵커
- 같은 잠재수준 근방에서 공변량이 변하는 충분한 지지영역과 positivity
- 측정경로와 잠재상태 경로에 같은 공변량이 들어갈 때의 구조적 분리조건
- 문항범주 코딩, 빈 범주, 평행 역치 DIF 가정, hard clipping에 대한 민감도

이 조건은 분석 전에 앵커 대안별 모형 비교와 prior predictive check로 점검한다. 논문 2에서는 약한 앵커, 누락 조절자, `Z–eta` 공선성, 함수형 오설정, 결측·중도탈락을 자료생성 조건으로 조작한다. 논문 3에서는 식별이 확보된 소·중규모 모형의 NUTS posterior를 기준으로 VI 근사오차를 평가한다. 따라서 본 프로포절은 RSDI의 식별을 완결된 정리로 주장하지 않고, 식별조건과 실패영역을 박사학위 연구에서 확립해야 할 대상으로 둔다.
'@
$text = [regex]::Replace(
  $text,
  '(?s)### 3\.5\.4 식별: 정식 명제와 증명.*?(?=\r?\n## 3\.6)',
  $identification.TrimEnd() + "`r`n`r`n",
  1
)

$text = $text.Replace(
  'MAPS 부모 문화적응 스트레스 자료에서 관찰점수 성장모형, 측정불변 순서형 잠재성장모형, 시간가변 DIF를 허용한 종단 MNLFA는 종단 변화에 대해 어떤 해석 차이를 만드는가? 차별경험 관련 측정기능 변화가 관찰된 범주확률 변화에 기여하는 상대적 크기는 RSDI로 어떻게 요약되는가?',
  'MAPS 부모 문화적응 스트레스 자료에서 관찰점수 성장모형, 측정불변 순서형 잠재성장모형, 시간가변 DIF를 허용한 종단 MNLFA는 종단 변화에 대해 어떤 해석 차이를 만드는가? 전체 공변량 관련 측정기능 변화의 상대적 크기는 RSDI로 어떻게 요약되며, 그중 차별경험의 고정-잠재 대비는 문항별 범주확률에서 어떤 방향과 크기를 보이는가?'
)
$text = $text.Replace(
  'posterior draw별 범주확률을 이용한 시점쌍 RSDI 분해',
  'posterior draw별 범주확률을 이용한 전체 `Z` 변화의 시점쌍 RSDI 분해와 별도의 차별경험 0/1 고정-잠재 대비'
)
$text = $text.Replace(
  '| 8문항 RSDI, W1–W5 | 0.360, 90% CrI [0.324, 0.396] | 근사 posterior 기반 예비 분해 |',
  '| 8문항 전체-`Z` RSDI 문항평균, W1–W5 | 0.360, approximate 90% CrI [0.324, 0.396] | 근사 posterior 기반 예비 분해 |'
)
$text = $text.Replace(
  '| Item 1·2·6 제외 RSDI, W1–W5 | 0.260, 90% CrI [0.231, 0.334] | 의미중첩을 줄인 민감도 결과 |',
  '| Item 1·2·6 제외 전체-`Z` RSDI 문항평균, W1–W5 | 0.260, approximate 90% CrI [0.231, 0.334] | 의미중첩을 줄인 민감도 결과 |'
)

$simulation = @'
## 5.2 단계적 설계

자료생성모형은 §3의 graded-response MNLFA를 사용한다. 계산량과 논문 3의 목적을 분리하기 위해 한 번에 144셀을 모두 수행하지 않고 세 단계로 확장한다.

| 단계 | 요인 | 목적 |
|---|---|---|
| 1. 핵심 회복 | `N`(300/600/1200), 웨이브(3/5), DIF 크기(0/중/대), DIF 유형(역치/역치+적재), 공변량 추세(정적/증가) | 기울기·DIF·RSDI의 기본 회복영역 확인 |
| 2. 식별 stress test | DIF 문항비율, 약한 앵커, 누락 조절자, `Z–eta` 공선성, 비선형 moderation | RSDI의 실패영역과 보고중단 기준 도출 |
| 3. 자료복잡성 | 결측·중도탈락, 희소범주, 비평행 역치 DIF, MAPS 유사 공변량 분포 | 실증 적용의 강건성 평가 |

각 단계는 소규모 pilot으로 실행시간과 실패율을 추정한 뒤 반복수를 정한다. 일률적으로 셀당 500회를 고정하지 않고, 편향·coverage·실패율의 Monte Carlo 표준오차가 사전 기준 이하가 되도록 반복수를 결정한다. Paper 2는 estimand와 모형의 통계적 성질에 집중하고, VI와 NUTS의 알고리즘 비교는 Paper 3에서 수행한다.

비교모형은 naive 관찰점수 성장모형, 측정불변 순서형 LGM, 정답구조 MNLFA, 선택적 오설정 MNLFA로 구성한다. true RSDI의 집계 규칙, 분모 임계값, 기본·역순·Shapley 분해는 simulation 실행 전에 고정한다.
'@
$text = [regex]::Replace(
  $text,
  '(?s)## 5\.2 설계 요인.*?(?=\r?\n## 5\.3)',
  $simulation.TrimEnd() + "`r`n`r`n",
  1
)

$text = $text.Replace(
  '분석 자료가 이미 확보되어 있어 자료 접근·IRB 대기 시간이 제거되므로, 프로포절 승인 이후 약 **2년**을 현실적 목표로 상정한다(풀타임 기준).',
  '분석 자료의 접근경로는 확보되어 있으나 IRB 승인 또는 면제 여부와 자료이용 조건은 별도로 확인해야 한다. 이를 초기 단계에 병행한다는 조건에서 프로포절 승인 이후 약 **2년**을 목표로 상정한다(풀타임 기준).'
)
$text = $text.Replace(
  'S0 자료구조 확인(접근 완료)    ███                                            (접근·IRB 제외, 구조 점검만)',
  'S0 자료구조·IRB·이용조건 확인  ███  ░░░                                      (접근경로와 윤리승인을 구분)'
)

$text = $text.Replace(
  'Bauer, D. J., Belzak, W. C. M., & Cole, V. T. (2019). Simplifying the assessment of measurement invariance over multiple background variables: Using regularized moderated nonlinear factor analysis to detect differential item functioning. *Structural Equation Modeling, 27*(1). https://doi.org/10.1080/10705511.2019.1642754',
  'Bauer, D. J., Belzak, W. C. M., & Cole, V. T. (2020). Simplifying the assessment of measurement invariance over multiple background variables: Using regularized moderated nonlinear factor analysis to detect differential item functioning. *Structural Equation Modeling: A Multidisciplinary Journal, 27*(1), 43–55. https://doi.org/10.1080/10705511.2019.1642754'
)
$chen2024 = 'Chen, S. M., & Bauer, D. J. (2024). Modeling construct change over time amidst potential changes in construct measurement: A longitudinal moderated factor analysis approach. *Psychological Methods*. https://doi.org/10.1037/met0000685'
$chen2026 = 'Chen, S. M., & Bauer, D. J. (2026). Improving the evaluation of construct change over time: Advantages of longitudinal moderated nonlinear factor analysis over conventional first-order growth models. *Multivariate Behavioral Research*. Advance online publication. https://doi.org/10.1080/00273171.2026.2640576'
if (-not $text.Contains($chen2026)) {
  $text = $text.Replace($chen2024, $chen2024 + "`r`n`r`n" + $chen2026)
}
$text = $text.Replace(
  'Lee, C., & Choi, Y. (2026). Psychometric validation of the cultural adaptation stress scale for mothers from multicultural families using the graded response model. *Korean Journal of Convergence Science, 15*(2), 379–395.',
  '이창현, & 최윤영. (2026). 등급반응모형(GRM)을 이용한 다문화가정 어머니의 문화적응스트레스 척도 타당도 검증. *한국융합과학회지, 15*(2), 379–395.'
)

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
Write-Output $path

