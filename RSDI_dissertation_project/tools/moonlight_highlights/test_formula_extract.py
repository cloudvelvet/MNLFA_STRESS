from tools.moonlight_highlights.formula_extract import (
    FormulaReviewState,
    is_formula_candidate,
    korean_explanation_draft,
)


def test_is_formula_candidate_when_block_has_mathematical_structure() -> None:
    # Given: a displayed equation with several mathematical operators.
    text = "delta_mu = mu_2 - mu_1 (1)"

    # When: the block is inspected.
    candidate = is_formula_candidate(text)

    # Then: it is retained as a formula candidate.
    assert candidate is True


def test_korean_explanation_draft_when_formula_is_latent_mean_change() -> None:
    # Given: a formula representing a difference in latent factor means.
    source = "delta_mu = mu_2 - mu_1"

    # When: a Korean explanation draft is built.
    draft = korean_explanation_draft(source)

    # Then: it explains the substantive role and retains human review.
    assert "\uc7a0\uc7ac\uc694\uc778 \ud3c9\uade0" in draft.text
    assert draft.review_state is FormulaReviewState.NEEDS_HUMAN_REVIEW

