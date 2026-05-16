# Poster Note: Estimation Status

## Estimation

The main empirical MNLFA estimates were obtained using CmdStanR variational inference
on the full parent panel analytic data set.

- Data: MAPS parent panel waves 1-5
- Rows used: 77,160 item-level observations
- Excluded: 136 rows with missing DIF predictors, mainly income-derived covariates
- Predictors in DIF model: parent age centered within wave, Korean proficiency,
  log household income, discrimination experience as raw 0/1
- Estimator: mean-field variational inference in CmdStanR

Because the model includes person-level latent growth factors and occasion effects,
full NUTS sampling for the complete data set is computationally expensive on the
current local machine. A small-sample NUTS run was used as a sanity check, but the
poster results should be described as approximate Bayesian estimates rather than
full NUTS posterior estimates.

## Main Full-Data VI Results

Latent trajectory:

- Latent slope mean: -0.028
- Latent slope variance: approximately 0.000039
- Occasion-level residual SD: 0.260

Largest discrimination-related threshold DIF effects:

- Item 2 discrimination threshold DIF: -1.514, 90% interval [-1.600, -1.425]
- Item 6 discrimination threshold DIF: -1.202, 90% interval [-1.280, -1.125]
- Item 1 discrimination threshold DIF: -1.044, 90% interval [-1.134, -0.948]
- Item 8 discrimination threshold DIF: -0.801, 90% interval [-0.892, -0.713]
- Item 7 discrimination threshold DIF: -0.792, 90% interval [-0.900, -0.688]

Interpretation:

Negative threshold DIF means that, at the same latent acculturative stress level,
parents reporting discrimination experiences (1 vs. 0) have a lower response
threshold and are more likely to endorse higher response categories on these items.

## NUTS Status

Full-data NUTS confirmation is not yet available. A very small quick NUTS pilot
on 80 persons was rerun after the raw `discrim_any` fix. It had no divergent
transitions, no max-treedepth hits, and E-BFMI values of about 0.80 and 0.69, but
the chains are too short and the subset is too small to treat it as posterior
confirmation of the full-data VI results.

## Poster Wording

Recommended methods wording:

> Bayesian longitudinal MNLFA was estimated in CmdStanR. Because full NUTS sampling
> for the complete person-level latent growth model was computationally intensive,
> the main empirical estimates are based on mean-field variational inference and
> should be interpreted as approximate posterior summaries. Full-data NUTS
> confirmation remains future work.

Recommended results wording:

> Discrimination experience showed consistent negative threshold DIF across several
> acculturative-stress items, especially Items 2 and 6. This implies that, at the
> same latent stress level, parents who reported discrimination were more likely
> to endorse higher response categories. The pattern supports the interpretation
> that observed score differences may partly reflect discrimination-related
> measurement noninvariance, not only latent change.
