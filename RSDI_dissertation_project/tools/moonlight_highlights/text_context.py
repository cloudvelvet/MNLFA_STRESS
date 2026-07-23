"""Recover complete sentences around flattened-PDF highlight anchors."""

from __future__ import annotations

import re
from typing import Final

MIN_ANCHOR_WORDS: Final = 5
MAX_ANCHOR_WORDS: Final = 12


def expand_to_sentence(source_text: str, anchor_text: str) -> str:
    """Expand a highlighted anchor to its complete containing sentence."""
    source = normalize_pdf_text(source_text)
    anchor = normalize_pdf_text(anchor_text)
    location = find_anchor(source, anchor)
    if location is None:
        return anchor
    match_start, _ = location
    sentence_start = 0
    for index in range(match_start - 1, -1, -1):
        if is_sentence_end(source, index):
            sentence_start = index + 1
            break
    sentence_end = len(source)
    for index in range(match_start, len(source)):
        if is_sentence_end(source, index):
            sentence_end = index + 1
            break
    return source[sentence_start:sentence_end].strip()


def normalize_pdf_text(text: str) -> str:
    """Collapse PDF line breaks while restoring line-ending hyphenation."""
    dehyphenated = text.replace("-\r\n", "").replace("-\n", "")
    normalized = " ".join(dehyphenated.split())
    return re.sub(r"(?<=\d)\.\s+(?=\d)", ".", normalized)


def find_anchor(source_text: str, anchor_text: str) -> tuple[int, int] | None:
    """Locate an anchor exactly or by a stable leading phrase."""
    source = source_text.casefold()
    anchor = anchor_text.casefold()
    direct_start = source.find(anchor)
    if direct_start >= 0:
        return direct_start, direct_start + len(anchor)
    words = anchor.split()
    for word_count in range(min(MAX_ANCHOR_WORDS, len(words)), MIN_ANCHOR_WORDS - 1, -1):
        prefix = " ".join(words[:word_count])
        prefix_start = source.find(prefix)
        if prefix_start >= 0:
            return prefix_start, prefix_start + len(prefix)
    return None


def is_sentence_end(text: str, index: int) -> bool:
    """Identify sentence punctuation without treating decimal points as stops."""
    character = text[index]
    if character in "?!":
        return True
    if character != ".":
        return False
    previous_is_digit = index > 0 and text[index - 1].isdigit()
    next_is_digit = index + 1 < len(text) and text[index + 1].isdigit()
    return not (previous_is_digit and next_is_digit)

