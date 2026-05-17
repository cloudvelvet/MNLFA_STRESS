# Distinguishing Latent Change from Measurement-Function Change in Acculturative Stress

## A Longitudinal Ordinal MNLFA of MAPS Parent Panel Data

### Draft Status

This is a first manuscript draft for the empirical Paper 1. The current draft
uses the MNLFA estimates already produced in the repository and marks the
observed-score and invariant latent-growth comparator results as planned
analyses. Those comparator analyses must be completed before submission.

## Abstract

Longitudinal studies often interpret repeated scale scores as evidence of change
in an underlying construct. This interpretation requires that the scale measures
the same construct in the same way across occasions. In migrant-family panel
data, however, time-varying experiences such as language proficiency, household
resources, and discrimination may alter how respondents endorse acculturative-
stress items. The present study examines whether conclusions about change in
parental acculturative stress differ when measurement-function change is ignored,
constrained away, or modeled directly. Using five waves of parent-report data
from the second cohort of the Multicultural Adolescents Panel Study, we analyze
eight ordinal acculturative-stress indicators with a Bayesian longitudinal
moderated nonlinear factor analysis. The model allows item loadings and
thresholds to vary as functions of parent age, Korean proficiency, income, and
discrimination experience. Current variational-inference estimates suggest a
small declining latent trajectory and strong discrimination-related threshold DIF
for several items, especially Item 2 and Item 6. At the same latent acculturative-
stress level, parents reporting discrimination tended to have lower thresholds
for endorsing higher response categories. These findings support the importance
of distinguishing latent change from measurement-function change in longitudinal
research with migrant families. Final conclusions will require direct comparison
with observed-score growth and invariant latent-growth models, plus additional
posterior robustness checks.

Keywords: longitudinal measurement invariance; differential item functioning;
moderated nonlinear factor analysis; acculturative stress; migrant families;
Bayesian psychometrics

## Introduction

Longitudinal research commonly asks whether people change over time. In many
applied studies, this question is answered by modeling repeated sum scores or
mean scores. Such analyses are straightforward, but they rely on a strong
psychometric assumption: the observed indicators must retain a stable
relationship to the latent construct across occasions. If this assumption fails,
observed-score change can reflect latent change, measurement-function change, or
both.

This problem is central to studies of acculturative stress in migrant families.
Parents' social positions, language environments, and discrimination experiences
can change across panel waves. These changes may influence the latent level of
acculturative stress, but they may also influence how particular items are
interpreted and endorsed. For example, a parent who has recently experienced
discrimination may endorse some stress-related items more readily than a parent
at the same latent stress level who did not report discrimination. In that case,
observed score differences would partly reflect differential item functioning
(DIF), not only differences in the latent construct.

Longitudinal measurement invariance provides the classical framework for this
problem. Growth models are most interpretable when repeated indicators measure a
common construct on a common metric. With ordered-categorical indicators, this
requires careful attention to thresholds and loadings rather than treating
Likert-type responses as continuous normal outcomes. Prior simulation evidence
also shows that measurement noninvariance can distort latent growth estimates and
growth-related inference.

Moderated nonlinear factor analysis (MNLFA) offers a flexible alternative to
simple multiple-group invariance testing. Instead of testing invariance across a
small number of discrete groups, MNLFA allows measurement parameters to vary as
functions of several covariates, including continuous and time-varying variables.
Recent longitudinal MNLFA work extends this logic to growth modeling by
separating construct change from changes in how the construct is measured over
time.

The present study applies this framework to MAPS parent-panel data. The central
empirical question is not simply whether acculturative stress increases or
decreases. Rather, the study asks how conclusions about change depend on the
measurement assumptions imposed by the model.

## Research Questions

RQ1. What trajectory of parental acculturative stress is suggested by a naive
observed-score growth model?

RQ2. What trajectory is suggested by an invariant ordinal latent growth model
that constrains item parameters to remain stable over time?

RQ3. Does a longitudinal ordinal MNLFA detect time-varying DIF associated with
parent age, Korean proficiency, income, or discrimination experience?

RQ4. Do conclusions about growth differ when DIF is ignored, constrained away, or
modeled directly?

## Method

### Data Source and Analytic Sample

The analysis uses the second cohort of the Multicultural Adolescents Panel Study
(MAPS), parent panel, waves 1 through 5. The current analytic file contains 2,191
parents, 5 waves, and 8 ordinal acculturative-stress items. Before complete
DIF-predictor filtering, the long-format item-level file contains 77,296 rows.
The full MNLFA uses 77,160 item-level rows after excluding rows with missing DIF
predictors. The only missing DIF-predictor source in the current QC summary is
log income, with 136 missing item rows.

### Measures

Acculturative stress was measured using eight ordinal parent-report items. Each
item was treated as an ordered-categorical indicator. Item labels should be
inserted in the final manuscript after confirming the MAPS codebook wording. In
the current poster and output summaries, Item 6 is treated as the anger-related
item and is used as one focal example.

### Time-Varying DIF Predictors

The MNLFA includes four predictors of item-parameter moderation:

1. Parent age, centered within wave.
2. Korean proficiency, standardized in the analytic data.
3. Log household income, standardized in the analytic data.
4. Discrimination experience, coded as a raw 0/1 indicator.

The raw 0/1 discrimination coding is important. Coefficients for
`discrim_any` are interpreted as the contrast between parents without and with
reported discrimination experience, not as a one-standard-deviation effect.

### Analytic Strategy

The paper is designed as a three-model comparison.

First, a naive observed-score growth model will be fit to person-wave mean scores
across the eight items. This model represents the common applied practice of
modeling repeated scale scores directly. It is useful as a benchmark because it
shows what would be concluded if measurement-function change were ignored.

Second, an invariant ordinal latent growth model will be fit. This model treats
the item responses as ordinal indicators of a latent acculturative-stress factor
and constrains item loadings and thresholds to be stable across waves. It is a
stronger psychometric comparator than the observed-score model, but it still
assumes away DIF from time-varying covariates.

Third, a Bayesian longitudinal ordinal MNLFA is fit. For person i at wave t and
item j, the latent response process is modeled through an ordered-logistic item
model. The latent factor follows a linear growth structure with person-level
intercepts and slopes plus a person-wave occasion residual. Item loadings and
thresholds are allowed to vary as functions of parent age, Korean proficiency,
income, and discrimination experience.

### Current MNLFA Estimation

The current full-data MNLFA estimates are based on CmdStanR mean-field
variational inference. A small subset NUTS run was used as a pipeline diagnostic
and showed no divergences in that limited check, but full-data NUTS has not yet
been completed. Therefore, all current MNLFA results should be described as
approximate posterior summaries, not as final NUTS posterior results.

## Results

### Descriptive Trajectory

The observed mean item response declined across the five waves in the current
summary output, from approximately 2.63 at wave 1 to 2.44 at wave 5. This
descriptive pattern argues against framing the empirical result as a simple
increase in acculturative stress. The more defensible framing is that both
observed and latent summaries suggest modest decline, while item functioning
differs by time-varying covariates.

### Current Longitudinal MNLFA Results

The full MNLFA estimated a small negative latent slope:

- Latent slope mean: -0.0278.
- 90% interval: approximately [-0.0307, -0.0251].
- Slope variance: approximately 0.000039.
- Occasion-level residual SD: approximately 0.260.

These estimates suggest a gradual decline in the latent acculturative-stress
factor under the current MNLFA specification. The very small slope variance
should be interpreted cautiously until comparator models and posterior
robustness checks are completed.

### Discrimination-Related Threshold DIF

The strongest current DIF results involve discrimination-related threshold shifts.
For `discrim_any`, the largest estimated threshold DIF effects were:

| Item | Threshold DIF mean | 90% interval |
| --- | ---: | ---: |
| 2 | -1.514 | [-1.600, -1.425] |
| 6 | -1.202 | [-1.280, -1.125] |
| 1 | -1.044 | [-1.134, -0.948] |
| 8 | -0.801 | [-0.892, -0.713] |
| 7 | -0.792 | [-0.900, -0.688] |

Because these are threshold effects in an ordered-logistic model, negative values
mean that parents reporting discrimination have lower thresholds for endorsing
higher response categories at the same latent acculturative-stress level. This
should be described as discrimination-related measurement noninvariance or
measurement-function change. It should not be described as proven over-reporting,
causal bias, or direct evidence that discrimination caused the response process
to change.

### Discrimination-Related Loading DIF

The current model also detects loading DIF, so the paper should not present the
results as a threshold-only story. The largest discrimination-related loading DIF
effects in the current top-effect output include:

| Item | Loading DIF mean | 90% interval |
| --- | ---: | ---: |
| 3 | 0.311 | [0.146, 0.475] |
| 6 | -0.290 | [-0.381, -0.197] |
| 5 | 0.269 | [0.193, 0.341] |
| 2 | -0.174 | [-0.248, -0.104] |

These loading effects imply that discrimination experience may also alter the
strength or direction of the relationship between the latent factor and some item
responses. This strengthens the measurement-noninvariance interpretation but
also requires a more nuanced discussion than a scalar-invariance-only account.

### Comparator Results To Be Added

The observed-score growth model and invariant ordinal latent growth model have
not yet been implemented in the repository. The final Results section should add:

1. Observed-score growth slope and uncertainty interval.
2. Invariant ordinal latent-growth slope and uncertainty interval.
3. Standardized comparison of the three estimated trajectories.
4. A reduced-model MNLFA comparison: no-DIF, threshold-only DIF, and full
   loading-plus-threshold DIF.
5. A counterfactual expected-score trajectory with discrimination DIF set to zero.

## Discussion

The preliminary MNLFA results support the paper's central psychometric argument:
longitudinal score differences in MAPS acculturative-stress items should not be
interpreted as pure latent change without evaluating measurement-function change.
The current model estimates a modest declining latent trajectory, but it also
finds substantial discrimination-related DIF. At the same latent acculturative-
stress level, parents reporting discrimination appear more likely to endorse
higher response categories on several items because the estimated item thresholds
are lower.

This pattern is consistent with a response-shift-like interpretation, but the
paper should use that phrase carefully. Statistical evidence of measurement
noninvariance does not by itself prove a psychological response-shift process.
The safer claim is that the observed item responses show discrimination-related
measurement-function change, and that this measurement change can confound
observed-score interpretations of longitudinal change.

The study contributes to quantitative psychology and psychometrics in three ways.
First, it applies longitudinal ordinal MNLFA to a substantively important migrant-
family panel context. Second, it treats discrimination as a time-varying
measurement moderator rather than only as a predictor of the latent construct.
Third, it turns a common applied question--whether acculturative stress changes
over time--into a psychometric comparison of what is concluded under different
measurement assumptions.

## Limitations

The current full-data estimates are based on variational inference, not full-data
NUTS. Variational inference is useful for making this large model computationally
tractable, but it may underestimate posterior uncertainty. The final paper should
include at least one stronger robustness check, such as longer subset NUTS,
Pathfinder, repeated VI stability, or full-data NUTS if feasible.

The current analysis uses complete-case filtering for DIF predictors, primarily
because of missing log income. The amount of missingness is small at the item-row
level, but the manuscript should still justify the decision or include a
sensitivity analysis.

The current pipeline appears unweighted. If MAPS survey weights are relevant to
the inferential target, this should be addressed directly. If the paper is framed
as a psychometric model demonstration rather than a population prevalence study,
an unweighted analysis may be defensible, but it remains a limitation.

Finally, prior MAPS-based evidence supports discrimination as a plausible DIF
source, but it is not direct replication. The prior KCI study used a related
scale, a different modeling framework, and a different wave structure.

## Proposed Tables and Figures

Table 1. Analytic sample and item-row construction.

Table 2. Comparison of model assumptions: observed-score growth, invariant
ordinal latent growth, and longitudinal MNLFA.

Table 3. Growth-estimate comparison across the three models.

Table 4. Discrimination-related threshold and loading DIF estimates.

Figure 1. Observed mean response by wave, overall and by discrimination status.

Figure 2. Three-trajectory comparison on a standardized scale.

Figure 3. DIF forest plot, with separate panels for threshold and loading DIF.

Figure 4. Item response curves for Item 2 and Item 6 under `discrim_any = 0`
versus `discrim_any = 1`.

Figure 5. Counterfactual expected-score trajectory with discrimination DIF set to
zero.

## Provisional Conclusion

The current evidence suggests that longitudinal changes in MAPS parental
acculturative-stress scores cannot be interpreted solely as latent construct
change. A longitudinal ordinal MNLFA estimates a modest declining latent
trajectory while also detecting substantial discrimination-related item-function
change. The final empirical contribution will be strongest after adding the
planned observed-score and invariant latent-growth comparators, because the
paper's main claim is comparative: conclusions about change depend on whether
measurement noninvariance is ignored, constrained, or modeled directly.

## References

Bauer, D. J. (2017). A more general model for testing measurement invariance and
differential item functioning. Psychological Methods, 22(3), 507-526.
https://doi.org/10.1037/met0000077

Bauer, D. J., Belzak, W. C. M., & Cole, V. T. (2020). Simplifying the
assessment of measurement invariance over multiple background variables: Using
regularized moderated nonlinear factor analysis to detect differential item
functioning. Structural Equation Modeling, 27(1), 43-55.
https://doi.org/10.1080/10705511.2019.1642754

Chen, S. M., & Bauer, D. J. (2024). Modeling construct change over time amidst
potential changes in construct measurement: A longitudinal moderated factor
analysis approach. Psychological Methods. https://doi.org/10.1037/met0000685

Chen, S. M., & Bauer, D. J. (2026). Improving the evaluation of construct change
over time: Advantages of longitudinal moderated nonlinear factor analysis over
conventional first-order growth models. Multivariate Behavioral Research.
https://doi.org/10.1080/00273171.2026.2640576

Kim, E. S., & Willson, V. L. (2014). Measurement invariance across groups in
latent growth modeling. Structural Equation Modeling, 21(3), 408-424.
https://doi.org/10.1080/10705511.2014.915374

King-Kallimanis, B. L., Oort, F. J., & Garst, G. J. A. (2010). Using structural
equation modelling to detect measurement bias and response shift in longitudinal
data. AStA Advances in Statistical Analysis, 94, 139-156.
https://doi.org/10.1007/s10182-010-0129-y

Lee, C., & Choi, Y. (2026). Psychometric Validation of the Cultural Adaptation
Stress Scale for Mothers from Multicultural Families Using the Graded Response
Model. Korean Journal of Convergence Science, 15(2), 379-395.
https://www.kci.go.kr/kciportal/ci/sereArticleSearch/ciSereArtiView.kci?sereArticleSearchBean.artiId=ART003314865

Liu, Y., Millsap, R. E., West, S. G., Tein, J.-Y., Tanaka, R., & Grimm, K. J.
(2017). Testing measurement invariance in longitudinal data with ordered-
categorical measures. Psychological Methods, 22(3), 486-506.
https://doi.org/10.1037/met0000075

Widaman, K. F., Ferrer, E., & Conger, R. D. (2010). Factorial invariance within
longitudinal structural equation models: Measuring the same construct across
time. Child Development Perspectives, 4(1), 10-18.
https://doi.org/10.1111/j.1750-8606.2009.00110.x

