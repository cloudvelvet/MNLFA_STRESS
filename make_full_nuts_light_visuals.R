out_dir <- file.path("poster_model_output", "full_nuts_light")
viz_dir <- file.path(out_dir, "visuals")
dir.create(viz_dir, recursive = TRUE, showWarnings = FALSE)

dif <- read.csv(file.path(out_dir, "item_dif_summary.csv"))
latent <- read.csv(file.path(out_dir, "latent_trajectory_summary.csv"))

item_map <- data.frame(
  item = 1:8,
  item_stem = sprintf("p_accul_str_%02d", 1:8),
  item_short = c(
    "different treatment",
    "prejudice",
    "homesickness",
    "unfamiliar environment",
    "missing birthplace/people",
    "anger at disregard",
    "withdrawal",
    "low social status"
  ),
  item_text_ko = c(
    "나는 사회생활에서 한국 사람들과 다른 대우를 받는다",
    "한국 사람들은 내가 외국에서 왔다는 편견을 가지고 있다",
    "나는 고향에 대한 그리움 때문에 힘들다",
    "나는 고향을 떠나 낯선 환경에서 생활하는 게 슬프다",
    "나는 내가 태어난 곳과 사람들이 그립다",
    "나는 외국출신자들을 무시하는 것에 화가 난다",
    "나는 내가 외국에서 왔다는 이유 때문에 위축된다",
    "나는 내가 외국에서 왔기 때문에 사회적 지위가 낮다고 느낀다"
  ),
  stringsAsFactors = FALSE
)

write.csv(item_map, file.path(viz_dir, "item_text_map.csv"), row.names = FALSE)
writeLines(
  c(
    "| Item | Variable | Short label | Korean item wording |",
    "|---:|---|---|---|",
    sprintf(
      "| %d | `%s` | %s | %s |",
      item_map$item, item_map$item_stem, item_map$item_short, item_map$item_text_ko
    )
  ),
  file.path(viz_dir, "item_text_map.md")
)

dif <- merge(dif, item_map, by = "item", all.x = TRUE)
dif$label <- paste0("Item ", dif$item, " (", dif$item_short, ") / ",
                    dif$parameter_type, " / ", dif$predictor)
dif$abs_mean <- abs(dif$mean)

poster_colors <- c(
  loading = "#2D6A8E",
  threshold = "#C84C3A",
  age_c = "#6B7280",
  korean_c = "#2D6A8E",
  income_c = "#3A7D44",
  discrim_any = "#C84C3A"
)

save_png <- function(path, expr, width = 2400, height = 1600, res = 220) {
  png(path, width = width, height = height, res = res)
  on.exit(dev.off(), add = TRUE)
  force(expr)
}

# 1. Top DIF forest plot.
top <- dif[order(dif$abs_mean, decreasing = TRUE), ][1:20, ]
top <- top[rev(seq_len(nrow(top))), ]
save_png(file.path(viz_dir, "fig1_top_dif_forest.png"), {
  par(mar = c(5, 10, 3, 2), family = "sans")
  xlim <- range(c(top$q5, top$q95), na.rm = TRUE)
  plot(
    top$mean, seq_len(nrow(top)),
    xlim = xlim,
    yaxt = "n",
    pch = 19,
    col = poster_colors[top$parameter_type],
    xlab = "Posterior mean with 90% credible interval",
    ylab = "",
    main = "Largest DIF Effects: NUTS Subset"
  )
  abline(v = 0, lty = 2, col = "#555555")
  segments(top$q5, seq_len(nrow(top)), top$q95, seq_len(nrow(top)),
           col = poster_colors[top$parameter_type], lwd = 2.5)
  points(top$mean, seq_len(nrow(top)), pch = 19,
         col = poster_colors[top$parameter_type], cex = 1.2)
  axis(2, at = seq_len(nrow(top)), labels = top$label, las = 2, cex.axis = 0.72)
  legend("bottomright", legend = names(poster_colors[1:2]),
         col = poster_colors[1:2], pch = 19, bty = "n")
})

# 2. Discrimination threshold DIF by item.
disc_thr <- dif[dif$predictor == "discrim_any" & dif$parameter_type == "threshold", ]
disc_thr <- disc_thr[order(disc_thr$item), ]
save_png(file.path(viz_dir, "fig2_discrimination_threshold_dif.png"), {
  par(mar = c(9, 5, 3, 1), family = "sans")
  ylim <- range(c(disc_thr$q5, disc_thr$q95, 0), na.rm = TRUE)
  plot(
    disc_thr$item, disc_thr$mean,
    ylim = ylim,
    type = "b",
    pch = 19,
    lwd = 2.5,
    col = "#C84C3A",
    xaxt = "n",
    xlab = "Item",
    ylab = "Threshold DIF effect",
    main = "Discrimination-Related Response Shift"
  )
  axis(1, at = disc_thr$item,
       labels = paste0("Item ", disc_thr$item, "\n", disc_thr$item_short),
       cex.axis = 0.75)
  abline(h = 0, lty = 2, col = "#555555")
  arrows(disc_thr$item, disc_thr$q5, disc_thr$item, disc_thr$q95,
         angle = 90, code = 3, length = 0.04, col = "#C84C3A", lwd = 1.8)
  text(
    disc_thr$item, disc_thr$mean,
    labels = sprintf("%.2f", disc_thr$mean),
    pos = ifelse(disc_thr$mean < 0, 1, 3),
    cex = 0.8
  )
  mtext("Negative values indicate lower response thresholds: higher endorsement at the same latent level.",
        side = 1, line = 7.4, cex = 0.75, col = "#444444")
})

# 2b. Korean item wording panel for poster side caption/table.
save_png(file.path(viz_dir, "fig2b_item_wording_panel.png"),
         width = 2600, height = 1500, res = 220, {
  par(mar = c(1, 1, 3, 1), family = "sans")
  plot.new()
  title("Acculturative-Stress Item Wording", cex.main = 1.1)
  y <- seq(0.88, 0.08, length.out = nrow(item_map))
  for (i in seq_len(nrow(item_map))) {
    text(0.02, y[i], paste0("Item ", item_map$item[i]), adj = 0,
         cex = 0.9, font = 2, col = "#222222")
    text(0.15, y[i], item_map$item_text_ko[i], adj = 0,
         cex = 0.86, col = "#222222")
    segments(0.02, y[i] - 0.045, 0.98, y[i] - 0.045, col = "#E5E7EB")
  }
})

# 3. Threshold DIF heatmap.
thr <- dif[dif$parameter_type == "threshold", ]
items <- sort(unique(thr$item))
preds <- c("age_c", "korean_c", "income_c", "discrim_any")
mat <- matrix(NA_real_, nrow = length(items), ncol = length(preds),
              dimnames = list(paste0("Item ", items), preds))
sig <- matrix(FALSE, nrow = length(items), ncol = length(preds),
              dimnames = dimnames(mat))
for (i in seq_len(nrow(thr))) {
  mat[paste0("Item ", thr$item[i]), thr$predictor[i]] <- thr$mean[i]
  sig[paste0("Item ", thr$item[i]), thr$predictor[i]] <- thr$credible_nonzero_90[i]
}
save_png(file.path(viz_dir, "fig3_threshold_dif_heatmap.png"), {
  par(mar = c(6, 7, 3, 5), family = "sans")
  zlim <- max(abs(mat), na.rm = TRUE)
  cols <- colorRampPalette(c("#2D6A8E", "white", "#C84C3A"))(101)
  image(
    x = seq_len(ncol(mat)), y = seq_len(nrow(mat)), z = t(mat[nrow(mat):1, ]),
    col = cols, zlim = c(-zlim, zlim), axes = FALSE,
    xlab = "", ylab = "", main = "Threshold DIF Pattern by Item and Covariate"
  )
  axis(1, at = seq_len(ncol(mat)), labels = colnames(mat), las = 2)
  axis(2, at = seq_len(nrow(mat)), labels = rev(rownames(mat)), las = 2)
  for (r in seq_len(nrow(mat))) {
    for (c in seq_len(ncol(mat))) {
      rr <- nrow(mat) - r + 1
      lab <- if (sig[r, c]) sprintf("%.2f*", mat[r, c]) else sprintf("%.2f", mat[r, c])
      text(c, rr, lab, cex = 0.75)
    }
  }
  mtext("* 90% CrI excludes 0", side = 1, line = 4.6, cex = 0.75, col = "#444444")
})

# 4. Latent growth summary.
growth <- latent[latent$variable %in% c("slope_mean", "slope_variance", "occasion_sd"), ]
growth$label <- c(
  slope_mean = "Latent slope mean",
  slope_variance = "Slope variance",
  occasion_sd = "Occasion residual SD"
)[growth$variable]
growth <- growth[rev(seq_len(nrow(growth))), ]
save_png(file.path(viz_dir, "fig4_latent_growth_summary.png"), {
  par(mar = c(5, 8, 3, 2), family = "sans")
  xlim <- range(c(growth$q5, growth$q95, 0), na.rm = TRUE)
  plot(
    growth$mean, seq_len(nrow(growth)),
    xlim = xlim,
    yaxt = "n",
    pch = 19,
    col = "#2D6A8E",
    xlab = "Posterior mean with 90% credible interval",
    ylab = "",
    main = "Recovered Latent Trajectory Parameters"
  )
  abline(v = 0, lty = 2, col = "#555555")
  segments(growth$q5, seq_len(nrow(growth)), growth$q95, seq_len(nrow(growth)),
           col = "#2D6A8E", lwd = 2.5)
  points(growth$mean, seq_len(nrow(growth)), pch = 19, col = "#2D6A8E", cex = 1.2)
  axis(2, at = seq_len(nrow(growth)), labels = growth$label, las = 2)
  text(growth$mean, seq_len(nrow(growth)),
       labels = sprintf("%.3f", growth$mean),
       pos = ifelse(growth$mean < 0, 2, 4), cex = 0.85)
})

write.csv(
  data.frame(
    figure = c(
      "fig1_top_dif_forest.png",
      "fig2_discrimination_threshold_dif.png",
      "fig2b_item_wording_panel.png",
      "fig3_threshold_dif_heatmap.png",
      "fig4_latent_growth_summary.png"
    ),
    purpose = c(
      "Top 20 DIF effects with 90% credible intervals",
      "Discrimination-related threshold DIF by item",
      "Korean wording for the eight acculturative-stress items",
      "Threshold DIF heatmap across covariates and items",
      "Latent growth parameter summary"
    )
  ),
  file.path(viz_dir, "visual_index.csv"),
  row.names = FALSE
)

message("Saved visuals to: ", viz_dir)
