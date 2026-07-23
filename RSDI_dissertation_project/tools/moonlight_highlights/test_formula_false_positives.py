from tools.moonlight_highlights.formula_cards import detection_score


def test_detection_score_when_text_contains_url_parameters() -> None:
    # Given: a URL with punctuation and an equals sign.
    reference = "https://example.org/paper?seq=1&cid=pdf-reference"

    # When: its equation likelihood is scored.
    score = detection_score(reference)

    # Then: it is excluded from equation candidates.
    assert score == 0.0


def test_detection_score_when_text_is_a_model_constraint_table_row() -> None:
    # Given: a table row that happens to contain an equals sign.
    table_row = "Measurement model Diag(Q11) = Diag(Q22) = I"

    # When: its equation likelihood is scored.
    score = detection_score(table_row)

    # Then: it is not presented as a standalone formula card.
    assert score == 0.0


def test_detection_score_when_text_is_a_prose_test_result() -> None:
    # Given: a sentence fragment with a threshold and citation.
    prose = "= 0.01) [12]. For this test, sample sizes are needed"

    # When: its equation likelihood is scored.
    score = detection_score(prose)

    # Then: it is not presented as a standalone formula card.
    assert score == 0.0


def test_detection_score_when_text_is_a_constraint_table_fragment() -> None:
    # Given: a table fragment containing mathematical constraints.
    table_fragment = "Diag(Q11) = I constraints within T, F, and Diag(Q)"

    # When: its equation likelihood is scored.
    score = detection_score(table_fragment)

    # Then: it is not presented as a standalone formula card.
    assert score == 0.0
