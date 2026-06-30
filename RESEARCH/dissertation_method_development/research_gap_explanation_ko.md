# Research Gap 상세 설명

주제: **Bayesian longitudinal ordinal MNLFA와 RSDI를 이용한 latent change / measurement shift 분해**

작성일: 2026-06-30

---

## 핵심 요약

현재 연구의 research gap은 네 층위로 정리할 수 있습니다.

1. **Gap 1: 실증 적용의 희소성**  
   Longitudinal MNLFA는 있지만, MAPS 같은 migrant-family panel에서 ordinal acculturative-stress items와 time-varying discrimination DIF를 결합한 적용은 드뭅니다.

2. **Gap 2: 핵심 방법론적 빈틈**  
   DIF 검출은 많지만, 그 DIF가 longitudinal change 해석에 얼마나 기여했는지를 분해하는 posterior-based contribution index는 아직 명확히 정리되어 있지 않습니다.

3. **Gap 3: 이론 연결의 빈틈**  
   Response shift 문헌과 ordinal MNLFA 문헌은 각각 존재하지만, response shift를 item threshold/loading 변화와 posterior predictive probability로 직접 연결하는 작업은 덜 명확합니다.

4. **Gap 4: 계산/추정 실무의 빈틈**  
   대규모 longitudinal ordinal MNLFA는 full NUTS가 매우 무겁기 때문에, VI, Pathfinder, subset NUTS, selected NUTS를 결합한 calibration workflow가 필요합니다.

가장 중요한 것은 **Gap 2**입니다. 박사논문에서 “방법론적 개발” 느낌은 여기서 나옵니다.

---

## Gap 1. Longitudinal MNLFA는 있지만, ordinal migrant-panel discrimination DIF 적용은 드물다

이 gap은 **자료 맥락의 gap**입니다.

Chen and Bauer의 longitudinal MNLFA 연구는 시간이 지나면서 construct 자체도 변하고 measurement function도 변할 수 있으므로, 둘을 같이 모형화해야 한다는 방법론적 근거를 제공합니다.

그런데 MAPS 자료는 다음과 같은 특수성이 있습니다.

- migrant-family panel
- acculturative stress
- ordinal Likert-type items
- time-varying discrimination
- Korean proficiency, income 같은 빠르게 변할 수 있는 covariates
- 부모 패널의 반복측정 구조

이 조합이 중요한 이유는 다문화가족 자료에서 discrimination이 단순한 “스트레스 예측변수”가 아니라, 특정 문항을 해석하고 응답하는 방식 자체와 연결될 수 있기 때문입니다.

예를 들어 다음 문항은 discrimination 경험과 내용적으로 매우 가깝습니다.

- 한국 사람들이 나에게 편견을 가지고 있다.
- 외국출신자를 무시하는 것에 화가 난다.
- 한국 사람들과 다른 대우를 받는다.

같은 latent acculturative stress 수준이어도 discrimination 경험자가 이런 문항에서 더 높은 범주를 선택할 수 있습니다. 따라서 discrimination은 latent stress의 predictor일 뿐 아니라, item functioning의 predictor일 가능성도 있습니다.

### Gap 1의 주장

> Longitudinal MNLFA라는 방법은 존재하지만, migrant-family panel에서 time-varying discrimination을 ordinal acculturative-stress item의 DIF predictor로 다룬 실증 적용은 제한적이다.

단, 이 gap만으로는 박사논문급 방법론 개발이라고 보기는 어렵습니다. 이것은 주로 **좋은 응용 연구의 근거**입니다.

---

## Gap 2. DIF 검출은 있지만, longitudinal change 해석에 대한 contribution decomposition은 부족하다

이 gap이 현재 연구의 핵심입니다.

기존 DIF/MNLFA 연구는 보통 다음과 같은 결과를 보고합니다.

> Item 2에서 discrimination threshold DIF가 있다.  
> Item 6에서 loading DIF가 있다.  
> Korean proficiency가 어떤 문항의 threshold와 관련된다.

이것은 “어디에 DIF가 있는지”를 알려줍니다.

하지만 종단 연구자가 실제로 궁금한 것은 한 단계 더 나아간 질문입니다.

> 시간이 지나면서 점수가 변했는데, 이 변화가 실제 latent stress 변화인가?  
> 아니면 문항기능 변화 때문에 그렇게 보이는 것인가?  
> 둘이 각각 얼마나 기여했는가?

기존 MNLFA 결과만 보면 DIF 계수는 알 수 있지만, 그 DIF가 **성장궤적 해석에 얼마나 영향을 줬는지**는 바로 보이지 않습니다.

여기서 RSDI가 들어갑니다.

---

## RSDI의 기본 아이디어

관찰 응답 변화인 `Total change`를 다음 세 성분으로 나눕니다.

```text
Total response change
= latent-change component
+ measurement-shift component
+ interaction component
```

예를 들어 Item 6에서 예측 응답이 wave 1에서 wave 5로 증가했다고 가정할 수 있습니다.

기존 해석은 다음과 같을 수 있습니다.

> 분노 문항 점수가 증가했다. 따라서 스트레스가 증가한 것 같다.

하지만 RSDI를 이용하면 다음처럼 해석할 수 있습니다.

> latent stress 자체는 감소하거나 거의 변하지 않았는데, discrimination-related threshold shift 때문에 높은 응답확률이 올라갔다. 따라서 관찰 응답 변화의 상당 부분은 latent change가 아니라 measurement shift 성분이다.

즉 RSDI는 단순히 DIF를 찾는 것이 아니라, 그 DIF가 longitudinal response trajectory 해석에 얼마나 기여했는지를 계산하려는 지표입니다.

### Gap 2의 기여

> DIF를 탐지하는 데서 끝나지 않고, DIF가 longitudinal response trajectory 해석에 기여한 정도를 posterior counterfactual로 정량화한다.

이 부분은 “방법론적 개발”이라고 말할 수 있는 핵심입니다. 완전히 새로운 모형 class를 발명하는 것은 아니지만, **새 estimand / 새 해석 지표 / 새 workflow**입니다.

---

## Gap 3. Response shift 문헌과 ordinal MNLFA 문헌 사이의 연결이 아직 약하다

Response shift 문헌은 오래되었습니다. 특히 건강 관련 삶의 질 연구에서 많이 발전했습니다.

핵심은 사람이 시간이 지나면서 응답 기준을 바꿀 수 있다는 것입니다.

예를 들어:

- 예전에는 “매우 힘들다”고 느꼈던 상태를 나중에는 “보통”으로 평가함
- 삶의 가치 우선순위가 바뀜
- construct 자체를 이해하는 방식이 바뀜

이론적으로는 매우 풍부하지만, 이것을 ordinal item threshold/loading 변화와 직접 연결하는 작업은 항상 명확하지 않습니다.

현재 연구에서는 response shift를 더 구체적으로 계량화할 수 있습니다.

- **threshold shift**: 같은 latent level에서 높은 범주를 선택하는 기준 변화
- **loading DIF**: latent trait와 item response 사이의 관계 강도 변화
- **posterior predictive probability**: 실제 응답확률 차이
- **counterfactual curve**: discrimination이 없었다면 어땠을지 보여주는 반사실적 곡선

즉 response shift를 말로만 설명하는 것이 아니라, 다음 질문으로 바꿀 수 있습니다.

> discrimination = 0일 때와 1일 때, 같은 eta에서 `P(Y >= 4)`가 얼마나 바뀌는가?

이것이 Gap 3의 장점입니다.

다만 표현은 조심해야 합니다.

피해야 할 표현:

> response shift를 증명했다.

더 안전한 표현:

> discrimination-related DIF patterns are consistent with a response-shift interpretation.

한국어로:

> 차별경험 관련 DIF 패턴은 response shift 해석과 일관된다.

따라서 Gap 3은 **이론적 연결의 기여**입니다.

---

## Gap 4. 대규모 longitudinal ordinal MNLFA의 추정전략이 실용적으로 어렵다

이 gap은 **계산방법/추정전략의 gap**입니다.

현재 모델은 계산적으로 무겁습니다. 이유는 다음과 같습니다.

- 사람마다 latent intercept/slope가 있음
- person-wave residual이 있음
- item이 8개
- wave가 여러 개
- ordinal likelihood 사용
- threshold가 여러 개
- loading DIF와 threshold DIF를 함께 추정
- covariates가 age, Korean proficiency, income, discrimination 등 여러 개
- posterior geometry가 복잡함

이런 모델을 full NUTS로 돌리면 시간이 오래 걸립니다. 실제 분석에서도 full-data NUTS는 현실적으로 매우 무거웠고, full-data 결과는 VI 기반으로 산출했으며, subset NUTS로 주요 패턴을 검증했습니다.

따라서 Gap 4는 다음처럼 정리할 수 있습니다.

> Longitudinal ordinal MNLFA는 이론적으로 매력적이지만, 실제 대규모 패널자료에서는 full Bayesian posterior inference가 계산적으로 어렵다. 따라서 approximate inference와 exact validation을 결합한 calibration workflow가 필요하다.

---

## 가능한 estimation calibration workflow

현실적인 workflow는 다음과 같습니다.

1. **Full-data VI로 전체 패턴 screening**
   - 전체 자료를 사용해 대략적인 DIF 패턴과 latent trajectory를 확인합니다.

2. **Repeated VI 또는 Pathfinder로 안정성 확인**
   - 초기값과 근사추정 방식에 따라 결과가 크게 흔들리는지 봅니다.

3. **Subset NUTS로 주요 DIF 방향과 크기 확인**
   - 계산 가능한 subset에서 NUTS posterior를 얻고, VI 결과와 방향/순위가 일치하는지 봅니다.

4. **Selected model만 longer NUTS**
   - 모든 후보를 full NUTS로 돌리기보다, 이론적으로 중요한 reduced/selected model에 집중합니다.

5. **VI와 NUTS의 posterior mean, SD, rank ordering, interval width 비교**
   - 단순히 평균만 비교하지 않고 불확실성 추정과 DIF ranking 안정성까지 봅니다.

이 전략을 사용하면 Paper 3로 발전시킬 수 있습니다.

나쁜 주장:

> VI로 충분하다.

좋은 주장:

> VI는 screening과 탐색에 유용하지만, 핵심 inference는 NUTS/Pathfinder/subset validation으로 보정해야 한다.

---

## 박사논문에서 각 gap의 역할

### Paper 1. MAPS empirical paper

주로 Gap 1, Gap 2, Gap 3과 연결됩니다.

질문:

> MAPS acculturative stress의 종단 변화 해석은 discrimination-related item functioning을 고려하면 달라지는가?

핵심 분석:

- naive growth
- invariant ordinal growth
- longitudinal MNLFA
- RSDI decomposition

### Paper 2. Monte Carlo paper

주로 Gap 2와 연결됩니다.

질문:

> time-varying DIF가 있을 때 RSDI와 longitudinal MNLFA가 latent slope와 measurement shift를 잘 회복하는가?

핵심 분석:

- true latent change known
- true DIF known
- naive model bias 확인
- MNLFA recovery 확인
- RSDI recovery 확인

이 paper가 방법론 개발의 진짜 검증 파트입니다.

### Paper 3. Estimation strategy paper

주로 Gap 4와 연결됩니다.

질문:

> 대규모 ordinal longitudinal MNLFA에서 VI, Pathfinder, subset NUTS, selected NUTS를 어떻게 조합해야 실용적이면서 방어 가능한가?

핵심 분석:

- runtime
- convergence diagnostics
- posterior mean 차이
- posterior SD/interval 차이
- DIF ranking stability
- RSDI stability

---

## 가장 강한 한 문장

교수님께는 다음처럼 말할 수 있습니다.

> 기존 longitudinal MNLFA는 measurement change를 모형화할 수 있다는 방법론적 기반을 제공하지만, 실제 종단 응답 변화 중 latent change와 measurement shift가 각각 얼마나 기여했는지를 ordinal item response probability 수준에서 분해하는 지표는 아직 명확히 정리되어 있지 않은 것 같습니다. 그래서 저는 MAPS 자료를 적용 사례로 삼아 Bayesian longitudinal MNLFA posterior에서 counterfactual expected response를 계산하고, 이를 RSDI로 정량화하는 방향을 생각하고 있습니다.

더 짧게 말하면:

> **DIF가 있다**에서 끝내지 않고, **그 DIF가 종단 변화 해석을 얼마나 바꾸는지**를 계산하겠다는 것입니다.

이것이 현재 연구의 가장 좋은 개발 포인트입니다.

