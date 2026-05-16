options(stringsAsFactors = FALSE)

emu <- function(inches) as.integer(round(inches * 914400))
xml_escape <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x <- gsub('"', "&quot;", x, fixed = TRUE)
  x
}

root <- normalizePath(".", winslash = "/", mustWork = TRUE)
out_dir <- file.path(root, "imps_poster_output")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
asset_dir <- file.path(out_dir, "assets")
dir.create(asset_dir, recursive = TRUE, showWarnings = FALSE)

dif <- read.csv(file.path(root, "poster_model_output/full/item_dif_summary.csv"))
latent <- read.csv(file.path(root, "poster_model_output/full/latent_trajectory_summary.csv"))
sim_item <- read.csv(file.path(root, "simulation_parent_discrim_output/observed_vs_simulated_by_discrim_item.csv"))
wave <- read.csv(file.path(root, "simulation_parent_discrim_output/observed_vs_simulated_mean_by_wave.csv"))

if (!"discrim_any" %in% dif$predictor) {
  stop("Expected raw discrimination predictor 'discrim_any' in item_dif_summary.csv")
}
fmt <- function(x, digits = 3) sprintf(paste0("%.", digits, "f"), as.numeric(x))
latent_mean <- function(variable) {
  value <- latent$mean[latent$variable == variable]
  if (length(value) != 1) stop("Missing latent summary variable: ", variable)
  as.numeric(value)
}

disc <- dif[dif$parameter_type == "threshold" & dif$predictor == "discrim_any", ]
disc <- disc[order(disc$mean), ]
disc$label <- paste0("Item ", disc$item)
disc_top <- disc[order(abs(disc$mean), decreasing = TRUE), ]
disc_top <- head(disc_top, 5)
key_estimate_body <- c(
  "Largest discrimination-related threshold DIF effects:",
  paste0(
    "- Item ", disc_top$item, ": ", fmt(disc_top$mean),
    ", 90% interval [", fmt(disc_top$q5), ", ", fmt(disc_top$q95), "]"
  ),
  "",
  "Item 6 interpretation:",
  "The anger item is more easily endorsed by parents who report discrimination, conditional on the same latent stress level."
)
latent_body <- c(
  "Full-data VI estimates:",
  paste0("- Latent slope mean: ", fmt(latent_mean("slope_mean"))),
  paste0("- Latent slope variance: approx. ", fmt(latent_mean("slope_variance"), 6)),
  paste0("- Occasion-level residual SD: ", fmt(latent_mean("occasion_sd"))),
  "",
  "Substantive read:",
  "The approximate fit suggests modest latent decline while item functioning changes substantially by discrimination experience."
)

png(file.path(asset_dir, "discrimination_threshold_dif.png"), width = 1900, height = 1200, res = 200)
op <- par(mar = c(5.5, 6.0, 1.0, 1.0), family = "sans")
cols <- ifelse(disc$q95 < 0, "#0F766E", "#8A8F98")
bp <- barplot(
  disc$mean,
  names.arg = disc$label,
  horiz = TRUE,
  las = 1,
  col = cols,
  border = NA,
  xlim = c(min(disc$q5) - 0.05, max(0.08, max(disc$q95) + 0.02)),
  xlab = "Discrimination threshold DIF estimate (raw 0/1 contrast; VI mean, 90% interval)",
  cex.names = 0.95,
  cex.lab = 0.95
)
arrows(disc$q5, bp, disc$q95, bp, angle = 90, code = 3, length = 0.04, lwd = 1.4, col = "#263238")
abline(v = 0, lty = 2, col = "#64748B")
text(disc$mean / 2, bp, sprintf("%.2f", disc$mean), cex = 0.85, col = "white", font = 2)
par(op)
dev.off()

plot_sim <- sim_item[sim_item$item %in% c(2, 6, 7) & sim_item$discrim_any == 1 &
                       sim_item$condition %in% c("observed", "no_dif", "discrim_dif", "full_dif"), ]
plot_sim$condition <- factor(plot_sim$condition, levels = c("observed", "no_dif", "discrim_dif", "full_dif"))
png(file.path(asset_dir, "simulated_response_shift_items.png"), width = 1900, height = 1200, res = 200)
op <- par(mar = c(5.8, 5.5, 1.0, 0.8), family = "sans")
mat <- tapply(plot_sim$resp, list(plot_sim$condition, paste0("Item ", plot_sim$item)), mean)
barplot(
  mat,
  beside = TRUE,
  col = c("#334155", "#CBD5E1", "#14B8A6", "#F97316"),
  border = NA,
  ylim = c(0, 4.4),
  ylab = "Mean response among discrimination-experienced parents",
  legend.text = c("Observed", "No DIF sim.", "Discrim DIF sim.", "Full DIF sim."),
  args.legend = list(x = "topleft", bty = "n", cex = 0.82),
  cex.names = 1.0
)
grid(nx = NA, ny = NULL, col = "#E2E8F0")
par(op)
dev.off()

png(file.path(asset_dir, "wave_mean_trajectory.png"), width = 1900, height = 1100, res = 200)
op <- par(mar = c(5.0, 5.2, 1.0, 1.0), family = "sans")
conds <- c("observed", "no_dif", "discrim_dif", "full_dif")
cols <- c("#111827", "#94A3B8", "#14B8A6", "#F97316")
plot(NA, xlim = c(1, 5), ylim = range(wave$resp) + c(-0.05, 0.05),
     xlab = "Wave", ylab = "Mean item response")
grid(col = "#E2E8F0")
for (i in seq_along(conds)) {
  d <- wave[wave$condition == conds[i], ]
  lines(d$time, d$resp, type = "b", lwd = 2.6, pch = 16, col = cols[i])
}
legend("topright", legend = c("Observed", "No DIF sim.", "Discrim DIF sim.", "Full DIF sim."),
       col = cols, lwd = 2.6, pch = 16, bty = "n", cex = 0.85)
par(op)
dev.off()

slide_w <- 33.1
slide_h <- 46.8

shape_id <- 1
next_id <- function() {
  shape_id <<- shape_id + 1
  shape_id
}

solid_rect <- function(x, y, w, h, fill, line = fill, alpha = NULL) {
  id <- next_id()
  alpha_xml <- if (is.null(alpha)) "" else sprintf("<a:alpha val=\"%s\"/>", as.integer(alpha * 100000))
  sprintf(
    '<p:sp><p:nvSpPr><p:cNvPr id="%d" name="Rect %d"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x="%d" y="%d"/><a:ext cx="%d" cy="%d"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:solidFill><a:srgbClr val="%s">%s</a:srgbClr></a:solidFill><a:ln><a:solidFill><a:srgbClr val="%s"/></a:solidFill></a:ln></p:spPr><p:txBody><a:bodyPr/><a:lstStyle/><a:p/></p:txBody></p:sp>',
    id, id, emu(x), emu(y), emu(w), emu(h), fill, alpha_xml, line
  )
}

text_box <- function(x, y, w, h, lines, size = 20, color = "111827",
                     bold = FALSE, align = "l", name = "Text", spacing = 1.0) {
  id <- next_id()
  b <- if (bold) " b=\"1\"" else ""
  paras <- vapply(lines, function(line) {
    sprintf(
      '<a:p><a:pPr algn="%s"/><a:r><a:rPr lang="en-US" sz="%d"%s><a:solidFill><a:srgbClr val="%s"/></a:solidFill><a:latin typeface="Aptos"/></a:rPr><a:t>%s</a:t></a:r></a:p>',
      align, as.integer(size * 100), b, color, xml_escape(line)
    )
  }, character(1))
  sprintf(
    '<p:sp><p:nvSpPr><p:cNvPr id="%d" name="%s"/><p:cNvSpPr txBox="1"/><p:nvPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x="%d" y="%d"/><a:ext cx="%d" cy="%d"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/><a:ln><a:noFill/></a:ln></p:spPr><p:txBody><a:bodyPr wrap="square" lIns="0" tIns="0" rIns="0" bIns="0"><a:spAutoFit/></a:bodyPr><a:lstStyle/>%s</p:txBody></p:sp>',
    id, xml_escape(name), emu(x), emu(y), emu(w), emu(h), paste0(paras, collapse = "")
  )
}

image_box <- function(x, y, w, h, rid, name) {
  id <- next_id()
  sprintf(
    '<p:pic><p:nvPicPr><p:cNvPr id="%d" name="%s"/><p:cNvPicPr/><p:nvPr/></p:nvPicPr><p:blipFill><a:blip r:embed="%s"/><a:stretch><a:fillRect/></a:stretch></p:blipFill><p:spPr><a:xfrm><a:off x="%d" y="%d"/><a:ext cx="%d" cy="%d"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom></p:spPr></p:pic>',
    id, xml_escape(name), rid, emu(x), emu(y), emu(w), emu(h)
  )
}

section <- function(x, y, w, title, body, h_body, title_fill = "0F766E") {
  c(
    solid_rect(x, y, w, 0.48, title_fill, title_fill),
    text_box(x + 0.18, y + 0.08, w - 0.36, 0.34, title, size = 16, color = "FFFFFF", bold = TRUE),
    text_box(x, y + 0.64, w, h_body, body, size = 13, color = "111827")
  )
}

left <- 0.85
top <- 6.25
gutter <- 0.4
col_w <- (slide_w - 2 * left - 2 * gutter) / 3
x1 <- left
x2 <- left + col_w + gutter
x3 <- left + 2 * (col_w + gutter)

slide_parts <- c(
  solid_rect(0, 0, slide_w, 5.45, "0F172A", "0F172A"),
  solid_rect(0, 5.45, slide_w, 0.12, "14B8A6", "14B8A6"),
  text_box(0.85, 0.55, 31.4, 2.0,
           c("Distinguishing Latent Change from Measurement-Function Change in Migrant-Family Panel Data"),
           size = 31, color = "FFFFFF", bold = TRUE, name = "Title"),
  text_box(0.9, 2.75, 22.5, 0.8,
           c("A Bayesian longitudinal MNLFA with time-varying covariate DIF"),
           size = 18, color = "BFEFEA", name = "Subtitle"),
  text_box(0.9, 3.75, 21.0, 0.8,
           c("Changhyeon Lee | Ajou University | changhyeon@ajou.ac.kr"),
           size = 14, color = "E5E7EB", name = "Author"),
  text_box(24.2, 3.45, 8.0, 1.0,
           c("IMPS poster draft | MAPS parent panel waves 1-5"),
           size = 13, color = "E5E7EB", align = "r", name = "Context"),
  section(x1, top, col_w, "BACKGROUND AND RESEARCH QUESTION", c(
    "Longitudinal growth models often assume that repeated item responses are comparable across time.",
    "In migrant-family panel data, key covariates can change rapidly: Korean proficiency, socioeconomic status, parent age, and discrimination experience.",
    "If these covariates shift item thresholds or loadings, observed score change may reflect both true latent change and measurement-function change.",
    "",
    "Research question: Can longitudinal MNLFA recover latent trajectories while accounting for time-varying DIF linked to discrimination?"
  ), 4.45),
  section(x1, 11.55, col_w, "DATA AND PREPROCESSING", c(
    "Data: MAPS 2nd cohort parent panel, waves 1-5.",
    "Outcome: 8 ordinal acculturative-stress items, scored 1-5.",
    "Analytic file: 77,160 item-level observations after dropping 136 rows with missing DIF predictors.",
    "Time-varying DIF predictors:",
    "- Parent age, centered within wave",
    "- Korean proficiency",
    "- Log household income",
    "- Discrimination experience"
  ), 5.0),
  section(x1, 17.65, col_w, "MODEL", c(
    "Measurement model:",
    "P(Y_itj = k) = ordered-logit(tau_jk - [lambda_itj eta_it])",
    "",
    "DIF model:",
    "log(lambda_itj) = lambda_0j + X_it b_lambda,j",
    "tau_itjk = tau_jk + X_it b_tau,j",
    "",
    "Structural growth model:",
    "eta_it = eta_0i + eta_1i Time_t + zeta_it",
    "",
    "Identification used soft priors on loadings, thresholds, and latent growth variation."
  ), 6.1),
  section(x1, 25.15, col_w, "ESTIMATION", c(
    "Primary empirical estimates:",
    "Mean-field variational inference in CmdStanR.",
    "",
    "Reason:",
    "Full NUTS for the complete person-level latent growth model is computationally expensive on the local machine.",
    "",
    "Current status:",
    "No full-data NUTS confirmation is claimed in this poster draft.",
    "",
    "Interpretation:",
    "Approximate Bayesian posterior summaries, not final full-NUTS posterior estimates."
  ), 6.6),
  section(x2, top, col_w, "MAIN RESULT: DISCRIMINATION THRESHOLD DIF", c(
    "Negative threshold DIF is a raw 0/1 contrast: parents reporting discrimination experiences versus those not reporting them.",
    "At the same latent acculturative-stress level, these parents are more likely to endorse higher response categories."
  ), 1.55),
  image_box(x2, 9.1, col_w, 6.1, "rId2", "Discrimination threshold DIF chart"),
  section(x2, 15.85, col_w, "KEY ESTIMATES", key_estimate_body, 6.7),
  section(x2, 24.0, col_w, "LATENT TRAJECTORY", latent_body, 4.9),
  image_box(x2, 30.25, col_w, 5.9, "rId3", "Wave mean trajectory chart"),
  section(x3, top, col_w, "SIMULATION: WHAT DIF CAN DO", c(
    "Simulation conditions compared observed responses with data generated under:",
    "- No DIF",
    "- Discrimination DIF only",
    "- Full DIF",
    "",
    "The simulation shows how discrimination-related threshold shifts can alter observed response distributions even when latent growth is held fixed."
  ), 4.1),
  image_box(x3, 11.05, col_w, 6.1, "rId4", "Simulated threshold-DIF chart"),
  section(x3, 18.0, col_w, "PSYCHOMETRIC IMPLICATIONS", c(
    "1. Observed score differences may overstate true latent differences when item thresholds shift by discrimination experience.",
    "2. Scalar invariance is not a minor technical detail; it changes how growth is interpreted.",
    "3. Longitudinal MNLFA helps distinguish latent change from measurement-function change in migrant-family research."
  ), 4.6),
  section(x3, 23.7, col_w, "CONTRIBUTION", c(
    "Building on prior MAPS analysis showing discrimination-related DIF in acculturative-stress items, this study extends the framework longitudinally.",
    "",
    "The contribution is not only detecting DIF, but showing how DIF changes the interpretation of latent trajectories."
  ), 3.8),
  section(x3, 28.75, col_w, "SELECTED REFERENCES", c(
    "Bauer (2017). Psychological Methods. MNLFA for MI/DIF.",
    "Bauer, Belzak, & Cole (2020). Regularized MNLFA for multiple covariates.",
    "Chen & Bauer (2024). Longitudinal moderated factor analysis.",
    "Kim & Willson (2014). Measurement noninvariance biases growth estimates.",
    "King-Kallimanis et al. (2010). Response shift as longitudinal measurement bias.",
    "Widaman, Ferrer, & Conger (2010). Longitudinal factorial invariance."
  ), 5.2),
  text_box(0.85, 45.7, 31.4, 0.4,
           c("Note: Main empirical results are VI-based approximate posterior summaries; full-data NUTS confirmation is future work."),
           size = 10.5, color = "475569", name = "Footer")
)

slide_xml <- paste0(
  '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
  '<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">',
  '<p:cSld><p:spTree>',
  '<p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>',
  '<p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>',
  paste0(slide_parts, collapse = ""),
  '</p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sld>'
)

pkg <- file.path(out_dir, "pptx_pkg")
if (dir.exists(pkg)) unlink(pkg, recursive = TRUE)
dirs <- c(
  "_rels", "docProps", "ppt", "ppt/_rels", "ppt/slides", "ppt/slides/_rels",
  "ppt/media", "ppt/slideMasters", "ppt/slideMasters/_rels",
  "ppt/slideLayouts", "ppt/slideLayouts/_rels", "ppt/theme"
)
for (d in dirs) dir.create(file.path(pkg, d), recursive = TRUE, showWarnings = FALSE)

writeLines('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Default Extension="png" ContentType="image/png"/>
<Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
<Override PartName="/ppt/presentation.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>
<Override PartName="/ppt/slides/slide1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>
<Override PartName="/ppt/slideMasters/slideMaster1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/>
<Override PartName="/ppt/slideLayouts/slideLayout1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/>
<Override PartName="/ppt/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>
</Types>', file.path(pkg, "[Content_Types].xml"), useBytes = TRUE)

writeLines('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>', file.path(pkg, "_rels/.rels"), useBytes = TRUE)

writeLines('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
<Application>R OpenXML</Application><PresentationFormat>A0 portrait</PresentationFormat><Slides>1</Slides><Company>Ajou University</Company></Properties>',
file.path(pkg, "docProps/app.xml"), useBytes = TRUE)

writeLines(sprintf('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<dc:title>IMPS Poster Draft - Longitudinal MNLFA</dc:title><dc:creator>Changhyeon Lee</dc:creator><cp:lastModifiedBy>Codex</cp:lastModifiedBy><dcterms:created xsi:type="dcterms:W3CDTF">%s</dcterms:created><dcterms:modified xsi:type="dcterms:W3CDTF">%s</dcterms:modified></cp:coreProperties>',
format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ"), format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ")),
file.path(pkg, "docProps/core.xml"), useBytes = TRUE)

writeLines(sprintf('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:presentation xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
<p:sldMasterIdLst><p:sldMasterId id="2147483648" r:id="rId1"/></p:sldMasterIdLst>
<p:sldIdLst><p:sldId id="256" r:id="rId2"/></p:sldIdLst>
<p:sldSz cx="%d" cy="%d" type="custom"/>
<p:notesSz cx="6858000" cy="9144000"/>
</p:presentation>', emu(slide_w), emu(slide_h)), file.path(pkg, "ppt/presentation.xml"), useBytes = TRUE)

writeLines('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="slideMasters/slideMaster1.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide1.xml"/>
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>
</Relationships>', file.path(pkg, "ppt/_rels/presentation.xml.rels"), useBytes = TRUE)

writeLines('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld><p:sldLayoutIdLst><p:sldLayoutId id="2147483649" r:id="rId1"/></p:sldLayoutIdLst><p:clrMap bg1="lt1" tx1="dk1" bg2="lt2" tx2="dk2" accent1="accent1" accent2="accent2" accent3="accent3" accent4="accent4" accent5="accent5" accent6="accent6" hlink="hlink" folHlink="folHlink"/></p:sldMaster>',
file.path(pkg, "ppt/slideMasters/slideMaster1.xml"), useBytes = TRUE)

writeLines('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/></Relationships>',
file.path(pkg, "ppt/slideMasters/_rels/slideMaster1.xml.rels"), useBytes = TRUE)

writeLines('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldLayout xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" type="blank" preserve="1"><p:cSld name="Blank"><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sldLayout>',
file.path(pkg, "ppt/slideLayouts/slideLayout1.xml"), useBytes = TRUE)

writeLines('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="../slideMasters/slideMaster1.xml"/></Relationships>',
file.path(pkg, "ppt/slideLayouts/_rels/slideLayout1.xml.rels"), useBytes = TRUE)

writeLines('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="IMPS Poster"><a:themeElements><a:clrScheme name="IMPS"><a:dk1><a:srgbClr val="111827"/></a:dk1><a:lt1><a:srgbClr val="FFFFFF"/></a:lt1><a:dk2><a:srgbClr val="0F172A"/></a:dk2><a:lt2><a:srgbClr val="F8FAFC"/></a:lt2><a:accent1><a:srgbClr val="0F766E"/></a:accent1><a:accent2><a:srgbClr val="F97316"/></a:accent2><a:accent3><a:srgbClr val="334155"/></a:accent3><a:accent4><a:srgbClr val="14B8A6"/></a:accent4><a:accent5><a:srgbClr val="94A3B8"/></a:accent5><a:accent6><a:srgbClr val="111827"/></a:accent6><a:hlink><a:srgbClr val="0F766E"/></a:hlink><a:folHlink><a:srgbClr val="334155"/></a:folHlink></a:clrScheme><a:fontScheme name="Aptos"><a:majorFont><a:latin typeface="Aptos Display"/></a:majorFont><a:minorFont><a:latin typeface="Aptos"/></a:minorFont></a:fontScheme><a:fmtScheme name="Clean"><a:fillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:fillStyleLst><a:lnStyleLst><a:ln w="9525"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln></a:lnStyleLst><a:effectStyleLst><a:effectStyle><a:effectLst/></a:effectStyle></a:effectStyleLst><a:bgFillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:bgFillStyleLst></a:fmtScheme></a:themeElements><a:objectDefaults/><a:extraClrSchemeLst/></a:theme>',
file.path(pkg, "ppt/theme/theme1.xml"), useBytes = TRUE)

writeLines(slide_xml, file.path(pkg, "ppt/slides/slide1.xml"), useBytes = TRUE)
writeLines('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="../media/discrimination_threshold_dif.png"/>
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="../media/wave_mean_trajectory.png"/>
<Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="../media/simulated_response_shift_items.png"/>
</Relationships>', file.path(pkg, "ppt/slides/_rels/slide1.xml.rels"), useBytes = TRUE)

file.copy(file.path(asset_dir, "discrimination_threshold_dif.png"), file.path(pkg, "ppt/media/discrimination_threshold_dif.png"), overwrite = TRUE)
file.copy(file.path(asset_dir, "wave_mean_trajectory.png"), file.path(pkg, "ppt/media/wave_mean_trajectory.png"), overwrite = TRUE)
file.copy(file.path(asset_dir, "simulated_response_shift_items.png"), file.path(pkg, "ppt/media/simulated_response_shift_items.png"), overwrite = TRUE)

old <- setwd(pkg)
on.exit(setwd(old), add = TRUE)
pptx_path <- file.path(out_dir, "imps_mnlfa_discrimination_poster_A0_portrait.pptx")
if (file.exists(pptx_path)) unlink(pptx_path)
utils::zip(zipfile = pptx_path, files = list.files(".", recursive = TRUE, all.files = TRUE, no.. = TRUE))

cat("Wrote:", pptx_path, "\n")
cat("Assets:", asset_dir, "\n")
