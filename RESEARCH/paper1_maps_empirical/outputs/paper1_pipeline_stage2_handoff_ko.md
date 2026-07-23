# 논문 1 Stage 2 WRITE Handoff

작성일: 2026-07-02

파이프라인: `academic-pipeline`  
현재 단계: `Stage 2 WRITE` 진입 직전  
다음 호출 권장: `academic-paper full` 또는 `academic-paper plan -> full`

## 1. 논문 1의 최종 framing

논문 1은 RSDI를 완성형 방법론으로 강하게 주장하는 논문이 아니라, 기존 longitudinal ordinal MNLFA posterior를 이용해 RSDI라는 새로운 decomposition estimand/index를 제안하고 MAPS 자료에 적용하는 empirical proof-of-concept 논문으로 둔다.

권장 한 문장:

> 본 연구는 MNLFA 자체의 새로운 추정법을 제안하기보다, longitudinal ordinal MNLFA posterior로부터 관찰 응답 변화의 latent-change component와 measurement-function shift component를 분해하는 Response Shift Decomposition Index(RSDI)를 제안하고, 이를 MAPS 부모 패널 자료에 적용한다.

## 2. Contribution 정리

| 층위 | 기여 | 표현 강도 |
|---|---|---|
| 방법론 배경 | MNLFA/longitudinal MNLFA는 기존 방법론 | 기존 문헌에 근거 |
| 본 연구의 새 요소 | RSDI: posterior predictive, model-implied decomposition estimand/index | 본 연구가 제안 |
| 경험적 적용 | MAPS 부모 패널 문화적응 스트레스에서 time-varying discrimination-related DIF와 RSDI 적용 | 논문 1의 중심 |
| 추후 확장 | simulation으로 recovery, bias, coverage, VI vs NUTS 검증 | 논문 2/박사논문 |

## 3. 논문 1에서 써도 되는 표현

- `we propose RSDI as a model-implied decomposition estimand`
- `posterior predictive decomposition`
- `empirical proof-of-concept`
- `response-shift-consistent measurement-function change`
- `longitudinal ordinal MNLFA application`
- `preliminary Bayesian VI results calibrated with repeated VI and subset NUTS`

## 4. 피해야 할 표현

- `we develop a new Bayesian MNLFA model`
- `RSDI proves response shift`
- `RSDI is a fully validated method`
- `discrimination caused response shift`
- `full NUTS confirmed the results`
- `observed-score slope and latent slope are directly comparable`

## 5. Stage 2 원고 구조

### Introduction

1. 종단 성장모형은 measurement invariance를 전제한다.
2. MAPS 같은 이주/다문화가족 패널에서는 차별경험, 한국어 능력, 소득이 시간에 따라 변한다.
3. 이 요인들은 latent stress뿐 아니라 item threshold/loading도 바꿀 수 있다.
4. 따라서 observed response change는 latent change와 measurement-function shift가 섞인 결과일 수 있다.
5. 기존 MNLFA는 DIF 검출에는 강하지만, observed longitudinal response change 중 measurement shift가 얼마나 기여하는지를 직접 요약하는 applied index는 부족하다.
6. 본 연구는 RSDI를 제안하고 MAPS 자료에 적용한다.

### Method

1. Data: MAPS 2기 부모 패널.
2. Measures: ordinal acculturative stress items, discrimination, Korean proficiency, income.
3. Comparator 1: naive observed-score growth.
4. Comparator 2: invariant ordinal latent growth model.
5. Primary model: Bayesian structural-state longitudinal ordinal MNLFA.
6. RSDI: posterior predictive, model-implied counterfactual decomposition.
7. Robustness/calibration: repeated VI, subset NUTS calibration, item 1/2/6 exclusion.

### Results

1. Comparator growth: naive observed-score, invariant ordinal LGM, MNLFA.
2. Discrimination-related threshold DIF stability.
3. RSDI decomposition.
4. Item 1/2/6 exclusion sensitivity.
5. VI calibration and limitations.

### Discussion

1. 문화적응 스트레스 변화 해석에서 measurement-function shift를 분리해야 한다.
2. 차별경험 관련 threshold DIF는 observed response trajectory 해석을 바꿀 수 있다.
3. RSDI는 DIF 계수를 longitudinal change interpretation으로 번역하는 index다.
4. 다만 현재 논문은 proof-of-concept이며, full methodological validation은 simulation study가 필요하다.

## 6. 핵심 결과로 사용할 숫자

| 결과 | 값 | 해석 |
|---|---:|---|
| Naive observed-score LME slope | -0.042 | 관찰 평균범주 척도에서 감소 |
| Invariant ordinal LGM slope_mean | -0.222 [-0.239, -0.205] | 불변 측정모형에서 latent 감소 |
| Structural-state MNLFA slope_mean | mean -0.210, seed range [-0.260, -0.164] | repeated VI에서 감소 방향 안정 |
| 8-item RSDI W1-W5 | 0.360 [0.324, 0.396] | measurement-shift component가 무시하기 어려움 |
| Drop item 1/2/6 RSDI W1-W5 | 0.260 [0.231, 0.334] | semantic overlap 제거 후에도 유지 |

주의:

- structural-state MNLFA slope range는 posterior interval이 아니라 VI seed range다.
- 8-item RSDI와 drop-item RSDI는 VI 기반 preliminary result다.
- subset NUTS는 최신 structural-state model의 직접 검증이 아니라 selected measurement/DIF pattern calibration으로만 쓴다.

## 7. 현재 보유 산출물

| 산출물 | 경로 |
|---|---|
| Pipeline status | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_academic_pipeline_status_ko.md` |
| Introduction draft | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_introduction_draft_v0_ko.md` |
| Manuscript strategy | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_manuscript_strategy_ko.md` |
| Comparator/calibration summary | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_comparator_calibration_summary_ko.md` |
| Drop item 1/2/6 sensitivity | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/drop126_sensitivity_summary_ko.md` |
| Existing empirical draft | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_empirical_draft.md` |

## 8. Stage 2.5 Integrity에서 막아야 할 문제

1. RSDI를 이미 검증 완료된 일반 방법론처럼 쓰지 않는다.
2. VI posterior approximation을 숨기지 않는다.
3. subset NUTS calibration의 범위를 과장하지 않는다.
4. response shift를 causal effect로 쓰지 않는다.
5. item 1/2/6 semantic overlap 문제를 limitation과 sensitivity analysis에 명시한다.
6. 모든 DOI와 reference metadata는 원고 완성 후 citation-check에서 재검증한다.

## 9. 다음 체크포인트

현재 파이프라인은 `Stage 2 WRITE`로 넘어갈 준비가 되어 있다.

권장 다음 산출물:

`C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_empirical_draft_v2_ko.md`

작성 방식:

- 기존 초안을 수정하기보다 v2 원고를 새 파일로 작성한다.
- Introduction은 `paper1_introduction_draft_v0_ko.md`를 기반으로 한다.
- Results는 최신 comparator/calibration/sensitivity 결과만 사용한다.
- RSDI는 “new estimand/index”로 표현한다.
