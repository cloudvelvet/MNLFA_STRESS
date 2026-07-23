from tools.moonlight_highlights.formula_cards import detection_score


def test_detection_score_when_text_only_references_equation() -> None:
    # Given: a prose reference without any displayed mathematical expression.
    reference = "See Equation (1) for the full model."

    # When: its equation likelihood is scored.
    score = detection_score(reference)

    # Then: it remains below the candidate threshold.
    assert score < 0.72
