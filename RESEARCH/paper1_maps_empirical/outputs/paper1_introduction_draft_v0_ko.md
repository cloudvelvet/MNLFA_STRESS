# 논문 1 서론 초안 v0.1

작성일: 2026-07-02

작업 상태: 초안. 문헌 인용은 일부 DOI/웹 확인을 마쳤으나, Stage 2.5 integrity 단계에서 전체 reference check가 필요함.

제목 후보:

> 잠재변화인가 측정이동인가? MAPS 부모 패널 문화적응 스트레스의 Bayesian Longitudinal Ordinal MNLFA와 RSDI 분석

영문 제목 후보:

> Disentangling Latent Change and Response Shift in Longitudinal Acculturative Stress: A Bayesian Ordinal MNLFA Application to MAPS Parent Panel Data

## Introduction

종단 연구에서 성장모형은 반복 측정된 점수의 변화를 통해 개인과 집단의 변화 궤적을 추정한다. 그러나 성장모형의 해석은 단순히 시점이 여러 개 있다는 사실만으로 보장되지 않는다. 같은 문항 또는 같은 척도 점수가 시간에 걸쳐 같은 잠재구인을 같은 방식으로 반영한다는 전제가 필요하다. 종단 measurement invariance가 충족되지 않으면, 관찰된 점수 변화는 실제 latent construct의 변화뿐 아니라 문항이 작동하는 방식의 변화까지 함께 포함할 수 있다(Widaman et al., 2010; Liu et al., 2017). 이 경우 성장계수는 “스트레스가 변했다”는 해석과 “스트레스를 보고하는 기준이 변했다”는 해석을 구분하지 못한다.

이 문제는 이주배경 및 다문화가족 연구에서 특히 중요하다. 이주가족의 적응 과정에서는 언어능력, 사회경제적 지위, 사회적 관계, 차별경험이 시간에 따라 빠르게 변할 수 있다. 이러한 요인은 문화적응 스트레스의 수준 자체를 바꿀 수 있지만, 동시에 특정 문항을 해석하고 응답하는 방식도 바꿀 수 있다. 예를 들어 같은 latent acculturative stress 수준에 있더라도 차별경험을 최근에 겪은 응답자는 분노, 위축, 낮은 사회적 지위감과 관련된 문항에서 더 높은 범주를 선택할 수 있다. 이 경우 차별경험은 단순한 예측변수가 아니라 문항 threshold 또는 loading을 변화시키는 measurement moderator가 된다. 심리측정 용어로는 differential item functioning(DIF)이며, 종단 맥락에서는 response shift와도 연결된다(Sprangers & Schwartz, 1999; Oort, 2005).

기존 종단 분석은 대체로 두 가지 방식으로 이 문제를 다루어 왔다. 첫째, 합산점수나 평균점수를 반복측정 변수로 두고 naive growth model을 추정한다. 이 접근은 간단하지만, 문항별 측정기능이 시간 또는 공변량에 따라 달라질 가능성을 거의 반영하지 못한다. 둘째, confirmatory factor analysis 또는 ordinal latent growth model을 통해 configural, metric, scalar invariance를 검토한다. 이 접근은 합산점수 분석보다 명시적이지만, 여러 시간가변 공변량이 동시에 문항모수에 영향을 주는 상황에서는 모형이 빠르게 복잡해진다. 특히 ordinal item, 여러 wave, continuous covariate, binary discrimination indicator가 함께 있는 자료에서는 전통적인 invariance test만으로는 어떤 measurement-function change가 관찰 응답 궤적에 얼마나 기여하는지 설명하기 어렵다.

Moderated nonlinear factor analysis(MNLFA)는 이 지점에서 유용한 대안이 된다. MNLFA는 문항 loading, threshold 또는 intercept, residual variance 같은 측정모형의 모수를 응답자 특성의 함수로 표현함으로써, 집단변수뿐 아니라 연속형 또는 시간가변 공변량에 따른 DIF를 하나의 모형 안에서 다룰 수 있다(Bauer, 2017). 최근 Chen과 Bauer(2024)는 이러한 논리를 종단 자료로 확장하여 construct change와 measurement change가 혼재된 상황에서 longitudinal moderated factor analysis가 기존 성장모형의 한계를 보완할 수 있음을 보였다. 이 접근은 반복 측정된 평균점수의 변화를 곧바로 construct change로 해석하는 관행이 measurement constancy를 암묵적으로 가정한다는 점을 분명히 한다.

그럼에도 적용 연구에서 남는 질문은 한 단계 더 구체적이다. DIF가 존재하는지는 중요하지만, 종단 연구자가 실제로 알고 싶은 것은 “관찰된 응답 변화 중 얼마가 latent change이고, 얼마가 measurement-function change인가?”이다. 기존 MNLFA 연구는 주로 어떤 문항-공변량 조합에서 DIF가 나타나는지를 보고한다. response shift 문헌은 측정기준 변화의 개념적 의미를 제공하지만, ordinal item response model의 posterior predictive probability를 이용해 response-shift contribution을 직접 분해하는 방식은 아직 충분히 정리되어 있지 않다. 따라서 longitudinal ordinal MNLFA와 response shift 문헌 사이에는 해석 가능한 decomposition estimand가 필요하다.

본 연구는 이 공백을 MAPS 2기 부모 패널의 문화적응 스트레스 자료에서 다룬다. 분석 대상은 반복 측정된 ordinal acculturative stress items와 시간가변 공변량이다. 특히 차별경험, 한국어 능력, 소득과 같은 공변량이 latent stress 수준뿐 아니라 문항 threshold와 loading에 영향을 줄 수 있다고 보고, Bayesian longitudinal ordinal MNLFA를 추정한다. 이 모형은 latent growth trajectory와 item-functioning change를 동시에 표현한다. 여기서 본 연구는 MNLFA posterior로부터 posterior predictive counterfactuals를 구성하고, 관찰 응답 변화의 latent-change component와 measurement-shift component를 분해하는 지표인 Response Shift Decomposition Index(RSDI)를 제안한다.

본 연구의 목적은 세 가지다. 첫째, naive observed-score growth model과 measurement-invariant ordinal latent growth model, 그리고 longitudinal ordinal MNLFA가 문화적응 스트레스의 종단 변화에 대해 어떤 서로 다른 해석을 제공하는지 비교한다. 둘째, 차별경험을 포함한 시간가변 공변량이 acculturative stress 문항의 threshold/loading DIF와 관련되는지 검토한다. 셋째, RSDI를 이용해 관찰된 응답 변화 중 measurement-function shift가 차지하는 정도를 정량화한다. 추가로 차별경험 공변량과 의미적으로 가까운 문항이 결과를 과도하게 주도한다는 비판을 점검하기 위해, 차별 내용과 가까운 문항을 제외한 민감도 분석을 수행한다.

이 연구의 기여는 두 층위로 구분된다. 첫째, MNLFA 자체는 기존 심리측정 방법론에 속하지만, 본 연구는 이를 MAPS 부모 패널의 longitudinal ordinal acculturative stress 자료와 time-varying discrimination-related DIF에 적용한다. 둘째, 본 연구는 MNLFA 추정값을 단순한 DIF 계수 보고에 그치지 않고, 관찰 응답 변화 중 measurement-function shift가 차지하는 정도를 요약하는 RSDI estimand로 확장한다. 즉 문화적응 스트레스가 시간에 따라 감소하거나 증가했는지를 묻는 데서 멈추지 않고, 그 변화가 latent stress 변화인지, 차별경험과 연결된 response threshold 변화인지, 또는 두 과정의 결합인지 분해한다. 이러한 접근은 다문화가족 종단연구에서 DIF 검토가 성장모형 이후의 부가 절차가 아니라 성장해석의 전제 조건임을 보여준다.

## Research Questions

1. MAPS 부모 패널의 문화적응 스트레스 종단 변화는 naive observed-score growth, invariant ordinal latent growth, longitudinal ordinal MNLFA에서 어떻게 달리 해석되는가?
2. 차별경험, 한국어 능력, 소득 등 시간가변 공변량은 acculturative stress 문항의 threshold 또는 loading DIF와 관련되는가?
3. 차별경험 관련 measurement-function change는 관찰된 ordinal response trajectory 변화에 어느 정도 기여하는가?
4. 차별경험과 의미적으로 가까운 문항을 제외해도 response-shift component는 유지되는가?

## 현재 초안에서의 핵심 논리

짧게 말하면:

> 종단 성장모형은 반복 측정 점수가 비교가능하다는 전제 위에서 작동한다. 그러나 MAPS 부모 패널처럼 차별경험과 언어능력, 소득이 시간에 따라 변하는 자료에서는 이 요인들이 latent stress뿐 아니라 문항 응답기준까지 바꿀 수 있다. 본 연구는 Bayesian longitudinal ordinal MNLFA로 이 time-varying DIF를 모델링하고, RSDI를 통해 관찰 응답 변화 중 latent change와 measurement-function shift를 분리한다.

## 인용/검증 메모

아래 문헌은 서론 본문에 들어간 핵심 citation이다. 최종 원고 전 Stage 2.5에서 DOI, reference metadata, citation context를 다시 확인해야 한다.

| 문헌 | 본문 역할 | 현재 확인 상태 |
|---|---|---|
| Widaman, Ferrer, & Conger (2010) | 종단 measurement invariance의 기본 근거 | DOI 보유, 추가 확인 필요 |
| Liu et al. (2017) | ordered-categorical longitudinal MI 근거 | DOI 보유, 추가 확인 필요 |
| Bauer (2017) | MNLFA/DIF framework | DOI 보유, 추가 확인 필요 |
| Chen & Bauer (2024) | longitudinal moderated factor analysis 직접 anchor | PubMed/DOI 확인 |
| Sprangers & Schwartz (1999) | response shift 이론 | DOI 보유, 추가 확인 필요 |
| Oort (2005) | SEM 기반 true change/response shift 구분 | DOI 보유, 추가 확인 필요 |
| Samejima (1969) | ordinal/graded response model 배경, Method에서 사용 가능 | 서론 본문에는 아직 직접 미사용 |

## 참고문헌 초안

Bauer, D. J. (2017). A more general model for testing measurement invariance and differential item functioning. *Psychological Methods*. https://doi.org/10.1037/met0000077

Chen, S. M., & Bauer, D. J. (2024). Modeling construct change over time amidst potential changes in construct measurement: A longitudinal moderated factor analysis approach. *Psychological Methods*. https://doi.org/10.1037/met0000685

King-Kallimanis, B. L., Oort, F. J., & Garst, G. J. A. (2010). Using structural equation modelling to detect measurement bias and response shift in longitudinal data. *AStA Advances in Statistical Analysis*. https://doi.org/10.1007/s10182-010-0129-y

Liu, Y., Millsap, R. E., West, S. G., Tein, J.-Y., Tanaka, R., & Grimm, K. J. (2017). Testing measurement invariance in longitudinal data with ordered-categorical measures. *Psychological Methods*. https://doi.org/10.1037/met0000075

Oort, F. J. (2005). Using structural equation modeling to detect response shifts and true change. *Quality of Life Research*. https://doi.org/10.1007/s11136-004-0830-y

Sprangers, M. A. G., & Schwartz, C. E. (1999). Integrating response shift into health-related quality of life research: A theoretical model. *Social Science & Medicine*. https://doi.org/10.1016/S0277-9536(99)00045-3

Widaman, K. F., Ferrer, E., & Conger, R. D. (2010). Factorial invariance within longitudinal structural equation models: Measuring the same construct across time. *Child Development Perspectives*. https://doi.org/10.1111/j.1750-8606.2009.00110.x

## 다음 수정 포인트

1. target이 KCI면 한국 다문화가족/MAPS 문헌을 서론 앞부분에 더 넣는다.
2. target이 SSCI면 Chen & Bauer, response shift, longitudinal MI를 더 앞세우고 MAPS는 application context로 둔다.
3. 방법론 논문 느낌을 키우려면 RSDI를 본 연구가 제안하는 posterior counterfactual estimand로 더 엄밀하게 정의한다.
4. 경험논문 느낌을 키우려면 “discrimination-related threshold DIF가 실제 해석을 어떻게 바꾸는가”를 전면에 둔다.
