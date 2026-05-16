# Chen & Bauer (2024) Longitudinal MNLFA
# Step 1: Data preparation
# sm2.dat = already processed Add Health data (N=1000 subset)

library(dplyr)
library(tidyr)

# ── Option A: Use provided sm2.dat (N=1000 subset) ──────────────────────────
# sm2.dat structure: ID, BIO_SEX, then item responses in long format
# Column count check
raw <- read.table("F:/ai-code/met0000685_sm/met0000685_sm2.dat")
cat("Dimensions:", dim(raw), "\n")
cat("First few rows:\n")
print(head(raw, 3))

# Based on code: person, wave(1-3), item(1-9), BIO_SEX, resp
# Need to reconstruct from wide → long
# sm2.dat likely already in long format based on the analysis code
# Let's check column count: 9 items × 3 waves = 27 item cols + ID + sex + age cols

# ── Option B: Process from raw Add Health .rda files ─────────────────────────
# Requires downloading from ICPSR study 21600:
#   Wave I:  21600-0001-Data.rda
#   Wave II: 21600-0005-Data.rda
#   Wave III:21600-0008-Data.rda

process_addhealth_raw <- function(data_dir) {
  load(file.path(data_dir, '21600-0001-Data.rda'))
  load(file.path(data_dir, '21600-0005-Data.rda'))
  load(file.path(data_dir, '21600-0008-Data.rda'))

  mergedat <- da21600.0001 %>%
    left_join(da21600.0005, by = 'AID') %>%
    left_join(da21600.0008, by = 'AID')

  mergedat$H1GI1Y  <- as.numeric(gsub("\\([0-9]+\\) +", "", mergedat$H1GI1Y))
  mergedat$IYEAR   <- as.numeric(gsub("\\([0-9]+\\) +", "", mergedat$IYEAR))
  mergedat$IYEAR2  <- as.numeric(gsub("\\([0-9]+\\) +", "", mergedat$IYEAR2))
  mergedat$IYEAR3  <- as.numeric(gsub("\\([0-9]+\\) +", "", mergedat$IYEAR3))
  mergedat$BIO_SEX <- as.numeric(mergedat$BIO_SEX) - 1  # 0=male, 1=female
  mergedat$SMP01   <- as.numeric(gsub("^\\(([0-9]+)\\).+$", "\\1", mergedat$SMP01))
  mergedat$SMP01_2 <- as.numeric(gsub("^\\(([0-9]+)\\).+$", "\\1", mergedat$SMP01_2))

  coredat <- mergedat %>%
    filter_at(vars(SMP01, SMP01_2), any_vars(. == 1)) %>%
    mutate(
      age_1 = IYEAR  - H1GI1Y,
      age_2 = IYEAR2 - H1GI1Y,
      age_3 = IYEAR3 - H1GI1Y
    ) %>%
    filter_at(vars(BIO_SEX), all_vars(!is.na(.))) %>%
    filter(age_1 < 20)

  # 9 delinquency items (binary: 0=never, 1=any)
  coredat_use <- coredat %>%
    select(age_1, age_2, age_3, BIO_SEX,
           H1DS1, H1DS2, H1DS3, H1DS8,  H1DS9,  H1DS10, H1DS12, H1DS13, H1DS15,
           H2DS1, H2DS2, H2DS3, H2DS6,  H2DS7,  H2DS8,  H2DS10, H2DS11, H2DS12,
           H3DS1, H3DS2, H3DS3, H3DS5,  H3DS6) %>%
    filter_at(vars(H1DS1:H3DS6), any_vars(!is.na(.))) %>%
    mutate_at(vars(H1DS1:H3DS6), ~recode(., "(0) (0) Never" = 0, .default = 1))

  coredat_long <- coredat_use %>%
    rename(
      graffiti_1 = H1DS1,  dmgprop_1 = H1DS2, lie_1     = H1DS3,
      car_1      = H1DS8,  stealm_1  = H1DS9, house_1   = H1DS10,
      selldrg_1  = H1DS12, steall_1  = H1DS13, unruly_1 = H1DS15,
      graffiti_2 = H2DS1,  dmgprop_2 = H2DS2, lie_2     = H2DS3,
      car_2      = H2DS6,  stealm_2  = H2DS7, house_2   = H2DS8,
      selldrg_2  = H2DS10, steall_2  = H2DS11, unruly_2 = H2DS12,
                           dmgprop_3 = H3DS1, stealm_3  = H3DS2,
      house_3    = H3DS3,  selldrg_3 = H3DS5, steall_3  = H3DS6
    ) %>%
    mutate(ID = row_number()) %>%
    pivot_longer(!c(BIO_SEX, ID, age_1, age_2, age_3),
                 names_to = c(".value", "wave"), names_sep = "_")

  longdat <- coredat_long %>%
    pivot_longer(graffiti:unruly, names_to = "question", values_to = "resp") %>%
    mutate(
      question = factor(question,
                        levels = c("graffiti","dmgprop","lie","car",
                                   "stealm","house","selldrg","steall","unruly")),
      item = as.numeric(question)
    ) %>%
    na.omit()

  write.csv(longdat, "longdat.csv", row.names = FALSE)
  cat("longdat.csv saved:", nrow(longdat), "rows\n")
  return(longdat)
}

# ── sm2.dat 구조 탐색 ─────────────────────────────────────────────────────────
cat("\n--- sm2.dat structure ---\n")
cat("Rows:", nrow(raw), "\n")
cat("Cols:", ncol(raw), "\n")
cat("Col ranges:\n")
print(sapply(raw, range, na.rm = TRUE))
