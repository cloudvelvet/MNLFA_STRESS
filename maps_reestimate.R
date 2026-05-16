# MAPS GRM 재추정 (Step 2: DIF 확정 후 비정규화 추정)
# maps_ssp_run.R 실행 후 maps_dif_detected.csv 확인하고
# 아래 Ldf 행렬을 수동으로 업데이트하여 실행

library(rstan)
library(dplyr)

options(mc.cores = 4)
rstan_options(auto_write = TRUE)

# ── 데이터 로드 ───────────────────────────────────────────────────────────────
longdat <- read.csv("F:/ai-code/chen_bauer_2024/longdat_maps.csv")

Nobs   <- nrow(longdat)
P      <- length(unique(longdat$item))
Ni     <- length(unique(longdat$person_id))
D      <- length(unique(longdat$time))
K      <- 5

person <- longdat$person_id
itm    <- longdat$item
time   <- longdat$time
Y      <- longdat$resp

Xtv <- as.matrix(cbind(longdat$age_c, longdat$age_sq))
Xf  <- as.matrix(longdat[, c("nat2","nat3","nat5","nat6","nat7","nat8")])

NFpreds  <- ncol(Xf)   # 6
Ntvpreds <- ncol(Xtv)  # 2

# ── Step 1 결과 기반으로 DIF 패턴 설정 ───────────────────────────────────────
# maps_dif_detected.csv 보고 채워넣기
# 예시: pi_tv1[3]=0.85, pi_tv1[7]=0.91, pi_f[2,1]=0.88 → 해당 셀을 1로
#
# Ldf[i, j]:
#   j=1: age_c DIF       (time-varying)
#   j=2: age_c^2 DIF     (time-varying)
#   j=3~8: nation 2,3,5,6,7,8 DIF (time-invariant)
#
# Step 1 결과 확인 전까지는 0으로 채움 — 실행 후 수정

dif_results <- read.csv("F:/ai-code/chen_bauer_2024/maps_dif_detected.csv")
cat("탐지된 DIF:\n"); print(dif_results)

# !!!  아래 Ldf를 Step 1 결과 보고 수동으로 수정하세요  !!!
Ldf <- matrix(0, nrow = P, ncol = NFpreds + Ntvpreds)
# 예시 (Step 1 결과 기반으로 업데이트):
# Ldf[3, 1] <- 1   # item 3, age_c DIF
# Ldf[7, 1] <- 1   # item 7, age_c DIF
# Ldf[2, 3] <- 1   # item 2, nation3(j=3) DIF

Mtv <- sum(Ldf[, 1:Ntvpreds])
Mf  <- sum(Ldf[, (Ntvpreds+1):(Ntvpreds+NFpreds)])

# DIF 없으면 최소 1로 설정 (Stan 파라미터 벡터 길이 0 방지)
if (Mtv == 0) Mtv <- 1
if (Mf  == 0) Mf  <- 1

fa.data <- list(
  Nobs = Nobs, P = P, Ni = Ni, D = D, K = K,
  person = person, itm = itm, time = time, Y = Y,
  NFpreds = NFpreds, Ntvpreds = Ntvpreds,
  Xf = Xf, Xtv = Xtv, Ldf = Ldf,
  Mtv = Mtv, Mf = Mf,
  sigma_l  = 1.5,
  sigma_nu = 1.5,
  sigma_f  = 1.5,
  sigma_di = 1.0
)

init_cat <- function() {
  list(
    Lp          = runif(P, 1, 1.5),
    cutpoints   = lapply(1:P, function(i) sort(runif(K-1, -2, 2))),
    L_diftv     = runif(Mtv, -0.1, 0.1),
    L_diff      = runif(Mf,  -0.1, 0.1),
    n_diftv     = runif(Mtv, -0.1, 0.1),
    n_diff      = runif(Mf,  -0.1, 0.1),
    b_mu        = matrix(runif(2 * NFpreds, -0.05, 0.05), nrow = 2),
    b_phi       = matrix(runif(2 * NFpreds, -0.05, 0.05), nrow = 2),
    b_phicor    = runif(NFpreds, -0.1, 0.1),
    phicorr     = runif(1, -0.1, 0.1),
    mu_slp      = runif(1, 0, 0.1),
    phi_int     = runif(1, 0.4, 0.6),
    phi_slp     = runif(1, 0.4, 0.6),
    eti_sd2     = runif(1, -0.1, 0.1),
    fac_dist    = matrix(rnorm(2 * Ni, 0, 0.1), nrow = 2),
    fac_eti_raw = matrix(rnorm(D * Ni, 0, 0.1), nrow = D)
  )
}

# ── 컴파일 & 실행 ─────────────────────────────────────────────────────────────
stan_m <- stan_model(
  file    = "F:/ai-code/chen_bauer_2024/grm_final.stan",
  verbose = FALSE
)

stan_f <- sampling(
  stan_m,
  data    = fa.data,
  pars    = c("Lp", "cutpoints",
              "L_diftv", "L_diff", "n_diftv", "n_diff",
              "Ldiftv1", "Ldiftv2", "Ldiff_v",
              "Ndiftv1", "Ndiftv2", "Ndiff_v",
              "mu_eta", "b_mu", "b_phi",
              "phi_var1", "phi_var2", "phi_eta",
              "phicorr", "b_phicor", "fac_gr"),
  chains  = 4,
  warmup  = 1000,
  iter    = 2500,
  init    = init_cat,
  cores   = 4,
  control = list(adapt_delta = 0.88, max_treedepth = 13),
  seed    = 99
)

save.image("F:/ai-code/chen_bauer_2024/maps_final_result.RData")

# ── 결과 요약 ─────────────────────────────────────────────────────────────────
fit_summary <- as.data.frame(
  summary(stan_f,
          pars = c("Lp","mu_eta","b_mu","b_phi","phi_var1","phi_var2",
                   "phi_eta","phicorr","b_phicor"),
          probs = c(0.025, 0.5, 0.975))$summary
)
print(fit_summary)

sampler_params <- get_sampler_params(stan_f, inc_warmup = FALSE)
chain_div <- sapply(sampler_params, function(x) sum(x[, "divergent__"]))
cat("\nDivergences:", chain_div, "\n")
cat("Rhat > 1.1:", sum(fit_summary$Rhat > 1.1, na.rm = TRUE), "\n")

write.csv(fit_summary, "F:/ai-code/chen_bauer_2024/maps_final_summary.csv")
