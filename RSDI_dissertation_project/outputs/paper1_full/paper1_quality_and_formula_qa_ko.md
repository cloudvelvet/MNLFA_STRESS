# Paper 1 품질·수식 보존 검증 기록

검증일: 2026-07-10

## 최종 산출물

- Markdown: `paper1_empirical_manuscript_v2_ko.md`
- Word: `paper1_empirical_manuscript_v2_ko.docx`
- HWPX: `paper1_empirical_manuscript_v2_ko.hwpx`
- HWP 5.0: `paper1_empirical_manuscript_v2_ko.hwp`

## 수식 보존 경로

1. Markdown의 10개 전개식을 LaTeX 블록으로 유지했다.
2. Pandoc이 전개식을 Word 네이티브 OMML 수식으로 변환했다.
3. 한컴오피스 2024가 DOCX를 열어 HWPX의 `EQUATION` 객체로 저장했다.
4. rhwp v0.7.17이 HWPX를 편집 가능한 HWP 5.0으로 변환했다.
5. HWP를 SVG로 렌더하여 분수, 합기호, 그리스 문자, 노름, 위첨자와 아래첨자를 시각 확인했다.

## 검증 결과

| 검사 | 결과 |
|---|---:|
| Markdown 전개식 여는/닫는 구분자 | 10 / 10 |
| 사라질 위험이 있는 인라인 LaTeX 구분자 | 0 |
| DOCX `m:oMath` 관련 태그 | 30 |
| HWPX 수식 객체 | 10 |
| HWPX 수식 스크립트 | 10 |
| HWP `Equation` 컨트롤 | 10 |
| HWP `EQEDIT` 레코드 | 10 |
| HWP 내장 그림 | 3 |
| HWP 페이지 | 21 |

인라인 OMML 수식은 DOCX→HWPX 왕복 시험에서 유실되는 현상이 확인되었다. 이를 피하기 위해 문장 안의 기호는 `μ₁`, `t₀`, `10⁻⁸`, `p₁₁ - p₀₀ = L + M + I`처럼 안전한 유니코드 또는 고정폭 텍스트로 바꾸고, 분수·합·노름처럼 조판이 필요한 수식만 전개식 객체로 유지했다.

## 인용·문서 구조

- 최종 인용 감사: PASS
- 본문 인용–참고문헌 대응: 24/24
- 고아 본문 인용: 0
- 고아 참고문헌: 0
- DOI: 21개, 모두 `https://doi.org/` 형식
- DOCX 접근성 감사: high 0, medium 0, low 0
- DOCX 표: 9개
- DOCX/HWP 그림: 3개

## 해석상 잔여 한계

문서 변환과 수식 보존은 검증되었지만, 실증결과는 여전히 앵커 없는 prior-regularized structural-state MNLFA와 평균장 변분추론에 근거한 예비 결과다. 수식이 보존되었다는 검증은 통계적 식별 또는 결과의 확증성을 보장하지 않는다.

표준 `render_docx.py`는 이 Windows 환경에 LibreOffice가 없어 실행되지 않았다. 대신 한컴오피스 2024의 실제 DOCX→HWPX 변환, HWPX/HWP 구조 감사, rhwp의 21쪽 SVG 렌더를 사용했다. rhwp SVG 렌더에서 5쪽 한 문단에 layout-overflow 경고가 있었으므로 최종 투고 전 한컴오피스에서 해당 쪽의 표·문단 나눔을 한 번 확인하는 것이 좋다. 수식 페이지의 객체와 조판은 정상적으로 확인됐다.
