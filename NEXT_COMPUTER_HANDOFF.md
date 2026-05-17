# 다른 컴퓨터 작업 인수인계 노트

작성일: 2026-05-17

## 목적

이 프로젝트를 다른 컴퓨터에서 이어서 작업하기 위한 최소 인수인계 문서입니다. 핵심은 코드와 연구 노트는 GitHub/zip으로 옮기고, MAPS 원자료와 API key는 별도로 옮기는 것입니다.

## 추천 방식

### 1. 코드와 연구 노트

가능하면 GitHub를 사용합니다.

```powershell
git clone https://github.com/cloudvelvet/MNLFA_STRESS.git
cd MNLFA_STRESS
```

아직 커밋/푸시하지 않은 파일이 있다면 현재 컴퓨터에서 먼저 커밋하고 push해야 합니다.

```powershell
git status
git add .gitignore RESEARCH check_gemini_api_key.ps1 run_maps_llm_gemini_pilot.ps1 run_maps_llm_openai_pilot.ps1 *.R *.md *.py
git commit -m "Preserve LLM-assisted DIF pilot workflow"
git push origin main
```

커밋 메시지는 프로젝트의 Lore protocol에 맞춰 더 자세히 써도 됩니다.

### 2. MAPS 원자료

MAPS 원자료는 GitHub에 올리지 않습니다. 별도 저장장치나 개인 클라우드로 옮깁니다.

현재 예상 위치:

```text
C:\chen_bauer_2024\MAPS 2기 패널_Data_CSV (1)
```

다른 컴퓨터에서도 가능하면 같은 위치에 둡니다.

```text
C:\chen_bauer_2024\MAPS 2기 패널_Data_CSV (1)
```

같은 위치에 두면 기존 R script 경로 수정이 가장 적습니다.

### 3. LLM/API key

API key는 GitHub나 zip에 넣지 않습니다.

다른 컴퓨터 PowerShell에서 새로 설정합니다.

```powershell
[Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "여기에_키", "User")
```

설정 후 PowerShell을 새로 열고 확인합니다.

```powershell
powershell -ExecutionPolicy Bypass -File .\check_gemini_api_key.ps1
```

### 4. 큰 output 파일

`llm_dif_output/`은 GitHub에 올리지 않도록 되어 있습니다. 다른 컴퓨터에서 결과까지 이어서 보려면 별도 zip으로 옮깁니다.

옮기면 좋은 파일:

```text
llm_dif_output/maps_llm_gemini_pilot_results_gemini-2.5-flash_n10.jsonl
llm_dif_output/maps_llm_gemini_pilot_predictions_flat.csv
llm_dif_output/maps_llm_gemini_pilot_eval_joined.csv
llm_dif_output/maps_llm_gemini_pilot_eval_metrics.csv
llm_dif_output/maps_llm_item_catalog_filled.csv
llm_dif_output/maps_llm_full_item_covariate_pairs.csv
llm_dif_output/maps_dif_screening_gold_full.csv
llm_dif_output/maps_dif_screening_gold_summary_full.csv
```

원자료만 있으면 대부분 재생성 가능하지만, Gemini API 결과는 비용/쿼터가 들기 때문에 결과 JSONL은 따로 백업하는 것이 좋습니다.

## 현재 주요 스크립트

### MAPS + LLM item catalog 준비

```powershell
& 'C:\Program Files\R\R-4.4.2\bin\Rscript.exe' .\maps_multiscale_llm_prep.R
& 'C:\Program Files\R\R-4.4.2\bin\Rscript.exe' .\maps_llm_fill_item_text.R
& 'C:\Program Files\R\R-4.4.2\bin\Rscript.exe' .\maps_llm_make_batches.R
```

### provisional DIF screening

```powershell
& 'C:\Program Files\R\R-4.4.2\bin\Rscript.exe' .\maps_llm_dif_gold_screen.R full
```

### Gemini pilot 실행

무료 API rate limit 때문에 천천히 실행합니다.

```powershell
powershell -ExecutionPolicy Bypass -File .\run_maps_llm_gemini_pilot.ps1 -Limit 10 -Resume -SleepSeconds 90 -RateLimitBaseSeconds 90 -RateLimitMaxSeconds 600
```

### Gemini 결과 파싱/평가

```powershell
& 'C:\Program Files\R\R-4.4.2\bin\Rscript.exe' .\maps_llm_parse_gemini_results.R
& 'C:\Program Files\R\R-4.4.2\bin\Rscript.exe' .\maps_llm_eval_gemini_pilot.R
```

## 현재 예비결과 요약

Gemini pilot n=10 기준:

- item-covariate 판단 수: 42
- provisional DIF positive: 10
- Gemini 전체 AUPRC: 약 0.491
- keyword baseline 전체 AUPRC: 약 0.538
- discrimination에서는 LLM이 높은 점수를 주지만 keyword baseline도 강함
- Korean proficiency에서는 LLM이 keyword보다 의미 추론을 조금 더 하는 경향
- income false positive는 guardrail prompt 이후 줄어듦
- age는 latent difference를 DIF처럼 과해석하는 경향이 남아 있음

해석:

> LLM은 DIF의 최종 판정자가 아니라, 문항 의미 기반 DIF 후보 생성 도구로 사용하는 것이 타당하다. 최종 판단은 MNLFA 또는 ordinal DIF model로 검증해야 한다.

## 교수님 면담용 문서

다음 파일을 보면 됩니다.

```text
RESEARCH/ai_llm_dif_requirements/professor_pitch_llm_dif.md
```

핵심 문장:

> LLM으로 DIF를 자동 판정하려는 것이 아니라, LLM을 문항 의미 기반 DIF 가설 생성 도구로 제한하고, 그 후보를 MNLFA/ordinal DIF model로 검증함으로써 다문화 패널 자료의 측정불변성 검토를 보완하려는 시도입니다.

## 다른 컴퓨터에서 바로 할 일

1. GitHub에서 repo를 clone합니다.
2. MAPS 원자료 폴더를 같은 위치에 복사합니다.
3. R 4.4.x, CmdStanR, 필요한 R 패키지를 확인합니다.
4. Gemini API key를 User 환경변수로 설정합니다.
5. `check_gemini_api_key.ps1`로 API 연결을 확인합니다.
6. `llm_dif_output/`을 옮겼다면 바로 parse/eval부터 확인합니다.
7. output을 안 옮겼다면 prep script부터 다시 실행합니다.

## 압축해서 옮길 때

코드와 작은 연구 노트만 압축할 때 포함:

```text
RESEARCH/
*.R
*.ps1
*.py
*.md
.gitignore
```

따로 압축하거나 외장 저장장치로 옮길 것:

```text
MAPS 2기 패널_Data_CSV (1)/
llm_dif_output/
poster_model_output/
simulation_output/
simulation_parent_discrim_output/
imps_poster_output/
```

절대 포함하지 말 것:

```text
API key
.Renviron
개인 인증 파일
```

## 다음 분석 방향

1. 487 item-covariate pair 전체를 Gemini로 천천히 실행합니다.
2. LLM vs keyword baseline vs empirical DIF를 비교합니다.
3. 주요 척도는 MNLFA/ordinal DIF model로 확인합니다.
4. false positive/false negative를 질적으로 해석합니다.
5. 논문 프레이밍은 "LLM-assisted DIF hypothesis generation"으로 잡습니다.
