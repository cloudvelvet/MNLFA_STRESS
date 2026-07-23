# Calibrate the anchor-identified, no-clamp structural-state MNLFA.
#
# This script intentionally writes to the shared C:/chen_bauer_2024 output
# root so that its provenance is separate from the legacy exploratory runs.
# Usage from C:/chen_bauer_2024:
#   Rscript RSDI_dissertation_project/analysis/scripts/maps_mnlfa_structural_state_anchored_run.R quick 20260720 80 3,4,5
#   Rscript RSDI_dissertation_project/analysis/scripts/maps_mnlfa_structural_state_anchored_run.R nuts 20260720 300 3,4,5

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[[1]] else "quick"
seed <- if (length(args) >= 2) as.integer(args[[2]]) else 20260720L
n_people <- if (length(args) >= 3) as.integer(args[[3]]) else 80L
anchor_arg <- if (length(args) >= 4) args[[4]] else "3,4,5"
anchors <- sort(unique(as.integer(strsplit(anchor_arg, ",", fixed = TRUE)[[1]])))

if (!mode %in% c("quick", "nuts")) stop("mode must be quick or nuts")
if (is.na(seed) || is.na(n_people) || n_people < 1) stop("invalid seed or n_people")
if (length(anchors) < 2) stop("at least two anchor items are required")

root <- normalizePath("C:/chen_bauer_2024", mustWork = TRUE)
project <- file.path(root, "RSDI_dissertation_project")
data_path <- file.path(root, "longdat_maps_parent_discrim.csv")
stan_path <- file.path(project, "analysis", "stan", "maps_mnlfa_structural_state_anchored_v2.stan")
out_dir <- file.path(root, "poster_model_output", paste0("structural_state_anchored_", mode, "_seed", seed, "_n", n_people, "_a", paste(anchors, collapse = "")))
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

if (!requireNamespace("cmdstanr", quietly = TRUE)) stop("cmdstanr is required")
if (!requireNamespace("posterior", quietly = TRUE)) stop("posterior is required")
library(cmdstanr)
library(posterior)
cmdstanr::set_cmdstan_path(file.path(root, "cmdstan", "cmdstan-2.39.0"))

dat <- read.csv(data_path)
dat <- dat[order(dat$person_id, dat$time, dat$item), , drop = FALSE]
required <- c("resp", "person_id", "time", "item", "age_c", "korean_score", "log_income", "discrim_any")
missing_cols <- setdiff(required, names(dat))
if (length(missing_cols)) stop("missing: ", paste(missing_cols, collapse = ", "))

all_people <- sort(unique(dat$person_id))
set.seed(seed)
keep_people <- sort(sample(all_people, min(n_people, length(all_people))))
dat <- dat[dat$person_id %in% keep_people, , drop = FALSE]
dat$person_id <- as.integer(factor(dat$person_id))

if (!"korean_c" %in% names(dat)) dat$korean_c <- as.numeric(scale(dat$korean_score))
if (!"income_c" %in% names(dat)) dat$income_c <- as.numeric(scale(dat$log_income))
dat$time_c <- as.numeric(scale(dat$time, center = TRUE, scale = FALSE))
dif_names <- c("age_c", "korean_c", "income_c", "discrim_any")
complete <- complete.cases(dat[, dif_names, drop = FALSE])
dat <- dat[complete, , drop = FALSE]
dat$person_id <- as.integer(factor(dat$person_id))

person_wave <- unique(dat[, c("person_id", "time", "age_c", "korean_c", "income_c", "discrim_any")])
between <- aggregate(cbind(age_c, korean_c, income_c, discrim_any) ~ person_id, person_wave, mean, na.rm = TRUE)
names(between) <- c("person_id", "age_between", "korean_between", "income_between", "discrim_between")
dat <- merge(dat, between, by = "person_id", all.x = TRUE, sort = FALSE)
dat <- dat[order(dat$person_id, dat$time, dat$item), , drop = FALSE]
dat$korean_within <- dat$korean_c - dat$korean_between
dat$income_within <- dat$income_c - dat$income_between
dat$discrim_within <- dat$discrim_any - dat$discrim_between

state_names <- c("age_between", "korean_between", "korean_within", "income_between", "income_within", "discrim_between", "discrim_within")
state_complete <- complete.cases(dat[, state_names, drop = FALSE])
dat <- dat[state_complete, , drop = FALSE]
dat$person_id <- as.integer(factor(dat$person_id))

orig_items <- sort(unique(dat$item))
dat$item <- match(dat$item, orig_items)
P <- length(orig_items)
if (any(!anchors %in% orig_items)) stop("anchor item outside observed item range")
nonanchors <- setdiff(seq_len(P), anchors)
nonanchor_index <- integer(P)
nonanchor_index[nonanchors] <- seq_along(nonanchors)

X_dif <- as.matrix(dat[, dif_names, drop = FALSE])
X_state <- as.matrix(dat[, state_names, drop = FALSE])
stan_data <- list(
  Nobs = nrow(dat), P = P, P_free = length(nonanchors), Ni = length(unique(dat$person_id)),
  D = length(unique(dat$time)), K = 5, Q = ncol(X_dif), S = ncol(X_state), A = length(anchors),
  person = dat$person, item = dat$item, wave = dat$time, Y = dat$resp,
  time_score = dat$time_c, X_dif = X_dif, X_state = X_state,
  anchor_item = anchors, nonanchor_index = nonanchor_index,
  sigma_loading_dif = 0.15, sigma_threshold_dif = 0.25, sigma_state_effect = 0.35
)

write.csv(data.frame(seed = seed, mode = mode, n_people = stan_data$Ni, n_obs = stan_data$Nobs,
                     anchors = paste(anchors, collapse = ","), source = normalizePath(data_path)),
          file.path(out_dir, "run_metadata.csv"), row.names = FALSE)
write.csv(data.frame(item = seq_len(P), original_item = orig_items,
                     anchor = seq_len(P) %in% anchors,
                     free_index = nonanchor_index),
          file.path(out_dir, "item_mapping.csv"), row.names = FALSE)

model <- cmdstanr::cmdstan_model(stan_path, dir = out_dir, quiet = TRUE)
init_fun <- function() list(
  log_loading_free = rep(0, length(nonanchors)),
  loading_dif_free = matrix(0, nrow = length(nonanchors), ncol = ncol(X_dif)),
  threshold_dif_free = matrix(0, nrow = length(nonanchors), ncol = ncol(X_dif)),
  state_effect = rep(0, ncol(X_state)),
  raw_cutpoint_first = rep(0, P),
  raw_cutpoint_spacing = matrix(0, nrow = P, ncol = 3),
  mu_slope = 0, growth_sd = c(0.7, 0.2), growth_cor_chol = diag(2),
  growth_z = matrix(0, nrow = 2, ncol = stan_data$Ni),
  occasion_sd = 0.2, occasion_z = matrix(0, nrow = stan_data$D, ncol = stan_data$Ni)
)

if (mode == "quick") {
  fit <- model$sample(data = stan_data, chains = 2, parallel_chains = 2,
                      iter_warmup = 100, iter_sampling = 100, adapt_delta = 0.95,
                      max_treedepth = 12, seed = seed, init = init_fun,
                      refresh = 50, output_dir = out_dir)
} else {
  fit <- model$sample(data = stan_data, chains = 4, parallel_chains = 4,
                      iter_warmup = 500, iter_sampling = 500, adapt_delta = 0.95,
                      max_treedepth = 13, seed = seed, init = init_fun,
                      refresh = 100, output_dir = out_dir)
}

fit$save_object(file.path(out_dir, "anchored_fit.rds"))
summary_all <- fit$summary()
write.csv(summary_all, file.path(out_dir, "anchored_posterior_summary.csv"), row.names = FALSE)
writeLines(capture.output(fit$diagnostic_summary()), file.path(out_dir, "diagnostic_summary.txt"))
message("saved: ", out_dir)
