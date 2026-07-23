# 논문 1 Comparator 및 Calibration 요약

## 1. 오늘 완성된 분석

논문 1에 필요한 1차 보강 분석은 완료되었다.

1. `naive observed-score growth`
2. `invariant ordinal latent growth model`
3. `structural-state MNLFA` full-data VI 반복 실행
4. 기존 subset NUTS 결과와 full-data VI의 calibration 표 생성

출력 위치:

`C:/chen_bauer_2024/RESEARCH/paper1_maps_empirical/outputs`

## 2. Comparator Growth 결과

| Model | Estimator | Parameter | Scale | Estimate | 90% interval / range |
|---|---|---|---|---:|---|
| Naive observed-score LME | REML LME | time slope | mean observed category | -0.042 | - |
| Invariant ordinal LGM | full-data mean-field VI | slope_mean | latent theta | -0.222 | [-0.239, -0.205] |
| Structural-state MNLFA | full-data repeated mean-field VI | slope_mean | latent theta | -0.210 | [-0.260, -0.164] |

해석:

- 세 모델 모두 감소 방향을 보인다.
- naive observed-score model은 관찰 평균범주 척도에서 wave가 1 증가할 때 약 `-0.042` 감소한다.
- invariant ordinal LGM과 structural-state MNLFA는 서로 다른 latent scale이므로 수치 크기를 직접 비교하면 안 된다.
- structural-state MNLFA의 `[-0.260, -0.164]`는 posterior credible interval이 아니라 4개 VI seed의 추정치 범위다.

논문 문장:

> 관찰점수 기반 성장모형과 불변 ordinal latent growth model, 그리고 structural-state MNLFA 모두 문화적응 스트레스의 감소 방향을 시사했다. 다만 모형별 척도와 식별 조건이 다르므로 slope의 절대 크기 비교보다는 방향성과 해석 차이에 초점을 두었다.

## 3. Repeated VI Stability: Structural-State MNLFA

full-data mean-field VI를 4개 seed로 반복했다.

- `20260702`
- `20260703`
- `20260704`
- `20260705`

### 3.1 Latent Growth Parameters

| Parameter | VI mean | VI SD across seeds | Min | Max | Sign stable |
|---|---:|---:|---:|---:|---|
| slope_mean | -0.210 | 0.050 | -0.260 | -0.164 | TRUE |
| slope_variance | 0.935 | 1.054 | 0.000 | 2.423 | TRUE |
| growth_sd[2] | 0.791 | 0.640 | 0.013 | 1.556 | TRUE |
| occasion_sd | 1.565 | 1.850 | 0.037 | 4.201 | TRUE |

해석:

- `slope_mean`의 방향은 모든 seed에서 음수로 안정적이다.
- 그러나 `slope_variance`, `growth_sd`, `occasion_sd`는 seed별 변동이 크다.
- 따라서 논문에서는 “latent decline direction is suggested” 정도로 쓰고, latent variance나 occasion residual 크기를 강하게 해석하면 안 된다.

논문 문장:

> Repeated VI runs consistently suggested a negative latent slope, but variance components and occasion-level residual scales were sensitive to initialization. We therefore interpret the direction of latent change more cautiously than the exact magnitude of latent heterogeneity.

## 4. Discrimination State Effects

| Predictor | VI mean | VI SD | Min | Max | All 90% CrI nonzero | Sign stable |
|---|---:|---:|---:|---:|---|---|
| discrim_between | 1.479 | 0.198 | 1.258 | 1.682 | TRUE | TRUE |
| discrim_within | -0.735 | 0.381 | -1.274 | -0.415 | TRUE | TRUE |
| income_between | -0.128 | 0.101 | -0.222 | -0.039 | TRUE | TRUE |
| income_within | 0.383 | 0.023 | 0.350 | 0.401 | TRUE | TRUE |
| korean_between | -0.978 | 0.375 | -1.431 | -0.585 | TRUE | TRUE |
| korean_within | 0.230 | 0.525 | -0.332 | 0.681 | TRUE | FALSE |

해석:

- discrimination between/within 효과는 방향은 안정적이지만 크기는 변동이 있다.
- Korean within-person effect는 sign이 seed에 따라 바뀐다.
- 따라서 structural-state effects는 보조 결과로 두고, 본문 핵심은 threshold DIF와 RSDI에 두는 것이 안전하다.

## 5. Discrimination Threshold DIF 안정성

가장 안정적인 결과는 discrimination-related threshold DIF다.

| Original item | VI mean | VI SD | Min | Max | All 90% CrI nonzero | Sign stable |
|---:|---:|---:|---:|---:|---|---|
| 2 | -1.499 | 0.089 | -1.622 | -1.416 | TRUE | TRUE |
| 6 | -1.194 | 0.062 | -1.253 | -1.133 | TRUE | TRUE |
| 1 | -1.028 | 0.076 | -1.102 | -0.948 | TRUE | TRUE |
| 8 | -0.793 | 0.141 | -0.947 | -0.623 | TRUE | TRUE |
| 7 | -0.752 | 0.153 | -0.948 | -0.591 | TRUE | TRUE |
| 4 | -0.434 | 0.133 | -0.594 | -0.311 | TRUE | TRUE |
| 3 | -0.336 | 0.118 | -0.460 | -0.217 | TRUE | TRUE |
| 5 | -0.253 | 0.110 | -0.356 | -0.139 | TRUE | TRUE |

해석:

- 8개 문항 모두 4개 seed에서 threshold DIF가 음수다.
- 8개 문항 모두 4개 seed에서 90% credible interval이 0을 지나지 않는다.
- 즉 현재 분석에서 가장 방어 가능한 핵심 결과는 “차별경험 관련 threshold DIF의 방향과 존재”다.

논문 문장:

> Across four independent full-data VI runs, discrimination-related threshold DIF was consistently negative for all eight items, and the 90% credible intervals excluded zero in every run. This was the most stable empirical pattern in the current analysis.

## 6. Existing Subset NUTS Calibration

기존 subset NUTS 결과는 최신 structural-state MNLFA가 아니라, 이전 measurement-only MNLFA의 subset NUTS 결과다.

따라서 다음처럼 써야 한다.

- 가능: 주요 measurement/DIF pattern의 방향 검증
- 불가능: 최신 structural-state latent effects의 직접 확증

### 6.1 Full-data VI vs Existing Subset NUTS: Discrimination Threshold DIF

| Original item | Full-data VI | Subset NUTS | Same direction | Both nonzero |
|---:|---:|---:|---|---|
| 2 | -1.514 | -1.270 | TRUE | TRUE |
| 6 | -1.202 | -0.906 | TRUE | TRUE |
| 1 | -1.044 | -0.869 | TRUE | TRUE |
| 7 | -0.792 | -0.578 | TRUE | TRUE |
| 8 | -0.801 | -0.546 | TRUE | TRUE |
| 3 | -0.235 | 0.256 | FALSE | TRUE |
| 5 | -0.163 | 0.234 | FALSE | TRUE |
| 4 | -0.348 | 0.124 | FALSE | FALSE |

해석:

- Item 1, 2, 6, 7, 8은 full-data VI와 subset NUTS에서 같은 방향이다.
- 특히 핵심 discrimination-proximal items인 Item 1, 2, 6은 모두 같은 방향이고 credible nonzero다.
- Item 3, 4, 5는 VI와 subset NUTS 방향이 일치하지 않으므로 강한 본문 주장에서 제외하거나 부록/제한점으로 처리하는 것이 안전하다.

논문 문장:

> The existing subset NUTS calibration supported the direction of the largest discrimination-related threshold DIF effects, especially for Items 1, 2, 6, 7, and 8. However, smaller effects for Items 3 to 5 were less stable across estimation strategies.

## 7. 논문 1에서 쓸 수 있는 가장 안전한 결론

가장 강하게 말할 수 있는 것:

1. 관찰점수, invariant ordinal LGM, MNLFA 모두 감소 방향을 시사한다.
2. 차별경험 관련 threshold DIF는 반복 VI에서 매우 안정적이다.
3. 핵심 문항 Item 1, 2, 6, 7, 8의 threshold DIF 방향은 기존 subset NUTS calibration과도 대체로 일치한다.
4. Item 1/2/6 제외 민감도 분석에서도 RSDI가 남아 있어, 결과 전체가 단순 semantic overlap만으로 설명되지는 않는다.

조심해야 하는 것:

1. latent slope의 정확한 크기
2. slope variance / occasion SD / latent heterogeneity
3. loading DIF의 세부 패턴
4. Item 3/4/5의 discrimination threshold DIF를 NUTS까지 확정된 결과처럼 쓰는 것
5. response shift를 인과적으로 단정하는 것

## 8. 최종 추천 framing

논문 1은 다음 프레이밍이 가장 방어 가능하다.

> MAPS 부모 패널에서 문화적응 스트레스는 전반적으로 감소하는 방향을 보이지만, 차별경험 관련 threshold DIF가 반복적으로 관찰된다. 특히 사회평가적/차별근접 문항에서 같은 latent stress 수준이라도 높은 응답범주를 선택할 threshold가 낮아지는 패턴이 안정적으로 나타난다. 따라서 MAPS 문화적응 스트레스의 종단 변화는 latent change만으로 해석하기보다 measurement-function change와 함께 해석해야 한다.

## 9. 원고에 넣을 Calibration 문단 초안

Full-data Bayesian estimation used mean-field variational inference because full NUTS was computationally prohibitive for the longitudinal ordinal MNLFA. To assess the stability of the approximate posterior summaries, we repeated the full-data VI estimation across four random seeds and compared key measurement parameters with an existing subset NUTS calibration run. The repeated VI runs consistently indicated a negative latent slope, although variance components and occasion-level residual scales were sensitive to initialization. In contrast, discrimination-related threshold DIF was highly stable: all eight items showed negative threshold DIF with 90% credible intervals excluding zero across all four VI runs. The existing subset NUTS calibration supported the direction of the largest discrimination-related threshold DIF effects, especially for Items 1, 2, 6, 7, and 8. We therefore treat the threshold-DIF pattern as the most stable empirical finding, while interpreting latent variance components, loading DIF, and exact RSDI magnitudes as approximate and model-based.

## 10. 다음에 하면 좋은 추가 확인

논문 제출 전 가장 좋은 추가 확인은 최신 structural-state model의 selected subset NUTS다.

추천 최소안:

- `n = 300` 또는 `n = 600`
- structural-state MNLFA
- 핵심 파라미터만 비교: slope_mean, threshold DIF Item 1/2/6/7/8, RSDI

하지만 논문 1 예비 원고/학회 발표 수준에서는 현재 결과만으로도 다음 주장은 가능하다.

> The robust part of the evidence is not the exact latent growth magnitude, but the repeated detection of discrimination-related threshold DIF and its implication for longitudinal interpretation.
