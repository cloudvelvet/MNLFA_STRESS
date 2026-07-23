# 논문 1 Academic Pipeline 상태판

작성일: 2026-07-02

프로젝트: MAPS 부모 패널 문화적응 스트레스 종단 MNLFA/RSDI 경험논문

## 1. 현재 파이프라인 위치

현재 논문 1은 `Stage 1 RESEARCH`를 처음부터 다시 시작할 필요는 낮다. 이미 자료, 예비분석, 민감도 분석, comparator 결과가 확보되어 있으므로, 가장 적절한 진입점은 다음과 같다.

| Stage | 상태 | 판단 |
|---|---|---|
| Stage 1. Research | 부분 완료 | 방법론 및 research gap은 정리되어 있음. 다만 최종 원고 전 인용문헌 검증/보강 필요 |
| Stage 2. Write | 다음 단계 | 기존 초안은 오래된 결과와 최신 결과가 섞일 수 있으므로 v2 원고 재작성 필요 |
| Stage 2.5. Integrity | 필수 예정 | Stage 2 원고 작성 후 citation, data, result claim을 반드시 검증해야 함 |
| Stage 3. Review | 예정 | 5인 리뷰 또는 academic-paper-reviewer full review로 비판점 정리 |
| Stage 4. Revise | 예정 | 리뷰 결과에 따라 논리/분석/표현 수정 |
| Stage 4.5. Final Integrity | 필수 예정 | 제출 전 최종 claim/reference/data 검증 |
| Stage 5. Finalize | 예정 | 학회/저널 양식으로 변환 |

판정: 지금은 `Stage 2 WRITE`로 진입하는 것이 맞다.

## 2. 현재 사용 가능한 핵심 산출물

| 자료 | 경로 | 논문 내 역할 |
|---|---|---|
| 원고 전략 | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_manuscript_strategy_ko.md` | 논문 1의 주장 범위와 방어선 |
| comparator/calibration 요약 | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_comparator_calibration_summary_ko.md` | naive growth, invariant LGM, MNLFA repeated VI, subset NUTS calibration |
| item 1/2/6 제외 민감도 분석 | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/drop126_sensitivity_summary_ko.md` | semantic overlap 비판 방어 |
| 기존 경험논문 초안 | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_empirical_draft.md` | v2 원고의 재료. 그대로 쓰기보다 최신 결과에 맞게 재구성 필요 |
| 문헌지도 | `C:/chen_bauer_2024/RESEARCH/dissertation_method_development/lit_review_mnlfa_rsdi_ko.md` | Introduction 및 Discussion의 이론/방법론 배경 |
| comparator growth table | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_comparator_growth_table.csv` | 결과 표 |
| repeated VI threshold DIF stability | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_repeated_vi_threshold_discrim_stability.csv` | 핵심 DIF 안정성 표 |
| subset NUTS DIF calibration | `C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_subset_nuts_dif_calibration.csv` | VI 결과의 제한적 calibration |

## 3. 현재까지의 가장 방어 가능한 핵심 결과

### 3.1 Growth comparator

| Model | Estimator | 핵심 결과 |
|---|---|---|
| Naive observed-score LME | REML LME | time slope = -0.042 |
| Invariant ordinal LGM | full-data mean-field VI | slope_mean = -0.222, 90% interval [-0.239, -0.205] |
| Structural-state MNLFA | full-data repeated mean-field VI | slope_mean 평균 = -0.210, seed 범위 [-0.260, -0.164] |

해석 원칙:

- 세 모델 모두 감소 방향을 시사한다.
- slope의 절대 크기는 척도와 식별 조건이 달라 직접 비교하면 안 된다.
- structural-state MNLFA의 범위는 posterior interval이 아니라 VI seed 간 추정치 범위다.

### 3.2 가장 안정적인 결과: discrimination-related threshold DIF

4개 full-data VI seed에서 모든 8문항의 discrimination threshold DIF가 음수였고, 90% credible interval이 0을 지나지 않았다.

강하게 쓸 수 있는 문장:

> Across four independent full-data VI runs, discrimination-related threshold DIF was consistently negative for all eight items, suggesting that discrimination experiences were associated with lower response thresholds at comparable latent acculturative stress levels.

### 3.3 subset NUTS calibration의 안전한 해석

기존 subset NUTS 결과는 최신 structural-state MNLFA가 아니라 measurement-only MNLFA에 가깝다. 따라서 다음처럼 제한적으로만 사용해야 한다.

- 가능: 강한 discrimination threshold DIF 문항의 방향성 calibration
- 불가능: 최신 structural-state latent growth, RSDI, state effect의 직접 확증

가장 안전한 calibration claim:

- Item 1, 2, 6, 7, 8은 full-data VI와 subset NUTS가 같은 방향의 discrimination threshold DIF를 보였다.
- Item 3, 4, 5는 subset calibration에서 방향/불확실성이 약하므로 보조 또는 탐색 결과로 낮춰야 한다.

### 3.4 item 1/2/6 제외 민감도 분석

차별경험 공변량과 일부 문항 내용이 겹친다는 비판을 점검하기 위해 Item 1, 2, 6을 제외한 분석이 수행되었다.

핵심 결과:

- 8문항 structural model: RSDI = 0.360, 90% CrI [0.324, 0.396]
- Item 1/2/6 제외: RSDI = 0.260, 90% CrI [0.231, 0.334]
- 잔여 문항 3, 4, 5, 7, 8에서도 discrimination threshold DIF가 남았다.

해석:

> 문항-공변량 의미 중복이 response shift 추정치를 키웠을 가능성은 있지만, 결과 전체가 차별 관련 문항 1/2/6에만 의존한다고 보기는 어렵다.

## 4. 논문 1의 권장 framing

논문 1은 “새로운 방법론을 완전히 개발한 논문”보다 다음 framing이 더 안전하다.

> A psychometric cautionary empirical study showing that time-varying discrimination-related DIF can alter longitudinal interpretation of acculturative stress trajectories in migrant-family panel data.

권장 제목 방향:

> Disentangling Latent Change and Response Shift in Longitudinal Acculturative Stress: A Bayesian Ordinal MNLFA Application to MAPS Parent Panel Data

핵심 기여:

1. MAPS 부모 패널 문화적응 스트레스 자료에서 종단 ordinal MNLFA를 적용했다.
2. time-varying discrimination이 문항 threshold에 미치는 DIF를 모델링했다.
3. naive observed-score growth, invariant ordinal LGM, MNLFA/RSDI를 비교했다.
4. discrimination-proximal items 제외 민감도 분석으로 semantic overlap 비판을 점검했다.
5. full-data VI 결과를 repeated VI 및 subset NUTS로 calibration했다.

## 5. 반드시 조심해야 할 표현

아래 표현은 현재 단계에서 과하다.

- “NUTS posterior가 최종적으로 확증했다”
- “RSDI는 완전히 새로운 방법론이다”
- “latent slope variance가 확실히 크다”
- “Item 3/4/5의 DIF도 NUTS에서 완전히 재현되었다”
- “관찰점수와 latent slope의 크기를 직접 비교할 수 있다”

권장 표현:

- “preliminary Bayesian VI results”
- “calibrated against existing subset NUTS results for selected measurement patterns”
- “most stable evidence was found for discrimination-related threshold DIF”
- “latent decline direction was consistent, whereas variance components were sensitive to VI initialization”
- “RSDI is used as a posterior predictive/counterfactual summary of response-shift contribution”

## 6. Stage 2 WRITE에서 해야 할 일

다음 원고는 기존 `paper1_empirical_draft.md`를 그대로 고치는 것보다, 최신 결과 기준으로 v2를 새로 구성하는 것이 안전하다.

권장 산출물:

`C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs/paper1_empirical_draft_v2_ko.md`

권장 구조:

1. Introduction
   - longitudinal measurement invariance 문제
   - migrant-family panel에서 time-varying discrimination의 중요성
   - observed change와 response shift의 confounding
2. Method
   - MAPS 부모 패널 자료
   - 8문항 ordinal acculturative stress
   - naive observed-score growth
   - invariant ordinal LGM
   - Bayesian structural-state longitudinal ordinal MNLFA
   - RSDI counterfactual decomposition
3. Results
   - comparator growth results
   - discrimination threshold DIF stability
   - RSDI result
   - item 1/2/6 exclusion sensitivity
   - subset NUTS calibration
4. Discussion
   - measurement invariance 위반의 실질적 의미
   - discrimination-related response shift 해석
   - applied longitudinal research에 대한 권고
   - VI 기반 예비 결과와 calibration 필요성
5. Limitations
   - VI posterior approximation
   - subset NUTS와 structural-state model의 불일치
   - item-covariate semantic overlap
   - causal interpretation 제한

## 7. Stage 2.5 Integrity에서 반드시 검증할 항목

Stage 2 원고가 완성되면 바로 아래 항목을 검증해야 한다.

1. 모든 문헌 인용이 실제 논문과 일치하는가?
2. Chen & Bauer longitudinal MNLFA anchor를 정확히 설명했는가?
3. response shift 문헌을 과장하지 않았는가?
4. MAPS 자료 설명에서 wave, sample size, item count, missingness를 분석 파일과 일치시켰는가?
5. VI 결과와 NUTS calibration의 차이를 명확히 썼는가?
6. posterior interval과 repeated-seed range를 혼동하지 않았는가?
7. item 1/2/6 제외 민감도 분석을 방어적 보조 결과로 썼는가?
8. RSDI를 causal effect가 아니라 model-implied counterfactual estimand로 썼는가?

## 8. 현재 체크포인트

Pipeline 판정:

- 현재 단계: `Stage 2 WRITE 진입 직전`
- Stage 1 상태: 완료에 가깝지만 최종 원고 전 문헌 검증/보강 필요
- 다음 실행: `academic-paper` 계열로 논문 1 v2 초안 작성
- 그 다음 게이트: `Stage 2.5 INTEGRITY`, 필수

권장 다음 작업:

> `paper1_empirical_draft_v2_ko.md`를 작성하고, 최신 comparator/calibration/sensitivity 결과만 사용하도록 기존 초안을 재구성한다.

체크포인트:

Stage 2 원고 작성을 시작하려면 다음 응답에서 `continue`라고 입력한다.  
대신 타깃을 바꾸려면 `target: KCI`, `target: SSCI`, `target: poster`, `target: dissertation chapter`처럼 지정한다.
