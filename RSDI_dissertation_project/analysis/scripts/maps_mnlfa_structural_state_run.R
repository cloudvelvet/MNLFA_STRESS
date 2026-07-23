# Run an alternative MAPS longitudinal ordinal MNLFA that lets covariates
# predict both the latent state and item parameters.
#
# Usage:
#   Rscript maps_mnlfa_structural_state_run.R quick 20260702
#   Rscript maps_mnlfa_structural_state_run.R full 20260702
#   Rscript maps_mnlfa_structural_state_run.R nuts_check 20260702
#   Rscript maps_mnlfa_structural_state_run.R full_nuts_light 20260702

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[1] else "quick"
seed <- if (length(args) >= 2) as.integer(args[2]) else 20260702L
drop_items_arg <- if (length(args) >= 3) args[3] else ""
drop_items_arg <- sub("^drop=", "", drop_items_arg)
drop_items <- if (nzchar(drop_items_arg) && tolower(drop_items_arg) != "none") {
  suppressWarnings(as.integer(strsplit(drop_items_arg, ",", fixed = TRUE)[[1]]))
} else {
  integer()
}
drop_items <- sort(unique(drop_items[!is.na(drop_items)]))
if (is.na(seed)) {
  stop("Seed must be an integer.")
}
if (!mode %in% c("quick", "full", "nuts_check", "full_nuts_light")) {
  stop("Mode must be one of: quick, full, nuts_check, full_nuts_light.")
}

data_path <- if (file.exists("longdat_maps_parent_discrim.csv")) {
  "longdat_maps_parent_discrim.csv"
} else {
  "longdat_maps.csv"
}
stan_path <- "maps_mnlfa_structural_state.stan"
drop_suffix <- if (length(drop_items) > 0) {
  paste0("_drop", paste(drop_items, collapse = ""))
} else {
  ""
}
out_dir <- file.path("poster_model_output", paste0("structural_state_", mode, "_seed", seed, drop_suffix))
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

if (!requireNamespace("cmdstanr", quietly = TRUE)) {
  stop("Package 'cmdstanr' is required.")
}
if (!requireNamespace("posterior", quietly = TRUE)) {
  stop("Package 'posterior' is required.")
}

library(cmdstanr)
library(posterior)

known_cmdstan_paths <- unique(c(
  Sys.getenv("CMDSTAN"),
  "C:/chen_bauer_2024/cmdstan/cmdstan-2.39.0",
  "C:/cmdstan/cmdstan-2.38.0",
  "C:/cmdstan-2.38.0/cmdstan-2.38.0"
))
known_cmdstan_paths <- known_cmdstan_paths[nzchar(known_cmdstan_paths)]
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

if (length(drop_items) > 0) {
  message("Dropping original items: ", paste(drop_items, collapse = ", "))
  dat <- dat[!dat$item %in% drop_items, ]
  if (nrow(dat) == 0) {
    stop("No rows remain after dropping requested items.")
  }
}
item_mapping <- data.frame(
  item = seq_along(sort(unique(dat$item))),
  original_item = sort(unique(dat$item))
)
dat$item <- item_mapping$item[match(dat$item, item_mapping$original_item)]

if (mode %in% c("quick", "nuts_check", "full_nuts_light")) {
  n_people <- switch(
    mode,
    quick = 80,
    nuts_check = 300,
    full_nuts_light = 600
  )
  set.seed(seed)
  all_people <- sort(unique(dat$person_id))
  keep_people <- sort(sample(all_people, min(n_people, length(all_people))))
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

dif_predictor_names <- c("age_c", "korean_c", "income_c", "discrim_any")
complete_predictors <- stats::complete.cases(dat[, dif_predictor_names])
if (any(!complete_predictors)) {
  message("Dropping rows with missing DIF predictors: ", sum(!complete_predictors))
  dat <- dat[complete_predictors, ]
  dat$person_id <- as.integer(factor(dat$person_id))
}

add_state_predictors <- function(dat) {
  dat$row_id_for_merge <- seq_len(nrow(dat))
  person_wave <- unique(dat[, c(
    "person_id", "time", "age_c", "korean_c", "income_c", "discrim_any"
  )])

  between <- stats::aggregate(
    cbind(age_c, korean_c, income_c, discrim_any) ~ person_id,
    data = person_wave,
    FUN = function(x) mean(x, na.rm = TRUE)
  )
  names(between) <- c(
    "person_id", "age_between", "korean_between",
    "income_between", "discrim_between"
  )

  dat <- merge(dat, between, by = "person_id", all.x = TRUE, sort = FALSE)
  dat <- dat[order(dat$row_id_for_merge), ]
  dat$row_id_for_merge <- NULL

  dat$korean_within <- dat$korean_c - dat$korean_between
  dat$income_within <- dat$income_c - dat$income_between
  dat$discrim_within <- dat$discrim_any - dat$discrim_between
  dat
}

dat <- add_state_predictors(dat)
state_predictor_names <- c(
  "age_between",
  "korean_between", "korean_within",
  "income_between", "income_within",
  "discrim_between", "discrim_within"
)

complete_state <- stats::complete.cases(dat[, state_predictor_names])
if (any(!complete_state)) {
  message("Dropping rows with missing latent-state predictors: ", sum(!complete_state))
  dat <- dat[complete_state, ]
  dat$person_id <- as.integer(factor(dat$person_id))
}

X_dif <- as.matrix(dat[, dif_predictor_names])
X_state <- as.matrix(dat[, state_predictor_names])

stan_data <- list(
  Nobs = nrow(dat),
  P = length(unique(dat$item)),
  Ni = length(unique(dat$person_id)),
  D = length(unique(dat$time)),
  K = 5,
  Q = length(dif_predictor_names),
  S = length(state_predictor_names),
  person = dat$person_id,
  item = dat$item,
  wave = dat$time,
  Y = dat$resp,
  time_score = dat$time_c,
  X_dif = X_dif,
  X_state = X_state,
  sigma_loading_dif = 0.20,
  sigma_threshold_dif = 0.35,
  sigma_state_effect = 0.35
)

write.csv(
  data.frame(index = seq_along(dif_predictor_names), predictor = dif_predictor_names),
  file.path(out_dir, "predictor_index.csv"),
  row.names = FALSE
)
write.csv(
  data.frame(index = seq_along(state_predictor_names), predictor = state_predictor_names),
  file.path(out_dir, "state_predictor_index.csv"),
  row.names = FALSE
)
write.csv(
  data.frame(
    mode = mode,
    seed = seed,
    dropped_original_items = if (length(drop_items) > 0) paste(drop_items, collapse = ",") else "",
    persons = stan_data$Ni,
    observations = stan_data$Nobs,
    items = stan_data$P,
    waves = stan_data$D
  ),
  file.path(out_dir, "run_metadata.csv"),
  row.names = FALSE
)
write.csv(item_mapping, file.path(out_dir, "item_mapping.csv"), row.names = FALSE)

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
} else if (mode == "full_nuts_light") {
  chains <- 4
  iter_warmup <- 500
  iter_sampling <- 500
  adapt_delta <- 0.95
}

init_fun <- function() {
  list(
    log_loading = rep(0, stan_data$P),
    cutpoint_first = rep(-1.5, stan_data$P),
    log_cutpoint_spacing = matrix(0, nrow = stan_data$P, ncol = stan_data$K - 2),
    loading_dif = matrix(0, nrow = stan_data$P, ncol = stan_data$Q),
    threshold_dif = matrix(0, nrow = stan_data$P, ncol = stan_data$Q),
    state_effect = rep(0, stan_data$S),
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
    seed = seed,
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
    seed = seed,
    refresh = 100,
    output_dir = out_dir
  )
}

fit$save_object(file.path(out_dir, "maps_mnlfa_structural_state_fit.rds"))

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

summarise_matrix <- function(prefix, label, predictor_names) {
  rows <- list()
  idx <- 1
  for (item in seq_len(stan_data$P)) {
    for (pred in seq_along(predictor_names)) {
      var <- paste0(prefix, "[", item, ",", pred, "]")
      one <- summary_all[summary_all$variable == var, ]
      if (nrow(one) == 1) {
        rows[[idx]] <- data.frame(
          parameter_type = label,
          item = item,
          predictor = predictor_names[pred],
          mean = one$mean,
          median = one$median,
          q5 = one$q5,
          q95 = one$q95,
          rhat = if ("rhat" %in% names(one)) one$rhat else NA_real_,
          ess_bulk = if ("ess_bulk" %in% names(one)) one$ess_bulk else NA_real_
        )
        idx <- idx + 1
      }
    }
  }
  do.call(rbind, rows)
}

dif_summary <- rbind(
  summarise_matrix("loading_dif", "loading", dif_predictor_names),
  summarise_matrix("threshold_dif", "threshold", dif_predictor_names)
)
dif_summary$original_item <- item_mapping$original_item[match(dif_summary$item, item_mapping$item)]
dif_summary <- dif_summary[, c(
  "parameter_type", "item", "original_item", "predictor",
  setdiff(names(dif_summary), c("parameter_type", "item", "original_item", "predictor"))
)]
dif_summary$credible_nonzero_90 <-
  (dif_summary$q5 > 0 & dif_summary$q95 > 0) |
  (dif_summary$q5 < 0 & dif_summary$q95 < 0)
write.csv(dif_summary, file.path(out_dir, "item_dif_summary.csv"),
          row.names = FALSE)

state_rows <- lapply(seq_along(state_predictor_names), function(s) {
  var <- paste0("state_effect[", s, "]")
  one <- summary_all[summary_all$variable == var, ]
  data.frame(
    predictor = state_predictor_names[s],
    mean = one$mean,
    median = one$median,
    q5 = one$q5,
    q95 = one$q95,
    rhat = if ("rhat" %in% names(one)) one$rhat else NA_real_,
    ess_bulk = if ("ess_bulk" %in% names(one)) one$ess_bulk else NA_real_
  )
})
state_summary <- do.call(rbind, state_rows)
state_summary$credible_nonzero_90 <-
  (state_summary$q5 > 0 & state_summary$q95 > 0) |
  (state_summary$q5 < 0 & state_summary$q95 < 0)
write.csv(state_summary, file.path(out_dir, "state_effect_summary.csv"),
          row.names = FALSE)

top_dif <- dif_summary[order(abs(dif_summary$mean), decreasing = TRUE), ]
write.csv(head(top_dif, 20), file.path(out_dir, "top_dif_effects.csv"),
          row.names = FALSE)

png(file.path(out_dir, "poster_top_dif_effects.png"),
    width = 2400, height = 1500, res = 220)
plot_dat <- head(top_dif, 16)
plot_item <- if ("original_item" %in% names(plot_dat)) plot_dat$original_item else plot_dat$item
plot_dat$label <- paste0("Item ", plot_item, "\n",
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
  main = "Largest estimated residual DIF effects"
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
message("  ", file.path(out_dir, "state_effect_summary.csv"))
message("  ", file.path(out_dir, "item_dif_summary.csv"))
message("  ", file.path(out_dir, "top_dif_effects.csv"))
