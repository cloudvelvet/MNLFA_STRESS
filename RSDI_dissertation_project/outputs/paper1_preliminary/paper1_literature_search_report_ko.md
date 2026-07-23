# 논문 1 문헌 검색·통합 보고서

## 검색 전략

- **핵심 문제:** 종단 서열형 척도에서 측정불변성이 성립하지 않을 때, 관찰된 변화와 잠재변화의 해석이 어떻게 달라지는가.
- **핵심 방법:** longitudinal MNLFA, DIF, Bayesian ordinal modeling, posterior-predictive counterfactual decomposition.
- **포함 기준:** 동료심사 논문 또는 고전적 방법론, 연구문제와 직접 연결된 이론·방법·응용 근거, 영어 또는 한국어 문헌.
- **제외 기준:** 측정모형을 다루지 않는 단순 평균점수 연구, 원문·초록·서지정보 확인이 불가능한 출처, MAPS 문항수준 DIF의 직접 증거로 일반 배경문헌을 과장하는 인용.

| 목적 | 예시 검색식 | 우선 데이터베이스 |
|---|---|---|
| 종단 불변성 | `("longitudinal measurement invariance" OR "longitudinal DIF") AND (ordinal OR ordered-categorical)` | Web of Science, Scopus, PsycINFO |
| MNLFA | `("moderated nonlinear factor analysis" OR MNLFA) AND (DIF OR invariance OR longitudinal)` | PsycINFO, Google Scholar |
| 반응이동 | `("response shift" AND (SEM OR "measurement invariance"))` | PsycINFO, PubMed |
| 베이지안 추정 | `("variational inference" OR NUTS OR Pathfinder) AND Bayesian AND (psychometric OR latent)` | Web of Science, 출판사 원문 |

## 스크리닝·포화 판단

- 사용자가 제공한 핵심문헌 목록: 14편
- DOI·초록을 추가 확인해 보강한 방법론 문헌: 6편
- 현재 본문에 배정한 핵심 문헌: 20편
- 포화 판단: 종단 불변성, MNLFA/DIF, 서열형 문항모형, 반응이동, 베이지안 추정의 다섯 주제에 각 3편 이상의 근거가 배정되었다.

## 문헌 매트릭스

| 문헌군 | 종단 불변성 | MNLFA/DIF | 서열형 문항 | 반응이동 | 베이지안 추정 | 적용 배경 |
|---|---:|---:|---:|---:|---:|---:|
| Meredith (1993); Widaman et al. (2010); Liu et al. (2017); Wu & Estabrook (2016) | 주 |  | 주 |  |  |  |
| Curran et al. (2014); Bauer (2017); Gottfredson et al. (2020); De Bondt et al. (2023); Kush et al. (2022) |  | 주 | 주 |  | 일부 |  |
| Chen & Bauer (2026); Koch et al. (2024) | 주 | 주 | 일부 |  | 일부 |  |
| Samejima (1969); Steinberg & Thissen (2006) |  | 주 | 주 |  |  |  |
| Sprangers & Schwartz (1999); Oort (2005) | 일부 |  |  | 주 |  |  |
| Blei et al. (2017); Vehtari et al. (2021) |  |  |  |  | 주 |  |
| Berry (1997); Pascoe & Smart Richman (2009) |  |  |  |  |  | 주 |

## 주석형 핵심 문헌

1. **Meredith (1993); Widaman et al. (2010).** 시간 간 잠재변화 비교가 측정의 동등성 가정에 의존한다는 고전적 근거다. 서론의 문제 제기에 사용한다.
2. **Liu et al. (2017); Wu and Estabrook (2016).** 서열형 반응에서 종단 불변성 검정과 식별의 쟁점을 다룬다. 문항을 연속형 합산점수로 환원하지 않는 이유와 invariant ordinal LGM의 한계를 설명한다.
3. **Curran et al. (2014); Bauer (2017).** MNLFA가 연속·범주형 조절변수에 따른 문항 threshold와 loading의 변화를 다룰 수 있음을 제시한다. 방법론의 직접 근거다.
4. **Gottfredson et al. (2020); De Bondt et al. (2023); Kush et al. (2022).** 다중 배경변수, 규제화, 베이지안 패널티 및 구현 선택을 보강한다.
5. **Chen and Bauer (2026); Koch et al. (2024).** 종단 MNLFA의 실용적 적용 및 기존 성장모형의 편향 가능성을 뒷받침한다. 본 논문의 RSDI가 이미 일반적으로 검증되었다는 근거로 사용하지 않는다.
6. **Samejima (1969); Steinberg and Thissen (2006).** graded response model, 문항기능, DIF 효과 해석의 기반이다.
7. **Sprangers and Schwartz (1999); Oort (2005).** response shift의 개념적 언어를 제공한다. 본문에서는 이를 인과적 증명으로 쓰지 않고 `response-shift-like measurement-function change`로 제한한다.
8. **Blei et al. (2017); Vehtari et al. (2021).** VI의 근사성과 MCMC 수렴·불확실성 진단의 필요성을 뒷받침한다.
9. **Berry (1997); Pascoe and Smart Richman (2009).** 문화적응과 차별경험의 실질적 배경이다. MAPS 문항별 DIF의 직접 증거로 사용하지 않는다.

## 식별된 공백과 본 논문의 위치

1. 기존 MNLFA는 DIF를 식별하지만, 그 DIF가 관찰된 종단 응답변화 해석에 기여하는 몫을 직접 요약하는 지표는 제한적이다.
2. 시간가변 차별경험이 이주·다문화 패널의 서열형 스트레스 문항 기능을 조절하는지, 그 결과가 성장 해석을 어떻게 바꾸는지에 관한 응용이 부족하다.
3. response shift 문헌과 서열형 MNLFA의 연결은 개념적으로 유용하지만, posterior counterfactual 분해의 일반적 타당화는 별도의 simulation이 필요하다.
4. 고차원 종단 서열형 MNLFA에서 full NUTS는 계산 부담이 크므로 VI·반복 VI·subset NUTS의 근거 범위를 분리해 투명하게 보고해야 한다.

## 인용 메타데이터 점검 메모

- `sources/key_sources.md`의 DOI 14건을 초안의 출발점으로 사용한다.
- 원고에 넣기 전에는 저자명·연도·권(호)·쪽수·DOI를 출판사 또는 Crossref에서 개별 재검증한다.
- 추가 확인 문헌: Chen and Bauer (2026), DOI `10.1080/00273171.2026.2640576`; De Bondt et al. (2023), DOI `10.1037/met0000552`.
