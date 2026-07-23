# Preliminary RSDI post-processing for the MAPS longitudinal ordinal MNLFA.
#
# This script uses existing CmdStan output from poster_model_output/full and
# decomposes posterior-predicted item response changes into:
#   1. latent trajectory contribution,
#   2. measurement-function / response-shift contribution,
#   3. latent-by-measurement interaction.
#
# The current target is a first-paper preliminary result. The default uses the
# person-wave posterior latent trajectory implied by the fitted MNLFA and the
# observed time-varying DIF covariates.

args <- commandArgs(trailingOnly = TRUE)

get_arg <- function(flag, default = NULL) {
  hit <- grep(paste0("^", flag, "="), args, value = TRUE)
  if (length(hit) == 0) {
    return(default)
  }
  sub(paste0("^", flag, "="), "", hit[[length(hit)]])
}

mode <- get_arg("--mode", "full")
draw_limit_arg <- get_arg("--draw-limit", NA_character_)
draw_limit <- suppressWarnings(as.integer(draw_limit_arg))
if (is.na(draw_limit)) {
  draw_limit <- Inf
}

out_dir <- file.path("poster_model_output", mode)
rsdi_dir <- file.path(out_dir, "rsdi_preliminary")
dir.create(rsdi_dir, recursive = TRUE, showWarnings = FALSE)

if (!requireNamespace("data.table", quietly = TRUE)) {
  stop("Package 'data.table' is required. Set R_LIBS_USER to the project Rlib if needed.")
}

library(data.table)

default_item_map <- data.table(
  original_item = 1:8,
  item_short = c(
    "Different treatment",
    "Perceived prejudice",
    "Homesickness",
    "Unfamiliar environment",
    "Missing birthplace/people",
    "Anger at disregard",
    "Withdrawal",
    "Perceived low social status"
  )
)

item_mapping_path <- file.path(out_dir, "item_mapping.csv")
if (file.exists(item_mapping_path)) {
  item_mapping <- fread(item_mapping_path)
  missing_mapping <- setdiff(c("item", "original_item"), names(item_mapping))
  if (length(missing_mapping) > 0) {
    stop("item_mapping.csv is missing columns: ", paste(missing_mapping, collapse = ", "))
  }
  item_mapping[, `:=`(
    item = as.integer(item),
    original_item = as.integer(original_item)
  )]
} else {
  item_mapping <- data.table(
    item = default_item_map$original_item,
    original_item = default_item_map$original_item
  )
}
item_map <- merge(item_mapping, default_item_map, by = "original_item", all.x = TRUE, sort = FALSE)
item_map[is.na(item_short), item_short := paste0("Original item ", original_item)]
setorder(item_map, item)
fwrite(item_map, file.path(rsdi_dir, "rsdi_item_mapping.csv"))

item_meta_for <- function(item_id) {
  item_idx <- match(item_id, item_map[["item"]])
  if (is.na(item_idx)) {
    stop("No item metadata found for model item ", item_id)
  }
  item_map[item_idx]
}

predictor_path <- file.path(out_dir, "predictor_index.csv")
if (!file.exists(predictor_path)) {
  stop("Missing predictor index: ", predictor_path)
}
predictor_index <- fread(predictor_path)
predictor_names <- predictor_index$predictor
disc_idx <- match("discrim_any", predictor_names)
if (is.na(disc_idx)) {
  stop("predictor_index.csv must include discrim_any.")
}

state_predictor_path <- file.path(out_dir, "state_predictor_index.csv")
state_predictor_names <- character()
if (file.exists(state_predictor_path)) {
  state_predictor_names <- fread(state_predictor_path)$predictor
  message("Detected latent-state predictors: ", paste(state_predictor_names, collapse = ", "))
}

data_path <- if (file.exists("longdat_maps_parent_discrim.csv")) {
  "longdat_maps_parent_discrim.csv"
} else {
  "longdat_maps.csv"
}
message("Reading MAPS long data: ", data_path)
dat <- fread(data_path)
setorder(dat, person_id, time, item)

required <- c("resp", "person_id", "time", "item", predictor_names)
missing_cols <- setdiff(required, names(dat))
if (length(missing_cols) > 0) {
  stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
}

# Match the preprocessing in maps_mnlfa_poster_run.R.
dat[, time_c := as.numeric(scale(time, center = TRUE, scale = FALSE))]
complete_predictors <- complete.cases(dat[, ..predictor_names])
if (any(!complete_predictors)) {
  message("Dropping rows with missing DIF predictors: ", sum(!complete_predictors))
  dat <- dat[complete_predictors]
  dat[, person_id := as.integer(factor(person_id))]
}

if (length(state_predictor_names) > 0 && !all(state_predictor_names %in% names(dat))) {
  dat[, row_id_for_merge := .I]
  person_wave_for_state <- unique(
    dat[, .(person_id, time, age_c, korean_c, income_c, discrim_any)],
    by = c("person_id", "time")
  )
  between <- person_wave_for_state[
    ,
    .(
      age_between = mean(age_c, na.rm = TRUE),
      korean_between = mean(korean_c, na.rm = TRUE),
      income_between = mean(income_c, na.rm = TRUE),
      discrim_between = mean(discrim_any, na.rm = TRUE)
    ),
    by = person_id
  ]
  dat <- merge(dat, between, by = "person_id", all.x = TRUE, sort = FALSE)
  setorder(dat, row_id_for_merge)
  dat[, row_id_for_merge := NULL]
  dat[, korean_within := korean_c - korean_between]
  dat[, income_within := income_c - income_between]
  dat[, discrim_within := discrim_any - discrim_between]
}

if (length(state_predictor_names) > 0) {
  missing_state_cols <- setdiff(state_predictor_names, names(dat))
  if (length(missing_state_cols) > 0) {
    stop("Missing latent-state predictor columns: ", paste(missing_state_cols, collapse = ", "))
  }
  complete_state <- complete.cases(dat[, ..state_predictor_names])
  if (any(!complete_state)) {
    message("Dropping rows with missing latent-state predictors: ", sum(!complete_state))
    dat <- dat[complete_state]
    dat[, person_id := as.integer(factor(person_id))]
  }
}

original_items <- sort(unique(item_map$original_item))
dat <- dat[item %in% original_items]
if (nrow(dat) == 0) {
  stop("No data rows remain after applying item_mapping.csv.")
}
dat[, original_item := item]
dat[, item := item_map$item[match(original_item, item_map$original_item)]]
setorder(dat, person_id, time, item)

waves <- sort(unique(dat$time))
D <- length(waves)
J <- max(item_map$item, na.rm = TRUE)
K <- 5L
Q <- length(predictor_names)
Ni <- length(unique(dat$person_id))

if (!identical(sort(unique(item_map$item)), seq_len(J))) {
  warning("Model item mapping is not a contiguous 1:J sequence.")
}
if (!all(waves == seq_len(D))) {
  warning("Wave labels are not 1:D; output assumes Stan wave indices follow sorted time values.")
}

person_wave_cols <- unique(c("person_id", "time", "time_c", predictor_names, state_predictor_names))
pw <- unique(dat[, ..person_wave_cols], by = c("person_id", "time"))
setorder(pw, person_id, time)

csv_files <- c(
  Sys.glob(file.path(out_dir, "maps_mnlfa_poster-*.csv")),
  Sys.glob(file.path(out_dir, "maps_mnlfa_structural_state-*.csv"))
)
csv_files <- unique(csv_files)
if (length(csv_files) == 0) {
  stop("No CmdStan CSV files found in ", out_dir)
}
csv_info <- file.info(csv_files)
csv_files <- csv_files[csv_info$size > 1e7]
if (length(csv_files) == 0) {
  stop("No large posterior CSV files found in ", out_dir)
}
csv_info <- file.info(csv_files)
csv_file <- csv_files[which.max(csv_info$mtime)]
message("Using posterior CSV: ", csv_file)

header_names <- names(fread(csv_file, comment.char = "#", nrows = 0, check.names = FALSE))

fixed_cols <- c(
  paste0("log_loading.", seq_len(J)),
  as.vector(outer(seq_len(J), seq_len(K - 1L), function(j, k) paste0("cutpoint.", j, ".", k))),
  as.vector(outer(seq_len(J), seq_len(Q), function(j, q) paste0("loading_dif.", j, ".", q))),
  as.vector(outer(seq_len(J), seq_len(Q), function(j, q) paste0("threshold_dif.", j, ".", q))),
  if (length(state_predictor_names) > 0) paste0("state_effect.", seq_along(state_predictor_names)) else character(),
  "occasion_sd"
)

person_cols <- c(
  paste0("eta_intercept.", seq_len(Ni)),
  paste0("eta_slope.", seq_len(Ni)),
  as.vector(outer(seq_len(D), seq_len(Ni), function(t, p) paste0("occasion_z.", t, ".", p)))
)

draw_cols <- unique(c(fixed_cols, person_cols))
missing_draw_cols <- setdiff(draw_cols, header_names)
if (length(missing_draw_cols) > 0) {
  stop(
    "Missing posterior columns. First missing columns: ",
    paste(head(missing_draw_cols, 20), collapse = ", ")
  )
}

message("Reading selected posterior columns: ", length(draw_cols), " of ", length(header_names))
draws <- fread(
  csv_file,
  comment.char = "#",
  select = draw_cols,
  check.names = FALSE,
  showProgress = TRUE
)

if (is.finite(draw_limit) && nrow(draws) > draw_limit) {
  keep <- unique(round(seq(1, nrow(draws), length.out = draw_limit)))
  draws <- draws[keep]
  message("Thinned posterior draws to ", nrow(draws), " evenly spaced draws.")
}

ndraw <- nrow(draws)
draw_mat <- as.matrix(draws)
rm(draws)
gc()

clamp <- function(x, lo, hi) pmin(hi, pmax(lo, x))

category_prob_vec <- function(cuts, shift, mu) {
  c1 <- plogis(cuts[1] + shift - mu)
  c2 <- plogis(cuts[2] + shift - mu)
  c3 <- plogis(cuts[3] + shift - mu)
  c4 <- plogis(cuts[4] + shift - mu)
  cbind(c1, c2 - c1, c3 - c2, c4 - c3, 1 - c4)
}

tv_rows <- function(delta) {
  0.5 * rowSums(abs(delta))
}

expected_delta <- function(delta) {
  as.numeric(delta %*% seq_len(ncol(delta)))
}

high_delta <- function(delta) {
  rowSums(delta[, 4:5, drop = FALSE])
}

summarise_draws <- function(dt, by_cols) {
  value_cols <- setdiff(names(dt), c(by_cols, "draw"))
  dt[
    ,
    {
      out <- vector("list", length(value_cols) * 3L)
      names(out) <- c(
        paste0(value_cols, "_mean"),
        paste0(value_cols, "_q5"),
        paste0(value_cols, "_q95")
      )
      offset_q5 <- length(value_cols)
      offset_q95 <- length(value_cols) * 2L
      for (i in seq_along(value_cols)) {
        x <- .SD[[value_cols[i]]]
        out[[i]] <- mean(x, na.rm = TRUE)
        out[[offset_q5 + i]] <- as.numeric(stats::quantile(x, 0.05, na.rm = TRUE))
        out[[offset_q95 + i]] <- as.numeric(stats::quantile(x, 0.95, na.rm = TRUE))
      }
      out
    },
    by = by_cols,
    .SDcols = value_cols
  ]
}

make_pair_data <- function(w0, w1) {
  left <- copy(pw[time == w0])
  right <- copy(pw[time == w1])
  setnames(left, setdiff(names(left), "person_id"), paste0(setdiff(names(left), "person_id"), "_0"))
  setnames(right, setdiff(names(right), "person_id"), paste0(setdiff(names(right), "person_id"), "_1"))
  merge(left, right, by = "person_id")
}

latent_for_wave <- function(draw_id, persons, time_c, wave_id, state_mat = NULL) {
  intercept <- draw_mat[draw_id, paste0("eta_intercept.", persons)]
  slope <- draw_mat[draw_id, paste0("eta_slope.", persons)]
  occ_sd <- draw_mat[draw_id, "occasion_sd"]
  occ <- draw_mat[draw_id, paste0("occasion_z.", wave_id, ".", persons)]
  eta <- intercept + slope * time_c + occ_sd * occ
  if (length(state_predictor_names) > 0) {
    if (is.null(state_mat)) {
      stop("state_mat is required when latent-state predictors are present.")
    }
    eta <- eta + as.numeric(
      state_mat %*% draw_mat[draw_id, paste0("state_effect.", seq_along(state_predictor_names))]
    )
  }
  eta
}

prob_for_item <- function(draw_id, item, theta, z_mat) {
  log_base <- draw_mat[draw_id, paste0("log_loading.", item)]
  loading_eff <- as.numeric(z_mat %*% draw_mat[draw_id, paste0("loading_dif.", item, ".", seq_len(Q))])
  threshold_shift <- as.numeric(z_mat %*% draw_mat[draw_id, paste0("threshold_dif.", item, ".", seq_len(Q))])
  lambda <- exp(clamp(log_base + loading_eff, -1.5, 1.5))
  cuts <- draw_mat[draw_id, paste0("cutpoint.", item, ".", seq_len(K - 1L))]
  category_prob_vec(cuts, clamp(threshold_shift, -3, 3), lambda * theta)
}

pair_specs <- data.table(
  wave0 = waves[-length(waves)],
  wave1 = waves[-1L],
  pair_type = "adjacent"
)
pair_specs <- rbind(
  pair_specs,
  data.table(wave0 = waves[1L], wave1 = waves[length(waves)], pair_type = "full_span")
)
pair_specs[, pair := paste0("W", wave0, "_to_W", wave1)]

message("Computing person-level RSDI components...")
result_rows <- vector("list", nrow(pair_specs) * J)
row_id <- 1L

for (pp in seq_len(nrow(pair_specs))) {
  w0 <- pair_specs$wave0[pp]
  w1 <- pair_specs$wave1[pp]
  pair_label <- pair_specs$pair[pp]
  pair_type <- pair_specs$pair_type[pp]
  pair_dat <- make_pair_data(w0, w1)
  persons <- pair_dat$person_id
  z0 <- as.matrix(pair_dat[, paste0(predictor_names, "_0"), with = FALSE])
  z1 <- as.matrix(pair_dat[, paste0(predictor_names, "_1"), with = FALSE])
  state0 <- if (length(state_predictor_names) > 0) {
    as.matrix(pair_dat[, paste0(state_predictor_names, "_0"), with = FALSE])
  } else {
    NULL
  }
  state1 <- if (length(state_predictor_names) > 0) {
    as.matrix(pair_dat[, paste0(state_predictor_names, "_1"), with = FALSE])
  } else {
    NULL
  }
  time0 <- pair_dat$time_c_0
  time1 <- pair_dat$time_c_1

  message("  Pair ", pair_label, " (persons = ", length(persons), ")")

  for (item in seq_len(J)) {
    metrics <- list(
      latent_tv = numeric(ndraw),
      measurement_tv = numeric(ndraw),
      interaction_tv = numeric(ndraw),
      total_tv = numeric(ndraw),
      rsdi = numeric(ndraw),
      latent_expected = numeric(ndraw),
      measurement_expected = numeric(ndraw),
      interaction_expected = numeric(ndraw),
      total_expected = numeric(ndraw),
      latent_high = numeric(ndraw),
      measurement_high = numeric(ndraw),
      interaction_high = numeric(ndraw),
      total_high = numeric(ndraw)
    )

    for (draw_id in seq_len(ndraw)) {
      theta0 <- latent_for_wave(draw_id, persons, time0, w0, state0)
      theta1 <- latent_for_wave(draw_id, persons, time1, w1, state1)

      p00 <- prob_for_item(draw_id, item, theta0, z0)
      p10 <- prob_for_item(draw_id, item, theta1, z0)
      p01 <- prob_for_item(draw_id, item, theta0, z1)
      p11 <- prob_for_item(draw_id, item, theta1, z1)

      d_latent <- p10 - p00
      d_measurement <- p01 - p00
      d_interaction <- p11 - p10 - p01 + p00
      d_total <- p11 - p00

      latent_tv <- mean(tv_rows(d_latent), na.rm = TRUE)
      measurement_tv <- mean(tv_rows(d_measurement), na.rm = TRUE)
      interaction_tv <- mean(tv_rows(d_interaction), na.rm = TRUE)
      total_tv <- mean(tv_rows(d_total), na.rm = TRUE)
      denom <- latent_tv + measurement_tv + interaction_tv

      metrics$latent_tv[draw_id] <- latent_tv
      metrics$measurement_tv[draw_id] <- measurement_tv
      metrics$interaction_tv[draw_id] <- interaction_tv
      metrics$total_tv[draw_id] <- total_tv
      metrics$rsdi[draw_id] <- ifelse(denom > 1e-8, measurement_tv / denom, NA_real_)
      metrics$latent_expected[draw_id] <- mean(expected_delta(d_latent), na.rm = TRUE)
      metrics$measurement_expected[draw_id] <- mean(expected_delta(d_measurement), na.rm = TRUE)
      metrics$interaction_expected[draw_id] <- mean(expected_delta(d_interaction), na.rm = TRUE)
      metrics$total_expected[draw_id] <- mean(expected_delta(d_total), na.rm = TRUE)
      metrics$latent_high[draw_id] <- mean(high_delta(d_latent), na.rm = TRUE)
      metrics$measurement_high[draw_id] <- mean(high_delta(d_measurement), na.rm = TRUE)
      metrics$interaction_high[draw_id] <- mean(high_delta(d_interaction), na.rm = TRUE)
      metrics$total_high[draw_id] <- mean(high_delta(d_total), na.rm = TRUE)
    }

    item_meta <- item_meta_for(item)
    draw_summary <- as.data.table(c(list(draw = seq_len(ndraw)), metrics))
    draw_summary[, `:=`(
      pair = pair_label,
      pair_type = pair_type,
      wave0 = w0,
      wave1 = w1,
      item = item,
      original_item = item_meta$original_item[1],
      item_short = item_meta$item_short[1]
    )]
    setcolorder(
      draw_summary,
      c("pair", "pair_type", "wave0", "wave1", "item", "original_item", "item_short", "draw",
        setdiff(names(draw_summary), c("pair", "pair_type", "wave0", "wave1", "item", "original_item", "item_short", "draw")))
    )
    result_rows[[row_id]] <- draw_summary
    row_id <- row_id + 1L
  }
}

rsdi_draws <- rbindlist(result_rows)
fwrite(rsdi_draws, file.path(rsdi_dir, "rsdi_person_wavepair_item_draws.csv"))

rsdi_item_summary <- summarise_draws(
  rsdi_draws,
  c("pair", "pair_type", "wave0", "wave1", "item", "original_item", "item_short")
)
setorder(rsdi_item_summary, wave0, wave1, item)
fwrite(rsdi_item_summary, file.path(rsdi_dir, "rsdi_person_wavepair_item_summary.csv"))

rsdi_overall_draws <- rsdi_draws[
  ,
  lapply(.SD, mean, na.rm = TRUE),
  by = .(pair, pair_type, wave0, wave1, draw),
  .SDcols = c(
    "latent_tv", "measurement_tv", "interaction_tv", "total_tv", "rsdi",
    "latent_expected", "measurement_expected", "interaction_expected", "total_expected",
    "latent_high", "measurement_high", "interaction_high", "total_high"
  )
]
rsdi_overall_summary <- summarise_draws(
  rsdi_overall_draws,
  c("pair", "pair_type", "wave0", "wave1")
)
setorder(rsdi_overall_summary, wave0, wave1)
fwrite(rsdi_overall_summary, file.path(rsdi_dir, "rsdi_person_wavepair_overall_summary.csv"))

message("Computing discrimination yes/no contrasts at fixed latent trait...")
disc_rows <- vector("list", D * J)
row_id <- 1L
for (wave_id in waves) {
  wave_dat <- pw[time == wave_id]
  persons <- wave_dat$person_id
  z_obs <- as.matrix(wave_dat[, ..predictor_names])
  state_obs <- if (length(state_predictor_names) > 0) {
    as.matrix(wave_dat[, ..state_predictor_names])
  } else {
    NULL
  }
  z_no <- z_obs
  z_yes <- z_obs
  z_no[, disc_idx] <- 0
  z_yes[, disc_idx] <- 1
  time_vec <- wave_dat$time_c

  for (item in seq_len(J)) {
    metrics <- list(
      discrim_tv = numeric(ndraw),
      discrim_expected = numeric(ndraw),
      discrim_high = numeric(ndraw)
    )
    for (draw_id in seq_len(ndraw)) {
      theta <- latent_for_wave(draw_id, persons, time_vec, wave_id, state_obs)
      p_no <- prob_for_item(draw_id, item, theta, z_no)
      p_yes <- prob_for_item(draw_id, item, theta, z_yes)
      delta <- p_yes - p_no
      metrics$discrim_tv[draw_id] <- mean(tv_rows(delta), na.rm = TRUE)
      metrics$discrim_expected[draw_id] <- mean(expected_delta(delta), na.rm = TRUE)
      metrics$discrim_high[draw_id] <- mean(high_delta(delta), na.rm = TRUE)
    }
    item_meta <- item_meta_for(item)
    draw_summary <- as.data.table(c(list(draw = seq_len(ndraw)), metrics))
    draw_summary[, `:=`(
      wave = wave_id,
      item = item,
      original_item = item_meta$original_item[1],
      item_short = item_meta$item_short[1]
    )]
    setcolorder(draw_summary, c("wave", "item", "original_item", "item_short", "draw",
                                "discrim_tv", "discrim_expected", "discrim_high"))
    disc_rows[[row_id]] <- draw_summary
    row_id <- row_id + 1L
  }
}

disc_draws <- rbindlist(disc_rows)
fwrite(disc_draws, file.path(rsdi_dir, "discrimination_contrast_item_draws.csv"))
disc_summary <- summarise_draws(disc_draws, c("wave", "item", "original_item", "item_short"))
setorder(disc_summary, wave, item)
fwrite(disc_summary, file.path(rsdi_dir, "discrimination_contrast_item_summary.csv"))

disc_item_draws <- disc_draws[
  ,
  .(
    discrim_tv = mean(discrim_tv),
    discrim_expected = mean(discrim_expected),
    discrim_high = mean(discrim_high)
  ),
  by = .(item, original_item, item_short, draw)
]
disc_item_summary <- summarise_draws(disc_item_draws, c("item", "original_item", "item_short"))
setorder(disc_item_summary, item)
fwrite(disc_item_summary, file.path(rsdi_dir, "discrimination_contrast_item_over_waves_summary.csv"))

save_png <- function(path, expr, width = 2600, height = 1600, res = 220) {
  png(path, width = width, height = height, res = res)
  on.exit(dev.off(), add = TRUE)
  force(expr)
}

item_labels <- function(dt) {
  item_number <- if ("original_item" %in% names(dt)) dt$original_item else dt$item
  paste0("Item ", item_number, ": ", dt$item_short)
}

red <- "#C84C3A"
blue <- "#2D6A8E"
green <- "#3E8F6B"
gray <- "#666666"

full_pair <- paste0("W", waves[1L], "_to_W", waves[length(waves)])
full_item <- rsdi_item_summary[pair == full_pair]

save_png(file.path(rsdi_dir, "fig_rsdi_fullspan_item_fraction.png"), {
  datp <- full_item[order(rsdi_mean)]
  par(mar = c(5, 10, 3, 2), family = "sans")
  xlim <- range(c(datp$rsdi_q5, datp$rsdi_q95, 0, 1), na.rm = TRUE)
  plot(
    datp$rsdi_mean, seq_len(nrow(datp)),
    xlim = xlim,
    yaxt = "n",
    pch = 19,
    col = green,
    xlab = "RSDI: measurement component / component magnitudes",
    ylab = "",
    main = paste0(full_pair, " Response Shift Decomposition by Item")
  )
  abline(v = seq(0, 1, 0.25), col = "#EEEEEE")
  segments(datp$rsdi_q5, seq_len(nrow(datp)), datp$rsdi_q95, seq_len(nrow(datp)),
           col = green, lwd = 2.5)
  points(datp$rsdi_mean, seq_len(nrow(datp)), pch = 19, col = green, cex = 1.1)
  axis(2, at = seq_len(nrow(datp)),
       labels = item_labels(datp), las = 2, cex.axis = 0.75)
})

save_png(file.path(rsdi_dir, "fig_rsdi_wavepair_component_tv.png"), {
  datp <- rsdi_overall_summary[order(wave0, wave1)]
  mat <- rbind(
    latent = datp$latent_tv_mean,
    measurement = datp$measurement_tv_mean,
    interaction = datp$interaction_tv_mean
  )
  par(mar = c(6, 5, 3, 1), family = "sans")
  barplot(
    mat,
    beside = FALSE,
    col = c(blue, red, gray),
    names.arg = datp$pair,
    las = 2,
    ylab = "Mean total-variation component",
    main = "Posterior-Predicted Response Change Components"
  )
  legend("topleft", legend = rownames(mat), fill = c(blue, red, gray), bty = "n")
})

save_png(file.path(rsdi_dir, "fig_discrimination_contrast_expected_score.png"), {
  datp <- disc_item_summary[order(discrim_expected_mean)]
  par(mar = c(5, 10, 3, 2), family = "sans")
  xlim <- range(c(datp$discrim_expected_q5, datp$discrim_expected_q95, 0), na.rm = TRUE)
  plot(
    datp$discrim_expected_mean, seq_len(nrow(datp)),
    xlim = xlim,
    yaxt = "n",
    pch = 19,
    col = ifelse(datp$discrim_expected_mean >= 0, red, blue),
    xlab = "Expected response shift: discrimination yes - no",
    ylab = "",
    main = "Discrimination-Related Response Shift by Item"
  )
  abline(v = 0, lty = 2, col = gray)
  segments(datp$discrim_expected_q5, seq_len(nrow(datp)),
           datp$discrim_expected_q95, seq_len(nrow(datp)),
           col = ifelse(datp$discrim_expected_mean >= 0, red, blue), lwd = 2.5)
  points(datp$discrim_expected_mean, seq_len(nrow(datp)),
         pch = 19, col = ifelse(datp$discrim_expected_mean >= 0, red, blue), cex = 1.1)
  axis(2, at = seq_len(nrow(datp)),
       labels = item_labels(datp), las = 2, cex.axis = 0.75)
})

metadata <- data.table(
  field = c(
    "mode", "posterior_csv", "draws_used", "persons", "waves", "items",
    "predictors", "analysis_note"
  ),
  value = c(
    mode,
    normalizePath(csv_file, winslash = "/", mustWork = FALSE),
    as.character(ndraw),
    as.character(Ni),
    paste(waves, collapse = ","),
    as.character(J),
    paste(predictor_names, collapse = ", "),
    "Preliminary person-wave RSDI from CmdStan variational posterior draws; use full NUTS or calibration runs for final confirmatory claims."
  )
)
fwrite(metadata, file.path(rsdi_dir, "rsdi_preliminary_metadata.csv"))

message("Saved RSDI preliminary outputs to: ", normalizePath(rsdi_dir, winslash = "/", mustWork = FALSE))
