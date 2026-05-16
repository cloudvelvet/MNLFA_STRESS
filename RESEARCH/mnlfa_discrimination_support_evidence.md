# Evidence Supporting the Poster Argument

## Core Claim

The poster's argument is supported by three connected literatures:

1. Longitudinal growth models require measurement invariance; otherwise observed change can mix true construct change with changes in item functioning.
2. MNLFA is a flexible framework for testing DIF across multiple covariates, including continuous and categorical predictors.
3. In MAPS-style multicultural-family acculturative-stress data, discrimination experience is a plausible and empirically supported source of DIF.

## Evidence Map

### 1. Longitudinal change requires stable measurement

Widaman, Ferrer, and Conger argue that developmental and longitudinal studies often rely on repeated scale scores, implicitly assuming that the same construct is measured at each occasion. With multiple indicators, factorial invariance can be evaluated; when invariance holds, latent scores are on the same metric and stronger conclusions about change are warranted.

Citation:
Widaman, K. F., Ferrer, E., & Conger, R. D. (2010). Factorial invariance within longitudinal structural equation models: Measuring the same construct across time. Child Development Perspectives, 4(1), 10-18. https://doi.org/10.1111/j.1750-8606.2009.00110.x

Web evidence:
https://ichgcp.net/cs/clinical-trials-registry/publications/27424-factorial-invariance-within-longitudinal-structural-equation-models-measuring-the-same-construct

Poster use:
"Longitudinal comparisons require that the latent construct is measured on a common metric across occasions."

### 2. Measurement noninvariance biases growth estimates

Kim and Willson's Monte Carlo study directly links measurement noninvariance to bias and inflated Type I error in latent growth model parameters. They report that loading and intercept noninvariance affect estimates of latent growth and initial status.

Citation:
Kim, E. S., & Willson, V. L. (2014). Measurement invariance across groups in latent growth modeling. Structural Equation Modeling: A Multidisciplinary Journal, 21(3), 408-424. https://doi.org/10.1080/10705511.2014.915374

Web evidence:
https://www.tandfonline.com/doi/abs/10.1080/10705511.2014.915374

Poster use:
"If item parameters vary across groups or time-varying covariates, estimated growth parameters may be biased."

### 3. Response shift is a special case of longitudinal measurement bias

King-Kallimanis, Oort, and Garst describe response shift as a special case of measurement bias in longitudinal data. Their SEM procedure separates measurement bias from true change by testing measurement-parameter equivalence and direct effects of exogenous variables on indicators.

Citation:
King-Kallimanis, B. L., Oort, F. J., & Garst, G. J. A. (2010). Using structural equation modelling to detect measurement bias and response shift in longitudinal data. AStA Advances in Statistical Analysis, 94, 139-156. https://doi.org/10.1007/s10182-010-0129-y

Web evidence:
https://link.springer.com/article/10.1007/s10182-010-0129-y

Poster use:
"Discrimination-related threshold shifts are consistent with response-shift-like measurement change: the response function changes even when the latent trait is held constant."

### 4. MNLFA supports DIF modeling across multiple covariates

Bauer proposed MNLFA as a general framework for measurement invariance and DIF. It combines strengths of multiple-group and MIMIC models and allows measurement parameters to vary as functions of multiple categorical and/or continuous covariates.

Citation:
Bauer, D. J. (2017). A more general model for testing measurement invariance and differential item functioning. Psychological Methods, 22(3), 507-526. https://doi.org/10.1037/met0000077

Web evidence:
https://www.researchgate.net/publication/303828942_A_More_General_Model_for_Testing_Measurement_Invariance_and_Differential_Item_Functioning

Poster use:
"MNLFA is appropriate here because parent age, Korean proficiency, income, and discrimination are person/time-varying covariates, not just a single grouping variable."

### 5. Regularized MNLFA is recognized for multi-covariate DIF detection

Bauer, Belzak, and Cole state that MNLFA evaluates MI/DIF simultaneously over multiple background variables, including categorical and continuous variables.

Citation:
Bauer, D. J., Belzak, W. C. M., & Cole, V. T. (2020). Simplifying the assessment of measurement invariance over multiple background variables: Using regularized moderated nonlinear factor analysis to detect differential item functioning. Structural Equation Modeling: A Multidisciplinary Journal, 27(1), 43-55. https://doi.org/10.1080/10705511.2019.1642754

Web evidence:
https://pubmed.ncbi.nlm.nih.gov/33132679/

Poster use:
"The MNLFA framework scales DIF testing beyond single-group comparisons by allowing simultaneous moderation by multiple covariates."

### 6. Longitudinal moderated factor analysis directly targets this problem

Chen and Bauer's 2024 paper is especially close to this poster. They argue that growth models using sum/mean scores risk confounding actual construct change with measurement change/DIF. They propose a longitudinal moderated factor analysis approach, implemented with Bayesian estimation and regularizing priors, to model construct growth amid potential changes in measurement.

Citation:
Chen, S. M., & Bauer, D. J. (2024). Modeling construct change over time amidst potential changes in construct measurement: A longitudinal moderated factor analysis approach. Psychological Methods. Advance online publication. https://doi.org/10.1037/met0000685

Web evidence:
https://pubmed.ncbi.nlm.nih.gov/39207378/

Poster use:
"This study follows the same logic: model latent growth while allowing item parameters to vary with time-varying DIF predictors."

### 7. MAPS multicultural-family acculturative-stress items show discrimination-related DIF

A recent KCI article using MAPS 2022 data reports that the acculturative-stress scale for mothers from multicultural families had good psychometric properties under GRM, but discrimination-related DIF was detected in five of seven items.

Citation:
이창현 & 최윤영. (2026). 등급반응모형(GRM)을 이용한 다문화가정 어머니의 문화적응스트레스 척도 타당도 검증. 한국융합과학회지, 15(2), 379-395.

Web evidence:
https://www.kci.go.kr/kciportal/ci/sereArticleSearch/ciSereArtiView.kci?sereArticleSearchBean.artiId=ART003314865

Poster use:
"Prior MAPS evidence suggests that discrimination experience is not only substantively relevant but also psychometrically relevant as a DIF source."

## How This Supports the Current Results

Current result:

- Discrimination threshold DIF was negative for several items.
- Item 2: -1.514
- Item 6: -1.202
- Item 1: -1.044
- Item 8: -0.801
- Item 7: -0.792

Interpretation:

Negative threshold DIF means that, at the same latent acculturative-stress level, respondents with discrimination experience require a lower threshold to endorse higher response categories. This supports the poster's claim that observed score differences may partially reflect discrimination-related measurement noninvariance rather than pure latent change.

## Suggested Poster Text

Measurement rationale:

> Longitudinal growth models assume that repeated observed scores remain comparable across time. Prior work shows that measurement noninvariance can bias growth estimates and that response shift is a form of longitudinal measurement bias.

Method rationale:

> MNLFA extends conventional measurement-invariance testing by allowing item parameters to vary as functions of multiple covariates, including continuous and time-varying predictors. This makes it suitable for migrant-family panel data where Korean proficiency, income, parent age, and discrimination experience may vary across waves.

Result interpretation:

> Discrimination experience showed negative threshold DIF across multiple acculturative-stress items. Thus, parents reporting discrimination were more likely to endorse higher response categories at the same latent stress level, suggesting that observed score differences may partly reflect discrimination-related measurement noninvariance rather than true latent change alone.

Limitation sentence:

> Because the full-data estimates were obtained using variational inference, results should be interpreted as approximate Bayesian posterior summaries and confirmed with longer NUTS runs in future work.
