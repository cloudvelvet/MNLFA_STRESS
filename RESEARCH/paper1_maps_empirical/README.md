# Paper 1 MAPS Empirical Manuscript Workspace

## Working Title

Distinguishing Latent Change from Measurement-Function Change in Acculturative Stress:
A Longitudinal Ordinal MNLFA of MAPS Parent Panel Data

## Core Contribution

This paper is framed as an empirical psychometric comparison:

1. Naive observed-score growth model.
2. Invariant ordinal latent growth model.
3. Longitudinal ordinal MNLFA with time-varying DIF predictors.

The current repository already supports the third lane. The first two comparator
lanes still need to be implemented before the manuscript can support the full
comparison claim.

## Current Evidence Already Available

- MAPS 2nd cohort parent panel, waves 1-5.
- 2,191 persons, 5 waves, 8 ordinal acculturative-stress items.
- 77,296 item rows before complete DIF-predictor filtering.
- 77,160 item rows used in the full MNLFA fit.
- Main full-data MNLFA estimates are mean-field variational inference.
- Small subset NUTS was used only as a pipeline diagnostic, not as full posterior
  confirmation.
- Current MNLFA latent slope mean is approximately -0.028.
- Current strongest discrimination threshold DIF effects are negative, especially
  Item 2 and Item 6, meaning lower endorsement thresholds for parents reporting
  discrimination at the same latent level.

## Files

- `outputs/paper1_empirical_draft.md`: first manuscript draft.
- `sources/key_sources.md`: source notes and citation anchors.
- `subagent_synthesis.md`: synthesis of the delegated literature, design, and
  writing reviews.
- `analysis_todo.md`: analyses needed before submission.
