# Run empirical comparator models for the MAPS parent-panel MNLFA paper.
#
# Comparators:
#   1. Naive observed-score growth model using person-wave mean item scores.
#   2. Invariant ordinal latent growth model with no loading or threshold DIF.
#
# Usage:
#   Rscript maps_empirical_comparators_run.R quick
#   Rscript maps_empirical_comparators_run.R full
#   Rscript maps_empirical_comparators_run.R nuts_check

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[1] else "quick"
if (!mode %in% c("quick", "full", "nuts_check")) {
  stop("Mode must be one of: quick, full, nuts_check.")
}

data_path <- if (file.exists("longdat_maps_parent_discrim.csv")) {
  "longdat_maps_parent_discrim.csv"
} else {
  "longdat_maps.csv"
}
stan_path <- "maps_invariant_lgm.stan"
out_dir <- file.path("empirical_comparator_output", mode)
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

if (!requireNamespace("cmdstanr", quietly = TRUE)) {
  stop("Package 'cmdstanr' is required.")
}
if (!requireNamespace("posterior", quietly = TRUE)) {
  stop("Package 'posterior' is required.")
}

library(cmdstanr)
library(posterior)

known_cmdstan_paths <- c(
  "C:/cmdstan/cmdstan-2.38.0",
  "C:/cmdstan-2.38.0/cmdstan-2.38.0"
)
current_cmdstan_path <- tryCatch(cmdstanr::cmdstan_path(), error = function(e) "")
if (!nzchar(current_cmdstan_path)) {
  found <- known_cmdstan_paths[dir.exists(known_cmdstan_paths)]
  if (length(found) == 0) {
    stop("CmdStan path is not set and no known local CmdStan path was found.")
  }
  cmdstanr::set_cmdstan_path(found[1])
}

message("Reading data: ", data_path)
dat <- read.csv(data_path)
required <- c("resp", "person_id", "time", "item")
missing_cols <- setdiff(required, names(dat))
if (length(missing_cols) > 0) {
  stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
}

dat <- dat[order(dat$person_id, dat$time, dat$item), ]
if (mode %in% c("quick", "nuts_check")) {
  n_people <- if (mode == "quick") 80 else 300
  keep_people <- sort(unique(dat$person_id))[seq_len(min(n_people, length(unique(dat$person_id))))]
  dat <- dat[dat$person_id %in% keep_people, ]
}
dat$person_id <- as.integer(factor(dat$person_id))
dat$item <- as.integer(factor(dat$item))
dat$wave_index <- as.integer(factor(dat$time, levels = sort(unique(dat$time))))
dat$time_c <- as.numeric(scale(dat$time, center = TRUE, scale = FALSE))

message("Fitting naive observed-score growth model.")
person_wave <- aggregate(
  resp ~ person_id + time + time_c,
  data = dat,
  FUN = function(x) mean(x, na.rm = TRUE)
)
names(person_wave)[names(person_wave) == "resp"] <- "mean_score"
write.csv(person_wave, file.path(out_dir, "observed_score_person_wave.csv"),
          row.names = FALSE)

if (requireNamespace("nlme", quietly = TRUE)) {
  observed_fit <- nlme::lme(
    mean_score ~ time_c,
    random = ~ time_c | person_id,
    data = person_wave,
    method = "REML",
    control = nlme::lmeControl(opt = "optim")
  )
  fixed <- summary(observed_fit)$tTable
  observed_summary <- data.frame(
    model = "observed_score_lme",
    term = rownames(fixed),
    estimate = fixed[, "Value"],
    se = fixed[, "Std.Error"],
    df = fixed[, "DF"],
    statistic = fixed[, "t-value"],
    p_value = fixed[, "p-value"],
    row.names = NULL
  )
  observed_random <- as.data.frame(nlme::VarCorr(observed_fit))
  write.csv(observed_random, file.path(out_dir, "observed_score_random_effects.csv"),
            row.names = FALSE)
} else {
  warning("Package 'nlme' is unavailable; falling back to ordinary least squares.")
  observed_fit <- stats::lm(mean_score ~ time_c, data = person_wave)
  fixed <- summary(observed_fit)$coefficients
  observed_summary <- data.frame(
    model = "observed_score_lm",
    term = rownames(fixed),
    estimate = fixed[, "Estimate"],
    se = fixed[, "Std. Error"],
    df = observed_fit$df.residual,
    statistic = fixed[, "t value"],
    p_value = fixed[, "Pr(>|t|)"],
    row.names = NULL
  )
}
write.csv(observed_summary, file.path(out_dir, "observed_score_growth_summary.csv"),
          row.names = FALSE)

wave_grid <- aggregate(
  time_c ~ time,
  data = person_wave,
  FUN = function(x) unique(x)[1]
)
wave_grid <- wave_grid[order(wave_grid$time), ]
wave_grid$observed_mean <- as.numeric(tapply(
  person_wave$mean_score,
  person_wave$time,
  mean,
  na.rm = TRUE
)[as.character(wave_grid$time)])
wave_grid$observed_se <- as.numeric(tapply(
  person_wave$mean_score,
  person_wave$time,
  function(x) stats::sd(x, na.rm = TRUE) / sqrt(sum(!is.na(x)))
)[as.character(wave_grid$time)])
wave_grid$observed_model_mean <- as.numeric(stats::predict(
  observed_fit,
  newdata = data.frame(time_c = wave_grid$time_c),
  level = 0
))
write.csv(wave_grid, file.path(out_dir, "observed_score_trajectory.csv"),
          row.names = FALSE)

message("Fitting invariant ordinal latent growth model: ", stan_path)
stan_data <- list(
  Nobs = nrow(dat),
  P = length(unique(dat$item)),
  Ni = length(unique(dat$person_id)),
  D = length(unique(dat$wave_index)),
  K = max(dat$resp, na.rm = TRUE),
  person = dat$person_id,
  item = dat$item,
  wave = dat$wave_index,
  Y = dat$resp,
  time_score = dat$time_c
)

model <- cmdstanr::cmdstan_model(stan_path, dir = out_dir)

init_fun <- function() {
  list(
    log_loading = rep(0, stan_data$P),
    cutpoint_first = rep(-1.5, stan_data$P),
    log_cutpoint_spacing = matrix(0, nrow = stan_data$P, ncol = stan_data$K - 2),
    mu_slope = 0,
    growth_sd = c(0.7, 0.2),
    growth_cor_chol = diag(2),
    growth_z = matrix(0, nrow = 2, ncol = stan_data$Ni),
    occasion_sd = 0.2,
    occasion_z = matrix(0, nrow = stan_data$D, ncol = stan_data$Ni)
  )
}

if (mode == "full") {
  fit <- model$variational(
    data = stan_data,
    algorithm = "meanfield",
    iter = 15000,
    grad_samples = 1,
    elbo_samples = 50,
    output_samples = 1000,
    adapt_engaged = TRUE,
    seed = 20260517,
    init = init_fun,
    refresh = 250,
    output_dir = out_dir
  )
} else {
  chains <- if (mode == "quick") 2 else 4
  iter_warmup <- if (mode == "quick") 50 else 300
  iter_sampling <- if (mode == "quick") 50 else 300
  fit <- model$sample(
    data = stan_data,
    chains = chains,
    parallel_chains = chains,
    iter_warmup = iter_warmup,
    iter_sampling = iter_sampling,
    adapt_delta = if (mode == "quick") 0.90 else 0.95,
    max_treedepth = 12,
    init = init_fun,
    seed = 20260517,
    refresh = 100,
    output_dir = out_dir
  )
}

fit$save_object(file.path(out_dir, "maps_invariant_lgm_fit.rds"))
summary_all <- fit$summary()
write.csv(summary_all, file.path(out_dir, "invariant_lgm_summary_all.csv"),
          row.names = FALSE)

key_vars <- c(
  "slope_mean", "slope_variance",
  "growth_sd[1]", "growth_sd[2]",
  "occasion_sd"
)
key_summary <- summary_all[summary_all$variable %in% key_vars, ]
write.csv(key_summary, file.path(out_dir, "invariant_lgm_trajectory_summary.csv"),
          row.names = FALSE)

ordered_logistic_probs <- function(eta, cuts) {
  cdf <- stats::plogis(cuts - eta)
  c(cdf[1], diff(cdf), 1 - cdf[length(cdf)])
}

expected_item_mean <- function(theta, item, summary_table) {
  log_loading <- summary_table$mean[summary_table$variable == paste0("log_loading[", item, "]")]
  lambda <- exp(max(-1.5, min(1.5, log_loading)))
  cuts <- vapply(seq_len(stan_data$K - 1), function(k) {
    summary_table$mean[summary_table$variable == paste0("cutpoint[", item, ",", k, "]")]
  }, numeric(1))
  probs <- ordered_logistic_probs(lambda * theta, cuts)
  sum(seq_len(stan_data$K) * probs)
}

invariant_slope <- summary_all$mean[summary_all$variable == "slope_mean"]
trajectory_rows <- list()
row_idx <- 1
for (i in seq_len(nrow(wave_grid))) {
  theta <- invariant_slope * wave_grid$time_c[i]
  expected_items <- vapply(seq_len(stan_data$P), function(item) {
    expected_item_mean(theta, item, summary_all)
  }, numeric(1))
  trajectory_rows[[row_idx]] <- data.frame(
    model = "invariant_lgm",
    time = wave_grid$time[i],
    time_c = wave_grid$time_c[i],
    trajectory_scale = "expected_observed_category",
    estimate = mean(expected_items)
  )
  row_idx <- row_idx + 1
  trajectory_rows[[row_idx]] <- data.frame(
    model = "invariant_lgm",
    time = wave_grid$time[i],
    time_c = wave_grid$time_c[i],
    trajectory_scale = "latent_theta",
    estimate = theta
  )
  row_idx <- row_idx + 1
}

for (i in seq_len(nrow(wave_grid))) {
  trajectory_rows[[row_idx]] <- data.frame(
    model = "observed_score_lme",
    time = wave_grid$time[i],
    time_c = wave_grid$time_c[i],
    trajectory_scale = "mean_observed_category",
    estimate = wave_grid$observed_model_mean[i]
  )
  row_idx <- row_idx + 1
}

mnlfa_dir <- file.path("poster_model_output", mode)
mnlfa_summary_path <- file.path(mnlfa_dir, "poster_model_summary_all.csv")
if (file.exists(mnlfa_summary_path)) {
  message("Adding MNLFA reference trajectories from: ", mnlfa_summary_path)
  mnlfa_summary <- read.csv(mnlfa_summary_path)
  predictor_index <- read.csv(file.path(mnlfa_dir, "predictor_index.csv"))
  discrim_col <- match("discrim_any", predictor_index$predictor)
  mnlfa_slope <- mnlfa_summary$mean[mnlfa_summary$variable == "slope_mean"]

  expected_mnlfa_item_mean <- function(theta, item, discrim_value) {
    log_loading <- mnlfa_summary$mean[mnlfa_summary$variable == paste0("log_loading[", item, "]")]
    loading_shift <- if (!is.na(discrim_col)) {
      mnlfa_summary$mean[mnlfa_summary$variable == paste0("loading_dif[", item, ",", discrim_col, "]")]
    } else {
      0
    }
    threshold_shift <- if (!is.na(discrim_col)) {
      mnlfa_summary$mean[mnlfa_summary$variable == paste0("threshold_dif[", item, ",", discrim_col, "]")]
    } else {
      0
    }
    lambda <- exp(max(-1.5, min(1.5, log_loading + discrim_value * loading_shift)))
    threshold_shift <- max(-3.0, min(3.0, discrim_value * threshold_shift))
    cuts <- vapply(seq_len(stan_data$K - 1), function(k) {
      mnlfa_summary$mean[mnlfa_summary$variable == paste0("cutpoint[", item, ",", k, "]")] +
        threshold_shift
    }, numeric(1))
    probs <- ordered_logistic_probs(lambda * theta, cuts)
    sum(seq_len(stan_data$K) * probs)
  }

  for (discrim_value in c(0, 1)) {
    for (i in seq_len(nrow(wave_grid))) {
      theta <- mnlfa_slope * wave_grid$time_c[i]
      expected_items <- vapply(seq_len(stan_data$P), function(item) {
        expected_mnlfa_item_mean(theta, item, discrim_value)
      }, numeric(1))
      trajectory_rows[[row_idx]] <- data.frame(
        model = paste0("mnlfa_ref_discrim_", discrim_value),
        time = wave_grid$time[i],
        time_c = wave_grid$time_c[i],
        trajectory_scale = "expected_observed_category",
        estimate = mean(expected_items)
      )
      row_idx <- row_idx + 1
      trajectory_rows[[row_idx]] <- data.frame(
        model = paste0("mnlfa_ref_discrim_", discrim_value),
        time = wave_grid$time[i],
        time_c = wave_grid$time_c[i],
        trajectory_scale = "latent_theta",
        estimate = theta
      )
      row_idx <- row_idx + 1
    }
  }
}

trajectory_comparison <- do.call(rbind, trajectory_rows)
write.csv(trajectory_comparison,
          file.path(out_dir, "model_trajectory_comparison.csv"),
          row.names = FALSE)

model_comparison <- rbind(
  data.frame(
    model = unique(observed_summary$model)[1],
    parameter = "slope",
    estimate = observed_summary$estimate[observed_summary$term == "time_c"],
    lower_90 = NA_real_,
    upper_90 = NA_real_,
    scale = "mean_observed_category"
  ),
  data.frame(
    model = "invariant_lgm",
    parameter = key_summary$variable,
    estimate = key_summary$mean,
    lower_90 = key_summary$q5,
    upper_90 = key_summary$q95,
    scale = "latent_theta"
  )
)
write.csv(model_comparison, file.path(out_dir, "empirical_model_comparison.csv"),
          row.names = FALSE)

png(file.path(out_dir, "model_trajectory_comparison.png"),
    width = 2200, height = 1400, res = 220)
plot_dat <- trajectory_comparison[
  trajectory_comparison$trajectory_scale %in%
    c("mean_observed_category", "expected_observed_category"),
]
plot(
  NA,
  xlim = range(plot_dat$time),
  ylim = range(plot_dat$estimate),
  xlab = "Wave",
  ylab = "Expected or observed mean category",
  main = "Empirical trajectory comparison"
)
palette <- c(
  observed_score_lme = "#2A6F97",
  invariant_lgm = "#C44536",
  mnlfa_ref_discrim_0 = "#3A7D44",
  mnlfa_ref_discrim_1 = "#6D597A"
)
for (model_name in unique(plot_dat$model)) {
  one <- plot_dat[plot_dat$model == model_name, ]
  col <- if (model_name %in% names(palette)) palette[[model_name]] else "#555555"
  lines(one$time, one$estimate, type = "b", pch = 19, lwd = 2, col = col)
}
legend("topright", legend = unique(plot_dat$model),
       col = palette[unique(plot_dat$model)], lwd = 2, pch = 19, bty = "n")
dev.off()

message("Done. Main outputs:")
message("  ", file.path(out_dir, "observed_score_growth_summary.csv"))
message("  ", file.path(out_dir, "invariant_lgm_trajectory_summary.csv"))
message("  ", file.path(out_dir, "empirical_model_comparison.csv"))
message("  ", file.path(out_dir, "model_trajectory_comparison.csv"))
