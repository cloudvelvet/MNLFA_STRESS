"""Formula detection primitives with explicit human-review status."""

from __future__ import annotations

import re
from dataclasses import dataclass
from enum import StrEnum
from typing import Final

MATH_SIGNS: Final = frozenset("=+-*/^_()[]{}<>")
MIN_OPERATOR_COUNT: Final = 3
EQUATION_REFERENCE: Final = re.compile(r"\bEquation\s*\(\d+(?:\.\d+)?\)", re.IGNORECASE)


class FormulaReviewState(StrEnum):
    """A formula remains unapproved until its source crop is reviewed."""

    NEEDS_HUMAN_REVIEW = "needs_human_review"


@dataclass(frozen=True, slots=True)
class FormulaExplanation:
    """A cautious Korean explanation draft for a formula source transcription."""

    text: str
    review_state: FormulaReviewState


def is_formula_candidate(text: str) -> bool:
    """Return whether a text block is likely a displayed equation, not a reference."""
    compact = " ".join(text.split())
    if EQUATION_REFERENCE.fullmatch(compact) is not None:
        return False
    operator_count = sum(character in MATH_SIGNS for character in compact)
    has_equality = "=" in compact
    alpha_ratio = sum(character.isalpha() for character in compact) / max(len(compact), 1)
    return (
        (has_equality and operator_count >= 2)
        or (operator_count >= MIN_OPERATOR_COUNT and alpha_ratio < 0.7)
    )


def korean_explanation_draft(source_text: str) -> FormulaExplanation:
    """Create a deliberately provisional Korean explanation from ASCII SEM notation."""
    normalized = source_text.lower().replace(" ", "")
    if "mu" in normalized:
        text = (
            "\ucd94\uc815 \uc124\uba85: \uc7a0\uc7ac\uc694\uc778 \ud3c9\uade0 \ub610\ub294 \ud3c9\uade0 \ubcc0\ud654\uc640 "
            "\uad00\ub828\ub41c \uc2dd\uc73c\ub85c \ubcf4\uc778\ub2e4. \ub450 \uc2dc\uc810\uc758 \ud3c9\uade0 \ucc28\uc774\ub97c "
            "\ud1b5\ud574 true change\ub97c \ud3c9\uac00\ud558\ub294 \ub370 \uc0ac\uc6a9\ub420 \uc218 \uc788\ub2e4."
        )
    elif "lambda" in normalized or "loading" in normalized:
        text = (
            "\ucd94\uc815 \uc124\uba85: \uc694\uc778\uc801\uc7ac\ub7c9\uacfc \uad00\ub828\ub41c \uc2dd\uc73c\ub85c \ubcf4\uc778\ub2e4. "
            "\uc2dc\uc810 \uac04 \uc801\uc7ac\ub7c9 \ubcc0\ud654\ub294 reprioritization\uc744 \uac80\ud1a0\ud558\ub294 "
            "\uadfc\uac70\uac00 \ub420 \uc218 \uc788\ub2e4."
        )
    elif "tau" in normalized or "intercept" in normalized:
        text = (
            "\ucd94\uc815 \uc124\uba85: \uc808\ud3b8 \ub610\ub294 \uc751\ub2f5 \uae30\uc900\uacfc \uad00\ub828\ub41c "
            "\uc2dd\uc73c\ub85c \ubcf4\uc778\ub2e4. \uc2dc\uc810 \uac04 \ubcc0\ud654\ub294 uniform recalibration\uc744 "
            "\uac80\ud1a0\ud558\ub294 \uadfc\uac70\uac00 \ub420 \uc218 \uc788\ub2e4."
        )
    elif "chi" in normalized or "x2" in normalized:
        text = (
            "\ucd94\uc815 \uc124\uba85: \ubaa8\ud615 \uc801\ud569\ub3c4 \ucc28\uc774\ub97c \ube44\uad50\ud558\ub294 "
            "\uc2dd\uc73c\ub85c \ubcf4\uc778\ub2e4. \uc81c\uc57d \ubaa8\ud615\uacfc \uc644\ud654 \ubaa8\ud615\uc758 "
            "\ucc28\uc774\ub85c response shift\ub97c \uac80\uc815\ud560 \uc218 \uc788\ub2e4."
        )
    else:
        text = (
            "\ucd94\uc815 \uc124\uba85: \uc218\uc2dd\uc758 \uc6d0\ubcf8 \uc774\ubbf8\uc9c0\uc640 \uc55e\ub4a4 \ubb38\ub9e5\uc744 "
            "\ud568\uaed8 \ubd10\uc57c \ud55c\ub2e4. \uc790\ub3d9 \uc804\uc0ac\ub294 \ucd08\uc548\uc774\uba70, "
            "\uae30\ud638\uc640 \ucca8\uc790\u00b7\uc704\ucca8\uc790\ub294 \uc0ac\ub78c \uac80\ud1a0 \ud6c4 \ud655\uc815\ud55c\ub2e4."
        )
    return FormulaExplanation(
        text=f"{text} \uc6d0\ubcf8 \uc218\uc2dd \uc774\ubbf8\uc9c0\uc640 \ub300\uc870\ud558\uae30 \uc804\uc5d0\ub294 \uc778\uc6a9\ud558\uc9c0 \uc54a\ub294\ub2e4.",
        review_state=FormulaReviewState.NEEDS_HUMAN_REVIEW,
    )

