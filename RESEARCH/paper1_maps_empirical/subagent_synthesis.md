# Subagent Synthesis

This memo summarizes the delegated review used to shape the first Paper 1 draft.

## Literature Framing

The literature lane recommended framing Paper 1 around the claim that
longitudinal change inference requires a stable measurement function. For MAPS,
this should be sharpened to ordered-categorical indicators, because the item
responses are ordinal. The strongest citation chain is:

- Widaman, Ferrer, and Conger (2010) for longitudinal factorial invariance.
- Liu et al. (2017) for ordered-categorical longitudinal invariance.
- Kim and Willson (2014) for bias in latent growth parameters under
  noninvariance.
- Bauer (2017) and Bauer, Belzak, and Cole (2020) for MNLFA with multiple
  covariates.
- Chen and Bauer (2024, 2026) for longitudinal MNLFA and the direct comparison
  with conventional growth modeling.
- King-Kallimanis, Oort, and Garst (2010) for response shift as measurement bias
  in longitudinal data.
- Lee and Choi (2026) as MAPS-specific contextual support that discrimination
  can be a DIF source.

## Design Review

The design lane emphasized that the current repository only implements the
longitudinal MNLFA lane. The strongest Paper 1 is a three-way comparison:

1. Naive observed-score growth.
2. Invariant ordinal latent growth.
3. Longitudinal ordinal MNLFA.

The comparator analyses are not yet implemented, so the draft must not claim a
completed three-model empirical comparison. The final paper should add
model-implied trajectories and counterfactual expected-score trajectories with
discrimination DIF set to zero.

The design lane also warned that the current output includes loading DIF, so a
threshold-only interpretation would be incomplete.

## Writing Review

The writing lane recommended a cautious manuscript thesis:

Observed longitudinal score differences may reflect latent change, measurement-
function change, or both. This paper evaluates how conclusions about MAPS
parental acculturative-stress trajectories change when measurement-function
change is ignored, constrained, or modeled directly.

The writing lane specifically advised avoiding claims that:

- response shift is proven;
- discrimination causally changed the response process;
- full-data NUTS has confirmed the VI estimates;
- observed change is necessarily an increase in acculturative stress.

