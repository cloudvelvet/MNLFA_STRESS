# Summarize Paper 1 comparator and calibration outputs.

if (!requireNamespace("data.table", quietly = TRUE)) {
  stop("Package 'data.table' is required.")
}

library(data.table)

out_dir <- file.path("RESEARCH", "paper1_maps_empirical", "outputs")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

fmt <- function(x, digits = 3) {
  ifelse(is.na(x), "", formatC(x, format = "f", digits = digits))
}

md_table <- function(dt) {
  cols <- names(dt)
  lines <- c(
    paste0("| ", paste(cols, collapse = " | "), " |"),
    paste0("| ", paste(rep("---", length(cols)), collapse = " | "), " |")
  )
  rows <- apply(as.data.frame(dt), 1, function(row) {
    paste0("| ", paste(row, collapse = " | "), " |")
  })
  paste(c(lines, rows), collapse = "\n")
}

add_original_item <- function(dt) {
  if (!"original_item" %in% names(dt)) {
    dt[, original_item := item]
  }
  dt
}

read_required <- function(path) {
  if (!file.exists(path)) {
    stop("Missing required file: ", path)
  }
  fread(path)
}

# -------------------------------------------------------------------------
# 1. Comparator growth models
# -------------------------------------------------------------------------

observed <- read_required(file.path(
  "empirical_comparator_output", "full", "observed_score_growth_summary.csv"
))
invariant <- read_required(file.path(
  "empirical_comparator_output", "full", "invariant_lgm_trajectory_summary.csv"
))

structural_seeds <- c(20260702L, 20260703L, 20260704L, 20260705L)
structural_dirs <- file.path(
  "poster_model_output",
  paste0("structural_state_full_seed", structural_seeds)
)

read_latent <- function(seed, dir) {
  dt <- read_required(file.path(dir, "latent_trajectory_summary.csv"))
  dt[, seed := seed]
  dt[, .(seed, variable, mean, q5, q95)]
}
latent_by_seed <- rbindlist(Map(read_latent, structural_seeds, structural_dirs))

observed_slope <- observed[term == "time_c"]
invariant_slope <- invariant[variable == "slope_mean"]
structural_slope <- latent_by_seed[variable == "slope_mean"]

comparator_growth <- rbindlist(list(
  data.table(
    model = "naive observed-score LME",
    estimator = "REML LME",
    parameter = "time slope",
    scale = "mean observed category",
    estimate = observed_slope$estimate,
    lower_90 = NA_real_,
    upper_90 = NA_real_,
    note = "Fast comparator; random intercept and time slope."
  ),
  data.table(
    model = "invariant ordinal LGM",
    estimator = "full-data mean-field VI",
    parameter = "slope_mean",
    scale = "latent theta",
    estimate = invariant_slope$mean,
    lower_90 = invariant_slope$q5,
    upper_90 = invariant_slope$q95,
    note = "Ordinal latent comparator with equal item parameters."
  ),
  data.table(
    model = "structural-state MNLFA",
    estimator = "full-data repeated mean-field VI",
    parameter = "slope_mean",
    scale = "latent theta",
    estimate = mean(structural_slope$mean),
    lower_90 = min(structural_slope$mean),
    upper_90 = max(structural_slope$mean),
    note = "Range is across 4 VI seeds, not a posterior interval."
  )
), fill = TRUE)
fwrite(comparator_growth, file.path(out_dir, "paper1_comparator_growth_table.csv"))

# -------------------------------------------------------------------------
# 2. Repeated VI stability for the structural-state model
# -------------------------------------------------------------------------

latent_stability <- latent_by_seed[
  ,
  .(
    vi_mean = mean(mean),
    vi_sd = stats::sd(mean),
    min = min(mean),
    max = max(mean),
    sign_stable = all(sign(mean) == sign(mean[1]))
  ),
  by = variable
]
setorder(latent_stability, variable)
fwrite(latent_by_seed, file.path(out_dir, "paper1_repeated_vi_latent_by_seed.csv"))
fwrite(latent_stability, file.path(out_dir, "paper1_repeated_vi_latent_stability.csv"))

read_state <- function(seed, dir) {
  dt <- read_required(file.path(dir, "state_effect_summary.csv"))
  dt[, seed := seed]
  dt[, .(seed, predictor, mean, q5, q95, credible_nonzero_90)]
}
state_by_seed <- rbindlist(Map(read_state, structural_seeds, structural_dirs))
state_stability <- state_by_seed[
  ,
  .(
    vi_mean = mean(mean),
    vi_sd = stats::sd(mean),
    min = min(mean),
    max = max(mean),
    all_nonzero_90 = all(credible_nonzero_90),
    sign_stable = all(sign(mean) == sign(mean[1]))
  ),
  by = predictor
]
setorder(state_stability, predictor)
fwrite(state_by_seed, file.path(out_dir, "paper1_repeated_vi_state_by_seed.csv"))
fwrite(state_stability, file.path(out_dir, "paper1_repeated_vi_state_stability.csv"))

read_dif <- function(seed, dir) {
  dt <- add_original_item(read_required(file.path(dir, "item_dif_summary.csv")))
  dt[, seed := seed]
  dt[, .(
    seed, parameter_type, item, original_item, predictor,
    mean, q5, q95, credible_nonzero_90
  )]
}
dif_by_seed <- rbindlist(Map(read_dif, structural_seeds, structural_dirs), fill = TRUE)
fwrite(dif_by_seed, file.path(out_dir, "paper1_repeated_vi_dif_by_seed.csv"))

dif_stability <- dif_by_seed[
  predictor == "discrim_any",
  .(
    vi_mean = mean(mean),
    vi_sd = stats::sd(mean),
    min = min(mean),
    max = max(mean),
    all_nonzero_90 = all(credible_nonzero_90),
    sign_stable = all(sign(mean) == sign(mean[1]))
  ),
  by = .(parameter_type, original_item)
]
dif_stability[, abs_vi_mean := abs(vi_mean)]
setorder(dif_stability, parameter_type, -abs_vi_mean)
dif_stability[, abs_vi_mean := NULL]
threshold_stability <- dif_stability[parameter_type == "threshold"]
loading_stability <- dif_stability[parameter_type == "loading"]
fwrite(threshold_stability, file.path(out_dir, "paper1_repeated_vi_threshold_discrim_stability.csv"))
fwrite(loading_stability, file.path(out_dir, "paper1_repeated_vi_loading_discrim_stability.csv"))

# -------------------------------------------------------------------------
# 3. Existing subset NUTS calibration for the earlier measurement-only MNLFA
# -------------------------------------------------------------------------

read_trajectory <- function(dir, label) {
  dt <- read_required(file.path(dir, "latent_trajectory_summary.csv"))
  dt[, source := label]
  dt[, .(source, variable, mean, q5, q95)]
}
baseline_vi_dir <- file.path("poster_model_output", "full")
subset_nuts_dir <- file.path("poster_model_output", "full_nuts_light")
baseline_latent <- read_trajectory(baseline_vi_dir, "full-data VI, measurement-only MNLFA")
subset_latent <- read_trajectory(subset_nuts_dir, "subset NUTS, measurement-only MNLFA")
subset_latent_calibration <- merge(
  baseline_latent,
  subset_latent,
  by = "variable",
  suffixes = c("_vi", "_nuts")
)
subset_latent_calibration[, same_direction := sign(mean_vi) == sign(mean_nuts)]
fwrite(subset_latent_calibration, file.path(out_dir, "paper1_subset_nuts_latent_calibration.csv"))

read_measurement_dif <- function(dir, label) {
  dt <- add_original_item(read_required(file.path(dir, "item_dif_summary.csv")))
  dt[, source := label]
  dt[, .(
    source, parameter_type, item, original_item, predictor,
    mean, q5, q95, credible_nonzero_90
  )]
}
baseline_dif <- read_measurement_dif(baseline_vi_dir, "full-data VI")
subset_dif <- read_measurement_dif(subset_nuts_dir, "subset NUTS")
subset_dif_calibration <- merge(
  baseline_dif[predictor == "discrim_any"],
  subset_dif[predictor == "discrim_any"],
  by = c("parameter_type", "original_item", "predictor"),
  suffixes = c("_vi", "_nuts")
)
subset_dif_calibration[, `:=`(
  same_direction = sign(mean_vi) == sign(mean_nuts),
  both_nonzero_90 = credible_nonzero_90_vi & credible_nonzero_90_nuts
)]
subset_dif_calibration[, abs_mean_nuts := abs(mean_nuts)]
setorder(subset_dif_calibration, parameter_type, -abs_mean_nuts)
subset_dif_calibration[, abs_mean_nuts := NULL]
fwrite(subset_dif_calibration, file.path(out_dir, "paper1_subset_nuts_dif_calibration.csv"))

# -------------------------------------------------------------------------
# 4. Markdown report
# -------------------------------------------------------------------------

comparator_md <- copy(comparator_growth)
comparator_md[, `:=`(
  estimate = fmt(estimate),
  lower_90 = fmt(lower_90),
  upper_90 = fmt(upper_90)
)]

latent_md <- copy(latent_stability[variable %in% c(
  "slope_mean", "slope_variance", "growth_sd[2]", "occasion_sd"
)])
latent_md[, `:=`(
  vi_mean = fmt(vi_mean),
  vi_sd = fmt(vi_sd),
  min = fmt(min),
  max = fmt(max)
)]

threshold_md <- copy(threshold_stability[order(abs(vi_mean), decreasing = TRUE)])
threshold_md[, `:=`(
  vi_mean = fmt(vi_mean),
  vi_sd = fmt(vi_sd),
  min = fmt(min),
  max = fmt(max)
)]

state_md <- copy(state_stability[predictor %in% c(
  "discrim_between", "discrim_within", "korean_between", "korean_within",
  "income_between", "income_within"
)])
state_md[, `:=`(
  vi_mean = fmt(vi_mean),
  vi_sd = fmt(vi_sd),
  min = fmt(min),
  max = fmt(max)
)]

subset_threshold_md <- copy(
  subset_dif_calibration[parameter_type == "threshold"][
    order(abs(mean_nuts), decreasing = TRUE)
  ][, .(
    original_item,
    mean_vi,
    mean_nuts,
    same_direction,
    both_nonzero_90
  )]
)
subset_threshold_md[, `:=`(
  mean_vi = fmt(mean_vi),
  mean_nuts = fmt(mean_nuts)
)]

report <- c(
  "# Paper 1 Comparator and Calibration Summary",
  "",
  "## 1. Comparator Growth Results",
  "",
  "The naive observed-score growth and invariant ordinal latent growth comparators are complete. The structural-state MNLFA row reports the across-seed mean and range of the full-data VI slope, not a posterior interval.",
  "",
  md_table(comparator_md),
  "",
  "## 2. Repeated VI Stability: Structural-State MNLFA",
  "",
  "Four full-data mean-field VI runs were compared: seeds 20260702, 20260703, 20260704, and 20260705.",
  "",
  "### Latent Growth Parameters",
  "",
  md_table(latent_md),
  "",
  "Interpretation: slope direction is stable and negative across seeds, but slope variance, growth SD, and occasion SD are not stable. This means latent/random-effect scale claims should be cautious.",
  "",
  "### Discrimination State Effects",
  "",
  md_table(state_md),
  "",
  "Interpretation: discrimination between-person and within-person state effects keep the same signs and exclude zero across seeds, but magnitudes vary. Korean within-person effect is not stable in sign.",
  "",
  "### Discrimination Threshold DIF",
  "",
  md_table(threshold_md),
  "",
  "Interpretation: discrimination-related threshold DIF is the most stable result. All eight items keep a negative sign and all 90% credible intervals exclude zero across all four VI seeds.",
  "",
  "## 3. Existing Subset NUTS Calibration",
  "",
  "The existing subset NUTS output is from the earlier measurement-only MNLFA, not the newer structural-state MNLFA. It should therefore be used as calibration for the measurement/DIF pattern, not as direct confirmation of the structural-state latent effects.",
  "",
  "### Discrimination Threshold DIF: Full VI vs Existing Subset NUTS",
  "",
  md_table(subset_threshold_md),
  "",
  "Interpretation: the earlier subset NUTS calibration supports the direction of major discrimination threshold DIF effects, but it is not a substitute for a selected NUTS check of the current structural-state model.",
  "",
  "## 4. Manuscript Implication",
  "",
  "The strongest defensible claim is that discrimination-related threshold DIF is robust across repeated VI runs and broadly aligned with the existing NUTS subset check. The weaker claim is the exact magnitude of the latent trajectory, latent variance components, loading DIF, and RSDI. Those should be reported as approximate/model-based and, if possible, followed by selected NUTS calibration.",
  "",
  "Recommended wording:",
  "",
  "> Full-data VI estimates consistently indicated negative discrimination-related threshold DIF across items, whereas latent variance components and some loading/state effects were more sensitive to initialization. We therefore treat threshold DIF and response-shift decomposition as primary exploratory evidence and use subset NUTS results as calibration rather than final full posterior confirmation."
)

writeLines(report, file.path(out_dir, "paper1_comparator_calibration_summary_ko.md"), useBytes = TRUE)

message("Wrote comparator/calibration summary files to: ", normalizePath(out_dir, winslash = "/", mustWork = FALSE))
