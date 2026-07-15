---
title: "종단 순서형 패널자료에서 잠재변화와 측정기능 변화를 분리하기 위한 Response-Shift Decomposition Index"
subtitle: "종단 MNLFA의 경험적 적용, 통계적 검증 및 계산적 보정"
author: "이창현"
date: "2026년 7월"
lang: ko-KR
---

# 목차

- 국문초록 ··· 3
- Abstract ··· 5
- 제1장 서론 ··· 6
- 제2장 이론적 배경 ··· 11
- 제3장 RSDI 방법론 ··· 14
- 제4장 Paper 1: MAPS 2 경험적 적용 ··· 23
- 제5장 Paper 2: Monte Carlo 검증 ··· 28
- 제6장 Paper 3: posterior 근사추론 calibration ··· 32
- 제7장 통합, 실행계획 및 기대기여 ··· 35
- 제8장 자료·윤리·필수 고지 ··· 42
- 참고문헌 ··· 44

# 국문초록

**예비분석의 해석 범위.** Paper 1에 제시한 수치는 연구 실행 가능성을 점검하기 위한 예비 mean-field 변분추론 결과이다. 반복 VI에서 일부 측정패턴의 방향은 안정적이었으나, 정확한 posterior calibration은 아직 확인되지 않았다. 기존 subset NUTS는 별도의 measurement-only 모형에 대한 결과이므로 현 structural-state 모형이나 RSDI의 근거가 될 수 없다. Paper 2의 Monte Carlo 검증과 Paper 3의 추정전략 비교도 아직 계획 단계에 있다.

RSDI는 검증이 완료된 효과크기가 아니라 종단 순서형 MNLFA posterior에서 계산하는 후보 model-implied estimand로 다룬다. 현재 0.360과 0.260은 occasion residual을 포함한 legacy realized-state conditional 계산치이며, 본 계획의 primary marginal structural-trajectory RSDI는 아직 산출되지 않았다. 차별경험 관련 결과의 해석은 모형과 식별조건에 조건부인 measurement-function change의 연관성으로 제한하며 인과효과로 해석하지 않는다.

종단연구는 관찰된 응답변화를 잠재구성개념의 변화로 해석하는 경우가 많다. 그러나 순서형 문항의 문턱과 요인부하가 시간 또는 시간가변 공변량에 따라 달라지면, 관찰된 변화에는 잠재상태 변화와 측정기능 변화가 동시에 포함된다. 이 둘을 구분하지 않으면 개인이나 집단의 변화에 관한 실질적 결론이 측정모형의 변화와 혼합될 수 있다.

본 학위논문은 종단 순서형 moderated nonlinear factor analysis(MNLFA)가 함의하는 범주확률을 이용하여 Response-Shift Decomposition Index(RSDI)를 정식화하고 평가한다. 네 개의 반사실적 확률벡터는 인과적 개입효과가 아니라 모형 안에서 잠재상태와 측정공변량의 조합을 달리한 대비이다. 이 벡터들로 두 시점의 확률변화를 잠재성분, 측정성분, 비가법적 상호작용성분으로 분해한다. 잠재·측정 성분은 두 확률벡터 사이의 총변동거리(total variation distance)로, 상호작용은 대각 혼합분포와 비대각 혼합분포 사이의 TV인 \(r^*=\tfrac14\lVert\mathbf I\rVert_1\)로 요약한다. TV 요약은 범주 간 등간격을 가정하지 않는 대신 범주의 순서와 이동 방향을 반영하지 않는다. 벡터 분해는 정확한 항등식이지만 성분 크기는 가법적이지 않다. RSDI는 관찰변화 중 측정변화의 백분율, 분산설명률 또는 인과매개 비율이 아니다.

세 편의 연구는 경험적 필요성, 통계적 타당성, 계산적 사용 가능성을 차례로 평가한다. Paper 1은 다문화청소년패널조사 2기(MAPS 2) 부모자료의 문화적응 스트레스 8문항에 종단 순서형 MNLFA와 RSDI를 탐색적으로 적용한다. 현재 파생자료는 2,191개 가구연결 기록, 9,662개 가구연결-시점, 77,296개 문항응답으로 구성된다. 완전사례 주 MNLFA에는 2,190개 가구연결 기록과 77,160개 문항응답을 사용한다.

예비 분석에서 관찰점수 LME 기울기는 -0.0419, 불변 순서형 LGM 기울기는 -0.222로 추정되었다. legacy structural-state MNLFA의 기울기는 네 VI seed에서 -0.260에서 -0.164의 범위에 있었다. 단일 seed의 W1–W5 legacy RSDI_all-Z는 0.360이었고, 문항 1·2·6을 제외한 민감도 분석에서는 0.260이었다. 두 값은 occasion residual 포함, 외부 앵커 부재, loading·threshold hard-clamp, latent-first 경로, 문항별 비율의 산술평균, 분모 cutoff \(10^{-8}\), 단일 VI 실행에 조건부인 탐색치이다. 그러므로 새 primary 정의를 뒷받침하는 근거로 사용하지 않는다.

Paper 2는 진값이 알려진 Monte Carlo 자료에서 RSDI의 식별조건, 편향, RMSE, 구간포괄률과 실패영역을 평가한다. Paper 3에서는 동일 자료·동일 모형·동일 parameterization의 posterior target을 유지한 채 NUTS, mean-field VI, full-rank VI와 Pathfinder를 비교한다. 그 결과를 바탕으로 근사추론을 실제 분석에 사용할 수 있는 사전 지정 calibration gate를 제안한다.

논문의 설명 순서는 Paper 1–2–3이지만, 분석은 식별 명세 확정과 소규모 provisional calibration부터 시작한다. 이후 Monte Carlo 본실험, 6–12개 regime의 confirmatory calibration, Paper 1 확증 재분석을 순서대로 수행한다. Paper 2에서 estimand 또는 식별조건이 바뀌면 식별검증과 provisional calibration 단계로 되돌아간다.

본 연구는 response-shift–true-change 분해나 상호작용항 자체를 최초로 제안하지 않는다(Oort, 2005; Leitgöb et al., 2023). 방법론적 기여는 기존 분해 논리를 시간가변 다중 공변량을 포함한 종단 순서형 MNLFA의 전체 범주확률 벡터로 운용화하는 데 있다. posterior draw별로 불확실성을 전파하고 표본표준화와 TV-compatible 크기 요약을 적용한다. 이어 식별과 회복, 계산 보정 및 보고중단 규칙을 하나의 검증 프로그램 안에서 평가한다. 2026년 7월 13일까지 수행한 범위검색에서는 이 조합의 직접 구현을 확인하지 못했다. 다만 이 검색 결과를 보편적 부재의 증거로 해석하지 않는다.

**주요어:** 종단 측정불변성, MNLFA, response shift, 순서형 자료, 총변동거리, 베이지안 추론, 변분추론, Monte Carlo

# Abstract

Observed change in longitudinal ordinal responses may combine change in the latent construct with change in the measurement function. This dissertation proposes and evaluates the Response-Shift Decomposition Index (RSDI), a candidate posterior functional derived from category probabilities implied by longitudinal ordinal moderated nonlinear factor analysis. Four counterfactual probability vectors yield latent, measurement, and nonadditive interaction components. Latent and measurement magnitudes are total variation (TV) distances; the interaction magnitude is the TV distance between diagonal and off-diagonal probability mixtures, \(r^*=\tfrac14\lVert\mathbf I\rVert_1\). This avoids assuming equal spacing between categories but does not use ordinal adjacency or direction. The vector decomposition is exact, whereas component magnitudes are nonadditive. RSDI is therefore not the percentage of observed change, variance explained, or a causal mediation proportion.

The three papers establish empirical necessity, statistical validity, and computational usability. Paper 1 provides an exploratory application to five waves of MAPS 2 parent-panel acculturative-stress items. Its currently reported RSDI values are legacy realized-state conditional quantities, not the proposed primary marginal structural-trajectory estimand. Paper 2 evaluates identification, recovery, and failure conditions through Monte Carlo simulation. Paper 3 benchmarks NUTS, mean-field and full-rank variational inference, and Pathfinder against the same posterior target and develops a prespecified calibration gate. The proposed contribution is neither a new theory of response shift nor the first response-shift–true-change decomposition. It is an operational extension of prior decomposition logic to posterior category-probability vectors from longitudinal ordinal MNLFA, accompanied by standardization, identification checks, recovery evidence, algorithm calibration, and reporting rules.

# 제1장 서론

## 1.1 연구배경

종단 측정의 핵심 질문은 “관찰된 응답의 변화가 무엇을 의미하는가”이다. 평균점수나 성장모형의 기울기는 변화의 방향과 크기를 간결하게 제시하지만, 그 해석은 동일한 응답범주가 모든 시점과 모든 공변량 수준에서 동일한 잠재상태를 나타낸다는 가정에 의존한다. 이 가정이 성립하지 않으면 관찰된 변화는 적어도 두 과정의 혼합이다. 첫째는 관심 구성개념의 실제 잠재변화이고, 둘째는 응답기준·문항민감도·문턱위치 등 측정기능의 변화이다.

측정불변성 연구는 시점과 집단에 걸쳐 동일한 척도를 사용할 수 있는 조건을 검토해 왔다(Meredith, 1993; Kim & Willson, 2014; Widaman et al., 2010; Wu & Estabrook, 2016). Response-shift 연구는 건강상태나 생애경험 이후 자기평가의 내부기준, 가치 또는 구성개념의 의미가 달라질 가능성을 이론화하였다. 구조방정식모형을 이용한 연구에서는 true change와 measurement-parameter change를 구분하였다(Sprangers & Schwartz, 1999; Oort, 2005; King-Kallimanis et al., 2010; Verdam et al., 2016, 2021). MNLFA는 요인모형의 문턱과 부하를 연속·범주형 공변량의 함수로 표현하여 differential item functioning(DIF)을 모형화한다(Curran et al., 2014; Bauer, 2017; Bauer et al., 2020).

그러나 추정된 DIF 계수만으로는 실제 두 시점 사이에 범주확률이 얼마나, 어떤 경로로 바뀌었는지 직접 알기 어렵다. 같은 DIF 계수라도 공변량 변화량, 잠재변화량, 기준확률에 따라 범주확률에 미치는 영향은 달라지며 비선형 링크에서는 변화경로에 따라 분해가 달라질 수 있다(Fairlie, 2017; Sinning et al., 2008). 본 연구는 종단 순서형 MNLFA의 추정치를 해석 가능한 범주확률 대비로 변환하고 그 통계적·계산적 신뢰성을 함께 평가한다.

## 1.2 문제진술

본 연구가 다루는 문제는 다음과 같다.

1. 종단 순서형 자료에서 잠재상태 변화와 측정기능 변화가 동시에 존재할 때 관찰된 변화를 어떻게 확률공간에서 분리할 것인가?
2. 그 분해를 하나의 요약지표로 제시할 때 순서형 범주의 간격을 가정하지 않으면서도 해석의 한계를 명확히 할 수 있는가?
3. 잠재효과와 공통 DIF가 약하게 식별되는 조건, 앵커 오지정, 공선성, 결측과 희소범주에서 해당 지표가 얼마나 회복되는가?
4. 대규모 종단 MNLFA에서 계산비용을 줄이기 위해 근사추론을 사용할 경우, posterior functional인 RSDI의 오차를 어떻게 보정하고 보고할 것인가?

## 1.3 RSDI의 운용적 정의와 연구공백

종단 순서형 MNLFA가 함의하는 범주확률에서 네 개의 반사실적 벡터를 구성한다. 여기서 반사실적 벡터는 인과적 개입효과가 아니라 추정모형 안에서 잠재상태와 측정공변량의 조합을 바꾼 확률 대비이다. 기준벡터와 비교할 벡터는 두 시점 사이에서 잠재상태만 바꾼 경우, 측정공변량만 바꾼 경우, 둘을 함께 바꾼 경우에 대응한다. 이 대비에 따라 전체 확률변화를 잠재성분, 측정성분, 상호작용성분으로 나누고 각 성분을 범주확률의 signed vector로 정의한다. 잠재·측정 성분은 직접 TV 거리로, 상호작용은 대각·비대각 혼합확률 사이의 TV로 요약한다.

RSDI의 연구공백은 “response shift를 처음 분해한다”는 데 있지 않다. 기존 SEM 연구는 true change와 response shift를 분리하고 이산변수와 효과크기 문제까지 확장해 왔다(Verdam et al., 2016, 2021). 특히 Leitgöb와 Seddig의 response-shift–true-change 분해는 recalibration, pure reprioritization, true change와 loading change의 상호작용을 구분하는 4항 구조로 Leitgöb et al. (2023)에 소개되어 있다. 2×2 유한차분 대수, 잠재·측정·상호작용 분리, 상호작용의 비인과적 성격은 이에 따라 본 연구의 독창성에서 제외한다. MNLFA 연구는 공변량 관련 DIF와 종단 측정을 포괄해 왔고 비선형 분해 연구는 확률분해의 경로의존성을 다루었다.

2026년 7월 13일까지 Google Scholar, Crossref, PubMed, PsycINFO 계열 색인과 출판사 웹에서 제한된 범위검색을 수행하였다. 그 결과, 시간가변 다중 공변량을 포함한 종단 순서형 MNLFA의 전체 범주확률 벡터를 posterior draw별로 분해하고, 표본표준화된 TV-compatible 후보 estimand로 요약하며, 식별·회복·계산 보정·실패 규칙을 하나의 워크플로에서 함께 평가한 선행연구는 확인하지 못했다. 이 bounded-search 결과는 보편적 부재를 증명하지 않는다.

따라서 독창성 주장은 다음 네 항목으로 제한한다.

- 종단 순서형 MNLFA의 posterior predictive category-probability space에서의 운용적 분해
- 잠재·측정·상호작용 성분의 draw별 계산과 불확실성 전파
- 순서형 간격을 가정하지 않는 TV-compatible 요약과 경로·집계·분모 민감도
- 식별 실패, 회복 실패와 근사추론 실패를 구분하는 검증 및 보고중단 규칙

## 1.4 연구목적과 연구질문

학위논문의 총괄 목적은 RSDI를 제안하는 데 그치지 않고, 경험적 필요성·통계적 타당성·계산적 사용 가능성을 순차적으로 평가하는 것이다.

| 연구 | 핵심 질문 | 독립 기여 | 누적 역할 |
|---|---|---|---|
| Paper 1 | 실제 MAPS 종단해석이 측정기능 변화를 고려하면 달라지는가? | 경험적 적용과 문제 입증 | 왜 필요한가 |
| Paper 2 | RSDI는 어떤 식별·자료 조건에서 참값을 회복하는가? | estimand의 성질과 통계적 검증 | 언제 믿을 수 있는가 |
| Paper 3 | 어떤 계산법이 동일 posterior functional을 얼마나 재현하는가? | 추론 calibration과 사용 게이트 | 어떻게 사용할 것인가 |

## 1.5 박사학위 논제와 반증가능성

학위논문의 통합 논제는 다음과 같다.

> “시간가변 측정기능이 존재할 때 종단 순서형 응답변화의 해석은 잠재변화만으로 충분하지 않으며, 범주확률 수준의 분해는 경험적 필요성·통계적 회복성·계산적 calibration이 모두 충족될 때에만 실질적으로 사용할 수 있다”

이 논제는 다음 실패조건에 의해 반증 또는 축소될 수 있다.

| 주장 층위 | 필요한 증거 | 실패 시 결론 |
|---|---|---|
| 경험적 필요성 | 식별·추론 보정 후에도 측정성분이 반복 가능한 실질 차이를 보임 | Paper 1을 영결과 또는 제한적 사례보고로 축소 |
| 통계적 타당성 | 사전 지정 DGM에서 RSDI의 편향·포괄률·분모 안정성이 기준 충족 | RSDI 수정 또는 폐기; 성공 cell만 선택 보고하지 않음 |
| 계산적 사용성 | 근사법이 matched NUTS functional calibration gate 통과 | NUTS 전용 또는 Paper 3를 계산 부록으로 축소 |
| 통합 독창성 | 기존 4항 RSTC 대비 ordinal PMF·MNLFA·posterior 검증체계의 추가 정보 입증 | 독창성 주장을 응용적 운용화로 제한 |

# 제2장 이론적 배경

## 2.1 순서형 종단 측정과 불변성

순서형 요인모형에서는 연속 잠재응답이 문턱을 통과함에 따라 관찰범주가 생성된다고 가정한다(Samejima, 1969; Liu et al., 2017). 문턱이나 부하가 시점·집단·공변량에 따라 달라지면 동일한 잠재상태에서도 응답범주 확률이 달라진다. 이때 순서형 불변성 검정의 결과는 모형의 parameterization, 문턱 제약, 잠재평균·분산과 잔차척도의 고정 방식에 따라 달라질 수 있다. 그러므로 척도 설정을 위한 식별조건과 실질적인 불변성 가정을 구분해야 한다(Wu & Estabrook, 2016).

전통적 단계검정은 명료하지만, 연속 공변량과 다중 조절변수, 부분적 DIF가 동시에 존재할 때 조합이 급증한다. MNLFA는 문턱과 부하를 공변량의 함수로 직접 표현하여 이 문제를 완화한다. 다만 유연성은 식별의 자동 보장을 뜻하지 않는다. 같은 공변량이 잠재상태와 모든 문항의 측정모수에 동시에 들어가면 공통 DIF와 잠재효과가 교환될 수 있다.

## 2.2 Response shift와 measurement-function change

Response shift는 재보정(recalibration), 우선순위 변화(reprioritization), 재개념화(reconceptualization)를 포괄하는 이론적 개념이다(Sprangers & Schwartz, 1999). 통계모형에서 검출한 문턱·부하 변화는 response shift와 정합적일 수 있으나 심리적 메커니즘 자체를 입증하지는 않는다. 이 구분을 유지하기 위해 통계 결과에는 원칙적으로 “measurement-function change” 또는 “response-shift-consistent measurement change”라는 용어를 사용한다.

## 2.3 MNLFA와 종단 확장

MNLFA에서 개인 \(i\), 시점 \(t\), 문항 \(j\)의 잠재상태를 \(\eta_{it}\), 측정공변량을 \(\mathbf z_{it}\)라 하면, 문항부하와 문턱은 다음과 같이 조절될 수 있다.

$$
\lambda_{jit}=\lambda_{j0}+\boldsymbol{\gamma}^{(\lambda)\top}_j\mathbf z_{it},
$$

$$
\tau_{jkit}=\tau_{jk0}+\boldsymbol{\gamma}^{(\tau)\top}_{jk}\mathbf z_{it}.
$$

누적로짓 예에서 범주확률은

$$
\Pr(Y_{ijt}\le k\mid \eta_{it},\mathbf z_{it},\Theta)
=
\operatorname{logit}^{-1}\left(\tau_{jkit}-\lambda_{jit}\eta_{it}\right)
$$

으로 표현된다. 실제 구현은 ordered-logistic 또는 graded-response parameterization을 사용할 수 있으나, 반사실 확률벡터의 정의와 추정모형의 링크가 일치해야 한다. 종단 MNLFA의 최근 확장과 베이지안 정규화는 구성개념 변화와 다중 공변량 DIF를 함께 다루는 근거를 제공한다(Brandt et al., 2025; Chen & Bauer, 2024, 2026).

## 2.4 MAPS 2와 문화적응 스트레스

MAPS 2 부모패널은 다문화가정의 적응과 가족환경을 반복 측정하며, 2기 패널은 2019년부터 2023년까지 5회 본조사를 수행했다(한국청소년정책연구원, n.d.). 문화적응 스트레스는 다차원적인 적응 경험과 스트레스 반응을 측정하는 구성개념이다(Berry, 1997; Sandhu & Asrabadi, 1994). 본 연구는 한국어 능력, 경제상황, 차별경험, 연령과 조사시점이 잠재 스트레스와 응답기준 양쪽에 관련된다는 가설을 경험적으로 검증한다. 해당 두 문헌이 이미 확정한 인과사실로 전제하지 않는다. MAPS 자료는 방법의 보편성을 입증하기 위한 것이 아니라, 복합적인 시간가변 측정기능이 실제 해석에 미치는 영향을 평가하기 위한 경험적 적용 사례로 사용한다.

## 2.5 가장 가까운 선행연구와 기여경계

| 선행 흐름 | 이미 확립된 내용 | 본 연구가 추가로 평가할 내용 |
|---|---|---|
| Oort·Verdam 계열 RSTC | true change와 response shift의 SEM 분리, 이산변수 확장 | ordinal item 전체 PMF에서의 posterior functional |
| Leitgöb와 Seddig의 분해(Leitgöb et al., 2023에 소개) | recalibration·pure reprioritization·interaction·true change의 4항 분해 | threshold+loading이 다중 공변량에 따라 변하는 MNLFA 운용화 |
| Curran·Bauer·Chen 계열 MNLFA | 공변량 관련 DIF와 종단 construct change 모형화 | 네 PMF 대비, 표본표준화, RSDI와 실패영역 |
| Fairlie·Sinning 계열 | 비선형 분해의 경로의존성과 가중치 | 순서형 PMF의 경로·Shapley·분모 민감도 |
| VI·Pathfinder 방법론 | scalable posterior approximation과 진단 필요성 | 동일 posterior target의 RSDI-specific calibration gate |

독창성은 각 열의 대수나 알고리즘을 새로 만들었다는 데 있지 않다. 본 학위논문은 선행연구의 성과를 식별 가능한 estimand, 회복실험, 추론 보정 및 재현 가능한 중단규칙으로 연결한다. 기존 분석에 더해 얻는 정보가 실제로 식별되고 반복적으로 회복되는지는 반증 가능한 가설로 평가한다.

# 제3장 RSDI 방법론

## 3.1 네 확률벡터와 벡터 분해

문항 \(j\), 개인 \(i\), 기준시점 \(a\), 비교시점 \(b\)를 생각한다. \(K_j\)개 범주에 대한 모형함수를 \(\mathbf p_j(\eta,\mathbf z;\Theta)\)라 하고 다음 네 벡터를 정의한다.

$$
\begin{aligned}
\mathbf p_{00,ij}&=\mathbf p_j(\eta_{ia},\mathbf z_{ia};\Theta),\\
\mathbf p_{10,ij}&=\mathbf p_j(\eta_{ib},\mathbf z_{ia};\Theta),\\
\mathbf p_{01,ij}&=\mathbf p_j(\eta_{ia},\mathbf z_{ib};\Theta),\\
\mathbf p_{11,ij}&=\mathbf p_j(\eta_{ib},\mathbf z_{ib};\Theta).
\end{aligned}
$$

잠재성분, 측정성분, 상호작용성분은

$$
\mathbf L_{ij}=\mathbf p_{10,ij}-\mathbf p_{00,ij},
$$

$$
\mathbf M_{ij}=\mathbf p_{01,ij}-\mathbf p_{00,ij},
$$

$$
\mathbf I_{ij}=\mathbf p_{11,ij}-\mathbf p_{10,ij}-\mathbf p_{01,ij}+\mathbf p_{00,ij}
$$

으로 정의한다. 따라서

$$
\mathbf p_{11,ij}-\mathbf p_{00,ij}
=
\mathbf L_{ij}+\mathbf M_{ij}+\mathbf I_{ij}
$$

는 정확한 벡터 항등식이다. \(\mathbf I\)는 잠재상태와 측정함수의 동시 변화가 비선형 링크에서 만드는 비가법성을 포착한다.

## 3.2 TV-compatible 성분 크기와 RSDI

범주확률 벡터 \(\mathbf p\)와 \(\mathbf q\)의 TV 거리는

$$
d_{\mathrm{TV}}(\mathbf p,\mathbf q)
=
\frac{1}{2}\sum_{k=1}^{K_j}|p_k-q_k|
$$

이다. 잠재·측정 성분의 크기는 직접적인 TV 거리로 정의한다.

$$
\ell_{ij}=\frac{1}{2}\lVert\mathbf L_{ij}\rVert_1
=d_{\mathrm{TV}}(\mathbf p_{10,ij},\mathbf p_{00,ij}),
\qquad
m_{ij}=\frac{1}{2}\lVert\mathbf M_{ij}\rVert_1
=d_{\mathrm{TV}}(\mathbf p_{01,ij},\mathbf p_{00,ij}).
$$

상호작용 벡터 \(\mathbf I\)는 그 자체가 두 확률벡터의 차이가 아니다. 기존 예비코드의 \(\tfrac12\lVert\mathbf I\rVert_1\)은 최대 2까지 가능한 half-L1 interaction magnitude이므로 잠재·측정 TV와 같은 범위가 아니다. 주 정의는 다음 TV-compatible 크기로 교정한다.

$$
\begin{aligned}
\mathbf q_{\mathrm{diag},ij}
&=\frac{\mathbf p_{11,ij}+\mathbf p_{00,ij}}{2},\\
\mathbf q_{\mathrm{off},ij}
&=\frac{\mathbf p_{10,ij}+\mathbf p_{01,ij}}{2},\\
r^*_{ij}
&=d_{\mathrm{TV}}(\mathbf q_{\mathrm{diag},ij},\mathbf q_{\mathrm{off},ij})
=\frac14\lVert\mathbf I_{ij}\rVert_1.
\end{aligned}
$$

\(\mathbf q_{\mathrm{diag}}-\mathbf q_{\mathrm{off}}=\mathbf I/2\)이므로 \(0\le r^*\le1\)이다. 문항가중치 \(v_j\ge0\)와 표본가중치 \(w_i\ge0\)를 사용한 척도수준 주 estimand는 posterior draw \(s\)마다 ratio of sums로 계산한다.

$$
N_M^{(s)}
=\sum_j v_j\sum_{i\in\mathcal T}w_i m_{ij}^{(s)},
\qquad
D^{(s)}
=\sum_j v_j\sum_{i\in\mathcal T}w_i
\left(\ell_{ij}^{(s)}+m_{ij}^{(s)}+r_{ij}^{*(s)}\right),
$$

$$
\operatorname{RSDI}^{(s)}_{\mathrm{pooled}}
=
\frac{N_M^{(s)}}{D^{(s)}}.
$$

\(D^{(s)}>0\)이면 \(0\le\operatorname{RSDI}^{(s)}\le1\)이다. 점추정은 posterior draw별 비율의 중앙값으로 보고하며, posterior 평균 성분의 비율로 대체하지 않는다. 문항별 RSDI와 문항별 비율의 산술평균은 보조 분석이다.

중요하게도

$$
d_{\mathrm{TV}}(\mathbf p_{11},\mathbf p_{00})
\ne
\ell+m+r^*
$$

가 일반적이다. 분모는 실제 전체변화 TV가 아니라 세 구성요소 크기의 합이다. RSDI는 관찰변화의 백분율·분산설명률·보편적 효과크기·인과매개 비율이 아니다. TV는 범주 간 등간격을 가정하지 않는 대신 순서 및 이동 방향에 관한 정보를 반영하지 않으므로, 인접범주 이동과 극단범주 이동을 같은 크기로 요약할 수 있다. 기대응답 대비, 누적확률 거리와 signed projection을 함께 보고한다(Steinberg & Thissen, 2006).

## 3.3 주 estimand, 대칭화와 분모 규칙

학위논문의 **주 estimand**는 표본표준화 marginal structural-trajectory pooled RSDI로 고정한다. 개인별 occasion residual은 0으로 두며, 잠재상태에는 성장모형이 함의하는 구조적 궤적을 사용한다. 주 시점쌍은 W1–W5이다. target sample은 두 시점의 결과와 핵심 공변량이 정의된 가구연결 기록으로 사전 고정하고, 기본 분석에서는 동일가중치로 표준화한다. 조사·이탈 가중치를 적용할 때에는 대상 모집단과 가중치 추정의 불확실성을 별도로 기술한다.

주 분석의 분모 규칙은 \(D^{(s)}\ge\varepsilon_0=0.01\)이다. 임계 미달 draw에서는 비율을 계산하지 않고 \(N_M,D\)와 세 성분만 유지한다. draw 유효률을

$$
\pi_D=\frac1S\sum_{s=1}^{S}\mathbb 1\{D^{(s)}\ge\varepsilon_0\}
$$

로 정의한다. v0.1 보고계약에 따라 \(\pi_D\ge0.95\)이면 primary posterior ratio와 구간을 확증적으로 보고하고, \(0.80\le\pi_D<0.95\)이면 조건부 ratio·\(\pi_D\)·성분을 탐색적으로 함께 제시한다. \(\pi_D<0.80\)인 경우에는 ratio를 보고하지 않는다. 조건부 ratio의 draw를 다시 100%로 간주하지 않음으로써 분모 불안정성을 명시적으로 반영한다.

Paper 2의 coverage와 실패율 분모에는 수렴한 모든 반복을 남긴다. \(\pi_D<0.95\)인 반복은 denominator-instability event로 집계하고, \(\varepsilon=0.005\)와 0.02를 민감도 분석에 사용한다. \(\varepsilon_0\)와 \(\pi_D\) 기준은 Paper 2의 null·near-null simulation을 검토한 뒤 MAPS 확증결과를 확인하기 전에 확정한다.

경로의존성 민감도는 interaction을 두 경로에 대칭 배분하는 Shapley형 벡터를 사용한다.

$$
\mathbf L^{\mathrm{Sh}}
=\frac12\{(\mathbf p_{10}-\mathbf p_{00})+(\mathbf p_{11}-\mathbf p_{01})\}
=\mathbf L+\frac12\mathbf I,
$$

$$
\mathbf M^{\mathrm{Sh}}
=\frac12\{(\mathbf p_{01}-\mathbf p_{00})+(\mathbf p_{11}-\mathbf p_{10})\}
=\mathbf M+\frac12\mathbf I.
$$

따라서 \(\mathbf p_{11}-\mathbf p_{00}=\mathbf L^{\mathrm{Sh}}+\mathbf M^{\mathrm{Sh}}\)이다. 대칭화 RSDI는 \(\tfrac12\lVert\mathbf M^{\mathrm{Sh}}\rVert_1\)을 두 Shapley 성분 크기의 합으로 나눈 값이며 주 3항 RSDI의 민감도 분석이다.

그 밖의 민감도 estimand는 다음과 같다.

- realized-state conditional RSDI: 개인별 추정 잠재상태와 occasion residual에 조건부
- leave-one-item-out RSDI: 문항 \(j\)의 확률변화를 계산할 때 해당 문항을 잠재점수 정보에서 제외
- population-marginal RSDI: 잠재분포를 적분하고 외부 또는 조사 가중치로 표준화
- pooled ratio, 문항별 ratio, 문항 ratio 산술평균의 비교
- forward·reverse·Shapley 경로와 누적확률 거리·signed projection의 비교

RSDI_all-Z는 연령, 한국어 능력, 소득과 차별경험을 함께 교체한 **포함 공변량 관련 측정경로 변화**로 부른다. 이 estimand는 차별경험만의 response shift나 인과효과를 나타내지 않는다. 차별경험 0→1 고정 대비는 잠재상태를 고정한 비인과적 measurement-path contrast로 별도 보고한다.

현재 0.360과 0.260은 이 주 정의에 따른 결과가 아니다. occasion residual을 포함한 legacy realized-state conditional이며, 기존 상호작용 half-L1, forward-order, item-ratio 평균에 따라 계산한 값이다.

## 3.4 식별전략

주모형은 같은 공변량이 잠재상태와 문항 측정모수에 동시에 들어가는 구조이므로 식별을 설계의 일부로 다룬다.

| 식별 대상 | 주 제약 | 민감도·검증 | 실패 신호 |
|---|---|---|---|
| 잠재 위치 | 기준시점 구조적 잠재평균 0 | 대안 시점 중심화 | 중심화 변경에 따른 실질결론 반전 |
| 잠재 척도·부호 | 사전 지정한 단일 marker 문항의 기준 loading=1, 양의 방향 | 대안 marker, effects coding | scale/sign switching, 극단 상관 |
| 시점 간 척도 연결 | 복수 내용기반 앵커의 threshold/loading DIF=0 | 대안 앵커집합, leave-one-anchor-out | 앵커 변경에 따른 RSDI·기울기 급변 |
| 잠재분산 | marker loading과 중복하여 1로 고정하지 않고 추정 | 분산 prior 민감도 | 경계값, prior 지배 |
| 공통 DIF와 잠재효과 | 복수 DIF 앵커, 효과의 구조적 제약, simulation recovery | effects coding, 선택적 DIF | 높은 posterior 상관, 낮은 회복률 |
| 문턱 순서 | ordered thresholds | nonparallel DIF 민감도 | 문턱 간격 붕괴, 희소범주 |
| 성장·occasion 분산 | 식별 가능한 random intercept/slope 구조 | 단순화 모형 | funnel, 발산, ESS 저하 |

복수 앵커를 사용한다고 해서 식별이 자동으로 보장되는 것은 아니다. 후보 앵커는 내용 타당성과 경험적 DIF 정보(empirical-DIF)를 함께 고려하여 사전 지정하고, 대안 앵커와 effects coding에서도 결론이 유지되는지 확인한다. 현재 maps_mnlfa_structural_state_anchored_v2.stan은 여러 앵커 loading을 모두 1로 고정한다. 반면 본 계획의 명세는 **복수 DIF 앵커 + 단일 marker loading**이다. 코드와 명세의 정합성은 Gate G1에서 검증하며, 수정과 단위검증을 마치기 전의 예비 NUTS 분석(quick NUTS) 결과는 본문 근거로 사용하지 않는다.

Gate G1은 문서검토가 아니라 실행 가능한 검증 명세로 정의한다.

| 단위검증 | 합격 조건 |
|---|---|
| 확률 생성 | 모든 범주확률이 0 이상, 합이 1이며 Stan과 독립 R 구현이 허용오차 내 일치 |
| 벡터 항등식 | 모든 draw·문항·표본에서 \(\mathbf p_{11}-\mathbf p_{00}=\mathbf L+\mathbf M+\mathbf I\) |
| 영조건 | 측정변화 0이면 \(\mathbf M=\mathbf I=0\); 잠재변화 0이면 \(\mathbf L=\mathbf I=0\) |
| 상호작용 크기 척도화(interaction scaling) | \(r^*=\tfrac14\lVert\mathbf I\rVert_1\)과 mixture-TV가 수치상 일치 |
| 추정대상 유형(estimand mode) | occasion residual=0과 realized conditional이 별도 모드·별도 파일명으로 저장 |
| 집계·경로 | pooled/item-average, forward/reverse/Shapley, cutoff를 metadata와 실행기록(manifest)에 기록 |
| 식별 제약 | 단일 marker loading과 복수 DIF anchor 외의 중복 고정이 없음 |
| 기초 회복 검증(smoke test) | 작은 진값 자료에서 부호·스케일·RSDI가 사전 허용오차 내 회복 |

## 3.5 추론, 진단과 보고중단 규칙

모든 확증 결과에서 RSDI는 posterior draw별로 직접 계산한다. NUTS의 수렴은 \(\widehat R<1.01\)과 bulk/tail ESS로 평가하고(Vehtari et al., 2021), divergence, max-treedepth와 E-BFMI는 CmdStan 진단 기준에 따라 점검한다(Stan Development Team, 2026). VI와 Pathfinder는 ELBO 안정성이나 수렴 플래그만으로 승인하지 않는다. Yao et al. (2018)이 제기한 근사추론 진단의 문제와 Zhang et al. (2022)의 알고리즘 특성을 고려하여, 동일 functional에 대한 matched NUTS 기준 calibration의 승인 규칙을 사전 지정한다.

사전등록용 수치 게이트 v0.1은 다음과 같다. 이 값은 MAPS 확증결과를 보기 전에 Paper 2–3 pilot의 Monte Carlo 오차만으로 한 번 조정할 수 있으며, 조정 이력과 근거를 공개한다(Morris et al., 2019).

| 영역 | 잠정 합격 기준 | 실패 시 조치 |
|---|---|---|
| NUTS | 주 functional·핵심 모수 \(\widehat R<1.01\), bulk/tail ESS≥400, divergence=0, max-treedepth hit=0, E-BFMI≥0.30 | 재매개화·prior 검토 후 재실행; 미해결 시 확증 중단 |
| RSDI 분모 | primary \(D^{(s)}\ge0.01\)인 draw 비율 \(\pi_D\ge0.95\); 0.005·0.02 민감도에서 결론 유지 | 0.80–0.95는 탐색적 조건부 보고, 0.80 미만은 비율 생략 |
| 근사추론 | 표준화 평균오차≤0.10, SD 비율 0.80–1.25, \(|\Delta\mathrm{RSDI}|\le0.02\), 문항순위 \(\rho\ge0.90\), PPC 체계적 열화 없음 | 해당 알고리즘 거부 |
| Paper 2 회복 | RSDI 절대편향≤0.02, RMSE≤0.05, 95% interval coverage 0.90–0.98, 수치실패≤5% | estimand·식별조건 수정 또는 사용영역 축소 |
| Monte Carlo 정밀도 | coverage·실패율 MCSE≤0.01, bias MCSE≤허용편향의 10% | 반복 batch 추가 |

다음 조건에서는 RSDI 확증 해석을 중단한다.

1. 앵커 변경 또는 effects coding에서 핵심 결론의 방향이 반전됨
2. latent impact와 공통 DIF의 회복률이 사전 기준을 충족하지 못함
3. 주 estimand 분모가 사전 임계값 아래여서 비율이 불안정함
4. posterior predictive check가 문항별 범주분포·시점변화·개인내 연관을 재현하지 못함
5. NUTS 기준 진단이 실패하거나, 근사법이 calibration gate를 통과하지 못한 상태에서 계산상 실행 가능한 보정 기준 통과 대안(calibrated 대안) 또는 NUTS가 없음. 근사법만 실패하고 NUTS가 통과하면 해당 근사법만 거부하고 NUTS로 계속함
6. 동일한 데이터·모형·parameterization 비교가 보장되지 않음


# 제4장 Paper 1: MAPS 2 경험적 적용

## 4.1 목적과 연구질문

Paper 1은 실제 자료에서 시간가변 측정기능을 고려하는 것이 종단해석에 실질적 차이를 만드는지 평가한다.

- RQ1. 관찰점수 LME, 불변 순서형 LGM과 종단 MNLFA의 변화 방향은 일관적인가?
- RQ2. 문화적응 스트레스 문항의 문턱과 부하는 시간가변 공변량에 따라 달라지는가?
- RQ3. W1–W5 범주확률 변화에서 잠재·측정·상호작용 성분의 크기는 얼마인가?
- RQ4. 결과는 앵커, 경로순서, 문항집합, 집계방식, 잠재상태 정의와 결측처리에 얼마나 민감한가?

## 4.2 자료와 변수

분석자료는 MAPS 2기 부모 파일 1–5차(2019–2023)이며, 문화적응 스트레스는 5범주 8문항으로 측정된다. 파생자료에는 2,191개 가구연결 기록, 9,662개 가구연결-시점, 77,296개 문항응답이 포함된다. 완전사례 주 MNLFA는 2,190개 가구연결 기록과 77,160개 응답을 사용한다. W1과 W5가 모두 관찰된 RSDI 표본은 1,743개이고, 모든 시점이 관찰된 기록은 1,702개이다. 파동별 관찰 기록은 W1 2,186에서 W5 1,750으로 감소한다.

원자료 식별자는 부모 개인 PID가 아니라 가구 ID이므로 “동일 부모 2,191명”이 아니라 “2,191개 가구연결 기록”으로 기술한다. 공변량은 연령, 한국어 능력, 로그소득과 차별경험이며, 차별경험은 9,662개 시점 중 1,308개(13.5%)이다. 회상기간이 시점별로 동일한지, 가구 내 응답자가 교체되었는지, 조사 가중치가 어떤 대상모집단을 대표하는지는 추가 확인한다.

## 4.3 분석계획

1. 기술통계와 범주분포, 이탈패턴, 공변량의 개인내·개인간 변동을 점검한다.
2. 관찰점수 LME와 불변 순서형 LGM을 비교기준으로 적합한다.
3. 복수 DIF 앵커와 단일 marker를 사용하는 structural-state longitudinal MNLFA를 재구현한다.
4. prior predictive check, 장기 NUTS pilot과 posterior predictive check를 수행한다.
5. 사전 지정 calibration gate를 통과한 추정법으로 전체자료를 적합한다.
6. 주 estimand와 사전 지정 민감도 RSDI를 posterior draw별 계산한다.
7. 앵커, 문항 1·2·6 제외, 역순/Shapley, leave-one-item-out, 가중치와 결측 민감도를 평가한다.
8. 결과문항 결측은 관측자료 likelihood로 처리하고, 시간가변 공변량 결측은 multilevel multiple imputation 또는 공동모형 중 prior predictive pilot에서 안정성이 확인된 방법을 사전 지정한다.
9. 중도탈락은 response-probability weighting과 pattern-mixture delta sensitivity로 점검하며, 완전사례 결과는 민감도로만 유지한다.

## 4.4 현재 예비결과

| 분석 | 예비치 | 허용되는 해석 |
|---|---:|---|
| 관찰점수 LME | 기울기 -0.0419 | 평균범주 척도의 감소 방향 |
| 불변 순서형 LGM | -0.222, VI 5–95% [-0.239, -0.205] | 불변 측정모형의 근사 잠재감소 |
| legacy structural-state MNLFA | 네 seed 평균 약 -0.210, 범위 [-0.260, -0.164] | VI seed별 점추정 감소 방향 |
| W1–W5 legacy realized-state RSDI_all-Z | 0.360, 단일 VI 5–95% [0.324, 0.396] | 기존 half-L1 interaction·forward·item-average 탐색량 |
| 문항 1·2·6 제외 legacy RSDI | 0.260, 단일 VI 5–95% [0.231, 0.334] | 동일 legacy 조건의 의미중첩 완화 민감도 |

W1–W5 문항평균은 잠재 TV 0.133, 측정 TV 0.096, 기존 상호작용 half-L1 magnitude 0.037, 실제 전체변화 TV 0.157이다. 상호작용 0.037은 본 계획의 \(r^*\)가 아니라 기존 \(\tfrac12\lVert\mathbf I\rVert_1\)이며, 같은 범위의 TV로 부르지 않는다. 이 값에서 확인할 수 있는 범위는 벡터 분해 후 성분 크기가 비가법적이라는 점에 한정된다. 0.360을 “관찰변화의 36%가 측정변화”라고 해석하지 않는다.

현재 0.360과 0.260은 seed 20260702의 mean-field VI로 계산한 realized-state conditional legacy RSDI이다. 이 계산에는 occasion residual이 포함된다. 측정모수에는 log-loading [-1.5, 1.5]와 threshold shift [-3, 3]의 hard-clamp를 적용하였다. W1–W5 공통 관찰자를 동일가중하고 forward-order 분해에서 문항별 ratio를 산술평균했으며, 분모 cutoff는 \(10^{-8}\)이었다. optimizer uncertainty, 가중치 불확실성, 경로·집계 선택의 불확실성은 포함하지 않는다.

legacy 모형은 외부 앵커 없이 모든 문항의 DIF를 허용하므로 공통 DIF와 잠재효과가 약하게 식별될 수 있다. 일부 loading predictor는 hard-clamp 경계에 포화되었다. 과거 subset NUTS는 별도의 measurement-only 모형에 대한 결과이므로 현재 structural-state 기울기와 RSDI의 확증 근거가 아니다.

현재의 예비 NUTS 분석(quick NUTS) 역시 확증에 사용할 수 없다. 이 분석은 \(N=80\), 2 chains, chain당 warmup 100·sampling 100으로 실행되었다. 최대 \(\widehat R=1.283\), \(\widehat R>1.01\)인 모수 1,875개, 최소 bulk ESS 6.46으로 나타났다.

| 증거 층위 | 상태 | 프로포절에서 허용되는 주장 |
|---|---|---|
| 표본·결측·파동별 집계 | 원자료 재계산 완료 | 기술통계 |
| LME·불변 LGM | 실행 완료, VI 한계 존재 | 방향 비교 |
| 반복 legacy VI | 4 seed 실행, 분산모수 불안정 | 기울기 부호와 큰 threshold-DIF의 탐색적 안정성 |
| legacy RSDI | 단일 seed·단일 경로 | 실행가능성 수치만 |
| 현 primary RSDI | 미산출 | 결과 주장 금지 |
| 식별수정 matched NUTS | 미완료 | 확증 주장 금지 |

## 4.5 Paper 1 성공기준

Paper 1의 확증 결론은 다음을 모두 만족할 때만 제시한다.

- Gate G1 코드-명세 정합과 식별 unit test 통과
- 장기 NUTS 또는 calibration된 대안 추론의 진단 통과
- 주 PPC와 앵커 민감도 통과
- RSDI 주 estimand의 분모 안정성 확보
- 결측·이탈 및 가중치 처리에 대한 영향 평가
- exploratory 수치와 confirmatory 결과의 명시적 분리

Paper 1의 **연구 성공**은 비영 측정성분의 발견을 전제로 하지 않는다. 위 품질 기준을 통과한 영결과도 측정기능 변화의 상한을 제시하는 유효한 결과이다.

다만 통합논제에서 “측정기능을 고려하면 경험적 해석이 실질적으로 달라진다”고 주장하려면 MAPS 결과를 확인하기 전에 최소 관심효과크기(smallest effect size of interest; SESOI)를 동결하고 관련 조건을 충족해야 한다. 조건은 (a) \(\Pr(\mathrm{RSDI}\ge0.10\mid y)\ge0.95\), (b) 모의실험에서 보정한 최소회복크기(simulation-calibrated 최소회복크기)를 넘는 측정성분, (c) 불변모형 대비 변화방향·문항순위·정책적 분류 중 적어도 하나의 사전 지정 실질적 결론 변화(substantive conclusion 변화)이다. 세 조건 가운데 최소 두 조건을 만족해야 한다. 앵커·결측·가중치·경로 민감도에서도 방향 또는 순위가 유지되어야 한다. 충족하지 못하면 Paper 1은 정당한 영결과 또는 도메인 한정 결과로 결론낸다. 0.10 기준은 v0.1이며 Paper 2의 영에 가까운 조건에 대한 pilot 해상도를 근거로 MAPS 분석 전에 한 번만 조정할 수 있다.

# 제5장 Paper 2: Monte Carlo 검증

## 5.1 목적과 연구질문

Paper 2의 질문은 “RSDI가 언제 회복되는가”이다. 하나의 사전 지정 추정법을 고정하여 DGM 진값 대비 estimand, 앵커, 공선성, 결측과 모형오지정의 통계적 성질을 평가한다. Paper 3와 달리 알고리즘 간 경쟁이 목적이 아니다.

## 5.2 자료생성모형과 단계별 설계

자료는 graded-response structural-state MNLFA에서 생성한다. 기본 자료생성모형은 \(J=8\) 문항, \(T=3\) 또는 5 시점, random intercept와 slope, 시간가변 공변량, 문턱·부하 DIF를 포함한다. 설계·estimand·방법·성과지표는 ADEMP 원칙에 따라 사전 등록한다(Morris et al., 2019). 현재 sim_recovery.R에는 단일 \(N=500,T=3\) 조건의 기초 작동 점검(sanity check)만 구현되어 있다. 아래의 72개 조건 실행기(72-cell runner)와 반복·실패 로깅은 아직 구현되지 않았다.

각 반복의 주 진값은 해당 반복에서 생성한 공변량 궤적과 target-sample 가중치에 표준화한 **finite-sample marginal structural-trajectory pooled RSDI**이다. Paper 1과 마찬가지로 occasion residual=0, W1–W5 대비(\(T=3\)에서는 첫–마지막 시점), \(r^*=\tfrac14\lVert\mathbf I\rVert_1\), pooled ratio, 동일 문항·표본 가중치, \(\varepsilon_0\)와 \(\pi_D\) 규칙을 적용한다. 매우 큰 독립 Monte Carlo 표본에 적분한 superpopulation-marginal truth는 보조 결과로 분리한다. 이와 같이 Paper 2의 회복성은 편의적으로 정의한 별도의 truth가 아니라 Paper 1과 동일한 target functional에 대해 평가한다.

### Stage 1: 핵심 회복성

핵심 요인은 표본크기 \(N=300,600,1200\), 시점 \(T=3,5\), DIF 크기 0·중간·큰 수준, DIF 유형 threshold-only와 threshold+loading, 공변량 추세 정적·증가이다. 완전요인 설계는 \(3\times2\times3\times2\times2=72\)개 조건(cell)이다.

### Stage 2: 식별 취약성 검증(stress test)

Stage 1에서 선정한 대표 조건(cell)에 DIF 문항 비율, 약한 앵커, 앵커 오지정, 누락 조절변수, \(\mathbf Z\)–\(\eta\) 공선성, 비선형 조절을 추가한다. marker는 척도를 정할 뿐 공통 DIF와 latent impact 분리를 자동 보장하지 않는다는 점을 직접 평가한다.

### Stage 3: 현실적 복잡성

패널이탈과 간헐결측, 희소범주, 비평행 threshold-DIF, MAPS 유사 공변량 분포, 문항 중복과 경계분모 조건을 평가한다. 모든 요인을 완전교차하지 않고 Stage 1–2 결과에서 실패 가능성이 높은 조합을 사전 규칙으로 선택한다.

## 5.3 비교모형과 요약량

비교모형은 관찰점수 성장모형, 불변 순서형 LGM, 자료생성모형과 일치하는 MNLFA와 선택적으로 오지정된 MNLFA이다. RSDI의 추가정보를 검증하기 위해 DIF 계수, 기대점수 차이, 실제 전체변화 TV, 누적확률 거리와 signed projection을 함께 비교한다.

필수 경계 사례(edge case)는 영 측정변화, 영 잠재변화, 영 상호작용, 분모 0 근방, 잠재·측정 성분의 상쇄, 동일 DIF 계수이나 서로 다른 \(\Delta Z\)·\(\Delta\eta\), 동일 관찰점수 변화이나 서로 다른 성분구성이다.

## 5.4 평가기준

- 성장·잠재효과: bias, relative bias, RMSE, interval coverage
- DIF: bias, RMSE, false-positive rate, power
- RSDI: bias, RMSE, coverage, 분모불안정률, 순위보존
- 모형진단: 수렴실패, 경계추정, PPC 실패, 식별경고
- Monte Carlo 오차: bias·coverage·실패율의 MCSE

반복수는 pilot 분산과 목표 MCSE에 따라 정하되, 최소 500회와 최대 2,000회, 100회 batch를 기본 규칙으로 둔다. 예를 들어 명목 95% coverage의 MCSE를 0.01 이하로 제한하려면 \(R\ge .95(.05)/.01^2=475\)이므로 최소 500회가 필요하다. bias MCSE가 허용편향 0.02의 10%인 0.002를 넘으면 batch를 추가한다. 적합에 실패한 반복은 원인별로 분류한다. 동일 seed를 단순 재시도하지 않고 사전 지정한 초기화·iteration 확대 규칙을 1회 적용한다. 재시도 후에도 실패한 반복은 분모에서 제외하지 않으며 실패율에 포함한다.

## 5.5 계산예산과 축소규칙

| 항목 | Pilot에서 확정할 값 | 사전 원칙 |
|---|---|---|
| 조건 수(cell 수) | Stage 1은 72, Stage 2–3은 선정규칙 적용 | 모든 확장을 완전교차하지 않음 |
| 셀당 반복수 | 목표 MCSE 기반 최소–최대 범위 | batch별 MCSE 확인 |
| 적합당 시간·메모리 | N/T/추정법별 중앙값·상위 90% | 이상치와 실패 분리 |
| 총 core-hours | pilot runtime으로 산출 | 20% 재시도 여유 포함 |
| 저장공간 | draw 보존수준별 산출 | 핵심 draw와 진단을 분리 보존 |
| 실패처리 | 원인코드·재시도 1회·최종 실패 | 실패율 자체를 결과로 보고 |

예산을 초과하면 먼저 비핵심 고차상호작용을 제거하고, 다음으로 Stage 3의 우선순위가 낮은 현실적 조건을 축소한다. 표본크기, 시점 수, DIF 크기, 앵커오지정과 분모경계 조건은 핵심요인으로 유지한다. 정확한 core-hours와 저장공간은 calibration pilot 완료 후 프로포절 부록에 갱신한다.

## 5.6 Paper 2 성공기준

RSDI를 실질적으로 사용할 수 있는 estimand로 주장하려면 §3.5의 v0.1 기준을 주 식별조건에서 충족해야 한다. 기준은 절대편향≤0.02, RMSE≤0.05, 95% interval coverage 0.90–0.98, 수치실패≤5%이며, 실패영역도 재현 가능하게 탐지되어야 한다. 기준은 pilot MCSE 또는 코드 오류를 근거로만 변경할 수 있고 MAPS 결과에 맞추어 바꾸지 않는다. 회복에 실패하면 지표를 폐기하거나 estimand·식별조건을 수정한다. 실패한 조건(cell)을 제외한 채 성공한 결과만 보고하지 않는다.


# 제6장 Paper 3: posterior 근사추론 calibration

## 6.1 목적과 연구질문

Paper 3의 질문은 “어떤 계산법이 같은 posterior functional을 얼마나 재현하는가”이다. DGM 진값 회복을 주목적으로 하는 Paper 2와 달리, 동일 자료·동일 모형·동일 parameterization에서 잘 진단된 NUTS posterior를 기준으로 알고리즘 근사오차와 계산비용을 분리한다.

## 6.2 비교설계

Paper 2의 6–12개 benchmark 분석 조건(regime)은 다음 기준으로 선택한다.

- 작은·중간·큰 표본과 짧은·긴 시점의 대표 조합
- RSDI가 0 근방, 중간, 큰 조건
- 약한 식별과 강한 식별 조건
- 희소범주 또는 결측이 있는 현실적 조건
- MAPS와 유사한 경험적 조건

각 분석 조건에는 동일한 생성자료, likelihood, prior, 식별제약과 posterior functional을 적용한다. 장기 NUTS, mean-field ADVI, full-rank ADVI와 Pathfinder를 비교한다(Blei et al., 2017; Kucukelbir et al., 2017; Zhang et al., 2022). 작은·중간 조건에서는 전체자료 matched NUTS를 사용한다. 큰 조건은 full-data NUTS가 진단기준을 통과한 경우에만 posterior-accuracy gate에 포함한다.

full-data reference를 구할 수 없는 조건은 별도의 확장성 평가층(scalability-only stratum)으로 옮긴다. 이 층에서는 runtime·memory·수치실패·PPC만 평가하며, subset NUTS·PSIS·simulation-based calibration은 문제진단에만 사용한다(Yao et al., 2018). subset 결과를 전체자료의 정답으로 간주하거나 full-data 근사법의 승인에 사용하지 않는다. 현재 matched benchmark는 한 건도 완료되지 않았고 기존 measurement-only subset NUTS는 benchmark에서 제외한다.

## 6.3 평가기준

- 표준화 posterior mean difference와 rank correlation
- posterior SD 비율과 구간포괄/중첩
- 문항별·통합 RSDI 오차와 순위보존
- tail·multimodality·posterior correlation 재현
- PPC와 pointwise log-likelihood 차이
- wall-clock time, peak memory, 실패율과 재실행 변동

## 6.4 2단계 calibration gate

**1단계 적격성 심사(eligibility screen)**에서는 동일 자료·likelihood·prior·parameterization·functional, 잘 진단된 full-data matched NUTS, 충분한 유효 draw와 재현 가능한 seed를 요구한다. 이 기준을 충족한 분석 조건만 posterior 정확도 평가(posterior-accuracy 승인)에 사용한다. **2단계 정확도–효용성 기준(accuracy–utility gate)**은 다음 조건을 모두 적용한다.

1. 핵심 구조모수의 표준화 평균오차≤0.10, RSDI 절대오차≤0.02
2. posterior SD 비율이 matched NUTS 대비 0.80–1.25
3. 문항 RSDI 순위의 Spearman \(\rho\ge0.90\)
4. PPC와 pointwise log-likelihood에서 방향성 있는 체계적 열화가 없음
5. 여러 seed에서 수치실패율≤5%이며 실질적 결론(substantive conclusion)이 동일

G2의 3–4개 작은·중간 분석 조건(regime)은 Paper 2의 주 추정법을 선택하기 위한 **잠정 추정법 선정 기준(provisional method-selection gate)**이다. Paper 2가 estimand·식별조건을 동결한 뒤, G5에서 6–12개 분석 조건의 **confirmatory generalization benchmark**를 다시 수행한다. Paper 1 전체자료에는 이 최종 기준을 통과한 방법만 사용한다.

Paper 2에서 estimand, 식별제약 또는 parameterization이 바뀌면 G1과 G2로 회귀하여 두 게이트를 재실행한다. 근사법이 실패하더라도 진단된 NUTS를 실행할 수 있으면 NUTS로 진행하고 해당 근사법만 거부한다. G5가 G4에서 사용한 근사법을 사후 거부하면 영향받은 Paper 2 조건을 NUTS 또는 G5에서 승인된 대안으로 재실행한다. 재실행할 수 없는 조건은 식별·통계 회복 실패가 아니라 알고리즘 실패로 재분류한다. 해당 조건에 근거한 bias·coverage·회복영역 주장도 철회한다.

단순 속도비교만으로는 독립 논문 기여가 부족하다. 따라서 Paper 3의 산출물은 “어떤 자료·진단 조건에서 어떤 추정법을 승인·거부할 것인지”에 관한 재현 가능한 2단계 의사결정 규칙이다.

## 6.5 Paper 3 실패 시 사전 Plan B

G5에서 독립적인 calibration 규칙을 확립하지 못하면 계산비교는 Paper 2의 부록으로 축소한다. 이 경우 세 번째 논문은 **동결된 RSDI의 응답자·구성개념 간 전이 가능성 연구**로 전환한다. 1순위 후보는 접근 가능한 MAPS 2 청소년 자기보고 파일의 반복 순서형 척도이다. 2027년 2분기까지 자료사전에서 4개 이상 시점, 5개 이상 공통 순서형 문항, 분석가능 표본 1,000 이상, 동일 응답자 연결키와 2차분석 허용을 확인해야 한다. 이 access/data gate를 통과하지 못하면 Plan B를 실행한 것으로 간주하지 않으며, 학위위원회의 승인을 받아 세 번째 논문의 범위를 다시 정한다.

Plan B의 RQ는 “Paper 2에서 동결한 RSDI 정의·식별·보고규칙이 다른 응답자와 구성개념에서도 재추정 없이 운용 가능한가”이다. Paper 2에서 동결한 코드·prior·\(r^*\)·분모규칙·민감도 순서를 그대로 적용하고, 새 자료를 확인한 뒤 threshold나 gate를 조정하지 않는다.

성공기준은 G1 통과, \(\pi_D\ge0.95\), 진단된 추론, 앵커·결측 민감도에서의 핵심 결론 유지이다. MAPS 부모자료와의 공통점과 차이는 사전 지정한 transportability 표로 보고한다. 이 연구는 두 도메인의 효과크기가 같다고 주장하는 복제가 아니다. RSDI 워크플로가 외적 상황에서도 운용되는 조건과 실패원인을 평가하는 독립 논문이다.

# 제7장 통합, 실행계획 및 기대기여

## 7.1 세 논문의 통합논리

세 연구는 동일한 방법을 반복 적용하지 않고 하나의 해석 주장을 성립시키는 데 필요한 서로 다른 조건을 평가한다. Paper 1의 경험적 결과는 Paper 2에서 확인한 식별·회복 범위와 Paper 3에서 승인한 추론법을 전제로 해석한다. Paper 2는 진값이 알려진 자료에서 RSDI의 식별조건과 실패영역을 규정하고, Paper 3은 같은 posterior target을 대규모 자료에서 근사할 때 생기는 알고리즘 오차와 계산비용을 평가한다. 세 논문의 결론은 이처럼 순차적으로 제약된다.

| 구분 | Paper 1 | Paper 2 | Paper 3 |
|---|---|---|---|
| 고정하는 것 | 실제 MAPS 자료 | DGM 진값과 주 추정법 | 자료·모형·parameterization |
| 변화시키는 것 | 모형·앵커·estimand 민감도 | N·T·DIF·앵커·결측·오지정 | 추론 알고리즘 |
| 기준 정답 | 없음; 강건성·진단 | 알려진 DGM truth | 잘 진단된 matched NUTS posterior |
| 주 산출물 | 실증적 해석 차이 | 회복영역·실패지도 | 승인·거부 calibration 규칙 |
| 독립 실패조건 | 측정성분이 재현되지 않음 | 식별·회복 기준 실패 | 근사법이 NUTS를 재현하지 못함 |

서술 순서는 Paper 1→2→3이지만 실행 순서는 다음과 같다.

1. G1: 식별명세와 Stan 코드 정합, 단위검증
2. G2: 3–4개 regime의 provisional matched NUTS calibration
3. G3: Paper 2 pilot, MCSE와 계산예산 확정
4. G4: Paper 2 본실험과 estimand/failure rule 확정
5. G4R: estimand·식별·parameterization 변경 시 G1–G2 rollback 및 재승인
6. G5: Paper 3의 6–12개 regime confirmatory generalization benchmark
7. G6: 승인된 추정법을 사용한 Paper 1 확증 전체자료 재분석
8. G7: 세 논문 통합, 재현성 패키지와 최종 논문 작성

## 7.2 기대기여

이론적 기여는 response shift라는 심리적 설명과 통계적 measurement-function change를 명시적으로 구분하는 데 있다. 방법론적으로는 기존 RSTC 분해를 ordinal MNLFA posterior의 전체 범주확률 벡터와 표본표준화 TV-compatible 후보 estimand로 운용화한다. 식별 실패와 통계적 회복 실패, 알고리즘 근사 실패를 서로 다른 검증 단계에서 평가함으로써 실패의 원인을 구분한다. 종단 순서형 척도의 변화해석에 필요한 최소 보고항목과 중단기준도 제시한다.

| 핵심 위험 | 조기 신호 | 완화 | 잔여 의사결정 |
|---|---|---|---|
| 공통 DIF–latent impact 비식별 | 높은 posterior 상관, 앵커 민감도 | single marker·복수 DIF anchor·effects coding | 실패 시 상대-DIF estimand로 축소 |
| denominator instability | \(D<0.01\) draw 다수 | 성분보고·epsilon 민감도·near-null simulation | 비율 보고 중단 |
| VI 과소분산 | SD ratio<0.80, RSDI 오차>0.02 | matched NUTS·PSIS/VSBC·다중 seed | 진단된 NUTS가 가능하면 NUTS 전용; 불가능하면 확증 보류 |
| 패널이탈·응답자 교체 | wave별 구성 변화, 가중치 민감도 | IPW·MI·pattern-mixture·가구ID 한계 공개 | 개인수준 인과해석 금지 |
| Paper 3 독립성 부족 | 속도표 외 추가 규칙 없음 | 승인·거부 gate와 실패지도 | 계산비교는 Paper 2 부록으로 통합하고 §6.5 Plan B access gate 적용 |

RSDI의 수학적 정의는 특정 도메인에 의존하지 않는다. 그러나 본 학위논문이 평가하는 일반화 범위는 사전 지정한 DGM이 포괄하는 모형 수준의 전이 가능성에 한정된다. 다른 구성개념과 모집단에 대한 경험적 일반화는 후속 연구과제이다.

## 7.3 일정과 마일스톤

| 기간 | 핵심 작업 | 완료 게이트 |
|---|---|---|
| 2026년 3분기 | 식별명세, 코드 정합, prior predictive unit test | G1 |
| 2026년 4분기 | 소규모 matched NUTS–VI–Pathfinder calibration | G2 |
| 2027년 1분기 | Paper 2 pilot, 반복수·계산예산 확정 | G3 |
| 2027년 2–3분기 | Paper 2 본실험, 결과·실패영역 정리 | G4 |
| 2027년 4분기 | Paper 3 confirmatory benchmark와 의사결정 규칙 | G5 |
| 2028년 1분기 | Paper 1 확증 재분석, 결측·가중치 민감도 | G6 |
| 2028년 2분기 | 통합논의, 재현성 패키지, 예비심사 수정 | G7 |

일정은 프로포절 승인일과 연산자원 배정에 따라 갱신한다. 각 게이트가 실패하면 후속 단계로 자동 진행하지 않고 모형 단순화, estimand 수정 또는 Paper 3 Plan B를 적용한다.

## 7.4 재현성 계획

분석은 R, cmdstanr와 CmdStan으로 수행한다. 최종 저장소에는 비식별화한 합성 예제자료, 자료사전, 전처리 checksum, seed, 실행 명령, 모형 파일, 패키지 lockfile 또는 완전한 sessionInfo(), OS·컴파일러 정보, 결과 실행기록과 표·그림 생성 스크립트를 포함한다. 원자료와 개인 수준 파생자료는 저장소에 포함하지 않는다. 각 결과표에서 해당 원출력 파일과 생성 스크립트를 추적할 수 있도록 한다.

## 7.5 한계

자료 측면에서 MAPS 식별자는 개인 PID가 아니라 가구 ID이므로 동일 응답자를 추적한다는 가정에 한계가 있다. 패널이탈과 결측, 공식 가중치 미적용도 현재 예비결과를 편향시킬 수 있다.

측정모형 측면에서는 8문항 단일요인 모형과 공통 DIF 함수가 실제 측정구조를 충분히 포착하지 못할 가능성이 있다. RSDI 자체도 추정모형, 앵커, 경로순서, 대상 표본, 상호작용 크기 척도화와 집계방식에 조건부이다. TV 요약은 방향과 ordinal adjacency를 축약하므로 인접범주 이동과 극단범주 이동을 동일하게 평가할 수 있다.

계산상 근사 실패와 통계적 식별 실패는 경험적으로 명확히 구분되지 않을 수 있다. 또한 한 도메인에 대한 적용만으로 경험적 일반성을 보장할 수 없다. 기존 0.360과 0.260은 새 primary estimand가 아니며 재계산 후 달라질 수 있다.


# 제8장 자료·윤리·필수 고지

## 8.1 Data Availability

MAPS 원자료는 자료제공기관의 이용규정에 따르며 공개 저장소에 재배포하지 않는다. 분석자료 접근경로는 확보되어 있으나 자료이용 승인조건과 표기해야 할 번호는 최종 제출 전에 확인한다. 원자료와 개인 수준 파생자료는 저장소 외부의 접근통제 경로에 보관한다. 허용되는 범위에서 비식별화된 집계 결과, 코드, 모형, 합성 예제자료와 재현성 실행기록을 공개한다.

## 8.2 Ethics

본 연구는 기존 패널자료의 2차분석이다. 저자 소속기관의 IRB 승인 또는 심의면제 여부와 자료제공기관의 이용조건은 현재 확인 대상이며, 승인·면제 번호는 확정 후 기입한다. 원 조사의 IRB, 자료이용 승인과 본 2차분석의 윤리심의를 서로 다른 절차로 기록한다.

## 8.3 Funding

현재 특정 연구비 지원은 확정되지 않았다. 지원이 확정될 경우 과제번호와 지원기관의 역할을 최종 원고에 기재한다.

## 8.4 Conflict of Interest

현재 보고할 이해상충은 없다. 공동저자와 투고대상이 확정되면 다시 확인한다.

## 8.5 CRediT Author Statement

이창현: Conceptualization, Methodology, Software, Formal analysis, Investigation, Data curation, Visualization, Writing—original draft, Writing—review & editing. 지도교수와 공동저자의 역할은 실제 기여에 따라 최종 제출 전에 확정한다.

## 8.6 AI Assistance Disclosure

OpenAI Codex는 문서 구조화, 초안 작성, 문헌·코드 정합성 점검과 표현 교정에 사용되었다. 연구문제, 분석결정, 자료해석, 인용 검증과 최종 문안에 대한 책임은 연구자에게 있다. 제출기관과 학술지의 생성형 AI 정책에 따라 사용 범위를 다시 고지한다.

## 8.7 추후 확정할 표지정보

소속 대학, 대학원·학과, 학위과정, 지도교수, 심사위원, 공식 제출일과 연구윤리·자료이용 번호는 학과 양식과 승인 결과에 따라 최종본에 기입한다.

# 참고문헌


Bauer, D. J. (2017). A more general model for testing measurement invariance and differential item functioning. *Psychological Methods, 22*(3), 507–526. https://doi.org/10.1037/met0000077

Bauer, D. J., Belzak, W. C. M., & Cole, V. T. (2020). Simplifying the assessment of measurement invariance over multiple background variables: Using regularized moderated nonlinear factor analysis to detect differential item functioning. *Structural Equation Modeling: A Multidisciplinary Journal, 27*(1), 43–55. https://doi.org/10.1080/10705511.2019.1642754

Berry, J. W. (1997). Immigration, acculturation, and adaptation. *Applied Psychology, 46*(1), 5–34. https://doi.org/10.1111/j.1464-0597.1997.tb01087.x

Blei, D. M., Kucukelbir, A., & McAuliffe, J. D. (2017). Variational inference: A review for statisticians. *Journal of the American Statistical Association, 112*(518), 859–877. https://doi.org/10.1080/01621459.2017.1285773

Brandt, H., Chen, S. M., & Bauer, D. J. (2025). Bayesian penalty methods for evaluating measurement invariance in moderated nonlinear factor analysis. *Psychological Methods, 30*(3), 482–512. https://doi.org/10.1037/met0000552

Chen, S. M., & Bauer, D. J. (2024). Modeling construct change over time amidst potential changes in construct measurement: A longitudinal moderated factor analysis approach. *Psychological Methods*. Advance online publication. https://doi.org/10.1037/met0000685

Chen, S. M., & Bauer, D. J. (2026). Improving the evaluation of construct change over time: Advantages of longitudinal moderated nonlinear factor analysis over conventional first-order growth models. *Multivariate Behavioral Research*. Advance online publication. https://doi.org/10.1080/00273171.2026.2640576

Curran, P. J., McGinley, J. S., Bauer, D. J., Hussong, A. M., Burns, A., Chassin, L., Sher, K., & Zucker, R. (2014). A moderated nonlinear factor model for the development of commensurate measures in integrative data analysis. *Multivariate Behavioral Research, 49*(3), 214–231. https://doi.org/10.1080/00273171.2014.889594

Fairlie, R. W. (2017). *Addressing path dependence and incorporating sample weights in the nonlinear Blinder-Oaxaca decomposition technique for logit, probit and other nonlinear models* (SIEPR Discussion Paper No. 17-013). Stanford Institute for Economic Policy Research. https://siepr.stanford.edu/publications/working-paper/addressing-path-dependence-and-incorporating-sample-weights-nonlinear

Kim, E. S., & Willson, V. L. (2014). Measurement invariance across groups in latent growth modeling. *Structural Equation Modeling: A Multidisciplinary Journal, 21*(3), 408–424. https://doi.org/10.1080/10705511.2014.915374

King-Kallimanis, B. L., Oort, F. J., & Garst, G. J. A. (2010). Using structural equation modelling to detect measurement bias and response shift in longitudinal data. *AStA Advances in Statistical Analysis, 94*(2), 139–156. https://doi.org/10.1007/s10182-010-0129-y

Kucukelbir, A., Tran, D., Ranganath, R., Gelman, A., & Blei, D. M. (2017). Automatic differentiation variational inference. *Journal of Machine Learning Research, 18*(14), 1–45. https://www.jmlr.org/papers/v18/16-107.html

Leitgöb, H., Seddig, D., Asparouhov, T., Behr, D., Davidov, E., De Roover, K., Jak, S., Meitinger, K., Menold, N., Muthén, B., Rudnev, M., Schmidt, P., & van de Schoot, R. (2023). Measurement invariance in the social sciences: Historical development, methodological challenges, state of the art, and future perspectives. *Social Science Research, 110*, 102805. https://doi.org/10.1016/j.ssresearch.2022.102805

Liu, Y., Millsap, R. E., West, S. G., Tein, J.-Y., Tanaka, R., & Grimm, K. J. (2017). Testing measurement invariance in longitudinal data with ordered-categorical measures. *Psychological Methods, 22*(3), 486–506. https://doi.org/10.1037/met0000075

Meredith, W. (1993). Measurement invariance, factor analysis and factorial invariance. *Psychometrika, 58*(4), 525–543. https://doi.org/10.1007/BF02294825

Morris, T. P., White, I. R., & Crowther, M. J. (2019). Using simulation studies to evaluate statistical methods. *Statistics in Medicine, 38*(11), 2074–2102. https://doi.org/10.1002/sim.8086

Oort, F. J. (2005). Using structural equation modeling to detect response shifts and true change. *Quality of Life Research, 14*(3), 587–598. https://doi.org/10.1007/s11136-004-0830-y


Samejima, F. (1969). Estimation of latent ability using a response pattern of graded scores. *Psychometrika, 34*(Suppl. 1), 1–97. https://doi.org/10.1007/BF03372160

Sandhu, D. S., & Asrabadi, B. R. (1994). Development of an acculturative stress scale for international students: Preliminary findings. *Psychological Reports, 75*(1), 435–448. https://doi.org/10.2466/pr0.1994.75.1.435

Sinning, M., Hahn, M., & Bauer, T. K. (2008). The Blinder-Oaxaca decomposition for nonlinear regression models. *The Stata Journal, 8*(4), 480–492. https://doi.org/10.1177/1536867X0800800402

Sprangers, M. A. G., & Schwartz, C. E. (1999). Integrating response shift into health-related quality of life research: A theoretical model. *Social Science & Medicine, 48*(11), 1507–1515. https://doi.org/10.1016/S0277-9536(99)00045-3

Stan Development Team. (2026). *CmdStan user’s guide* (Version 2.39). https://mc-stan.org/docs/2_39/cmdstan-guide/

Steinberg, L., & Thissen, D. (2006). Using effect sizes for research reporting: Examples using item response theory to analyze differential item functioning. *Psychological Methods, 11*(4), 402–415. https://doi.org/10.1037/1082-989X.11.4.402

Verdam, M. G. E., Oort, F. J., & Sprangers, M. A. G. (2016). Using structural equation modeling to detect response shifts and true change in discrete variables: An application to the items of the SF-36. *Quality of Life Research, 25*(6), 1361–1383. https://doi.org/10.1007/s11136-015-1195-0

Verdam, M. G. E., Oort, F. J., & Sprangers, M. A. G. (2021). Using structural equation modeling to investigate change and response shift in patient-reported outcomes: Practical considerations and recommendations. *Quality of Life Research, 30*(5), 1293–1304. https://doi.org/10.1007/s11136-020-02742-9

Vehtari, A., Gelman, A., Simpson, D., Carpenter, B., & Bürkner, P.-C. (2021). Rank-normalization, folding, and localization: An improved R-hat for assessing convergence of MCMC (with discussion). *Bayesian Analysis, 16*(2), 667–718. https://doi.org/10.1214/20-BA1221

Widaman, K. F., Ferrer, E., & Conger, R. D. (2010). Factorial invariance within longitudinal structural equation models: Measuring the same construct across time. *Child Development Perspectives, 4*(1), 10–18. https://doi.org/10.1111/j.1750-8606.2009.00110.x

Wu, H., & Estabrook, R. (2016). Identification of confirmatory factor analysis models of different levels of invariance for ordered categorical outcomes. *Psychometrika, 81*(4), 1014–1045. https://doi.org/10.1007/s11336-016-9506-0

Yao, Y., Vehtari, A., Simpson, D., & Gelman, A. (2018). Yes, but did it work? Evaluating variational inference. In *Proceedings of the 35th International Conference on Machine Learning* (Vol. 80, pp. 5581–5590). Proceedings of Machine Learning Research. https://proceedings.mlr.press/v80/yao18a.html

Zhang, L., Carpenter, B., Gelman, A., & Vehtari, A. (2022). Pathfinder: Parallel quasi-Newton variational inference. *Journal of Machine Learning Research, 23*(306), 1–49. https://jmlr.org/papers/v23/21-0889.html

한국청소년정책연구원. (n.d.). *다문화청소년패널조사(구)*. 한국 아동·청소년 데이터 아카이브. Retrieved July 13, 2026, from https://www.nypi.re.kr/archive/board?menuId=MENU00221
