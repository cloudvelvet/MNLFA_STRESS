out_dir <- file.path("poster_model_output", "full_nuts_light")
viz_dir <- file.path(out_dir, "visuals")
dir.create(viz_dir, recursive = TRUE, showWarnings = FALSE)

item_map <- data.frame(
  item = 1:8,
  item_short = c(
    "Different treatment",
    "Perceived prejudice",
    "Homesickness",
    "Unfamiliar environment",
    "Missing birthplace/people",
    "Anger at disregard",
    "Withdrawal",
    "Perceived low social status"
  ),
  stringsAsFactors = FALSE
)

csv_files <- Sys.glob(file.path(out_dir, "maps_mnlfa_poster-202605202034-*-6562a3.csv"))
if (length(csv_files) == 0) {
  stop("No NUTS CSV files found for the completed full_nuts_light run.")
}

read_draws <- function(files) {
  out <- vector("list", length(files))
  for (i in seq_along(files)) {
    message("Reading draws: ", basename(files[i]))
    out[[i]] <- read.csv(files[i], comment.char = "#", check.names = FALSE)
  }
  do.call(rbind, out)
}

clamp <- function(x, lo, hi) pmin(hi, pmax(lo, x))
inv_logit <- function(x) 1 / (1 + exp(-x))

category_prob <- function(cuts, mu) {
  cdf <- inv_logit(cuts - mu)
  c(cdf[1], diff(cdf), 1 - cdf[length(cdf)])
}

summ <- function(x) {
  c(mean = mean(x), q5 = unname(quantile(x, 0.05)), q95 = unname(quantile(x, 0.95)))
}

draws <- read_draws(csv_files)

eta_grid <- seq(-2, 2, by = 0.1)
focus_items <- c(2, 6)

curve_rows <- list()
row_id <- 1
for (item in focus_items) {
  for (eta in eta_grid) {
    for (disc in c(0, 1)) {
      log_lambda <- draws[[paste0("log_loading.", item)]] +
        disc * draws[[paste0("loading_dif.", item, ".4")]]
      lambda <- exp(clamp(log_lambda, -1.5, 1.5))
      mu <- lambda * eta
      shift <- clamp(disc * draws[[paste0("threshold_dif.", item, ".4")]], -3, 3)
      cuts <- cbind(
        draws[[paste0("cutpoint.", item, ".1")]],
        draws[[paste0("cutpoint.", item, ".2")]],
        draws[[paste0("cutpoint.", item, ".3")]],
        draws[[paste0("cutpoint.", item, ".4")]]
      )

      p_high <- numeric(nrow(draws))
      exp_score <- numeric(nrow(draws))
      for (d in seq_len(nrow(draws))) {
        p <- category_prob(cuts[d, ] + shift[d], mu[d])
        p_high[d] <- sum(p[4:5])
        exp_score[d] <- sum(seq_along(p) * p)
      }

      s_high <- summ(p_high)
      s_exp <- summ(exp_score)
      curve_rows[[row_id]] <- data.frame(
        item = item,
        item_short = item_map$item_short[item_map$item == item],
        eta = eta,
        discrim_any = disc,
        p_high_mean = s_high["mean"],
        p_high_q5 = s_high["q5"],
        p_high_q95 = s_high["q95"],
        expected_mean = s_exp["mean"],
        expected_q5 = s_exp["q5"],
        expected_q95 = s_exp["q95"]
      )
      row_id <- row_id + 1
    }
  }
}
curve_summary <- do.call(rbind, curve_rows)
write.csv(curve_summary, file.path(viz_dir, "counterfactual_item2_item6_curves.csv"),
          row.names = FALSE)

# Eta = 0 category probabilities for focal items.
cat_rows <- list()
row_id <- 1
for (item in focus_items) {
  for (disc in c(0, 1)) {
    log_lambda <- draws[[paste0("log_loading.", item)]] +
      disc * draws[[paste0("loading_dif.", item, ".4")]]
    lambda <- exp(clamp(log_lambda, -1.5, 1.5))
    mu <- lambda * 0
    shift <- clamp(disc * draws[[paste0("threshold_dif.", item, ".4")]], -3, 3)
    cuts <- cbind(
      draws[[paste0("cutpoint.", item, ".1")]],
      draws[[paste0("cutpoint.", item, ".2")]],
      draws[[paste0("cutpoint.", item, ".3")]],
      draws[[paste0("cutpoint.", item, ".4")]]
    )
    probs <- matrix(NA_real_, nrow = nrow(draws), ncol = 5)
    for (d in seq_len(nrow(draws))) {
      probs[d, ] <- category_prob(cuts[d, ] + shift[d], mu[d])
    }
    for (k in 1:5) {
      ss <- summ(probs[, k])
      cat_rows[[row_id]] <- data.frame(
        item = item,
        item_short = item_map$item_short[item_map$item == item],
        discrim_any = disc,
        category = k,
        prob_mean = ss["mean"],
        prob_q5 = ss["q5"],
        prob_q95 = ss["q95"]
      )
      row_id <- row_id + 1
    }
  }
}
cat_summary <- do.call(rbind, cat_rows)
write.csv(cat_summary, file.path(viz_dir, "counterfactual_eta0_category_probabilities.csv"),
          row.names = FALSE)

# Item-level gap at eta = 0 across all eight items.
gap_rows <- list()
row_id <- 1
for (item in 1:8) {
  p_high_by_disc <- list()
  exp_by_disc <- list()
  for (disc in c(0, 1)) {
    log_lambda <- draws[[paste0("log_loading.", item)]] +
      disc * draws[[paste0("loading_dif.", item, ".4")]]
    lambda <- exp(clamp(log_lambda, -1.5, 1.5))
    mu <- lambda * 0
    shift <- clamp(disc * draws[[paste0("threshold_dif.", item, ".4")]], -3, 3)
    cuts <- cbind(
      draws[[paste0("cutpoint.", item, ".1")]],
      draws[[paste0("cutpoint.", item, ".2")]],
      draws[[paste0("cutpoint.", item, ".3")]],
      draws[[paste0("cutpoint.", item, ".4")]]
    )
    p_high <- numeric(nrow(draws))
    exp_score <- numeric(nrow(draws))
    for (d in seq_len(nrow(draws))) {
      p <- category_prob(cuts[d, ] + shift[d], mu[d])
      p_high[d] <- sum(p[4:5])
      exp_score[d] <- sum(seq_along(p) * p)
    }
    p_high_by_disc[[as.character(disc)]] <- p_high
    exp_by_disc[[as.character(disc)]] <- exp_score
  }
  gap_high <- p_high_by_disc[["1"]] - p_high_by_disc[["0"]]
  gap_exp <- exp_by_disc[["1"]] - exp_by_disc[["0"]]
  s_high <- summ(gap_high)
  s_exp <- summ(gap_exp)
  gap_rows[[row_id]] <- data.frame(
    item = item,
    item_short = item_map$item_short[item_map$item == item],
    p_high_gap_mean = s_high["mean"],
    p_high_gap_q5 = s_high["q5"],
    p_high_gap_q95 = s_high["q95"],
    expected_gap_mean = s_exp["mean"],
    expected_gap_q5 = s_exp["q5"],
    expected_gap_q95 = s_exp["q95"]
  )
  row_id <- row_id + 1
}
gap_summary <- do.call(rbind, gap_rows)
write.csv(gap_summary, file.path(viz_dir, "counterfactual_eta0_item_gaps.csv"),
          row.names = FALSE)

save_png <- function(path, expr, width = 2600, height = 1600, res = 220) {
  png(path, width = width, height = height, res = res)
  on.exit(dev.off(), add = TRUE)
  force(expr)
}

red <- "#C84C3A"
blue <- "#2D6A8E"
gray <- "#666666"

save_png(file.path(viz_dir, "fig5_counterfactual_high_response_curves.png"), {
  par(mfrow = c(1, 2), mar = c(5, 5, 3, 1), family = "sans")
  for (item in focus_items) {
    dat <- curve_summary[curve_summary$item == item, ]
    plot(
      NA, xlim = range(eta_grid), ylim = c(0, 1),
      xlab = "Latent acculturative stress (eta)",
      ylab = "P(Y >= 4)",
      main = paste0("Item ", item, ": ", item_map$item_short[item_map$item == item])
    )
    abline(h = seq(0, 1, 0.25), col = "#EEEEEE")
    for (disc in c(0, 1)) {
      one <- dat[dat$discrim_any == disc, ]
      col <- if (disc == 1) red else blue
      polygon(
        c(one$eta, rev(one$eta)),
        c(one$p_high_q5, rev(one$p_high_q95)),
        col = adjustcolor(col, alpha.f = 0.18),
        border = NA
      )
      lines(one$eta, one$p_high_mean, col = col, lwd = 3)
    }
    legend(
      "topleft",
      legend = c("No discrimination", "Discrimination"),
      col = c(blue, red),
      lwd = 3,
      bty = "n"
    )
  }
})

save_png(file.path(viz_dir, "fig6_eta0_category_probabilities.png"), {
  par(mfrow = c(1, 2), mar = c(5, 5, 3, 1), family = "sans")
  for (item in focus_items) {
    dat <- cat_summary[cat_summary$item == item, ]
    mat <- tapply(dat$prob_mean, list(dat$category, dat$discrim_any), identity)
    colnames(mat) <- c("No discrimination", "Discrimination")
    bp <- barplot(
      mat,
      beside = FALSE,
      col = c("#D9E8F3", "#AFCFE5", "#7AA6C2", "#E59A8E", "#C84C3A"),
      ylim = c(0, 1),
      ylab = "Predicted category probability at eta = 0",
      main = paste0("Item ", item, ": ", item_map$item_short[item_map$item == item])
    )
    legend("topright", legend = paste("Category", 1:5),
           fill = c("#D9E8F3", "#AFCFE5", "#7AA6C2", "#E59A8E", "#C84C3A"),
           bty = "n", cex = 0.8)
    text(bp, 1.03, colnames(mat), xpd = TRUE, cex = 0.78)
  }
})

save_png(file.path(viz_dir, "fig7_eta0_high_response_gap_by_item.png"), {
  dat <- gap_summary[order(gap_summary$p_high_gap_mean), ]
  par(mar = c(5, 9, 3, 2), family = "sans")
  xlim <- range(c(dat$p_high_gap_q5, dat$p_high_gap_q95, 0), na.rm = TRUE)
  plot(
    dat$p_high_gap_mean, seq_len(nrow(dat)),
    xlim = xlim,
    yaxt = "n",
    pch = 19,
    col = ifelse(dat$p_high_gap_mean >= 0, red, blue),
    xlab = "Difference in P(Y >= 4) at eta = 0: discrimination - no discrimination",
    ylab = "",
    main = "Counterfactual Response Shift by Item"
  )
  abline(v = 0, lty = 2, col = gray)
  segments(dat$p_high_gap_q5, seq_len(nrow(dat)),
           dat$p_high_gap_q95, seq_len(nrow(dat)),
           col = ifelse(dat$p_high_gap_mean >= 0, red, blue), lwd = 2.5)
  points(dat$p_high_gap_mean, seq_len(nrow(dat)),
         pch = 19, col = ifelse(dat$p_high_gap_mean >= 0, red, blue), cex = 1.1)
  axis(2, at = seq_len(nrow(dat)),
       labels = paste0("Item ", dat$item, ": ", dat$item_short), las = 2, cex.axis = 0.75)
})

index_path <- file.path(viz_dir, "visual_index.csv")
if (file.exists(index_path)) {
  visual_index <- read.csv(index_path)
} else {
  visual_index <- data.frame(figure = character(), purpose = character())
}
new_index <- data.frame(
  figure = c(
    "fig5_counterfactual_high_response_curves.png",
    "fig6_eta0_category_probabilities.png",
    "fig7_eta0_high_response_gap_by_item.png"
  ),
  purpose = c(
    "Counterfactual P(Y >= 4) curves for Item 2 and Item 6 under discrimination = 0 vs 1",
    "Predicted response-category probabilities at eta = 0 for Item 2 and Item 6",
    "Item-level gap in high-response probability at eta = 0"
  )
)
visual_index <- rbind(visual_index, new_index)
visual_index <- visual_index[!duplicated(visual_index$figure, fromLast = TRUE), ]
write.csv(visual_index, index_path, row.names = FALSE)

message("Saved counterfactual visuals to: ", viz_dir)
