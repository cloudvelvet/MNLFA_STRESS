# RSDI Dissertation Project

이 폴더는 포스터 프로젝트와 분리한 박사학위논문용 작업공간이다.

주제는 **Bayesian longitudinal ordinal MNLFA를 이용해 관찰된 종단 응답 변화를 latent change와 measurement-function change로 분해하는 RSDI(Response-Shift Decomposition Index) 방법론 개발**이다.

## 핵심 아이디어

종단 성장모형은 반복 측정된 문항이 시간에 걸쳐 같은 방식으로 작동한다고 가정하기 쉽다. 하지만 MAPS 같은 migrant-family panel에서는 차별경험, 한국어 능력, 소득 같은 시간가변 공변량이 latent stress뿐 아니라 문항 threshold/loading 자체에도 영향을 줄 수 있다. 이 경우 관찰된 점수 변화는 실제 latent acculturative stress 변화와 문항 기능 변화가 섞인 결과가 된다.

RSDI는 이 혼합을 posterior counterfactual 관점에서 분해하려는 방법론적 estimand이다.

## 현재 프로젝트 구조

- `docs/proposal/`
  - 박사학위논문 계획서 docx/md.
- `docs/literature/`
  - MNLFA, longitudinal invariance, response shift, RSDI research gap 정리.
- `docs/briefs/`
  - 지도교수님 설명용 one-page pitch와 brief.
- `docs/audit/`
  - 코드/논리 점검 메모.
- `analysis/stan/`
  - longitudinal ordinal MNLFA 및 comparator Stan 모델.
- `analysis/scripts/`
  - RSDI 후처리, simulation recovery, comparator 분석 스크립트.
- `outputs/paper1_preliminary/`
  - MAPS 실증 논문/예비결과에서 박사논문에 연결되는 comparator, repeated VI, subset NUTS, sensitivity 결과.
- `sources/`
  - 읽어야 할 핵심 문헌 seed list.
- `data/`
  - 데이터는 복사하지 않고 원본 위치만 기록한다.

## 포스터 프로젝트와의 관계

포스터/Psychometrika 제출용 PPTX와 빌드 스크립트는 원래 위치에 둔다.

- 포스터 쪽: `C:\chen_bauer_2024\presentation_workspace`
- 포스터 출력: `C:\chen_bauer_2024\imps_poster_output`
- 박사논문 쪽: `C:\chen_bauer_2024\RSDI_dissertation_project`

이 프로젝트는 포스터 산출물을 포함하지 않는다. 다만 포스터에서 나온 MAPS empirical result 중 박사논문 방법론 개발에 필요한 preliminary evidence만 `outputs/paper1_preliminary/`에 복사했다.

## 다음 작업

1. RSDI estimand를 수식으로 고정한다.
2. simulation recovery design을 확정한다.
3. MAPS empirical example은 논문 1 또는 dissertation application chapter로 정리한다.
4. VI-only 결과와 subset NUTS calibration을 방법론적으로 어떻게 보고할지 명확히 한다.
5. item 1/2/6 제외 민감도 분석은 semantic overlap critique 방어용으로 유지한다.

