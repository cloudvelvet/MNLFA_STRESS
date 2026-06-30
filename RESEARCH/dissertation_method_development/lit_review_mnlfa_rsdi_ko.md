# Literature Review: Longitudinal MNLFA, Response Shift, and RSDI

작성일: 2026-06-24

주제: **종단 서열형 심리측정 자료에서 시간가변 DIF와 response shift를 분리하기 위한 Bayesian longitudinal MNLFA 및 RSDI 개발 가능성**

---

## 1. 문헌검색 범위

### 검색 질문

이 문헌고찰은 다음 질문에 답하기 위한 것입니다.

1. 종단 성장모형에서 측정불변성이 왜 필요한가?
2. 측정불변성이 깨지면 latent growth 해석이 어떻게 왜곡되는가?
3. MNLFA는 여러 공변량에 따른 DIF를 어떻게 다루는가?
4. longitudinal MNLFA는 기존 growth model의 어떤 한계를 보완하는가?
5. response shift 문헌은 measurement bias/change를 어떻게 해석해왔는가?
6. MAPS/다문화가족 acculturative stress 맥락에서 discrimination-related DIF를 주장할 근거가 있는가?
7. 현재 제안하는 RSDI가 기존 문헌 사이에서 어떤 gap을 메우는가?

### 검색어

- `longitudinal measurement invariance latent growth`
- `ordered-categorical longitudinal measurement invariance`
- `measurement non-invariance latent growth modeling`
- `moderated nonlinear factor analysis DIF`
- `regularized MNLFA differential item functioning`
- `longitudinal moderated factor analysis construct change measurement change`
- `response shift measurement bias longitudinal SEM`
- `acculturative stress differential item functioning discrimination MAPS`

### 포함 기준

- 종단 측정불변성, DIF, MNLFA, response shift 중 하나 이상을 직접 다루는 문헌
- latent growth 해석과 measurement-function change의 구분에 기여하는 문헌
- ordinal indicators 또는 DIF/threshold 해석에 연결 가능한 문헌
- MAPS 또는 다문화가족 acculturative stress와 직접 관련된 문헌

### 제외 기준

- 단순 acculturative stress 예측요인 연구
- 측정모형 없이 합산점수만 분석한 연구
- DIF를 언급하지만 latent trait conditioning 또는 measurement invariance 논리가 없는 연구

---

## 2. 핵심 결론

현재 문헌을 보면, 각각의 조각은 이미 존재합니다.

- longitudinal measurement invariance는 growth 해석의 전제입니다.
- measurement noninvariance는 latent growth parameter를 왜곡할 수 있습니다.
- MNLFA는 여러 공변량에 따른 item parameter moderation을 유연하게 다룹니다.
- longitudinal MNLFA는 construct change와 measurement change를 동시에 다루는 방향으로 발전하고 있습니다.
- response shift 문헌은 longitudinal measurement bias/change를 이론적으로 다루어 왔습니다.
- MAPS 기반 선행연구는 discrimination-related DIF가 acculturative stress 문항에서 나타날 수 있음을 보여줍니다.

하지만 아직 비교적 덜 다뤄진 지점은 다음입니다.

> **시간가변 discrimination-related DIF가 있는 종단 서열형 문항자료에서, 관찰 응답 변화 중 얼마가 latent change이고 얼마가 measurement-function shift인지 posterior 기반 counterfactual decomposition으로 정량화하는 연구는 직접적으로 많지 않습니다.**

따라서 RSDI의 기여는 "MNLFA를 새로 발명했다"가 아니라, 기존 Bayesian longitudinal MNLFA 결과를 이용해 **종단 응답변화의 latent-change component와 measurement-shift component를 분해하는 estimand/workflow를 제안하는 것**으로 잡는 것이 가장 안전합니다.

---

## 3. 문헌 매트릭스

| 영역 | 핵심 문헌 | 무엇을 제공하는가 | 현재 연구와의 연결 | 남는 gap |
|---|---|---|---|---|
| Longitudinal measurement invariance | Widaman, Ferrer, & Conger (2010) | 종단 SEM에서 같은 construct를 측정한다는 전제의 중요성 | MAPS growth 해석 전에 item functioning 확인 필요 | ordinal/time-varying DIF까지는 직접 다루지 않음 |
| Ordered-categorical invariance | Liu et al. (2017) | ordered-categorical longitudinal MI 검정 | MAPS acculturative stress가 Likert/ordinal item이라는 점과 연결 | covariate-driven DIF와 growth decomposition은 제한적 |
| Noninvariance and growth bias | Kim & Willson (2014) | 측정비동일성이 latent growth 추정에 영향을 줄 수 있음 | naive/invariant growth와 MNLFA 비교의 근거 | discrimination/time-varying item shift는 직접 초점 아님 |
| MNLFA general framework | Bauer (2017) | MI/DIF를 continuous/categorical moderators로 일반화 | age, Korean proficiency, income, discrimination을 item parameter predictors로 넣는 근거 | longitudinal response-shift decomposition은 아님 |
| Regularized MNLFA | Bauer, Belzak, & Cole (2019/2020) | 많은 background variables에서 DIF screening/regularization | 추후 sparse DIF selection 개발 가능성 | 종단 성장해석 분해는 초점 아님 |
| Longitudinal moderated factor analysis | Chen & Bauer (2024) | construct change와 measurement change를 같이 다루는 longitudinal framework | 현재 연구의 가장 직접적인 방법론 anchor | MAPS/ordinal/discrimination/RSDI까지는 확장 필요 |
| Longitudinal MNLFA vs growth models | Chen & Bauer (2026) | conventional first-order growth models와 longitudinal MNLFA 비교 | "왜 MNLFA가 필요한가"를 설명하는 핵심 근거 | response-shift contribution index는 별도 개발 여지 |
| Response shift theory | Sprangers & Schwartz (1999) | response shift의 이론적 유형: recalibration, reprioritization, reconceptualization | discrimination-linked threshold shift를 response shift 관점으로 해석 가능 | 계량적으로 ordinal MNLFA posterior decomposition까지는 아님 |
| SEM response shift detection | Oort (2005); King-Kallimanis et al. (2010) | SEM으로 true change와 response shift/measurement bias 구분 | RSDI의 이론적 선행 기반 | Bayesian ordinal item response posterior 기반 분해는 아님 |
| MAPS-specific prior evidence | Lee & Choi (2026) | 동일 MAPS 연구맥락에서 mothers acculturative stress의 discrimination-related DIF 가능성 제시 | discrimination을 time-varying DIF predictor로 설정할 같은 맥락의 예비 근거 | 동일 연구 프로그램의 단일시점 GRM/MIMIC이며, 독립적 외부 타당화나 longitudinal replication은 아님 |
| Recent sparse/ordinal DIF | Padgett (2025); Wallin & Huang (2026) | penalized/regularized DIF와 ordinal measurement noninvariance의 최신 흐름 | sparse DIF prior 또는 regularized screening의 후속 개발 가능성 | migrant longitudinal response-shift decomposition은 아님 |

---

## 4. Annotated Bibliography

### 4.1 Longitudinal Measurement Invariance and Growth

**Widaman, Ferrer, and Conger (2010)**  
종단 SEM에서 factor mean 또는 growth parameter를 해석하려면 동일한 construct가 시간에 걸쳐 같은 방식으로 측정되어야 한다는 기본 논리를 제공합니다. 현재 연구에서는 이 문헌을 "왜 naive growth 또는 합산점수 growth만으로는 부족한가"를 설명하는 출발점으로 사용할 수 있습니다.

- DOI: https://doi.org/10.1111/j.1750-8606.2009.00110.x

**Liu et al. (2017)**  
ordered-categorical measures에서 longitudinal measurement invariance를 검정하는 문제를 다룹니다. MAPS acculturative stress 문항은 연속형이 아니라 ordinal Likert-type 응답이므로, 일반 연속 CFA/LGM보다 ordered-categorical measurement logic이 필요하다는 근거가 됩니다.

- DOI: https://doi.org/10.1037/met0000075

**Kim and Willson (2014)**  
latent growth modeling에서 measurement invariance가 깨질 때 growth parameter 해석이 어떻게 흔들릴 수 있는지 보여주는 문헌입니다. 현재 연구의 모형비교 파트, 즉 naive growth / invariant ordinal growth / MNLFA 비교의 필요성을 뒷받침합니다.

- DOI: https://doi.org/10.1080/10705511.2014.915374

### 4.2 MNLFA and Longitudinal MNLFA

**Bauer (2017)**  
MNLFA를 measurement invariance와 DIF 검정을 위한 일반적 framework로 제시합니다. 핵심은 item parameters가 group뿐 아니라 continuous/categorical covariates의 함수가 될 수 있다는 점입니다. 현재 연구에서 parent age, Korean proficiency, income, discrimination을 item loading/threshold predictors로 넣는 이론적 기반입니다.

- DOI: https://doi.org/10.1037/met0000077

**Bauer, Belzak, and Cole (2019/2020)**  
여러 background variables가 있을 때 regularized MNLFA로 DIF를 효율적으로 탐지하는 접근을 제시합니다. 현재 연구의 후속 개발인 sparse DIF selection, horseshoe/regularized prior, candidate screening 전략과 연결됩니다.

- DOI: https://doi.org/10.1080/10705511.2019.1642754

**Chen and Bauer (2024)**  
이 연구의 가장 직접적인 방법론 anchor입니다. PubMed 초록에 따르면, 일반 growth curve model은 관찰된 measure change를 construct change로 해석하는 경향이 있고, sum/mean score를 반복측정으로 쓰면 measurement constancy를 암묵적으로 가정하게 됩니다. Chen and Bauer는 moderated nonlinear factor analysis를 기반으로 many time points와 covariate-related DIF를 parsimonious하게 다루는 longitudinal moderated factor analysis를 제안합니다. 현재 연구는 이 논리를 MAPS acculturative stress, ordinal item response, discrimination-related DIF로 확장하는 위치에 있습니다.

- DOI: https://doi.org/10.1037/met0000685
- PubMed: https://pubmed.ncbi.nlm.nih.gov/39207378/

**Chen and Bauer (2026)**  
Longitudinal MNLFA와 conventional first-order growth models를 직접 비교하는 최신 문헌입니다. 현재 연구의 주장을 가장 잘 밀어주는 문헌입니다. 즉, "MNLFA는 예쁜 고급모형이라서 쓰는 것"이 아니라, conventional growth model이 measurement-function change를 무시할 때 construct change 해석이 달라질 수 있기 때문에 쓰는 것입니다.

- DOI: https://doi.org/10.1080/00273171.2026.2640576

### 4.3 Response Shift and Measurement Bias

**Sprangers and Schwartz (1999)**  
response shift를 health-related quality of life 연구에서 이론화한 고전 문헌입니다. response shift를 단순 measurement error가 아니라 응답자의 기준, 가치, construct 개념화 변화로 볼 수 있게 해줍니다. 현재 연구에서는 discrimination-related threshold shift를 "response shift와 일관된 measurement-function change"로 조심스럽게 해석하는 이론적 배경입니다.

- DOI: https://doi.org/10.1016/S0277-9536(99)00045-3

**Oort (2005)**  
SEM을 이용해 response shift와 true change를 구분하는 방법을 제시합니다. 현재 RSDI 아이디어와의 연결점은 "true change와 response shift를 같은 longitudinal framework 안에서 분리하려는 시도"입니다. 차이는 Oort가 SEM 기반인 반면, 현재 연구는 ordinal item response/MNLFA posterior 기반의 counterfactual decomposition을 목표로 한다는 점입니다.

- DOI: https://doi.org/10.1007/s11136-004-0830-y

**King-Kallimanis, Oort, and Garst (2010)**  
longitudinal data에서 measurement bias와 response shift를 SEM으로 탐지하는 논문입니다. 현재 연구에서 response shift를 "측정모형 변화"로 다루는 데 직접적인 다리 역할을 합니다. 다만 현재 연구는 discrimination을 time-varying DIF predictor로 넣고, ordinal item probability 차원에서 response-shift contribution을 계산한다는 점에서 확장 여지가 있습니다.

- DOI: https://doi.org/10.1007/s10182-010-0129-y

### 4.4 MAPS and Acculturative-Stress DIF

**Lee and Choi (2026)**  
MAPS 2022 3차년도 자료에서 다문화가정 어머니의 acculturative stress 척도를 GRM과 MIMIC으로 검증한 연구입니다. KCI 상세정보에 따르면 1,920명의 응답을 분석했고, discrimination experience에 따른 DIF가 7문항 중 5문항에서 확인되었습니다. 현재 연구에서는 이 결과를 "동일 MAPS 연구맥락에서 discrimination이 psychometrically relevant DIF source일 수 있다"는 같은 맥락의 예비 근거로 사용할 수 있습니다.

단, 이것을 독립적인 외부 타당화나 직접 replication 근거로 쓰면 안 됩니다. 같은 연구 프로그램에서 나온 MAPS 기반 선행분석이고, item set, wave structure, model도 다르기 때문입니다. 현재 연구는 longitudinal ordinal MNLFA이고, Lee and Choi는 단일시점 GRM/MIMIC입니다.

- KCI: https://www.kci.go.kr/kciportal/ci/sereArticleSearch/ciSereArtiView.kci?sereArticleSearchBean.artiId=ART003314865

### 4.5 Recent Regularized / Ordinal DIF Developments

**Padgett (2025, preprint)**  
Multidimensional MNLFA에서 여러 factor와 parameter moderation을 다루는 확장을 제안합니다. Bayesian Stan 구현과 penalized maximum likelihood 접근을 함께 논의하고, longitudinal data와 categorical indicators로의 확장을 미래 방향으로 제시합니다. 현재 연구와 직접 동일하지는 않지만, sparse/regularized MNLFA 개발 방향의 최신 맥락을 보여줍니다.

- arXiv: https://arxiv.org/abs/2509.05443

**Wallin and Huang (2026, preprint)**  
ordinal scales에서 group label 또는 anchor item이 명확하지 않을 때 regularized latent-class IRT로 measurement non-invariance를 탐지하는 접근입니다. 현재 연구와 모형은 다르지만, ordinal DIF, sparsity, anchor 문제를 함께 다룬다는 점에서 방법론적 배경으로 참고할 수 있습니다.

- arXiv: https://arxiv.org/abs/2601.17612

**Wallin and Huang (2026, preprint)**  
asymmetric IRT model에서 latent impact와 DIF를 함께 분석하는 접근입니다. 이 문헌은 "DIF와 latent population heterogeneity를 구분해야 한다"는 점을 강조합니다. 현재 연구에서도 discrimination group의 latent stress difference와 item-functioning difference를 구분해야 하므로, 논리적으로 연결됩니다.

- arXiv: https://arxiv.org/abs/2605.05684

---

## 5. Synthesis: 기존 문헌이 말하는 것

### 5.1 Growth model은 measurement invariance를 전제한다

Widaman et al. (2010), Liu et al. (2017), Kim and Willson (2014)은 모두 한 방향을 가리킵니다. 종단 변화 해석은 "같은 것을 같은 방식으로 측정한다"는 전제가 있을 때 안전합니다. MAPS acculturative stress처럼 ordinal items를 반복측정한 자료에서는 이 전제가 더 중요합니다.

### 5.2 MNLFA는 covariate-related DIF를 유연하게 다룬다

Bauer (2017)는 MNLFA를 group-based invariance test보다 일반적인 DIF framework로 제시합니다. Bauer et al. (2019/2020)은 여러 background variables가 있을 때 regularization을 활용할 수 있음을 보여줍니다. 따라서 MAPS에서 parent age, Korean proficiency, income, discrimination 같은 공변량을 item parameter predictors로 넣는 것은 기존 MNLFA 문헌 안에서 자연스러운 확장입니다.

### 5.3 Longitudinal MNLFA는 기존 growth model의 해석 문제를 직접 겨냥한다

Chen and Bauer (2024, 2026)는 현재 연구의 중심 anchor입니다. 이 문헌들은 construct change와 measurement change가 confounded될 수 있다는 점을 명시적으로 다루며, longitudinal MNLFA가 conventional growth model보다 measurement-function change를 더 잘 반영할 수 있음을 보여줍니다.

### 5.4 Response shift 문헌은 "측정기능 변화"를 해석할 언어를 제공한다

Sprangers and Schwartz (1999), Oort (2005), King-Kallimanis et al. (2010)은 response shift를 longitudinal measurement change의 한 형태로 다룹니다. 현재 연구의 discrimination-related threshold DIF는 response shift의 한 가지 후보적 표현으로 해석할 수 있습니다. 다만 인과적으로 "차별이 response shift를 일으켰다"고 쓰면 안 되고, "findings are consistent with discrimination-related measurement-function shift" 정도가 안전합니다.

### 5.5 MAPS-specific prior evidence는 discrimination DIF의 타당한 출발점을 제공한다

Lee and Choi (2026)는 MAPS 기반 acculturative stress 문항에서 discrimination-related DIF가 관찰될 수 있음을 보여줍니다. 따라서 현재 연구가 discrimination을 주요 time-varying DIF predictor로 다루는 것은 사후적 fishing이 아니라 같은 자료 맥락의 선행 심리측정 근거가 있는 선택으로 방어할 수 있습니다. 다만 이 문헌은 독립적 외부검증이 아니라 연구 프로그램 내부의 선행 근거로 표현해야 합니다.

---

## 6. Research Gap

현재 문헌의 빈틈은 다음처럼 정리하는 것이 가장 강합니다.

### Gap 1. Longitudinal MNLFA는 있지만, ordinal migrant-panel discrimination DIF 적용은 드물다

Chen and Bauer의 longitudinal MNLFA는 매우 직접적인 방법론 anchor입니다. 그러나 MAPS 같은 migrant-family panel에서 acculturative stress ordinal items와 time-varying discrimination을 결합한 응용은 별도 기여가 있습니다.

### Gap 2. DIF 검출은 있지만, longitudinal change 해석에 대한 contribution decomposition은 부족하다

기존 MNLFA는 보통 어떤 item-covariate pair에서 DIF가 있는지를 보고합니다. 하지만 applied longitudinal 연구자가 궁금한 것은 한 단계 더 나아갑니다.

> 관찰된 점수 변화 중 얼마가 실제 latent stress change이고, 얼마가 item-functioning change인가?

RSDI는 이 질문에 답하기 위한 posterior-based counterfactual estimand로 제안할 수 있습니다.

### Gap 3. Response shift 문헌과 ordinal MNLFA 문헌 사이의 연결이 아직 약하다

response shift 문헌은 개념적으로 풍부하지만, ordinal item threshold/loading DIF와 posterior predictive probabilities로 response shift contribution을 계산하는 방식은 덜 직접적으로 정리되어 있습니다. 현재 연구는 response shift를 문항모수 변화와 예측 응답확률 변화로 연결할 수 있습니다.

### Gap 4. 대규모 longitudinal ordinal MNLFA의 추정전략이 실용적으로 어렵다

full NUTS는 계산적으로 무겁고, VI는 근사 posterior입니다. 따라서 VI, Pathfinder/full-rank VI, subset NUTS, selected NUTS를 비교하는 estimation calibration workflow 자체도 박사논문 3번째 축으로 방어할 수 있습니다.

---

## 7. 현재 연구의 가장 안전한 문헌기반 주장

가장 안전한 주장은 다음입니다.

> Prior work shows that longitudinal growth interpretation depends on stable measurement, and recent longitudinal MNLFA research provides a framework for modeling construct change amid measurement change. However, less is known about how time-varying discrimination-related DIF in ordinal migrant-family panel data contributes to observed response trajectories. This study extends the longitudinal MNLFA logic by proposing a posterior-based counterfactual decomposition of ordinal response change into latent-change and measurement-shift components.

한국어로는:

> 기존 문헌은 종단 성장해석이 측정불변성에 의존한다는 점과, longitudinal MNLFA가 construct change와 measurement change를 함께 다룰 수 있다는 점을 보여준다. 그러나 다문화가족 패널의 서열형 acculturative stress 문항에서 시간가변 차별경험 관련 DIF가 관찰 응답궤적에 얼마나 기여하는지를 분해한 연구는 부족하다. 본 연구는 Bayesian longitudinal MNLFA posterior를 이용해 응답변화를 latent-change 성분과 measurement-shift 성분으로 반사실적으로 분해하는 방법을 제안한다.

---

## 8. 교수님께 말할 수 있는 짧은 버전

문헌을 보면 longitudinal measurement invariance, MNLFA, response shift는 각각 따로 발전해왔습니다. 특히 Chen and Bauer의 longitudinal MNLFA 논문은 제 연구의 가장 직접적인 방법론 근거입니다. 그런데 기존 연구는 주로 "measurement change를 모형화해야 한다"는 데 초점이 있고, 실제 적용에서 관찰 응답 변화 중 얼마가 latent change이고 얼마가 measurement shift인지 문항별로 분해하는 지표는 아직 명확히 정리되지 않은 것 같습니다.

그래서 저는 MAPS acculturative stress 자료에서 time-varying discrimination DIF를 Bayesian longitudinal ordinal MNLFA로 추정하고, posterior predictive counterfactuals를 이용해 response-shift contribution을 RSDI로 정량화하는 방향을 생각하고 있습니다. 즉, MNLFA 자체를 새로 발명한다기보다, longitudinal MNLFA 결과를 해석 가능한 decomposition estimand로 확장하는 쪽입니다.

---

## 9. 참고문헌

Bauer, D. J. (2017). A more general model for testing measurement invariance and differential item functioning. *Psychological Methods*. https://doi.org/10.1037/met0000077

Bauer, D. J., Belzak, W. C. M., & Cole, V. T. (2019). Simplifying the assessment of measurement invariance over multiple background variables: Using regularized moderated nonlinear factor analysis to detect differential item functioning. *Structural Equation Modeling: A Multidisciplinary Journal*. https://doi.org/10.1080/10705511.2019.1642754

Chen, S. M., & Bauer, D. J. (2024). Modeling construct change over time amidst potential changes in construct measurement: A longitudinal moderated factor analysis approach. *Psychological Methods*. https://doi.org/10.1037/met0000685

Chen, S. M., & Bauer, D. J. (2026). Improving the evaluation of construct change over time: Advantages of longitudinal moderated nonlinear factor analysis over conventional first-order growth models. *Multivariate Behavioral Research*. https://doi.org/10.1080/00273171.2026.2640576

Kim, E. S., & Willson, V. L. (2014). Measurement invariance across groups in latent growth modeling. *Structural Equation Modeling: A Multidisciplinary Journal*. https://doi.org/10.1080/10705511.2014.915374

King-Kallimanis, B. L., Oort, F. J., & Garst, G. J. A. (2010). Using structural equation modelling to detect measurement bias and response shift in longitudinal data. *AStA Advances in Statistical Analysis*. https://doi.org/10.1007/s10182-010-0129-y

Lee, C., & Choi, Y. (2026). Psychometric validation of the cultural adaptation stress scale for mothers from multicultural families using the graded response model. *Korean Journal of Convergence Science, 15*(2), 379-395. https://www.kci.go.kr/kciportal/ci/sereArticleSearch/ciSereArtiView.kci?sereArticleSearchBean.artiId=ART003314865

Liu, Y., Millsap, R. E., West, S. G., Tein, J.-Y., Tanaka, R., & Grimm, K. J. (2017). Testing measurement invariance in longitudinal data with ordered-categorical measures. *Psychological Methods*. https://doi.org/10.1037/met0000075

Oort, F. J. (2005). Using structural equation modeling to detect response shifts and true change. *Quality of Life Research*. https://doi.org/10.1007/s11136-004-0830-y

Padgett, R. N. (2025). Multidimensional constructs and moderated linear and nonlinear factor analysis. *arXiv*. https://arxiv.org/abs/2509.05443

Sprangers, M. A. G., & Schwartz, C. E. (1999). Integrating response shift into health-related quality of life research: A theoretical model. *Social Science & Medicine*. https://doi.org/10.1016/S0277-9536(99)00045-3

Wallin, G., & Huang, Q. (2026). A regularised latent-class item response model for detecting measurement non-invariance in ordinal response scales. *arXiv*. https://arxiv.org/abs/2601.17612

Wallin, G., & Huang, Q. (2026). Latent impact and differential item functioning analysis for asymmetric IRT models. *arXiv*. https://arxiv.org/abs/2605.05684

Widaman, K. F., Ferrer, E., & Conger, R. D. (2010). Factorial invariance within longitudinal structural equation models: Measuring the same construct across time. *Child Development Perspectives*. https://doi.org/10.1111/j.1750-8606.2009.00110.x
