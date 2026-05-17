# Analysis TODO Before Paper 1 Submission

## Required Comparator Analyses

1. Implement naive observed-score growth.
   - Person-wave mean across the 8 items.
   - Linear mixed model with random intercept and random time slope.
   - Report observed-score slope and wave 1 to wave 5 contrast.
   - Optional extension: include time-varying discrimination as a covariate.

2. Implement invariant ordinal latent growth.
   - Longitudinal ordinal factor model.
   - Equal loadings and thresholds across waves.
   - No DIF from parent age, Korean proficiency, income, or discrimination.
   - Report latent intercept and slope parameters on the invariant latent scale.

3. Add reduced MNLFA variants.
   - No-DIF MNLFA.
   - Threshold-only DIF MNLFA.
   - Full loading plus threshold DIF MNLFA.

## Required MNLFA Outputs

1. Model-implied latent trajectory by wave.
2. Counterfactual expected-score trajectory with discrimination DIF set to zero.
3. Item response curves or category probability curves for Item 2 and Item 6.
4. Separate DIF forest plots for threshold DIF and loading DIF.

## Validation and Sensitivity

1. Repeat key estimates under at least one stronger posterior check.
   - Longer subset NUTS.
   - Pathfinder or repeated VI stability.
   - Full NUTS if computationally feasible.

2. Document missing-data handling.
   - Current MNLFA drops 136 item rows with missing log income.
   - Need justify complete-case DIF-predictor filtering or add sensitivity.

3. Decide whether survey weights are needed.
   - Current pipeline appears unweighted.
   - If weights are unavailable or incompatible with the model, explain this as
     a limitation and focus on psychometric demonstration.

4. Do not write the final paper as a threshold-only DIF story.
   - Current outputs also show discrimination-related loading DIF for several
     items.

