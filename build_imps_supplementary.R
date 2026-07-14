options(stringsAsFactors = FALSE)

input_dir <- file.path("poster_model_output", "no_wave_dif_full_vi_4seed")
output_dir <- file.path("supplementary", "imps2026")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

qr_target <- "https://github.com/cloudvelvet/MNLFA_STRESS/tree/main/supplementary/imps2026"

item_labels <- c(
  "Different treatment",
  "Perceived prejudice",
  "Homesickness",
  "Unfamiliar environment",
  "Missing birthplace/people",
  "Anger at disregard",
  "Withdrawal",
  "Low social status"
)

dif <- read.csv(file.path(input_dir, "item_dif_summary.csv"), check.names = FALSE)
slope <- read.csv(file.path(input_dir, "latent_slope_summary.csv"), check.names = FALSE)
stability <- read.csv(file.path(input_dir, "vi_seed_stability.csv"), check.names = FALSE)
cf <- read.csv(file.path(input_dir, "counterfactual_expected_response_eta0.csv"), check.names = FALSE)

table_s1 <- data.frame(
  Item = dif$item,
  `Item content` = item_labels[dif$item],
  `Threshold DIF mean` = round(dif$mean, 3),
  `90% lower` = round(dif$q5, 3),
  `90% upper` = round(dif$q95, 3),
  `Seed mean minimum` = round(dif$seed_mean_min, 3),
  `Seed mean maximum` = round(dif$seed_mean_max, 3),
  `All seed means negative` = dif$all_seed_means_negative,
  check.names = FALSE
)

pooled <- data.frame(
  Estimate = "Pooled posterior slope mean",
  Seed = NA_integer_,
  `Slope mean` = round(slope$mean[1], 3),
  `90% lower` = round(slope$q5[1], 3),
  `90% upper` = round(slope$q95[1], 3),
  `Growth intercept SD` = NA_real_,
  `Growth slope SD` = NA_real_,
  `Occasion SD` = NA_real_,
  check.names = FALSE
)
seed_rows <- data.frame(
  Estimate = "VI seed",
  Seed = stability$seed,
  `Slope mean` = round(stability$slope_mean, 3),
  `90% lower` = NA_real_,
  `90% upper` = NA_real_,
  `Growth intercept SD` = round(stability$growth_sd_intercept, 3),
  `Growth slope SD` = round(stability$growth_sd_slope, 3),
  `Occasion SD` = round(stability$occasion_sd, 3),
  check.names = FALSE
)
table_s2 <- rbind(pooled, seed_rows)

cf0 <- cf[cf$discrim_any == 0, ]
cf1 <- cf[cf$discrim_any == 1, ]
cf0 <- cf0[match(cf1$item, cf0$item), ]
table_s3 <- data.frame(
  Item = cf1$item,
  `Item content` = cf1$item_label,
  `No discrimination mean` = round(cf0$mean, 3),
  `No discrimination 90% lower` = round(cf0$q5, 3),
  `No discrimination 90% upper` = round(cf0$q95, 3),
  `Discrimination mean` = round(cf1$mean, 3),
  `Discrimination 90% lower` = round(cf1$q5, 3),
  `Discrimination 90% upper` = round(cf1$q95, 3),
  `Mean contrast` = round(cf1$mean - cf0$mean, 3),
  check.names = FALSE
)

write.csv(table_s1, file.path(output_dir, "table_s1_discrimination_threshold_dif.csv"), row.names = FALSE, na = "")
write.csv(table_s2, file.path(output_dir, "table_s2_latent_slope_and_vi_stability.csv"), row.names = FALSE, na = "")
write.csv(table_s3, file.path(output_dir, "table_s3_counterfactual_expected_response_eta0.csv"), row.names = FALSE, na = "")
writeLines(qr_target, file.path(output_dir, "qr_target.txt"), useBytes = TRUE)

markdown_table <- function(x) {
  values <- lapply(x, function(col) {
    col <- ifelse(is.na(col), "", as.character(col))
    gsub("|", "\\|", col, fixed = TRUE)
  })
  x <- as.data.frame(values, stringsAsFactors = FALSE, check.names = FALSE)
  header <- paste0("| ", paste(names(x), collapse = " | "), " |")
  divider <- paste0("| ", paste(rep("---", ncol(x)), collapse = " | "), " |")
  rows <- apply(x, 1, function(row) paste0("| ", paste(row, collapse = " | "), " |"))
  paste(c(header, divider, rows), collapse = "\n")
}

readme <- paste0(
  "# IMPS 2026 supplementary tables\n\n",
  "**Poster:** Acculturative Stress Change and Covariate DIF: a Bayesian MNLFA Approach<br>\n",
  "**Authors:** Changhyeon Lee and Younyoung Choi, Ajou University\n\n",
  "## Analysis specification\n\n",
  "The primary poster analysis uses the MAPS parent panel (W1-W5; 2,190 parents; 77,160 item responses). ",
  "Wave is restricted to the latent growth equation. Measurement DIF is modeled with time-varying Korean proficiency, income, and discrimination. ",
  "The estimates below pool selected draws from four full-data mean-field variational inference fits.\n\n",
  "## Table S1. Discrimination-related threshold DIF\n\n",
  "Negative coefficients indicate lower endorsement thresholds among parents reporting discrimination, conditional on the latent stress level and other modeled covariates.\n\n",
  markdown_table(table_s1), "\n\n",
  "[Download Table S1 as CSV](table_s1_discrimination_threshold_dif.csv)\n\n",
  "## Table S2. Latent slope and VI seed stability\n\n",
  markdown_table(table_s2), "\n\n",
  "[Download Table S2 as CSV](table_s2_latent_slope_and_vi_stability.csv)\n\n",
  "## Table S3. Posterior counterfactual expected responses at eta = 0\n\n",
  "These model-implied comparisons hold latent stress fixed at eta = 0 and contrast discrimination = 0 versus 1. They are not causal effects.\n\n",
  markdown_table(table_s3), "\n\n",
  "[Download Table S3 as CSV](table_s3_counterfactual_expected_response_eta0.csv)\n\n",
  "## Interpretation boundary\n\n",
  "- The design is observational; discrimination-associated DIF is not a causal response-shift effect.\n",
  "- Mean-field VI provides an approximate posterior. No NUTS confirmation is claimed for the revised no-wave measurement-DIF specification.\n",
  "- The latent slope direction was stable across seeds, but variance components were seed-sensitive.\n",
  "- Item content overlaps conceptually with discrimination for some items, so estimates should be interpreted as measurement noninvariance rather than simple response bias.\n",
  "- Restricted MAPS microdata are not redistributed in this repository.\n\n",
  "## Selected references\n\n",
  "- Chen, S. M., & Bauer, D. J. (2024). Modeling construct change over time amidst potential changes in construct measurement: A longitudinal moderated factor analysis approach. *Psychological Methods*. https://doi.org/10.1037/met0000685\n",
  "- Chen, S. M., & Bauer, D. J. (2026). Improving the evaluation of construct change over time: Advantages of longitudinal moderated nonlinear factor analysis over conventional first-order growth models. *Multivariate Behavioral Research*. https://doi.org/10.1080/00273171.2026.2640576\n",
  "- King-Kallimanis, B. L., Oort, F. J., & Garst, G. J. A. (2010). Using structural equation modelling to detect measurement bias and response shift in longitudinal data. *AStA Advances in Statistical Analysis, 94*(2), 139-156. https://doi.org/10.1007/s10182-010-0129-y\n",
  "- Pascoe, E. A., & Smart Richman, L. (2009). Perceived discrimination and health: A meta-analytic review. *Psychological Bulletin, 135*(4), 531-554. https://doi.org/10.1037/a0016059\n\n",
  "## Reproducibility files\n\n",
  "The supplementary tables are generated from `poster_model_output/no_wave_dif_full_vi_4seed/` by `build_imps_supplementary.R`. ",
  "The fitted-model runner is `maps_mnlfa_structural_state_run.R`, and the poster summaries are generated by `summarize_no_wave_vi_poster.R`."
)
writeLines(readme, file.path(output_dir, "README.md"), useBytes = TRUE)

html_escape <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x
}

html_table <- function(x, caption) {
  x[] <- lapply(x, function(col) ifelse(is.na(col), "", as.character(col)))
  head_cells <- paste0("<th>", html_escape(names(x)), "</th>", collapse = "")
  body_rows <- apply(x, 1, function(row) {
    paste0("<tr>", paste0("<td>", html_escape(row), "</td>", collapse = ""), "</tr>")
  })
  paste0(
    "<h3 class=\"table-title\">", caption, "</h3><div class=\"table-wrap\"><table><thead><tr>", head_cells,
    "</tr></thead><tbody>", paste(body_rows, collapse = ""), "</tbody></table></div>"
  )
}

html <- paste0(
  "<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\">",
  "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">",
  "<title>IMPS 2026 MNLFA Supplement</title><style>",
  ":root{color-scheme:light;--navy:#1f2937;--teal:#2f6f73;--soft:#eaf2f2;--line:#d8dee8;--muted:#4b5563}",
  "*{box-sizing:border-box}html,body{width:100%;max-width:100%;overflow-x:hidden}body{margin:0;font-family:Arial,sans-serif;color:#111;background:#fff;line-height:1.5}",
  "header{width:100%;min-width:0;background:var(--navy);color:#fff;padding:28px 20px}main{width:100%;min-width:0;max-width:1100px;margin:auto;padding:24px 20px 64px}",
  "h1{font-size:clamp(28px,5vw,46px);line-height:1.1;margin:0 0 8px;overflow-wrap:anywhere}h2{margin-top:36px;color:var(--navy)}",
  ".meta{color:#d5e7e8}.note{background:var(--soft);border-left:5px solid var(--teal);padding:16px;margin:20px 0}",
  ".table-title{font-size:18px;line-height:1.35;margin:28px 0 0;padding:14px;background:var(--soft);border:1px solid var(--line);border-bottom:0}",
  ".table-wrap{width:100%;max-width:100%;overflow-x:auto;border:1px solid var(--line);margin:0 0 8px}table{border-collapse:collapse;width:max-content;min-width:100%;font-size:14px}",
  "th,td{padding:9px 10px;border-bottom:1px solid var(--line);text-align:left;white-space:nowrap}",
  "th{background:#f7f8fa}a{color:var(--teal);font-weight:700}.small{color:var(--muted);font-size:14px}",
  "</style></head><body><header><h1>IMPS 2026 supplementary tables</h1>",
  "<div class=\"meta\">Acculturative Stress Change and Covariate DIF: a Bayesian MNLFA Approach<br>",
  "Changhyeon Lee and Younyoung Choi, Ajou University</div></header><main>",
  "<div class=\"note\"><strong>Primary specification.</strong> Wave enters only the latent growth equation. Measurement DIF uses Korean proficiency, income, and discrimination. Results pool selected draws from four full-data mean-field VI fits.</div>",
  html_table(table_s1, "Table S1. Discrimination-related threshold DIF"),
  "<p><a href=\"table_s1_discrimination_threshold_dif.csv\">Download Table S1 (CSV)</a></p>",
  html_table(table_s2, "Table S2. Latent slope and VI seed stability"),
  "<p><a href=\"table_s2_latent_slope_and_vi_stability.csv\">Download Table S2 (CSV)</a></p>",
  html_table(table_s3, "Table S3. Counterfactual expected responses at eta = 0"),
  "<p><a href=\"table_s3_counterfactual_expected_response_eta0.csv\">Download Table S3 (CSV)</a></p>",
  "<h2>Interpretation boundary</h2><ul>",
  "<li>Observational discrimination-associated DIF is not a causal response-shift effect.</li>",
  "<li>Mean-field VI is approximate; no no-wave NUTS confirmation is claimed.</li>",
  "<li>Variance components were seed-sensitive even though the latent slope direction was stable.</li>",
  "<li>Restricted MAPS microdata are not redistributed.</li></ul>",
  "<h2>Selected references</h2><ul>",
  "<li>Chen, S. M., &amp; Bauer, D. J. (2024). Modeling construct change over time amidst potential changes in construct measurement: A longitudinal moderated factor analysis approach. <em>Psychological Methods</em>. <a href=\"https://doi.org/10.1037/met0000685\">https://doi.org/10.1037/met0000685</a></li>",
  "<li>Chen, S. M., &amp; Bauer, D. J. (2026). Improving the evaluation of construct change over time: Advantages of longitudinal moderated nonlinear factor analysis over conventional first-order growth models. <em>Multivariate Behavioral Research</em>. <a href=\"https://doi.org/10.1080/00273171.2026.2640576\">https://doi.org/10.1080/00273171.2026.2640576</a></li>",
  "<li>King-Kallimanis, B. L., Oort, F. J., &amp; Garst, G. J. A. (2010). Using structural equation modelling to detect measurement bias and response shift in longitudinal data. <em>AStA Advances in Statistical Analysis, 94</em>(2), 139-156. <a href=\"https://doi.org/10.1007/s10182-010-0129-y\">https://doi.org/10.1007/s10182-010-0129-y</a></li>",
  "<li>Pascoe, E. A., &amp; Smart Richman, L. (2009). Perceived discrimination and health: A meta-analytic review. <em>Psychological Bulletin, 135</em>(4), 531-554. <a href=\"https://doi.org/10.1037/a0016059\">https://doi.org/10.1037/a0016059</a></li></ul>",
  "<p class=\"small\">Generated 2026-07-14 from the archived poster-analysis summaries.</p>",
  "</main></body></html>"
)
writeLines(html, file.path(output_dir, "index.html"), useBytes = TRUE)

message("Wrote supplementary materials to: ", normalizePath(output_dir, winslash = "/"))
