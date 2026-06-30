from pathlib import Path
import re
import zipfile
import xml.etree.ElementTree as ET


DOCX = Path(r"C:\chen_bauer_2024\한국융합과학회_수정원고_교수검토용.docx")
OUT = Path(r"C:\chen_bauer_2024\한국융합과학회_text_markers.md")

NS = {"w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main"}
W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"


def text_of(node):
    return "".join(t.text or "" for t in node.findall(".//w:t", NS)).strip()


def style_of(p):
    pstyle = p.find(".//w:pStyle", NS)
    if pstyle is None:
        return ""
    return pstyle.attrib.get(W + "val", "")


def compact(s, n=260):
    s = re.sub(r"\s+", " ", s).strip()
    return s if len(s) <= n else s[: n - 1] + "…"


with zipfile.ZipFile(DOCX) as z:
    doc = ET.fromstring(z.read("word/document.xml"))

paragraphs = []
for p in doc.findall(".//w:p", NS):
    txt = text_of(p)
    if txt:
        paragraphs.append((style_of(p), txt))

patterns = {
    "분석/방법 관련": r"분석|모형|검증|screening|bootstrap|permutation|cluster|FDR|AP|P@|키워드|LLM|Gemini|DIF",
    "수정 지시/메모형 표현": r"수정|추가|삭제|보완|고쳐|넣어|빼기|필수|권고|리뷰|검토|코멘트|메모",
    "깨진 문자/placeholder": r"\?\?\?|focal \?\?|TODO|TBD|XXX",
}

lines = []
lines.append("# DOCX 본문 표식 점검")
lines.append("")
lines.append(f"- 파일: `{DOCX}`")
lines.append(f"- 본문 문단 수: {len(paragraphs)}")
lines.append("")

headings = [(st, txt) for st, txt in paragraphs if re.search(r"Heading|제목|Title", st, re.I) or re.match(r"^\d+(\.\d+)*\s+", txt)]
lines.append("## 제목/개요로 잡힐 가능성이 큰 문단")
lines.append("")
for st, txt in headings[:120]:
    lines.append(f"- `{st or 'style 없음'}` {compact(txt, 180)}")
if len(headings) > 120:
    lines.append(f"- ... {len(headings) - 120}개 추가 생략")

for label, pat in patterns.items():
    hits = [(i + 1, st, txt) for i, (st, txt) in enumerate(paragraphs) if re.search(pat, txt, re.I)]
    lines.append("")
    lines.append(f"## {label}: {len(hits)}개")
    lines.append("")
    for i, st, txt in hits[:80]:
        lines.append(f"- 문단 {i} `{st or 'style 없음'}`: {compact(txt)}")
    if len(hits) > 80:
        lines.append(f"- ... {len(hits) - 80}개 추가 생략")

OUT.write_text("\n".join(lines), encoding="utf-8")
print(str(OUT))
print(f"paragraphs={len(paragraphs)} headings={len(headings)}")
