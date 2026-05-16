# MAPS-style longitudinal MNLFA simulation using Stan fixed-parameter sampling.
# Outputs are designed for poster figures and for reuse with the existing
# GRM/SSP Stan estimation scripts in this folder.

set.seed(20260513)

rstan_path <- "maps_simulate_grm_mnlfa.stan"
data_path <- "longdat_maps.csv"
out_dir <- "simulation_output"
tmp_dir <- file.path(getwd(), "rstan_tmp")

dir.create(tmp_dir, showWarnings = FALSE)
Sys.setenv(
  TMPDIR = tmp_dir,
  TMP = tmp_dir,
  TEMP = tmp_dir,
  LANG = "en_US.UTF-8",
  LC_ALL = "en_US.UTF-8"
)

dir.create(out_dir, showWarnings = FALSE)

message("Reading MAPS structure from: ", data_path)
template <- read.csv(data_path)

needed <- c(
  "ID", "Wave", "age_c", "age_sq", "nation", "item_name", "item",
  "person_id", "time", "nat2", "nat3", "nat5", "nat6", "nat7", "nat8"
)
missing_cols <- setdiff(needed, names(template))
if (length(missing_cols) > 0) {
  stop("Missing required columns in longdat_maps.csv: ",
       paste(missing_cols, collapse = ", "))
}

template <- template[order(template$person_id, template$time, template$item), ]

Nobs <- nrow(template)
P <- length(unique(template$item))
Ni <- length(unique(template$person_id))
D <- length(unique(template$time))
K <- 5

if (!identical(sort(unique(template$item)), seq_len(P))) {
  stop("Item IDs must be consecutive integers starting at 1.")
}
if (!identical(sort(unique(template$person_id)), seq_len(Ni))) {
  stop("person_id must be consecutive integers starting at 1.")
}

Xf <- as.matrix(template[, c("nat2", "nat3", "nat5", "nat6", "nat7", "nat8")])
Xtv <- as.matrix(template[, c("age_c", "age_sq")])

# True parameters: chosen to resemble the observed MAPS response distribution
# while creating a small, clear DIF signal for poster demonstration.
true <- list(
  Lp = c(1.15, 1.00, 1.25, 0.95, 1.10, 1.05, 1.20, 0.90),
  cutpoints = rbind(
    c(-2.10, -0.60, 0.85, 2.15),
    c(-1.80, -0.35, 1.00, 2.35),
    c(-1.95, -0.45, 0.95, 2.30),
    c(-1.65, -0.20, 1.15, 2.50),
    c(-1.85, -0.30, 1.05, 2.45),
    c(-1.70, -0.25, 1.10, 2.55),
    c(-2.00, -0.55, 0.90, 2.25),
    c(-1.55, -0.10, 1.25, 2.65)
  ),
  Ldiftv1 = c(0.00, 0.00, 0.28, 0.00, 0.00, 0.00, -0.22, 0.00),
  Ldiftv2 = c(0.00, 0.00, 0.00, 0.18, 0.00, 0.00, 0.00, 0.00),
  Ldiff =   c(0.00, 0.25, 0.00, 0.00, 0.00, -0.20, 0.00, 0.00),
  Ndiftv1 = c(0.00, 0.00, -0.25, 0.00, 0.00, 0.00, 0.20, 0.00),
  Ndiftv2 = c(0.00, 0.00, 0.00, -0.18, 0.00, 0.00, 0.00, 0.00),
  Ndiff =   c(0.00, -0.30, 0.00, 0.00, 0.00, 0.25, 0.00, 0.00),
  mu_intercept = -0.20,
  mu_slope = 0.12,
  b_mu_nat2 = c(0.25, -0.05),
  phi_int = 0.80,
  phi_slp = 0.25,
  phi_corr = 0.20,
  occasion_sd = 0.35
)

make_stan_data <- function(with_dif = TRUE) {
  dif_scale <- if (with_dif) 1 else 0
  list(
    Nobs = Nobs, P = P, Ni = Ni, D = D, K = K,
    person = template$person_id,
    itm = template$item,
    time = template$time,
    NFpreds = ncol(Xf),
    Ntvpreds = ncol(Xtv),
    Xf = Xf,
    Xtv = Xtv,
    Lp = true$Lp,
    cutpoints = true$cutpoints,
    Ldiftv1 = true$Ldiftv1 * dif_scale,
    Ldiftv2 = true$Ldiftv2 * dif_scale,
    Ldiff = true$Ldiff * dif_scale,
    Ndiftv1 = true$Ndiftv1 * dif_scale,
    Ndiftv2 = true$Ndiftv2 * dif_scale,
    Ndiff = true$Ndiff * dif_scale,
    mu_intercept = true$mu_intercept,
    mu_slope = true$mu_slope,
    b_mu_nat2 = true$b_mu_nat2,
    phi_int = true$phi_int,
    phi_slp = true$phi_slp,
    phi_corr = true$phi_corr,
    occasion_sd = true$occasion_sd
  )
}

use_cmdstan <- requireNamespace("cmdstanr", quietly = TRUE)
if (use_cmdstan) {
  library(cmdstanr)
  known_cmdstan_paths <- c(
    "C:/cmdstan/cmdstan-2.38.0",
    "C:/cmdstan-2.38.0/cmdstan-2.38.0"
  )
  current_cmdstan_path <- tryCatch(cmdstanr::cmdstan_path(), error = function(e) "")
  if (!nzchar(current_cmdstan_path)) {
    found <- known_cmdstan_paths[dir.exists(known_cmdstan_paths)]
    if (length(found) > 0) {
      cmdstanr::set_cmdstan_path(found[1])
    } else {
      use_cmdstan <- FALSE
    }
  }
}

if (use_cmdstan) {
  message("Compiling Stan simulator with CmdStanR: ", rstan_path)
  model <- cmdstanr::cmdstan_model(rstan_path, dir = out_dir)
} else {
  if (!requireNamespace("rstan", quietly = TRUE)) {
    stop("Package 'cmdstanr' or 'rstan' is required to run this script.")
  }
  message("Compiling Stan simulator with RStan: ", rstan_path)
  rstan::rstan_options(auto_write = TRUE)
  model <- rstan::stan_model(file = rstan_path)
}

simulate_condition <- function(label, with_dif, seed) {
  message("Simulating condition: ", label)
  stan_data <- make_stan_data(with_dif)
  if (use_cmdstan) {
    fit <- model$sample(
      data = stan_data,
      fixed_param = TRUE,
      chains = 1,
      parallel_chains = 1,
      iter_warmup = 0,
      iter_sampling = 1,
      seed = seed,
      refresh = 0,
      output_dir = out_dir
    )
    y <- as.integer(fit$draws(variables = "Y_sim", format = "draws_matrix")[1, ])
  } else {
    fit <- rstan::sampling(
      model,
      data = stan_data,
      algorithm = "Fixed_param",
      chains = 1,
      iter = 1,
      warmup = 0,
      seed = seed,
      refresh = 0
    )
    y <- as.integer(rstan::extract(fit, pars = "Y_sim")$Y_sim[1, ])
  }
  out <- template
  out$resp_observed <- out$resp
  out$resp <- y
  out$condition <- label
  out
}

sim_dif <- simulate_condition("with_dif", TRUE, 20260513)
sim_nodif <- simulate_condition("no_dif", FALSE, 20260514)

write.csv(sim_dif, file.path(out_dir, "longdat_maps_simulated_with_dif.csv"),
          row.names = FALSE)
write.csv(sim_nodif, file.path(out_dir, "longdat_maps_simulated_no_dif.csv"),
          row.names = FALSE)
write.csv(rbind(sim_dif, sim_nodif),
          file.path(out_dir, "longdat_maps_simulated_both_conditions.csv"),
          row.names = FALSE)

truth <- data.frame(
  item = seq_len(P),
  item_name = paste0("p_accul_str_0", seq_len(P)),
  Lp = true$Lp,
  Ldiftv_age = true$Ldiftv1,
  Ldiftv_age_sq = true$Ldiftv2,
  Ldiff_nat2 = true$Ldiff,
  Ndiftv_age = true$Ndiftv1,
  Ndiftv_age_sq = true$Ndiftv2,
  Ndiff_nat2 = true$Ndiff
)
truth$has_DIF <- rowSums(abs(truth[, 4:9])) > 0
write.csv(truth, file.path(out_dir, "simulation_true_dif_parameters.csv"),
          row.names = FALSE)

summarise_condition <- function(dat) {
  aggregate(resp ~ condition + time + item, data = dat, FUN = mean)
}

summary_both <- rbind(summarise_condition(sim_dif), summarise_condition(sim_nodif))
write.csv(summary_both,
          file.path(out_dir, "simulation_mean_response_by_time_item.csv"),
          row.names = FALSE)

observed <- template
observed$condition <- "observed"
observed$resp_observed <- observed$resp

compare_dat <- rbind(
  observed[, names(sim_dif)],
  sim_dif,
  sim_nodif
)

compare_summary <- aggregate(
  resp ~ condition + time + item,
  data = compare_dat,
  FUN = mean
)
write.csv(compare_summary,
          file.path(out_dir, "observed_vs_simulated_mean_response.csv"),
          row.names = FALSE)

overall_summary <- do.call(
  rbind,
  lapply(split(compare_dat, compare_dat$condition), function(x) {
    data.frame(
      condition = x$condition[1],
      n = nrow(x),
      mean_resp = mean(x$resp),
      sd_resp = stats::sd(x$resp),
      prop_1 = mean(x$resp == 1),
      prop_2 = mean(x$resp == 2),
      prop_3 = mean(x$resp == 3),
      prop_4 = mean(x$resp == 4),
      prop_5 = mean(x$resp == 5)
    )
  })
)
write.csv(overall_summary,
          file.path(out_dir, "observed_vs_simulated_overall_summary.csv"),
          row.names = FALSE)

poster_png <- file.path(out_dir, "poster_simulation_summary.png")
png(poster_png, width = 2400, height = 1400, res = 220)
op <- par(mfrow = c(1, 2), mar = c(4.2, 4.2, 2.5, 1), oma = c(0, 0, 2, 0))

plot_means <- function(dat, title_text) {
  means <- aggregate(resp ~ time + item, data = dat, FUN = mean)
  y_range <- range(means$resp)
  plot(NA, xlim = range(means$time), ylim = y_range,
       xlab = "Wave", ylab = "Mean simulated response",
       main = title_text, xaxt = "n")
  axis(1, at = sort(unique(means$time)))
  cols <- grDevices::hcl.colors(P, "Dark 3")
  for (i in seq_len(P)) {
    one <- means[means$item == i, ]
    lines(one$time, one$resp, type = "b", pch = 15 + i %% 6,
          col = cols[i], lwd = 2)
  }
  legend("topright", legend = paste("Item", seq_len(P)), col = cols,
         pch = 15 + seq_len(P) %% 6, lwd = 2, cex = 0.75, bty = "n")
}

plot_means(sim_nodif, "No DIF condition")
plot_means(sim_dif, "DIF condition")
mtext("MAPS GRM-MNLFA Stan simulation", outer = TRUE, cex = 1.2, font = 2)
par(op)
dev.off()

comparison_png <- file.path(out_dir, "poster_observed_vs_simulated.png")
png(comparison_png, width = 2600, height = 1500, res = 220)
op <- par(mfrow = c(1, 2), mar = c(4.2, 4.2, 2.7, 1), oma = c(0, 0, 2, 0))

plot_compare_trajectories <- function() {
  means <- compare_summary
  y_range <- range(means$resp)
  plot(NA, xlim = range(means$time), ylim = y_range,
       xlab = "Wave", ylab = "Mean response",
       main = "Observed vs simulated trajectories", xaxt = "n")
  axis(1, at = sort(unique(means$time)))

  cols <- c(observed = "black", with_dif = "#1B9E77", no_dif = "#D95F02")
  ltys <- c(observed = 1, with_dif = 2, no_dif = 3)
  for (cond in c("observed", "with_dif", "no_dif")) {
    cond_mean <- aggregate(resp ~ time, means[means$condition == cond, ], mean)
    lines(cond_mean$time, cond_mean$resp, type = "b",
          col = cols[cond], lty = ltys[cond], pch = 16, lwd = 2.5)
  }
  legend("bottomright",
         legend = c("Observed MAPS", "Simulated DIF", "Simulated no DIF"),
         col = cols, lty = ltys, pch = 16, lwd = 2.5, bty = "n")
}

plot_response_distribution <- function() {
  props <- prop.table(table(compare_dat$resp, compare_dat$condition), 2)
  barplot(props[, c("observed", "with_dif", "no_dif")],
          beside = TRUE,
          col = grDevices::hcl.colors(K, "BluYl"),
          ylim = c(0, max(props) * 1.18),
          xlab = "Condition",
          ylab = "Proportion",
          main = "Response-category distribution",
          names.arg = c("Observed", "DIF", "No DIF"))
  legend("topright", legend = paste("Response", seq_len(K)),
         fill = grDevices::hcl.colors(K, "BluYl"), bty = "n", cex = 0.8)
}

plot_compare_trajectories()
plot_response_distribution()
mtext("Observed MAPS data compared with Stan-generated data",
      outer = TRUE, cex = 1.2, font = 2)
par(op)
dev.off()

message("Done.")
message("Generated files:")
message("  ", file.path(out_dir, "longdat_maps_simulated_with_dif.csv"))
message("  ", file.path(out_dir, "longdat_maps_simulated_no_dif.csv"))
message("  ", file.path(out_dir, "simulation_true_dif_parameters.csv"))
message("  ", poster_png)
message("  ", comparison_png)
