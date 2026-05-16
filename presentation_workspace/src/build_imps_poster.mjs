const {
  Presentation,
  PresentationFile,
  row,
  column,
  grid,
  panel,
  text,
  image,
  rule,
  fill,
  fixed,
  hug,
  fr,
  wrap,
} = await import("@oai/artifact-tool");
const fs = await import("node:fs");

const SLIDE_W = 3178;
const SLIDE_H = 4493;
const WORKSPACE = "presentation_workspace";
function parseCsvLine(line) {
  const cells = [];
  let cell = "";
  let quoted = false;
  for (let i = 0; i < line.length; i += 1) {
    const ch = line[i];
    if (ch === '"') {
      if (quoted && line[i + 1] === '"') {
        cell += '"';
        i += 1;
      } else {
        quoted = !quoted;
      }
    } else if (ch === "," && !quoted) {
      cells.push(cell);
      cell = "";
    } else {
      cell += ch;
    }
  }
  cells.push(cell);
  return cells;
}

function parseCsv(path) {
  const text = fs.readFileSync(path, "utf8").trim();
  const [headerLine, ...lines] = text.split(/\r?\n/);
  const headers = parseCsvLine(headerLine);
  return lines.filter(Boolean).map((line) => {
    const cells = parseCsvLine(line);
    return Object.fromEntries(headers.map((header, i) => [header, cells[i] ?? ""]));
  });
}

function fmt(value, digits = 3) {
  return Number(value).toFixed(digits);
}

function pngDataUrl(path) {
  return `data:image/png;base64,${fs.readFileSync(path).toString("base64")}`;
}
const difChart = pngDataUrl(`${WORKSPACE}/scratch/assets/discrimination_threshold_dif.png`);
const waveChart = pngDataUrl(`${WORKSPACE}/scratch/assets/wave_mean_trajectory.png`);
const simChart = pngDataUrl(`${WORKSPACE}/scratch/assets/simulated_response_shift_items.png`);
const difRows = parseCsv("poster_model_output/full/item_dif_summary.csv");
const latentRows = parseCsv("poster_model_output/full/latent_trajectory_summary.csv");
const discRows = difRows
  .filter((row) => row.parameter_type === "threshold" && row.predictor === "discrim_any")
  .sort((a, b) => Math.abs(Number(b.mean)) - Math.abs(Number(a.mean)));
if (discRows.length === 0) {
  throw new Error("Expected raw discrimination predictor 'discrim_any' in item_dif_summary.csv");
}
const keyEstimateBullets = discRows.slice(0, 5).map(
  (row) => `Item ${row.item}: ${fmt(row.mean)}, 90% interval [${fmt(row.q5)}, ${fmt(row.q95)}]`,
);
function latentMean(variable) {
  const row = latentRows.find((item) => item.variable === variable);
  if (!row) throw new Error(`Missing latent summary variable: ${variable}`);
  return Number(row.mean);
}
const latentBullets = [
  `Latent slope mean: ${fmt(latentMean("slope_mean"))}`,
  `Latent slope variance: approximately ${fmt(latentMean("slope_variance"), 6)}`,
  `Occasion-level residual SD: ${fmt(latentMean("occasion_sd"))}`,
];

const colors = {
  ink: "#111827",
  muted: "#475569",
  faint: "#E2E8F0",
  paper: "#F8FAFC",
  navy: "#0F172A",
  teal: "#0F766E",
  teal2: "#14B8A6",
  orange: "#F97316",
  white: "#FFFFFF",
};

const baseText = { fontFamily: "Aptos", color: colors.ink };

function T(value, opts = {}) {
  return text(value, {
    width: opts.width ?? fill,
    height: opts.height ?? hug,
    style: {
      ...baseText,
      fontSize: opts.size ?? 30,
      bold: opts.bold ?? false,
      color: opts.color ?? colors.ink,
      lineHeight: opts.lineHeight ?? 1.15,
    },
    name: opts.name,
  });
}

function Section(title, children, opts = {}) {
  return column(
    {
      name: opts.name ?? `section-${title}`,
      width: fill,
      height: opts.height ?? hug,
      gap: 18,
      padding: { x: 0, y: 0 },
    },
    [
      panel(
        {
          name: `${opts.name ?? title}-title-band`,
          width: fill,
          height: fixed(56),
          background: colors.teal,
          padding: { x: 18, y: 10 },
        },
        T(title, { size: 25, bold: true, color: colors.white }),
      ),
      ...children,
    ],
  );
}

function Bullets(items, opts = {}) {
  return column(
    { width: fill, height: hug, gap: opts.gap ?? 10 },
    items.map((item, i) =>
      T(`${opts.marker ?? "•"} ${item}`, {
        size: opts.size ?? 26,
        color: opts.color ?? colors.ink,
        name: `${opts.name ?? "bullet"}-${i + 1}`,
      }),
    ),
  );
}

const presentation = Presentation.create({
  slideSize: { width: SLIDE_W, height: SLIDE_H },
});

const slide = presentation.slides.add();

slide.compose(
  column(
    {
      name: "poster-root",
      width: fill,
      height: fill,
      gap: 40,
      padding: { x: 96, y: 78 },
      background: colors.paper,
    },
    [
      panel(
        {
          name: "header",
          width: fill,
          height: fixed(430),
          background: colors.navy,
          padding: { x: 64, y: 50 },
        },
        column(
          { width: fill, height: fill, gap: 24 },
          [
            T("Distinguishing Latent Change from Measurement-Function Change in Migrant-Family Panel Data", {
              name: "poster-title",
              size: 64,
              bold: true,
              color: colors.white,
              lineHeight: 1.05,
            }),
            T("A Bayesian longitudinal MNLFA with time-varying covariate DIF", {
              name: "poster-subtitle",
              size: 34,
              color: "#BFEFEA",
            }),
            row(
              { width: fill, height: hug },
              [
                T("Changhyeon Lee | Ajou University | changhyeon@ajou.ac.kr", {
                  name: "author",
                  size: 26,
                  color: "#E5E7EB",
                  width: fill,
                }),
                T("IMPS poster draft | MAPS parent panel waves 1-5", {
                  name: "context",
                  size: 24,
                  color: "#E5E7EB",
                  width: wrap(620),
                }),
              ],
            ),
          ],
        ),
      ),
      grid(
        {
          name: "content-grid",
          width: fill,
          height: fixed(3770),
          columns: [fr(1), fr(1), fr(1)],
          columnGap: 52,
        },
        [
          column(
            { name: "left-col", width: fill, height: fill, gap: 38 },
            [
              Section("BACKGROUND AND RESEARCH QUESTION", [
                T("Longitudinal growth models often assume that repeated item responses are comparable across time.", { size: 27 }),
                T("In migrant-family panel data, Korean proficiency, SES, parent age, and discrimination experience can change rapidly.", { size: 27 }),
                T("If these covariates shift item thresholds or loadings, observed score change may mix true latent change with measurement-function change.", { size: 27 }),
                T("Research question: Can longitudinal MNLFA recover latent trajectories while accounting for time-varying discrimination DIF?", { size: 28, bold: true, color: colors.teal }),
              ], { name: "background" }),
              Section("DATA AND PREPROCESSING", [
                Bullets([
                  "MAPS 2nd cohort parent panel, waves 1-5",
                  "8 ordinal acculturative-stress items, scored 1-5",
                  "77,160 item-level observations after dropping 136 rows with missing DIF predictors",
                  "DIF predictors: parent age (wave-centered), Korean proficiency, log household income, discrimination experience (0/1)",
                ], { size: 26, name: "data" }),
              ], { name: "data-prep" }),
              Section("MODEL", [
                T("Measurement model", { size: 27, bold: true, color: colors.teal }),
                T("P(Y_itj = k) = ordered-logit(tau_jk - [lambda_itj eta_it])", { size: 24, color: colors.muted }),
                T("DIF model", { size: 27, bold: true, color: colors.teal }),
                T("log(lambda_itj) = lambda_0j + X_it b_lambda,j", { size: 24, color: colors.muted }),
                T("tau_itjk = tau_jk + X_it b_tau,j", { size: 24, color: colors.muted }),
                T("Growth model", { size: 27, bold: true, color: colors.teal }),
                T("eta_it = eta_0i + eta_1i Time_t + zeta_it", { size: 24, color: colors.muted }),
              ], { name: "model" }),
              Section("ESTIMATION", [
                Bullets([
                  "Primary estimates: mean-field variational inference in CmdStanR",
                  "Full-data NUTS is computationally heavy for the person-level latent growth model",
                  "No full-data NUTS confirmation is claimed in this draft",
                  "Interpret as approximate, direction-focused Bayesian posterior summaries",
                ], { size: 25, name: "estimation" }),
              ], { name: "estimation-section" }),
            ],
          ),
          column(
            { name: "middle-col", width: fill, height: fill, gap: 36 },
            [
              Section("MAIN RESULT: DISCRIMINATION THRESHOLD DIF", [
                T("Negative threshold DIF is a raw 0/1 contrast: parents reporting discrimination versus those not reporting it. At the same latent stress level, higher response categories become more likely.", { size: 27 }),
                image({
                  name: "dif-chart",
                  dataUrl: difChart,
                  width: fill,
                  height: fixed(720),
                  fit: "contain",
                  alt: "Bar chart of discrimination-related threshold DIF estimates",
                }),
              ], { name: "main-result" }),
              Section("KEY ESTIMATES", [
                Bullets(keyEstimateBullets, { size: 25, name: "key-estimates" }),
                T("Item 6 interpretation: the anger item is more easily endorsed by parents who report discrimination, conditional on the same latent stress level.", { size: 27, bold: true, color: colors.teal }),
              ], { name: "key-estimates-section" }),
              Section("LATENT TRAJECTORY", [
                Bullets(latentBullets, { size: 25, name: "latent" }),
                T("The approximate fit suggests modest latent decline while item functioning changes substantially by discrimination experience.", { size: 27 }),
                image({
                  name: "wave-chart",
                  dataUrl: waveChart,
                  width: fill,
                  height: fixed(610),
                  fit: "contain",
                  alt: "Wave mean response trajectory comparing observed and simulated conditions",
                }),
              ], { name: "latent-section" }),
            ],
          ),
          column(
            { name: "right-col", width: fill, height: fill, gap: 38 },
            [
              Section("SIMULATION: WHAT DIF CAN DO", [
                T("Simulation compared observed responses with generated data under no DIF, discrimination DIF only, and full DIF.", { size: 27 }),
                image({
                  name: "simulation-chart",
                  dataUrl: simChart,
                  width: fill,
                  height: fixed(660),
                  fit: "contain",
                  alt: "Simulated threshold-DIF effect for Items 2, 6, and 7",
                }),
                T("Discrimination-related threshold shifts can alter observed response distributions even when latent growth is held fixed.", { size: 27, bold: true, color: colors.teal }),
              ], { name: "simulation-section" }),
              Section("PSYCHOMETRIC IMPLICATIONS", [
                Bullets([
                  "Observed score differences may overstate true latent differences when item thresholds shift.",
                  "Scalar invariance is not a minor technical detail; it changes how growth is interpreted.",
                  "Longitudinal MNLFA helps distinguish latent change from measurement-function change.",
                ], { size: 26, name: "implications" }),
              ], { name: "implications-section" }),
              Section("CONTRIBUTION", [
                T("Building on prior MAPS analysis showing discrimination-related DIF in acculturative-stress items, this study extends the framework longitudinally.", { size: 27 }),
                T("The contribution is not only detecting DIF, but showing how DIF changes the interpretation of latent trajectories.", { size: 28, bold: true, color: colors.teal }),
              ], { name: "contribution-section" }),
              Section("SELECTED REFERENCES", [
                Bullets([
                  "Bauer (2017). Psychological Methods. MNLFA for MI/DIF.",
                  "Bauer, Belzak, & Cole (2020). Regularized MNLFA for multiple covariates.",
                  "Chen & Bauer (2024). Longitudinal moderated factor analysis.",
                  "Kim & Willson (2014). Measurement noninvariance biases growth estimates.",
                  "King-Kallimanis et al. (2010). Response shift as longitudinal measurement bias.",
                  "Widaman, Ferrer, & Conger (2010). Longitudinal factorial invariance.",
                ], { size: 22, name: "refs" }),
              ], { name: "refs-section" }),
            ],
          ),
        ],
      ),
      T("Note: Main empirical results are VI-based approximate posterior summaries; full-data NUTS confirmation is future work.", {
        name: "footer-note",
        size: 19,
        color: colors.muted,
      }),
    ],
  ),
  {
    frame: { left: 0, top: 0, width: SLIDE_W, height: SLIDE_H },
    baseUnit: 8,
  },
);

const pptxBlob = await PresentationFile.exportPptx(presentation);
await pptxBlob.save(`${WORKSPACE}/output/output.pptx`);
console.log(`Wrote ${WORKSPACE}/output/output.pptx`);
