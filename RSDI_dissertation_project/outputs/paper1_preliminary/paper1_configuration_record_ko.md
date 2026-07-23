# Paper Configuration Record — Paper 1

| Parameter | Value |
|---|---|
| **Topic** | Decomposing latent change and measurement-function shift in longitudinal ordinal panel data using a Bayesian longitudinal MNLFA posterior and the Response-Shift Decomposition Index (RSDI) |
| **Research Question** | In the MAPS parent panel, how much of observed longitudinal change in acculturative-stress ordinal responses is attributable to latent change versus discrimination-related measurement-function shift, and how does this alter inferences from conventional growth models? |
| **Paper Type** | Empirical methods/application article (IMRaD) |
| **Discipline** | Quantitative psychology / psychometrics / longitudinal measurement |
| **Target Journal** | General (venue selection pending) |
| **Citation Format** | APA 7th (provisional) |
| **Output Format** | Markdown first; final DOCX/PDF conversion after revision |
| **Body Language** | English |
| **Abstract** | English primary abstract plus Korean abstract and 5–7 keywords per language |
| **Word Count Target** | 7,000 words (excluding references, tables, and figures) |
| **Existing Materials** | Dissertation proposal; literature review and gap memo; Stan models and R analysis scripts; comparator, repeated-VI, subset-NUTS calibration, and sensitivity outputs; key-source list; Paper 1 manuscript strategy and Stage 2 handoff |
| **Co-Authors** | Single author (provisional) |
| **Funding** | Not documented; insert a verified funding/acknowledgment statement before finalization |
| **Style Profile** | null |
| **Operational Mode** | full |

## Scope and integrity constraints

- Primary framing: RSDI is a model-implied, posterior-predictive decomposition estimand/index, not a new sampler or fully validated general method.
- Primary model: structural-state longitudinal ordinal MNLFA; sensitivity analyses: measurement-only specification and exclusion of Items 1/2/6.
- Full-data findings are preliminary variational-inference results. Repeated VI and subset NUTS are calibration/robustness evidence only; they do not validate the full structural-state model.
- Use noncausal terminology: `discrimination-related measurement-function change` and `DIF patterns consistent with a response-shift interpretation`.
- Do not treat the MAPS empirical proof of concept as definitive method validation; reserve recovery, coverage, and workflow validation for the planned simulation/estimation papers.
- Verify all citations, reference metadata, and DOI data before submission. No source will be fabricated.

## Materials audit

The available project materials are sufficient to draft the empirical Paper 1 manuscript. They support the manuscript framing, methods, preliminary numerical results, robustness language, and core references. They do not yet document a target venue, final author/funding metadata, or a complete verified reference database.

## Provisional results to report carefully

| Result | Value | Reporting boundary |
|---|---:|---|
| Naive observed-score LME slope | -0.042 | Descriptive comparator only |
| Invariant ordinal LGM slope | -0.222 [ -0.239, -0.205 ] | Invariance-constrained comparator |
| Structural-state MNLFA slope | mean -0.210; seed range [ -0.260, -0.164 ] | Repeated-VI directional stability; the range is not a posterior interval |
| 8-item RSDI, W1–W5 | 0.360 [0.324, 0.396] | Preliminary VI result |
| Drop-Items-1/2/6 RSDI, W1–W5 | 0.260 [0.231, 0.334] | Sensitivity result; does not eliminate the response-shift-like component |

## Confirmation gate

This configuration is the required Phase 0 record for `academic-paper full`. Phase 1 literature consolidation, outline/argument construction, and full drafting may start only after the author confirms or corrects this record.
