# Preprocess MAPS 2nd panel parent data using the user guide variables.
#
# Source folder:
#   MAPS 2기 패널_Data_CSV (1)/학부모(1~6차)
#
# Uses parent waves 1-5 CSV files because the local user guide covers 1-5차.
# Main output:
#   longdat_maps_parent_discrim.csv
#
# Variables:
#   - Ordinal items: p_accul_str_01 ... p_accul_str_08
#   - Korean proficiency: mean(ko_language_c1 ... ko_language_c4)
#   - Income: income_a01, log transformed
#   - Parent age: par_age_1, centered within wave
#   - Discrimination: p_discrim_a01, recoded to 1 = experienced, 0 = no

library(dplyr)
library(tidyr)

source_dir <- file.path("MAPS 2기 패널_Data_CSV (1)", "학부모(1~6차)")
out_csv <- "longdat_maps_parent_discrim.csv"
qc_csv <- "longdat_maps_parent_discrim_qc.csv"

valid_1_5 <- function(x) {
  x <- suppressWarnings(as.numeric(x))
  x[!(x %in% 1:5)] <- NA_real_
  x
}

valid_positive <- function(x) {
  x <- suppressWarnings(as.numeric(x))
  x[x < 0] <- NA_real_
  x
}

valid_nat <- function(x) {
  x <- suppressWarnings(as.integer(x))
  x[!(x %in% 1:8)] <- NA_integer_
  x
}

valid_edu <- function(x) {
  x <- suppressWarnings(as.integer(x))
  x[!(x %in% 1:5)] <- NA_integer_
  x
}

recode_discrim_any <- function(x) {
  x <- suppressWarnings(as.integer(x))
  out <- rep(NA_integer_, length(x))
  out[x == 1] <- 1L
  out[x == 2] <- 0L
  out
}

first_existing <- function(dat, candidates) {
  hit <- candidates[candidates %in% names(dat)]
  if (length(hit) == 0) {
    rep(NA_real_, nrow(dat))
  } else {
    dat[[hit[1]]]
  }
}

read_wave <- function(wave) {
  file <- list.files(
    source_dir,
    pattern = paste0("학부모 ", wave, "차년도[.]csv$"),
    full.names = TRUE
  )
  if (length(file) != 1) {
    stop("Could not find exactly one parent CSV for wave ", wave)
  }

  dat <- read.csv(file, fileEncoding = "CP949", check.names = FALSE)
  suffix <- paste0("_w", wave)

  item_cols <- paste0("p_accul_str_0", 1:8, suffix)
  missing_items <- setdiff(item_cols, names(dat))
  if (length(missing_items) > 0) {
    stop("Missing acculturative stress item columns in wave ", wave, ": ",
         paste(missing_items, collapse = ", "))
  }

  korean_cols <- paste0("ko_language_c", 1:4, suffix)
  korean_available <- korean_cols[korean_cols %in% names(dat)]
  if (length(korean_available) == 0) {
    stop("No ko_language_c* columns found in wave ", wave)
  }

  discrim_col <- paste0("p_discrim_a01", suffix)
  if (!discrim_col %in% names(dat)) {
    stop("Missing discrimination column: ", discrim_col)
  }

  income_col <- paste0("income_a01", suffix)
  if (!income_col %in% names(dat)) {
    stop("Missing income column: ", income_col)
  }

  parent_age <- valid_positive(first_existing(dat, paste0("par_age_1", suffix)))
  parent_age_c <- parent_age - mean(parent_age, na.rm = TRUE)

  wide_base <- dat %>%
    transmute(
      ID = as.integer(ID),
      Wave = wave,
      time = wave,
      time_c = wave - 3,
      parent_age = parent_age,
      parent_age_c = parent_age_c,
      nation = valid_nat(first_existing(dat, paste0("par_nat_1", suffix))),
      education = valid_edu(first_existing(dat, paste0("par_edu_1", suffix))),
      income = valid_positive(.data[[income_col]]),
      log_income = log(pmax(income, 1)),
      korean_score = rowMeans(
        as.data.frame(lapply(dat[korean_available], valid_1_5)),
        na.rm = TRUE
      ),
      discrim_any = recode_discrim_any(.data[[discrim_col]])
    )

  wide <- bind_cols(wide_base, dat[item_cols])
  wide$korean_score[is.nan(wide$korean_score)] <- NA_real_

  wide %>%
    pivot_longer(
      cols = all_of(item_cols),
      names_to = "item_name",
      values_to = "resp"
    ) %>%
    mutate(
      resp = valid_1_5(resp),
      item = as.integer(gsub(paste0("p_accul_str_0|", suffix), "", item_name)),
      item_name = paste0("p_accul_str_0", item)
    )
}

longdat <- bind_rows(lapply(1:5, read_wave)) %>%
  filter(!is.na(resp)) %>%
  mutate(
    person_id = as.integer(factor(ID)),
    age_c = parent_age_c,
    age_sq = age_c^2,
    time_dif_c = time_c,
    nat2 = as.integer(nation == 2),
    nat3 = as.integer(nation == 3),
    nat5 = as.integer(nation == 5),
    nat6 = as.integer(nation == 6),
    nat7 = as.integer(nation == 7),
    nat8 = as.integer(nation == 8),
    korean_c = as.numeric(scale(korean_score)),
    income_c = as.numeric(scale(log_income)),
    discrim_z = as.numeric(scale(discrim_any))
  ) %>%
  arrange(person_id, time, item)

write.csv(longdat, out_csv, row.names = FALSE)

qc <- data.frame(
  metric = c(
    "rows",
    "persons",
    "waves",
    "items",
    "missing_parent_age_rows",
    "missing_age_c_rows",
    "missing_korean_score_rows",
    "missing_log_income_rows",
    "missing_discrim_any_rows",
    "discrim_experienced_person_waves",
    "discrim_not_experienced_person_waves"
  ),
  value = c(
    nrow(longdat),
    length(unique(longdat$person_id)),
    length(unique(longdat$time)),
    length(unique(longdat$item)),
    sum(is.na(longdat$parent_age)),
    sum(is.na(longdat$age_c)),
    sum(is.na(longdat$korean_score)),
    sum(is.na(longdat$log_income)),
    sum(is.na(longdat$discrim_any)),
    sum(longdat$discrim_any == 1, na.rm = TRUE),
    sum(longdat$discrim_any == 0, na.rm = TRUE)
  )
)
write.csv(qc, qc_csv, row.names = FALSE)

cat("Saved:", out_csv, "\n")
cat("Saved:", qc_csv, "\n")
print(qc)
cat("\nResponse distribution:\n")
print(table(longdat$resp, useNA = "ifany"))
cat("\nDiscrimination distribution by wave (person-wave rows, before item expansion shown divided by 8):\n")
print(with(longdat, table(time, discrim_any, useNA = "ifany")) / 8)
