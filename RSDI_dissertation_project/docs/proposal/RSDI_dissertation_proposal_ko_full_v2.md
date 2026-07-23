# 종단 순서형 패널자료에서 잠재 변화와 측정기능 변화를 분해하는 베이지안 종단 MNLFA 프레임워크

## A Bayesian Longitudinal MNLFA Framework for Decomposing Latent Change and Measurement-Function Change in Ordinal Panel Data

**박사학위논문 연구계획서 (3편 논문형 학위논문 / Three-Paper Dissertation Proposal)**

---

> **인식론적 상태 고지 (Epistemic Status Notice).** 본 문서는 박사학위논문 연구계획서이다. 논문 1의 MAPS 실증분석에는 비교모형, 반복 mean-field VI, 기존 subset NUTS 보정, 문항 제외 민감도 분석에서 산출된 *예비결과*가 포함되어 있다. 이 결과는 연구의 실행 가능성과 가설을 뒷받침하지만 최종 확증 결과가 아니다. 논문 2의 Monte Carlo 검증과 논문 3의 추정전략 비교는 계획 단계이며, 그 성능을 미리 단정하지 않는다. RSDI(Response-Shift Decomposition Index)는 기존 베이지안 종단 MNLFA posterior를 이용하는 model-implied decomposition estimand/index로 제안되며, 아직 일반적 타당화가 완료된 방법으로 간주하지 않는다. 차별경험과 문항기능의 관련성도 인과효과가 아니라 `discrimination-related measurement-function change`로 해석한다.

---

## 국문 초록

종단 패널에서 순서형 척도의 점수가 변하더라도 그 변화가 잠재 특성의 변화만을 반영한다고 단정할 수는 없다. 차별경험, 언어능력, 소득처럼 시간에 따라 변하는 공변량이 문항의 역치나 적재량과 관련되면, 관찰된 반응 변화에는 잠재변화와 측정기능 변화가 함께 포함된다. 본 박사학위논문은 베이지안 종단 순서형 moderated nonlinear factor analysis(MNLFA)의 posterior predictive distribution을 이용하여 관찰된 범주확률 변화를 잠재변화 성분, 측정기능 변화 성분, 상호작용 성분으로 분해하고, 측정기능 변화의 상대적 크기를 Response-Shift Decomposition Index(RSDI)로 요약하는 방법을 개발·평가한다. 논문 1은 다문화청소년패널조사(MAPS) 2기 부모 패널의 5개 시점과 문화적응 스트레스 8문항에 적용하여 관찰점수 혼합모형, 측정불변 순서형 잠재성장모형, 종단 순서형 MNLFA를 비교한다. 예비 mean-field VI의 네 최적화 실행에서는 차별경험 관련 평행 역치 DIF가 같은 방향의 variational solution으로 나타났다. 모든 모형화된 공변량의 변화가 결합된 W1–W5 RSDI_all-Z 문항평균은 8문항 모형에서 0.360, 차별 내용과 직접 맞닿은 문항 1·2·6을 제외한 민감도 모형에서 0.260으로 추정되었다. 이 값들은 차별경험만의 기여율이 아니다. 이 값들은 방향과 실행 가능성을 보여주는 근사 posterior 결과이며 최종 확증치로 다루지 않는다. 논문 2는 시간가변 역치·적재 DIF의 크기, 문항비율, 공변량 추세, 표본크기와 웨이브 수를 조작한 Monte Carlo 연구로 성장기울기와 RSDI의 편향·RMSE·coverage를 평가한다. 논문 3은 mean-field VI, full-rank VI, Pathfinder, subset NUTS, 선택모형 NUTS를 비교하여 점추정, 불확실성, 문항순위, 계산비용을 함께 평가한다. 세 연구는 시간가변 측정 비불변성이 종단 변화 해석에 미치는 영향을 탐지하고, 분해하며, 계산적으로 검증하는 통합 워크플로를 제공하는 것을 목표로 한다.

**주제어:** 종단 측정불변성, 서열형 문항반응, moderated nonlinear factor analysis, 차별적 문항기능, 측정기능 변화, 반응이동, 베이지안 근사추론

## Abstract

Change in an ordinal scale score does not necessarily represent change in the underlying construct. When time-varying covariates such as perceived discrimination, language proficiency, and household income are associated with item thresholds or loadings, observed response change combines latent change with measurement-function change. This three-paper dissertation develops and evaluates the Response-Shift Decomposition Index (RSDI), a model-implied estimand derived from the posterior predictive distribution of a Bayesian longitudinal ordinal moderated nonlinear factor analysis (MNLFA). Paper 1 applies the framework to five waves of the Multicultural Adolescents Panel Study parent panel and eight acculturative-stress items. Across four mean-field variational optimizations, discrimination-related parallel threshold DIF had the same direction. The preliminary W1–W5 all-covariate RSDI item mean was 0.360 for the eight-item model and 0.260 after excluding Items 1, 2, and 6, which were most proximal to discrimination content. These indices combine changes in all modeled covariates and are not discrimination-specific proportions. These estimates are treated as approximate feasibility evidence rather than confirmatory results. Paper 2 uses a Monte Carlo study to evaluate bias, RMSE, coverage, DIF recovery, and RSDI recovery under time-varying threshold and loading DIF. Paper 3 compares mean-field and full-rank variational inference, Pathfinder, subset NUTS, and selected-model NUTS with respect to posterior location, uncertainty, item ranking, RSDI accuracy, and computational cost. Together, the studies aim to establish a transparent workflow for detecting, decomposing, and validating measurement-function change in longitudinal ordinal data without interpreting covariate-related DIF as a causal response-shift effect.

**Keywords:** longitudinal measurement invariance, ordinal item response, moderated nonlinear factor analysis, differential item functioning, measurement-function change, response shift, approximate Bayesian inference

---

# 1. 서론

## 1.1 연구 배경과 문제 제기

순서형(Likert형) 문항을 반복측정하는 종단 패널연구에서, 연구자는 흔히 "시간이 지나면서 점수가 증가/감소했다"는 형태로 결과를 해석한다. 그러나 이러한 해석은 측정 불변성이 성립할 때에만 타당하다. 동일한 잠재 특성이 시점마다 동일한 방식으로 문항에 반영된다는 보장이 없다면, 관찰된 점수 변화는 잠재 특성의 변화와 측정기능의 변화가 합쳐진 결과일 수 있다(Widaman et al., 2010). 이 문제는 특정 영역에 국한되지 않는다. 환자의 삶의 질 추적(반응 이동), 임상 증상 척도, 노화·인지 패널, 교육검사 등 **시간에 따라 변하는 공변량이 문항 응답기준을 바꿀 수 있는 모든 순서형 패널**에서 동일하게 발생한다. 따라서 본 연구의 일차적 관심은 특정 구성개념이 아니라, *관찰된 종단 순서형 반응변화를 잠재 변화와 측정기능 변화로 분해하는 일반적 방법*이다.

본 연구는 이 일반적 방법을 **다문화가족 패널의 문화적응 스트레스(acculturative stress)** 사례로 구체화하여 시연(demonstration)한다. 이 사례를 대표 적용으로 택한 이유는, 시간가변 공변량이 문항기능을 바꿀 이론적 근거가 특히 분명하기 때문이다. 차별경험, 한국어 능력, 소득과 같은 공변량은 시간에 따라 변할 뿐 아니라, 응답자가 문항을 해석하고 범주를 선택하는 기준 자체를 바꿀 수 있다. 예를 들어 "한국 사람들이 나에게 편견을 가지고 있다", "외국 출신자를 무시하는 것이 화가 난다", "한국 사람들과 다른 대우를 받는다"와 같은 문항은 차별경험과 내용적으로 직접 맞닿아 있다. 따라서 같은 잠재 스트레스 수준을 가진 두 응답자라도 차별경험이 다르면 동일 문항에서 더 높은 범주를 선택할 가능성이 달라질 수 있다. 이 경우 관찰된 변화는 (1) 실제 잠재 스트레스의 변화와 (2) 차별경험에 따른 문항 응답기준의 변화라는 두 성분으로 분리될 필요가 있다. 즉 이 사례는 일반 방법론의 가치를 보여줄 **거의 이상적인 테스트 베드**이지, 방법의 적용 범위가 다문화에 한정됨을 뜻하지 않는다.

## 1.2 기존 접근의 한계

기존의 잠재성장모형(LGM)이나 합산점수 기반 성장모형은 이 두 성분을 분리하기 어렵다. 이들 모형은 측정 모형을 시점 간에 고정하거나 합산점수를 반복측정 지표로 사용함으로써 측정의 항상성을 암묵적으로 가정한다(Chen & Bauer, 2024). 측정 비불변성이 존재하면 잠재 성장 모수(특히 기울기) 추정이 편향될 수 있음이 보고되어 왔다(Kim & Willson, 2014). 종단 MNLFA 연구는 construct change와 measurement change를 동시에 다룰 수 있는 틀을 제공하며, 전통적 성장모형이 측정기능 변화를 무시할 때 발생하는 해석 왜곡을 직접 겨냥한다(Chen & Bauer, 2024).

그러나 기존 MNLFA 연구는 대개 "어떤 문항에서 어떤 공변량 DIF가 있는가"를 보고하는 데 머문다. 응용 종단 연구자가 실제로 궁금해하는 한 단계 더 나아간 질문—**관찰된 점수 변화 중 얼마가 실제 잠재 변화이고 얼마가 측정기능 변화인가**—에 대한 정량적 분해는 아직 명확히 정리되어 있지 않다.

## 1.3 연구 목적과 연구 질문

본 연구의 목적은 베이지안 종단 순서형 MNLFA posterior를 활용하여 관찰된 순서형 반응 변화를 잠재 변화 성분과 측정 이동 성분으로 반사실적으로 분해하는 estimand(RSDI)를 제안하고, 실증분석과 시뮬레이션을 통해 그 타당성과 한계를 평가하는 것이다.

핵심 연구 질문은 다음과 같다.

- **RQ1.** 시간가변 DIF가 있는 순서형 종단 패널에서, 측정 불변성을 가정한 성장모형과 시간가변 DIF를 허용한 종단 MNLFA는 서로 다른 종단 해석을 낳는가? (대표 적용: 다문화가족 패널의 문화적응 스트레스 자료)
- **RQ2.** 관찰된 문항 반응 변화 중 어느 정도가 잠재 특성 변화에 기인하고, 어느 정도가 측정기능 이동에 기인하는가(RSDI로 정량화 가능한가)?
- **RQ3.** 시간가변 역치/적재 DIF가 존재할 때 기존 성장모형은 잠재 기울기를 얼마나 편향되게 추정하며, MNLFA/RSDI는 이를 어느 정도 회복하는가?
- **RQ4.** 고차원 종단 순서형 MNLFA에서 어떤 추정전략(VI, Pathfinder, subset/selected NUTS)을 어디까지 신뢰할 수 있는가?

## 1.4 기여와 본 연구의 위치

본 연구는 새로운 sampler나 완전히 새로운 모형 class를 제안하지 않는다. 기여는 다음과 같이 정리된다. 첫째, 시간가변 DIF가 있는 종단 순서형 자료에서 관찰 반응변화를 반사실적으로 분해하는 estimand를 정의한다. 둘째, posterior draw 단위로 잠재-변화 성분과 측정-이동 성분의 불확실성을 추정한다. 셋째, RSDI를 이용해 문항별 반응 이동 영향을 정량화한다. 넷째, Monte Carlo 시뮬레이션으로 기울기 편향과 RSDI 회복을 검증한다. 따라서 본 연구의 포지션은 **방법론적 확장 및 평가(methodological extension and evaluation)**이다.

---

# 2. 이론적 배경

## 2.1 종단 측정 불변성과 성장 해석

종단 SEM에서 요인 평균이나 성장 모수를 해석하려면 동일한 구성개념이 시간에 걸쳐 동일한 방식으로 측정되어야 한다는 기본 논리가 확립되어 있다(Widaman et al., 2010). 측정 대상이 순서형 지표일 때는 이 논리가 더욱 중요하며, 순서형 종단 측정 불변성 검정 절차가 별도로 발전해 왔다(Liu et al., 2017). MAPS 문화적응 스트레스 문항은 Likert형 순서형 응답이므로, 일반 연속 CFA/LGM 논리보다 순서형 측정 논리가 요구된다.

측정 불변성이 깨질 때 잠재 성장 모수 해석이 어떻게 왜곡되는지는 선행연구에서 보고되어 왔다(Kim & Willson, 2014). 이는 본 연구가 naive 성장모형, 불변성 가정 순서형 성장모형, MNLFA를 비교하는 설계의 근거가 된다.

## 2.2 MNLFA와 종단 MNLFA

MNLFA는 측정 불변성·DIF 검정을 집단 기반 비교를 넘어 연속·범주형 조절변수의 함수로 일반화하는 틀을 제공한다(Bauer, 2017). 핵심은 문항 모수(적재·역치)가 집단뿐 아니라 공변량의 함수가 될 수 있다는 점이다. 본 연구에서 부모 연령, 한국어 능력, 소득, 차별경험을 문항 모수 예측변수로 투입하는 것은 이 틀에 직접 근거한다. 다수의 배경변수가 있을 때는 정규화(regularized) MNLFA를 통해 DIF를 효율적으로 선별할 수 있다(Bauer et al., 2020).

종단 MNLFA는 construct change와 measurement change를 동시에 모형화하는 방향으로 발전했으며, 본 연구의 가장 직접적인 방법론적 anchor이다(Chen & Bauer, 2024). 후속 시뮬레이션은 측정기능 변화를 무시한 1차 성장모형의 변화 추정이 편향될 수 있음을 보이고, 종단 MNLFA의 DIF 탐지 성능을 평가하였다(Chen & Bauer, 2026). 두 연구는 종단 MNLFA의 필요성과 성장편향 가능성을 뒷받침하지만, 본 연구에서 제안하는 RSDI나 MAPS 순서형 구현을 검증한 근거는 아니다.

## 2.3 반응 이동(Response Shift) 이론

반응 이동은 건강관련 삶의 질 연구에서 발전한 이론적 틀로, 응답자의 내적 기준(recalibration), 가치 우선순위(reprioritization), 구성개념 정의(reconceptualization)의 변화를 포괄한다(Sprangers & Schwartz, 1999). SEM을 이용해 true change와 response shift/측정편향을 구분하려는 시도가 이어져 왔다(Oort, 2005; King-Kallimanis et al., 2010).

본 연구의 반응 이동 유형 대응은 다음과 같다. 문항 **역치(threshold) 이동**은 동일 잠재수준에서 범주 선택 기준이 달라지는 것이므로 주로 **recalibration**에 대응하고, 문항 **적재(loading) 이동**은 문항이 구성개념을 반영하는 강도의 변화이므로 **reprioritization/reconceptualization**에 가깝다.

기존 SEM 기반 반응이동 분해(Oort, 2005)와 본 연구의 차별점을 분명히 할 필요가 있다. Oort류 접근은 (1) 주로 연속지표 공통요인 SEM에서 절편/적재 변화를 모수로 탐지하고, (2) 집단·시점 수준의 모수 차이로 반응이동을 *진단*하는 데 초점이 있다. 이에 비해 본 연구는 (a) 순서형 문항반응 확률 척도에서, (b) 연속·시간가변 공변량의 함수로 문항모수 변화를 모형화하며(MNLFA), (c) 모수 탐지에 그치지 않고 **관찰된 종단 반응변화량을 잠재·측정 성분으로 분해하는 양적 estimand(RSDI)와 그 사후 불확실성**을 산출한다. 즉 "반응이동이 있는가"를 넘어 "선택한 모형과 경로에서 측정이동 성분의 상대적 크기가 얼마인가"를 정량화한다는 점에서 기존 분해와 구별된다.

본 연구는 차별경험 관련 역치 이동을 반응 이동의 한 후보적 형태로 해석하되, 인과적 주장("차별이 반응 이동을 일으켰다")은 하지 않고 "discrimination-related measurement-function shift와 일관된 패턴"으로 표현한다.

## 2.4 MAPS 및 문화적응 스트레스 DIF 맥락

동일 연구 맥락(MAPS 기반)에서 다문화가정 어머니의 문화적응 스트레스 척도에 대해 차별경험 관련 DIF 가능성이 보고된 바 있다(이창현 & 최윤영, 2026). 이는 차별경험을 시간가변 DIF 예측변수로 설정하는 것이 사후적 fishing이 아니라 같은 자료 맥락의 선행 심리측정 근거에 기반한 선택임을 방어하는 근거가 된다. 다만 이 선행연구는 단일시점 GRM/MIMIC이며 독립적 외부 타당화로 인용하기보다 같은 연구 프로그램 내부의 선행 근거로 표현한다.

## 2.5 연구 공백(Research Gap)

선행문헌을 종합하면 (1) 종단 측정 불변성은 성장 해석의 전제이고, (2) MNLFA는 공변량 관련 DIF를 유연하게 다루며, (3) 종단 MNLFA는 construct change와 measurement change를 함께 다룰 수 있고, (4) 반응 이동 이론은 측정기능 변화를 해석할 언어를 제공한다. 그러나 **시간가변 차별경험 관련 DIF가 있는 순서형 이주가족 패널에서, 관찰 반응변화 중 얼마가 잠재 변화이고 얼마가 측정기능 이동인지를 posterior 기반 반사실적 분해로 정량화한 연구는 직접적으로 드물다.** 본 연구는 이 공백을 RSDI라는 estimand/워크플로로 메우고자 한다.

---

# 3. 전체 연구 프레임워크: RSDI

## 3.1 표기와 모형 개요

문항 `j`, 개인 `i`, 시점 `t`에서 순서형 반응을 `Y_itj`라 하고, 잠재 문화적응 스트레스를 `eta_it`, 시간가변 공변량 벡터를 `Z_it`(예: 차별경험, 한국어 능력, 소득)라 한다. 종단 순서형 MNLFA에서 문항 모수(적재 `a_j`, 역치 `tau_jk`)는 `Z_it`의 함수가 될 수 있다. 베이지안 추정으로 모든 모수의 결합 posterior를 얻는다.

분해의 기준량 `mu`를 어떤 척도에서 정의하느냐는 중요한 설계 선택이다. 기대 범주점수 `E[Y_itj | eta_it, Z_it]`를 직접 쓰면 순서형 반응을 사실상 등간으로 취급하게 되어, 본 연구의 순서형 약속과 충돌한다. 따라서 본 연구는 **문항 범주별 응답확률(또는 누적확률/로짓) 척도에서 분해를 우선 정의**하고, 기대 범주점수는 보조적 요약으로만 사용한다. 즉 기준량을 다음 중 하나로 둔다.

```text
(척도 A, 권장)  p_itjk = P(Y_itj = k | eta_it, Z_it)   또는 누적확률/로짓
(척도 B, 보조)  mu_itj = E[Y_itj | eta_it, Z_it]
```

분해는 각 척도에서 동일한 반사실 논리로 적용되며, 확률 척도에서는 범주별(또는 누적) 차이를 요약통계(예: 총변동 거리)로 집약한다.

## 3.2 반사실적 분해

두 시점 `t0`, `t1` 사이의 총 변화는 다음과 같다.

```text
Total change = mu(eta_t1, Z_t1) - mu(eta_t0, Z_t0)
```

이를 세 성분으로 분해한다.

```text
Latent change component     = mu(eta_t1, Z_t0) - mu(eta_t0, Z_t0)
Measurement shift component = mu(eta_t0, Z_t1) - mu(eta_t0, Z_t0)
Interaction component       = Total change - Latent component - Measurement component
```

즉 잠재 성분은 공변량을 `t0`에 고정한 채 잠재값만 변화시킨 반사실적 변화이고, 측정 성분은 잠재값을 `t0`에 고정한 채 공변량(따라서 문항 모수)만 변화시킨 반사실적 변화이다.

**경로의존성과 대칭 분해.** 위 분해는 "무엇을 먼저 바꾸는가"에 따라 잠재·측정 귀속이 달라지는 경로의존성(order dependence)을 가진다. interaction 항이 비가법성을 흡수하지만, 그 결과 "측정 성분 X%"라는 진술의 일의성은 약해진다. 본 연구는 (1) 기준 분해의 순서를 명시적으로 보고하고, (2) 순서를 뒤집은 분해를 민감도 분석으로 함께 제시하며, (3) 두 순서의 평균에 해당하는 **Shapley형 대칭 분해**를 대안 정의로 검토한다. 이로써 RSDI가 분해 순서 선택에 얼마나 민감한지를 투명하게 드러낸다.

## 3.3 RSDI 정의

문항별 반응 이동 기여율을 다음과 같이 정의한다.

```text
RSDI = |Measurement shift component|
       / ( |Latent change component| + |Measurement shift component| + |Interaction component| )
```

위 식의 `mu`와 `|·|`는 개념적 표기이다. 순서형 반응에 맞는 **형식적 정의**(범주확률 척도 `m_j`와 총변동거리 `||·||_TV` 기반)는 §3.5.1에 제시한다. 두 표기는 동일한 분해 논리의 개념판과 형식판이다.

**예시(illustrative).** 만약 어떤 문항에서 `RSDI = 0.70`이라면, 이는 해당 문항의 예측 반응 변화 중 상당 부분이 잠재 스트레스 변화보다 측정기능 이동과 관련됨을 의미한다. *이 값은 설명을 위한 예시이며 자료에서 추정된 값이 아니다.*

**경계 불안정성.** RSDI는 분모(총 변동량의 절대값 합)가 0에 가까운 문항—즉 종단 변화가 거의 없는 문항—에서 비율이 불안정해진다. 따라서 본 연구는 (1) 분모가 일정 임계 미만인 문항은 RSDI를 보고하지 않거나 "정의 약함"으로 표시하고, (2) RSDI를 점추정이 아닌 사후분포로 제시하여 불안정성이 넓은 신뢰구간으로 드러나도록 하며, (3) 필요 시 약한 정규화(분모 안정화 항)를 민감도 분석으로 검토한다. 또한 절대값 기반 비율은 분산분해처럼 가법적이지 않으므로, RSDI는 "기여율의 분산분해"가 아니라 "측정이동 상대크기 지표"로 해석함을 명시한다.

## 3.4 불확실성 추정

각 posterior draw마다 위 세 성분과 RSDI를 계산하여, 문항별 RSDI의 사후분포(점추정 + 신뢰구간)를 얻는다. 이로써 "이 문항의 반응 이동 기여율이 유의하게 큰가"를 불확실성과 함께 판단한다.

## 3.5 식별과 가정 (계획 단계에서 명확히 할 사항)

**분해의 조건부 정의.** 핵심 쟁점은 MNLFA에서 잠재분포 자체가 공변량에 의존(latent impact)할 수 있다는 점이다. 즉 `eta_it ~ f(· | Z_it)`이면 "`Z`를 t0에 고정한 채 `eta`만 t1로"라는 조작의 의미가 모호해진다. 본 연구는 이를 다음과 같이 정리한다.

- **개인 조건부(person-conditional) RSDI:** 개인 `i`의 posterior `eta_it` draw를 *주어진 값*으로 간주하고, 문항모수에 들어가는 측정용 공변량만 t0↔t1로 교체한다. 이때 잠재 성분은 "그 사람의 잠재값이 실제로 이동한 효과", 측정 성분은 "같은 잠재값이라도 문항이 다르게 기능한 효과"로 해석된다. 이는 latent impact(잠재 평균의 Z 의존성)를 잠재 성분 쪽에 귀속시킨다.
- **모집단(population-level) RSDI:** 잠재분포를 Z로 적분하여 집단 수준 기대량에서 분해한다. 이 경우 latent impact의 귀속 방식을 별도로 규정해야 한다.

본 연구는 **개인 조건부 정의를 기본**으로 하고 모집단 정의를 보조로 보고하며, 두 정의가 주는 해석 차이를 명시한다.

### 3.5.1 형식적 정식화

순서형 문항 `j`(범주 `0, …, K_j`)에 대해 누적 로짓(graded response) 측정모형을 다음과 같이 둔다. 측정용 공변량 벡터를 `Z`라 할 때,

```text
P(Y_itj >= k | eta_it, Z_it) = inv_logit( a_j(Z_it) * eta_it - tau_jk(Z_it) ),   k = 1, …, K_j
```

여기서 문항모수는 공변량의 함수(MNLFA moderation)이다.

```text
a_j(Z)    = exp(ell_j0 + ell_j' Z)  (양의 적재량을 위한 log-linear moderation)
tau_jk(Z) = tau_jk0 + b_j' Z        (역치 이동: threshold moderation)
```

잠재 구조모형에서는 잠재 평균이 시간·공변량의 함수일 수 있다(잠재 영향, latent impact).

```text
eta_it = g(t, Z_it ; structural params) + zeta_it,   zeta_it ~ N(0, psi)
```

문항 `j`의 **측정함수**를 범주확률 벡터로 정의한다.

```text
m_j(eta, Z) = ( P(Y=0 | eta, Z), …, P(Y=K_j | eta, Z) )
```

개인 조건부 정의에서, 개인 `i`의 사후 draw `eta_it0, eta_it1`을 *주어진 값*으로 두고 측정용 공변량만 시점 간 교체하여 분해한다.

```text
Total_ij       = m_j(eta_it1, Z_it1) - m_j(eta_it0, Z_it0)
Latent_ij      = m_j(eta_it1, Z_it0) - m_j(eta_it0, Z_it0)
Measurement_ij = m_j(eta_it0, Z_it1) - m_j(eta_it0, Z_it0)
Interaction_ij = Total_ij - Latent_ij - Measurement_ij
```

각 성분은 확률벡터의 차이이므로 스칼라 요약이 필요하다. 본 연구는 총변동거리(total variation)로 크기를 집약한다.

```text
||D||_TV = (1/2) * sum_k | D_k |
```

따라서 개인·문항 RSDI는

```text
RSDI_ij = ||Measurement_ij||_TV
          / ( ||Latent_ij||_TV + ||Measurement_ij||_TV + ||Interaction_ij||_TV )
```

이며, 문항 수준 RSDI는 개인 집계(분자·분모를 개인 평균한 뒤 비율) 후 **사후 draw마다 계산하여 사후분포**로 보고한다. 잠재 영향(`g`의 `Z` 의존)은 개인 조건부 정의에서 실현된 `eta_it1`에 이미 반영되므로 잠재 성분에 귀속된다. 이것이 모집단 정의(잠재분포를 `Z`로 적분)와의 핵심 해석 차이다.

### 3.5.2 식별 가정 (명시적)

위 분해가 의미를 가지려면 다음 가정이 필요하며, 본 연구는 이를 단순 전제가 아니라 **검토·점검 대상**으로 삼는다.

- **(A1) 함수형 정확성.** 문항모수의 `Z` 의존이 가정한 모수형(예: 선형 moderation)을 따른다. 위반 시 측정 성분이 편향 — 시뮬레이션 민감도 점검.
- **(A2) 국소 독립.** `eta, Z` 조건부로 문항 응답이 독립이다.
- **(A3) 관측 공변량 한정성.** 측정 성분은 *모형에 포함된* `Z`에 의한 이동만 포착한다. 누락 조절자가 있으면 편향될 수 있으므로, RSDI는 "포함 공변량에 조건부(conditional-on-Z)" 지표로 해석한다.
- **(A4) 종단 척도 식별.** 잠재 척도가 시점 간 비교 가능하도록 앵커(불변 참조 모수) 또는 분포 고정으로 식별된다.
- **(A5) 공변량 측정.** 측정-이동 반사실이 의미를 가지려면 `Z`가 (근사적으로) 오차 없이 측정되거나 측정오차가 모형화되어야 한다.

또한 측정용 공변량(문항모수 예측)과 구조용 공변량(잠재 예측)의 역할을 분리하여, 같은 변수가 두 경로로 들어갈 때 분해 해석이 어떻게 달라지는지 명시한다.

### 3.5.3 인과가 아니라 모형함의(model-implied)

위 `Latent/Measurement` 항은 자료에 대한 *개입(do-operator)*이 아니라 적합된 posterior의 **함수(functional)**다. 즉 "Z를 t1로 바꾸면 측정함수가 이렇게 달라진다"는 모형 내부의 반사실 평가이지 외생적 조작의 인과효과가 아니다. 본 연구가 "counterfactual"과 "model-implied decomposition"을 병기하는 이유가 여기에 있으며, 인과 해석은 (A1)–(A5)에 더해 강한 가정을 요구하므로 본 연구의 주장 범위를 벗어난다.

### 3.5.4 전체 측정이동과 공변량별 귀속

기본 RSDI는 `Z` 벡터 전체를 `t0`에서 `t1`로 바꾸어 계산한다. 따라서 기본값은 차별경험만의 RSDI가 아니라, 모형에 포함된 연령·한국어 능력·소득·차별경험 변화가 함께 반영된 **전체 측정기능 이동 지표**다. 차별경험의 역할은 다음과 같이 별도로 보고한다.

1. 잠재값과 다른 공변량을 고정하고 차별경험만 0에서 1로 바꾸는 문항별 범주확률 및 기대응답 대비
2. 실제 시점 간 분해에서 차별경험만 교체한 단일공변량 measurement component
3. 여러 공변량의 순서에 따른 귀속 차이가 클 때 공변량별 Shapley 평균

현재 예비 산출물의 W1–W5 RSDI는 전체 `Z` 변화에 대한 item-level RSDI의 문항 평균이다. 차별경험 0/1 고정-잠재 대비는 별도 결과이며 RSDI와 동일한 양으로 부르지 않는다.
문항 `j`와 posterior draw `s`의 표본집계량은 다음과 같이 사전 고정한다.

```text
RSDI_j^(s) = sum_i w_i ||M_ij^(s)||_TV
             / sum_i w_i (||L_ij^(s)||_TV + ||M_ij^(s)||_TV + ||I_ij^(s)||_TV)
```

기본 가중치 `w_i`는 시점쌍에 모두 관찰된 개인의 동일가중치이며, 중도탈락 역확률가중치 결과를 민감도로 보고한다. 척도수준 RSDI_all-Z는 문항별 분자와 분모를 각각 합한 뒤 비율을 계산하는 값을 주 estimand로 하고, 문항별 RSDI의 산술평균은 기존 예비 산출물과의 비교용으로만 제시한다. 분모 임계값과 임계 미달 비율을 함께 보고한다. RSDI는 총변화의 가법적 설명률이 아니라 성분벡터 크기의 상대지표다.

### 3.5.5 식별은 검증할 조건이다

posterior draw가 계산되었다는 사실만으로 잠재척도와 측정기능 분해가 식별되었다고 결론내릴 수는 없다. 현재 Stan 구현은 적재량의 부호를 양수로 고정하고 역치 순서를 보장하지만, 기준문항 적재량이나 잠재분산을 고정하지 않았고 모든 문항에 공변량 관련 DIF를 허용한다. 따라서 적재량과 잠재척도의 역비례 변환, 잠재상태 효과와 공통 DIF의 분리에서 약한 식별이 남을 수 있다. 현재 VI 결과는 사전분포에 의해 정규화된 탐색적 추정으로 간주한다.

최종 주모형의 **1차 식별전략**은 기준시점의 잠재평균을 0, 잠재분산을 1로 고정하고, 외부 단일시점 검증과 문항내용을 이용해 공변량별로 최소 두 개의 후보 앵커 문항을 분석 전에 지정하는 것이다. 후보 앵커에서는 해당 공변량의 loading-DIF와 threshold-DIF를 0으로 고정한다. 앵커 선택은 종단 결과나 RSDI 크기를 보고 바꾸지 않는다.

공통 DIF를 식별할 외부 앵커가 충분하지 않은 공변량에는 effects-coded 제약을 사용하되, 이 경우 DIF와 RSDI를 “평균 문항 대비 상대적 측정기능 이동”으로 제한해 해석한다. 대체 앵커 세트와 iterative purification은 민감도 분석으로 두고, 앵커를 바꾸었을 때 RSDI의 방향·문항순위 또는 신용구간이 실질적으로 달라지면 해당 RSDI의 실질적 해석을 중단한다.

추가 검증 조건은 다음과 같다.

- 같은 잠재수준 근방에서 공변량이 변하는 충분한 지지영역과 positivity
- 측정경로와 잠재상태 경로에 같은 공변량이 들어갈 때의 구조적 분리조건
- 문항범주 코딩, 빈 범주, 평행 역치 DIF 가정, hard clipping에 대한 민감도
- 기준 앵커, 대체 앵커, effects-coded 모형에서 잠재기울기·DIF 순위·RSDI의 안정성

이 조건은 분석 전에 앵커 대안별 모형 비교와 prior predictive check로 점검한다. 논문 2에서는 약한 앵커, 누락 조절자, `Z–eta` 공선성, 함수형 오설정, 결측·중도탈락을 자료생성 조건으로 조작한다. 논문 3에서는 식별이 확보된 소·중규모 모형의 NUTS posterior를 기준으로 VI 근사오차를 평가한다. 따라서 본 프로포절은 RSDI의 식별을 완결된 정리로 주장하지 않고, 식별조건과 실패영역을 박사학위 연구에서 확립해야 할 대상으로 둔다.



### 3.5.6 사전분포와 DIF 보고 규칙

예비모형은 base log-loading에 `Normal(0, 0.35)`, loading-DIF에 `Normal(0, 0.20)`, 평행 threshold-DIF와 latent-state effect에 `Normal(0, 0.35)`, 평균기울기에 `Normal(0, 0.50)`, 성장 표준편차에 `half-Normal(0, 0.75)`, 성장 상관에 `LKJ(2)`, occasion 표준편차에 `half-Normal(0, 0.50)`을 사용한다. 최종 hyperparameter는 prior predictive check에서 범주확률과 잠재궤적이 비현실적으로 포화되지 않는 범위로 조정하고, 최소 두 개의 prior scale을 민감도 분석한다.

DIF는 단순히 근사구간이 0을 제외하는지로 판정하지 않는다. 문항별 범주확률에서 사전 정의한 실질적 변화량을 초과할 posterior probability, 효과의 문항순위, 앵커·prior·추정법에 대한 방향 안정성을 함께 보고한다. 현재 90% 구간은 “mean-field variational posterior의 5–95% 분위수”로 부르며 실제 posterior coverage를 뜻하지 않는다.

## 3.6 예상되는 반론: RSDI는 DIF 계수의 재포장인가

제기될 수 있는 핵심 반론은 "RSDI가 결국 MNLFA가 이미 추정한 DIF 계수의 재표현 아닌가"이다. 이에 대한 본 연구의 입장은 다음과 같다. DIF 계수는 *문항모수가 공변량에 의존하는 정도*를 나타내는 모형 내부량이다. 반면 RSDI는 *관찰된 종단 반응변화량*을 분모로 두고 그 중 측정이동이 차지하는 **상대적 기여**를 나타낸다. 동일한 DIF 계수라도 (1) 공변량이 시간에 따라 얼마나 변했는지, (2) 잠재값이 얼마나 변했는지에 따라 RSDI는 크게 달라진다. 즉 RSDI는 DIF의 크기뿐 아니라 *실제 종단 변화 맥락에서의 작동량*을 반영하므로 DIF 계수와 일대일 대응되지 않는다. 이 점이 응용 종단 해석에서 RSDI가 추가하는 정보이다.

---

# 4. 논문 1: MAPS 실증분석과 예비근거

## 4.1 연구 질문

MAPS 부모 문화적응 스트레스 자료에서 관찰점수 성장모형, 측정불변 순서형 잠재성장모형, 시간가변 DIF를 허용한 종단 MNLFA는 종단 변화에 대해 어떤 해석 차이를 만드는가? 전체 공변량 관련 측정기능 변화의 상대적 크기는 RSDI로 어떻게 요약되며, 그중 차별경험의 고정-잠재 대비는 문항별 범주확률에서 어떤 방향과 크기를 보이는가?

## 4.2 자료와 측정

논문 1은 MAPS 2기 부모 패널의 1–5차 자료를 사용한다. 문화적응 스트레스는 5점 순서형 8문항으로 측정하며, 문항기능 조절변수에는 웨이브 내 중심화 부모 연령, 한국어 능력, 로그소득, 차별경험 0/1 지표를 포함한다. 구조상태 강건성 모형에서는 한국어 능력, 소득, 차별경험을 개인간 성분과 개인내 성분으로 분해하여 잠재상태에도 투입한다. 원자료는 프로젝트 저장소에 복사하지 않고 별도의 통제된 위치에서 관리한다. 결측 예측변수에 대한 현재 예비분석은 완전사례 방식이므로, 최종 분석에서는 시점별 유효표본, 중도탈락, 결측패턴과 선택편향 가능성을 명시한다.

Item 1·2·6 제외 민감도 분석에는 2,190명, 5개 시점, 잔여 5문항의 48,225개 문항반응이 포함되었다. 이 수치는 민감도 모형의 분석표본이며, 8문항 주모형의 최종 표본 기술은 재현 스크립트에서 별도로 확정한다.

## 4.3 분석 모형

1. 개인-웨이브 평균 범주를 결과로 하는 naive 관찰점수 선형혼합모형
2. 문항 적재량과 역치를 시간·공변량에 걸쳐 고정한 측정불변 순서형 잠재성장모형
3. 문항 적재량과 평행 역치 이동을 시간가변 공변량의 함수로 둔 베이지안 종단 순서형 MNLFA
4. 동일 공변량의 개인간·개인내 성분을 잠재상태에도 투입한 structural-state 강건성 모형
5. posterior draw별 범주확률을 이용한 전체 `Z` 변화의 시점쌍 RSDI 분해와 별도의 차별경험 0/1 고정-잠재 대비

주모형은 개인별 상관된 잠재 절편·기울기와 개인-시점 occasion residual을 포함한다. 적재량은 양수 로그선형 함수이며 역치 DIF는 문항 내 모든 역치를 같은 양만큼 이동시키는 평행 역치 DIF이다. 이 제약은 해석 가능성을 높이지만 범주별 비평행 DIF를 표현하지 못하므로 논문 2의 모형 오설정 조건과 민감도 분석에서 다룬다.

## 4.4 RSDI 산출

각 posterior draw, 개인, 문항, 시점쌍에서 예측 범주확률 벡터를 계산한 뒤 잠재값만 변화시킨 반사실, 측정공변량만 변화시킨 반사실, 둘을 모두 변화시킨 관찰경로를 비교한다. 세 성분의 크기는 총변동거리로 요약하고, 측정기능 변화 크기를 잠재변화·측정변화·상호작용 크기의 합으로 나누어 RSDI를 계산한다. W1–W5 전 구간과 인접 시점쌍을 함께 보고한다. 기본 분해의 경로의존성은 역순 분해와 Shapley형 대칭 분해를 이용해 점검한다.

## 4.5 예비결과

| 분석 | 예비 추정 | 해석 범위 |
|---|---:|---|
| 관찰점수 LME 시간기울기 | -0.042 | 평균 관찰범주 척도의 기술적 비교량 |
| 측정불변 순서형 LGM 기울기 | -0.222, mean-field variational 5–95% 분위수 [-0.239, -0.205] | 잠재척도 추정치. 관찰점수 기울기와 크기를 직접 비교하지 않음 |
| structural-state MNLFA 기울기 | 평균 -0.210, seed 범위 [-0.260, -0.164] | 4회 mean-field VI의 초기값 민감도 범위이며 CrI가 아님 |
| 8문항 전체-`Z` RSDI 문항평균, W1–W5 | 0.360, approximate mean-field variational 5–95% 분위수 [0.324, 0.396] | 근사 posterior 기반 예비 분해 |
| Item 1·2·6 제외 전체-`Z` RSDI 문항평균, W1–W5 | 0.260, approximate mean-field variational 5–95% 분위수 [0.231, 0.334] | 의미중첩을 줄인 민감도 결과 |

네 개의 독립적 VI 실행에서 차별경험 관련 평행 역치 DIF의 variational solution은 8개 문항 모두 음의 방향이었고 각 실행의 5–95% 분위수가 0을 제외하였다. 가장 큰 효과는 Item 2, 6, 1에서 나타났다. 음의 계수는 같은 잠재수준에서 차별경험이 보고된 경우 더 높은 응답범주를 선택하기 쉬운 방향을 뜻한다. 다만 기존 subset NUTS는 이전 measurement-only 모형의 제한된 부분표본 보정이다. Item 1·2·6·7·8의 큰 threshold DIF와 방향이 대체로 일치했지만, 최신 structural-state 모형 전체나 정확한 RSDI 분포를 확증하지는 않는다.

Item 1·2·6을 제외하면 측정기능 변화의 상대적 크기는 줄었으나 사라지지 않았다. 잔여 문항의 threshold DIF와 RSDI는 결과가 특정 문항의 의미중첩에만 의존하지 않을 가능성을 보여준다. 그러나 이 분석도 VI 기반이므로 최종 결론은 앵커 기반 척도식별, 선택모형 장기 NUTS, 결측처리, 분해순서 민감도 검증 이후 확정한다.

## 4.6 논문 1의 산출물

- 세 비교모형의 추정량과 서로 다른 척도의 해석표
- 문항별 차별경험 관련 loading·threshold DIF forest plot
- 인접 시점쌍 및 W1–W5 문항별 RSDI posterior summary
- 8문항 모형과 Item 1·2·6 제외 민감도 모형 비교
- 반복 VI 및 축소·선택모형 NUTS calibration 보고서

---


# 5. 논문 2: Monte Carlo 시뮬레이션 (계획)

## 5.1 연구 질문

시간가변 역치/적재 DIF가 존재할 때, 측정 불변성을 가정한 성장모형은 잠재 기울기를 얼마나 편향되게 추정하는가? MNLFA/RSDI는 잠재 기울기와 DIF, RSDI를 얼마나 회복하는가?

## 5.2 단계적 설계

자료생성모형은 §3의 graded-response MNLFA를 사용한다. 계산량과 논문 3의 목적을 분리하기 위해 한 번에 단계적 후보 셀을 모두 수행하지 않고 세 단계로 확장한다.

| 단계 | 요인 | 목적 |
|---|---|---|
| 1. 핵심 회복 | `N`(300/600/1200), 웨이브(3/5), DIF 크기(0/중/대), DIF 유형(역치/역치+적재), 공변량 추세(정적/증가) | 기울기·DIF·RSDI의 기본 회복영역 확인 |
| 2. 식별 stress test | DIF 문항비율, 약한 앵커, 누락 조절자, `Z–eta` 공선성, 비선형 moderation | RSDI의 실패영역과 보고중단 기준 도출 |
| 3. 자료복잡성 | 결측·중도탈락, 희소범주, 비평행 역치 DIF, MAPS 유사 공변량 분포 | 실증 적용의 강건성 평가 |

각 단계는 소규모 pilot으로 실행시간과 실패율을 추정한 뒤 반복수를 정한다. 일률적으로 셀당 500회를 고정하지 않고, 편향·coverage·실패율의 Monte Carlo 표준오차가 사전 기준 이하가 되도록 반복수를 결정한다. Paper 2는 estimand와 모형의 통계적 성질에 집중하고, VI와 NUTS의 알고리즘 비교는 Paper 3에서 수행한다.

비교모형은 naive 관찰점수 성장모형, 측정불변 순서형 LGM, 정답구조 MNLFA, 선택적 오설정 MNLFA로 구성한다. true RSDI의 집계 규칙, 분모 임계값, 기본·역순·Shapley 분해는 simulation 실행 전에 고정한다.


## 5.3 평가 지표 (지표별 정의)

| 지표 | 정의 | 대상 |
|---|---|---|
| 잠재 기울기 편향 | `E[hat_slope] - true_slope` (상대편향 병기) | 모형 1·2·3 비교 |
| 기울기 RMSE | 평균제곱근오차 | 모형 비교 |
| 포함확률(coverage) | 95% 구간이 진값을 포함한 비율(목표 ≈ .95) | 기울기·DIF·RSDI |
| DIF 회복 | DIF 계수 편향·RMSE | 모형 3 |
| 거짓양성 DIF | DIF 없는 문항을 DIF로 판정한 비율 | 모형 3 |
| 검정력(power) | 실제 DIF 문항을 탐지한 비율 | 모형 3 |
| **RSDI 회복** | DGM 진값에서 계산한 true RSDI 대비 추정 RSDI의 편향·RMSE·coverage | 핵심 지표 |
| 식별 저하 점검 | (F1 누락조절자·F2 공선성·F3 앵커부재) 조건에서 RSDI 회복 변화 | §3.5.5 연결 |

각 지표는 시점쌍(인접/전구간)별로 집계하며, Monte Carlo 표준오차를 함께 보고한다.

## 5.4 기대 기여

(1) DIF를 무시할 때 잠재 기울기 해석이 편향되는 조건(크기·추세·비율)을 정량적으로 지도화하고, (2) MNLFA/RSDI가 그 편향을 분해·회복하는 조건과 한계(식별 저하 3경우, §3.5.4)를 제시하며, (3) 응용 연구자를 위한 "언제 RSDI를 신뢰할 수 있는가"의 실무 가이드라인을 도출한다.

---

# 6. 논문 3: 추정전략 비교 (계획)

## 6.1 연구 질문

논문 3은 논문 1·2와의 응집력을 위해 **"RSDI 추정이 근사추론에서 얼마나 신뢰 가능한가"**라는 축으로 묶인다. 즉 단순한 일반적 추정전략 비교가 아니라, 본 연구의 핵심 산출물인 RSDI(및 그 사후 불확실성)가 추정전략에 따라 얼마나 안정적으로 회복되는지를 평가한다. 구체적으로: 고차원 종단 순서형 MNLFA에서 VI, Pathfinder/full-rank VI, subset NUTS, 선택적 NUTS 중 무엇을 어디까지 신뢰할 수 있으며, **각 전략이 RSDI 점추정·구간을 정확 posterior(기준) 대비 어느 정도로 재현하는가?**

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


## 6.4 평가 지표

| 지표 | 정의 |
|---|---|
| 모수 점추정 일치 | 근사 vs 기준 posterior 평균 차이(표준화) |
| **RSDI 일치** | 근사 RSDI vs 기준 RSDI 편향·RMSE |
| 구간 보정 | 90/95% 구간 폭·포함률(기준 대비 과소·과대) |
| 순위 일치 | DIF·RSDI 문항 *순위* 상관(스크리닝 적합성: 상위 문항 식별력) |
| 진단 | divergence 수, R-hat, ESS, treedepth, E-BFMI; PSIS를 실제 적용할 때만 Pareto-k |
| 비용 | 벽시계 시간·메모리(동일 하드웨어) |


Paper 2는 고정된 한 가지 추정법을 사용하여 estimand·앵커·공선성·결측 조건의 통계적 성질을 DGM 진값과 비교한다. Paper 3은 Paper 2에서 선정한 6–12개 benchmark regime만 사용하여 동일 posterior target에 대한 알고리즘 오차와 계산비용을 비교한다. 따라서 Paper 2의 질문은 “RSDI가 언제 회복되는가”, Paper 3의 질문은 “어떤 계산법이 같은 posterior functional을 얼마나 재현하는가”로 분리된다.

## 6.5 핵심 주장

Full NUTS가 항상 현실적이지 않은 대규모 종단 순서형 MNLFA에서, **근사추론(스크리닝)과 정확 posterior 검증(calibration)을 결합한 2단계 워크플로**가 필요하다. 특히 점추정은 근사가 잘 맞더라도 **구간(불확실성)과 RSDI는 전략에 따라 달라질 수 있으므로**, "어떤 양을 어떤 전략으로 신뢰할 수 있는가"를 분리해 권고한다. 이 워크플로와 권고 자체가 논문 3의 기여이다.

---

# 7. 통합 논의

## 7.1 세 논문의 연결

논문 1은 실증 적용에서 문제의 존재와 RSDI의 활용을 보인다. 논문 2는 시뮬레이션으로 방법의 통계적 성질을 검증한다. 논문 3은 대규모 추정의 실행 가능성을 확보한다. 세 논문은 "문제 제기 → 성질 검증 → 실행 가능성"으로 연결된다.

## 7.2 기대 학문적 기여와 적용 범위

시간가변 측정 비불변성이 종단 성장 해석에 미치는 영향을 분해·정량화하는 estimand와 분석 워크플로를 제시한다. 핵심은 이 기여가 **도메인 일반적(domain-general)**이라는 점이다. RSDI/반사실(모형함의) 분해에는 다문화 특수적 요소가 없으며, "시간가변 공변량이 문항기능을 바꿀 수 있는 순서형 패널"이면 어디에나 적용된다. 다문화 사례(논문 1)는 적용 *범위*가 아니라 방법의 가치를 보여주는 *시연*이며, 일반성은 도메인 무관한 Monte Carlo 검증(논문 2)이 직접 뒷받침한다.

교차도메인 적용 예시는 다음과 같다.

- **건강관련 삶의 질(HRQoL):** 반응 이동 이론의 본고장. 질병 경과·치료에 따라 환자가 내적 기준을 재조정(recalibration)할 때, 관찰된 점수 변화에서 진짜 변화와 반응 이동을 분리.
- **임상 증상 척도:** 치료·병식 변화 등 시간가변 요인이 증상 문항 응답기준을 바꾸는 경우.
- **노화·인지 패널:** 연령·건강상태가 자기보고 문항기능을 이동시키는 경우.
- **교육·심리검사 종단:** 학년·교육경험 등 시간가변 공변량에 따른 문항기능 변화.

이처럼 본 프레임워크는 반응 이동 또는 시간가변 DIF가 우려되는 폭넓은 순서형 패널 연구에 이전 가능하다.

## 7.3 한계 (계획 단계에서 명시)

- RSDI의 식별 조건과 경계 행동에 대한 추가 검토 필요
- 인과 해석 불가(관찰 패턴의 일관성 수준의 주장)
- 추정 근사에 따른 편향 가능성(논문 3에서 다룸)
- **단일 실증 도메인의 제약:** 실증 시연이 다문화 문화적응 스트레스 한 도메인에 기반한다. 방법의 일반성은 Monte Carlo(논문 2)가 뒷받침하지만, 서로 다른 척도·구성개념에서의 경험적 일반화는 제한된다. **향후 과제로 이질적 제2 도메인(예: HRQoL 또는 임상 증상 척도) 실증 적용**을 명시한다.
- 선행 MAPS DIF 근거의 독립성 한계(같은 연구 프로그램 내부 근거)


**결측·중도탈락 계획.** 결과문항 결측은 관측된 응답의 MAR likelihood로 처리한다. 시간가변 공변량 결측은 multilevel multiple imputation 또는 공동 베이지안 모형 중 prior predictive pilot이 안정적인 방식을 주분석으로 사전 지정한다. 중도탈락은 response-probability weighting과 pattern-mixture delta sensitivity로 점검하며, 완전사례 결과는 민감도 분석으로만 유지한다. 모든 연속 공변량은 pooled scale과 개인평균/개인내 편차 분해를 비교하고, response-shift 해석은 주로 within-person 성분에 한정한다.

## 7.4 실행가능성 선결과제 (Feasibility Prerequisites)

분석 자료(MAPS 부모 패널)는 확보되어 있고, 시간가변 공변량이 매 웨이브 측정되어 있으며 활용 가능한 웨이브가 3개 이상이다. 따라서 자료 접근·IRB와 "분해 가능성"의 핵심 조건은 이미 충족되어 선결과제에서 제외된다. 남은 확인 사항은 설계 미세조정 수준이다.

- 문화적응 스트레스 8문항의 시점 간 동일성(문항 표현 변경·추가 여부)
- 최종 표본 크기·중도탈락·결측 구조(시점쌍별 유효표본)
- 순서형 베이지안 종단 MNLFA의 계산 부담(→ 논문 3의 추정전략 필요성과 연결)

자료 구조가 이상적(매 웨이브 측정 + 3웨이브 이상)이므로, §4.3.1의 다중 시점쌍 RSDI 설계를 제약 없이 적용할 수 있다.

## 7.5 연구 일정

분석 자료의 접근경로는 확보되어 있으나 IRB 승인 또는 면제 여부와 자료이용 조건은 별도로 확인해야 한다. 이를 초기 단계에 병행한다는 조건에서 프로포절 승인 이후 약 **2년**을 목표로 상정한다(풀타임 기준). 아래는 분기(Q) 단위 개략 간트이다. 단계 길이는 범위로 표기하며, 자료 리스크가 빠진 만큼 남은 핵심 일정 리스크는 식별 이론(§3.5) 정립과 논문 2·3의 계산 부담이다.

```text
단계                          Y1Q1 Y1Q2 Y1Q3 Y1Q4 Y2Q1 Y2Q2 Y2Q3 Y2Q4
S0 자료구조·IRB·이용조건 확인  ███  ░░░                                      (접근경로와 윤리승인을 구분)
S1 식별 이론(§3.5) 정립        ███  ███  ░░░                                  (리스크: 최대 6개월)
S2 코드 프로토타입             ░░░  ███  ███
S3 논문 3 추정전략(선행 일부)        ███  ███  ███                           (1·2의 추정시간 절감)
S4 논문 1 MAPS 실증                  ███  ███  ███                           (자료 확보로 조기 착수)
S5 논문 2 Monte Carlo                     ███  ███  ███  ███               (계산 폭발 주의)
S6 논문 3 마무리                               ███  ███
S7 통합·심사·수정                                   ███  ███  ███
```

설계 의도는 다음과 같다.

- **리스크 선행 배치:** 최대 변수인 식별 이론(S1)과 자료 확인(S0)을 Y1 전반에 앞당겨, 막힐 경우 조기에 설계를 조정한다.
- **추정전략 조기 착수:** 논문 3의 일부(S3)를 먼저 진행해 논문 1·2의 추정 시간을 줄이는 선순환을 만든다.
- **병렬화:** 논문 2 시뮬레이션(S5)을 백그라운드로 돌리며 논문 1(S4) 작성을 병행한다.

**2년 달성 조건.** 자료가 확보된 상태이므로, 식별 이론(§3.5)이 약 6개월 내 정리되고 계산 인프라(클러스터/GPU)가 확보되면 Y2 말 완료가 현실적이다. 일정이 빠듯하면 논문 3을 짧은 방법노트/부록으로 축소(plan B)하여 논문 1·2에 집중한다. 반대로 식별 이론이나 계산에서 한 번 막히면 2.5년으로 늘어날 수 있다. *구체 일정은 §3.5 정립 결과와 확보 자료의 구조(웨이브·공변량 측정 시점)에 따라 확정한다.*

---

# 8. 연구윤리 및 필수 고지

**자료 가용성(Data Availability).** MAPS 원자료는 이 프로젝트 저장소에 포함하지 않으며 별도의 통제된 경로에서 관리한다. 공개·배포 가능 범위는 자료제공기관의 이용규정에 따른다. 분석 코드와 공개 가능한 집계 산출물은 재현 가능한 형태로 정리하되, 원자료나 개인식별 가능 정보는 배포하지 않는다.

**연구윤리(Ethics).** 본 연구는 인간대상 2차 자료분석이다. 최종 제출 전 소속기관 IRB의 심의·면제 여부, MAPS 자료이용 승인번호, 원 조사 동의절차를 확인하여 정확한 문구와 번호를 삽입한다.

**이해상충(Conflict of Interest).** 현재 보고된 이해상충은 없다. 최종 제출 시 다시 확인한다.

**연구비(Funding).** 연구비 정보가 현재 문서에 확인되지 않았다. 지원이 없으면 “별도의 연구비 지원을 받지 않았다”고 명시하고, 지원이 있으면 기관명과 과제번호를 삽입한다.

**저자 기여(CRediT).** 단독 학위논문을 전제로 연구자가 conceptualization, methodology, software, formal analysis, validation, visualization, writing을 담당한다. 지도·자문 또는 공동연구자의 기여는 최종 저자정책과 CRediT 역할에 따라 기록한다.

**AI 활용 고지(AI Disclosure).** 본 연구계획서의 구조화, 문장 편집, 코드·인용 점검에 생성형 AI 도구를 보조적으로 사용하였다. 연구질문 확정, 모형 선택, 자료분석, 결과 해석, 문헌 원문 확인과 최종 문구의 책임은 연구자에게 있다. RSDI는 AI 산출물을 그대로 채택한 결과가 아니라 연구자가 수식, 코드, 식별조건, simulation을 통해 검증해야 하는 개발 대상 estimand이다.

---


# 참고문헌 (References)

> **참고문헌 상태.** DOI가 있는 핵심 문헌은 공식 DOI 또는 색인정보로 재검증한다. 2026년 3월 온라인 선출판된 Chen and Bauer의 종단 MNLFA 시뮬레이션 논문은 PubMed와 DOI `10.1080/00273171.2026.2640576`에서 실재가 확인되었다. 이전 초안에서 이 문헌을 허위로 판정했던 메모는 현재 정보와 모순되어 폐기한다. Lee and Choi (2026) 등 DOI가 없는 국내문헌은 KCI/학술지 원문에서 최종 서지사항을 확인하기 전까지 검토표시를 유지한다.

Bauer, D. J. (2017). A more general model for testing measurement invariance and differential item functioning. *Psychological Methods*. https://doi.org/10.1037/met0000077

Bauer, D. J., Belzak, W. C. M., & Cole, V. T. (2020). Simplifying the assessment of measurement invariance over multiple background variables: Using regularized moderated nonlinear factor analysis to detect differential item functioning. *Structural Equation Modeling: A Multidisciplinary Journal, 27*(1), 43–55. https://doi.org/10.1080/10705511.2019.1642754

Chen, S. M., & Bauer, D. J. (2024). Modeling construct change over time amidst potential changes in construct measurement: A longitudinal moderated factor analysis approach. *Psychological Methods*. https://doi.org/10.1037/met0000685

Chen, S. M., & Bauer, D. J. (2026). Improving the evaluation of construct change over time: Advantages of longitudinal moderated nonlinear factor analysis over conventional first-order growth models. *Multivariate Behavioral Research*. Advance online publication. https://doi.org/10.1080/00273171.2026.2640576
Blei, D. M., Kucukelbir, A., & McAuliffe, J. D. (2017). Variational inference: A review for statisticians. *Journal of the American Statistical Association, 112*(518), 859–877. https://doi.org/10.1080/01621459.2017.1285773

Vehtari, A., Gelman, A., Simpson, D., Carpenter, B., & Bürkner, P.-C. (2021). Rank-normalization, folding, and localization: An improved R-hat for assessing convergence of MCMC. *Bayesian Analysis, 16*(2), 667–718. https://doi.org/10.1214/20-BA1221

Kim, E. S., & Willson, V. L. (2014). Measurement invariance across groups in latent growth modeling. *Structural Equation Modeling, 21*(3). https://doi.org/10.1080/10705511.2014.915374

King-Kallimanis, B. L., Oort, F. J., & Garst, G. J. A. (2010). Using structural equation modelling to detect measurement bias and response shift in longitudinal data. *AStA Advances in Statistical Analysis, 94*. https://doi.org/10.1007/s10182-010-0129-y

이창현, & 최윤영. (2026). 등급반응모형(GRM)을 이용한 다문화가정 어머니의 문화적응스트레스 척도 타당도 검증. *한국융합과학회지, 15*(2), 379–395.

Liu, Y., Millsap, R. E., West, S. G., Tein, J.-Y., Tanaka, R., & Grimm, K. J. (2017). Testing measurement invariance in longitudinal data with ordered-categorical measures. *Psychological Methods, 22*(3). https://doi.org/10.1037/met0000075

Oort, F. J. (2005). Using structural equation modeling to detect response shifts and true change. *Quality of Life Research, 14*. https://doi.org/10.1007/s11136-004-0830-y

Sprangers, M. A. G., & Schwartz, C. E. (1999). Integrating response shift into health-related quality of life research: A theoretical model. *Social Science & Medicine, 48*(11). https://doi.org/10.1016/S0277-9536(99)00045-3

Widaman, K. F., Ferrer, E., & Conger, R. D. (2010). Factorial invariance within longitudinal structural equation models: Measuring the same construct across time. *Child Development Perspectives, 4*(1). https://doi.org/10.1111/j.1750-8606.2009.00110.x
