# MAPS 데이터 전처리 → longdat_maps.csv 생성
# Chen & Bauer (2024) GRM 확장 버전용

library(dplyr)
library(tidyr)

raw <- read.csv("F:/ai-code/MAPS_MNLFA_Final_Data.csv")

cat("원본 데이터:", nrow(raw), "행,", ncol(raw), "열\n")
cat("고유 ID:", length(unique(raw$ID)), "명\n")
cat("Wave 분포:\n"); print(table(raw$Wave))
cat("Nation 분포:\n"); print(table(raw$nation))

# ── 1. 아이템 long format 변환 ─────────────────────────────────────────────
item_cols <- paste0("p_accul_str_0", 1:8)

longdat <- raw %>%
  select(ID, Wave, age_c, nation, education, korean_score, log_income,
         all_of(item_cols)) %>%
  pivot_longer(
    cols      = all_of(item_cols),
    names_to  = "item_name",
    values_to = "resp"
  ) %>%
  mutate(
    item = as.integer(gsub("p_accul_str_0", "", item_name)),
    # 응답 범위 확인: 1~5 (ordered_logistic은 1~K 정수 필요)
    resp = as.integer(resp)
  ) %>%
  filter(!is.na(resp)) %>%
  # person index 재생성 (연속 정수로)
  mutate(
    person_id = as.integer(factor(ID)),
    time      = as.integer(Wave)
  ) %>%
  arrange(person_id, time, item)

cat("\nLong format:", nrow(longdat), "행\n")
cat("응답 분포:\n"); print(table(longdat$resp))

# ── 2. Nation 더미 변수 생성 (reference = nation 4, 가장 많음) ───────────────
# 7개국 → 6개 더미 (nation 2,3,5,6,7,8 vs. 4)
longdat <- longdat %>%
  mutate(
    nat2 = as.integer(nation == 2),
    nat3 = as.integer(nation == 3),
    nat5 = as.integer(nation == 5),
    nat6 = as.integer(nation == 6),
    nat7 = as.integer(nation == 7),
    nat8 = as.integer(nation == 8)
  )

# ── 3. age_c 파생 변수 ───────────────────────────────────────────────────────
longdat <- longdat %>%
  mutate(
    age_sq = age_c^2  # 비선형 시간 효과용
  )

# ── 4. 저장 ──────────────────────────────────────────────────────────────────
write.csv(longdat, "F:/ai-code/chen_bauer_2024/longdat_maps.csv", row.names = FALSE)
cat("\nlongdat_maps.csv 저장 완료\n")
cat("컬럼:", paste(names(longdat), collapse = ", "), "\n")

# ── 5. Stan용 데이터 구조 미리보기 ───────────────────────────────────────────
cat("\n--- Stan 데이터 구조 ---\n")
cat("Nobs:", nrow(longdat), "\n")
cat("P (items):", length(unique(longdat$item)), "\n")
cat("Ni (persons):", length(unique(longdat$person_id)), "\n")
cat("D (waves):", length(unique(longdat$time)), "\n")
cat("K (response categories): 5\n")
cat("Km1 (cutpoints per item): 4\n")
cat("NFpreds (time-invariant: 6 nation dummies): 6\n")
cat("Ntvpreds (time-varying: age_c, age_c^2): 2\n")
