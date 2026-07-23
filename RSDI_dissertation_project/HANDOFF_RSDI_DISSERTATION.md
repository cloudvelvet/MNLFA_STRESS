# Handoff: RSDI Dissertation Project

## 한 줄 요약

Bayesian longitudinal ordinal MNLFA를 기반으로, 관찰된 종단 응답 변화가 latent change 때문인지 measurement-function change(response-shift-like DIF) 때문인지 posterior counterfactual로 분해하는 RSDI 방법론 개발 프로젝트다.

## 연구 질문

1. 시간가변 공변량(discrimination, Korean proficiency, income 등)이 ordinal item threshold/loading을 변화시킬 때, 기존 observed-score growth 또는 invariant ordinal LGM의 성장해석은 얼마나 달라지는가?
2. Longitudinal ordinal MNLFA가 latent trajectory와 time-varying DIF를 동시에 회복할 수 있는가?
3. 관찰된 응답 변화 중 measurement-function change가 차지하는 기여분을 RSDI로 안정적으로 추정할 수 있는가?
4. discrimination-proximal items를 제외해도 response-shift-like component가 남는가?

## 현재 확보된 근거

- MAPS parent panel acculturative stress 8 ordinal items.
- discrimination-related threshold DIF가 repeated full-data VI에서 안정적으로 음의 방향을 보임.
- subset NUTS calibration에서 가장 큰 item effects의 방향은 VI와 일치.
- naive observed-score growth, invariant ordinal LGM, structural-state MNLFA comparator 결과 일부 확보.
- item 1/2/6 제외 민감도 분석에서 효과는 약화되지만 완전히 사라지지 않는 패턴이 있음.

## 가장 중요한 방어 논리

- 이 연구는 단순히 DIF를 찾는 연구가 아니다.
- 핵심은 DIF가 longitudinal change interpretation에 얼마나 기여하는지 분해하는 것이다.
- response shift라는 용어는 조심스럽게 사용한다. 현재 자료만으로 causal response shift를 입증하지 않고, response-shift-like measurement-function change로 표현하는 것이 안전하다.
- VI 결과는 posterior approximation이므로 direction-focused preliminary result로 보고하고, full NUTS 또는 targeted NUTS calibration을 장기 과제로 둔다.

## 파일 안내

- 계획서: `docs/proposal/RSDI_dissertation_proposal_ko_revised.docx`
- 문헌 지도: `docs/literature/lit_review_mnlfa_rsdi_ko.md`
- 연구 gap 설명: `docs/literature/research_gap_explanation_ko.md`
- 교수님 설명용: `docs/briefs/rsdi_professor_brief_ko.md`
- 핵심 코드:
  - `analysis/stan/longitudinal_ordinal_mnlfa.stan`
  - `analysis/scripts/rsdi_postprocess.R`
  - `analysis/scripts/sim_recovery.R`
  - `analysis/scripts/make_rsdi_preliminary_results.R`
- 예비결과:
  - `outputs/paper1_preliminary/paper1_comparator_growth_table.csv`
  - `outputs/paper1_preliminary/paper1_repeated_vi_threshold_discrim_stability.csv`
  - `outputs/paper1_preliminary/paper1_subset_nuts_dif_calibration.csv`
  - `outputs/paper1_preliminary/drop126_sensitivity_summary_ko.md`

## 주의할 점

- 포스터 파일은 이 프로젝트에 넣지 않았다.
- MAPS 원자료는 복사하지 않았다. 데이터 위치는 `data/README.md`를 확인한다.
- 기존 메모 일부는 인코딩이 깨져 보일 수 있다. 새로 쓰는 논문 원고에는 이 `HANDOFF`와 `README`의 용어를 기준으로 삼는다.

