# Item 1/2/6 제외 민감도 분석 요약

## 목적

차별경험 공변량과 문화적응 스트레스 일부 문항의 내용이 겹친다는 비판을 점검하기 위해, 원문항 1, 2, 6을 제외하고 structural-state longitudinal ordinal MNLFA를 다시 추정했다.

- 제외 문항: Item 1, Item 2, Item 6
- 포함 문항: Item 3, Item 4, Item 5, Item 7, Item 8
- 추정: CmdStan variational inference
- 표본: 2,190명, 48,225 item responses, 5 waves, 5 items
- 출력 폴더: `C:/chen_bauer_2024/poster_model_output/structural_state_full_seed20260702_drop126`

## 핵심 결과

Item 1/2/6을 제외해도 discrimination-related residual threshold DIF는 남았다. 모든 잔여 문항에서 discrimination threshold DIF의 90% credible interval이 0을 지나지 않았다.

| Original item | Content | Threshold DIF mean | 90% CrI |
|---:|---|---:|---|
| 3 | Homesickness | -0.333 | [-0.416, -0.251] |
| 4 | Unfamiliar environment | -0.419 | [-0.498, -0.337] |
| 5 | Missing birthplace/people | -0.284 | [-0.365, -0.197] |
| 7 | Withdrawal | -0.718 | [-0.799, -0.634] |
| 8 | Perceived low social status | -0.788 | [-0.863, -0.716] |

해석상 음의 threshold DIF는 동일한 latent stress 수준에서 차별경험이 있는 경우 더 높은 응답 범주를 선택할 확률이 커지는 방향이다.

## RSDI 변화

8문항 structural model과 비교하면, Item 1/2/6 제거 후 measurement component의 비중은 줄었지만 사라지지 않았다.

| Model | Latent TV | Measurement TV | Interaction TV | RSDI mean | 90% CrI |
|---|---:|---:|---:|---:|---|
| 8-item structural | 0.133 | 0.096 | 0.037 | 0.360 | [0.324, 0.396] |
| Drop Item 1/2/6 | 0.149 | 0.069 | 0.049 | 0.260 | [0.231, 0.334] |

따라서 차별경험 관련 response shift가 일부 직접적인 차별 내용 문항에 의해 커진 것은 맞지만, 결과 전체가 그 문항들에만 의존한다고 보기는 어렵다.

## 잔여 문항별 W1 to W5 RSDI

| Original item | Content | RSDI mean | 90% CrI | Measurement expected change |
|---:|---|---:|---|---:|
| 3 | Homesickness | 0.226 | [0.190, 0.304] | -0.057 |
| 4 | Unfamiliar environment | 0.245 | [0.211, 0.317] | -0.071 |
| 5 | Missing birthplace/people | 0.214 | [0.175, 0.299] | -0.040 |
| 7 | Withdrawal | 0.299 | [0.262, 0.365] | -0.094 |
| 8 | Perceived low social status | 0.315 | [0.274, 0.376] | -0.105 |

## 고정 latent trait에서 discrimination yes/no contrast

동일 latent stress 수준에서 차별경험을 0에서 1로 바꾸면, 잔여 문항에서도 expected response가 증가했다.

| Original item | Content | Expected response shift | 90% CrI |
|---:|---|---:|---|
| 3 | Homesickness | 0.172 | [0.124, 0.217] |
| 4 | Unfamiliar environment | 0.207 | [0.162, 0.249] |
| 5 | Missing birthplace/people | 0.146 | [0.098, 0.191] |
| 7 | Withdrawal | 0.356 | [0.303, 0.401] |
| 8 | Perceived low social status | 0.400 | [0.352, 0.445] |

## 논문/발표용 방어 문장

“Because discrimination experience may overlap semantically with several stress items, we conducted a sensitivity analysis excluding the most discrimination-proximal items (Items 1, 2, and 6). The response-shift component was attenuated but remained non-negligible (RSDI = 0.260, 90% CrI [0.231, 0.334]), and all remaining items still showed credible discrimination-related threshold DIF. This suggests that the estimated response shift is not solely an artifact of item-covariate semantic overlap.”

## 주의

이 결과는 variational inference 기반 예비 결과다. 최종 논문에서는 subset NUTS 또는 selected full NUTS로 calibration을 수행한 뒤 확증적 표현을 정해야 한다.
