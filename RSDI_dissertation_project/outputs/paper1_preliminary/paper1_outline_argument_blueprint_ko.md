# 논문 1 개요 및 논증 청사진

## 잠정 제목

**종단 서열형 패널자료에서 잠재변화와 측정기능 변화를 분해하기 위한 베이지안 MNLFA 기반 RSDI: MAPS 부모 패널의 문화적응 스트레스 적용**

영문 제목: *A Bayesian Longitudinal MNLFA Framework for Decomposing Latent Change and Measurement-Function Shift in Ordinal Panel Data*

## 중심 주장과 경계

MAPS 부모 패널의 문화적응 스트레스 응답은 시간에 따른 잠재 스트레스 변화만으로 해석될 수 없다. 베이지안 종단 서열형 MNLFA의 posterior-predictive counterfactual을 이용한 RSDI는 관찰된 응답변화 중 measurement-function shift가 차지하는 몫을 정량화한다.

- RSDI는 **model-implied decomposition estimand/index**이며, 새 sampler나 완전 검증된 일반 방법이 아니다.
- 차별경험 관련 DIF는 **response-shift 해석과 일관된** 패턴이지 인과적 response shift의 증거가 아니다.
- full-data 결과는 VI 기반의 예비 결과다. 반복 VI는 방향 안정성을, 기존 subset NUTS는 일부 핵심 threshold DIF의 제한된 보정을 제공한다.

## 상세 개요와 분량

| 절 | 목표 분량 | 핵심 내용 |
|---|---:|---|
| 초록 | 250–300단어 | 문제, 자료·모형, RSDI, 핵심 결과, 제한점 |
| 1. 서론 | 1,200–1,400단어 | 불변성 가정, 이주 패널의 시간가변 조절변수, MNLFA와 RSDI의 공백 |
| 2. 이론·방법 배경 | 900–1,100단어 | 서열형 종단 불변성, MNLFA, response-shift-like 해석, RSDI 정의 |
| 3. 방법 | 1,300–1,500단어 | MAPS 2기 부모 패널, 5 waves·8문항, 비교모형, structural-state MNLFA, 추정·보정 |
| 4. 결과 | 1,400–1,600단어 | 비교 성장, 반복 VI, threshold DIF, RSDI, 민감도·subset NUTS |
| 5. 논의 | 1,300–1,500단어 | 해석 변화, 방법·응용 함의, 한계, 후속 검증 |
| 결론 | 250–350단어 | 검증 가능한 최소 결론 |

## 결과 절의 고정 보고 순서

1. **비교모형:** naive observed-score LME time slope = -0.042; invariant ordinal LGM slope mean = -0.222 [ -0.239, -0.205 ]; structural-state MNLFA repeated-VI mean = -0.210, seed range [ -0.260, -0.164 ]. 척도가 달라 크기를 직접 비교하지 않는다.
2. **반복 VI 안정성:** 잠재 기울기의 음의 방향은 안정적이나 분산·occasion residual은 초기값에 민감함을 먼저 밝힌다.
3. **threshold DIF:** 8개 문항의 음의 차별경험 관련 threshold DIF가 4회 VI에서 일관되게 나타난다.
4. **RSDI 분해:** W1–W5의 8문항 구조상태 모형에서 RSDI = 0.360 [0.324, 0.396]. 이는 measurement-shift 성분의 비중을 요약한 예비 VI 결과다.
5. **의미중첩 민감도:** Item 1/2/6을 제외해도 RSDI = 0.260 [0.231, 0.334]이고 잔여 5문항에서 threshold DIF가 남는다.
6. **보정 범위:** 기존 subset NUTS는 Item 1/2/6/7/8의 가장 큰 threshold DIF 방향과 부합하지만 최신 structural-state 모형 전체를 직접 검증한 것은 아니다.

## 논증 사슬

| 주장 | 필요한 근거 | 현재 상태 | 반론·제한 |
|---|---|---|---|
| 종단 점수변화의 잠재변화 해석에는 불변성 검토가 필요하다 | 종단 SEM·서열형 불변성 문헌 | 확보 | 모든 비불변성이 실질적으로 큰 편향을 뜻하지는 않음 |
| MNLFA는 시간가변 연속 조절변수의 문항 threshold/loading 변화를 모델링할 수 있다 | MNLFA 문헌·모형 명세 | 확보 | 식별·모형복잡도·추정 부담 |
| RSDI는 DIF 결과를 종단 응답변화 해석으로 연결한다 | posterior counterfactual 정의·분해식 | 코드·예비결과 확보 | 일반적 타당화는 Paper 2 simulation이 필요 |
| 핵심 안정 패턴은 차별경험 관련 threshold DIF다 | 반복 VI·subset NUTS 비교 | 확보 | 작은 문항효과와 loading DIF의 안정성은 제한적 |
| 의미중첩만으로 전체 결과를 설명하기 어렵다 | drop-1/2/6 민감도 | 확보 | 비판을 완전히 제거하지 않으며 한계로 명시 |

## 필수 표·그림

1. 표 1: 표본·wave·변수·결측 처리 개요.
2. 표 2: 세 비교모형의 추정량·척도·해석 범위.
3. 표 3: 반복 VI의 잠재기울기와 주요 threshold DIF 안정성.
4. 표 4: 8문항 및 drop-1/2/6 RSDI 분해.
5. 그림 1: 관찰 변화 = 잠재변화 + measurement shift + interaction의 RSDI 개념도.
6. 그림 2: 문항별 차별경험 threshold DIF와 90% CrI.
7. 그림 3: 8문항·민감도 모형의 RSDI 비교.

## 최종 원고의 의무 항목

Data Availability Statement, Ethics Declaration, CRediT 저자기여, Conflict of Interest, Funding Acknowledgment, AI usage disclosure를 최종 확정 정보로 작성한다. MAPS 원자료는 이 저장소에 없으므로 접근절차와 재현 코드의 범위를 분리해 명시한다.
