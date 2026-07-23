"""Extract visually highlighted text from flattened Moonlight PDFs."""

from __future__ import annotations

import json
from dataclasses import asdict, dataclass
from enum import StrEnum
from pathlib import Path
from typing import Final

import fitz
from PIL import Image

from .text_context import expand_to_sentence, find_anchor, normalize_pdf_text

Rgb = tuple[int, int, int]

DEFAULT_RENDER_SCALE: Final = 2.0
MAX_COLOR_DISTANCE_SQUARED: Final = 1_000
MIN_HIGHLIGHT_COVERAGE: Final = 0.20
MAX_WORD_GAP: Final = 26.0
MAX_LINE_OFFSET: Final = 3.0
MAX_LINE_GAP: Final = 18.0
NON_CONTENT_MARKERS: Final = (
    "contents lists available at",
    "hhs public access",
    "author manuscript",
    "educational research review",
    "journal homepage:",
    "doi.org/",
    "www.",
)


class HighlightCategory(StrEnum):
    """User-defined meaning for the Moonlight color palette."""

    NOVELTY = "novelty"
    METHOD = "method"
    RESULT = "result"


@dataclass(frozen=True, slots=True)
class PaletteColor:
    """One target RGB color and its research role."""

    category: HighlightCategory
    rgb: Rgb


@dataclass(frozen=True, slots=True)
class HighlightPalette:
    """Configurable target colors used by the extractor."""

    colors: tuple[PaletteColor, ...]

    @classmethod
    def default(cls) -> HighlightPalette:
        """Return the RGB colors Moonlight embeds into exported PDFs."""
        return cls(
            colors=(
                PaletteColor(HighlightCategory.NOVELTY, (255, 229, 229)),
                PaletteColor(HighlightCategory.METHOD, (229, 255, 229)),
                PaletteColor(HighlightCategory.RESULT, (229, 229, 255)),
            )
        )


@dataclass(frozen=True, slots=True)
class WordBox:
    """A word and its position in PDF page coordinates."""

    text: str
    x0: float
    y0: float
    x1: float
    y1: float


@dataclass(frozen=True, slots=True)
class Passage:
    """A highlighted text span ready for JSON or Markdown output."""

    category: HighlightCategory
    page: int
    text: str
    highlight_text: str = ""


def is_readable_highlight(passage: Passage) -> bool:
    """Return whether a colored span is useful as a research highlight."""
    normalized = " ".join(passage.text.split())
    lowered = normalized.lower()
    if len(normalized.split()) < 3:
        return False
    if any(marker in lowered for marker in NON_CONTENT_MARKERS):
        return False
    return not ("/" in normalized and lowered.startswith(("10.", "1007/")))


def classify_color(rgb: Rgb, palette: HighlightPalette) -> HighlightCategory | None:
    """Return the nearest palette category when the RGB value is close enough."""
    nearest: PaletteColor | None = None
    nearest_distance = MAX_COLOR_DISTANCE_SQUARED + 1
    for palette_color in palette.colors:
        distance = sum(
            (channel - reference) ** 2
            for channel, reference in zip(rgb, palette_color.rgb, strict=True)
        )
        if distance < nearest_distance:
            nearest = palette_color
            nearest_distance = distance
    if nearest_distance <= MAX_COLOR_DISTANCE_SQUARED and nearest is not None:
        return nearest.category
    return None


def merge_words(words: tuple[WordBox, ...], category: HighlightCategory) -> tuple[Passage, ...]:
    """Merge adjacent highlighted words and wrapped lines into readable passages."""
    if not words:
        return ()
    passages: list[Passage] = []
    current_words: list[WordBox] = [words[0]]
    for word in words[1:]:
        previous = current_words[-1]
        same_line = abs(word.y0 - previous.y0) <= MAX_LINE_OFFSET
        nearby = word.x0 - previous.x1 <= MAX_WORD_GAP
        wrapped_line = (
            MAX_LINE_OFFSET < word.y0 - previous.y0 <= MAX_LINE_GAP
            and word.x0 <= previous.x0
        )
        if (same_line and nearby) or wrapped_line:
            current_words.append(word)
        else:
            passages.append(Passage(category, 0, _join_words(current_words)))
            current_words = [word]
    passages.append(Passage(category, 0, _join_words(current_words)))
    return tuple(passages)


def _join_words(words: list[WordBox]) -> str:
    """Restore a word split at a PDF line-ending hyphen."""
    text = ""
    for word in words:
        if not text:
            text = word.text
        elif text.endswith("-"):
            text = text[:-1] + word.text
        else:
            text += f" {word.text}"
    return text


def extract_passages(pdf_path: Path, palette: HighlightPalette) -> tuple[Passage, ...]:
    """Extract colored text spans from a PDF whose highlights are flattened."""
    passages: list[Passage] = []
    with fitz.open(pdf_path) as document:
        for page_number, page in enumerate(document, start=1):
            image = _render_page(page)
            for category, words in _words_by_category(page, image, palette):
                for passage in merge_words(words, category):
                    paged_passage = Passage(category, page_number, passage.text, passage.text)
                    if is_readable_highlight(paged_passage):
                        passages.append(_expand_passage(page, paged_passage))
    unique: dict[tuple[HighlightCategory, int, str], Passage] = {}
    for passage in passages:
        key = (passage.category, passage.page, passage.text.casefold())
        unique.setdefault(key, passage)
    return tuple(unique.values())


def write_outputs(passages: tuple[Passage, ...], output_directory: Path) -> tuple[Path, Path]:
    """Write reusable JSON data and a reviewable Markdown report."""
    output_directory.mkdir(parents=True, exist_ok=True)
    json_path = output_directory / "moonlight_highlights.json"
    markdown_path = output_directory / "moonlight_highlights.md"
    json_path.write_text(
        json.dumps([asdict(passage) for passage in passages], ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    markdown_path.write_text(_as_markdown(passages), encoding="utf-8")
    return json_path, markdown_path


def _expand_passage(page: fitz.Page, passage: Passage) -> Passage:
    """Recover the complete sentence containing a colored anchor."""
    source_candidates = tuple(str(block[4]) for block in page.get_text("blocks"))
    for source in (*source_candidates, str(page.get_text("text"))):
        normalized_source = normalize_pdf_text(source)
        if find_anchor(normalized_source, passage.highlight_text) is not None:
            return Passage(
                passage.category,
                passage.page,
                expand_to_sentence(normalized_source, passage.highlight_text),
                passage.highlight_text,
            )
    return passage


def _render_page(page: fitz.Page) -> Image.Image:
    pixmap = page.get_pixmap(matrix=fitz.Matrix(DEFAULT_RENDER_SCALE, DEFAULT_RENDER_SCALE), alpha=False)
    return Image.frombytes("RGB", (pixmap.width, pixmap.height), pixmap.samples)


def _words_by_category(
    page: fitz.Page, image: Image.Image, palette: HighlightPalette
) -> tuple[tuple[HighlightCategory, tuple[WordBox, ...]], ...]:
    classified: dict[HighlightCategory, list[WordBox]] = {category: [] for category in HighlightCategory}
    for raw_word in page.get_text("words"):
        word = WordBox(str(raw_word[4]), float(raw_word[0]), float(raw_word[1]), float(raw_word[2]), float(raw_word[3]))
        category = _category_for_word(word, image, palette)
        if category is not None:
            classified[category].append(word)
    return tuple((category, tuple(words)) for category, words in classified.items() if words)


def _category_for_word(word: WordBox, image: Image.Image, palette: HighlightPalette) -> HighlightCategory | None:
    """Classify a word when enough pixels behind it match a highlight color."""
    crop = image.crop(
        (
            int(word.x0 * DEFAULT_RENDER_SCALE),
            int(word.y0 * DEFAULT_RENDER_SCALE),
            int(word.x1 * DEFAULT_RENDER_SCALE),
            int(word.y1 * DEFAULT_RENDER_SCALE),
        )
    )
    pixel_count = crop.width * crop.height
    if pixel_count == 0:
        return None
    counts: dict[HighlightCategory, int] = {category: 0 for category in HighlightCategory}
    for red, green, blue in crop.getdata():
        category = classify_color((red, green, blue), palette)
        if category is not None:
            counts[category] += 1
    category, matches = max(counts.items(), key=lambda item: item[1])
    if matches / pixel_count >= MIN_HIGHLIGHT_COVERAGE:
        return category
    return None


def _as_markdown(passages: tuple[Passage, ...]) -> str:
    sections: list[str] = ["# Moonlight Highlights"]
    for category in HighlightCategory:
        sections.append(f"\n## {category.value.title()}")
        category_passages = tuple(passage for passage in passages if passage.category is category)
        if category_passages:
            for passage in category_passages:
                sections.extend(
                    (
                        f"\n### p. {passage.page}",
                        f"- Highlighted: {passage.highlight_text or passage.text}",
                        f"- Recovered sentence: {passage.text}",
                    )
                )
        else:
            sections.append("- No highlights detected.")
    return "\n".join(sections) + "\n"













