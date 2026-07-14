# IMPS 2026 supplementary tables

**Poster:** Acculturative Stress Change and Covariate DIF: a Bayesian MNLFA Approach<br>
**Authors:** Changhyeon Lee and Younyoung Choi, Ajou University

## Analysis specification

The primary poster analysis uses the MAPS parent panel (W1-W5; 2,190 parents; 77,160 item responses). Wave is restricted to the latent growth equation. Measurement DIF is modeled with time-varying Korean proficiency, income, and discrimination. The estimates below pool selected draws from four mean-field variational inference fits using complete covariate cases.

## Estimation, priors, and data handling

- **Approximation.** Four independent mean-field VI optimizations used 15,000 iterations, 50 ELBO samples per evaluation, and 1,000 output samples. The posterior is approximate; no same-specification no-wave NUTS confirmation is claimed.
- **Current diagnostic record.** The archived output documents four-seed stability for the slope. ELBO trace and PSIS diagnostics are not archived in this release, so they are not presented as completed validation.
- **Missing covariates.** The source contained 77,296 response rows from 2,191 parents. Complete-case analysis excluded 136 rows with missing log-income, yielding 77,160 analyzed responses from 2,190 parents. This is not FIML or multiple imputation.
- **Panel retention in the analytic data.** W1: 2,183; W2: 1,992; W3: 1,914; W4: 1,808; W5: 1,748 parents.
- **DIF parameterization.** All item-by-covariate loading and threshold DIF effects were jointly estimated. There was no hard anchor item and no modification-index or post-hoc item selection.
- **Regularizing priors.** Loading DIF parameters used Normal(0, 0.20); threshold DIF parameters used Normal(0, 0.35); latent-state covariate effects used Normal(0, 0.35).

## Table S1. Discrimination-related threshold DIF

Negative coefficients indicate lower endorsement thresholds among parents reporting discrimination, conditional on the latent stress level and other modeled covariates.

| Item | Item content | Threshold DIF mean | 90% lower | 90% upper | Seed mean minimum | Seed mean maximum | All seed means negative |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Different treatment | -1.09 | -1.225 | -0.977 | -1.139 | -1.046 | TRUE |
| 2 | Perceived prejudice | -1.575 | -1.715 | -1.456 | -1.658 | -1.533 | TRUE |
| 3 | Homesickness | -0.266 | -0.403 | -0.135 | -0.357 | -0.212 | TRUE |
| 4 | Unfamiliar environment | -0.371 | -0.57 | -0.216 | -0.53 | -0.277 | TRUE |
| 5 | Missing birthplace/people | -0.202 | -0.345 | -0.077 | -0.298 | -0.152 | TRUE |
| 6 | Anger at disregard | -1.214 | -1.325 | -1.093 | -1.258 | -1.156 | TRUE |
| 7 | Withdrawal | -0.821 | -1.023 | -0.675 | -0.976 | -0.759 | TRUE |
| 8 | Low social status | -0.848 | -1.021 | -0.705 | -0.986 | -0.78 | TRUE |

[Download Table S1 as CSV](table_s1_discrimination_threshold_dif.csv)

## Table S2. Latent slope and VI seed stability

| Estimate | Seed | Slope mean | 90% lower | 90% upper | Growth intercept SD | Growth slope SD | Occasion SD |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Pooled posterior slope mean |  | -0.16 | -0.185 | -0.133 |  |  |  |
| VI seed | 20260710 | -0.16 |  |  | 0.02 | 0.011 | 4.141 |
| VI seed | 20260711 | -0.167 |  |  | 2.484 | 0.174 | 2.031 |
| VI seed | 20260712 | -0.144 |  |  | 2.389 | 0.012 | 2.281 |
| VI seed | 20260713 | -0.169 |  |  | 2.544 | 0.158 | 2.122 |

[Download Table S2 as CSV](table_s2_latent_slope_and_vi_stability.csv)

## Table S3. Posterior counterfactual expected responses at eta = 0

These model-implied comparisons hold latent stress fixed at eta = 0 and contrast discrimination = 0 versus 1. They are not causal effects.

| Item | Item content | No discrimination mean | No discrimination 90% lower | No discrimination 90% upper | Discrimination mean | Discrimination 90% lower | Discrimination 90% upper | Mean contrast |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2 | Perceived prejudice | 2.383 | 2.35 | 2.415 | 3.077 | 3.019 | 3.133 | 0.694 |
| 6 | Anger at disregard | 2.662 | 2.594 | 2.754 | 3.347 | 3.218 | 3.496 | 0.685 |
| 7 | Withdrawal | 2.091 | 2.058 | 2.131 | 2.404 | 2.33 | 2.47 | 0.313 |

[Download Table S3 as CSV](table_s3_counterfactual_expected_response_eta0.csv)

## Interpretation boundary

- The design is observational; discrimination-associated DIF is not a causal response-shift effect.
- Mean-field VI provides an approximate posterior. No NUTS confirmation is claimed for the revised no-wave measurement-DIF specification.
- The latent slope direction was stable across seeds, but variance components were seed-sensitive.
- Item content overlaps conceptually with discrimination for some items, so estimates should be interpreted as measurement noninvariance rather than simple response bias.
- Restricted MAPS microdata are not redistributed in this repository.

## Selected references

- Chen, S. M., & Bauer, D. J. (2024). Modeling construct change over time amidst potential changes in construct measurement: A longitudinal moderated factor analysis approach. *Psychological Methods*. https://doi.org/10.1037/met0000685
- Chen, S. M., & Bauer, D. J. (2026). Improving the evaluation of construct change over time: Advantages of longitudinal moderated nonlinear factor analysis over conventional first-order growth models. *Multivariate Behavioral Research*. https://doi.org/10.1080/00273171.2026.2640576
- King-Kallimanis, B. L., Oort, F. J., & Garst, G. J. A. (2010). Using structural equation modelling to detect measurement bias and response shift in longitudinal data. *AStA Advances in Statistical Analysis, 94*(2), 139-156. https://doi.org/10.1007/s10182-010-0129-y
- Pascoe, E. A., & Smart Richman, L. (2009). Perceived discrimination and health: A meta-analytic review. *Psychological Bulletin, 135*(4), 531-554. https://doi.org/10.1037/a0016059

## Reproducibility files

The supplementary tables are generated from `poster_model_output/no_wave_dif_full_vi_4seed/` by `build_imps_supplementary.R`. The fitted-model runner is `maps_mnlfa_structural_state_run.R`, and the poster summaries are generated by `summarize_no_wave_vi_poster.R`.
