---
title: "종단 순서형 패널자료에서 잠재변화와 측정기능 변화를 분리하기 위한 Response-Shift Decomposition Index"
subtitle: "종단 MNLFA의 경험적 적용, 통계적 검증 및 계산적 보정"
author: "이창현"
date: "2026년 7월"
lang: ko-KR
---

# 목차

- 국문초록 ··· 3
- Abstract ··· 4
- 제1장 서론 ··· 5
- 제2장 이론적 배경 ··· 7
- 제3장 RSDI 방법론 ··· 9
- 제4장 Paper 1: MAPS 2 경험적 적용 ··· 13
- 제5장 Paper 2: Monte Carlo 검증 ··· 16
- 제6장 Paper 3: posterior 근사추론 calibration ··· 19
- 제7장 통합, 실행계획 및 기대기여 ··· 21
- 제8장 자료·윤리·필수 고지 ··· 24
- 참고문헌 ··· 25

# 국문초록

> **문서 성격과 인식론적 상태.** 본 문서는 박사학위논문 연구계획서 v3 초안이다. Paper 1의 수치는 연구 실행 가능성을 평가하기 위한 예비 mean-field 변분추론 결과이다. 반복 VI는 일부 측정패턴의 방향 안정성을 보여주지만 정확한 posterior calibration을 보장하지 않는다. 기존 subset NUTS는 다른 measurement-only 모형이며 현 structural-state 모형이나 RSDI를 확증하지 않는다. Paper 2의 Monte Carlo 검증과 Paper 3의 추정전략 비교는 계획 단계이다. RSDI는 검증이 완료된 효과크기가 아니라 종단 순서형 MNLFA posterior에서 계산되는 후보 model-implied estimand이다. 차별경험 관련 결과는 인과효과가 아니라 모형과 식별조건에 조건부인 measurement-function change의 연관성으로만 해석한다.

종단연구는 관찰된 응답변화를 잠재구성개념의 변화로 해석하는 경우가 많다. 그러나 순서형 문항의 문턱과 요인부하가 시간 또는 시간가변 공변량에 따라 달라지면, 관찰된 변화에는 잠재상태 변화와 측정기능 변화가 동시에 포함된다. 이 둘을 구분하지 않으면 개인이나 집단의 변화에 관한 실질적 결론이 측정모형의 변화와 혼합될 수 있다.

본 학위논문은 종단 순서형 moderated nonlinear factor analysis(MNLFA)가 함의하는 범주확률을 이용하여 Response-Shift Decomposition Index(RSDI)를 정식화하고 평가한다. 네 개의 반사실적 확률벡터를 구성하여 두 시점의 확률변화를 잠재성분, 측정성분, 비가법적 상호작용성분으로 벡터 수준에서 분해하고, 범주 간 등간격을 가정하지 않는 총변동거리(total variation distance)로 각 성분의 크기를 요약한다. 이 분해의 벡터 항등식은 정확하지만 세 성분의 TV 거리는 가법적이지 않다. 따라서 RSDI는 관찰변화 중 측정변화의 백분율, 분산설명률 또는 인과매개 비율이 아니다.

세 편의 연구는 경험적 필요성, 통계적 타당성, 계산적 사용 가능성을 누적하여 검토한다. Paper 1은 다문화청소년패널조사 2기(MAPS 2) 부모자료의 문화적응 스트레스 8문항에 종단 순서형 MNLFA와 RSDI를 탐색적으로 적용한다. 현재 파생자료는 2,191개 가구연결 기록, 9,662개 가구연결-시점, 77,296개 문항응답으로 구성되고, 완전사례 주 MNLFA는 2,190개 가구연결 기록과 77,160개 문항응답을 사용한다. 예비 결과는 관찰점수 LME 기울기 -0.0419, 불변 순서형 LGM 기울기 -0.222, legacy structural-state MNLFA의 네 VI seed 기울기 범위 -0.260에서 -0.164를 보였다. 단일 seed의 W1–W5 RSDI_all-Z는 0.360이었고 문항 1·2·6 제외 민감도는 0.260이었다. 이 값들은 외부 앵커가 없는 legacy 모형, 단일 경로순서, 특정 집계 및 단일 VI 실행에 조건부인 탐색치이다.

Paper 2는 진값이 알려진 Monte Carlo 자료에서 RSDI의 식별조건, 편향, RMSE, 구간포괄률과 실패영역을 평가한다. Paper 3은 동일 자료·동일 모형·동일 parameterization의 posterior target을 유지한 채 NUTS, mean-field VI, full-rank VI와 Pathfinder를 비교하고, 근사추론을 실제 분석에 사용할 수 있는 사전 지정 calibration gate를 제안한다. 설명 순서는 Paper 1–2–3이지만 실제 실행은 식별 명세 확정, 소규모 알고리즘 calibration, Monte Carlo 본실험, Paper 1 확증 재분석의 순서로 진행한다.

본 연구는 response-shift 분해 자체를 최초로 제안하지 않는다. 기존 response-shift SEM, 종단 MNLFA, 비선형 반사실적 분해를 연결하여 시간가변 다중 공변량을 포함한 종단 순서형 문항의 범주확률 공간에서 잠재·측정·상호작용 성분을 posterior draw별로 계산하고, TV 거리로 요약하며, 식별·회복·계산 보정·보고중단 규칙을 함께 제시하는 운용적 estimand와 검증 워크플로를 제안한다.

**주요어:** 종단 측정불변성, MNLFA, response shift, 순서형 자료, 총변동거리, 베이지안 추론, 변분추론, Monte Carlo

# Abstract

Observed change in longitudinal ordinal responses may combine change in the latent construct with change in the measurement function. This dissertation proposes and evaluates the Response-Shift Decomposition Index (RSDI), a candidate posterior functional derived from category probabilities implied by longitudinal ordinal moderated nonlinear factor analysis. Four counterfactual probability vectors are used to obtain latent, measurement, and nonadditive interaction components at the vector level. Component magnitudes are summarized using total variation distance, which avoids assuming equal spacing between ordinal categories. Although the vector decomposition is an exact identity, the componentwise TV distances are not additive; RSDI is therefore not the percentage of observed change, variance explained, or a causal mediation proportion.

The three papers establish empirical necessity, statistical validity, and computational usability. Paper 1 provides an exploratory application to five waves of MAPS 2 parent-panel acculturative-stress items. Paper 2 evaluates identification, recovery, and failure conditions through Monte Carlo simulation. Paper 3 benchmarks NUTS, mean-field and full-rank variational inference, and Pathfinder against the same posterior target and develops a prespecified calibration gate. The proposed contribution is not a new theory of response shift or the first decomposition of response-shift effects. It is an operational integration of response-shift SEM, longitudinal MNLFA, and nonlinear probability decomposition in the category-probability space of longitudinal ordinal items, accompanied by posterior uncertainty, identification checks, recovery evidence, and reporting rules.

# 제1장 서론

## 1.1 연구배경

종단 측정의 핵심 질문은 “관찰된 응답의 변화가 무엇을 의미하는가”이다. 평균점수나 성장모형의 기울기는 변화의 방향과 크기를 간결하게 제시하지만, 그 해석은 동일한 응답범주가 모든 시점과 모든 공변량 수준에서 동일한 잠재상태를 나타낸다는 가정에 의존한다. 이 가정이 성립하지 않으면 관찰된 변화는 적어도 두 과정의 혼합이다. 첫째는 관심 구성개념의 실제 잠재변화이고, 둘째는 응답기준·문항민감도·문턱위치 등 측정기능의 변화이다.

측정불변성 연구는 시점과 집단 간 동일한 척도 사용 가능성을 검토해 왔다(Meredith, 1993; Kim & Willson, 2014; Widaman et al., 2010; Wu & Estabrook, 2016). Response-shift 연구는 건강상태나 생애경험 이후 자기평가의 내부기준, 가치 또는 구성개념의 의미가 바뀔 수 있음을 이론화하고 구조방정식모형으로 true change와 measurement-parameter change를 분리해 왔다(Sprangers & Schwartz, 1999; Oort, 2005; King-Kallimanis et al., 2010; Verdam et al., 2016, 2021). MNLFA는 요인모형의 문턱과 부하를 연속·범주형 공변량의 함수로 표현하여 differential item functioning(DIF)을 유연하게 모형화한다(Curran et al., 2014; Bauer, 2017; Bauer et al., 2020).

그러나 추정된 DIF 계수만으로는 실제 두 시점 사이에 범주확률이 얼마나, 어떤 경로로 바뀌었는지 직접 알기 어렵다. 같은 DIF 계수라도 공변량 변화량, 잠재변화량, 기준확률에 따라 확률영향은 달라지며, 비선형 링크에서는 변화경로에 따라 분해가 달라질 수 있다(Fairlie, 2017; Sinning et al., 2008). 따라서 종단 순서형 MNLFA의 추정치를 해석 가능한 범주확률 대비로 변환하고, 그 통계적·계산적 신뢰성을 함께 검증하는 후속 단계가 필요하다.

## 1.2 문제진술

본 연구가 다루는 문제는 다음과 같다.

1. 종단 순서형 자료에서 잠재상태 변화와 측정기능 변화가 동시에 존재할 때 관찰된 변화를 어떻게 확률공간에서 분리할 것인가?
2. 그 분해를 하나의 요약지표로 제시할 때 순서형 범주의 간격을 가정하지 않으면서도 해석의 한계를 명확히 할 수 있는가?
3. 잠재효과와 공통 DIF가 약하게 식별되는 조건, 앵커 오지정, 공선성, 결측과 희소범주에서 해당 지표가 얼마나 회복되는가?
4. 대규모 종단 MNLFA에서 계산비용을 줄이기 위해 근사추론을 사용할 경우, posterior functional인 RSDI의 오차를 어떻게 보정하고 보고할 것인가?

## 1.3 RSDI의 운용적 정의와 연구공백

본 연구는 종단 순서형 MNLFA가 함의하는 범주확률로 네 개의 반사실적 벡터를 구성한다. 두 시점 사이에서 잠재상태만 바꾼 벡터, 측정공변량만 바꾼 벡터, 둘을 함께 바꾼 벡터를 기준벡터와 비교하여 전체 확률변화를 잠재성분, 측정성분, 상호작용성분으로 나눈다. 각 성분은 범주확률의 signed vector로 정의되며, 크기는 TV 거리로 요약한다.

RSDI의 연구공백은 “response shift를 처음 분해한다”는 데 있지 않다. 기존 SEM 연구는 true change와 response shift를 분리하고 이산변수와 효과크기 문제까지 확장해 왔다(Verdam et al., 2016, 2021). MNLFA는 공변량 관련 DIF와 종단 측정을 포괄하고, 비선형 분해 연구는 확률분해의 경로의존성을 다루었다. 범위가 한정된 문헌검색에서 상대적으로 제한적이었던 부분은 시간가변 다중 공변량을 포함한 종단 순서형 MNLFA의 범주확률 변화를 posterior draw별 반사실로 분해하고, 측정경로의 상대적 크기를 TV 거리 기반 후보 estimand로 요약하며, 식별·회복·계산 보정·실패 규칙을 하나의 워크플로로 평가하는 직접적 구현이다.

따라서 독창성 주장은 다음 네 항목으로 제한한다.

- 종단 순서형 MNLFA의 posterior predictive category-probability space에서의 운용적 분해
- 잠재·측정·상호작용 성분의 draw별 계산과 불확실성 전파
- 순서형 간격을 가정하지 않는 TV 기반 요약과 경로·집계 민감도
- 식별 실패, 회복 실패와 근사추론 실패를 구분하는 검증 및 보고중단 규칙

## 1.4 연구목적과 연구질문

학위논문의 총괄 목적은 RSDI를 제안하는 데 그치지 않고, 경험적 필요성·통계적 타당성·계산적 사용 가능성을 순차적으로 평가하는 것이다.

| 연구 | 핵심 질문 | 독립 기여 | 누적 역할 |
|---|---|---|---|
| Paper 1 | 실제 MAPS 종단해석이 측정기능 변화를 고려하면 달라지는가? | 경험적 적용과 문제 입증 | 왜 필요한가 |
| Paper 2 | RSDI는 어떤 식별·자료 조건에서 참값을 회복하는가? | estimand의 성질과 통계적 검증 | 언제 믿을 수 있는가 |
| Paper 3 | 어떤 계산법이 동일 posterior functional을 얼마나 재현하는가? | 추론 calibration과 사용 게이트 | 어떻게 사용할 것인가 |

# 제2장 이론적 배경

## 2.1 순서형 종단 측정과 불변성

순서형 요인모형은 연속 잠재응답이 문턱을 통과할 때 관찰범주가 생성된다고 가정한다(Samejima, 1969; Liu et al., 2017). 문턱이나 부하가 시점·집단·공변량에 따라 달라지면 동일한 잠재상태라도 응답범주 확률이 달라진다. 순서형 불변성 검정에서는 모형의 parameterization, 문턱 제약, 잠재평균·분산과 잔차척도의 고정 방식이 결과에 영향을 줄 수 있으므로 식별조건을 실질적 불변성 가정과 구분해야 한다(Wu & Estabrook, 2016).

전통적 단계검정은 명료하지만, 연속 공변량과 다중 조절변수, 부분적 DIF가 동시에 존재할 때 조합이 급증한다. MNLFA는 문턱과 부하를 공변량의 함수로 직접 표현하여 이 문제를 완화한다. 다만 유연성은 식별의 자동 보장을 뜻하지 않는다. 같은 공변량이 잠재상태와 모든 문항의 측정모수에 동시에 들어가면 공통 DIF와 잠재효과가 교환될 수 있다.

## 2.2 Response shift와 measurement-function change

Response shift는 재보정(recalibration), 우선순위 변화(reprioritization), 재개념화(reconceptualization)를 포괄하는 이론적 개념이다(Sprangers & Schwartz, 1999). 통계모형에서 검출되는 문턱·부하 변화는 response shift와 정합적일 수 있지만, 그 자체로 심리적 메커니즘을 증명하지 않는다. 본 논문은 이 구분을 유지하기 위해 통계 결과를 원칙적으로 “measurement-function change” 또는 “response-shift-consistent measurement change”라고 부른다.

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

MAPS 2 부모패널은 다문화가정의 적응과 가족환경을 반복 측정한다(한국청소년정책연구원, 2024). 문화적응 스트레스 응답은 한국어 능력, 경제상황, 차별경험, 연령 및 조사시점과 관련될 수 있다(Berry, 1997; Sandhu & Asrabadi, 1994). 이 공변량들은 잠재 스트레스 수준과 응답기준 양쪽에 관련될 가능성이 있으므로 종단 MNLFA의 실질적 적용 사례가 된다. 그러나 MAPS 적용은 방법의 보편성을 입증하는 것이 아니라, 복합적인 시간가변 측정기능이 실제 해석에 미칠 수 있는 영향을 보여주는 test bed이다.

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

## 3.2 TV 거리와 RSDI

범주확률 벡터 \(\mathbf p\)와 \(\mathbf q\)의 TV 거리는

$$
d_{\mathrm{TV}}(\mathbf p,\mathbf q)
=
\frac{1}{2}\sum_{k=1}^{K_j}|p_k-q_k|
$$

이다. 성분 크기는

$$
\ell_{ij}=\frac{1}{2}\sum_k|L_{ijk}|,\qquad
m_{ij}=\frac{1}{2}\sum_k|M_{ijk}|,\qquad
r_{ij}=\frac{1}{2}\sum_k|I_{ijk}|
$$

으로 정의한다. 주 분석의 문항별 표본표준화 RSDI는 posterior draw \(s\)마다

$$
\operatorname{RSDI}^{(s)}_j
=
\frac{\sum_{i\in\mathcal T}w_i m^{(s)}_{ij}}
{\sum_{i\in\mathcal T}w_i\left(\ell^{(s)}_{ij}+m^{(s)}_{ij}+r^{(s)}_{ij}\right)}
$$

으로 계산한다. \(\mathcal T\)는 사전 지정된 표준화 표본이며, 기본 가중치는 동일가중치이다. 조사 가중치 또는 이탈보정 가중치를 사용할 때에는 estimand의 대상 모집단을 별도로 기술한다.

중요하게도

$$
d_{\mathrm{TV}}(\mathbf p_{11},\mathbf p_{00})
\ne
\ell+m+r
$$

가 일반적이다. 따라서 RSDI의 분모는 실제 전체변화 TV가 아니라 세 성분 크기의 합이다. RSDI는 측정경로가 세 구성요소 크기 중 어느 정도를 차지하는지 나타내는 정규화 요약량이며, 관찰변화의 백분율·분산설명률·효과크기의 보편적 기준·인과매개 비율이 아니다. DIF의 실질적 크기를 계수 이외의 확률·응답척도로 제시해야 한다는 문제의식과 연결되지만, 별도 회복검증 없이 검증된 효과크기로 부르지 않는다(Steinberg & Thissen, 2006).

## 3.3 주 estimand와 민감도 estimand

학위논문의 **주 estimand**는 표본표준화 marginal structural-trajectory RSDI로 고정한다. 개인별 occasion residual을 0으로 두고 성장모형이 함의하는 구조적 잠재궤적을 사용하며, 사전 지정된 target sample의 공변량 분포에 표준화한다. posterior draw별 모수·잠재궤적 불확실성을 전파하고 draw 분포로 점추정과 불확실성 구간을 보고한다.

다음은 민감도 분석으로 구분한다.

- realized-state conditional RSDI: 개인별 추정 잠재상태에 조건부
- leave-one-item-out RSDI: 문항 \(j\)의 확률변화를 계산할 때 해당 문항을 잠재점수 정보에서 제외
- population-marginal RSDI: 잠재분포를 적분하고 외부 또는 조사 가중치로 표준화
- 역순분해와 Shapley형 대칭화: 잠재와 측정 교체 순서의 경로의존성 평가
- pooled-scale 요약과 문항평균 요약의 비교

RSDI_all-Z는 연령, 한국어 능력, 소득과 차별경험을 함께 교체한 **포함 공변량 관련 측정경로 변화**로 부른다. 이는 차별경험만의 response shift나 인과효과가 아니다. 차별경험 0→1 고정 대비는 잠재상태를 고정한 비인과적 measurement-path contrast로 별도 보고한다.

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

복수 앵커는 식별을 자동 보장하는 충분조건으로 간주하지 않는다. 내용 타당성과 empirical-DIF 정보를 함께 사용해 후보 앵커를 사전 지정하고, 대안 앵커와 effects coding에서 결론이 유지되는지 확인한다. 현재 maps_mnlfa_structural_state_anchored_v2.stan은 여러 앵커 loading을 모두 1로 고정하지만 본 계획의 명세는 **복수 DIF 앵커 + 단일 marker loading**이다. 코드와 명세의 일치를 Gate G1으로 두고, 수정·단위검증 전 quick NUTS 결과는 본문 근거로 사용하지 않는다.

## 3.5 추론, 진단과 보고중단 규칙

모든 확증 결과는 posterior draw에서 RSDI를 직접 계산한다. NUTS에서는 \(\widehat R<1.01\), 적절한 bulk/tail ESS, divergence와 max-treedepth, energy 진단을 점검하고 prior/posterior predictive check를 수행한다(Vehtari et al., 2021). VI와 Pathfinder는 ELBO 안정성이나 수렴 플래그만으로 승인하지 않고 matched NUTS 대비 functional calibration을 요구한다(Blei et al., 2017).

다음 조건에서는 RSDI 확증 해석을 중단한다.

1. 앵커 변경 또는 effects coding에서 핵심 결론의 방향이 반전됨
2. latent impact와 공통 DIF의 회복률이 사전 기준을 충족하지 못함
3. 주 estimand 분모가 사전 임계값 아래여서 비율이 불안정함
4. posterior predictive check가 문항별 범주분포·시점변화·개인내 연관을 재현하지 못함
5. NUTS 기준 진단이 실패하거나 근사법이 calibration gate를 통과하지 못함
6. 동일한 데이터·모형·parameterization 비교가 보장되지 않음


# 제4장 Paper 1: MAPS 2 경험적 적용

## 4.1 목적과 연구질문

Paper 1은 실제 자료에서 시간가변 측정기능을 고려하는 것이 종단해석에 실질적 차이를 만드는지 평가한다.

- RQ1. 관찰점수 LME, 불변 순서형 LGM과 종단 MNLFA의 변화 방향은 일관적인가?
- RQ2. 문화적응 스트레스 문항의 문턱과 부하는 시간가변 공변량에 따라 달라지는가?
- RQ3. W1–W5 범주확률 변화에서 잠재·측정·상호작용 성분의 크기는 얼마인가?
- RQ4. 결과는 앵커, 경로순서, 문항집합, 집계방식, 잠재상태 정의와 결측처리에 얼마나 민감한가?

## 4.2 자료와 변수

자료는 MAPS 2기 부모 파일 1–5차(2019–2023)이다. 문화적응 스트레스는 5범주 8문항으로 측정된다. 파생자료는 2,191개 가구연결 기록, 9,662개 가구연결-시점, 77,296개 문항응답이며, 완전사례 주 MNLFA는 2,190개 가구연결 기록과 77,160개 응답을 사용한다. W1과 W5가 모두 관찰된 RSDI 표본은 1,743개, 모든 시점이 관찰된 기록은 1,702개이다. 파동별 관찰 기록은 W1 2,186에서 W5 1,750으로 감소한다.

원자료 식별자는 부모 개인 PID가 아니라 가구 ID이므로 “동일 부모 2,191명”이 아니라 “2,191개 가구연결 기록”으로 기술한다. 공변량은 연령, 한국어 능력, 로그소득과 차별경험이며, 차별경험은 9,662개 시점 중 1,308개(13.5%)이다. 회상기간이 시점별로 동일한지, 가구 내 응답자가 교체되었는지, 조사 가중치가 어떤 대상모집단을 대표하는지는 추가 확인한다.

## 4.3 분석계획

1. 기술통계와 범주분포, 이탈패턴, 공변량의 개인내·개인간 변동을 점검한다.
2. 관찰점수 LME와 불변 순서형 LGM을 비교기준으로 적합한다.
3. 복수 DIF 앵커와 단일 marker를 사용하는 structural-state longitudinal MNLFA를 재구현한다.
4. prior predictive check, 장기 NUTS pilot과 posterior predictive check를 수행한다.
5. 사전 지정 calibration gate를 통과한 추정법으로 전체자료를 적합한다.
6. 주 estimand와 사전 지정 민감도 RSDI를 posterior draw별 계산한다.
7. 앵커, 문항 1·2·6 제외, 역순/Shapley, leave-one-item-out, 가중치/IPW·다중대치 가능성을 평가한다.

## 4.4 현재 예비결과

| 분석 | 예비치 | 허용되는 해석 |
|---|---:|---|
| 관찰점수 LME | 기울기 -0.0419 | 평균범주 척도의 감소 방향 |
| 불변 순서형 LGM | -0.222, VI 5–95% [-0.239, -0.205] | 불변 측정모형의 근사 잠재감소 |
| legacy structural-state MNLFA | 네 seed 평균 약 -0.210, 범위 [-0.260, -0.164] | VI seed별 점추정 감소 방향 |
| W1–W5 RSDI_all-Z | 0.360, 단일 VI 5–95% [0.324, 0.396] | 특정 seed·경로·집계의 탐색량 |
| 문항 1·2·6 제외 RSDI | 0.260, 단일 VI 5–95% [0.231, 0.334] | 의미중첩 완화 민감도 |

W1–W5 성분 TV의 문항평균은 잠재 0.133, 측정 0.096, 상호작용 0.037이며 실제 전체변화 TV는 0.157이다. 이 수치는 TV 크기가 비가법적임을 보여준다. 0.360을 “관찰변화의 36%가 측정변화”라고 해석하지 않는다.

예비결과의 핵심 한계는 다음과 같다. 0.360과 0.260은 각각 단일 VI 실행이며 optimizer uncertainty를 포함하지 않는다. legacy 모형은 외부 앵커 없이 모든 문항의 DIF를 허용하여 공통 DIF와 잠재효과가 약하게 식별될 수 있다. 과거 subset NUTS는 다른 measurement-only 모형이므로 현재 structural-state 기울기와 RSDI의 확증 근거가 아니다. 현재 anchored quick NUTS도 소표본·짧은 chain이며 진단과 코드-명세 정합성이 충분하지 않다.

## 4.5 Paper 1 성공기준

Paper 1의 확증 결론은 다음을 모두 만족할 때만 제시한다.

- Gate G1 코드-명세 정합과 식별 unit test 통과
- 장기 NUTS 또는 calibration된 대안 추론의 진단 통과
- 주 PPC와 앵커 민감도 통과
- RSDI 주 estimand의 분모 안정성 확보
- 결측·이탈 및 가중치 처리에 대한 영향 평가
- exploratory 수치와 confirmatory 결과의 명시적 분리


# 제5장 Paper 2: Monte Carlo 검증

## 5.1 목적과 연구질문

Paper 2의 질문은 “RSDI가 언제 회복되는가”이다. 하나의 사전 지정 추정법을 고정하여 DGM 진값 대비 estimand, 앵커, 공선성, 결측과 모형오지정의 통계적 성질을 평가한다. Paper 3와 달리 알고리즘 간 경쟁이 목적이 아니다.

## 5.2 자료생성모형과 단계별 설계

자료는 graded-response structural-state MNLFA에서 생성한다. 기본 구조는 \(J=8\) 문항, \(T=3\) 또는 5 시점, random intercept와 slope, 시간가변 공변량, 문턱·부하 DIF를 포함한다.

### Stage 1: 핵심 회복성

핵심 요인은 표본크기 \(N=300,600,1200\), 시점 \(T=3,5\), DIF 크기 0·중간·큼, DIF 유형 threshold-only와 threshold+loading, 공변량 추세 정적·증가이다. 완전요인 설계는 \(3\times2\times3\times2\times2=72\)개 cell이다.

### Stage 2: 식별 stress test

Stage 1에서 선정한 대표 cell에 DIF 문항 비율, 약한 앵커, 앵커 오지정, 누락 조절변수, \(\mathbf Z\)–\(\eta\) 공선성, 비선형 조절을 추가한다. marker는 척도를 정할 뿐 공통 DIF와 latent impact 분리를 자동 보장하지 않는다는 점을 직접 평가한다.

### Stage 3: 현실적 복잡성

패널이탈과 간헐결측, 희소범주, 비평행 threshold-DIF, MAPS 유사 공변량 분포, 문항 중복과 경계분모 조건을 평가한다. 모든 요인을 완전교차하지 않고 Stage 1–2 결과에서 실패 가능성이 높은 조합을 사전 규칙으로 선택한다.

## 5.3 비교모형과 요약량

비교모형은 관찰점수 성장모형, 불변 순서형 LGM, 진실한 MNLFA와 선택적으로 오지정된 MNLFA이다. RSDI의 추가정보를 검증하기 위해 DIF 계수, 기대점수 차이, 실제 전체변화 TV, 누적확률 거리와 signed projection을 함께 비교한다.

필수 edge case는 영 측정변화, 영 잠재변화, 영 상호작용, 분모 0 근방, 잠재·측정 성분의 상쇄, 동일 DIF 계수이나 서로 다른 \(\Delta Z\)·\(\Delta\eta\), 동일 관찰점수 변화이나 서로 다른 성분구성이다.

## 5.4 평가기준

- 성장·잠재효과: bias, relative bias, RMSE, interval coverage
- DIF: bias, RMSE, false-positive rate, power
- RSDI: bias, RMSE, coverage, 분모불안정률, 순위보존
- 모형진단: 수렴실패, 경계추정, PPC 실패, 식별경고
- Monte Carlo 오차: bias·coverage·실패율의 MCSE

반복수는 임의의 고정값을 먼저 선언하지 않고 pilot 분산과 목표 MCSE로 결정한다. 단, 최소 반복수, 최대 반복수, 배치단위와 중단규칙을 pilot protocol에 사전 등록한다. 실패한 적합은 원인을 분류하고, 동일 seed 재시도보다 사전 지정된 초기화·iteration 확대 규칙을 적용한다.

## 5.5 계산예산과 축소규칙

| 항목 | Pilot에서 확정할 값 | 사전 원칙 |
|---|---|---|
| cell 수 | Stage 1은 72, Stage 2–3은 선정규칙 적용 | 모든 확장을 완전교차하지 않음 |
| 셀당 반복수 | 목표 MCSE 기반 최소–최대 범위 | batch별 MCSE 확인 |
| 적합당 시간·메모리 | N/T/추정법별 중앙값·상위 90% | 이상치와 실패 분리 |
| 총 core-hours | pilot runtime으로 산출 | 20% 재시도 여유 포함 |
| 저장공간 | draw 보존수준별 산출 | 핵심 draw와 진단을 분리 보존 |
| 실패처리 | 원인코드·재시도 1회·최종 실패 | 실패율 자체를 결과로 보고 |

예산을 초과하면 우선 비핵심 고차상호작용을 제거하고, 다음으로 Stage 3의 저우선순위 현실조건을 축소한다. 표본크기, 시점 수, DIF 크기, 앵커오지정과 분모경계 조건은 핵심요인으로 유지한다. 정확한 core-hours와 저장공간은 calibration pilot 완료 후 프로포절 부록에 갱신한다.

## 5.6 Paper 2 성공기준

RSDI를 실질적으로 사용 가능한 estimand로 주장하려면 주 식별조건에서 편향·coverage가 사전 기준을 충족하고, 실패영역이 재현 가능하게 탐지되어야 한다. 회복에 실패하면 지표를 폐기하거나 estimand·식별조건을 수정하며, 실패 cell을 제외하고 성공만 보고하지 않는다.


# 제6장 Paper 3: posterior 근사추론 calibration

## 6.1 목적과 연구질문

Paper 3의 질문은 “어떤 계산법이 같은 posterior functional을 얼마나 재현하는가”이다. DGM 진값 회복을 주목적으로 하는 Paper 2와 달리, 동일 자료·동일 모형·동일 parameterization에서 잘 진단된 NUTS posterior를 기준으로 알고리즘 근사오차와 계산비용을 분리한다.

## 6.2 비교설계

Paper 2의 6–12개 benchmark regime을 다음 기준으로 선택한다.

- 작은·중간·큰 표본과 짧은·긴 시점의 대표 조합
- RSDI가 0 근방, 중간, 큰 조건
- 약한 식별과 강한 식별 조건
- 희소범주 또는 결측이 있는 현실적 조건
- MAPS와 유사한 경험적 조건

각 regime에서 동일 생성자료, likelihood, prior, 식별제약과 posterior functional을 사용한다. 비교법은 장기 NUTS, mean-field VI, full-rank VI와 Pathfinder이다. 작은·중간 조건에서는 전체자료 matched NUTS를, 큰 조건에서는 동일 규칙으로 선정한 matched subset NUTS와 가능한 경우 분할 또는 중요도 보정 진단을 사용한다. subset 결과를 전체자료의 정답으로 간주하지 않는다.

## 6.3 평가기준

- 표준화 posterior mean difference와 rank correlation
- posterior SD 비율과 구간포괄/중첩
- 문항별·통합 RSDI 오차와 순위보존
- tail·multimodality·posterior correlation 재현
- PPC와 pointwise log-likelihood 차이
- wall-clock time, peak memory, 실패율과 재실행 변동

## 6.4 Calibration gate

근사법은 다음 조건을 모두 만족할 때만 Paper 1 전체자료 및 Paper 2 주 추정법으로 승인한다.

1. 핵심 구조모수와 RSDI의 표준화 오차가 사전 허용범위 이내
2. posterior SD 축소가 사전 한도를 넘지 않음
3. RSDI 구간과 문항순위가 matched NUTS와 충분히 일치
4. PPC와 log-likelihood 진단에서 체계적 열화가 없음
5. 여러 seed에서 최적화 실패와 결론변동이 허용범위 이내

단순 속도비교만으로는 독립 논문 기여가 부족하다. 따라서 Paper 3의 산출물은 “어떤 자료·진단 조건에서 어떤 추정법을 승인·거부할 것인지”에 관한 재현 가능한 2단계 의사결정 규칙이다. 독립적인 calibration 규칙을 확립하지 못하면 Paper 3를 Paper 2의 계산 부록 또는 방법노트로 축소하고, 제2 도메인 적용을 대안으로 검토한다. 신규자료 접근과 윤리승인 위험 때문에 제2 도메인 적용은 사전 Plan B이지 현재 확정 연구는 아니다.

# 제7장 통합, 실행계획 및 기대기여

## 7.1 세 논문의 통합논리

세 연구는 동일한 방법을 세 번 적용하는 것이 아니라 하나의 해석 주장에 필요한 서로 다른 타당성 조건을 누적하여 검토한다. Paper 1은 시간가변 측정기능을 무시할 때 실제 종단해석이 달라질 수 있음을 경험적으로 보인다. Paper 2는 RSDI의 식별조건, 통계적 성질과 실패영역을 진값이 알려진 자료에서 평가한다. Paper 3은 식별된 동일 posterior target을 대규모 자료에서 근사할 때 발생하는 알고리즘 오차와 계산비용을 분리한다. 누적 기여는 경험적 필요성, 통계적 타당성, 계산적 사용 가능성이다.

서술 순서는 Paper 1→2→3이지만 실행 순서는 다음과 같다.

1. G1: 식별명세와 Stan 코드 정합, 단위검증
2. G2: Paper 3의 소규모 matched NUTS calibration
3. G3: Paper 2 pilot, MCSE와 계산예산 확정
4. G4: Paper 2 본실험과 estimand/failure rule 확정
5. G5: Paper 1 확증 전체자료 재분석
6. G6: 세 논문 통합, 재현성 패키지와 최종 논문 작성

## 7.2 기대기여

이론적으로 response shift라는 심리적 설명과 통계적 measurement-function change를 구분한다. 방법론적으로는 ordinal MNLFA posterior에서 계산되는 범주확률 분해와 TV 기반 후보 estimand를 제시한다. 검증 측면에서는 식별 실패, 통계적 회복 실패와 알고리즘 근사 실패를 분리한다. 응용 측면에서는 종단 순서형 척도의 변화해석에 필요한 최소 보고항목과 중단기준을 제공한다.

RSDI의 수학적 정의는 특정 도메인에 의존하지 않는다. 그러나 본 학위논문이 입증하는 일반성은 사전 지정한 DGM 범위의 모형급 전이 가능성에 한정된다. 다른 구성개념과 모집단에 대한 경험적 일반화는 후속 연구과제이다.

## 7.3 일정과 마일스톤

| 기간 | 핵심 작업 | 완료 게이트 |
|---|---|---|
| 2026년 3분기 | 식별명세, 코드 정합, prior predictive unit test | G1 |
| 2026년 4분기 | 소규모 matched NUTS–VI–Pathfinder calibration | G2 |
| 2027년 1분기 | Paper 2 pilot, 반복수·계산예산 확정 | G3 |
| 2027년 2–3분기 | Paper 2 본실험, 결과·실패영역 정리 | G4 |
| 2027년 4분기 | Paper 1 확증 재분석, 결측·가중치 민감도 | G5 |
| 2028년 1분기 | Paper 3 본분석과 의사결정 규칙 | G6a |
| 2028년 2분기 | 통합논의, 재현성 패키지, 예비심사 수정 | G6b |

일정은 프로포절 승인일과 연산자원 배정에 따라 갱신한다. 각 게이트가 실패하면 후속 단계로 자동 진행하지 않고 모형 단순화, estimand 수정 또는 Paper 3 Plan B를 적용한다.

## 7.4 재현성 계획

분석은 R, cmdstanr와 CmdStan으로 수행한다. 최종 저장소에는 비식별 합성 예제자료, 자료사전, 전처리 checksum, seed, 실행 명령, 모형 파일, 패키지 lockfile 또는 완전한 sessionInfo(), OS·컴파일러 정보, 결과 manifest와 표·그림 생성 스크립트를 포함한다. 원자료와 개인 수준 파생자료는 저장소에 포함하지 않는다. 각 결과표는 원출력 파일과 생성 스크립트에 추적 가능하도록 한다.

## 7.5 한계

첫째, MAPS 식별자가 개인 PID가 아닌 가구 ID이므로 동일 응답자 추적 가정이 제한될 수 있다. 둘째, 패널이탈과 결측, 공식 가중치 미적용은 현재 예비결과를 편향시킬 수 있다. 셋째, 8문항 단일요인 모형과 공통 DIF 함수가 실제 측정구조를 충분히 포착하지 못할 수 있다. 넷째, RSDI는 추정모형, 앵커, 경로순서, target sample과 집계방식에 조건부이다. 다섯째, TV 요약은 방향정보를 축약한다. 여섯째, 계산상 근사와 통계적 식별 실패는 경험적으로 구분하기 어려울 수 있다. 일곱째, 한 도메인 적용은 경험적 일반성을 보장하지 않는다.


# 제8장 자료·윤리·필수 고지

## 8.1 Data Availability

MAPS 원자료는 자료제공기관의 이용규정에 따르며 공개 저장소에 재배포하지 않는다. 분석자료 접근경로는 확보되어 있으나 자료이용 승인조건과 표기해야 할 번호는 최종 제출 전에 확인한다. 원자료와 개인 수준 파생자료는 저장소 외부의 접근통제 경로에 보관한다. 허용되는 범위에서 비식별 집계결과, 코드, 모형, 합성 예제자료와 재현성 manifest를 공개한다.

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

Liu, Y., Millsap, R. E., West, S. G., Tein, J.-Y., Tanaka, R., & Grimm, K. J. (2017). Testing measurement invariance in longitudinal data with ordered-categorical measures. *Psychological Methods, 22*(3), 486–506. https://doi.org/10.1037/met0000075

Meredith, W. (1993). Measurement invariance, factor analysis and factorial invariance. *Psychometrika, 58*(4), 525–543. https://doi.org/10.1007/BF02294825

Oort, F. J. (2005). Using structural equation modeling to detect response shifts and true change. *Quality of Life Research, 14*(3), 587–598. https://doi.org/10.1007/s11136-004-0830-y


Samejima, F. (1969). Estimation of latent ability using a response pattern of graded scores. *Psychometrika, 34*(Suppl. 1), 1–97. https://doi.org/10.1007/BF03372160

Sandhu, D. S., & Asrabadi, B. R. (1994). Development of an acculturative stress scale for international students: Preliminary findings. *Psychological Reports, 75*(1), 435–448. https://doi.org/10.2466/pr0.1994.75.1.435

Sinning, M., Hahn, M., & Bauer, T. K. (2008). The Blinder-Oaxaca decomposition for nonlinear regression models. *The Stata Journal, 8*(4), 480–492. https://doi.org/10.1177/1536867X0800800402

Sprangers, M. A. G., & Schwartz, C. E. (1999). Integrating response shift into health-related quality of life research: A theoretical model. *Social Science & Medicine, 48*(11), 1507–1515. https://doi.org/10.1016/S0277-9536(99)00045-3

Steinberg, L., & Thissen, D. (2006). Using effect sizes for research reporting: Examples using item response theory to analyze differential item functioning. *Psychological Methods, 11*(4), 402–415. https://doi.org/10.1037/1082-989X.11.4.402

Verdam, M. G. E., Oort, F. J., & Sprangers, M. A. G. (2016). Using structural equation modeling to detect response shifts and true change in discrete variables: An application to the items of the SF-36. *Quality of Life Research, 25*(6), 1361–1383. https://doi.org/10.1007/s11136-015-1195-0

Verdam, M. G. E., Oort, F. J., & Sprangers, M. A. G. (2021). Using structural equation modeling to investigate change and response shift in patient-reported outcomes: Practical considerations and recommendations. *Quality of Life Research, 30*(5), 1293–1304. https://doi.org/10.1007/s11136-020-02742-9

Vehtari, A., Gelman, A., Simpson, D., Carpenter, B., & Bürkner, P.-C. (2021). Rank-normalization, folding, and localization: An improved R-hat for assessing convergence of MCMC (with discussion). *Bayesian Analysis, 16*(2), 667–718. https://doi.org/10.1214/20-BA1221

Widaman, K. F., Ferrer, E., & Conger, R. D. (2010). Factorial invariance within longitudinal structural equation models: Measuring the same construct across time. *Child Development Perspectives, 4*(1), 10–18. https://doi.org/10.1111/j.1750-8606.2009.00110.x

Wu, H., & Estabrook, R. (2016). Identification of confirmatory factor analysis models of different levels of invariance for ordered categorical outcomes. *Psychometrika, 81*(4), 1014–1045. https://doi.org/10.1007/s11336-016-9506-0

한국청소년정책연구원. (2024). *다문화청소년패널조사(MAPS) 2기 1–5차 조사 데이터 유저가이드* [데이터 유저가이드]. 한국 아동·청소년 데이터 아카이브. https://www.nypi.re.kr/archive/mps/program/examinDataCode/view?menuId=MENU00226&titleId=144
