from pathlib import Path
import re
import shutil

from docx import Document
from docx.oxml.ns import qn


WORK = Path(r"C:\chen_bauer_2024\docx_work")
SRC = WORK / "outline_cleanup_input.docx"
LOCAL_OUT = WORK / "outline_cleanup_final.docx"
FINAL_OUT = Path(r"N:\개인\다음논문\LLM_DIF_full_manuscript_draft_psychometric_style_Gemini범위수정_투고압축본_최종_탐색창정리.docx")


MAIN_HEADING = re.compile(r"^[1-4]\.\s+\S+")
SUB_HEADING = re.compile(r"^[1-4]\.\d+\s+\S+")


def remove_direct_outline(paragraph):
    ppr = paragraph._p.pPr
    if ppr is None:
        return
    outline = ppr.find(qn("w:outlineLvl"))
    if outline is not None:
        ppr.remove(outline)


def is_abstract_heading(text):
    return text in {"국문초록", "English Abstract"}


def is_appendix_heading(text):
    return text.startswith("부록 A.") or text.startswith("부록 B.")


def is_references_heading(text):
    return text == "References"


def is_main_heading(text):
    return bool(MAIN_HEADING.match(text)) and not bool(SUB_HEADING.match(text))


def is_sub_heading(text):
    return bool(SUB_HEADING.match(text))


def is_table_caption(text):
    return text.startswith("표 ")


doc = Document(SRC)

for paragraph in doc.paragraphs:
    text = paragraph.text.strip()
    remove_direct_outline(paragraph)

    # Fix a small typo that was visible in the navigation pane.
    if text.startswith(".3.6 "):
        paragraph.text = paragraph.text.replace(".3.6 ", "3.6 ", 1)
        text = paragraph.text.strip()

    if not text:
        paragraph.style = doc.styles["Normal"]
        continue

    if is_abstract_heading(text) or is_main_heading(text) or is_references_heading(text):
        paragraph.style = doc.styles["Heading 1"]
    elif is_sub_heading(text) or is_appendix_heading(text):
        paragraph.style = doc.styles["Heading 2"]
    elif is_table_caption(text):
        # Keep table captions out of Word's navigation pane.
        paragraph.style = doc.styles["Caption"] if "Caption" in [s.name for s in doc.styles] else doc.styles["Normal"]
    else:
        # This is the important part: paragraphs accidentally styled as Heading
        # are returned to body text so they disappear from the navigation pane.
        paragraph.style = doc.styles["Normal"]

doc.save(LOCAL_OUT)
shutil.copy2(LOCAL_OUT, FINAL_OUT)
print(LOCAL_OUT)
print(FINAL_OUT)
