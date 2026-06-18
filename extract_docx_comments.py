from pathlib import Path
import re
import zipfile
import xml.etree.ElementTree as ET


DOCX = Path(r"C:\chen_bauer_2024\한국융합과학회_수정원고_교수검토용.docx")
OUT = Path(r"C:\chen_bauer_2024\한국융합과학회_comments_extracted.md")

NS = {"w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main"}
W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"


def text_of(node):
    parts = []
    for t in node.findall(".//w:t", NS):
        if t.text:
            parts.append(t.text)
    return "".join(parts).strip()


def compact(s, limit=220):
    s = re.sub(r"\s+", " ", s or "").strip()
    if len(s) <= limit:
        return s
    return s[: limit - 1] + "…"


def paragraph_comment_ids(p):
    ids = set()
    for tag in ("commentRangeStart", "commentRangeEnd", "commentReference"):
        for el in p.findall(f".//w:{tag}", NS):
            cid = el.attrib.get(W + "id")
            if cid is not None:
                ids.add(cid)
    return ids


def main():
    if not DOCX.exists():
        raise FileNotFoundError(DOCX)

    with zipfile.ZipFile(DOCX) as z:
        names = set(z.namelist())
        has_comments = "word/comments.xml" in names
        doc_xml = z.read("word/document.xml")
        comments_xml = z.read("word/comments.xml") if has_comments else None

    comments = {}
    if comments_xml:
        root = ET.fromstring(comments_xml)
        for c in root.findall(".//w:comment", NS):
            cid = c.attrib.get(W + "id", "")
            comments[cid] = {
                "author": c.attrib.get(W + "author", ""),
                "date": c.attrib.get(W + "date", ""),
                "text": text_of(c),
            }

    snippets = {cid: [] for cid in comments}
    doc = ET.fromstring(doc_xml)
    for p in doc.findall(".//w:p", NS):
        ids = paragraph_comment_ids(p)
        if not ids:
            continue
        ptext = text_of(p)
        if not ptext:
            continue
        for cid in ids:
            snippets.setdefault(cid, [])
            if ptext not in snippets[cid]:
                snippets[cid].append(ptext)

    # Basic topical tags to help answer whether comments already contain analysis.
    topic_rules = {
        "방법/분석": r"분석|방법|모형|회귀|DIF|IRT|MNLFA|AP|bootstrap|permutation|FDR|표본|결측|가중치|screening|검증|통계",
        "결과/해석": r"결과|해석|논의|시사점|기여|한계|주장|과장|결론|의미",
        "문헌/이론": r"문헌|선행연구|이론|측정동일성|타당도|참고문헌|인용",
        "문장/형식": r"문장|표현|수정|삭제|추가|오탈자|제목|초록|표|각주|용어",
    }
    topic_counts = {k: 0 for k in topic_rules}
    tagged = {}
    for cid, c in comments.items():
        text = c["text"]
        tags = [name for name, pat in topic_rules.items() if re.search(pat, text, re.I)]
        tagged[cid] = tags or ["기타"]
        for t in tags:
            topic_counts[t] += 1

    lines = []
    lines.append(f"# Word 메모 추출 결과")
    lines.append("")
    lines.append(f"- 파일: `{DOCX}`")
    lines.append(f"- 메모 수: {len(comments)}")
    lines.append("")
    lines.append("## 주제별 대략 분류")
    lines.append("")
    for k, v in topic_counts.items():
        lines.append(f"- {k}: {v}개")
    if comments and all(v == 0 for v in topic_counts.values()):
        lines.append("- 주제어 기준으로는 뚜렷한 분석 메모가 잡히지 않았습니다.")

    lines.append("")
    lines.append("## 메모 목록")
    lines.append("")
    if not comments:
        lines.append("문서 안에서 `word/comments.xml` 메모를 찾지 못했습니다.")
    else:
        for cid in sorted(comments, key=lambda x: int(x) if x.isdigit() else x):
            c = comments[cid]
            anchor = " / ".join(compact(s, 160) for s in snippets.get(cid, [])[:2])
            lines.append(f"### 메모 {cid}")
            if c["author"] or c["date"]:
                lines.append(f"- 작성자/일시: {c['author']} {c['date']}".strip())
            lines.append(f"- 분류: {', '.join(tagged.get(cid, ['기타']))}")
            if anchor:
                lines.append(f"- 본문 위치: {anchor}")
            lines.append(f"- 메모 내용: {c['text']}")
            lines.append("")

    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(str(OUT))
    print(f"comments={len(comments)}")
    print(topic_counts)


if __name__ == "__main__":
    main()
