from tools.moonlight_highlights.formula_extract import is_formula_candidate


def test_is_formula_candidate_when_block_only_references_equation() -> None:
    # Given: prose that refers to an equation but contains no equation itself.
    text = "See Equation (1) for the full model."

    # When: the block is inspected.
    candidate = is_formula_candidate(text)

    # Then: it is rejected to avoid creating a false formula card.
    assert candidate is False
