from tools.moonlight_highlights.moonlight_extract import (
    HighlightCategory,
    HighlightPalette,
    Passage,
    WordBox,
    classify_color,
    expand_to_sentence,
    is_readable_highlight,
    merge_words,
)


def test_classify_color_when_pixel_matches_method_palette() -> None:
    # Given: a color close to the configured method highlight.
    palette = HighlightPalette.default()

    # When: the color is classified.
    category = classify_color((230, 252, 230), palette)

    # Then: it is assigned to Method.
    assert category is HighlightCategory.METHOD


def test_merge_words_when_adjacent_words_share_a_category() -> None:
    # Given: adjacent words from a single highlighted line.
    words = (
        WordBox("structural", 10.0, 20.0, 45.0, 30.0),
        WordBox("equation", 48.0, 20.0, 82.0, 30.0),
        WordBox("modeling", 85.0, 20.0, 120.0, 30.0),
    )

    # When: the words are merged.
    passages = merge_words(words, HighlightCategory.METHOD)

    # Then: a single ordered passage is produced.
    assert len(passages) == 1
    assert passages[0].text == "structural equation modeling"
    assert passages[0].category is HighlightCategory.METHOD




def test_merge_words_when_highlight_wraps_across_pdf_lines() -> None:
    # Given: a passage split by a normal PDF line wrap and a line-ending hyphen.
    words = (
        WordBox("recalibra-", 10.0, 20.0, 230.0, 30.0),
        WordBox("tion", 10.0, 32.0, 35.0, 42.0),
        WordBox("response", 38.0, 32.0, 82.0, 42.0),
        WordBox("shift", 85.0, 32.0, 115.0, 42.0),
    )

    # When: the highlighted lines are merged.
    passages = merge_words(words, HighlightCategory.NOVELTY)

    # Then: one readable passage restores the split word.
    assert len(passages) == 1
    assert passages[0].text == "recalibration response shift"


def test_readable_highlight_when_text_is_a_journal_header() -> None:
    # Given: a colored journal masthead that resembles a Moonlight highlight.
    passage = Passage(HighlightCategory.NOVELTY, 1, "Contents lists available at ScienceDirect")

    # When: its reading value is checked.
    readable = is_readable_highlight(passage)

    # Then: the masthead is excluded.
    assert readable is False


def test_readable_highlight_when_text_is_a_short_fragment() -> None:
    # Given: an isolated word produced by a decorative color collision.
    passage = Passage(HighlightCategory.RESULT, 10, "both")

    # When: its reading value is checked.
    readable = is_readable_highlight(passage)

    # Then: the fragment is excluded.
    assert readable is False


def test_readable_highlight_when_text_is_substantive() -> None:
    # Given: a complete highlighted research statement.
    passage = Passage(
        HighlightCategory.METHOD,
        4,
        "A total of 291 articles were included in the review.",
    )

    # When: its reading value is checked.
    readable = is_readable_highlight(passage)

    # Then: the statement is retained.
    assert readable is True


def test_expand_to_sentence_when_highlight_is_partial() -> None:
    # Given: a complete source sentence and a highlighted phrase inside it.
    source = "Recent studies increasingly simulate tests of between 2 and 15 items. A second sentence follows."
    anchor = "simulate tests of between 2 and 15 items"

    # When: the anchor is expanded against the source text.
    expanded = expand_to_sentence(source, anchor)

    # Then: the complete containing sentence is returned.
    assert expanded == "Recent studies increasingly simulate tests of between 2 and 15 items."


def test_expand_to_sentence_when_highlight_contains_contamination() -> None:
    # Given: a highlighted sentence followed by unrelated text from another layout region.
    source = "Various methods have been proposed for detecting DIF. The next sentence is separate."
    anchor = "Various methods have been proposed for detecting DIF. biased items"

    # When: the contaminated anchor is expanded using its stable prefix.
    expanded = expand_to_sentence(source, anchor)

    # Then: only the matched source sentence is returned.
    assert expanded == "Various methods have been proposed for detecting DIF."


def test_expand_to_sentence_when_source_contains_decimals() -> None:
    # Given: a sentence with percentages that contain decimal points.
    source = "Purification increased from 27. 1% to 41. 7%. A second sentence follows."
    anchor = "Purification increased from 27.1%"

    # When: the anchor is expanded against the source text.
    expanded = expand_to_sentence(source, anchor)

    # Then: decimal points do not terminate the sentence.
    assert expanded == "Purification increased from 27.1% to 41.7%."



def test_readable_highlight_when_text_is_an_access_masthead() -> None:
    # Given: a repository access masthead colored like a highlight.
    passage = Passage(HighlightCategory.NOVELTY, 1, "HHS Public Access")

    # When: its reading value is checked.
    readable = is_readable_highlight(passage)

    # Then: the masthead is excluded.
    assert readable is False


def test_readable_highlight_when_text_is_an_author_manuscript_header() -> None:
    # Given: an author-manuscript banner colored like a highlight.
    passage = Passage(HighlightCategory.NOVELTY, 1, "Author manuscript Psychol Methods")

    # When: its reading value is checked.
    readable = is_readable_highlight(passage)

    # Then: the banner is excluded.
    assert readable is False
