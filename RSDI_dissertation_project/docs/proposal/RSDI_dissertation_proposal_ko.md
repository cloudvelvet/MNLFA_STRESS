1# 종단 순서형 패널자료에서 잠재 변화와 반응 이동을 분해하는 베이지안 종단 MNLFA 프레임워크

## A Bayesian Longitudinal MNLFA Framework for Decomposing Latent Change and Response Shift in Ordinal Panel Data

**학위논문 연구계획서 (3-편 논문 통합 개요 / Three-Paper Dissertation Proposal)**

---

> **인식론적 상태 고지 (Epistemic Status Notice).** 본 문서는 *연구계획서*이다. 기술된 모든 분석 결과·추정치·시뮬레이션 성능은 아직 산출되지 않은 *계획되고 기대되는* 결과이며, 실제로 계산된 실증 결과가 아니다. 본문에 제시되는 RSDI 수치(예: 0.70)는 전적으로 *예시(illustrative)*이며 자료에서 추정된 값이 아니다. 본 계획서에서 제안하는 RSDI(Counterfactual Response-Shift Decomposition Index)는 검증이 완료된 지표가 아니라, 기존 베이지안 종단 MNLFA를 토대로 *개발 가능성을 검토하려는* estimand이다. 또한 본 연구는 차별경험이 반응과정을 인과적으로 변화시킨다고 주장하지 않으며, 관찰된 패턴을 "차별경험과 관련된 측정기능 이동(discrimination-related measurement-function shift)"으로 신중하게 해석한다.

---

## 국문 초록

다문화가족 종단 패널에서 문화적응 스트레스(acculturative stress) 점수가 시간에 따라 변할 때, 그 변화가 곧 실제 잠재 스트레스의 변화만을 의미하지는 않는다. 차별경험, 한국어 능력, 소득과 같이 시간에 따라 변하는 공변량(time-varying covariate)이 문항의 역치(threshold)나 적재량(loading)을 바꾸면, 관찰된 점수 변화에는 (1) 실제 잠재 변화 성분과 (2) 측정기능 이동 성분이 뒤섞인다. 따라서 측정 불변성(measurement invariance)을 암묵적으로 가정하는 기존 합산점수 기반 성장모형이나 잠재성장모형(LGM)은 종단 변화 해석을 왜곡할 수 있다. 본 연구는 베이지안 종단 순서형 MNLFA(moderated nonlinear factor analysis) posterior를 이용하여, 관찰된 순서형 반응 변화를 **잠재 변화 성분**과 **측정 이동 성분(반응 이동/DIF)**으로 반사실적(counterfactual)으로 분해하는 estimand인 RSDI(Counterfactual Response-Shift Decomposition Index)를 제안하고 평가하는 것을 목표로 한다. 본 계획서는 세 편의 논문으로 구성된다. 논문 1은 MAPS(다문화청소년패널 부모자료) 문화적응 스트레스 8문항에 대해 naive 성장모형, 측정 불변성 가정 순서형 성장모형, 베이지안 종단 MNLFA를 비교하고 RSDI로 차별경험 관련 반응 이동을 정량화한다. 논문 2는 시간가변 DIF가 존재할 때 기존 성장모형의 기울기 편향과 MNLFA/RSDI의 회복(recovery)·포함확률(coverage)을 Monte Carlo 시뮬레이션으로 검증한다. 논문 3은 VI, Pathfinder, subset NUTS, 선택적 NUTS 등 추정전략을 비교하여 고차원 종단 MNLFA에서 신뢰 가능한 추론 워크플로를 제시한다. 본 연구의 기여는 새로운 sampler를 만드는 것이 아니라, 시간가변 측정 비불변성이 종단 성장 해석에 미치는 영향을 분해·정량화하는 방법론적 확장과 평가에 있다.

**주제어:** 순서형 종단 패널, 종단 측정 불변성, moderated nonlinear factor analysis, 반응 이동, 차별적 문항기능(DIF), 문화적응 스트레스, 베이지안 추론, 반사실적(모형함의) 분해

## Abstract

When acculturative stress scores change over time in multicultural-family panel data, the observed change does not necessarily reflect a change in the underlying latent construct. If time-varying covariates—such as perceived discrimination, Korean-language proficiency, and household income—alter item thresholds or loadings, the observed change confounds (1) genuine latent change with (2) measurement-function shift. Conventional sum-score growth models and latent growth models (LGMs) that implicitly assume measurement invariance can therefore distort longitudinal interpretation. This dissertation proposes and evaluates the **Counterfactual Response-Shift Decomposition Index (RSDI)**, an estimand that uses a Bayesian longitudinal ordinal MNLFA (moderated nonlinear factor analysis) posterior to decompose observed ordinal response change into a **latent-change component** and a **measurement-shift (response-shift/DIF) component**. The proposal comprises three papers. Paper 1 applies the framework to the eight-item acculturative-stress scale in the MAPS parent panel, comparing a naive growth model, an invariance-constrained ordinal growth model, and a Bayesian longitudinal MNLFA, and quantifying discrimination-related response shift via RSDI. Paper 2 uses Monte Carlo simulation to examine slope bias in conventional growth models under time-varying DIF and to evaluate the recovery and coverage of MNLFA/RSDI estimates. Paper 3 compares estimation strategies—variational inference, Pathfinder, subset NUTS, and selected-model NUTS—to establish a trustworthy inference workflow for high-dimensional longitudinal MNLFA. The contribution is not a new sampler but a methodological extension and evaluation that decomposes and quantifies how time-varying measurement non-invariance affects longitudinal growth interpretation.

**Keywords:** longitudinal measurement invariance, moderated nonlinear factor analysis, response shift, differential item functioning, acculturative stress, Bayesian inference, counterfactual decomposition

---

# 1. 서론

## 1.1 연구 배경과 문제 제기

순서형(Likert형) 문항을 반복측정하는 종단 패널연구에서, 연구자는 흔히 "시간이 지나면서 점수가 증가/감소했다"는 형태로 결과를 해석한다. 그러나 이러한 해석은 측정 불변성이 성립할 때에만 타당하다. 동일한 잠재 특성이 시점마다 동일한 방식으로 문항에 반영된다는 보장이 없다면, 관찰된 점수 변화는 잠재 특성의 변화와 측정기능의 변화가 합쳐진 결과일 수 있다(Widaman, Ferrer, & Conger, 2010). 이 문제는 특정 영역에 국한되지 않는다. 환자의 삶의 질 추적(반응 이동), 임상 증상 척도, 노화·인지 패널, 교육검사 등 **시간에 따라 변하는 공변량이 문항 응답기준을 바꿀 수 있는 모든 순서형 패널**에서 동일하게 발생한다. 따라서 본 연구의 일차적 관심은 특정 구성개념이 아니라, *관찰된 종단 순서형 반응변화를 잠재 변화와 측정기능 변화로 분해하는 일반적 방법*이다.

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

MNLFA는 측정 불변성·DIF 검정을 집단 기반 비교를 넘어 연속·범주형 조절변수의 함수로 일반화하는 틀을 제공한다(Bauer, 2017). 핵심은 문항 모수(적재·역치)가 집단뿐 아니라 공변량의 함수가 될 수 있다는 점이다. 본 연구에서 부모 연령, 한국어 능력, 소득, 차별경험을 문항 모수 예측변수로 투입하는 것은 이 틀에 직접 근거한다. 다수의 배경변수가 있을 때는 정규화(regularized) MNLFA를 통해 DIF를 효율적으로 선별할 수 있다(Bauer, Belzak, & Cole, 2019).

종단 MNLFA는 construct change와 measurement change를 동시에 모형화하는 방향으로 발전했으며, 본 연구의 가장 직접적인 방법론적 anchor이다(Chen & Bauer, 2024). 이 연구는 합산/평균 점수를 반복측정 지표로 사용할 때 측정 항상성을 암묵적으로 가정하게 되어 construct change와 DIF가 혼입될 수 있음을 명시적으로 다루며, "왜 종단 MNLFA가 필요한가"를 뒷받침한다.

## 2.3 반응 이동(Response Shift) 이론

반응 이동은 건강관련 삶의 질 연구에서 발전한 이론적 틀로, 응답자의 내적 기준(recalibration), 가치 우선순위(reprioritization), 구성개념 정의(reconceptualization)의 변화를 포괄한다(Sprangers & Schwartz, 1999). SEM을 이용해 true change와 response shift/측정편향을 구분하려는 시도가 이어져 왔다(Oort, 2005; King-Kallimanis, Oort, & Garst, 2010).

본 연구의 반응 이동 유형 대응은 다음과 같다. 문항 **역치(threshold) 이동**은 동일 잠재수준에서 범주 선택 기준이 달라지는 것이므로 주로 **recalibration**에 대응하고, 문항 **적재(loading) 이동**은 문항이 구성개념을 반영하는 강도의 변화이므로 **reprioritization/reconceptualization**에 가깝다.

기존 SEM 기반 반응이동 분해(Oort, 2005)와 본 연구의 차별점을 분명히 할 필요가 있다. Oort류 접근은 (1) 주로 연속지표 공통요인 SEM에서 절편/적재 변화를 모수로 탐지하고, (2) 집단·시점 수준의 모수 차이로 반응이동을 *진단*하는 데 초점이 있다. 이에 비해 본 연구는 (a) 순서형 문항반응 확률 척도에서, (b) 연속·시간가변 공변량의 함수로 문항모수 변화를 모형화하며(MNLFA), (c) 모수 탐지에 그치지 않고 **관찰된 종단 반응변화량을 잠재·측정 성분으로 분해하는 양적 estimand(RSDI)와 그 사후 불확실성**을 산출한다. 즉 "반응이동이 있는가"를 넘어 "관찰 변화 중 측정이동 기여가 얼마인가"를 정량화한다는 점에서 기존 분해와 구별된다.

본 연구는 차별경험 관련 역치 이동을 반응 이동의 한 후보적 형태로 해석하되, 인과적 주장("차별이 반응 이동을 일으켰다")은 하지 않고 "discrimination-related measurement-function shift와 일관된 패턴"으로 표현한다.

## 2.4 MAPS 및 문화적응 스트레스 DIF 맥락

동일 연구 맥락(MAPS 기반)에서 다문화가정 어머니의 문화적응 스트레스 척도에 대해 차별경험 관련 DIF 가능성이 보고된 바 있다(Lee & Choi, 2026). 이는 차별경험을 시간가변 DIF 예측변수로 설정하는 것이 사후적 fishing이 아니라 같은 자료 맥락의 선행 심리측정 근거에 기반한 선택임을 방어하는 근거가 된다. 다만 이 선행연구는 단일시점 GRM/MIMIC이며 독립적 외부 타당화로 인용하기보다 같은 연구 프로그램 내부의 선행 근거로 표현한다.

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
a_j(Z)    = a_j0 + a_j' Z          (적재 이동: loading moderation)
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

### 3.5.4 식별: 정식 명제와 증명

핵심 질문은 "잠재분포가 `Z`에 의존(latent impact)하는데도 `Latent`/`Measurement` 성분이 분리 식별되는가"이다. 아래에서 이를 명제·증명 형태로 정식화한다. 일부 단계(특히 명제 4의 사후 일치성)는 완전 증명을 향후 과제로 두되, 핵심 식별 논증(정리 1)은 자기완결적으로 제시한다.

#### 정의

문항 `j`의 **측정함수**를 입력 `(e, z) ∈ ℝ × ℝ^P`에서 단체(simplex) `Δ^{K_j}`로 가는 사상으로 둔다.

```text
m_j(e, z) = ( P(Y=0 | e, z), …, P(Y=K_j | e, z) ),
  with  P(Y >= k | e, z) = inv_logit( a_j(z) * e - kappa_jk(z) ),
        a_j(z) = exp(la0_j + la_j' z),   kappa_jk(z) = c_jk + b_j' z.
```

선형예측자를 `phi_j(e, z) = a_j(z) * e - kappa_jk(z)`로 두면, 입력 `(e, z)`는 측정함수에 **두 통로**로만 들어간다: (i) 잠재값 `e`는 적재와 곱해진 항 `a_j(z)·e`로, (ii) 공변량 `z`는 문항모수 `a_j(z), kappa_jk(z)`로.

분해 연산자를 측정함수의 평가값 차이로 정의한다(기준 `p00 = m_j(e0, z0)`).

```text
Total_j(e0,z0; e1,z1)  = m_j(e1, z1) - p00
Latent_j               = m_j(e1, z0) - p00
Measurement_j          = m_j(e0, z1) - p00
Interaction_j          = Total_j - Latent_j - Measurement_j
```

#### 명제 1 (측정함수의 식별)

가정 (A1)(함수형 정확성), (A2)(국소 독립), (A4)(종단 척도 식별) 하에서, 그리고 공변량 `z`가 잠재값 `e`와 함수적으로 독립인 변동(즉 동일 `e` 근방에서 `z`가 변하는 관측)을 충분히 포함하면, 문항모수 함수 `a_j(·), kappa_jk(·)`는 식별된다. 따라서 측정함수 `m_j: (e,z) ↦ Δ^{K_j}`는 정의역 전체에서 식별되어, **임의의 입력쌍 `(e,z)`에서 평가 가능**하다.

*근거.* 이는 MNLFA의 표준 식별 결과의 직접 적용이다(Bauer, 2017). 국소 독립과 충분한 응답 패턴은 문항반응함수의 형태를 식별하고, `z`의 외생적 변동은 moderation 계수 `la_j, b_j`를 식별한다. 종단 척도 식별(A4)은 `e`의 단위·원점을 시점 간 공통으로 고정하여 평가의 비교가능성을 보장한다. ∎

#### 정리 1 (개인 조건부 분해의 식별 — latent impact 불변)

구조모형이 latent impact를 포함하더라도, 즉 `eta_it = g(t, Z_it) + zeta_it`에서 `g`가 `Z`에 의존하더라도, 개인 조건부 분해 `(Latent_ij, Measurement_ij, Interaction_ij)`는 식별된다.

*증명.* 개인 조건부 정의에서 `eta_it0, eta_it1`은 **사후분포에서 추출된 실현값(주어진 상수)**으로 취급된다. 분해의 각 항은 명제 1에서 식별된 함수 `m_j`를 네 입력점

```text
(eta_it0, Z_it0), (eta_it1, Z_it0), (eta_it0, Z_it1), (eta_it1, Z_it1)
```

에서 평가한 값들의 선형결합이다. 식별된 함수의 식별된 점에서의 평가값은 식별되므로, 네 평가값 모두 식별되고 따라서 그 선형결합인 분해 항들도 식별된다.

핵심은 다음 분리이다. latent impact는 **`eta`의 생성기제 `g`**, 즉 "`eta_it1`이라는 값이 어떻게 만들어졌는가"에만 관여한다. 그러나 분해 항은 `eta`의 *생성기제*가 아니라 *실현값* `eta_it0, eta_it1`에만 의존한다(위 네 평가점에 `g`가 등장하지 않음). 형식적으로, 분해를 사상

```text
D_j : (e0, e1, z0, z1) ↦ (Latent_j, Measurement_j, Interaction_j)
```

로 보면 `D_j`는 `m_j`와 네 입력점만의 함수이며 `g`에 대해 상수이다. 즉 `∂D_j/∂g = 0`. 따라서 `g`가 `Z`에 의존하든(latent impact 존재) 아니든 `D_j`의 값은 동일하게 식별된다. ∎

**따름정리 (RSDI의 식별).** §3.5.1의 스칼라화(총변동거리)와 분모 임계 규칙 하에서, 분자·분모가 모두 식별된 분해 항의 연속함수이므로, 분모가 0이 아닌 영역에서 `RSDI_ij`는 식별된다. (분모=0 근방의 불안정성은 §3.3의 경계 규칙으로 처리.)

#### 명제 2 (interaction 항의 출처)

`Interaction_j`는 일반적으로 0이 아니며, 이는 모형의 구조적 특징에서 비롯된다. 선형예측자 `phi_j(e,z) = a_j(z)·e − kappa_j(z)`는 `e`와 `z`에 대해 **이선형(bilinear) 성분 `a_j(z)·e`**를 가지므로, `phi` 자체도 `(e,z)`에 대해 가법적이지 않다. 더하여 `inv_logit(·)`이 비선형이므로, 확률척도의 분해는 `Latent + Measurement`로 정확히 가법되지 않는다. 따라서 interaction은 오차가 아니라 **적재 moderation(비균일 DIF)과 링크 비선형성의 결합으로 생기는 구조적 비가법성**이다. 적재 moderation이 없고(`la_j = 0`) 변화가 작은 극한에서는 interaction이 1차적으로 소멸한다(`Interaction_j = o(||(Δe, Δz)||)`).

#### 명제 3 (latent impact의 귀속과 3-way 확장)

개인 조건부 분해는 latent impact를 `Latent` 성분에 귀속시킨다("그 사람의 잠재값이 실제로 그만큼 변했다"). `Z`가 잠재값을 바꾼 경로를 측정이동과 분리해 보고 싶다면, 식별된 구조모형 `g`를 이용해 잠재 성분을 다시 둘로 나눈다.

```text
eta_it1 = g(t1, Z_it1) + zeta_it1
잠재-자생(autonomous)  : m_j( g(t1,Z_it0)+zeta_it1, Z_it0 ) - p00
잠재-Z매개(Z-mediated) : m_j( g(t1,Z_it1)+zeta_it1, Z_it0 ) - m_j( g(t1,Z_it0)+zeta_it1, Z_it0 )
측정(measurement)      : m_j(eta_it0, Z_it1) - p00
```

`g`가 명제 1·구조모형에서 식별되므로 이 3-way 분해도 식별된다. 본 연구는 기본형(2-way)을 우선하고 3-way를 선택적 확장으로 둔다.

#### 정리 2 (모집단 정의 분해의 식별)

개인 조건부 정의(정리 1)는 `eta`를 실현값으로 고정했다. 모집단 정의는 잠재값을 분포에 대해 적분하므로 latent impact가 적분 경로로 다시 들어온다. 이때 분해의 식별에는 **잠재값 이동의 기준 분포를 명시적으로 고정**하는 추가 규약이 필요하다.

*설정.* 구조모형에서 시점 `t`·공변량 `z`에서의 잠재분포를 `F_t(· | z)`로 둔다(예: 평균 `g(t,z)`, 분산 `psi`인 정규). 문항 `j`의 시점 `t`·공변량 `z`에서의 모집단 기대 측정함수를 다음으로 정의한다.

```text
M_j(t, z) = ∫ m_j(e, z) dF_t(e | z)
```

여기서 `M_j`는 두 인자에 각각 의존한다: (i) 적분 분포 `F_t(·|z)`를 통한 **잠재 경로**, (ii) 피적분 측정함수 `m_j(·, z)`를 통한 **측정 경로**. 모집단 총변화 `M_j(t1, z1) − M_j(t0, z0)`를 분해하려면 두 경로를 교차고정해야 한다.

```text
기준        Pbar00 = M_j(t0, z0)
잠재 성분   M_j(t1, z0) - Pbar00       (측정함수의 z는 z0 고정, 분포는 t0->t1)
측정 성분   Mtil_j(t0, z1) - Pbar00     (분포는 t0 고정, 측정함수의 z는 z0->z1)
교호 성분   잔차
  where  Mtil_j(t0, z1) = ∫ m_j(e, z1) dF_t0(e | z0)
```

*증명.* 명제 1에서 `m_j(·,·)`가 식별되고, 구조모형에서 `F_t(·|z)`(즉 `g, psi`)가 식별된다. `M_j`와 `Mtil_j`는 식별된 측정함수를 식별된 분포로 적분한 값이므로 식별된다. 따라서 위 세 성분과 그 스칼라화(RSDI의 모집단 버전)도 식별된다. ∎

**규약상의 선택(개인 vs 모집단의 차이).** 정리 2의 핵심은 *적분 분포의 `z`를 어디에 고정하는가*라는 규약이 결과를 바꾼다는 점이다. 위에서는 잠재 성분의 분포 이동을 `dF_{t}(e | z0)`로(즉 분포의 공변량을 `z0`에 고정) 두어, "공변량으로 매개된 잠재분포 이동"을 잠재 성분에 귀속시켰다. 만약 분포의 공변량까지 `z1`로 옮기면 그 부분이 측정 성분 쪽으로 재배분된다. 즉:

- **개인 조건부(정리 1):** `eta`를 실현값으로 고정 → latent impact는 자동으로 잠재 성분에 귀속, 규약 선택 불필요(가장 견고).
- **모집단(정리 2):** 적분 분포의 `z` 고정 위치라는 **명시적 규약**이 필요하며, 그 규약에 따라 latent impact의 귀속이 달라진다.

본 연구는 이 때문에 **개인 조건부 정의를 기본**으로 채택하고, 모집단 정의는 (규약을 명시한 채) 보조·비교용으로만 보고한다. 두 정의가 크게 다르면 그 차이 자체가 latent impact의 크기를 드러내는 진단 정보가 된다.

#### 명제 4 (사후 일치성 — 향후 과제)

위 식별은 모수·잠재값이 알려졌을 때의 식별이다. 유한표본 사후추정에서 RSDI 사후평균이 참값으로 수렴하는지(베이지안 일치성)는 표준 사후 일치성 조건(사전분포의 지지, 모형 정칙성) 하에서 성립할 것으로 기대되나, 순서형 MNLFA + 잠재 성장 구조에서의 정식 증명은 향후 과제로 둔다. 논문 2(시뮬레이션)는 이 수렴을 경험적 회복(recovery)·포함확률로 점검한다.

#### 식별이 깨지는 경우 (정밀화)

정리 1의 전제가 무너지는 세 경우를 명시한다.

- **(F1) 누락 조절자 — (A3) 위반.** 참 측정함수가 모형에 없는 시간가변 변수 `W`에 의존하면, 적합된 `m_j(e,z)`는 `W`에 대해 주변화된 사상이다. 이때 `Measurement_j`는 `Z`의 효과뿐 아니라 `W`의 효과 일부를 흡수해 편향된다. → RSDI는 "포함 공변량에 조건부" 지표로만 해석.
- **(F2) `Z`–`eta` 공선성.** 명제 1의 전제(동일 `e` 근방에서 `z`의 변동)가 약하면 `a_j(z)·e` 통로와 `kappa_j(z)` 통로가 분리되지 않는다. 극단적으로 `Z`가 `eta`를 거의 결정하면, 반사실 입력 `(eta_t0, Z_t1)`이 자료에서 거의 관측되지 않아 외삽(extrapolation)이 되어 분해가 불안정해진다.
- **(F3) 종단 앵커 부재 — (A4) 위반.** 시점 간 잠재 척도가 표류하면 `eta_it0`과 `eta_it1`이 서로 다른 단위가 되어 `m_j(eta_it1, Z_it0)`의 비교 자체가 무의미해진다.

논문 2는 (F1)–(F3)을 시뮬레이션 셀(§5.2–5.3의 식별 저하 점검)로 직접 구현하여 RSDI 회복 저하를 정량화한다.

## 3.6 예상되는 반론: RSDI는 DIF 계수의 재포장인가

제기될 수 있는 핵심 반론은 "RSDI가 결국 MNLFA가 이미 추정한 DIF 계수의 재표현 아닌가"이다. 이에 대한 본 연구의 입장은 다음과 같다. DIF 계수는 *문항모수가 공변량에 의존하는 정도*를 나타내는 모형 내부량이다. 반면 RSDI는 *관찰된 종단 반응변화량*을 분모로 두고 그 중 측정이동이 차지하는 **상대적 기여**를 나타낸다. 동일한 DIF 계수라도 (1) 공변량이 시간에 따라 얼마나 변했는지, (2) 잠재값이 얼마나 변했는지에 따라 RSDI는 크게 달라진다. 즉 RSDI는 DIF의 크기뿐 아니라 *실제 종단 변화 맥락에서의 작동량*을 반영하므로 DIF 계수와 일대일 대응되지 않는다. 이 점이 응용 종단 해석에서 RSDI가 추가하는 정보이다.

---

# 4. 논문 1: MAPS 실증분석 (계획)

## 4.1 연구 질문

MAPS 부모 문화적응 스트레스 자료에서 측정 불변성을 가정한 성장모형과 시간가변 DIF를 허용한 MNLFA는 서로 다른 종단 해석을 주는가? 차별경험 관련 반응 이동은 RSDI로 어떻게 정량화되는가?

## 4.2 자료

MAPS(다문화청소년패널) 부모 패널의 문화적응 스트레스 8문항과 시간가변 공변량(차별경험, 한국어 능력, 소득 등). 자료는 확보되어 있으며, **각 시간가변 공변량이 매 웨이브 측정**되어 있고 **활용 가능한 웨이브가 3개 이상(W1, W2, W3, …)**이다. 따라서 측정용 공변량 `Z_it`가 모든 시점에서 정의되어, 시점쌍 단위의 측정-이동 분해를 풀스케일로 설계할 수 있다. *최종 표본 크기·결측·중도탈락 수치는 분석 시 확정한다.*

## 4.3 분석 모형

1. 합산점수 기반 naive 성장모형
2. 측정 불변성 가정 순서형 잠재성장모형(comparator) — 3웨이브 이상이므로 선형 잠재 기울기(절편·기울기) 식별 가능
3. 베이지안 종단 순서형 MNLFA — 문항모수를 `Z_it`의 함수로(적재·역치 moderation), 잠재 구조에 성장(절편·기울기) 포함
4. RSDI 기반 반사실(모형함의) 반응 이동 분해

### 4.3.1 다중 웨이브 시점쌍 설계 (RSDI 적용)

3웨이브 이상이므로 §3.5의 2시점 분해를 다음과 같이 확장한다.

- **인접 시점쌍:** (W1→W2), (W2→W3), …  각 쌍에서 문항별 `Latent/Measurement/Interaction` 성분과 RSDI를 산출 → *언제* 측정이동이 두드러지는지 시간적 패턴 포착.
- **전 구간(endpoint):** (W1→W3 등) 전체 변화의 누적 분해.
- **궤적(trajectory) 요약:** 잠재 기울기에 대응하는 측정-이동 누적 기여를 요약하여, "성장 궤적 해석 중 측정이동이 차지하는 비중"을 제시.

각 시점쌍·문항·사후 draw마다 RSDI를 계산하여 사후분포로 보고하고, 인접쌍 RSDI의 시간 추세를 함께 제시한다.

## 4.4 기대 산출물 (계획/예상)

- 모형별 잠재 기울기 비교(naive / 불변성 / MNLFA)
- 차별경험 관련 DIF forest plot
- **시점쌍별·문항별 RSDI(사후분포)** 와 인접쌍 RSDI 시간 추세
- DIF 제거 반사실 trajectory(측정이동을 제거했을 때의 성장 궤적)

## 4.5 기대 패턴에 대한 신중한 서술

선행 근거와 이론에 비추어, 차별경험이 일부 문항(예: 편견·차별대우·무시 관련 문항)의 역치 이동과 관련될 가능성을 *예상*한다. 그러나 이는 검증할 가설이며, 실제 방향·크기는 분석 전 확정하지 않는다. 결과가 나오더라도 "차별이 반응 이동을 인과적으로 유발했다"가 아니라 "관찰된 종단 변화 일부가 차별경험 관련 측정기능 이동과 일관된다"로 해석한다.

---

# 5. 논문 2: Monte Carlo 시뮬레이션 (계획)

## 5.1 연구 질문

시간가변 역치/적재 DIF가 존재할 때, 측정 불변성을 가정한 성장모형은 잠재 기울기를 얼마나 편향되게 추정하는가? MNLFA/RSDI는 잠재 기울기와 DIF, RSDI를 얼마나 회복하는가?

## 5.2 설계 요인 (완전요인 + 핵심 요인 우선)

자료생성모형(DGM)은 §3.5.1의 graded-response MNLFA이며(논문 1과 동일 구조), 요인은 다음과 같다.

| 요인 | 수준 | 비고 |
|---|---|---|
| 표본 크기 N | 300 / 600 / 1200 | 3수준 |
| 웨이브 수 T | 3 / 5 | 실증자료 정합(3 기준) |
| DIF 크기 | 없음(0) / 중간 / 큼 | 적재+역치 moderation 계수 크기 |
| DIF 유형 | 역치만(균일) / 역치+적재(혼합) | 비균일 DIF 포함 여부 |
| 공변량 추세 | 정적 / 시간증가 | 차별경험이 시간에 따라 증가하는 시나리오 |
| DIF 문항 비율 | 25%(2/8) / 50%(4/8) | sparse vs dense |

**규모.** 완전요인은 3×2×3×2×2×2 = 144셀. 셀당 **반복 R = 500**(총 72,000 적합)을 목표로 하되, 계산 부담을 고려해 **핵심 부분요인(예: N×DIF크기×추세 = 18셀)을 1차로 R=500** 수행하고 나머지는 축소반복(R=200)으로 확장한다. 추정은 논문 3의 결과에 따라 VI(스크리닝) + 선택셀 NUTS 조합을 사용한다.

비교 추정 모형(각 셀에서):

1. naive 합산점수 성장모형
2. 측정 불변성 가정 순서형 LGM
3. 종단 MNLFA(정답 구조)
4. (선택) DIF 문항을 잘못 지정한 오설정 MNLFA — 강건성 점검

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
| 식별 저하 점검 | (F1 누락조절자·F2 공선성·F3 앵커부재) 조건에서 RSDI 회복 변화 | §3.5.4 연결 |

각 지표는 시점쌍(인접/전구간)별로 집계하며, Monte Carlo 표준오차를 함께 보고한다.

## 5.4 기대 기여

(1) DIF를 무시할 때 잠재 기울기 해석이 편향되는 조건(크기·추세·비율)을 정량적으로 지도화하고, (2) MNLFA/RSDI가 그 편향을 분해·회복하는 조건과 한계(식별 저하 3경우, §3.5.4)를 제시하며, (3) 응용 연구자를 위한 "언제 RSDI를 신뢰할 수 있는가"의 실무 가이드라인을 도출한다.

---

# 6. 논문 3: 추정전략 비교 (계획)

## 6.1 연구 질문

논문 3은 논문 1·2와의 응집력을 위해 **"RSDI 추정이 근사추론에서 얼마나 신뢰 가능한가"**라는 축으로 묶인다. 즉 단순한 일반적 추정전략 비교가 아니라, 본 연구의 핵심 산출물인 RSDI(및 그 사후 불확실성)가 추정전략에 따라 얼마나 안정적으로 회복되는지를 평가한다. 구체적으로: 고차원 종단 순서형 MNLFA에서 VI, Pathfinder/full-rank VI, subset NUTS, 선택적 NUTS 중 무엇을 어디까지 신뢰할 수 있으며, **각 전략이 RSDI 점추정·구간을 정확 posterior(기준) 대비 어느 정도로 재현하는가?**

## 6.2 비교 대상 추정전략

| 전략 | 설명 | 위치 |
|---|---|---|
| **Full NUTS** | 전체자료 HMC/NUTS — *기준(reference)* posterior | 정확하지만 고비용 |
| **Subset NUTS** | 개인 부분표본 NUTS — 기준 근사 + calibration | 중간 |
| **Mean-field VI (ADVI)** | 평균장 변분추론 — 빠른 스크리닝 | 저비용/구간 과소 위험 |
| **Full-rank VI** | 상관 포함 변분추론 | 중간 |
| **Pathfinder** | 준뉴턴 경로 기반 근사 + 다중경로 | 저비용/초기화 |

## 6.3 검증 설계 (calibration 프로토콜)

각 전략을 **(a) 시뮬레이션 자료**(진값 알려짐)와 **(b) MAPS 실증 자료**(기준=가능한 최대 길이 NUTS)에서 비교한다.

1. **기준 설정:** 소·중 규모 셀에서 Full NUTS를 충분히 길게 돌려 기준 posterior로 삼는다(R-hat≈1.00, 높은 ESS, divergence 0 확인).
2. **근사 대조:** 동일 자료에 각 근사전략 적용 → 모수·DIF·**RSDI**의 점추정·구간을 기준과 대조.
3. **워크플로 평가:** "VI 스크리닝 → 선택 셀/모형 NUTS"의 2단계 전략이 단독 전략 대비 정확도-비용 trade-off에서 우월한지 평가.

## 6.4 평가 지표

| 지표 | 정의 |
|---|---|
| 모수 점추정 일치 | 근사 vs 기준 posterior 평균 차이(표준화) |
| **RSDI 일치** | 근사 RSDI vs 기준 RSDI 편향·RMSE |
| 구간 보정 | 90/95% 구간 폭·포함률(기준 대비 과소·과대) |
| 순위 일치 | DIF·RSDI 문항 *순위* 상관(스크리닝 적합성: 상위 문항 식별력) |
| 진단 | divergence 수, R-hat, ESS, Pareto-k(VI) |
| 비용 | 벽시계 시간·메모리(동일 하드웨어) |

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

## 7.4 실행가능성 선결과제 (Feasibility Prerequisites)

분석 자료(MAPS 부모 패널)는 확보되어 있고, 시간가변 공변량이 매 웨이브 측정되어 있으며 활용 가능한 웨이브가 3개 이상이다. 따라서 자료 접근·IRB와 "분해 가능성"의 핵심 조건은 이미 충족되어 선결과제에서 제외된다. 남은 확인 사항은 설계 미세조정 수준이다.

- 문화적응 스트레스 8문항의 시점 간 동일성(문항 표현 변경·추가 여부)
- 최종 표본 크기·중도탈락·결측 구조(시점쌍별 유효표본)
- 순서형 베이지안 종단 MNLFA의 계산 부담(→ 논문 3의 추정전략 필요성과 연결)

자료 구조가 이상적(매 웨이브 측정 + 3웨이브 이상)이므로, §4.3.1의 다중 시점쌍 RSDI 설계를 제약 없이 적용할 수 있다.

## 7.5 연구 일정

분석 자료가 이미 확보되어 있어 자료 접근·IRB 대기 시간이 제거되므로, 프로포절 승인 이후 약 **2년**을 현실적 목표로 상정한다(풀타임 기준). 아래는 분기(Q) 단위 개략 간트이다. 단계 길이는 범위로 표기하며, 자료 리스크가 빠진 만큼 남은 핵심 일정 리스크는 식별 이론(§3.5) 정립과 논문 2·3의 계산 부담이다.

```text
단계                          Y1Q1 Y1Q2 Y1Q3 Y1Q4 Y2Q1 Y2Q2 Y2Q3 Y2Q4
S0 자료구조 확인(접근 완료)    ███                                            (접근·IRB 제외, 구조 점검만)
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

**2년 달성 조건.** 자료가 확보된 상태이므로, 식별 이론(§3.5)이 약 6개월 내 정리되고 계산 인프라(클러스터/GPU)가 확보되면 Y2 말 완료가 현실적이다. 정 빠듯하면 논문 3을 짧은 방법노트/부록으로 축소(plan B)하여 논문 1·2에 집중한다. 반대로 식별 이론이나 계산에서 한 번 막히면 2.5년으로 늘어날 수 있다. *구체 일정은 §3.5 정립 결과와 확보 자료의 구조(웨이브·공변량 측정 시점)에 따라 확정한다.*

---

# 8. 연구윤리 및 필수 고지

**자료 가용성(Data Availability).** 분석에 사용할 MAPS 부모 패널 자료는 이미 확보되어 있다. 본 계획서 단계에서는 아직 분석 결과가 산출되지 않았을 뿐, 자료 접근은 완료된 상태이다. 자료 이용은 제공기관의 규정과 IRB 절차를 준수한다.

**연구윤리(Ethics).** 인간 대상 2차 자료 분석에 해당하며, 실제 분석 전 소속 기관 IRB 절차 및 자료제공기관 규정을 준수한다.

**이해상충(Conflict of Interest).** 없음(계획 단계).

**연구비(Funding).** 해당 없음/미정.

**저자 기여(CRediT, 계획).** 개념화·방법론·집필은 연구자가 수행하며, 본 초안은 AI 보조로 작성된 출발 자료이다.

**AI 활용 고지(AI Disclosure).** 본 연구계획서 초안은 AI 도구(Claude)와의 브레인스토밍 및 초안 작성 보조를 통해 작성되었다. 모든 방법론적 주장·식별 조건·인용은 연구자의 검토·수정·검증을 거쳐 확정되어야 한다. 인용 무결성 검증 과정에서 초안에 포함되었던 1건의 문헌(Chen & Bauer, 2026, *Multivariate Behavioral Research*)이 실재하지 않는 할루시네이션으로 확인되어 제거되었고, 관련 주장은 검증된 Chen & Bauer (2024)로 재귀속하였다. 나머지 12편은 웹/DB(공식 출판목록, arXiv, KCI)에서 실재 확인되었다. RSDI와 반사실(모형함의) 분해는 AI 보조로 도출한 개발 후보 아이디어이며, 자동으로 완성된 연구가 아니다. 최종 연구 기여가 되려면 연구자가 식별 조건 정립, 실제 posterior 계산, 시뮬레이션 검증을 직접 수행해야 한다.

---

# 참고문헌 (References)

> ✅ **인용 검증 완료 (Stage 2.5).** 전 항목 웹/DB 검증 완료. **Chen & Bauer (2026, Multivariate Behavioral Research)는 Bauer 공식 출판목록·검색 어디에도 존재하지 않아 할루시네이션으로 판정, 목록에서 제거**하고 관련 주장은 검증된 Chen & Bauer (2024)로 재귀속하였다. Wallin & Huang (2026) 항목은 arXiv ID는 실재하나 초안의 제목이 잘못되어 실제 제목으로 수정하였다. Lee & Choi (2026), Padgett (2025)는 KCI/arXiv에서 실재 확인되었다.

Bauer, D. J. (2017). A more general model for testing measurement invariance and differential item functioning. *Psychological Methods*. https://doi.org/10.1037/met0000077

Bauer, D. J., Belzak, W. C. M., & Cole, V. T. (2019). Simplifying the assessment of measurement invariance over multiple background variables: Using regularized moderated nonlinear factor analysis to detect differential item functioning. *Structural Equation Modeling, 27*(1). https://doi.org/10.1080/10705511.2019.1642754

Chen, S. M., & Bauer, D. J. (2024). Modeling construct change over time amidst potential changes in construct measurement: A longitudinal moderated factor analysis approach. *Psychological Methods*. https://doi.org/10.1037/met0000685

Kim, E. S., & Willson, V. L. (2014). Measurement invariance across groups in latent growth modeling. *Structural Equation Modeling, 21*(3). https://doi.org/10.1080/10705511.2014.915374

King-Kallimanis, B. L., Oort, F. J., & Garst, G. J. A. (2010). Using structural equation modelling to detect measurement bias and response shift in longitudinal data. *AStA Advances in Statistical Analysis, 94*. https://doi.org/10.1007/s10182-010-0129-y

Lee, C., & Choi, Y. (2026). Psychometric validation of the cultural adaptation stress scale for mothers from multicultural families using the graded response model. *Korean Journal of Convergence Science, 15*(2), 379–395.

Liu, Y., Millsap, R. E., West, S. G., Tein, J.-Y., Tanaka, R., & Grimm, K. J. (2017). Testing measurement invariance in longitudinal data with ordered-categorical measures. *Psychological Methods, 22*(3). https://doi.org/10.1037/met0000075

Oort, F. J. (2005). Using structural equation modeling to detect response shifts and true change. *Quality of Life Research, 14*. https://doi.org/10.1007/s11136-004-0830-y

Padgett, R. N. (2025). Multidimensional constructs and moderated linear and nonlinear factor analysis. *arXiv*. https://arxiv.org/abs/2509.05443

Sprangers, M. A. G., & Schwartz, C. E. (1999). Integrating response shift into health-related quality of life research: A theoretical model. *Social Science & Medicine, 48*(11). https://doi.org/10.1016/S0277-9536(99)00045-3

Wallin, G., & Huang, Q. (2026). A hybrid latent-class item response model for detecting measurement non-invariance in ordinal scales. *arXiv*. https://arxiv.org/abs/2601.17612

Widaman, K. F., Ferrer, E., & Conger, R. D. (2010). Factorial invariance within longitudinal structural equation models: Measuring the same construct across time. *Child Development Perspectives, 4*(1). https://doi.org/10.1111/j.1750-8606.2009.00110.x
