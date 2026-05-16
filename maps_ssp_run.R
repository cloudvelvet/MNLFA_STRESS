# ══════════════════════════════════════════════════════════════════════════════
# MAPS GRM + SSP 모델 실행
# Step 1: DIF 탐지 (grm_ssp.stan)
# Step 2: 확정 DIF 패턴으로 재추정 (grm_final.stan)
# ══════════════════════════════════════════════════════════════════════════════

library(rstan)
library(dplyr)
library(posterior)

options(mc.cores = 4)

rstan_options(auto_write = TRUE)

# ── 데이터 로드 ───────────────────────────────────────────────────────────────
longdat <- read.csv("F:/ai-code/chen_bauer_2024/longdat_maps.csv")

stopifnot(min(longdat$person_id) == 1)
stopifnot(all(diff(sort(unique(longdat$person_id))) == 1))

Nobs <- nrow(longdat)
P    <- length(unique(longdat$item))       # 8
Ni   <- length(unique(longdat$person_id))  # 2191
D    <- length(unique(longdat$time))       # 5
K    <- 5

person <- longdat$person_id
itm    <- longdat$item
time   <- longdat$time
Y      <- longdat$resp

Xtv <- as.matrix(cbind(longdat$age_c, longdat$age_sq))
Xf  <- as.matrix(longdat[, c("nat2","nat3","nat5","nat6","nat7","nat8")])

NFpreds  <- ncol(Xf)   # 6
Ntvpreds <- ncol(Xtv)  # 2

Ldf <- matrix(1, nrow = P, ncol = NFpreds + Ntvpreds)
Mtv <- sum(Ldf[, 1:Ntvpreds])
Mf  <- sum(Ldf[, (Ntvpreds+1):(Ntvpreds+NFpreds)])

fa.data <- list(
  Nobs = Nobs, P = P, Ni = Ni, D = D, K = K,
  person = person, itm = itm, time = time, Y = Y,
  NFpreds = NFpreds, Ntvpreds = Ntvpreds,
  Xf = Xf, Xtv = Xtv, Ldf = Ldf,
  Mtv = Mtv, Mf = Mf,
  sigma_l  = 2,
  sigma_nu = 2,
  sigma_f  = 1.5,
  sigma_di = 2,
  gamma_a  = 4000,
  gamma_b  = 200
)

# ── init 함수 (full data용) ───────────────────────────────────────────────────
init_cat <- function() {
  list(
    Lp          = runif(P, 1, 1.5),
    cutraw      = lapply(1:P, function(i) sort(runif(K-1, -2, 2))),
    lambda_l_tv = runif(1, 10, 20),
    lambda_n_tv = runif(1, 10, 20),
    lambda_l_f  = runif(1, 10, 20),
    lambda_n_f  = runif(1, 10, 20),
    L_diftv_raw = runif(Mtv,  -0.1, 0.1),
    L_diff_raw  = runif(Mf,   -0.1, 0.1),
    n_diftv_raw = runif(Mtv,  -0.1, 0.1),
    n_diff_raw  = runif(Mf,   -0.1, 0.1),
    pi_tv1      = runif(P, 0.4, 0.6),
    pi_tv2      = runif(P, 0.4, 0.6),
    pi_f        = matrix(runif(P * NFpreds, 0.4, 0.6), nrow = P),
    b_mu        = matrix(runif(2 * NFpreds, -0.05, 0.05), nrow = 2),
    b_phi       = matrix(runif(2 * NFpreds, -0.05, 0.05), nrow = 2),
    b_phicor    = runif(NFpreds, -0.1, 0.1),
    phicorr     = runif(1, -0.1, 0.1),
    mu_slp      = runif(1, 0.4, 0.6),
    phi_int     = runif(1, 0.4, 0.6),
    phi_slp     = runif(1, 0.4, 0.6),
    eti_sd2     = runif(1, -0.1, 0.1),
    fac_dist    = matrix(rnorm(2 * Ni, 0, 0.1), nrow = 2),
    fac_eti_raw = matrix(rnorm(D * Ni, 0, 0.1), nrow = D)
  )
}

# ── subset 데이터 & init (테스트용) ───────────────────────────────────────────
N_subset <- 50  # 200 -> 50으로 확 줄이기

idx <- which(fa.data$person %in% 1:N_subset)
fa.data_sub <- fa.data
fa.data_sub$Nobs    <- length(idx)
fa.data_sub$Ni      <- N_subset
fa.data_sub$person  <- fa.data$person[idx]
fa.data_sub$itm     <- fa.data$itm[idx]
fa.data_sub$time    <- fa.data$time[idx]
fa.data_sub$Y       <- fa.data$Y[idx]
fa.data_sub$Xf      <- fa.data$Xf[idx, ]
fa.data_sub$Xtv     <- fa.data$Xtv[idx, ]

init_cat_sub <- function() {
  list(
    Lp          = runif(P, 1, 1.5),
    cutraw      = lapply(1:P, function(i) sort(runif(K-1, -2, 2))),
    lambda_l_tv = runif(1, 10, 20),
    lambda_n_tv = runif(1, 10, 20),
    lambda_l_f  = runif(1, 10, 20),
    lambda_n_f  = runif(1, 10, 20),
    L_diftv_raw = runif(Mtv,  -0.1, 0.1),
    L_diff_raw  = runif(Mf,   -0.1, 0.1),
    n_diftv_raw = runif(Mtv,  -0.1, 0.1),
    n_diff_raw  = runif(Mf,   -0.1, 0.1),
    pi_tv1      = runif(P, 0.4, 0.6),
    pi_tv2      = runif(P, 0.4, 0.6),
    pi_f        = matrix(runif(P * NFpreds, 0.4, 0.6), nrow = P),
    b_mu        = matrix(runif(2 * NFpreds, -0.05, 0.05), nrow = 2),
    b_phi       = matrix(runif(2 * NFpreds, -0.05, 0.05), nrow = 2),
    b_phicor    = runif(NFpreds, -0.1, 0.1),
    phicorr     = runif(1, -0.1, 0.1),
    mu_slp      = runif(1, 0.4, 0.6),
    phi_int     = runif(1, 0.4, 0.6),
    phi_slp     = runif(1, 0.4, 0.6),
    eti_sd2     = runif(1, -0.1, 0.1),
    fac_dist    = matrix(rnorm(2 * N_subset, 0, 0.1), nrow = 2),
    fac_eti_raw = matrix(rnorm(D * N_subset, 0, 0.1), nrow = D)
  )
}

# ══════════════════════════════════════════════════════════════════════════════
# STEP 1: SSP DIF 탐지 (grm_ssp.stan)
# ══════════════════════════════════════════════════════════════════════════════
ssp_lines <- readLines("F:/ai-code/chen_bauer_2024/grm_ssp.stan")
length(ssp_lines)
cat(tail(ssp_lines, 30), sep = "\n")
fix_idx <- which(grepl("phi_var2 = quad_form_diag", ssp_lines))
ssp_lines[fix_idx] <- "  phi_var2 = quad_form_diag(phi_mat2, phi_eta .* exp(b_phi[, 1]));"
writeLines(ssp_lines, "F:/ai-code/chen_bauer_2024/grm_ssp.stan")

# 확인
cat(ssp_lines[fix_idx], "\n")
stan_m_ssp <- stan_model(
  file    = "F:/ai-code/chen_bauer_2024/grm_ssp.stan",
  verbose = FALSE
)

cat("Step 1 Stan 모델 컴파일 중...\n")
stan_m_ssp <- stan_model(
  file    = "F:/ai-code/chen_bauer_2024/grm_ssp.stan",
  verbose = FALSE
)

# ── 테스트 실행 ───────────────────────────────────────────────────────────────
cat("Step 1 테스트 실행 (N=200, chain=1)...\n")
stan_test_ssp <- sampling(
  stan_m_ssp,
  data   = fa.data_sub,
  chains = 1,
  iter   = 500,
  warmup = 250,
  init   = init_cat_sub,
  cores  = 1,
  control = list(adapt_delta = 0.90, max_treedepth = 13),
  seed   = 42
)
stan_test_ssp <- sampling(
  stan_m_ssp,
  data    = fa.data_sub,
  chains  = 1,
  iter    = 100,   # 500 -> 100
  warmup  = 50,    # 250 -> 50
  init    = init_cat_sub,
  cores   = 1,
  control = list(adapt_delta = 0.90, max_treedepth = 13),
  seed    = 42
)
# 테스트 통과 후 본 실행
cat("Step 1 본 실행 (N=2191, chain=4)...\n")
stan_f_ssp <- sampling(
  stan_m_ssp,
  data    = fa.data,
  pars    = c("Lp", "pi_tv1", "pi_tv2", "pi_f",
              "Ldiftv1", "Ldiftv2", "Ldiff_v",
              "Ndiftv1", "Ndiftv2", "Ndiff_v",
              "mu_eta", "b_mu", "b_phi",
              "phi_var1", "phi_var2", "phi_eta",
              "phicorr", "b_phicor"),
  chains  = 4,
  iter    = 3000,
  warmup  = 1500,
  init    = init_cat,
  cores   = 4,
  control = list(adapt_delta = 0.90, max_treedepth = 13),
  seed    = 42
)

save(stan_f_ssp, file = "F:/ai-code/chen_bauer_2024/maps_ssp_result.RData")

# ── Step 1 수렴 진단 & DIF 탐지 ───────────────────────────────────────────────
fit_summary_ssp <- as.data.frame(
  summary(stan_f_ssp,
          pars  = c("Lp", "pi_tv1", "pi_tv2", "pi_f", "mu_eta", "b_mu", "phi_eta"),
          probs = c(0.025, 0.5, 0.975))$summary
)

sampler_params <- get_sampler_params(stan_f_ssp, inc_warmup = FALSE)
chain_div      <- sapply(sampler_params, function(x) sum(x[, "divergent__"]))
cat("\nDivergences:", chain_div, "\n")
cat("Rhat > 1.1:", sum(fit_summary_ssp$Rhat > 1.1, na.rm = TRUE), "\n")

stan_draws <- as_draws_df(stan_f_ssp)
dif_detected <- summarise_draws(
  subset_draws(stan_draws, variable = c("^pi_tv", "^pi_f"), regex = TRUE)
) %>% filter(mean > 0.8)

cat("\n--- 탐지된 DIF (inclusion prob > 0.8) ---\n")
print(dif_detected, n = 50)
write.csv(dif_detected, "F:/ai-code/chen_bauer_2024/maps_dif_detected.csv",
          row.names = FALSE)

# ══════════════════════════════════════════════════════════════════════════════
# STEP 2: 확정 DIF 패턴으로 재추정 (grm_final.stan)
# ══════════════════════════════════════════════════════════════════════════════

# ── grm_final.stan 버그 수정 (최초 1회만 실행) ────────────────────────────────
model_lines <- readLines("F:/ai-code/chen_bauer_2024/grm_final.stan")
# generated quantities의 phi_var2 크기 불일치 수정
model_lines[203] <- "  phi_var2 = quad_form_diag(phi_mat2, phi_eta .* exp(b_phi[, 1]));"
writeLines(model_lines, "F:/ai-code/chen_bauer_2024/grm_final.stan")

cat("Step 2 Stan 모델 컴파일 중...\n")
stan_m_final <- stan_model(
  file    = "F:/ai-code/chen_bauer_2024/grm_final.stan",
  verbose = FALSE
)

# ── 테스트 실행 ───────────────────────────────────────────────────────────────
# grm_final.stan의 실제 파라미터 확인
cat("사용 가능한 파라미터:\n")
print(stan_m_final@model_pars)

cat("Step 2 테스트 실행 (N=200, chain=1)...\n")
stan_test_final <- sampling(
  stan_m_final,
  data    = fa.data_sub,
  pars    = c("Lp",
              "Ldiftv1", "Ldiftv2",
              "Ndiftv1", "Ndiftv2",
              "mu_eta", "b_mu", "b_phi",
              "phi_var1", "phi_var2", "phi_eta",
              "phicorr", "b_phicor"),
  chains  = 1,
  iter    = 500,
  warmup  = 250,
  init    = init_cat_sub,
  cores   = 1,
  control = list(adapt_delta = 0.90, max_treedepth = 13),
  seed    = 42
)

# ── 본 실행 ───────────────────────────────────────────────────────────────────
cat("Step 2 본 실행 (N=2191, chain=4)...\n")
stan_f_final <- sampling(
  stan_m_final,
  data    = fa.data,
  pars    = c("Lp",
              "Ldiftv1", "Ldiftv2",
              "Ndiftv1", "Ndiftv2",
              "mu_eta", "b_mu", "b_phi",
              "phi_var1", "phi_var2", "phi_eta",
              "phicorr", "b_phicor"),
  chains  = 4,
  iter    = 3000,
  warmup  = 1500,
  init    = init_cat,
  cores   = 4,
  control = list(adapt_delta = 0.90, max_treedepth = 13),
  seed    = 42
)

save(stan_f_final, file = "F:/ai-code/chen_bauer_2024/maps_final_result.RData")

# ── Step 2 수렴 진단 ──────────────────────────────────────────────────────────
fit_summary_final <- as.data.frame(
  summary(stan_f_final,
          pars  = c("Lp", "mu_eta", "b_mu", "phi_eta"),
          probs = c(0.025, 0.5, 0.975))$summary
)

sampler_params2 <- get_sampler_params(stan_f_final, inc_warmup = FALSE)
chain_div2      <- sapply(sampler_params2, function(x) sum(x[, "divergent__"]))
cat("\nDivergences:", chain_div2, "\n")
cat("Rhat > 1.1:", sum(fit_summary_final$Rhat > 1.1, na.rm = TRUE), "\n")