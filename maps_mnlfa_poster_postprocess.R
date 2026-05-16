mode <- if (length(commandArgs(trailingOnly = TRUE)) >= 1) {
  commandArgs(trailingOnly = TRUE)[1]
} else {
  "full"
}

out_dir <- file.path("poster_model_output", mode)
fit_path <- file.path(out_dir, "maps_mnlfa_poster_fit.rds")

if (!requireNamespace("cmdstanr", quietly = TRUE)) {
  stop("Package 'cmdstanr' is required.")
}
library(cmdstanr)

fit <- readRDS(fit_path)
summary_all <- fit$summary()
write.csv(summary_all, file.path(out_dir, "poster_model_summary_all.csv"),
          row.names = FALSE)

predictor_names <- read.csv(file.path(out_dir, "predictor_index.csv"))$predictor
P <- 8

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
  for (item in seq_len(P)) {
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

message("Postprocessed: ", out_dir)
