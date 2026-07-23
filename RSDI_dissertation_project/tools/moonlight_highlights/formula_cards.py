"""Evidence-preserving formula cards for flattened Moonlight PDFs."""

from __future__ import annotations

import hashlib
import json
from dataclasses import asdict, dataclass
from enum import StrEnum
from pathlib import Path
from typing import Final

import fitz

from .formula_extract import FormulaExplanation, FormulaReviewState, korean_explanation_draft

RENDER_SCALE: Final = 2.5
CROP_PADDING: Final = 8.0
MIN_DETECTION_SCORE: Final = 0.72
MATH_SIGNS: Final = frozenset("=+-*/^_()[]{}<>")
TABLE_MARKERS: Final = frozenset(
    {
        "associated model",
        "identification constraints",
        "invariance constraints",
        "measurement model",
        "no response shift model",
        "response shift model",
        "response shift detection",
        "true change assessment",
        "true change common factor means",
    }
)
PROSE_MARKERS: Final = frozenset(
    {
        "are the",
        "for this test",
        "is rejected",
        "notes:",
        "where ",
        "constraints",
        "within ",
        "shifts diag",
    }
)


class FormulaCandidateType(StrEnum):
    """Conservative candidate type detected by the local pipeline."""

    DISPLAY_EQUATION = "display_equation"


@dataclass(frozen=True, slots=True)
class PdfBlock:
    """A text-layer block with coordinates in PDF points."""

    x0: float
    y0: float
    x1: float
    y1: float
    text: str


@dataclass(frozen=True, slots=True)
class FormulaEvidence:
    """Original evidence that allows a human to verify an AI draft."""

    page: int
    bbox_pdf: tuple[float, float, float, float]
    crop_path: str
    crop_sha256: str
    raw_ocr_text: str
    context_before: str
    context_after: str
    candidate_type: FormulaCandidateType
    detection_score: float


@dataclass(frozen=True, slots=True)
class FormulaReviewCard:
    """One formula with source evidence and a deliberately unapproved explanation."""

    evidence: FormulaEvidence
    explanation_draft_ko: FormulaExplanation
    review_status: FormulaReviewState


def detection_score(text: str) -> float:
    """Score a text block conservatively for displayed-equation likelihood."""
    compact = " ".join(text.split())
    lowered = compact.lower()
    if (
        len(compact) > 180
        or "http" in lowered
        or "www." in lowered
        or any(marker in lowered for marker in TABLE_MARKERS)
        or any(marker in lowered for marker in PROSE_MARKERS)
        or "." in compact
    ):
        return 0.0
    operator_count = sum(character in MATH_SIGNS for character in compact)
    has_equality = "=" in compact
    alpha_ratio = sum(character.isalpha() for character in compact) / max(len(compact), 1)
    score = 0.0
    if has_equality:
        score += 0.55
    if operator_count >= 3:
        score += 0.25
    if alpha_ratio < 0.7:
        score += 0.2
    if compact.endswith(")") and operator_count >= 4:
        score += 0.1
    return min(score, 1.0)


def extract_review_cards(pdf_path: Path, output_directory: Path) -> tuple[FormulaReviewCard, ...]:
    """Create unapproved formula cards and lossless crops from a PDF text layer."""
    evidence_directory = output_directory / "formula_evidence"
    evidence_directory.mkdir(parents=True, exist_ok=True)
    cards: list[FormulaReviewCard] = []
    with fitz.open(pdf_path) as document:
        for page_number, page in enumerate(document, start=1):
            blocks = _sorted_blocks(page)
            for block_index, block in enumerate(blocks):
                score = detection_score(block.text)
                if score >= MIN_DETECTION_SCORE:
                    crop_path = evidence_directory / f"page_{page_number:03d}_formula_{block_index + 1:02d}.png"
                    _save_crop(page, block, crop_path)
                    evidence = FormulaEvidence(
                        page=page_number,
                        bbox_pdf=(block.x0, block.y0, block.x1, block.y1),
                        crop_path=str(crop_path.relative_to(output_directory)),
                        crop_sha256=_sha256(crop_path),
                        raw_ocr_text=" ".join(block.text.split()),
                        context_before=_nearest_context(blocks, block_index, -1),
                        context_after=_nearest_context(blocks, block_index, 1),
                        candidate_type=FormulaCandidateType.DISPLAY_EQUATION,
                        detection_score=score,
                    )
                    cards.append(
                        FormulaReviewCard(
                            evidence=evidence,
                            explanation_draft_ko=_contextual_explanation(block.text, evidence.context_before, evidence.context_after),
                            review_status=FormulaReviewState.NEEDS_HUMAN_REVIEW,
                        )
                    )
    return tuple(cards)


def write_review_outputs(cards: tuple[FormulaReviewCard, ...], output_directory: Path) -> tuple[Path, Path]:
    """Write review-only JSON and Markdown; no card is automatically approved."""
    output_directory.mkdir(parents=True, exist_ok=True)
    json_path = output_directory / "formula_review_cards.json"
    markdown_path = output_directory / "formula_review_cards_ko.md"
    json_path.write_text(
        json.dumps([asdict(card) for card in cards], ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    markdown_path.write_text(_as_markdown(cards), encoding="utf-8")
    return json_path, markdown_path


def _sorted_blocks(page: fitz.Page) -> tuple[PdfBlock, ...]:
    """Return text blocks ordered in visual reading order."""
    blocks = tuple(
        PdfBlock(float(x0), float(y0), float(x1), float(y1), text)
        for x0, y0, x1, y1, text, *_ in page.get_text("blocks")
        if text.strip()
    )
    return tuple(sorted(blocks, key=lambda block: (block.y0, block.x0)))


def _nearest_context(blocks: tuple[PdfBlock, ...], index: int, direction: int) -> str:
    """Find the closest non-equation prose block on one side of the candidate."""
    cursor = index + direction
    while 0 <= cursor < len(blocks):
        candidate = " ".join(blocks[cursor].text.split())
        if detection_score(candidate) < MIN_DETECTION_SCORE and len(candidate) >= 30:
            return candidate[:500]
        cursor += direction
    return ""


def _save_crop(page: fitz.Page, block: PdfBlock, crop_path: Path) -> None:
    """Save a padded lossless crop that is the card's verification anchor."""
    rect = fitz.Rect(block.x0, block.y0, block.x1, block.y1)
    rect += (-CROP_PADDING, -CROP_PADDING, CROP_PADDING, CROP_PADDING)
    pixmap = page.get_pixmap(
        matrix=fitz.Matrix(RENDER_SCALE, RENDER_SCALE),
        clip=rect & page.rect,
        alpha=False,
    )
    pixmap.save(crop_path)


def _sha256(path: Path) -> str:
    """Return a stable integrity hash for a formula evidence crop."""
    digest = hashlib.sha256()
    with path.open("rb") as file:
        for chunk in iter(lambda: file.read(65_536), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _cautious_explanation(text: str) -> FormulaExplanation:
    """Preserve the heuristic explanation while explicitly requiring review."""
    draft = korean_explanation_draft(text)
    return FormulaExplanation(
        text=f"{draft.text} Source image verification is required.",
        review_state=FormulaReviewState.NEEDS_HUMAN_REVIEW,
    )


def _as_markdown(cards: tuple[FormulaReviewCard, ...]) -> str:
    """Render cards as Korean Markdown ready for later Notion import."""
    sections: list[str] = ["# Moonlight Formula Review Cards"]
    for number, card in enumerate(cards, start=1):
        evidence = card.evidence
        sections.extend(
            (
                f"\n## Formula {number} - p. {evidence.page}",
                f"- Image: `{evidence.crop_path}`",
                f"- PDF bbox: `{evidence.bbox_pdf}`",
                f"- Crop SHA-256: `{evidence.crop_sha256}`",
                f"- Raw transcription: `{evidence.raw_ocr_text}`",
                f"- Korean explanation: {card.explanation_draft_ko.text}",
                f"- Review status: `{card.review_status.value}`",
                f"- Before context: {evidence.context_before}",
                f"- After context: {evidence.context_after}",
            )
        )
    return "\n".join(sections) + "\n"





def _contextual_explanation(
    source_text: str, context_before: str, context_after: str
) -> FormulaExplanation:
    """Explain only what the formula transcription and adjacent prose support."""
    context = f"{source_text} {context_before} {context_after}".lower()
    if "common factors means" in context or "means of the common factors" in context:
        text = (
            "\ucd94\uc815 \uc124\uba85: \uacf5\ud1b5\uc694\uc778\uc758 \ud3c9\uade0\uacfc \uad00\ub828\ub41c "
            "\uc2dd\uc73c\ub85c \ubcf4\uc778\ub2e4. response shift\ub97c \ubc18\uc601\ud55c \ubaa8\ud615\uc5d0\uc11c "
            "\uc2dc\uc810 \uac04 \uc7a0\uc7ac\ud3c9\uade0 \ucc28\uc774\ub294 true change\ub97c \ud3c9\uac00\ud558\ub294 "
            "\uadfc\uac70\uac00 \ub420 \uc218 \uc788\ub2e4."
        )
    elif "covariance" in context:
        text = (
            "\ucd94\uc815 \uc124\uba85: \uad00\uce21\ubcc0\uc218 \ub610\ub294 \uc694\uc778 \uc0ac\uc774\uc758 "
            "\uacf5\ubd84\uc0b0 \uad6c\uc870\ub97c \ud45c\ud604\ud558\ub294 \uc2dd\uc73c\ub85c \ubcf4\uc778\ub2e4. "
            "\uce21\uc815\uc2dc\uc810\uc5d0 \ub530\ub978 \uacf5\ubd84\uc0b0 \uad6c\uc870 \ubcc0\ud654\ub97c \ud1b5\ud574 "
            "\uce21\uc815\ubd88\ubcc0\uc131 \uc704\ubc18\uc744 \uac80\ud1a0\ud560 \uc218 \uc788\ub2e4."
        )
    elif "intercept" in context:
        text = (
            "\ucd94\uc815 \uc124\uba85: \uc808\ud3b8 \ub610\ub294 \uc751\ub2f5 \uae30\uc900\uc758 \uc2dc\uc810 \uac04 "
            "\ubd88\ubcc0\uc131\uc744 \uac80\uc815\ud558\ub294 \ub9e5\ub77d\uc758 \uc2dd\uc73c\ub85c \ubcf4\uc778\ub2e4. "
            "\uc808\ud3b8\uc758 \ubcc0\ud654\ub294 uniform recalibration\uc758 \uadfc\uac70\uac00 \ub420 \uc218 \uc788\ub2e4."
        )
    elif "factor loadings" in context:
        text = (
            "\ucd94\uc815 \uc124\uba85: \uc694\uc778\uc801\uc7ac\ub7c9\uc758 \uc2dc\uc810 \uac04 \ubd88\ubcc0\uc131\uc744 "
            "\uac80\uc815\ud558\ub294 \ub9e5\ub77d\uc758 \uc2dd\uc73c\ub85c \ubcf4\uc778\ub2e4. \uc801\uc7ac\ub7c9\uc774 "
            "\ub2ec\ub77c\uc9c0\uba74 \ubb38\ud56d\uc758 \uc0c1\ub300\uc801 \uc911\uc694\ub3c4 \ubcc0\ud654, \uc989 "
            "reprioritization\uc744 \uac80\ud1a0\ud560 \uc218 \uc788\ub2e4."
        )
    else:
        return _cautious_explanation(source_text)
    return FormulaExplanation(
        text=f"{text} \uc6d0\ubcf8 \uc218\uc2dd \uc774\ubbf8\uc9c0\uc640 \ub300\uc870\ud558\uae30 \uc804\uc5d0\ub294 \uc778\uc6a9\ud558\uc9c0 \uc54a\ub294\ub2e4.",
        review_state=FormulaReviewState.NEEDS_HUMAN_REVIEW,
    )





