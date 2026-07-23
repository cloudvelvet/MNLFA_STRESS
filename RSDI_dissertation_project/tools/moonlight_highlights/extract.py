# /// script
# requires-python = ">=3.11"
# dependencies = ["pymupdf==1.28.0", "pillow==12.2.0", "typer==0.26.8"]
# ///
# How to run:
# python -m tools.moonlight_highlights.extract "C:\\path\\to\\moonlight-export.pdf"

"""Create highlight and formula-review outputs from a Moonlight PDF."""

from __future__ import annotations

from pathlib import Path

import typer

from tools.moonlight_highlights.formula_cards import (
    extract_review_cards,
    write_review_outputs,
)
from tools.moonlight_highlights.moonlight_extract import (
    HighlightPalette,
    extract_passages,
    write_outputs,
)


def extract(
    pdf: Path = typer.Argument(..., exists=True, file_okay=True, dir_okay=False),
    output_directory: Path = typer.Option(Path("outputs/moonlight_highlights"), "--output", "-o"),
) -> None:
    """Extract color-coded highlights and evidence-preserving formula review cards."""
    passages = extract_passages(pdf, HighlightPalette.default())
    highlights_json, highlights_markdown = write_outputs(passages, output_directory)
    formula_cards = extract_review_cards(pdf, output_directory)
    formulas_json, formulas_markdown = write_review_outputs(formula_cards, output_directory)
    typer.echo(f"Extracted {len(passages)} highlight passages.")
    typer.echo(f"Extracted {len(formula_cards)} formula candidates for human review.")
    typer.echo(f"Highlights JSON: {highlights_json}")
    typer.echo(f"Highlights Markdown: {highlights_markdown}")
    typer.echo(f"Formula cards JSON: {formulas_json}")
    typer.echo(f"Formula cards Markdown: {formulas_markdown}")


if __name__ == "__main__":
    typer.run(extract)

