# 교수님 설명용 메모

## 가제

**종단 서열형 심리측정 자료에서 잠재 변화와 반응기준 변화를 분해하기 위한 Bayesian longitudinal MNLFA framework**

영문 가제:

**A Bayesian Longitudinal MNLFA Framework for Decomposing Latent Change and Response Shift in Ordinal Panel Data**

---

## 1. 한 문장 요약

기존 종단 성장모형은 관찰점수 변화가 실제 잠재특성 변화라고 가정하기 쉽지만, 다문화가족 패널에서는 차별경험, 한국어 능력, 소득 같은 시간가변 공변량이 문항 응답기준 자체를 바꿀 수 있습니다. 본 연구는 Bayesian longitudinal ordinal MNLFA를 이용해 관찰된 응답 변화를 **잠재 변화 성분**과 **측정기능 변화 성분(response shift/DIF)** 으로 분해하는 방법을 제안하고 검증하려는 연구입니다.

---

## 2. 왜 이게 문제인가

다문화가족 종단자료에서 acculturative stress를 분석할 때 보통 다음과 같이 해석합니다.

> 시간이 지나면서 스트레스 점수가 증가했다/감소했다.

하지만 이 해석은 측정불변성이 성립할 때만 안전합니다. 예를 들어 같은 잠재 스트레스 수준이라도 차별경험이 있는 부모는 다음 문항에 더 쉽게 높은 범주를 선택할 수 있습니다.

- 한국 사람들이 나에게 편견을 가지고 있다.
- 외국출신자를 무시하는 것에 화가 난다.
- 한국 사람들과 다른 대우를 받는다.

이 경우 관찰점수 변화는 두 가지가 섞인 결과입니다.

1. 실제 잠재 스트레스 변화
2. 차별경험에 따른 문항 응답기준 변화

따라서 기존 LGM이나 합산점수 성장모형만으로는 **latent change**와 **measurement-function change**를 분리하기 어렵습니다.

---

## 3. 현재 MAPS 분석에서 보이는 패턴

현재 MAPS 2기 학부모 패널자료를 이용해 8개 acculturative stress 서열형 문항에 Bayesian longitudinal MNLFA를 적용했습니다.

예비 결과의 핵심은 다음과 같습니다.

1. 잠재 acculturative stress trajectory는 전반적으로 감소하는 방향을 보입니다.
2. 그러나 차별경험은 일부 문항의 threshold DIF와 강하게 관련됩니다.
3. 특히 Item 2, Item 6, Item 1에서 discrimination-related threshold shift가 큽니다.
4. 같은 잠재 스트레스 수준에서도 차별경험이 있으면 특정 문항의 높은 응답확률이 커질 수 있습니다.

주의할 점:

- 이 결과는 “차별이 스트레스를 인과적으로 증가시켰다”는 뜻이 아닙니다.
- 더 안전한 해석은 “차별경험과 관련된 문항기능 변화가 관찰되며, 이를 무시하면 종단 변화 해석이 왜곡될 수 있다”입니다.
- full-data 결과는 variational inference 기반이고, subset NUTS validation은 보조 검증으로 사용합니다.

---

## 4. 방법론적 개발 포인트

단순히 MNLFA를 적용하는 데서 끝나면 방법 적용 연구입니다. 박사논문 수준의 방법론적 기여를 만들려면, MNLFA 결과를 이용해 종단 응답변화를 분해하는 새로운 estimand를 제안할 수 있습니다.

제안 지표:

**Counterfactual Response-Shift Decomposition Index, RSDI**

핵심 질문:

> 관찰된 문항 응답 변화 중 어느 정도가 latent trait 변화 때문이고, 어느 정도가 measurement function 변화 때문인가?

---

## 5. RSDI 기본 정의

문항 `j`, 개인 `i`, 시점 `t`에서 예측 기대응답을 다음과 같이 둡니다.

```text
mu_itj = E[Y_itj | eta_it, Z_it]
```

여기서:

- `Y_itj`: 서열형 문항 응답
- `eta_it`: 잠재 acculturative stress
- `Z_it`: 시간가변 공변량, 예: discrimination, Korean proficiency, income

두 시점 `t0`와 `t1` 사이의 총 변화는 다음과 같습니다.

```text
Total change = mu(eta_t1, Z_t1) - mu(eta_t0, Z_t0)
```

이를 세 성분으로 분해합니다.

```text
Latent change component
= mu(eta_t1, Z_t0) - mu(eta_t0, Z_t0)

Measurement shift component
= mu(eta_t0, Z_t1) - mu(eta_t0, Z_t0)

Interaction component
= Total change - Latent component - Measurement component
```

그리고 response-shift 기여율을 다음처럼 정의할 수 있습니다.

```text
RSDI =
|Measurement shift component| /
(|Latent component| + |Measurement shift component| + |Interaction component|)
```

해석:

```text
RSDI = 0.70
```

이라면, 해당 문항의 예측 응답 변화 중 상당 부분이 latent stress 변화보다 measurement-function shift와 관련된다는 뜻입니다.

---

## 6. 왜 이것이 개발인가

기존 MNLFA 연구는 보통 다음을 보고합니다.

> 어떤 문항에서 어떤 공변량 DIF가 있다.

본 연구는 여기서 한 단계 더 나아가 다음을 묻습니다.

> 그 DIF가 종단 성장 해석을 얼마나 바꾸는가?

즉, 개발 포인트는 새로운 Stan sampler를 만드는 것이 아니라, Bayesian MNLFA posterior를 이용해 종단 응답변화를 반사실적으로 분해하는 **새로운 estimand와 분석 workflow**를 제안하는 것입니다.

방법론적 기여는 다음과 같이 정리할 수 있습니다.

1. 시간가변 DIF가 있는 종단 서열형 자료에서 관찰 응답변화를 분해하는 counterfactual estimand 제안
2. posterior draw 단위로 latent-change component와 measurement-shift component의 불확실성 추정
3. MAPS 실자료에 적용해 discrimination-linked response shift가 성장해석에 미치는 영향 제시
4. Monte Carlo simulation으로 RSDI와 latent slope recovery 검증

---

## 7. 논문/학위논문 구성안

### Paper 1. MAPS 실증 분석

질문:

> MAPS 학부모 acculturative stress 자료에서 측정불변성을 가정한 성장모형과 time-varying DIF를 허용한 MNLFA는 서로 다른 종단 해석을 주는가?

분석:

- 합산점수 기반 naive growth model
- 측정불변성 가정 ordinal latent growth model
- Bayesian longitudinal ordinal MNLFA
- RSDI 기반 counterfactual response-shift decomposition

핵심 산출:

- 모델별 latent slope 비교
- discrimination-related DIF forest plot
- 문항별 RSDI
- DIF 제거 counterfactual trajectory

### Paper 2. Monte Carlo simulation

질문:

> time-varying threshold/loading DIF가 있을 때 기존 성장모형은 latent slope를 얼마나 편향 추정하는가?

조건:

- 표본크기: 예, 300 / 600 / 1200
- DIF 크기: 0 / 중간 / 큼
- discrimination prevalence 변화: 안정 / 증가
- residual 구조: 낮음 / 높음
- missingness 또는 attrition: 선택적으로 추가

평가:

- slope bias
- DIF recovery
- coverage
- false positive DIF
- RSDI recovery

### Paper 3. 추정전략 비교

질문:

> 고차원 longitudinal ordinal MNLFA에서 VI, Pathfinder, subset NUTS, full NUTS 중 무엇을 어디까지 신뢰할 수 있는가?

분석:

- full-data VI를 screening 용도로 사용
- subset NUTS로 posterior calibration
- Pathfinder/full-rank VI와 비교
- selected model에 대해 longer NUTS 가능성 평가

핵심 주장:

> full NUTS가 항상 현실적이지 않은 대규모 패널 MNLFA에서, approximate inference와 exact posterior validation을 결합한 calibration workflow가 필요하다.

---

## 8. 교수님께 설명할 때 쓸 2분 스크립트

처음에는 MAPS 자료에 Bayesian longitudinal MNLFA를 적용해서 discrimination-related DIF를 보는 실증연구로 생각했습니다. 그런데 단순히 DIF가 있다는 결과만으로는 박사논문에서 새로운 개발이라고 보기 어렵다고 판단했습니다.

그래서 방향을 조금 바꿔서, 종단 서열형 심리측정 자료에서 관찰된 응답 변화가 실제 잠재특성 변화인지, 아니면 시간가변 공변량에 따른 문항기능 변화인지 분해하는 framework로 발전시키려고 합니다.

구체적으로는 MNLFA posterior를 이용해 각 문항의 예측 기대응답을 반사실적으로 계산합니다. 예를 들어 실제 상태, DIF를 제거한 상태, latent trajectory만 바꾼 상태를 비교해서 총 응답 변화 중 latent-change component와 measurement-shift component를 분리합니다. 이 비중을 Counterfactual Response-Shift Decomposition Index, RSDI로 정의할 수 있습니다.

MAPS 예비분석에서는 차별경험이 특히 편견, 다른 대우, 무시/분노 문항의 threshold shift와 관련되어 있고, 같은 잠재 스트레스 수준에서도 높은 응답확률을 증가시키는 패턴이 보입니다. 따라서 관찰점수 변화만 보면 스트레스 변화처럼 보이는 부분이 실제로는 discrimination-linked response shift일 수 있습니다.

박사논문으로는 세 단계로 구성할 수 있을 것 같습니다. 첫째, MAPS 실자료에서 naive growth, invariant growth, MNLFA를 비교합니다. 둘째, Monte Carlo simulation으로 time-varying DIF가 slope 추정에 주는 bias와 RSDI recovery를 검증합니다. 셋째, VI와 NUTS 기반 추정전략을 비교해 대규모 longitudinal MNLFA에서 어떤 추정결과를 어디까지 신뢰할 수 있는지 정리합니다.

따라서 이 연구의 기여는 새 sampler를 만드는 것은 아니지만, time-varying measurement noninvariance가 종단 성장해석에 미치는 영향을 분해하고 정량화하는 방법론적 확장이라고 설명할 수 있습니다.

---

## 9. 예상 질문과 답변

### Q1. 이게 단순 MNLFA 적용과 뭐가 다른가?

단순 적용은 DIF 계수를 보고하는 데서 끝납니다. 이 연구는 DIF가 종단 변화 해석에 얼마나 기여했는지를 counterfactual decomposition으로 정량화합니다. 즉 “DIF가 있다”가 아니라 “관찰 변화 중 어느 정도가 response shift인가”를 추정합니다.

### Q2. 완전히 새로운 방법론 개발인가?

새로운 sampler나 완전히 새로운 모형 class를 제안하는 것은 아닙니다. 더 정확히는 Bayesian longitudinal ordinal MNLFA를 기반으로 한 **새로운 estimand와 분석 workflow 개발**입니다. 박사논문에서는 “methodological development” 또는 “methodological extension and evaluation”으로 표현하는 것이 안전합니다.

### Q3. 왜 discrimination을 중심에 두는가?

다문화가족 맥락에서 discrimination은 단순한 외부 예측변수가 아니라 문항 응답기준을 바꿀 수 있는 경험입니다. 특히 편견, 차별대우, 무시/분노 문항은 discrimination 경험과 내용적으로도 직접 연결됩니다. 따라서 discrimination-related DIF는 response shift를 검토하기에 이론적으로 타당한 출발점입니다.

### Q4. 인과 주장인가?

아닙니다. 현재 분석은 discrimination이 response process를 인과적으로 바꿨다고 주장하지 않습니다. 더 안전한 표현은 “discrimination-related measurement-function shift” 또는 “findings consistent with response-shift interpretation”입니다.

### Q5. full NUTS가 안 되면 논문이 약하지 않은가?

full-data NUTS가 이상적이지만, 고차원 longitudinal ordinal MNLFA에서는 계산적으로 매우 무겁습니다. 따라서 full-data VI를 screening으로 사용하고, subset NUTS 또는 selected model NUTS로 posterior calibration을 수행하는 전략을 제시할 수 있습니다. 이 자체가 Paper 3의 주제가 됩니다.

---

## 10. 다음에 바로 할 분석

우선순위는 다음과 같습니다.

1. 현재 MNLFA posterior에서 RSDI 후처리 코드 작성
2. Item 1, 2, 6 중심으로 counterfactual expected-score decomposition 산출
3. 합산점수 naive growth model 실행
4. invariant ordinal latent growth comparator 실행
5. no-DIF / threshold-only DIF / full DIF MNLFA 비교
6. 작은 Monte Carlo prototype 작성

---

## 11. 가장 안전한 최종 주장

가장 안전한 주장은 다음입니다.

> 본 연구는 다문화가족 종단자료에서 차별경험과 관련된 문항기능 변화가 관찰점수 기반 성장해석에 영향을 줄 수 있음을 보이고, Bayesian longitudinal ordinal MNLFA posterior를 이용해 관찰 응답변화를 잠재 변화 성분과 측정기능 변화 성분으로 분해하는 반사실적 지표를 제안한다.

영문:

> This study proposes a counterfactual decomposition of longitudinal ordinal response changes within a Bayesian MNLFA framework, separating latent-change components from measurement-shift components associated with time-varying discrimination experiences.

---

## 12. 연구 아이디어의 현재 상태와 설명 방식

현재 RSDI와 counterfactual response-shift decomposition은 완성된 방법론이라기보다 **개발 가능성이 있는 연구 아이디어 후보**입니다. 따라서 교수님께 설명할 때는 “이미 개발했다”가 아니라 “이 방향으로 개발해볼 수 있을지 검토받고 싶다”는 방식이 안전합니다.

현재 상태:

- MNLFA 적용 결과는 존재합니다.
- discrimination-related DIF와 latent trajectory 패턴은 예비적으로 확인했습니다.
- RSDI는 이 결과를 바탕으로 제안한 후속 개발 아이디어입니다.
- 아직 문헌상 유사 decomposition 확인, 수식 정교화, 실제 posterior 계산, simulation validation이 필요합니다.

교수님께 말할 때:

> MNLFA 적용만으로는 개발성이 약할 수 있다고 생각해서, 관찰 응답 변화를 latent change와 measurement shift로 분해하는 방향을 고민해봤습니다. 아직 아이디어 단계이지만, Bayesian MNLFA posterior에서 counterfactual expected response를 계산하면 response-shift contribution을 지표화할 수 있을 것 같습니다. 이 방향이 방법론 개발로 확장 가능한지 검토받고 싶습니다.

피해야 할 표현:

- “새로운 방법론을 완성했습니다.”
- “RSDI는 검증된 지표입니다.”
- “차별경험이 response shift를 인과적으로 발생시켰습니다.”
- “기존 성장모형이 틀렸다는 것을 입증했습니다.”

더 안전한 표현:

- “방법론적 개발 가능성이 있는 아이디어입니다.”
- “기존 Bayesian longitudinal MNLFA posterior를 활용한 counterfactual decomposition을 제안해볼 수 있습니다.”
- “이 접근이 타당한지는 문헌검토, 모형 비교, posterior validation, Monte Carlo simulation으로 검증해야 합니다.”
- “현재 결과는 discrimination-related measurement-function shift와 일관된 패턴을 보입니다.”

연구윤리와 저자성 측면에서도, 이 아이디어는 자동으로 완성된 연구가 되는 것이 아닙니다. 최종 연구 기여가 되려면 연구자가 직접 다음을 수행해야 합니다.

1. 기존 문헌에서 유사한 decomposition 또는 response-shift index가 있는지 확인
2. RSDI의 수식과 식별 조건을 명확히 정리
3. MAPS posterior draw에서 실제 RSDI 계산
4. naive/invariant/MNLFA comparator 분석
5. Monte Carlo simulation으로 recovery, bias, coverage 검증
6. 해석 가능한 범위와 한계를 논문에 명시

따라서 가장 적절한 현재 포지션은 다음입니다.

> AI와의 브레인스토밍을 통해 도출한 방법론적 개발 아이디어를 연구자가 검토, 수정, 구현, 검증해 박사논문 주제로 발전시키는 단계.
