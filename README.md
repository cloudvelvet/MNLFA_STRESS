# MAPS Longitudinal MNLFA

Bayesian longitudinal ordinal MNLFA workflow for MAPS parent-panel
acculturative-stress items.

## Scope

This repository keeps code and documentation only. Restricted MAPS source data,
derived analytic CSV files, posterior draws, rendered posters, and other large
outputs are intentionally excluded from Git.

## Main Files

- `maps_parent_prep_discrim.R`: preprocess MAPS parent waves 1-5
- `maps_mnlfa_poster.stan`: longitudinal ordinal MNLFA model
- `maps_mnlfa_poster_run.R`: CmdStanR estimation wrapper
- `maps_invariant_lgm.stan`: invariant ordinal latent-growth comparator
- `maps_empirical_comparators_run.R`: observed-score and invariant-model comparator workflow
- `maps_simulate_parent_discrim.stan`: simulation model
- `maps_parent_discrim_simulation_run.R`: simulation wrapper
- `make_imps_poster.R`: A0 poster generation from model summaries
- `HANDOFF_MAPS_MNLFA.md`: project handoff notes and dissertation roadmap

## Current Modeling Contract

- `age_c` is actual parent age centered within wave, not wave/time.
- `discrim_any` is raw 0/1 and is the discrimination DIF predictor.
- Simulation generates one `theta[t, person]` per person-wave and reuses it
  across item responses.
- Full empirical estimates are mean-field VI summaries, not full-data NUTS
  posterior confirmation.
- Empirical-paper comparators are run separately from the MNLFA poster model:
  naive observed-score growth and an invariant ordinal latent-growth model.

## Data Notice

MAPS raw data and generated analytic datasets are not included. Recreate them
locally from the authorized MAPS files before running the analysis.
