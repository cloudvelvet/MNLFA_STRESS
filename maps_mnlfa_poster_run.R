# Run the MAPS longitudinal ordinal MNLFA poster model with CmdStanR.
# Usage:
#   Rscript maps_mnlfa_poster_run.R quick
#   Rscript maps_mnlfa_poster_run.R full
#   Rscript maps_mnlfa_poster_run.R nuts_check
#
# "quick" uses a person subset and short chains to verify the pipeline.
# "full" uses all MAPS rows with CmdStan variational inference.
# "nuts_check" uses a larger person subset with regular NUTS as a sanity check.
# "full_nuts" is the full posterior target, but it is computationally heavy
# because the model has person-level latent growth and occasion effects.

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[1] else "quick"
if (!mode %in% c("quick", "full", "nuts_check", "full_nuts")) {
  stop("Mode must be one of: quick, full, nuts_check, full_nuts.")
}

data_path <- if (file.exists("longdat_maps_parent_discrim.csv")) {
  "longdat_maps_parent_discrim.csv"
} else {
  "longdat_maps.csv"
}
stan_path <- "maps_mnlfa_poster.stan"
out_dir <- file.path("poster_model_output", mode)
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
dat <- dat[order(dat$person_id, dat$time, dat$item), ]

required <- c(
  "resp", "person_id", "time", "item", "age_c",
  "korean_score", "log_income", "discrim_any"
)
missing_cols <- setdiff(required, names(dat))
if (length(missing_cols) > 0) {
  stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
}

if (mode %in% c("quick", "nuts_check")) {
  n_people <- if (mode == "quick") 80 else 300
  keep_people <- sort(unique(dat$person_id))[seq_len(min(n_people, length(unique(dat$person_id))))]
  dat <- dat[dat$person_id %in% keep_people, ]
  dat$person_id <- as.integer(factor(dat$person_id))
}

if (!"korean_c" %in% names(dat)) {
  dat$korean_c <- as.numeric(scale(dat$korean_score))
}
if (!"income_c" %in% names(dat)) {
  dat$income_c <- as.numeric(scale(dat$log_income))
}
dat$time_c <- as.numeric(scale(dat$time, center = TRUE, scale = FALSE))

predictor_names <- c("age_c", "korean_c", "income_c", "discrim_any")
complete_predictors <- stats::complete.cases(dat[, predictor_names])
if (any(!complete_predictors)) {
  message("Dropping rows with missing DIF predictors: ", sum(!complete_predictors))
  dat <- dat[complete_predictors, ]
  dat$person_id <- as.integer(factor(dat$person_id))
}
X_dif <- as.matrix(dat[, predictor_names])

stan_data <- list(
  Nobs = nrow(dat),
  P = length(unique(dat$item)),
  Ni = length(unique(dat$person_id)),
  D = length(unique(dat$time)),
  K = 5,
  Q = length(predictor_names),
  person = dat$person_id,
  item = dat$item,
  wave = dat$time,
  Y = dat$resp,
  time_score = dat$time_c,
  X_dif = X_dif,
  sigma_loading_dif = 0.20,
  sigma_threshold_dif = 0.35
)

write.csv(
  data.frame(index = seq_along(predictor_names), predictor = predictor_names),
  file.path(out_dir, "predictor_index.csv"),
  row.names = FALSE
)

message("Compiling model: ", stan_path)
model <- cmdstanr::cmdstan_model(stan_path, dir = out_dir)

if (mode == "quick") {
  chains <- 2
  iter_warmup <- 50
  iter_sampling <- 50
  adapt_delta <- 0.90
} else if (mode == "nuts_check") {
  chains <- 4
  iter_warmup <- 300
  iter_sampling <- 300
  adapt_delta <- 0.95
} else if (mode == "full_nuts") {
  chains <- 4
  iter_warmup <- 1000
  iter_sampling <- 1000
  adapt_delta <- 0.95
}

init_fun <- function() {
  list(
    log_loading = rep(0, stan_data$P),
    cutpoint_first = rep(-1.5, stan_data$P),
    log_cutpoint_spacing = matrix(0, nrow = stan_data$P, ncol = stan_data$K - 2),
    loading_dif = matrix(0, nrow = stan_data$P, ncol = stan_data$Q),
    threshold_dif = matrix(0, nrow = stan_data$P, ncol = stan_data$Q),
    mu_slope = 0,
    growth_sd = c(0.7, 0.2),
    growth_cor_chol = diag(2),
    growth_z = matrix(0, nrow = 2, ncol = stan_data$Ni),
    occasion_sd = 0.2,
    occasion_z = matrix(0, nrow = stan_data$D, ncol = stan_data$Ni)
  )
}

message("Estimation mode: ", mode)
if (mode == "full") {
  fit <- model$variational(
    data = stan_data,
    algorithm = "meanfield",
    iter = 15000,
    grad_samples = 1,
    elbo_samples = 50,
    output_samples = 1000,
    adapt_engaged = TRUE,
    seed = 20260513,
    init = init_fun,
    refresh = 250,
    output_dir = out_dir
  )
} else {
  fit <- model$sample(
    data = stan_data,
    chains = chains,
    parallel_chains = chains,
    iter_warmup = iter_warmup,
    iter_sampling = iter_sampling,
    adapt_delta = adapt_delta,
    max_treedepth = 12,
    init = init_fun,
    seed = 20260513,
    refresh = 100,
    output_dir = out_dir
  )
}

fit$save_object(file.path(out_dir, "maps_mnlfa_poster_fit.rds"))

summary_all <- fit$summary()
write.csv(summary_all, file.path(out_dir, "poster_model_summary_all.csv"),
          row.names = FALSE)

key_vars <- c(
  "slope_mean", "slope_variance",
  "growth_sd[1]", "growth_sd[2]",
  "occasion_sd"
)
key_summary <- summary_all[summary_all$variable %in% key_vars, ]
write.csv(key_summary, file.path(out_dir, "latent_trajectory_summary.csv"),
          row.names = FALSE)

summarise_dif <- function(prefix, label) {
  rows <- list()
  idx <- 1
  for (item in seq_len(stan_data$P)) {
    for (pred in seq_along(predictor_names)) {
      var <- paste0(prefix, "[", item, ",", pred, "]")
      one <- summary_all[summary_all$variable == var, ]
      if (nrow(one) == 1) {
        rhat_value <- if ("rhat" %in% names(one)) one$rhat else NA_real_
        ess_value <- if ("ess_bulk" %in% names(one)) one$ess_bulk else NA_real_
        rows[[idx]] <- data.frame(
          parameter_type = label,
          item = item,
          predictor = predictor_names[pred],
          mean = one$mean,
          median = one$median,
          q5 = one$q5,
          q95 = one$q95,
          rhat = rhat_value,
          ess_bulk = ess_value
        )
        idx <- idx + 1
      }
    }
  }
  do.call(rbind, rows)
}

dif_summary <- rbind(
  summarise_dif("loading_dif", "loading"),
  summarise_dif("threshold_dif", "threshold")
)
dif_summary$credible_nonzero_90 <-
  (dif_summary$q5 > 0 & dif_summary$q95 > 0) |
  (dif_summary$q5 < 0 & dif_summary$q95 < 0)
write.csv(dif_summary, file.path(out_dir, "item_dif_summary.csv"),
          row.names = FALSE)

top_dif <- dif_summary[order(abs(dif_summary$mean), decreasing = TRUE), ]
write.csv(head(top_dif, 20), file.path(out_dir, "top_dif_effects.csv"),
          row.names = FALSE)

png(file.path(out_dir, "poster_top_dif_effects.png"),
    width = 2400, height = 1500, res = 220)
plot_dat <- head(top_dif, 16)
plot_dat$label <- paste0("Item ", plot_dat$item, "\n",
                         plot_dat$parameter_type, ": ",
                         plot_dat$predictor)
cols <- ifelse(plot_dat$credible_nonzero_90, "#1B9E77", "#777777")
op <- par(mar = c(8, 4, 2, 1))
bp <- barplot(
  plot_dat$mean,
  names.arg = plot_dat$label,
  las = 2,
  col = cols,
  ylab = "Posterior mean",
  main = "Largest estimated DIF effects"
)
arrows(bp, plot_dat$q5, bp, plot_dat$q95, angle = 90, code = 3, length = 0.04)
abline(h = 0, lty = 2)
legend("topright",
       legend = c("90% CrI excludes 0", "90% CrI overlaps 0"),
       fill = c("#1B9E77", "#777777"), bty = "n")
par(op)
dev.off()

message("Done. Main outputs:")
message("  ", file.path(out_dir, "latent_trajectory_summary.csv"))
message("  ", file.path(out_dir, "item_dif_summary.csv"))
message("  ", file.path(out_dir, "top_dif_effects.csv"))
message("  ", file.path(out_dir, "poster_top_dif_effects.png"))
