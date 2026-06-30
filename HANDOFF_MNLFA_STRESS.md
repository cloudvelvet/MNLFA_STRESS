# MNLFA_STRESS handoff

Purpose: MAPS longitudinal MNLFA / DIF / poster workflow.

This repository is for the psychometric modeling and poster/manuscript workflow around MAPS longitudinal measurement non-invariance, discrimination-related DIF, and latent trajectory recovery.

## What belongs here

- Stan models for MNLFA / GRM / simulation
- R scripts for MAPS preprocessing, MNLFA fitting, posterior/poster summaries
- Poster-generation scripts and manuscript notes for the empirical MNLFA project
- Research notes directly supporting the MAPS MNLFA/poster paper

## What does not belong here

- LLM-DIF prompt engineering and Gemini/OpenAI runners
- LLM prediction outputs
- MAPS raw source data
- API keys or `.Renviron`
- Large generated output folders

LLM-specific work is separated into:

```text
https://github.com/cloudvelvet/MNLFALLM
```

## Local-only folders

Keep these outside GitHub and move them through MYBOX/private storage if needed:

```text
C:\chen_bauer_2024\MAPS 2기 패널_Data_CSV (1)
C:\chen_bauer_2024\poster_model_output
C:\chen_bauer_2024\simulation_output
C:\chen_bauer_2024\simulation_parent_discrim_output
C:\chen_bauer_2024\imps_poster_output
```

## Other computer setup

Clone the repo:

```powershell
git clone https://github.com/cloudvelvet/MNLFA_STRESS.git C:\chen_bauer_2024\MNLFA_STRESS
```

Then copy MAPS raw data from MYBOX/private storage into the expected local path, or adjust script paths as needed.

Recommended shared-data location:

```text
MYBOX\MNLFA_STRESS_shared\data\MAPS 2기 패널_Data_CSV (1)
```

Recommended local working location:

```text
C:\chen_bauer_2024\MAPS 2기 패널_Data_CSV (1)
```

## Current caution

Poster/MNLFA claims should stay separate from the newer LLM-DIF idea. The poster/manuscript claim is about longitudinal MNLFA and discrimination-related measurement-function changes; the LLM project is a separate hypothesis-generation workflow.
