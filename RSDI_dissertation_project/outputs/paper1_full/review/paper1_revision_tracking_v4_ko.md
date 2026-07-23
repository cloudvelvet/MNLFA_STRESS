# 논문 1 v4 수정 추적표

## 수정 기준

- 기준 원고: `paper1_empirical_manuscript_v3_ko.md`
- 수정 원고: `paper1_empirical_manuscript_v4_draft_ko.md`
- 적용 모드: academic-paper revision
- 상태: 방법론적 제안과 예비 실증 적용을 포함한 박사학위논문 Paper 1 초안

## 주요 수정 사항

| 쟁점 | v4 조치 | 상태 |
|---|---|---|
| RSDI의 독창성 과장 가능성 | response-shift 분해 자체를 최초 주장하지 않고, 종단 순서형 MNLFA·반사실적 범주확률·총변동거리의 운용적 통합으로 한정하였다. | 반영 |
| 벡터 분해와 거리 분해의 혼동 | 확률벡터 수준에서는 가법 항등식이 성립하지만 각 경로의 TV 거리는 일반적으로 가법적이지 않으며 관찰변화의 백분율이 아님을 명시하였다. | 반영 |
| 식별조건의 불명확성 | 복수 앵커 문항의 DIF를 0으로 두고 하나의 marker loading을 1로 고정하는 기준을 명시하였다. | 반영 |
| 선행연구 공백의 근거 부족 | Verdam et al. (2016, 2021), Sinning et al. (2008), Fairlie (2017)를 추가해 response-shift 및 비선형 분해와의 관계를 구체화하였다. | 반영 |
| 문장 미완성 및 선언문 누락 | 결과·자료이용·연구윤리 문장의 미완성 종결을 교정하고 Data Availability, Ethics, CRediT, Conflict, Funding, AI disclosure를 완결하였다. | 반영 |
| 수식 깨짐 | Pandoc 입력 형식에 single-backslash TeX 수식 확장을 추가해 10개 표시수식을 Word OMML 개체로 생성하였다. | 반영 |
| 표·부록 하단 넘침 | 절·표 캡션·부록 앞의 페이지 나눔을 조정하고 한컴/rhwp 30쪽 렌더에서 overflow 0을 확인하였다. | 반영 |
| 확증적 분석의 부족 | 현재 RSDI 수치를 탐색적 기술량으로 한정하고 동일모형 NUTS, PPC, recovery simulation, IPW/가중치 분석을 후속 필수 과제로 유지하였다. | 의도적 제한 |
| 단일요인·회상창·탈락·ID 추적 문제 | 제한점과 최종 Paper 1 전환 우선순위에 명시하였다. | 의도적 제한 |

## 결론

v4는 논문의 개념적 기여, 수학적 의미, 식별조건 및 예비 결과의 해석 경계를 명확히 한 초안이다. 다만 현재 수치가 VI 기반 예비 분석이므로, 투고 또는 학위심사 제출본으로 전환하려면 확증적 추정과 모의실험이 선행되어야 한다.
