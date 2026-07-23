# Run the stable anchor-identified structural-state MNLFA.
# Usage from C:/chen_bauer_2024:
# Rscript RSDI_dissertation_project/analysis/scripts/maps_mnlfa_structural_state_anchored_stable_run.R quick 20260724 80 3,4,5

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[[1]] else "quick"
seed <- if (length(args) >= 2) as.integer(args[[2]]) else 20260724L
n_people <- if (length(args) >= 3) as.integer(args[[3]]) else 80L
anchor_arg <- if (length(args) >= 4) args[[4]] else "3,4,5"
anchors <- sort(unique(as.integer(strsplit(anchor_arg, ",", fixed = TRUE)[[1]])))
if (!mode %in% c("quick", "nuts")) stop("mode must be quick or nuts")
if (length(anchors) < 2) stop("at least two anchors required")

root <- normalizePath("C:/chen_bauer_2024", mustWork = TRUE)
project <- file.path(root, "RSDI_dissertation_project")
data_path <- file.path(root, "longdat_maps_parent_discrim.csv")
stan_path <- file.path(project, "analysis", "stan", "maps_mnlfa_structural_state_anchored_stable.stan")
out_dir <- file.path(root, "poster_model_output", paste0("structural_state_anchored_stable_", mode, "_seed", seed, "_n", n_people, "_a", paste(anchors, collapse = "")))
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

library(cmdstanr)
library(posterior)
cmdstanr::set_cmdstan_path(file.path(root, "cmdstan", "cmdstan-2.39.0"))

dat <- read.csv(data_path)
dat <- dat[order(dat$person_id, dat$time, dat$item), , drop = FALSE]
set.seed(seed)
keep <- sort(sample(unique(dat$person_id), min(n_people, length(unique(dat$person_id)))))
dat <- dat[dat$person_id %in% keep, , drop = FALSE]
dat$person_id <- as.integer(factor(dat$person_id))
if (!"korean_c" %in% names(dat)) dat$korean_c <- as.numeric(scale(dat$korean_score))
if (!"income_c" %in% names(dat)) dat$income_c <- as.numeric(scale(dat$log_income))
dat$time_c <- as.numeric(scale(dat$time, center = TRUE, scale = FALSE))
dif_names <- c("age_c", "korean_c", "income_c", "discrim_any")
dat <- dat[complete.cases(dat[, dif_names, drop = FALSE]), , drop = FALSE]

person_wave <- unique(dat[, c("person_id", "time", "age_c", "korean_c", "income_c", "discrim_any")])
between <- aggregate(cbind(age_c, korean_c, income_c, discrim_any) ~ person_id, person_wave, mean, na.rm = TRUE)
names(between) <- c("person_id", "age_between", "korean_between", "income_between", "discrim_between")
dat <- merge(dat, between, by = "person_id", all.x = TRUE, sort = FALSE)
dat <- dat[order(dat$person_id, dat$time, dat$item), , drop = FALSE]
dat$korean_within <- dat$korean_c - dat$korean_between
dat$income_within <- dat$income_c - dat$income_between
dat$discrim_within <- dat$discrim_any - dat$discrim_between
state_names <- c("age_between", "korean_between", "korean_within", "income_between", "income_within", "discrim_between", "discrim_within")
dat <- dat[complete.cases(dat[, state_names, drop = FALSE]), , drop = FALSE]
dat$person_id <- as.integer(factor(dat$person_id))

orig_items <- sort(unique(dat$item))
if (!all(anchors %in% orig_items)) stop("anchor outside items")
dat$item <- match(dat$item, orig_items)
P <- length(orig_items)
nonanchors <- setdiff(seq_len(P), anchors)
free_index <- integer(P); free_index[nonanchors] <- seq_along(nonanchors)
X_dif <- as.matrix(dat[, dif_names, drop = FALSE])
X_state <- as.matrix(dat[, state_names, drop = FALSE])
stan_data <- list(Nobs=nrow(dat), P=P, P_free=length(nonanchors), Ni=length(unique(dat$person_id)), D=length(unique(dat$time)), K=5, Q=ncol(X_dif), S=ncol(X_state), A=length(anchors), person=dat$person_id, item=dat$item, wave=dat$time, Y=dat$resp, time_score=dat$time_c, X_dif=X_dif, X_state=X_state, anchor_item=anchors, nonanchor_index=free_index, sigma_loading_dif=0.15, sigma_threshold_dif=0.25, sigma_state_effect=0.35)
write.csv(data.frame(seed=seed,mode=mode,n_people=stan_data$Ni,n_obs=stan_data$Nobs,anchors=paste(anchors,collapse=","),stan=basename(stan_path)), file.path(out_dir,"run_metadata.csv"), row.names=FALSE)

model <- cmdstan_model(stan_path, dir=out_dir, quiet=TRUE)
init_fun <- function() list(log_loading_free=rep(0,length(nonanchors)), loading_dif_free=matrix(0,length(nonanchors),ncol(X_dif)), threshold_dif_free=matrix(0,length(nonanchors),ncol(X_dif)), state_effect=rep(0,ncol(X_state)), cutpoint_first_raw=rep(-1.1,P), cutpoint_spacing_raw=matrix(1.15,P,3), mu_slope=0, growth_sd=c(0.7,0.2), growth_cor_chol=diag(2), growth_z=matrix(0,2,stan_data$Ni), occasion_sd=0.2, occasion_z=matrix(0,stan_data$D,stan_data$Ni))
if (mode == "quick") {
  fit <- model$sample(data=stan_data, chains=2, parallel_chains=2, iter_warmup=150, iter_sampling=150, adapt_delta=.97, max_treedepth=13, seed=seed, init=init_fun, refresh=50, output_dir=out_dir)
} else {
  fit <- model$sample(data=stan_data, chains=4, parallel_chains=4, iter_warmup=750, iter_sampling=750, adapt_delta=.98, max_treedepth=14, seed=seed, init=init_fun, refresh=100, output_dir=out_dir)
}
fit$save_object(file.path(out_dir,"anchored_stable_fit.rds"))
write.csv(fit$summary(), file.path(out_dir,"posterior_summary.csv"), row.names=FALSE)
writeLines(capture.output(fit$diagnostic_summary()), file.path(out_dir,"diagnostic_summary.txt"))
message("saved: ", out_dir)
