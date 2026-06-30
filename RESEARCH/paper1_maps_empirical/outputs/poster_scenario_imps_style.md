# Poster Scenario: Longitudinal MNLFA and Discrimination-Related Response Shift

## Working Title

**Discrimination-Linked Response Shifts in Longitudinal Acculturative-Stress Measurement: A Bayesian MNLFA Analysis of MAPS Parent Panel Data**

Shorter title option:

**When Stress Scores Shift: Discrimination-Related DIF in Longitudinal MAPS Parent Data**

## One-Sentence Thesis

Observed longitudinal differences in acculturative-stress responses may reflect both latent change and discrimination-linked changes in item functioning; a longitudinal ordinal MNLFA separates these two sources.

## Core Contribution

This poster is not simply a DIF detection exercise. Its contribution is showing that discrimination-related threshold shifts can change how longitudinal stress trajectories are interpreted.

Key contribution sentence:

> At the same latent acculturative-stress level, parents reporting discrimination were more likely to endorse high response categories on prejudice- and anger-related items, indicating that observed score change may partly reflect response shift rather than latent change alone.

## Poster Flow

### 1. Background: Why Longitudinal Invariance Matters

Many longitudinal growth models assume that repeated item responses are comparable across waves. In migrant-family panel data, however, language proficiency, socioeconomic position, and discrimination experiences may change over time and may also affect how respondents interpret or endorse specific items.

Poster text:

> Longitudinal growth models often assume stable measurement. In migrant-family research, this assumption may fail because time-varying social experiences can alter item thresholds and loadings.

Main problem:

> Observed score change can conflate true latent change with measurement-function change.

### 2. Research Question

> Can a Bayesian longitudinal ordinal MNLFA recover latent acculturative-stress trajectories while accounting for discrimination-related DIF?

Optional sub-questions:

- Which items show discrimination-related threshold DIF?
- Does the latent trajectory remain interpretable after allowing item parameters to vary?
- How large is the response-probability shift at the same latent stress level?

### 3. Data and Measures

Dataset:

- MAPS 2nd panel parent data
- 5 waves
- 8 ordinal parent acculturative-stress items
- Full analytic file: 77,160 item-level rows after complete DIF-predictor filtering

Focal covariates:

- parent age
- Korean proficiency
- log income
- discrimination experience, coded 0/1

Item wording should be summarized in English on the poster:

| Item | Short label |
|---:|---|
| 1 | Different treatment |
| 2 | Perceived prejudice |
| 3 | Homesickness |
| 4 | Unfamiliar environment |
| 5 | Missing birthplace/people |
| 6 | Anger at disregard |
| 7 | Withdrawal due to foreign-born status |
| 8 | Perceived low social status |

Original Korean wording can be omitted from the main poster or placed in a small QR/appendix note.

### 4. Model

Use a compact equation box.

Measurement model:

```text
Y_itj ~ ordered_logistic(lambda_itj * eta_it, cutpoints_j + threshold_shift_itj)
```

MNLFA moderation:

```text
loading_j = f(parent age, Korean proficiency, income, discrimination)
threshold_j = f(parent age, Korean proficiency, income, discrimination)
```

Growth model:

```text
eta_it = eta_0i + eta_1i * time_t + occasion_it
```

Estimation:

- Full-sample estimates: CmdStan variational inference
- Validation: NUTS subset analysis, n = 600 persons
- NUTS settings: 4 chains, 500 warmup + 500 sampling per chain
- NUTS runtime: about 4.5 hours

Important wording:

> Because full-sample NUTS was computationally prohibitive, full-sample VI estimates were supplemented by a NUTS-based subset validation.

### 5. Main Results

#### Result A. NUTS diagnostics support subset validation

Use small diagnostic box:

- 4 chains completed successfully
- 2,000 posterior draws
- divergent transitions = 0
- max Rhat = 1.016
- Rhat > 1.05 = 0
- max treedepth = 10

Poster sentence:

> The NUTS subset fit showed acceptable diagnostics for validating the direction and magnitude of key DIF patterns.

#### Result B. Discrimination-related threshold DIF was strongest for specific social-evaluative items

Top discrimination threshold DIF effects:

| Item | Short label | Threshold DIF mean | 90% CrI |
|---:|---|---:|---|
| 2 | Perceived prejudice | -1.270 | [-1.452, -1.081] |
| 6 | Anger at disregard | -0.906 | [-1.080, -0.730] |
| 1 | Different treatment | -0.869 | [-1.051, -0.689] |
| 7 | Withdrawal | -0.578 | [-0.794, -0.363] |
| 8 | Perceived low social status | -0.546 | [-0.753, -0.342] |

Interpretation:

> Negative threshold DIF indicates lower response thresholds. At the same latent stress level, parents reporting discrimination were more likely to endorse higher response categories.

#### Result C. Latent trajectory declined after accounting for DIF

Latent growth result:

- latent slope mean = -0.118
- 90% CrI = [-0.157, -0.082]
- slope variance = 0.035

Poster sentence:

> After accounting for DIF, the latent acculturative-stress trajectory showed a gradual decline, while item response functions varied by discrimination experience.

#### Result D. Counterfactual response shift gives the +@ contribution

At eta = 0, discrimination increased the probability of endorsing high categories, P(Y >= 4):

| Item | Short label | Difference in P(Y >= 4) |
|---:|---|---:|
| 6 | Anger at disregard | +0.206 |
| 2 | Perceived prejudice | +0.183 |
| 1 | Different treatment | +0.125 |

Concrete examples:

- Item 2: P(Y >= 4) increased from about 0.100 to 0.283
- Item 6: P(Y >= 4) increased from about 0.262 to 0.468

Poster sentence:

> Holding latent stress constant, discrimination experience shifted predicted response probabilities upward for prejudice- and anger-related items.

## Recommended Figure Layout

### Figure 1. Discrimination Threshold DIF by Item

Use:

`poster_model_output/full_nuts_light/visuals/fig2_discrimination_threshold_dif.png`

Caption:

> Posterior means and 90% credible intervals for discrimination-related threshold DIF. Negative values indicate lower thresholds for endorsing higher response categories.

### Figure 2. Counterfactual High-Response Curves

Use:

`poster_model_output/full_nuts_light/visuals/fig5_counterfactual_high_response_curves.png`

Caption:

> Predicted probability of high endorsement, P(Y >= 4), under discrimination = 0 versus 1, holding other covariates fixed and varying the latent trait.

### Figure 3. Response Shift Gap by Item

Use:

`poster_model_output/full_nuts_light/visuals/fig7_eta0_high_response_gap_by_item.png`

Caption:

> Counterfactual difference in P(Y >= 4) at eta = 0. Positive values indicate higher predicted endorsement under discrimination experience.

### Figure 4. Latent Growth Summary

Use:

`poster_model_output/full_nuts_light/visuals/fig4_latent_growth_summary.png`

Caption:

> Posterior summaries of latent growth parameters from the NUTS subset validation.

## Suggested Poster Sections

### Left Column

1. Background
2. Research question
3. Data and item labels
4. Model diagram/equation

### Middle Column

1. Estimation strategy
2. NUTS diagnostics
3. Figure 1: Discrimination threshold DIF
4. Short interpretation of negative threshold DIF

### Right Column

1. Figure 2: Counterfactual response curves
2. Figure 3: Response-shift gap
3. Figure 4: latent growth summary
4. Implications and limitations

## Suggested Presentation Script

### 20-second version

> This poster examines whether longitudinal acculturative-stress scores in MAPS parent data reflect only latent change or also changes in item functioning. Using a Bayesian longitudinal ordinal MNLFA, I found strong discrimination-related threshold DIF, especially for perceived prejudice and anger-at-disregard items. A counterfactual analysis showed that, at the same latent stress level, discrimination experience increased the probability of high endorsement by about 18 to 21 percentage points for the focal items. This suggests that observed score changes may partly reflect response shifts, not latent change alone.

### 60-second version

> Many longitudinal growth models assume that items function the same way across time. In migrant-family data, that assumption is risky because social experiences such as discrimination can change how people respond to specific items. I used MAPS parent panel data and fit a longitudinal ordinal MNLFA in which item loadings and thresholds were moderated by parent age, Korean proficiency, income, and discrimination experience. Full-sample estimation used variational inference, and I validated the main patterns with a 600-person NUTS subset. The strongest effects were discrimination-related threshold DIF for perceived prejudice, anger at disregard, and different treatment. Importantly, the counterfactual analysis shows what this means in response-probability terms: holding latent stress fixed at eta = 0, discrimination increased P(Y >= 4) by about .18 for perceived prejudice and .21 for anger at disregard. So the contribution is not just detecting DIF, but showing how discrimination-linked response shifts can alter longitudinal interpretations of stress.

## Discussion Points

Main implication:

> Measurement invariance should not be assumed in longitudinal migrant-family research when time-varying social experiences are substantively tied to item content.

Psychometric implication:

> Scalar invariance is especially vulnerable because discrimination experience shifts item thresholds.

Substantive implication:

> Higher observed scores among discrimination-experienced parents may partly reflect response shifts tied to specific social-evaluative item content.

Methodological implication:

> Longitudinal MNLFA provides a principled way to separate latent trajectory estimation from item-functioning change.

## Limitations

- Full-sample NUTS was computationally prohibitive; NUTS validation used a 600-person subset.
- Full-sample estimates rely on variational inference and should be framed as approximate.
- DIF estimates are associational, not causal evidence that discrimination caused response shifts.
- Item wording was originally Korean; English labels are poster summaries rather than validated translations.

## Safe Final Claim

> These results suggest that discrimination-related response shifts are measurable in longitudinal acculturative-stress items and can meaningfully alter the interpretation of observed score trajectories.

## Avoid These Claims

- Do not say discrimination caused DIF.
- Do not say the full-sample result is full NUTS.
- Do not say observed changes are purely artifacts.
- Do not overstate the subset NUTS as definitive final inference for the full sample.

## Best Final Poster Punchline

> In longitudinal migrant-family data, what looks like stress change may partly be a change in how discrimination-experienced respondents use the response scale.
