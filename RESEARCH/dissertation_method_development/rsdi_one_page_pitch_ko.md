# 1페이지 설명자료

## 연구 가제

**종단 서열형 심리측정 자료에서 잠재 변화와 response shift를 분해하는 Bayesian MNLFA framework**

영문:

**A Bayesian Longitudinal MNLFA Framework for Decomposing Latent Change and Response Shift in Ordinal Panel Data**

---

## 핵심 문제

다문화가족 패널에서 acculturative stress 점수가 시간에 따라 변할 때, 그 변화가 반드시 실제 잠재 스트레스 변화만을 의미하지는 않습니다.

차별경험, 한국어 능력, 소득처럼 시간에 따라 변하는 공변량이 문항의 threshold나 loading을 바꾸면, 관찰점수 변화는 다음 두 성분이 섞인 결과가 됩니다.

1. **Latent change**: 실제 잠재 acculturative stress 변화
2. **Measurement shift**: 문항 응답기준 또는 문항기능 변화

따라서 기존 합산점수 growth model이나 측정불변성을 가정한 LGM은 종단 변화 해석을 왜곡할 수 있습니다.

---

## 현재 MAPS 예비결과

MAPS 2기 학부모 패널 acculturative stress 8문항에 Bayesian longitudinal ordinal MNLFA를 적용했습니다.

예비 결과:

- 잠재 acculturative stress trajectory는 전반적으로 감소하는 방향입니다.
- 차별경험은 일부 문항의 threshold DIF와 강하게 관련됩니다.
- 특히 Item 2(편견), Item 6(외국출신자 무시에 대한 분노), Item 1(다른 대우)에서 discrimination-related threshold shift가 큽니다.
- 같은 잠재 스트레스 수준에서도 차별경험이 있으면 해당 문항의 높은 응답확률이 커질 수 있습니다.

안전한 해석:

> 차별경험은 스트레스 수준뿐 아니라 스트레스를 보고하는 문항기능과도 관련될 수 있으며, 이를 무시하면 성장궤적 해석이 달라질 수 있다.

---

## 개발 아이디어: RSDI

제안 지표:

**Counterfactual Response-Shift Decomposition Index, RSDI**

목표:

> 관찰된 문항 응답 변화 중 어느 정도가 latent trait 변화이고, 어느 정도가 measurement-function shift인지 분해한다.

기본 분해:

```text
Total change
= Latent change component
+ Measurement shift component
+ Interaction component
```

안정적 비율 지표:

```text
RSDI =
|Measurement shift| /
(|Latent change| + |Measurement shift| + |Interaction|)
```

해석:

`RSDI = 0.70`이면, 해당 문항의 종단 응답 변화에서 measurement shift 성분이 매우 크다는 뜻입니다.

---

## 방법론적 기여

이 연구는 완전히 새로운 sampler를 제안하는 것은 아닙니다. 대신 기존 Bayesian longitudinal MNLFA를 이용해 다음을 개발합니다.

1. 시간가변 DIF가 있는 종단 서열형 자료에서 응답변화를 반사실적으로 분해하는 estimand
2. posterior draw 단위의 latent-change / measurement-shift 불확실성 추정
3. RSDI를 이용한 문항별 response-shift 영향 정량화
4. Monte Carlo simulation을 통한 slope bias와 RSDI recovery 검증

따라서 포지션은 **methodological development** 또는 **methodological extension and evaluation**입니다.

---

## 박사논문 구성안

**Paper 1. MAPS 실증 분석**

naive growth, invariant ordinal growth, Bayesian longitudinal MNLFA를 비교하고, RSDI로 discrimination-related response shift를 정량화합니다.

**Paper 2. Monte Carlo simulation**

time-varying DIF가 있을 때 기존 성장모형의 slope bias와 MNLFA/RSDI의 recovery, coverage를 검증합니다.

**Paper 3. 추정전략 비교**

VI, Pathfinder/full-rank VI, subset NUTS, selected NUTS를 비교해 고차원 longitudinal MNLFA에서 어떤 추정전략을 신뢰할 수 있는지 평가합니다.

---

## 교수님께 말할 핵심 문장

> 단순히 MAPS에서 DIF를 찾는 연구가 아니라, 시간가변 공변량에 의해 생기는 문항기능 변화가 종단 성장해석에 얼마나 섞이는지를 Bayesian MNLFA posterior로 분해하는 방법을 개발해보고 싶습니다. 핵심 개발은 counterfactual response-shift decomposition과 RSDI이고, 실자료 분석과 시뮬레이션으로 검증하려고 합니다.

---

## 설명할 때 주의할 점

이 아이디어는 아직 완성된 방법론이 아니라 **개발 가능성이 있는 연구 아이디어 후보**로 설명하는 것이 안전합니다.

교수님께는 다음처럼 말하는 것이 좋습니다.

> MNLFA 적용만으로는 개발성이 약할 수 있다고 생각해서, 관찰 응답 변화를 latent change와 measurement shift로 분해하는 방향을 고민해봤습니다. 아직 아이디어 단계이지만, Bayesian MNLFA posterior에서 counterfactual expected response를 계산하면 response-shift contribution을 지표화할 수 있을 것 같습니다. 이 방향이 방법론 개발로 확장 가능한지 검토받고 싶습니다.

피해야 할 표현:

- 제가 새로운 방법론을 완성했습니다.
- RSDI는 이미 검증된 지표입니다.
- 차별경험이 response shift를 인과적으로 발생시켰습니다.

더 안전한 표현:

- 방법론적 개발 가능성이 있는 아이디어입니다.
- 기존 MNLFA posterior를 활용한 counterfactual decomposition을 검토하려고 합니다.
- 실증분석과 Monte Carlo simulation을 통해 검증이 필요합니다.
