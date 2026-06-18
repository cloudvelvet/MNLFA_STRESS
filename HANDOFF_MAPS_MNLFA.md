# HANDOFF: MAPS Longitudinal MNLFA Project

## Current Project

This project analyzes the MAPS 2nd cohort parent panel, waves 1-5.

Main goal:

> Develop and evaluate a Bayesian longitudinal ordinal MNLFA framework for
> separating latent growth from time-varying measurement noninvariance in panel
> data.

Substantive application:

> Acculturative-stress items among multicultural-family parents, with
> discrimination experience as a time-varying DIF predictor.

The user is working from a quantitative psychology / psychometrics perspective,
not a clinical psychology perspective.

## Data

Source folder:

```text
C:\chen_bauer_2024\MAPS 2기 패널_Data_CSV (1)\학부모(1~6차)
```

Analytic file:

```text
longdat_maps_parent_discrim.csv
```

Current analytic structure:

- MAPS parent panel waves 1-5
- 2,191 persons
- 5 waves
- 8 ordinal acculturative-stress items
- 77,296 item-level rows before complete predictor filtering
- 77,160 item-level rows used in the full model after dropping missing DIF predictors
- discrimination-experienced item rows: 10,464
- discrimination-not-experienced item rows: 66,832

QC file:

```text
longdat_maps_parent_discrim_qc.csv
```

## Important Fixes Already Made

### 1. `age_c` is no longer wave/time

Old problem:

```r
age_c = time_c
```

That meant `age_c` was actually `wave - 3`, not parent age.

Fixed:

```r
age_c = parent_age_c
```

`parent_age_c` is actual parent age centered within wave. Growth time remains
separate as `time_c` / `time_score`.

Relevant file:

```text
maps_parent_prep_discrim.R
```

### 2. Discrimination predictor is raw 0/1

Old problem:

`discrim_c` was a standardized binary variable, so coefficients were per 1 SD
instead of a direct no/yes contrast.

Fixed:

The fitted model uses:

```text
discrim_any
```

where:

```text
0 = no discrimination experience
1 = discrimination experience
```

The model predictor order is:

```text
age_c
korean_c
income_c
discrim_any
```

Relevant files:

```text
maps_parent_prep_discrim.R
maps_mnlfa_poster_run.R
poster_model_output/full/predictor_index.csv
```

### 3. Simulation residual structure now matches the fitted model

Old problem:

The simulation drew a new occasion residual for every item response.

Fixed:

The simulation now generates:

```stan
theta[t, person]
```

once per person-wave and reuses it across all item responses for that same
person-wave.

Relevant files:

```text
maps_simulate_parent_discrim.stan
maps_parent_discrim_simulation_run.R
```

## Current Model

Main Stan model:

```text
maps_mnlfa_poster.stan
```

Main run script:

```text
maps_mnlfa_poster_run.R
```

Empirical comparator workflow:

```text
maps_empirical_comparators_run.R
maps_invariant_lgm.stan
run_maps_empirical_comparators.ps1
```

PowerShell wrapper:

```text
run_maps_mnlfa_poster.ps1
```

Main model:

- ordinal item responses
- person-level latent growth factors
- person-wave occasion residual
- loading DIF
- threshold DIF
- predictors: parent age, Korean proficiency, income, discrimination experience

Estimation status:

- Main full-data estimates are mean-field variational inference via CmdStanR.
- Quick NUTS was run only as a pipeline check.
- Do not claim full-data NUTS confirmation.

Quick NUTS diagnostic check after fixes:

```text
divergent = 0,0
max_treedepth = 0,0
E-BFMI = 0.799, 0.685
```

This is not full posterior confirmation because it used a small subset and short
chains.

## Main Full VI Results

Latent trajectory:

```text
latent slope mean = -0.028
slope variance = approximately 0.000039
occasion-level residual SD = 0.260
```

Largest raw 0/1 discrimination threshold DIF effects:

```text
Item 2: -1.514, 90% interval [-1.600, -1.425]
Item 6: -1.202, 90% interval [-1.280, -1.125]
Item 1: -1.044, 90% interval [-1.134, -0.948]
Item 8: -0.801, 90% interval [-0.892, -0.713]
Item 7: -0.792, 90% interval [-0.900, -0.688]
```

Interpretation:

Negative threshold DIF means that parents reporting discrimination endorse higher
response categories more easily at the same latent acculturative-stress level.

Safe wording:

> Observed score differences may partly reflect discrimination-related
> measurement noninvariance, not only latent change.

Avoid:

- "over-reporting bias"
- "response shift was proven"
- "full NUTS confirmed"
- "the prior KCI/MAPS study directly replicated this result"
- causal language such as "discrimination caused DIF"

## Poster

Current poster:

```text
imps_poster_output\imps_mnlfa_discrimination_poster_A0_portrait_v2.pptx
```

Poster title direction:

> Distinguishing Latent Change from Measurement-Function Change in
> Migrant-Family Panel Data

Poster note:

> Main empirical results are VI-based approximate posterior summaries; full-data
> NUTS confirmation is future work.

Poster generation files:

```text
make_imps_poster.R
presentation_workspace\src\build_imps_poster.mjs
```

The poster generators were updated so the headline DIF and latent trajectory
numbers are read from the regenerated CSV summaries rather than hardcoded.

## Prior MAPS/KCI Evidence

There is a MAPS/KCI study using MAPS 2022 data with GRM/MIMIC and 7 items. It
reported discrimination-related DIF in 5 of 7 items.

Use this as:

- contextual support
- external/background evidence
- plausibility that discrimination can be a DIF source

Do not use this as:

- direct replication
- same item-set confirmation
- same model confirmation
- validation of current longitudinal MNLFA estimates

Safe sentence:

> Prior MAPS-based evidence suggests that discrimination experience can be a
> psychometrically relevant source of DIF. Because the prior study used a
> different item set and modeling framework, we treat it as contextual support
> rather than direct replication evidence.

## Dissertation Direction

The user is in quantitative psychology / psychometrics.

Best dissertation framing:

> Modeling Longitudinal Measurement Noninvariance with Time-Varying Covariates:
> Bayesian Ordinal MNLFA, Simulation Validation, and Estimation Strategies

Overall dissertation thesis:

> This dissertation develops and evaluates a Bayesian longitudinal ordinal MNLFA
> framework for separating latent growth from time-varying measurement
> noninvariance in panel data.

## Three-Paper Structure

### Paper 1: MAPS Empirical Paper

Working idea:

> Naive observed-score growth vs invariant latent growth vs longitudinal MNLFA.

Purpose:

Show how conclusions about acculturative-stress trajectories change depending on
whether measurement noninvariance is ignored, constrained away, or modeled.

Status:

Most feasible and closest to completion.

Still needed:

- run and validate the newly added comparator workflow on local analytic data
- inspect naive observed-score growth results
- inspect invariant ordinal latent growth results
- compare both against the current MNLFA outputs
- refine model-implied trajectory comparison for the manuscript figures
- discuss loading DIF as well as threshold DIF
- justify weighting / unweighted analysis choice

Best framing:

> The central empirical contribution is not "large growth was found," but that
> measurement assumptions change how growth is interpreted.

### Paper 2: Monte Carlo Paper

Working idea:

> Recovery, bias, RMSE, coverage, and false positive DIF rates for longitudinal
> ordinal MNLFA with time-varying DIF and person-wave occasion residuals.

Recommended scope:

- focus on threshold DIF first
- include occasion residuals
- keep loading DIF as robustness or appendix

Minimal simulation design:

```text
N: 300, 600, 1000
DIF magnitude: 0, small, moderate
occasion residual SD: low, high
```

This gives 18 core cells.

Required metrics:

- bias
- RMSE
- empirical SD
- average posterior SD
- 90/95% interval coverage
- interval width
- convergence/failure rate
- false positive DIF rate
- power / true positive rate for DIF

Current status:

The project has a one-shot simulation generator for poster illustration, but not
yet a repeated Monte Carlo recovery pipeline.

### Paper 3: Estimation Strategy Paper

Working idea:

> Practical estimation workflow for high-dimensional longitudinal ordinal MNLFA.

Best comparison:

- mean-field VI
- Pathfinder
- subset NUTS
- attempted full-data NUTS

Do not make full-rank VI the main full-data comparison. Full-rank VI is likely
impractical for the full model because the unconstrained dimension is large.
Use full-rank VI only on small/medium subsets if desired.

Needed work:

- add CmdStanR `$pathfinder()`
- create person-level subset ladder: 80, 300, 600, 1000, 1500
- compare runtime, diagnostics, posterior means, posterior SDs, and DIF ranking
- implement `reduce_sum + threading` before making strong claims about full NUTS
- consider Pathfinder initialization for NUTS

Recommended framing:

> Practical workflow comparison, not definitive full-data NUTS validation.

## Current Status

Completed:

- MAPS parent preprocessing
- discrimination raw 0/1 correction
- actual parent age correction
- simulation residual correction
- full VI estimation
- quick NUTS pipeline check
- poster regeneration
- prior MAPS/KCI evidence framing
- three-paper dissertation feasibility review

Remaining dissertation-level work:

- implement comparator models for empirical paper
- build repeated Monte Carlo simulation pipeline
- add Pathfinder / subset NUTS estimation comparison
- strengthen posterior validation
- clarify identification and anchoring strategy
- handle broad DIF interpretation carefully
- prepare model comparison tables and trajectory figures

## Useful Commands

Preprocess:

```powershell
& "C:\Program Files\R\R-4.4.2\bin\x64\Rscript.exe" .\maps_parent_prep_discrim.R
```

Run full VI:

```powershell
powershell -ExecutionPolicy Bypass -File .\run_maps_mnlfa_poster.ps1 -Mode full
```

Run quick NUTS check:

```powershell
powershell -ExecutionPolicy Bypass -File .\run_maps_mnlfa_poster.ps1 -Mode quick
```

Run empirical comparators:

```powershell
powershell -ExecutionPolicy Bypass -File .\run_maps_empirical_comparators.ps1 -Mode quick
```

Run simulation:

```powershell
powershell -ExecutionPolicy Bypass -File .\run_maps_parent_discrim_simulation.ps1
```

Regenerate R-based poster:

```powershell
& "C:\Program Files\R\R-4.4.2\bin\x64\Rscript.exe" .\make_imps_poster.R
```

Regenerate presentation-workspace poster:

```powershell
node .\presentation_workspace\src\build_imps_poster.mjs
```

## How To Continue In A New Chat

Paste this file and say:

> Continue the MAPS longitudinal MNLFA dissertation project from this handoff.

