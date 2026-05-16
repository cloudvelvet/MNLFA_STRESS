# Code, Logic, and Dissertation Feasibility Audit

## Bottom Line

After the May 15, 2026 fixes, the project is more defensible as an exploratory,
VI-based longitudinal DIF poster, but still not defensible as a NUTS-confirmed
empirical result or as a strong proof that observed longitudinal change is
response shift rather than latent change.

Dissertation feasibility is conditional: the topic is strong enough, but the
current pipeline needs stronger validation before it can support a doctoral
defense.

## High-Priority Issues

1. `age_c` was corrected to parent age.

Earlier code set `age_c` equal to `time_c`. This was corrected so that `age_c`
uses actual parent age centered within wave, while the latent growth model keeps
its separate `time_score`.

Remaining caution:
Because parent age and wave are naturally related in panel data, describe this as
parent age centered within wave rather than generic "Age DIF."

2. Simulation residual structure does not match the fitted model.

The fitted model has one occasion residual per person-wave, shared across items.
Earlier simulator code drew a new residual inside the observation loop, creating
item-level noise instead of person-wave occasion dependence. This was corrected
by generating `theta[t, p]` once per person-wave and reusing it for all item
responses.

3. Discrimination was switched to a raw 0/1 contrast.

The model now uses unscaled `discrim_any` in the DIF predictor matrix. The
poster estimates are therefore interpretable as no-discrimination versus
discrimination contrasts. In the updated VI output, Item 2 threshold DIF is
approximately `-1.514`.

4. NUTS confirmation is overstated.

The full `nuts_check` did not complete with usable output. The only completed
NUTS-like run was `quick`, using a very small subset and very short chains.

Required fix:
Remove the claim that NUTS confirmed the result. Use wording such as:
"A very small quick NUTS pilot showed the same sign for the largest
discrimination-threshold terms, but full-data NUTS confirmation is not yet
available."

## Interpretation Corrections

- Negative threshold DIF is correctly interpreted as easier endorsement of higher
  categories, because the threshold shift is added to the cutpoints.
- The current evidence supports discrimination-related measurement noninvariance.
- It does not prove that observed change is response shift rather than latent
  change. Safer wording:
  "The findings are consistent with discrimination-related measurement-function
  change that could contribute to observed score differences."
- Avoid upward-change phrasing; observed wave means decline in the
  current summaries. Use "observed score change" or "observed score differences."
- The model also estimates loading DIF, so the poster should not tell a purely
  threshold-only story unless loading DIF is removed or explicitly treated as
  secondary.

## What Passed

- MAPS parent waves 1-5 were used.
- Discrimination is present and coded.
- `person_id` is reindexed after complete-case filtering in estimation and
  simulation scripts.
- The ordinal sign convention is internally consistent.
- The main full-data VI output shows a consistent negative discrimination
  threshold pattern for several items.

## Dissertation Feasibility

Feasibility judgment: conditional.

Strong thesis:
Longitudinal acculturative-stress change in migrant-family panel data is partly
confounded with covariate-related measurement-function change, and Bayesian
longitudinal MNLFA can separate latent growth from DIF more defensibly than
score-based or invariant growth models.

Possible three-paper structure:

1. Empirical MAPS paper:
   Longitudinal MNLFA of acculturative stress, comparing naive observed-score
   trends, invariant growth models, and DIF-adjusted latent trajectories.

2. Simulation paper:
   Monte Carlo validation of ordinal longitudinal MNLFA with time-varying DIF
   under MAPS-like sample sizes, missingness, and discrimination prevalence.

3. Estimation workflow paper:
   Practical comparison of VI, full-rank VI/pathfinder, subset NUTS, and full
   NUTS strategies for high-dimensional longitudinal MNLFA.

Required before dissertation defense:

- Add a true Monte Carlo recovery/bias/coverage study.
- Strengthen identification and anchoring strategy.
- Add model comparisons against no-DIF and conventional growth models.
- Use stronger posterior validation than mean-field VI alone.
