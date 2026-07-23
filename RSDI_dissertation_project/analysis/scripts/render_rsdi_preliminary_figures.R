# Render publication/poster-friendly figures from RSDI preliminary summaries.

args <- commandArgs(trailingOnly = TRUE)

get_arg <- function(flag, default = NULL) {
  hit <- grep(paste0("^", flag, "="), args, value = TRUE)
  if (length(hit) == 0) {
    return(default)
  }
  sub(paste0("^", flag, "="), "", hit[[length(hit)]])
}

mode <- get_arg("--mode", "full")
rsdi_dir <- file.path("poster_model_output", mode, "rsdi_preliminary")

if (!requireNamespace("data.table", quietly = TRUE)) {
  stop("Package 'data.table' is required. Set R_LIBS_USER to the project Rlib if needed.")
}

library(data.table)

required_files <- file.path(
  rsdi_dir,
  c(
    "rsdi_person_wavepair_item_summary.csv",
    "rsdi_person_wavepair_overall_summary.csv",
    "discrimination_contrast_item_over_waves_summary.csv"
  )
)
missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files) > 0) {
  stop("Missing RSDI summary files: ", paste(missing_files, collapse = ", "))
}

rsdi_item_summary <- fread(required_files[1])
rsdi_overall_summary <- fread(required_files[2])
disc_item_summary <- fread(required_files[3])

item_labels <- function(dt) {
  item_number <- if ("original_item" %in% names(dt)) dt$original_item else dt$item
  paste0("Item ", item_number, ": ", dt$item_short)
}

save_png <- function(path, expr, width = 3200, height = 1800, res = 240) {
  png(path, width = width, height = height, res = res)
  on.exit(dev.off(), add = TRUE)
  force(expr)
}

red <- "#C84C3A"
blue <- "#2D6A8E"
green <- "#3E8F6B"
gray <- "#666666"

full_pair <- rsdi_overall_summary[pair_type == "full_span", pair][1]
if (is.na(full_pair)) {
  full_pair <- rsdi_overall_summary[which.max(wave1 - wave0), pair]
}
full_pair_label <- gsub("_", " ", full_pair)
full_item <- rsdi_item_summary[pair == full_pair]

save_png(file.path(rsdi_dir, "fig_rsdi_fullspan_item_fraction.png"), {
  datp <- full_item[order(rsdi_mean)]
  x_max <- max(datp$rsdi_q95, na.rm = TRUE) * 1.15
  par(mar = c(5, 13, 3, 2), family = "sans")
  plot(
    datp$rsdi_mean, seq_len(nrow(datp)),
    xlim = c(0, x_max),
    yaxt = "n",
    pch = 19,
    col = green,
    xlab = "RSDI: measurement component / component magnitudes",
    ylab = "",
    main = paste0(full_pair_label, " Response Shift Decomposition by Item")
  )
  abline(v = seq(0, x_max, by = 0.05), col = "#EEEEEE")
  segments(datp$rsdi_q5, seq_len(nrow(datp)), datp$rsdi_q95, seq_len(nrow(datp)),
           col = green, lwd = 2.5)
  points(datp$rsdi_mean, seq_len(nrow(datp)), pch = 19, col = green, cex = 1.1)
  axis(2, at = seq_len(nrow(datp)),
       labels = item_labels(datp),
       las = 2, cex.axis = 0.72)
})

save_png(file.path(rsdi_dir, "fig_rsdi_wavepair_component_tv.png"), {
  datp <- rsdi_overall_summary[order(wave0, wave1)]
  mat <- rbind(
    latent = datp$latent_tv_mean,
    measurement = datp$measurement_tv_mean,
    interaction = datp$interaction_tv_mean
  )
  y_max <- max(colSums(mat), na.rm = TRUE) * 1.15
  par(mar = c(6, 5, 3, 1), family = "sans")
  barplot(
    mat,
    beside = FALSE,
    col = c(blue, red, gray),
    names.arg = gsub("_", " ", datp$pair),
    las = 2,
    ylim = c(0, y_max),
    ylab = "Mean total-variation component",
    main = "Posterior-Predicted Response Change Components"
  )
  legend("topright", legend = rownames(mat), fill = c(blue, red, gray), bty = "n")
})

save_png(file.path(rsdi_dir, "fig_discrimination_contrast_expected_score.png"), {
  datp <- disc_item_summary[order(discrim_expected_mean)]
  x_max <- max(datp$discrim_expected_q95, na.rm = TRUE) * 1.08
  par(mar = c(5, 13, 3, 2), family = "sans")
  plot(
    datp$discrim_expected_mean, seq_len(nrow(datp)),
    xlim = c(0, x_max),
    yaxt = "n",
    pch = 19,
    col = red,
    xlab = "Expected response shift: discrimination yes - no",
    ylab = "",
    main = "Discrimination-Related Response Shift by Item"
  )
  abline(v = 0, lty = 2, col = gray)
  abline(v = seq(0, x_max, by = 0.1), col = "#EEEEEE")
  segments(datp$discrim_expected_q5, seq_len(nrow(datp)),
           datp$discrim_expected_q95, seq_len(nrow(datp)),
           col = red, lwd = 2.5)
  points(datp$discrim_expected_mean, seq_len(nrow(datp)), pch = 19, col = red, cex = 1.1)
  axis(2, at = seq_len(nrow(datp)),
       labels = item_labels(datp),
       las = 2, cex.axis = 0.72)
})

message("Rendered RSDI figures to: ", normalizePath(rsdi_dir, winslash = "/", mustWork = FALSE))
