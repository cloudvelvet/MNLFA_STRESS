# 논문 1 원고 전략: MAPS 문화적응 스트레스 longitudinal MNLFA/RSDI

## 1. 논문 1의 가장 안전한 포지셔닝

논문 1은 “새로운 통계모형을 완전히 개발한 방법론 논문”보다는, 다음 형태가 가장 안전하다.

> MAPS 부모 패널 문화적응 스트레스 자료를 사용해, 종단 변화 해석이 측정불변성 가정에 얼마나 의존하는지 보이고, 차별경험 관련 DIF가 관찰된 응답 변화에 기여하는 정도를 RSDI로 정량화하는 실증 심리측정 논문.

핵심은 “차별 DIF가 있다”가 아니다. 더 강한 메시지는 다음이다.

> 같은 문화적응 스트레스 척도라도, 차별경험에 따라 문항 threshold/loading이 달라지면 관찰된 종단 변화는 latent change와 measurement-function change가 섞인 결과가 된다.

따라서 논문 제목과 초록은 `DIF detection`보다 `longitudinal change interpretation`, `measurement-function change`, `response-shift decomposition` 쪽으로 잡는 것이 좋다.

## 2. 한 문장 thesis

MAPS 부모 패널의 문화적응 스트레스 응답은 전반적으로 감소하는 경향을 보이지만, 차별경험 관련 문항기능 변화가 관찰된 응답 변화의 상당 부분을 설명하므로, 종단 변화 해석에서는 latent change와 measurement shift를 분리해야 한다.

## 3. 추천 제목

1. 잠재변화인가 측정이동인가? MAPS 부모 패널 문화적응 스트레스의 longitudinal ordinal MNLFA와 RSDI 분석
2. 차별경험 관련 DIF가 문화적응 스트레스 궤적 해석을 어떻게 바꾸는가
3. 관찰된 스트레스 변화의 재해석: MAPS 부모 패널의 longitudinal MNLFA와 response shift decomposition
4. 문화적응 스트레스 점수는 그대로 비교될 수 있는가? 다문화가족 부모 패널의 차별경험 관련 측정기능 변화
5. Distinguishing Latent Change from Measurement-Function Change in Longitudinal Acculturative Stress

## 4. 연구문제

### Main RQ

MAPS 부모 패널의 문화적응 스트레스 종단 변화 해석은 차별경험 관련 measurement noninvariance를 무시할 때와 모델링할 때 얼마나 달라지는가?

### Sub RQs

1. 관측점수 성장모형, 불변 ordinal latent growth model, longitudinal ordinal MNLFA는 서로 다른 변화 결론을 주는가?
2. 차별경험은 문화적응 스트레스 문항의 threshold/loading DIF와 관련되는가?
3. 차별경험 관련 measurement-function change는 관찰된 응답 변화 중 어느 정도를 설명하는가?
4. 차별경험과 내용적으로 가까운 문항 1/2/6을 제외해도 response-shift component가 유지되는가?

## 5. 핵심 기여

### Contribution 1. 종단 변화 해석의 재구성

이 논문은 문화적응 스트레스가 증가/감소했는지만 묻지 않는다. 관찰된 응답 변화가 latent change인지 measurement-function change인지 분해한다.

### Contribution 2. 차별경험을 time-varying measurement moderator로 모델링

차별경험을 단순히 latent stress의 원인 또는 예측변수로만 두지 않고, 문항 threshold/loading을 변화시키는 moderator로 다룬다.

### Contribution 3. RSDI를 통한 posterior counterfactual decomposition

DIF 계수를 보고하는 데서 끝나지 않고, 그 DIF가 longitudinal response trajectory 해석에 얼마나 기여하는지를 RSDI로 정량화한다.

### Contribution 4. semantic overlap critique에 대한 민감도 분석

차별경험과 내용적으로 가까운 Item 1/2/6을 제외해도 RSDI가 남는지 확인한다. 현재 결과에서는 drop 1/2/6 후에도 RSDI가 0.260으로 유지된다.

## 6. 원고 구조

### Introduction

1. 종단 성장모형은 반복 측정 문항의 비교가능성을 전제한다.
2. 이주/다문화가족 맥락에서는 한국어 능력, 소득, 차별경험이 빠르게 변하고, 이 요인들이 latent stress뿐 아니라 문항 반응 방식도 바꿀 수 있다.
3. 기존 연구는 DIF 검출 또는 종단 성장 해석을 각각 다루는 경우가 많지만, DIF가 종단 응답 변화에 얼마나 기여하는지 분해하는 적용은 부족하다.
4. 본 연구는 MAPS 부모 패널에서 longitudinal ordinal MNLFA와 RSDI를 사용해 latent change와 measurement shift를 분리한다.

### Method

1. Data: MAPS 2기 부모 패널, 5 waves, 문화적응 스트레스 8문항.
2. Measures: ordinal acculturative stress items, discrimination experience, Korean proficiency, income, parent age.
3. Comparator models:
   - naive observed-score growth model
   - invariant ordinal latent growth model
   - longitudinal ordinal MNLFA
4. MNLFA:
   - item thresholds and loadings moderated by time-varying covariates
   - latent growth structure
   - optional structural-state extension: covariates also predict person-wave latent state
5. RSDI:
   - total response change = latent-change component + measurement-shift component + interaction
6. Estimation:
   - full-data CmdStan variational inference
   - subset NUTS / repeated VI / Pathfinder as calibration or robustness checks
   - item 1/2/6 exclusion sensitivity

### Results

1. Descriptive observed response trajectory.
2. Comparator growth results: naive vs invariant ordinal LGM vs MNLFA.
3. Discrimination-related threshold DIF.
4. Discrimination-related loading DIF.
5. RSDI decomposition of W1 to W5 response change.
6. Fixed-latent discrimination yes/no counterfactual contrast.
7. Item 1/2/6 exclusion sensitivity.
8. Estimation robustness: VI stability and subset NUTS calibration.

### Discussion

1. Observed cultural-adaptation stress changes cannot be interpreted as pure latent change.
2. Discrimination-related item functioning is strongest for social-evaluative items but not limited to the most discrimination-proximal items.
3. Response-shift-like interpretation is plausible, but causal claims should be avoided.
4. Applied implication: longitudinal migrant-family studies should evaluate DIF before interpreting growth.
5. Methodological implication: RSDI translates DIF estimates into longitudinal trajectory interpretation.

## 7. 현재 결과에서 본문에 넣을 핵심 숫자

### Main structural-state RSDI result

W1 to W5:

| Model | Latent TV | Measurement TV | Interaction TV | RSDI |
|---|---:|---:|---:|---:|
| 8-item structural MNLFA | 0.133 | 0.096 | 0.037 | 0.360 [0.324, 0.396] |
| Drop Item 1/2/6 | 0.149 | 0.069 | 0.049 | 0.260 [0.231, 0.334] |

### Drop Item 1/2/6 residual discrimination threshold DIF

| Original item | Label | Threshold DIF | 90% CrI |
|---:|---|---:|---|
| 3 | Homesickness | -0.333 | [-0.416, -0.251] |
| 4 | Unfamiliar environment | -0.419 | [-0.498, -0.337] |
| 5 | Missing birthplace/people | -0.284 | [-0.365, -0.197] |
| 7 | Withdrawal | -0.718 | [-0.799, -0.634] |
| 8 | Perceived low social status | -0.788 | [-0.863, -0.716] |

### Drop Item 1/2/6 fixed-latent discrimination contrast

| Original item | Label | Expected response shift |
|---:|---|---:|
| 3 | Homesickness | 0.172 |
| 4 | Unfamiliar environment | 0.207 |
| 5 | Missing birthplace/people | 0.146 |
| 7 | Withdrawal | 0.356 |
| 8 | Perceived low social status | 0.400 |

## 8. 꼭 정리해야 할 분석상 주의점

### 1. 모델별 숫자를 섞지 말 것

현재 초안에는 과거 MNLFA 결과와 새 structural-state/RSDI 결과가 섞여 있다. 최종 원고에서는 주분석 모델을 하나로 정해야 한다.

추천 정리:

- Primary model: structural-state longitudinal ordinal MNLFA
- Sensitivity 1: measurement-only MNLFA
- Sensitivity 2: drop Item 1/2/6
- Calibration: subset NUTS or repeated VI

### 2. comparator가 없으면 논문 기여가 약해짐

이 논문은 “MNLFA를 돌렸다”가 아니라 “모형 가정에 따라 종단 변화 해석이 달라진다”가 핵심이다. 따라서 naive observed-score growth와 invariant ordinal latent growth model은 반드시 들어가야 한다.

### 3. VI 기반이라는 제한을 정직하게 써야 함

현재 full-data 결과는 variational inference 기반이다. 본문에서는 approximate posterior summaries로 표현하고, subset NUTS / repeated VI / Pathfinder 결과로 calibration을 붙여야 한다.

### 4. 차별경험의 인과효과처럼 쓰면 안 됨

안전한 표현:

> discrimination-related measurement-function change

피해야 할 표현:

> discrimination caused response shift

### 5. response shift도 조심해서 써야 함

안전한 표현:

> DIF patterns consistent with a response-shift interpretation

피해야 할 표현:

> response shift was proven

## 9. 필요한 추가 분석 우선순위

1. naive observed-score growth model 완성
2. invariant ordinal latent growth model 완성
3. primary model 숫자 재정렬: baseline MNLFA vs structural-state MNLFA 중 본문 주모형 결정
4. VI calibration: repeated VI, subset NUTS, 가능하면 selected NUTS
5. RSDI figure 정리: full 8-item vs drop 1/2/6 비교
6. loading DIF를 별도 표/그림으로 보고
7. missingness와 survey weight 사용 여부에 대한 방어 문장 작성

## 10. 교수님께 말할 1분 pitch

이번 논문 1은 MAPS 부모 패널의 문화적응 스트레스 변화가 단순한 잠재 스트레스 변화만이 아니라 차별경험과 연결된 측정기능 변화까지 포함한다는 점을 보여주는 실증 심리측정 논문으로 잡을 수 있습니다. 기존 성장모형은 반복 문항이 시간에 따라 동일하게 작동한다고 가정하지만, 이 자료에서는 차별경험이 일부 문항의 threshold와 loading을 바꾸는 것으로 보입니다. 더 중요한 점은 DIF를 발견하는 데서 끝나지 않고, 그 DIF가 관찰된 종단 응답 변화에 얼마나 기여하는지를 RSDI로 계산했다는 것입니다. 8문항 structural model에서는 W1에서 W5까지의 response-shift component 비중이 약 0.36이었고, 차별 내용과 가까운 문항 1/2/6을 제외해도 0.26으로 남았습니다. 그래서 이 논문은 “문화적응 스트레스가 줄었다/늘었다”보다 “무엇이 잠재변화이고 무엇이 측정이동인지 분리해서 해석해야 한다”는 메시지로 가는 것이 가장 강합니다.

## 11. 초록 초안

본 연구는 다문화가족 부모의 문화적응 스트레스 종단 변화가 실제 잠재변화만을 반영하는지, 아니면 차별경험과 연결된 측정기능 변화까지 함께 반영하는지를 검토하였다. 종단 성장모형은 반복 측정된 문항이 시간에 걸쳐 동일하게 작동한다는 가정을 전제하지만, 이주가족 맥락에서는 언어능력, 소득, 연령, 차별경험 같은 시간가변 요인이 문항 반응 방식 자체를 바꿀 수 있다. 이를 검토하기 위해 MAPS 2기 부모 패널의 5개 wave와 서열형 문화적응 스트레스 문항을 사용하여 Bayesian longitudinal ordinal MNLFA를 추정하였다. 모형에서는 잠재 스트레스의 종단 궤적과 함께 문항 loading 및 threshold가 부모 연령, 한국어 능력, 로그소득, 차별경험의 함수로 변하도록 설정하였다. 분석 결과, 차별경험 관련 threshold DIF가 여러 문항에서 나타났으며, 같은 latent stress 수준에서도 차별경험이 있는 응답자는 높은 응답범주를 선택할 확률이 더 컸다. RSDI 분석에서는 W1에서 W5까지의 응답 변화 중 measurement-shift component가 무시하기 어려운 비중을 차지했다. 특히 차별경험과 내용적으로 가까운 문항 1, 2, 6을 제외한 민감도 분석에서도 RSDI가 0.260으로 유지되어, 결과가 특정 문항의 semantic overlap에만 의존하지 않음을 보였다. 이러한 결과는 MAPS 부모 패널의 문화적응 스트레스 변화 해석에서 잠재변화와 측정기능 변화를 분리해야 함을 시사한다.
